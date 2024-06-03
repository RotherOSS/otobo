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

# This file demonstrates how to use the autoload mechanism of OTOBO to change existing functionality.
# Please note that all autoload files have to be registered via SysConfig (see AutoloadPerlPackages###1000-Test).

# First, we add a method to Kernel::System::Valid.

use Kernel::System::Valid;    ## no critic (Modules::RequireExplicitPackage)

package Kernel::System::Valid;    ## no critic (Modules::RequireFilenameMatchesPackage)

use strict;
use warnings;
use v5.24;
use utf8;

sub AutoloadTest {
    return 1;
}

# Now, we modify a method of Kernel::System::State.

package Kernel::Autoload::Test;    ## no critic qw(Modules::ProhibitMultiplePackages)

use strict;
use warnings;
use v5.24;
use utf8;

use Kernel::System::State;

our @ObjectDependencies = (
    'Kernel::System::Log'
);

{
    no warnings 'redefine';    ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)

    # keep reference to the original StateLookup()
    my $Orig = \&Kernel::System::State::StateLookup;

    # redefine StateLookup
    *Kernel::System::State::StateLookup = sub {
        my $Self = shift;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => 'Calling the modified method Kernel::System::State::StateLookup',
        );

        my $Result = $Orig->( $Self, @_ );

        # return a default value
        return $Result // 'unknown state';
    };
}

1;
