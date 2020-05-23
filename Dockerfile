# This is the build file for the OTOBO docker image.
# The database will run in a separate container. See docker-compose.yml

# See: https://perlmaven.com/getting-started-with-perl-on-docker
# See: http://mfg.fhstp.ac.at/development/webdevelopment/docker-compose-ein-quick-start-guide/
# See: https://github.com/juanluisbaptiste/docker-otrs/
# See: http://not403.blogspot.com/search/label/otrs
# See: https://forums.docker.com/t/command-to-remove-all-unused-images
# See: https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices/
# See: https://stackoverflow.com/questions/34814669/when-does-docker-image-cache-invalidation-occur

# Here are some commands for Docker newbys:
# show version:           sudo docker version
# build an image:         sudo docker build --tag otobo-web .
# run the new image:      sudo docker run -p 5000:5000 otobo-web
# log into the new image: sudo docker run  -v opt_otobo:/opt/otobo -it otobo-web bash
# show running images:    sudo docker ps
# show available images:  sudo docker images
# list volumes :          sudo docker volume ls
# inspect a volumne:      sudo docker volume inspect opt_otobo

# use the latest Perl on Debian 10 (buster). As of 2020-05-15.
# cpanm is already installed
FROM perl:5.30.2-buster

# install some required Debian packages
RUN apt-get update \
    && apt-get -y --no-install-recommends install tree vim nano default-mysql-client cron \
    && rm -rf /var/lib/apt/lists/*

# A minimal copy so that the Docker cache is not busted
COPY cpanfile ./cpanfile

# Found no easy way to install with --force in the cpanfile. Therefore install
# the modules with ignorable test failures with the option --force.
# Note that the modules in /opt/otobo/Kernel/cpan-lib are not considered by cpanm.
# This hopefully reduces potential conflicts.
RUN cpanm --force XMLRPC::Transport::HTTP Net::Server \
    && cpanm --force Net::Server \
    && RUN  cpanm --with-feature plack --with-feature=mysql --installdeps .

# create /opt/otobo and use it as working dir
RUN mkdir /opt/otobo
COPY . /opt/otobo
WORKDIR /opt/otobo

# Creating the image is like the first installation
# Activate the .dist files
RUN cd Kernel && cp Config.pm.dist Config.pm && cd ../var/cron && for foo in *.dist; do cp $foo `basename $foo .dist`; done

# start the OTOBO daemon
# start the webserver
# start the Cron watchdog
ENTRYPOINT ["/opt/otobo/bin/docker/entrypoint.sh"]
