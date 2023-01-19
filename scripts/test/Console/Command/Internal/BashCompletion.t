# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

my @Tests = (
    {
        Name      => 'Command completion',
        COMP_LINE => 'bin/otobo.Console.pl Hel',
        Arguments => [ 'bin/otobo.Console.pl', 'Hel', 'bin/otobo.Console.pl' ],
        Result    => "Help",
    },
    {
        Name      => 'Argument list',
        COMP_LINE => 'bin/otobo.Console.pl Admin::Article::StorageSwitch ',
        Arguments => [ 'bin/otobo.Console.pl', '', 'Admin::Article::SwitchStorage' ],
        Result    => "--target
--tickets-closed-before-date
--tickets-closed-before-days
--tolerant
--micro-sleep
--force-pid",
    },
    {
        Name      => 'Argument list limitted',
        COMP_LINE => 'bin/otobo.Console.pl Admin::Article::StorageSwitch --to',
        Arguments => [ 'bin/otobo.Console.pl', '--to', 'Admin::Article::SwitchStorage' ],
        Result    => "--tolerant",
    },
);

for my $Test (@Tests) {

    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Internal::BashCompletion');

    my ( $Result, $ExitCode );

    {
        local $ENV{COMP_LINE} = $Test->{COMP_LINE};
        local *STDOUT;
        open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
        $ExitCode = $CommandObject->Execute( @{ $Test->{Arguments} } );
    }

    $Self->Is(
        $ExitCode,
        0,
        "$Test->{Name} exit code",
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} result",
    );

}

$Self->DoneTesting();
