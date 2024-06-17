#!/usr/bin/env bash

# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

# Start an OTOBO specific image for Selenium testing.
# The image will be downloaded from hub.docker.com.
# The container holds no state. So we simple remove the container when it stops.
docker run --detach --rm --restart no --name otobo_selenium-chrome -p 4444:4444 -p 7900:7900 -v /dev/shm:/dev/shm rotheross/otobo-selenium-chrome:latest
