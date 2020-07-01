# This is the build file for the OTOBO docker image.
# See also DOCKER.md.
# The database will run in a separate container. See docker-compose.yml

# use the latest Perl on Debian 10 (buster). As of 2020-05-15.
# cpanm is already installed
FROM perl:5.32.0-buster

USER root

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
RUN cpanm --force XMLRPC::Transport::HTTP Net::Server Linux::Inotify2
RUN cpanm --with-feature=mysql --with-feature=plack --with-feature=mojo --installdeps .


# create the otobo user
#   --user-group            create group 'otobo' and add the user to the created group
#   --home-dir /opt/otobo   set $HOME of the user
#   --create-home           create /opt/otobo
#   --shell /bin/bash       set the login shell, not used here because otobo is system user
#   --comment 'OTOBO user'  complete name of the user
ENV OTOBO_USER otobo
ENV OTOBO_GROUP otobo
ENV OTOBO_HOME /opt/otobo
RUN useradd --user-group --home-dir $OTOBO_HOME --create-home --shell /bin/bash --comment 'OTOBO user' $OTOBO_USER

# copy the OTOBO installation to /opt/otobo and use it as the working dir
# skip the files set up in .dockerignore
COPY --chown=$OTOBO_USER:$OTOBO_GROUP . $OTOBO_HOME
WORKDIR $OTOBO_HOME

# Some initial setup.
# Create dirs.
# Enable bash completion.
# Activate the .dist files.
# Use the docker specific Config.pm.dist file.
RUN mkdir -p var/stats var/packages \
    && (echo ". ~/.bash_completion" >> .bash_aliases ) \
    && cp scripts/docker/Config.pm.dist Kernel/Config.pm \
    && cd Kernel && perl -pi -e "s/'127.0.0.1';/'db'; # adapted by Dockerfile/" Config.pm \
    && cd ../var/cron && for foo in *.dist; do cp $foo `basename $foo .dist`; done

# Generate and install the crontab for the user $OTOBO_USER.
# Explicitly set PATH as the required perl is located in /usr/local/bin/perl.
# var/tmp is created by $OTOBO_USER as bin/Cron.sh used this dir.
USER $OTOBO_USER
RUN mkdir -p var/tmp \
    && echo "# File added by Dockerfile"                             >  var/cron/aab_path \
    && echo "# Let '/usr/bin/env perl' find perl in /usr/local/bin"  >> var/cron/aab_path \
    && echo "PATH=/usr/local/bin:/usr/bin:/bin"                      >> var/cron/aab_path \
    && ./bin/Cron.sh start

# set permissions
USER root
RUN perl bin/docker/set_permissions.pl

# start the webserver
# start the OTOBO daemon
# start the Cron watchdog
# Tell the webapplication that it runs in a container.
# The entrypoint takes one command: 'web' or 'cron', web switches to OTOBO_USER
ENV OTOBO_RUNS_UNDER_DOCKER 1
ENTRYPOINT ["bin/docker/entrypoint.sh"]
