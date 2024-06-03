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
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM

our $Self;

# plan the tests
my $ChildCount   = $Kernel::OM->Get('Kernel::Config')->Get('UnitTest::TicketCreateNumber::ChildCount') || 5;
my $NumTestUsers = 3;
plan(
    $NumTestUsers                            # creation of a test user
        + 2 * $NumTestUsers * $ChildCount    # two tests per process and testuser
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# testing with three test users
my @TargetUserIDs;
{
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    for my $Cnt ( 1 .. $NumTestUsers ) {
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || bail_out('Did not get test user');

        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        push @TargetUserIDs, $TestUserID;
    }
}

my $FileBase = << 'EOF';
# OTOBO config file (automatically generated)
# VERSION:2.0
package Kernel::Config::Files::User::0;
use strict;
use warnings;
no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
use utf8;
 sub Load {
    my ($File, $Self) = @_;
$Self->{'Ticket::Frontend::AgentTicketQueue'}->{'Blink'} =  '1';
    return;
}
1;
EOF

my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
my $CacheType = 'UnitTestTicketCounter';

for my $TargetUserID (@TargetUserIDs) {

    my $UserFile = $FileBase;
    $UserFile =~ s{0}{$TargetUserID}gmxi;

    for my $ChildIndex ( 1 .. $ChildCount ) {

        # Disconnect database before fork.
        $DBObject->Disconnect();

        # Create a fork of the current process
        #   parent gets the PID of the child
        #   child gets PID = 0
        my $PID = fork;
        if ( !$PID ) {

            # Destroy objects.
            $Kernel::OM->ObjectsDiscard();

            my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

            my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
                Comments            => 'Some Comments',
                EffectiveValueStrg  => \$UserFile,
                TargetUserID        => $TargetUserID,
                DeploymentTimeStamp => '1977-12-12 12:00:00',
                UserID              => 1,
            );

            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $CacheType,
                Key   => "${TargetUserID}::${ChildIndex}",
                Value => {
                    DeploymentID => $DeploymentID,

                    #TicketID     => $TicketID,
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
                Key  => "${TargetUserID}::${ChildIndex}",
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

    my %DeploymentIDs;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    CHILDINDEX:
    for my $ChildIndex ( 1 .. $ChildCount ) {

        my %Data = %{ $ChildData{$ChildIndex} };

        next CHILDINDEX if !$Data{DeploymentID};

        $Self->Is(
            $DeploymentIDs{ $Data{DeploymentID} } || 0,
            0,
            "DeploymentID from child $ChildIndex '$Data{DeploymentID}' with $TargetUserID assigned multiple times",
        );

        $DeploymentIDs{ $Data{DeploymentID} } = 1;

        my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentDelete(
            DeploymentID => $Data{DeploymentID},
            UserID       => 1,
        );

        $Self->True(
            $Success,
            "DeploymentDelete for $Data{DeploymentID}",
        );
    }
    $CacheObject->CleanUp(
        Type => $CacheType,
    );
}
