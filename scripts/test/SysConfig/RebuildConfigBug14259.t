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
use Time::HiRes ();

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $CacheType = 'UnitTestRebuildConfig';

my $ChildCount = $Kernel::OM->Get('Kernel::Config')->Get('UnitTest::TicketCreateNumber::ChildCount') || 5;

for my $ChildIndex ( 1 .. $ChildCount ) {

    # Disconnect database before fork.
    $DBObject->Disconnect();

    # WORKAROUND: When forking on fast systems, Maint::Config::Rebuild fails due to the issue in PIDCreate().
    # Sometimes it can happen that there are 2 processes with same name at the same time (usually on Postgres).
    # It should be fixed in the next major release (requires DB modification).
    Time::HiRes::sleep(0.2);

    # Create a fork of the current process
    #   parent gets the PID of the child
    #   child gets PID = 0
    my $PID = fork;
    if ( !$PID ) {

        # Destroy objects.
        $Kernel::OM->ObjectsDiscard();

        # Execute console command.
        `$^X bin/otobo.Console.pl Maint::Config::Rebuild --time 180`;
        my $ExitCode = $? >> 8;

        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $CacheType,
            Key   => "$ChildIndex",
            Value => {
                ExitCode => $ExitCode,
            },
            TTL => 60 * 10,
        );

        exit 0;
    }
}

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

my %ChildData;

my $Wait = 1;
while ($Wait) {
    CHILDINDEX:
    for my $ChildIndex ( 1 .. $ChildCount ) {

        next CHILDINDEX if $ChildData{$ChildIndex};

        my $Cache = $CacheObject->Get(
            Type => $CacheType,
            Key  => "$ChildIndex",
        );

        next CHILDINDEX if !$Cache;
        next CHILDINDEX if ref $Cache ne 'HASH';

        $ChildData{$ChildIndex} = $Cache;
    }
}
continue {
    my $GotDataCount = scalar keys %ChildData;
    if ( $GotDataCount == $ChildCount ) {
        $Wait = 0;
    }
    sleep 1;
}

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

CHILDINDEX:
for my $ChildIndex ( 1 .. $ChildCount ) {

    my %Data = %{ $ChildData{$ChildIndex} };

    $Self->Is(
        $Data{ExitCode},
        0,
        "RebuildConfig from child $ChildIndex exit correctly",
    );
}

$CacheObject->CleanUp(
    Type => $CacheType,
);

$Self->DoneTesting();
