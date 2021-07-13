#!/usr/bin/env bash

# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

# Start a local build of the selenium server needed for Selenium testing.
# For now we use locally built image. It can be build with bin/docker/build_docker_images.sh
docker start otobo_selenium || docker run -d --rm --name otobo_selenium -p 4444:4444 -p 7900:7900 -v /dev/shm:/dev/shm otobo-selenium-chrome:local-10.0.x
