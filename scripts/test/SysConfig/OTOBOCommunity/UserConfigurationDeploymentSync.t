# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

## nofilter(TidyAll::Plugin::OTOBO::Perl::TestSubs)
use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use List::Util qw(max);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::Config;

# the question whether there is a S3 backend must the resolved early
my ($S3Active);
{
    my $ClearConfigObject = Kernel::Config->new( Level => 'Clear' );
    $S3Active = $ClearConfigObject->Get('Storage::S3::Active');
}

# Do not use database restore in this one as ConfigurationDeploymentSync discards Kernel::Config
#   and a new DB object will created (because of discard cascade) the new object will not be in
#   transaction mode
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $Home         = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Daemon       = $Home . '/bin/otobo.Daemon.pl';

# get daemon status (stop if necessary)
my $PreviousDaemonStatus = `$^X $Daemon status`;

if ( !$PreviousDaemonStatus ) {
    fail("Could not determine current daemon status!");

    bail_out "Could not determine current daemon status!";
}

if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    my $ResultMessage = system("$^X $Daemon stop");
}
else {
    pass("Daemon was already stopped.");
}

# Wait for slow systems
my $SleepTime = 120;
note "Waiting at most $SleepTime s until daemon stops";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $DaemonStatus = `$^X $Daemon status`;
    if ( $DaemonStatus =~ m{Daemon not running}i ) {
        last ACTIVESLEEP;
    }
    note "Sleeping for $Seconds seconds...";
    sleep 1;
}

my $CurrentDaemonStatus = `$^X $Daemon status`;
like( $CurrentDaemonStatus, qr{Daemon not running}i, "Daemon is not running", );

if ( $CurrentDaemonStatus !~ m{Daemon not running}i ) {
    die "Daemon could not be stopped.";
}

my $TestUserLogin = $HelperObject->TestUserCreate();
my $UserID        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

`rm -rf $Home/Kernel/Config/Files/User/`;

my $LocationUser = "$Home/Kernel/Config/Files/User/$UserID.pm";

unlink $LocationUser if -e $LocationUser;

# Create User directory if doesn't exists.
my $UserSettingsDir = "$Home/Kernel/Config/Files/User";
if ( !-d $UserSettingsDir ) {
    mkdir $UserSettingsDir;
}

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# create a new deployment for the user
my $UserDeploymentID;
{
    my $EffectiveValueStrg = << "END_PM";
# OTOBO config file (automatically generated)
# VERSION:2.0
package Kernel::Config::Files::User::$UserID;
use strict;
use warnings;
no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;
    \$Self->{Key} = 1;
    return;
}
1;
END_PM

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'Unit Test',
        EffectiveValueStrg  => \$EffectiveValueStrg,
        TargetUserID        => $UserID,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
        UserID              => $UserID,
    );

    # Get the id of the last deployment of the test user. The user should only have
    # a single deployment, but get the max anyways.
    my %UserDeploymentList = $SysConfigDBObject->DeploymentUserList();
    $UserDeploymentID =
        max
        grep { $UserDeploymentList{$_} == $UserID }
        keys %UserDeploymentList;

    # sanity check
    is( $UserDeploymentID, $DeploymentID, 'double check the user deployment ID' );
}

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

sub UpdateFile {
    my %Param = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $LocationUser,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    ref_ok( $ContentSCALARRef, 'SCALAR', "$LocationUser FileRead() for UpdateFile() is SCALAR ref" );

    my $Content = ${ $ContentSCALARRef || \'' };

    if ( defined $Param{Value} ) {
        $Content =~ s{ (\{'CurrentUserDeploymentID'\} [ ] = [ ] ')\d+(') }{$1$Param{Value}$2}msx;
    }
    if ( defined $Param{Remove} ) {
        $Content =~ s{ (\{'CurrentUserDeploymentID)('\})  }{$1Invalid$2}msx;
    }

    if ($S3Active) {

        # make sure the SyncWithS3() actually syncs
        sleep 1;

        # first write to S3
        my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');
        my $S3Key           = join '/', 'Kernel', 'Config', 'Files', 'User', "$UserID.pm";

        $StorageS3Object->StoreObject(
            Key     => $S3Key,
            Content => $Content,
        );

        # then sync to the file system
        $Kernel::OM->Get('Kernel::Config')->SyncWithS3;
    }
    else {
        $MainObject->FileWrite(
            Location => $LocationUser,
            Content  => \$Content,
            Mode     => 'utf8',
        );
    }

    return;
}

# reads the deployment ID from the user file in the file system
sub ReadDeploymentID {
    my ($LocationUser) = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $LocationUser,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    ref_ok( $ContentSCALARRef, 'SCALAR', "$LocationUser FileRead() for ReadDeploymentID() is SCALAR ref" );

    # greedily accept any deployment ID, even when they are not valid
    my ($CurrentDeploymentID) = $ContentSCALARRef->$* =~ m{ \{'CurrentUserDeploymentID'\} [ ] = [ ] '(.*)' }msx;

    return $CurrentDeploymentID;
}

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Make sure deployment is in sync before tests.
my $Success = $SysConfigObject->ConfigurationDeploySync();
is(
    $Success // 0,
    1,
    "Initial ConfigurationDeploymentSync() result",
);

my @Tests = (

    # User specific deployment test cases.
    {
        Name   => 'User No changes',
        Config => {
        },
        DeploymentIDBefore => $UserDeploymentID,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to 0',
        Config => {
            Value => 0,
        },
        DeploymentIDBefore => 0,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to -1',
        Config => {
            Value => -1,
        },
        DeploymentIDBefore => -1,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to empty',
        Config => {
            Value => '',
        },
        DeploymentIDBefore => '',
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Remove DeploymentID',
        Config => {
            Remove => 1,
        },
        DeploymentIDBefore => undef,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Directory does not exists',
        Config => {
            RemoveDir => 1,
        },
        DeploymentIDBefore => '',
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to be greater',
        Config => {
            Value => $UserDeploymentID + 1,
        },
        DeploymentIDBefore => $UserDeploymentID + 1,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to be latest from DB',
        Config => {
            Value => $UserDeploymentID,
        },
        DeploymentIDBefore => $UserDeploymentID,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
);

TEST:
for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        if ( $Test->{Config}->{RemoveDir} ) {
            my $Result = system("rm -rf $UserSettingsDir");
            ok(
                !$Result,
                "$UserSettingsDir directory was removed",
            );
        }
        else {
            UpdateFile( $Test->{Config}->%* );

            my $FileDeploymentID = ReadDeploymentID($LocationUser);
            is(
                $FileDeploymentID,
                $Test->{DeploymentIDBefore},
                'DeploymentID before ConfigurationDeploymentSync()',
            );
        }

        my $Success = $SysConfigObject->ConfigurationDeploySync();
        is(
            $Success // 0,
            $Test->{Success},
            "ConfigurationDeploymentSync() result",
        );

        my $FileDeploymentID = ReadDeploymentID($LocationUser);
        is(
            $FileDeploymentID,
            $Test->{DeploymentIDAfter},
            'DeploymentID after ConfigurationDeploymentSync()',
        );
    };
}

# Be sure to leave a clean system.
$Success = $SysConfigDBObject->DeploymentDelete(
    DeploymentID => $UserDeploymentID,
);

ok( $Success, "DeploymentDelete result", );

$Success = $SysConfigObject->ConfigurationDeploySync();
is( $Success, 1, "Finish ConfigurationDeploymentSync() result" );

ok( !-e $LocationUser, "Make sure that ConfigurationDeploymentSync() removed the user's file" );

done_testing;
