# Some info regarding running OTOBO under Docker.

For running OTOBO under HTTP altogether five containers are started.
For HTTPS an additional container running nginx is started.
These containers are managed via Docker compose.
The setup is controlled via the file .env.

## Containers

### Container otobo_web_1

OTOBO webserver on port 5000.

### Container otobo_cron_1

Cron and the OTOBO Daemon.

### Container otobo_db_1

Run the relational database MariaDB on port 3306.

### Container otobo_elastic_1

Run Elastic Search on the ports 9200 and 9300.

### Container otobo_redis_1

Run Redis as the caching service.

### Container otobo_nginx_1

Run nginx as a reverse proxy for providing HTTPS support.

## Volumes

Some volumes are created on the host. These allow starting and stopping the services without loosing data.

* **otobo_opt_otobo** containing `/opt/otobo` on the container `web` and `cron`.
* **otobo_mariadb_data** containing `/var/lib/mysql` on the container `db`.
* **otobo_elasticsearch_data** containing `/usr/share/elasticsearch/datal` on the container `elastic`.
* **otobo_redis_data** containing data on the container `redis`.
* **otobo_nginx_ssl** contains the TLS files, certificate and private key, must be initialzed manually

## Source files

The relevant files for running OTOBO with Docker are:

* `.docker_compose_env_http`
* `.docker_compose_env_https`
* `.docker_compose_env_http_port_5000`
* `scripts/docker-compose/otobo-base.yml`
* `scripts/docker-compose/otobo-override-http.yml`
* `scripts/docker-compose/otobp-override-https.yml`
* `otobo.web.dockerfile`
* `otobo.nginx.dockerfile`
* The scripts in `bin/docker`
* More setup and config files in `scripts/docker`

The file .env is also relavant. This is the file that needs to be created by the user.

## Requirements

The minimal versions that have been tested are listed here. Older versions might work as well.

* Docker 19.03.08
* Docker compose 1.25.0

## Setting up the the environment for Docker Compose

Choose one of

* .docker_compose_env_http
* .docker_compose_env_https
* .docker_compose_env_http_port_5000

and merge it with an maybe already existing file .env.

### .docker_compose_env_http

Run HTTP on port 80 or on the port specified in $OTOBO_WEB_HTTP_PORT.

### .docker_compose_env_https

Run HTTPS on port 443 or on the port specified in $OTOBO_WEB_HTTPS_PORT.

### .docker_compose_env_http_port_5000

Same as .docker_compose_env_http but $OTOBO_WEB_HTTP_PORT is already set to 5000

### OTOBO_DB_ROOT_PASSWORD

The root password for MySQL. Must be set for running otobo db.

### OTOBO_WEB_ROOT_HTTP_PORT

Set in case the HTTP port should deviate from the standard port 80.

### OTOBO_WEB_ROOT_HTTPS_PORT

Set in case the HTTPS port should deviate from the standard port 443.

### COMPOSE_PROJECT_NAME

The project name is used as a prefix for the generated volumes and containers.
Must be set because the compose file is located in scripts/docker-compose and thus docker-compose
would be used per default.

### COMPOSE_PATH_SEPARATOR

Seperator for the value of COMPOSE_FILE

### COMPOSE_FILE

Use scripts/docker-compose/otobo-base.yml as the base and add the wanted extension files.
E.g scripts/docker-compose/otobo-override-http.yml or scripts/docker-compose/otobo-override-https.yml.

## Set up TLS

This step is only needed for HTTPS support.

### Create a self-signed TLS certificate and private key

Nginx need for TLS a certificate and a private key.
For testing and development a self-signed certificate can be used. In the general case
registered certificates must be used.

`sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout otobo_nginx-selfsigned.key -out otobo_nginx-selfsigned.crt`

### Store the certificate in a volume

The certificate and the private key are stored in a volume, so that they can be used by nginx later on.

`docker volume create otobo_nginx_ssl`
`sudo cp otobo_nginx-selfsigned.key otobo_nginx-selfsigned.crt $(docker volume inspect --format '{{ .Mountpoint }}' otobo_nginx_ssl)`

In the general case the companys certificate and private key can be copied into the volume.
The names of the copied files can be set via environment options when starting the container.
For this make sure that files are declared in your .env file. E.g.
`OTOBO_NGINX_SSL_CERTIFICATE=/etc/nginx/ssl/acme.crt`
`OTOBO_NGINX_SSL_CERTIFICATE_KEY=/etc/nginx/ssl/acme.key`

## Building the docker image for otobo web and otobo nginx

This step not needed when the images from http://hub.docker.com are used.

Only the image for otobo web and otobo nginx need to be built. The image otobe web is also used for otobo cron.
For the other service the images are pulled http://hub.docker.com.

