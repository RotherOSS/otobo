#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# core modules

# CPAN modules
use Plack::Handler::CGI qw();

# OTOBO modules
use Kernel::System::Web::InterfaceAgent;
use Kernel::System::ObjectManager;

# make sure that the managed objects will be recreated for the current request
local $Kernel::OM = Kernel::System::ObjectManager->new();

# 0 = debug messages off; 1 = debug messages on;
my $Debug = 0;

# do the work and give the response to the webserver
# TODO: this is broken as the Kernel::System::Web::Eceptions are not caught.
my $Content = Kernel::System::Web::InterfaceAgent->new(
    Debug => $Debug
)->Content();

# The OTOBO response object already has the HTPP headers.
# Enhance it with the HTTP status code and the content.
my $ResponseObject = $Kernel::OM->Get('Kernel::System::Web::Response');
$ResponseObject->Code(200); # TODO: is it always 200 ?
$ResponseObject->Content($Content);

# Generate output suitable for CGI
Plack::Handler::CGI->new()->run( $ResponseObject->to_app() );
