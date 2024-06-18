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
use utf8;

# core modules

# CPAN modules
use CGI;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::Web::Request;

our $Self;

{
    # %ENV will be picked up in CGI->new()
    local %ENV = (
        REQUEST_METHOD => 'GET',
        QUERY_STRING   => 'a=4;b=5',
    );

    CGI->initialize_globals();
    my $Request = Kernel::System::Web::Request->new( WebRequest => CGI->new() );

    my @ParamNames = $Request->GetParamNames();
    $Self->IsDeeply(
        [ sort @ParamNames ],
        [qw/a b/],
        'ParamNames',
    );

    $Self->Is(
        $Request->GetParam( Param => 'a' ),
        4,
        'SingleParam',
    );

    $Self->Is(
        $Request->GetParam( Param => 'aia' ),
        undef,
        'SingleParam - not defined',
    );

    local $CGI::POST_MAX = 1024;

    $Request->{Query}->{'.cgi_error'} = 'Unittest failed ;-)';

    $Self->Is(
        $Request->Error(),
        'Unittest failed ;-) - POST_MAX=1KB',
        'Error()',
    );

}

{
    my $PostData = 'a=4&b=5;d=2';

    # %ENV will be picked up in CGI->new()
    local %ENV = (
        REQUEST_METHOD => 'POST',
        CONTENT_LENGTH => length($PostData),
        QUERY_STRING   => 'c=4;c=5;b=6',
    );

    local *STDIN;
    open STDIN, '<:utf8', \$PostData;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)

    CGI->initialize_globals();
    my $Request = Kernel::System::Web::Request->new( WebRequest => CGI->new() );

    my @ParamNames = $Request->GetParamNames();
    $Self->IsDeeply(
        [ sort @ParamNames ],
        [qw/a b c d/],
        'ParamNames',
    );

    $Self->IsDeeply(
        [ $Request->GetArray( Param => 'a' ) ],
        [4],
        'Param a, from POST',
    );

    $Self->IsDeeply(
        [ $Request->GetArray( Param => 'b' ) ],
        [5],
        'Param b, from POST (GET ignored)',
    );
    $Self->IsDeeply(
        [ $Request->GetArray( Param => 'c' ) ],
        [ 4, 5 ],
        'Param c, from GET',
    );
    $Self->IsDeeply(
        [ $Request->GetArray( Param => 'd' ) ],
        [2],
        'Param d, from POST',
    );

}

$Self->DoneTesting();
