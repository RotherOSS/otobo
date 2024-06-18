#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use strict;
use warnings;
use v5.24;
use utf8;

# core modules
use File::Basename qw(dirname);

# CPAN modules
use Plack::Util qw();
use Plack::Handler::CGI qw();

# OTOBO modules

#local $ENV{PLACK_URLMAP_DEBUG} = 1; # enable when the URL mapping does not work

# otobo.psgi looks primarily in $ENV{PATH_INFO}
local $ENV{PATH_INFO}   = join '/', grep { defined $_ && $_ ne '' } @ENV{qw(SCRIPT_NAME PATH_INFO)};
local $ENV{SCRIPT_NAME} = '';

my $CgiBinDir = dirname(__FILE__);
state $App = Plack::Util::load_psgi("$CgiBinDir/../psgi-bin/otobo.psgi");
Plack::Handler::CGI->new()->run($App);
