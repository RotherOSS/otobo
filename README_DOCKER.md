# Some info regarding running OTOBO as a Docker container

The idea is that at least three containers are used.
All containers are built and managed via Docker compose.

## Containers

### Container otobo_web_3

OTOBO webserver on port 5000.

### Container otobo_cron_1

Cron and the OTOBO Daemon.

### Container otobo_web_1

Run the relational database MariaDB on port 3306.

## Volumes

Two volumes are created on the host:

* **otobo_opt_otobo** containing `/opt/otobo` on the webserver container
* **otobo_mariadb_data** containing `/var/lib/mysql` on the database container


## Source files

The relevant files for running OTOBO with Docker are:

* docker-compose.yml`
* `Dockerfile`
* The scripts in `bin/docker`

## Requirements

The minimal versions that have been tested are listed here. Older versions might work as well.

* Docker 19.03.08
* Docker compose 1.25.0

## Building the image

Only the image for the webserver needs to be build. For MariaDb the image from DockerHub is used.

* cd into the toplevel OTOBO source dir, which contains docker-compose.yml
* run `docker-compose build`

## Starting the containers

* Make sure that the secret MySQL root password is set up in the file .env
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
    * Log to file /opt/otobo/var/log/otobo.log

## Other userful Docker commands

* start over:             `docker system prune -a`
* show version:           `docker version`
* build an image:         `docker build --tag otobo-web .`
* run the new image:      `docker run -p 5000:5000 otobo-web`
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
