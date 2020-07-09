# This is the build file for the OTOBO web docker image.
# See also README_DOCKER.md.

# use the latest Perl on Debian 10 (buster). As of 2020-07-02.
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
RUN cpanm --with-feature=mysql --with-feature=plack --with-feature=mojo --with-feature=docker --with-feature=redis --with-feature=test --installdeps .

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

# uncomment these steps when strange behavior must be investigated
#RUN echo "'$OTOBO_HOME'"
#RUN whoami
#RUN pwd
#RUN uname -a
#RUN ls -a
#RUN tree Kernel
#RUN false

# Under Docker the Elasticsearch Daemon in running on the host 'elastic' instead of '127.0.0.1'.
# The webservice configuration is in a YAML file and it is not obvious how
# to change settings for webservices.
# So we take the easy was out and do the change directly in the XML file,
# before installer.pl has run.
RUN cd scripts/database \
    && cp otobo-initial_insert.xml otobo-initial_insert.xml.orig \
    && perl -pi -e "s{Host: http://localhost:9200}{Host: http://elastic:9200}" otobo-initial_insert.xml

# Some initial setup.
# Create dirs.
# Create ARCHIVE
# Enable bash completion.
# Activate the .dist files.
# Use the docker specific Config.pm.dist file.
RUN mkdir -p var/stats var/packages \
    && bin/otobo.CheckSum.pl -a create \
    && (echo ". ~/.bash_completion" >> .bash_aliases ) \
    && cp Kernel/Config.pm.docker.dist Kernel/Config.pm \
    && cp Kernel/Config.pod.dist Kernel/Config.pod \
    && cd var/cron && for foo in *.dist; do cp $foo `basename $foo .dist`; done

# Generate and install the crontab for the user $OTOBO_USER.
# Explicitly set PATH as the required perl is located in /usr/local/bin/perl.
# var/tmp is created by $OTOBO_USER as bin/Cron.sh uses this dir.
USER $OTOBO_USER
RUN mkdir -p var/tmp \
    && echo "# File added by Dockerfile"                             >  var/cron/aab_path \
    && echo "# Let '/usr/bin/env perl' find perl in /usr/local/bin"  >> var/cron/aab_path \
    && echo "PATH=/usr/local/bin:/usr/bin:/bin"                      >> var/cron/aab_path \
    && ./bin/Cron.sh start \
    && cp scripts/vim/.vimrc .

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
