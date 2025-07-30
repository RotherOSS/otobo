#!/usr/bin/env bash

# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

# Just a small helper for building the OTOBO Docker images locally.
# For productive use please use the images that are available from Docker Hub.

# Formerly the building was compatible with automated builds on Docker Hub.
# See https://docs.docker.com/docker-hub/builds/advanced/.
# This is no longer the case as automated building is now done with GitHub Actions.

# this function calls "docker build"
build () {
    local DOCKER_FILE=$1;
    local DOCKER_TARGET=$2;
    local DOCKER_TAG=$3;
    local GIT_COMMIT=$4;
    local GIT_BRANCH=$5;
    local BUILD_PATH=$6;
    local IMAGE_NAME=$7;

    # build the Docker image
    # add the option '--progress plain' for seeing the printed output
    docker build\
    --build-arg "BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')"\
    --build-arg "DOCKER_TAG=$DOCKER_TAG"\
    --build-arg "GIT_COMMIT=$GIT_COMMIT"\
    --build-arg "GIT_BRANCH=$GIT_BRANCH"\
    --build-arg "GIT_REPO=$(git config --get remote.origin.url)"\
    -f "$DOCKER_FILE"\
    -t "$IMAGE_NAME"\
    --target="$DOCKER_TARGET"\
    $BUILD_PATH
}

# environment vars for all Docker images built by this script
GIT_BRANCH=$(git branch --show-current)   # will be empty in detached HEAD
GIT_COMMIT=$(git rev-parse HEAD)          # also works in detached HEAD
otobo_version=$(perl -lne 'print $1 if /VERSION\s*=\s*(\S+)/' < RELEASE)
DOCKER_TAG="local-${otobo_version}"

# build otobo
build "otobo.web.dockerfile" "otobo-web" $DOCKER_TAG $GIT_COMMIT $GIT_BRANCH "." "otobo:$DOCKER_TAG"

# build otobo with Kerberos support
build "otobo.web.dockerfile" "otobo-web-kerberos" $DOCKER_TAG $GIT_COMMIT $GIT_BRANCH "." "otobo-kerberos:$DOCKER_TAG"

# Building the web container entails installing Perl distributions from CPAN.
# The exact versions of these distributions are tracked in the file cpanfile.snapshot.
# This file is part of the git repository and is kept up to date.
docker run --rm --entrypoint cat otobo-kerberos:$DOCKER_TAG /opt/otobo_install/cpanfile.snapshot > cpanfile.docker.snapshot.11_1

# build otobo-nginx-webproxy
build "otobo.nginx.dockerfile" "otobo-nginx-webproxy" $DOCKER_TAG $GIT_COMMIT $GIT_BRANCH "scripts/nginx" "otobo-nginx-webproxy:$DOCKER_TAG"

# build otobo-nginx-kerberos-webproxy
build "otobo.nginx.dockerfile" "otobo-nginx-kerberos-webproxy" $DOCKER_TAG $GIT_COMMIT $GIT_BRANCH "scripts/nginx" "otobo-nginx-kerberos-webproxy:$DOCKER_TAG"

# build otobo-elasticsearch
build "otobo.elasticsearch.dockerfile" "otobo-elasticsearch" $DOCKER_TAG $GIT_COMMIT $GIT_BRANCH "scripts/elasticsearch" "otobo-elasticsearch:$DOCKER_TAG"

# build otobo-selenium-chrome
build "otobo.selenium-chrome.dockerfile" "otobo-selenium-chrome" $DOCKER_TAG $GIT_COMMIT $GIT_BRANCH "scripts/test/sample" "otobo-selenium-chrome:$DOCKER_TAG"
