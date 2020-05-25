# This is the build file for the OTOBO docker image.
# See also DOCKER.md.
# The database will run in a separate container. See docker-compose.yml

# use the latest Perl on Debian 10 (buster). As of 2020-05-15.
# cpanm is already installed
FROM perl:5.30.2-buster

# install some required Debian packages
RUN apt-get update \
    && apt-get -y --no-install-recommends install tree vim nano default-mysql-client cron \
    && rm -rf /var/lib/apt/lists/*

# create the otobo user
#   --system                group is 'nogroup', no login shell
#   --user-group            create group 'otobo' and add the user to the created group
#   --home-dir /opt/otobo   set $HOME of the user
#   --create-home           create /opt/otobo
#   --comment 'OTOBO user'  complete name of the user
#   --shell /bin/bash       set the login shell, not used here because otobo is system user
RUN useradd --system --user-group --home-dir /opt/otobo --create-home --comment 'OTOBO user' otobo

# continue in otobo home
WORKDIR /opt/otobo

# A minimal copy so that the Docker cache is not busted
COPY cpanfile ./cpanfile

# Found no easy way to install with --force in the cpanfile. Therefore install
# the modules with ignorable test failures with the option --force.
# Note that the modules in /opt/otobo/Kernel/cpan-lib are not considered by cpanm.
# This hopefully reduces potential conflicts.
RUN cpanm --force XMLRPC::Transport::HTTP Net::Server
RUN cpanm --with-feature plack --with-feature=mysql --installdeps .

# copy the OTOBO installation to /opt/otobo and use it as working dir
COPY --chown=otobo:otobo . /opt/otobo

# Activate the .dist files.
# Use 'db' instead of the localhost as the default database host.
RUN cd Kernel \
    && cp Config.pm.dist Config.pm \
    && perl -pi -e "s/'127.0.0.1';/'db'; # adapted by Dockerfile/" Config.pm \
    && cd ../var/cron && for foo in *.dist; do cp $foo `basename $foo .dist`; done

# set permissions
RUN perl bin/docker/set_permissions.pl

# start the OTOBO daemon
# start the webserver
# start the Cron watchdog
USER otobo
ENTRYPOINT ["/opt/otobo/bin/docker/entrypoint.sh"]
