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
use File::Basename qw(basename);

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# This test ensures that the notification-event templates
# don't have the html tag 'title'.

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $TemplatesFolder = $ConfigObject->Get('Home')
    . '/Kernel/Output/HTML/Templates/Standard/NotificationEvent/Email';
my @Templates = glob $TemplatesFolder . '/*.tt';

for my $Template (@Templates) {
    my $Contents = ${
        $MainObject->FileRead(
            Location => $Template,
        )
    };
    my $TagFound = $Contents =~ /<title>.*<\/title>/is;
    $Self->False(
        $TagFound,
        sprintf( 'NotificationEvent Template "%s" with no title tag.', basename($Template) ),
    );
}

$Self->DoneTesting();
