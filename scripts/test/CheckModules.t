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

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Home = $ConfigObject->Get('Home');

if ( open my $CheckModulesFh, '-|', "$^X $Home/bin/otobo.CheckModules.pl --all NoColors" )    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
{

    LINE:
    while ( my $Line = <$CheckModulesFh> ) {
        chomp $Line;

        next LINE unless $Line;
        next LINE unless $Line =~ m/^\s*o\s\w\w/;

        if ( $Line =~ m{ok|optional}ismx ) {
            pass(qq{got 'ok' or 'optional': $Line});
        }
        else {
            fail(qq{Error in your installed perl modules: $Line});
        }
    }
    close $CheckModulesFh;
}
else {
    fail('Unable to check Perl modules');
}

done_testing();
