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

# generate an informative log file name
otobo_version=$(perl -lne 'print $1 if /VERSION\s*=\s*(\S+)/' < RELEASE)
time_stamp=$(date +'%F-%H%M%S')
log_file="prove_${otobo_version}_${time_stamp}.out"

# run the test suite
bin/otobo.Console.pl Dev::UnitTest::Run --verbose >$log_file 2>&1
