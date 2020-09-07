#!/usr/bin/env bash

# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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

# NOTE: Do not set DOCKER_REPO in this script.
#       Because DOCKER_REPO is misused in hook scripts as an indication
#       that the script is called by an automated Docker Hub build.
#       Setting IMAGE_NAME is OK.

# Just a small helper for building the docker images locally.
# For productive use please use the images from Docker Hub.

# The variable that are defined here follow the same convention as in
# https://docs.docker.com/docker-hub/builds/advanced/.
# This means that local build can use the same build hook as Docker Hub builds.

# set general environment variables
export SOURCE_COMMIT=$(git rev-parse HEAD)
export SOURCE_BRANCH=$(git branch --show-current)

# build otobo:local-rel-10_0
export DOCKERFILE_PATH=otobo.web.dockerfile
export IMAGE_NAME=otobo:local-rel-10_0
hooks/build || exit 1

# build otobo-nginx-webproxy:local-rel-10_0
export DOCKERFILE_PATH=otobo.nginx.dockerfile
export IMAGE_NAME=otobo-nginx-webproxy:local-rel-10_0
hooks/build || exit 1

# build otobo-elasticsearch:local-rel-10_0
export DOCKERFILE_PATH=otobo.elasticsearch.dockerfile
export IMAGE_NAME=otobo-elasticsearch:local-rel-10_0
hooks/build || exit 1
