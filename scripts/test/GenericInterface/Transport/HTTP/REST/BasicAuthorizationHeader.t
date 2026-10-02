# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use MIME::Base64 qw(encode_base64);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::GenericInterface::Transport::HTTP::REST;

my $TransportObject = Kernel::GenericInterface::Transport::HTTP::REST->new(
    DebuggerObject  => {},
    TransportConfig => {},
);

for my $Test (
    {
        Name     => 'short credentials',
        User     => 'user',
        Password => 'password',
    },
    {
        Name     => 'credentials exceeding the MIME line length',
        User     => 'long-user',
        Password => 'p' x 100,
    },
    )
{
    my $Header = $TransportObject->_BasicAuthorizationHeader(
        User     => $Test->{User},
        Password => $Test->{Password},
    );

    is(
        $Header,
        'Basic ' . encode_base64( "$Test->{User}:$Test->{Password}", '' ),
        "$Test->{Name} are encoded without MIME line endings",
    );
    unlike( $Header, qr{[\r\n]}, "$Test->{Name} contain no line breaks" );
}

done_testing();
