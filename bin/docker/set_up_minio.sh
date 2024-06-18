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

# Set up MinIO starting from a virgin state. It is expected that the executable mc is
# in the path and that the MinIO alias otobo_minio is set up.

# settings
config_file=$( dirname -- "${BASH_SOURCE[0]}" )/../../Kernel/Config.pm.docker.dist
alias=otobo_minio

# sanity check
which mc

# create user with readwrite privileges
user=$(sed -n -e "s/.*'Storage::S3::AccessKey'.*'\(.*\)'.*/\1/p" $config_file)
password=$(sed -n -e "s/.*'Storage::S3::SecretKey'.*'\(.*\)'.*/\1/p" $config_file)
mc admin user add $alias $user $password
mc admin policy set $alias readwrite user=$user

# create a bucket
bucket=$(sed -n -e "s/.*'Storage::S3::Bucket'.*'\(.*\)'.*/\1/p" $config_file)
mc mb $alias/$bucket