* cd into the toplevel OTOBO source dir, which contains the subdir scripts.
* Double check your .env file.
* run `docker-compose build`

## Starting the containers

The docker images are pulled from https://hub.docker.com unless they are already available locally.

TODO: actually provide the images on https://hub.docker.com.

* If HTTP should not run on port 80 then also set OTOBO_WEB_HTTP_PORT in the .env file.
* If HTTPS should not run on port 443 then also set OTOBO_WEB_HTTPS_PORT in the .env file.
* run `docker-compose up`
* open http://localhost/hello as a sanity check

## For the curious: inspect the running containers

* `docker-compose ps`
* `docker volume ls`

## Install OTOBO

Install OTOBO by opening http://localhost/otobo/installer.pl.

## Stopping the running containers

* `docker-compose down`

## An example workflow for restarting with a new installation

Note that all previous data will be lost.

* `sudo service docker restart`    # workaround when sometimes the cached images are not available
* `docker-compose down -v`         # volumes are also removed
* `docker-compose up --build`      # rebuild when the Dockerfile or the code has changed
* Check sanity at [hello](http://localhost:5000/hello)
* Run the installer at [installer.pl](http://localhost:5000/otobo/installer.pl)
    * Keep the default 'db' for the database host
    * Keep logging to the file /opt/otobo/var/log/otobo.log

## Running with a seperate nginx as a reverse proxy for supporting HTTPS

This is basically an example for running OTOBO behind an external reverse proxy.

### Build the nginx image

The image contains nginx and openssl along with an adapted config. But there is no sensible editor.
The config for nginx is located in /etc/nginx.

`docker build --tag otobo_nginx --file otobo.nginx.dockerfile .`

### Create a self-signed TLS certificate and private key

See above.

### Store the certificate in a volume

See above.

### Run the container separate from otobo web

This is only an example. In the general case where there is an already existing reverse proxy.

Start the HTTP webserver on port 5000. Make sure that port 5000 is set in .env.
`docker-compose up`

Nginx running in a separate container should forward to port 80 of the host.
This should work because the otobo web container exposes port 80.
However the container does know the IP of the docker host. Therefore the host must tell the container
the relevant IP.

See https://nickjanetakis.com/blog/docker-tip-65-get-your-docker-hosts-ip-address-from-in-a-container

On the host find the IP of host in the network of the nginx container. E.g. 172.17.0.1.
Run `ip a` and find the ip in the docker0 network adapter.
Or `ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+'`

`docker run -e OTOBO_NGINX_WEB_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') --volume=otobo_nginx_ssl:/etc/nginx/ssl --publish 443:443 --publish 80:80 --name otobo_nginx_1 otobo_nginx`

In some cases the default OTOBO_NGINX_WEB_HOST, as defined in scripts/docker/nginx.Docker, suffices:

`docker run --volume=otobo_nginx_ssl:/etc/nginx/ssl --publish 443:443 --publish 80:80 --name otobo_nginx_1 otobo_nginx`

## Useful Docker commands

* start over:             `docker system prune -a`
* show version:           `docker version`
* build an image:         `docker build --tag otobo-web --file=otobo.web.Dockerfile .`
* run the new image:      `docker run --publish 80:5000 otobo-web`
* log into the new image: `docker run  -v opt_otobo:/opt/otobo -it otobo-web bash`
* show running images:    `docker ps`
* show available images:  `docker images`
* list volumes :          `docker volume ls`
* inspect a volumne:      `docker volume inspect otobo_opt_otobo`
* get volumne mountpoint: `docker volume inspect --format '{{ .Mountpoint }}' otobo_nginx_ssl`
* inspect a container:    `docker inspect <container>`

## Useful Docker compose commands

* check config:           `docker-compose config`
* check containers:       `docker-compose ps`

## Resources

* [Perl Maven](https://perlmaven.com/getting-started-with-perl-on-docker)
* [Docker Compose quick start](http://mfg.fhstp.ac.at/development/webdevelopment/docker-compose-ein-quick-start-guide/)
* [docker-otrs](https://github.com/juanluisbaptiste/docker-otrs/)
* [not403](http://not403.blogspot.com/search/label/otrs)
* [cleanup](https://forums.docker.com/t/command-to-remove-all-unused-images)
* [Dockerfile best practices](https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices/)
* [Docker cache invalidation](https://stackoverflow.com/questions/34814669/when-does-docker-image-cache-invalidation-occur)
* [Docker Host IP](https://nickjanetakis.com/blog/docker-tip-65-get-your-docker-hosts-ip-address-from-in-a-container)
* [Environment](https://vsupalov.com/docker-arg-env-variable-guide/)
* [Self signed certificate](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-18-04)
