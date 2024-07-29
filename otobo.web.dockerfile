# This is the build file for the OTOBO web docker image.
# The services OTOBO web and OTOBO daemon use the same image.

# See also bin/docker/build_docker_images.sh
# See also https://doc.otobo.org/manual/installation/10.0/en/content/installation-docker.html

# Use the latest maintainance release of the Perl 5.32.x series as the base.
# As of 2024-07-29 this is Perl 5.32.1.
# This assures that bug and security fixes are applied when rebuilding the image.
#
# The Debian version is explicitly set to buster, that is Debian 10.
#
# The Perl module installer 'cpanm' is already installed.
FROM perl:5.32-buster

# First there is some initial setup that needs to be done by root.
USER root

# Install some required and optional Debian packages.
#
# For ODBC see https://blog.devart.com/installing-and-configuring-odbc-driver-on-linux.html
# For ODBC for SQLIte, for testing ODBC, see http://www.ch-werner.de/sqliteodbc/html/index.html
#
# The webserver needs to connect to MariaDB service using DBD::mysql. For that purpose
# 'default-mysql-client' is installed. This allows the building
# of the Perl module DBD::mysql. It also installs the command line program 'mysql'.
#
# Create /opt/otobo_install already here, in order to reduce the number of build layers.
# hadolint ignore=DL3008
RUN apt-get update\
 && apt-get -y --no-install-recommends install\
 "ack"\
 "cron"\
 "default-mysql-client"\
 "ldap-utils"\
 "less"\
 "nano"\
 "odbcinst1debian2" "libodbc1" "odbcinst" "unixodbc-dev" "unixodbc"\
 "freetds-bin" "freetds-common" "tdsodbc"\
 "postgresql-client"\
 "redis-tools"\
 "sqlite3" "libsqliteodbc"\
 "rsync"\
 "telnet"\
 "tree"\
 "screen"\
 "vim"\
 && rm -rf /var/lib/apt/lists/*\
 && install -d /opt/otobo_install

# We want an UTF-8 console
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# required modules are installed in /opt/otobo_install/local
# additional local modules might be installed in /opt/otobo/local
ENV PERL5LIB="/opt/otobo/local/lib/perl5:/opt/otobo_install/local/lib/perl5"
ENV PATH="/opt/otobo/local/bin:/opt/otobo_install/local/bin:${PATH}"

# Install packages from CPAN into the local lib /opt/otobo_install/local.
#
# Note that the modules in /opt/otobo/Kernel/cpan-lib are not considered by cpanm.
# This hopefully reduces potential conflicts.
#
# carton install will create cpanfile.snapshot. Currently this file is only used for documentation.
#
# Clean up the .cpanm dir after the installation tasks as that dir is no longer needed
# and the unpacked Perl distributions sometimes have weird user and group IDs.
WORKDIR /opt/otobo_install
COPY cpanfile.docker cpanfile
RUN cpanm --local-lib local Carton \
    && PERL_CPANM_OPT="--local-lib /opt/otobo_install/local" carton install \
    && rm -rf "$HOME/.cpanm"

# create the otobo user
#   --user-group            create group 'otobo' and add the user to the created group
#   --home-dir /opt/otobo   set $HOME of the user
#   --create-home           create /opt/otobo
#   --shell /bin/bash       set the login shell, not used here because otobo is system user
#   --comment 'OTOBO user'  complete name of the user
ENV OTOBO_USER=otobo
ENV OTOBO_GROUP=otobo
ENV OTOBO_HOME=/opt/otobo
RUN useradd --user-group --home-dir $OTOBO_HOME --create-home --shell /bin/bash --comment 'OTOBO user' $OTOBO_USER

# copy the OTOBO installation to /opt/otobo_install/otobo_next and use it as the working dir
# skip the files set up in .dockerignore
COPY --chown=$OTOBO_USER:$OTOBO_GROUP . /opt/otobo_install/otobo_next
WORKDIR /opt/otobo_install/otobo_next

# uncomment these steps when strange behavior must be investigated
#RUN echo "'$OTOBO_HOME'"
#RUN whoami
#RUN pwd
#RUN uname -a
#RUN ls -A
#RUN tree Kernel
#RUN false

# Make sure that /opt/otobo exists and is writable by $OTOBO_USER.
# set up entrypoint.sh and docker_firsttime
# Finally set permissions. Explicitly pass --runs-under-docker as
# $ENV{OTOBO_RUNS_UNDER_DOCKER} is not yet set.
RUN install --group $OTOBO_GROUP --owner $OTOBO_USER -d $OTOBO_HOME \
    && install --owner $OTOBO_USER --group $OTOBO_GROUP -D bin/docker/entrypoint.sh /opt/otobo_install/entrypoint.sh \
    && install --owner $OTOBO_USER --group $OTOBO_GROUP /dev/null docker_firsttime \
    && perl bin/otobo.SetPermissions.pl --runs-under-docker

# perform build steps that can be done as the user otobo.
USER $OTOBO_USER

# More setup that can be done by the user otobo

# Under Docker the Elasticsearch Daemon is running on the host 'elastic' instead of '127.0.0.1'.
# The webservice configuration is in a YAML file and it is not obvious how
# to change settings for webservices.
# So we take the easy was out and do the change directly in the XML file,
# before installer.pl has run.
# Doing this already in the initial database insert allows installer.pl
# to pick up the changed host and to check whether Elasticsearch is available.
RUN perl -p -i.orig -e "s{Host: http://localhost:9200}{Host: http://elastic:9200}" scripts/database/otobo-initial_insert.xml

# Create dirs.
# Enable bash completion.
# Add a .vimrc.
# make Docker image identifyable via the files git-(repo|branch|commit).txt
# Create ARCHIVE with hashes of the files in the workdir
# Config.pm.docker.dist will be copied to Config.pm in entrypoint.sh when it does not already exist.
ARG GIT_REPO=unspecified
ARG GIT_BRANCH=unspecified
ARG GIT_COMMIT=unspecified
RUN install -d var/stats var/packages var/article var/tmp \
    && (echo ". ~/.bash_completion" >> .bash_aliases ) \
    && install -m u=rw,g=r,o=r scripts/vim/.vimrc .vimrc \
    && (echo $GIT_REPO   > git-repo.txt) \
    && (echo $GIT_BRANCH > git-branch.txt) \
    && (echo $GIT_COMMIT > git-commit.txt) \
    && bin/otobo.CheckSum.pl -a create

# Up to now we have prepared /opt/otobo_install/otobo_next.
# Merging /opt/otobo_install/otobo_next and /opt/otobo is left to /opt/otobo_install/entrypoint.sh.
# Note that for supporting the command 'cron' we need to start as root.
# For all other commands entrypoint.sh switches to the user otobo.
WORKDIR $OTOBO_HOME

# Tell the web application and bin/otobo.SetPermissions.pl that it runs in a container.
# Note that this setting is essential for a correct migration from OTRS 6.
ENV OTOBO_RUNS_UNDER_DOCKER=1

# the entrypoint is not in the volume
ENTRYPOINT ["/opt/otobo_install/entrypoint.sh"]

# Add some additional meta info to the image.
# This done at the end of the Dockerfile as changed labels and changed args invalidate the layer cache.
# The labels are compliant with https://github.com/opencontainers/image-spec/blob/master/annotations.md .
# For the standard build args passed by hub.docker.com see https://docs.docker.com/docker-hub/builds/advanced/.
LABEL maintainer='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.authors='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.description='OTOBO is the new open source ticket system with strong functionality AND a great look'
LABEL org.opencontainers.image.documentation='https://otobo.org'
LABEL org.opencontainers.image.licenses='GNU General Public License v3.0 or later'
LABEL org.opencontainers.image.title='OTOBO'
LABEL org.opencontainers.image.url=https://github.com/RotherOSS/otobo
LABEL org.opencontainers.image.vendor='Rother OSS GmbH'
ARG BUILD_DATE=unspecified
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.revision=$GIT_COMMIT
LABEL org.opencontainers.image.source=$GIT_REPO
ARG DOCKER_TAG=unspecified
LABEL org.opencontainers.image.version=$DOCKER_TAG
