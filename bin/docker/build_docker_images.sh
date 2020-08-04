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
docker build -f otobo.web.dockerfile   -t otobo:local   .
docker build -f otobo.nginx.dockerfile -t otobo-nginx-webproxy:local .
docker build -f otobo.elasticsearch.dockerfile -t otobo-elasticsearch:local .
