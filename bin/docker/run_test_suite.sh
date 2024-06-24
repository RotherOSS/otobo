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

# This script is a small helper for running the complete test suite.
# The output of the test suite is written to a log file with a somewhat
# sensible name. No parameters are handled.

# generate an informative log file name
otobo_version=$(perl -lne 'print $1 if /VERSION\s*=\s*(\S+)/' < RELEASE)
time_stamp=$(date +'%F-%H%M%S')
git_branch=$(cat git-branch.txt 2>/dev/null)
log_file="prove_${otobo_version}_${time_stamp}_${git_branch:-unknown_branch}.out"

# print out the relevant information about this OTOBO installation
# Never mind when any of these files are missing
more RELEASE git-*.txt >$log_file 2>/dev/null

# add an empty line, just for visual pleasantness
echo >>$log_file

# run the test suite
bin/otobo.Console.pl Dev::UnitTest::Run --verbose --merge >>$log_file 2>&1
