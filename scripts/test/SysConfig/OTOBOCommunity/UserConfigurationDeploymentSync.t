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
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# Do not use database restore in this one as ConfigurationDeploymentSync discards Kernel::Config
#   and a new DB object will created (because of discard cascade) the new object will not be in
#   transaction mode
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $Home         = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Daemon       = $Home . '/bin/otobo.Daemon.pl';

# get daemon status (stop if necessary)
my $PreviousDaemonStatus = `perl $Daemon status`;

if ( !$PreviousDaemonStatus ) {
    $Self->False(
        1,
        "Could not determine current daemon status!",
    );
    die "Could not determine current daemon status!";
}

if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    my $ResultMessage = system("perl $Daemon stop");
}
else {
    $Self->True(
        1,
        "Daemon was already stopped.",
    );
}

# Wait for slow systems
my $SleepTime = 120;
print "Waiting at most $SleepTime s until daemon stops\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $DaemonStatus = `perl $Daemon status`;
    if ( $DaemonStatus =~ m{Daemon not running}i ) {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

my $CurrentDaemonStatus = `perl $Daemon status`;

$Self->True(
    int $CurrentDaemonStatus =~ m{Daemon not running}i,
    "Daemon is not running",
);

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

my $EffectiveValueStrg = << "EOF";
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
EOF

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
    Comments            => 'Unit Test',
    EffectiveValueStrg  => \$EffectiveValueStrg,
    TargetUserID        => $UserID,
    DeploymentTimeStamp => '1977-12-12 12:00:00',
    UserID              => $UserID,
);

my %UserDeploymentList   = $SysConfigDBObject->DeploymentUserList();
my %DeploymentListLookup = reverse %UserDeploymentList;
my $UserDeploymentID     = $DeploymentListLookup{$UserID};

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $UpdateFile = sub {
    my %Param = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $LocationUser,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    $Self->Is(
        ref $ContentSCALARRef,
        'SCALAR',
        "$LocationUser FileRead() for UpdateFile() is SCALAR ref",
    );

    my $Content = ${ $ContentSCALARRef || \'' };

    if ( defined $Param{Value} ) {
        $Content =~ s{ (\{'CurrentUserDeploymentID'\} [ ] = [ ] ')\d+(') }{$1$Param{Value}$2}msx;
    }
    if ( defined $Param{Remove} ) {
        $Content =~ s{ (\{'CurrentUserDeploymentID)('\})  }{$1Invalid$2}msx;
    }

    my $FileLocation = $MainObject->FileWrite(
        Location => $LocationUser,
        Content  => \$Content,
        Mode     => 'utf8',
    );

};

my $ReadDeploymentID = sub {
    my %Param = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $LocationUser,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    $Self->Is(
        ref $ContentSCALARRef,
        'SCALAR',
        "$LocationUser FileRead() for ReadDeploymentID() is SCALAR ref",
    );

    my $Content = ${$ContentSCALARRef};

    my $CurrentDeploymentID;
    if ( $Content =~ m{ \{'CurrentUserDeploymentID'\} [ ] = [ ] '(-?\d+)' }msx ) {
        $CurrentDeploymentID = $1;
    }

    return $CurrentDeploymentID;
};

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Make sure deployment is in sync before tests.
my $Success = $SysConfigObject->ConfigurationDeploySync();
$Self->Is(
    $Success // 0,
    1,
    "Initial ConfigurationDeploymentSync() result",
);

my @Tests = (

    # User specific deployment test cases.
    {
        Name   => 'User No changes',
        Config => {
            Type => 'User',
        },
        DeploymentIDBefore => $UserDeploymentID,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to 0',
        Config => {
            Value => 0,
            Type  => 'User',
        },
        DeploymentIDBefore => 0,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to -1',
        Config => {
            Value => -1,
            Type  => 'User',
        },
        DeploymentIDBefore => -1,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to empty',
        Config => {
            Value => '',
            Type  => 'User',
        },
        DeploymentIDBefore => '',
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Remove DeploymentID',
        Config => {
            Remove => 1,
            Type   => 'User',
        },
        DeploymentIDBefore => '',
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Directory does not exists',
        Config => {
            RemoveDir => 1,
            Type      => 'User',
        },
        DeploymentIDBefore => '',
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to be greater',
        Config => {
            Value => $UserDeploymentID + 1,
            Type  => 'User',
        },
        DeploymentIDBefore => $UserDeploymentID + 1,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'User Set DeploymentID to be latest from DB',
        Config => {
            Value => $UserDeploymentID,
            Type  => 'User',
        },
        DeploymentIDBefore => $UserDeploymentID,
        DeploymentIDAfter  => $UserDeploymentID,
        Success            => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my $FileDeploymentID;
    if ( $Test->{Config}->{RemoveDir} ) {
        my $Result = system("rm -rf $UserSettingsDir");
        $Self->False(
            $Result,
            "$UserSettingsDir directory was removed",
        );
    }
    else {
        $UpdateFile->( %{ $Test->{Config} } );

        $FileDeploymentID = $ReadDeploymentID->( %{ $Test->{Config} } );
        $Self->Is(
            $FileDeploymentID // '',
            $Test->{DeploymentIDBefore},
            "$Test->{Name} DeploymentID before ConfigurationDeploymentSync()",
        );
    }

    my $Success = $SysConfigObject->ConfigurationDeploySync();
    $Self->Is(
        $Success // 0,
        $Test->{Success},
        "$Test->{Name} ConfigurationDeploymentSync() result",
    );

    $FileDeploymentID = $ReadDeploymentID->( %{ $Test->{Config} } );
    $Self->Is(
        $FileDeploymentID,
        $Test->{DeploymentIDAfter},
        "$Test->{Name} DeploymentID after ConfigurationDeploymentSync()",
    );
}

# Be sure to leave a clean system.
$Success = $SysConfigDBObject->DeploymentDelete(
    DeploymentID => $DeploymentID,
);

$Self->True(
    $Success // 0,
    "DeploymentDelete result",
);

$Success = $SysConfigObject->ConfigurationDeploySync();
$Self->Is(
    $Success // 0,
    1,
    "Finish ConfigurationDeploymentSync() result",
);

$Self->False(
    -e $LocationUser,
    "Make sure that ConfigurationDeploymentSync() removed the user's file",
);

$Self->DoneTesting();
