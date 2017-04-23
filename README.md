# docker-connextcms
A Dockerfile used to createa Docker Image for running ConnextCMS and KeystoneJS in a Docker Container

## Notes
* Unlike all other KeystoneJS Docker images I found, MongoDB runs inside the same container as KeystoneJS,
since I want a dedicated DB for KeystoneJS. I don't necessarily want to share my DB with other apps, so
it doesn't make sense to run the DB in a separate container.

