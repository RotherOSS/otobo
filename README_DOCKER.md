# Some info regarding running OTOBO under Docker.

The standard use case ist that altogether five containers are started.
These containers are managed via Docker compose.

## Containers

### Container otobo_web_1

OTOBO webserver on port 5000.

### Container otobo_cron_1

Cron and the OTOBO Daemon.

### Container otobo_web_1

Run the relational database MariaDB on port 3306.

### Container otobo_elastic_1

Run Elastic Search on the ports 9200 and 9300.

### Container otobo_redis_1

Run Redis as the caching service.

## Volumes

Some volumes are created on the host. These allow starting and stopping the services without loosing data.

* **otobo_opt_otobo** containing `/opt/otobo` on the container `web` and `cron`.
* **otobo_mariadb_data** containing `/var/lib/mysql` on the container `db`.
* **otobo_elasticsearch_data** containing `/usr/share/elasticsearch/datal` on the container `elastic`.
* **otobo_redis_data** containing data on the container `redis`.

## Source files

The relevant files for running OTOBO with Docker are:

* `docker-compose.yml`
* `docker-compose_https.yml`
* `scripts/docker/web.Dockerfile`
* `scripts/docker/nginx.Dockerfile`
* The scripts in `bin/docker`
* More setup and config files in `scripts/docker`

Note that the files `docker-compose.yml` and `docker-compose_https.yml` will be moved to `scripts\docker`.

## Requirements

The minimal versions that have been tested are listed here. Older versions might work as well.

* Docker 19.03.08
* Docker compose 1.25.0

## Building the docker image for otobo web

Only the image for the webserver needs to be built. This image is also used for otobo cron.
For the other service the image from http://hub.docker.com is used.

* cd into the toplevel OTOBO source dir, which contains docker-compose.yml
* run `docker-compose build`

## Starting the containers

* Make sure that the secret MySQL root password is set up in the file .env. Per default the not so secret 'otobo_root' is used.
* If HTTP should not run on port 80 then set OTOBO_WEB_PORT in the .env file.
* run `docker-compose up`

## Inspect the running containers

* `docker-compose ps`

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

## Running with nginx as a reverse proxy for supporting HTTPS

### Build the nginx image

The image contains nginx and openssl along with an adapted config. But there is no sensible editor.
The config for nginx is located in /etc/nginx.

`docker build --tag otobo_nginx --file scripts/docker/nginx.Dockerfile .`

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
The names of the copied files can be set via environment options when starting the container. E.g.
`-e SSL_CERTIFICATE=/etc/nginx/ssl/acme.crt -e SSL_CERTIFICATE_KEY=/etc/nginx/ssl/acme.key`

### Run the container separate from otobo web

This is only an example. In the general case where there is an already existing reverse proxy.

Start the HTTP webserver in the port 5000. This is done by setting OTOBO_WEB_PORT in .env.

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

### Run nginx in same container as the OTOBO webapp

This is the standard way of running the OTOBO webapp under HTTPS.
`docker-compose -f docker-compose_https.yml up --build`.

TODO

## Other userful Docker commands

* start over:             `docker system prune -a`
* show version:           `docker version`
* build an image:         `docker build --tag otobo-web --file=scripts/docker/web.Dockerfile .`
* run the new image:      `docker run --publish 80:5000 otobo-web`
* log into the new image: `docker run  -v opt_otobo:/opt/otobo -it otobo-web bash`
* show running images:    `docker ps`
* show available images:  `docker images`
* list volumes :          `docker volume ls`
* inspect a volumne:      `docker volume inspect opt_otobo`
* inspect a container:    `docker inspect <container>`

## other usefule Docker compose commands

* check config:          `docker-compose config`

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
