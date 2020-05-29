# Some info regarding running OTOBO as a Docker container

The idea is that two containers are used. One container runs the OTOBO webserver and the OTOBO Daemon.
The other container runs a relational database. Both containers are built and managed via Docker compose.
Two volumes are created on the host:

* **otobo_opt_otobo** containing `/opt/otobo` on the webserver container
* **otobo_mariadb_data** containing `/var/lib/mysql` on the database container

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

* `docker-compose build`

## Starting the containers

* `docker-compose up`

## Inspect the running containers

* `docker-compose ps`

## Stopping the running containers

* `docker-compose down`

## An example workflow for restarting with a new installation

Note that all previous data will be lost.

* sudo service docker restart    # workaround when sometimes the cached images are not available
* docker-compose down
* docker-compose build   # when the code has changed
* docker volume ls # should report otobo_mariadb_data and otobo_opt_otobo
* docker volume rm otobo_mariadb_data otobo_opt_otobo
* docker volume ls # should show no otobo volumes
* docker-compose up # start again
* Check sanity at [hello](http://localhost:5000/hello)
* Run the installer at [installer.pl](http://localhost:5000/otobo/installer.pl)
    * Keep the default 'db' for the database host
* Restart the Daemon as the Daemon still has the old Config.pm with the old DatabasePW
    * docker exec -it otobo_web_1  perl bin/otobo.Daemon.pl stop
    * docker exec -it otobo_web_1  perl bin/otobo.Daemon.pl start

## Other userful Docker commands

* start over:             sudo docker system prune -a
* show version:           sudo docker version
* build an image:         sudo docker build --tag otobo-web .
* run the new image:      sudo docker run -p 5000:5000 otobo-web
* log into the new image: sudo docker run  -v opt_otobo:/opt/otobo -it otobo-web bash
* show running images:    sudo docker ps
* show available images:  sudo docker images
* list volumes :          sudo docker volume ls
* inspect a volumne:      sudo docker volume inspect opt_otobo
* inspect a container: docker inspect <container>

## other usefule Docker compose commands

## Resources

* [Perl Maven](https://perlmaven.com/getting-started-with-perl-on-docker)
* [Docker Compose quick start](http://mfg.fhstp.ac.at/development/webdevelopment/docker-compose-ein-quick-start-guide/)
* [docker-otrs](https://github.com/juanluisbaptiste/docker-otrs/)
* [not403](http://not403.blogspot.com/search/label/otrs)
* [cleanup](https://forums.docker.com/t/command-to-remove-all-unused-images)
* [Dockerfile best practices](https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices/)
* [Docker cache invalidation](https://stackoverflow.com/questions/34814669/when-does-docker-image-cache-invalidation-occur)
