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

## nofilter(TidyAll::Plugin::OTOBO::Perl::TestSubs)
use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# Do not use database restore in this one as ConfigurationDeploymentSync discards Kernel::Config
#   and a new DB object will created (because of discard cascade) the new object will not be in
#   transaction mode
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Location = "$Home/Kernel/Config/Files/ZZZAAuto.pm";

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

sub UpdateFile {
    my %Param = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $Location,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    ref_ok( $ContentSCALARRef, 'SCALAR', "$Location FileRead() for UpdateFile() is SCALAR ref" );

    my $Content = ${ $ContentSCALARRef || \'' };

    if ( defined $Param{Value} ) {
        $Content =~ s{ (\{'CurrentDeploymentID'\} [ ] = [ ] ')\d+(') }{$1$Param{Value}$2}msx;
    }
    if ( defined $Param{Remove} ) {
        $Content =~ s{ (\{'CurrentDeploymentID)('\})  }{$1Invalid$2}msx;
    }

    my $FileLocation = $MainObject->FileWrite(
        Location => $Location,
        Content  => \$Content,
        Mode     => 'utf8',
    );

    return;
}

sub ReadDeploymentID {
    my %Param = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $Location,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    ref_ok( $ContentSCALARRef, 'SCALAR', "$Location FileRead() for ReadDeploymentID() is SCALAR ref" );

    my $Content = ${$ContentSCALARRef};

    my $CurrentDeploymentID;
    if ( $Content =~ m{ \{'CurrentDeploymentID'\} [ ] = [ ] '(-?\d+)' }msx ) {
        $CurrentDeploymentID = $1;
    }

    return $CurrentDeploymentID;
}

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Check system, provide more visibility to unit tests.
ok( -e "$Home/Kernel/Config/Files/ZZZAAuto.pm", "ZZZAAUto.pm exists" );
my @List = $SysConfigDBObject->DeploymentListGet();
isnt(
    \@List,
    [],
    "Initial DeploymentListGet() is not empty",
);

my %LastDeployment   = $SysConfigDBObject->DeploymentGetLast();
my $LastDeploymentID = $LastDeployment{DeploymentID};

# Make sure deployment is in sync before tests.
my $Success = $SysConfigObject->ConfigurationDeploySync();
is( $Success, 1, "Initial ConfigurationDeploymentSync() result" );

my @Tests = (
    {
        Name   => 'Global No changes',
        Config => {
            Type => 'Global',
        },
        DeploymentIDBefore => $LastDeploymentID,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to 0',
        Config => {
            Value => 0,
            Type  => 'Global',
        },
        DeploymentIDBefore => 0,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to -1',
        Config => {
            Value => -1,
            Type  => 'Global',
        },
        DeploymentIDBefore => -1,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },

    {
        Name   => 'Global Set DeploymentID to empty',
        Config => {
            Value => '',
            Type  => 'Global',
        },
        DeploymentIDBefore => undef,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Remove DeploymentID',
        Config => {
            Remove => 1,
            Type   => 'Global',
        },
        DeploymentIDBefore => undef,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to be greater',
        Config => {
            Value => $LastDeploymentID + 1,
            Type  => 'Global',
        },
        DeploymentIDBefore => $LastDeploymentID + 1,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to be latest from DB',
        Config => {
            Value => $LastDeploymentID,
            Type  => 'Global',
        },
        DeploymentIDBefore => $LastDeploymentID,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
);

TEST:
for my $Test (@Tests) {
    subtest $Test->{Name} => sub {

        # wait a bit, so that the newly written file doesn't have the same timestamp
        # as the file from the previous iteration
        sleep 1;
        UpdateFile( $Test->{Config}->%* );

        my $IDBefore = ReadDeploymentID( $Test->{Config}->%* );
        note("DeploymentID before sync: @{[ $IDBefore // 'undef' ]}");
        is( $IDBefore, $Test->{DeploymentIDBefore}, "DeploymentID before ConfigurationDeploymentSync()" );

        my $Success = $SysConfigObject->ConfigurationDeploySync();
        is( $Success, $Test->{Success}, "ConfigurationDeploymentSync() result" );

        # SyncWithS3() checks internally whether S3 is active
        $ConfigObject->SyncWithS3();

        my $IDAfter = ReadDeploymentID( $Test->{Config}->%* );
        note("DeploymentID after sync: @{[ $IDAfter // 'undef' ]}");
        is( $IDAfter, $Test->{DeploymentIDAfter}, "DeploymentID after ConfigurationDeploymentSync()" );
    };
}

$Success = $SysConfigObject->ConfigurationDeploySync();
is( $Success, 1, "Finish ConfigurationDeploymentSync() result" );

done_testing();
