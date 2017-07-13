# Build With Nginx
The Dockerfile and docker-compose.yml files in this directory expand upon the parent files by incorporating
nginx. Nginx is more efficient at serving static files than Node/Express/KeystoneJS, and it is easier to
configure for various optimizations like browser caching and compression. It's also needed to incorporate
an SSL certificate.

Here is an illustration of the containerization scheme used. The Compose file spins up MongoDB and Nginx in their
own containers. The ConnextCMS container links to both of them.

![nginx docker diagram](images/container-diagram.jpg?raw=true "nginx docker diagram")

## Installation
It's assumed that you are starting with a fresh installation of Ubuntu 16.04 LTS on a 64-bit machine. 
It's also assumed that you are installing as a [non-root user with sudo privileges](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04). 

1. Install Docker on the host system. [This tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)
shows how to install Docker on a Ubuntu 16.04 system. It's specifically targeted to Digital Ocean's cloud servers, but
should work for any Ubuntnu system.
Use [this link](https://m.do.co/c/8f47a23b91ce) to sign up for a Digital Ocean account and get a $10 credit, capable of
running a $5 server for two months.

2. Install Docker Compose too. [This tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04)
shows how to do so on a Ubuntu system.

3. Clone this repository in your home directory with the following command:
`git clone https://github.com/skagitpublishing/docker-connextcms`

4. (Optional) Add any [plugins](http://connextcms.com/page/plugins) or your own customized [plugin-template](https://github.com/skagitpublishing/plugin-template-connextcms) 
to the `plugins` directory. Or add your own
customized [site-template](https://github.com/skagitpublishing/site-template-connextcms) 
to the `theme` directory. Be sure to edit the `mergeandlaunch` script to execute each merge
script required to merge your plugins and site files into [ConnextCMS Core](https://github.com/skagitpublishing/connextCMS) 
at load time.

5. Bring ConnextCMS/KeystoneJS online by running the following command:
`docker-compose up -d`

Docker will build the ConnextCMS Docker image and launch it. At the end, KeystoneJS will be running on port 80, with ConnextCMS running with it.

