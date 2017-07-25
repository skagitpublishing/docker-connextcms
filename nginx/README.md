# Nginx
This readme contains instructions for setting up Nginx to serve static files and proxy to ConnextCMS. Nginx is more 
efficient at serving static files than Node/Express/KeystoneJS, and it is easier to
configure for various optimizations like browser caching and compression. It's also needed to incorporate
an SSL certificate. This readme also contains instructions for registering your domain with Let's Encrypt to 
obtain an SSL certificate.

This configuration opts to run nginx on the host system, as opposed to running it in a separate Docker container.
This makes it easier to preserve encryption keys, and auto-renew the SSL certificate. Multiple installations of
ConnextCMS can be run on the same machine. A single installation of nginx is easier to configure for proxying
traffic to multiple applications.

Here is an illustration of the containerization scheme used. The Compose file spins up MongoDB and ConnextCMS in their
own containers. Nginx executes in the host system and redirects traffic from port 80 to port 3000, which is the
port connected to the ConnextCMS container. Nginx also handles encryption of https traffic.

![nginx docker diagram](images/container-diagram.jpg?raw=true "nginx docker diagram")


# Setup Nginx with Let's Encrypte SSL
It's assumed that you are starting with a fresh installation of Ubuntu 16.04 LTS on a 64-bit machine. 
It's also assumed that you are installing as a [non-root user with sudo privileges](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04). 

1. Set up your site as a regular ConnextCMS installation. You should also have a registered domain names and functional
DNS configuration so that the domain resolves to your ConnextCMS installation on port 80.

2. Install Nginx:
```
sudo apt-get update
sudo apt-get install nginx
```

3. Install the Let's Encrypte Certbot:
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx 
```

4. Obtain a certificate for your domain. Examples below will use **example.com** as the domain.

`sudo certbot certonly --webroot -w /var/www/html/ -d example.com -d www.example.com`

5. Generate a strong DH group:

`sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048`

This will create a file at `/etc/ssl/certs/dhparam.pem`

6. Create the file `sudo nano /etc/nginx/snippets/ssl-example.com.conf` and add these lines to the file:
```
ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
```

7. Create the file `sudo nano /etc/nginx/snippets/ssl-params.conf` and add these lines to the file:
```
# from https://cipherli.st/
# and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
ssl_ecdh_curve secp384r1;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
#add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
		
ssl_dhparam /etc/ssl/certs/dhparam.pem;
```

8. Backup the current nginx file:

`sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak`

9. Remove the nginx default file and create a new one with nano:

`sudo rm default`

`sudo nano default`

10. Paste the following into it. Replace **example.com** with your domain and change the `root` directive to 
point to your cloned copy of this repository:
```
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  listen 443 ssl http2 default_server;
  listen [::]:443 ssl http2 default_server;

  #Edit as appropriate to point to the public file directory.
  #root /var/www/html;
  #root /home/trout/myCMS/public;
  #index index.nginx-debian.html;
  root /home/trout/docker-connextcms/public

  server_name example.com www.example.com;
  include snippets/ssl-newserver.example.com.conf;
  include snippets/ssl-params.conf;

  client_max_body_size 50M; #allow file uploads up to 50 MB

  #Turn on gzip compression
  gzip on;
  gzip_disable "msie6";
  gzip_comp_level 6;
  gzip_min_length 1100;
  gzip_buffers 16 8k;
  gzip_proxied any;
  gzip_types
      text/plain
      text/css
      text/js
      text/xml
      text/javascript
      application/javascript
      application/x-javascript
      application/json
      application/xml
      application/rss+xml
      image/svg+xml;

  
  #This block prevents browser caching of anything in the /keystone URI.
  #Browser caching will brake the ability to log into KeystoneJS.
  location ^~ /keystone {   
    try_files $uri @backend2;
  }
  location @backend2 {
    proxy_pass http://127.0.0.1:3000;
    access_log off;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_set_header X-Frame-Options SAMEORIGIN;

  }
  
  #This block turns on browser caching of static assets and proxys
  #the connection to the node applicatioin running on port 3000.
  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    #proxy_pass http://127.0.0.1:3000;
    #try_files $uri $uri/ =404;

    #http://ksloan.net/configuring-nginx-for-node-js-web-apps-that-serve-both-static-and-dynamic-content/
    try_files $uri @backend1;    
  }
  location @backend1 {
    proxy_pass http://127.0.0.1:3000;
    access_log off;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_set_header X-Frame-Options SAMEORIGIN;

  }

  #Browser caching
  location ~*  \.(jpg|jpeg|png|gif|ico|css|js|otf|ttf|woff2)$ {
    expires 7d;
  }
  location ~*  \.(pdf)$ {
    expires 7d;
  }

}

```

11. Check that there are no syntax errors in the config file:

`sudo nginx -t`

12. Restart nginx:

`sudo systemctl restart nginx`

