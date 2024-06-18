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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        #RestoreDatabase => 1
    },
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $DeploymentAdd = sub {
    my %Param = @_;

    my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

    return if !$DBObject->Do(
        SQL => '
                INSERT INTO sysconfig_deployment
                    (comments, effective_value, create_time, create_by)
                VALUES
                    (?, ?, ?, ?)',
        Bind => [
            \$Param{Comments}, \$Param{EffectiveValueStrg}, \$TimeStamp, \$Param{UserID},
        ],
    );

    # Get deployment ID.
    return if !$DBObject->Prepare(
        SQL => "
            SELECT id
            FROM sysconfig_deployment
            WHERE create_by = ?
                AND comments = ?
                AND user_id IS NULL
            ORDER BY id DESC",
        Bind  => [ \$Param{UserID}, \$Param{Comments} ],
        Limit => 1,
    );

    # Fetch the deployment ID.
    my $DeploymentID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DeploymentID = $Row[0];
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->Delete(
        Type => 'SysConfigDeployment',
        Key  => 'DeploymentUserList',
    );
    $CacheObject->Delete(
        Type => 'SysConfigDeployment',
        Key  => 'DeploymentList',
    );
    $CacheObject->Delete(
        Type => 'SysConfigDeployment',
        Key  => 'DeploymentGetLast',
    );

    return $DeploymentID;
};

my $DeploymentExists = sub {
    my %Param = @_;

    my $DeploymentID;
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM sysconfig_deployment
            WHERE id =?',
        Bind => [ \$Param{DeploymentID} ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DeploymentID = $Row[0];
    }

    return if !$DeploymentID;

    return 1;
};

my @Tests = (
    {
        Name => 'Invalid Deployment Old style',
        Add  => {
            Comments           => 'Comments',
            EffectiveValueStrg => 'Invalid',
            UserID             => 1,
        },
    },
    {
        Name => 'Invalid Deployment New style',
        Add  => {
            Comments           => 'OTOBOInvalid-123',
            EffectiveValueStrg => 'Some content',
            UserID             => 1,
        },
    },
);

FixedTimeSet();

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

for my $Test (@Tests) {

    my $DeploymentID = $DeploymentAdd->( %{ $Test->{Add} } );
    $Self->True(
        $DeploymentID,
        "DeploymentID $DeploymentID is added",
    );

    my $Success = $SysConfigDBObject->DeploymentListCleanup();
    $Self->True(
        $Success,
        "$Test->{Name} DeploymentListCleanup() immediately",
    );

    my $Exists = $DeploymentExists->( DeploymentID => $DeploymentID );
    $Self->True(
        $Exists,
        "$Test->{Name} Deployment exists after DeploymentListCleanup() immediately",
    );

    FixedTimeAddSeconds(21);

    $Success = $SysConfigDBObject->DeploymentListCleanup();
    $Self->True(
        $Success,
        "$Test->{Name} DeploymentListCleanup() after 21 secs",
    );

    $Exists = $DeploymentExists->( DeploymentID => $DeploymentID );
    $Self->False(
        $Exists,
        "$Test->{Name} Deployment exists after DeploymentListCleanup() after 21 secs with false",
    );
}

$Self->DoneTesting();
