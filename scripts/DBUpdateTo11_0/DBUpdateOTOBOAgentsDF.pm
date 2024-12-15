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

package scripts::DBUpdateTo11_0::DBUpdateOTOBOAgentsDF;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Package',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBUpdateOTOBOAgentsDF - Update OTOBOAgents Dynamic Fields
from the OTOBOAgents package and convert to standard Agent-Ref Dynamic Fields.

=cut

use parent qw(scripts::DBUpdateTo11_0::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DBObject                = $Kernel::OM->Get('Kernel::System::DB');
    my $DynamicFieldObject      = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
    my $PackageObject           = $Kernel::OM->Get('Kernel::System::Package');

    # support console command
    if ( !defined $DBObject->{dbh} ) {
        $DBObject->Connect();
    }
    if ( !defined $DBObject->{dbh} ) {
        die("unable to connect to Database.");
    }

    # get DynamicFieldOTOBOAgents package
    my $Package = $PackageObject->RepositoryGet(
        Name    => 'DynamicFieldOTOBOAgents',
        Version => '10.0.1',
    );
    if ( !$Package ) {

        # be a little paranoid and check for any other version installed
        my $IsInstalled = $PackageObject->PackageIsInstalled( Name => 'DynamicFieldOTOBOAgents' );
        if ($IsInstalled) {
            print "\tPackage DynamicFieldOTOBOAgents is installed but upgrade is only possibly from version 10.0.1.\n";
            print "\tOTOBOAgents package migration failed.\n";
            return 0;
        }
        else {
            print "\tDynamicFieldOTOBOAgents Package is not installed. Skipping.\n";
            return 1;
        }
    }

    $DBObject->BeginWork();

    # get IDs forall installed OTOBOAgents DFs

    my @DynamicFieldIDs = $Self->_GetOTOBOAGentsDFIDs( DBObject => $DBObject );

    # first upgrade the DF values

    for my $ID (@DynamicFieldIDs) {

        $Self->_UpdateDynamicFieldValues(
            ID                      => $ID,
            DBObject                => $DBObject,
            DynamicFieldValueObject => $DynamicFieldValueObject,
        );
    }

    # second step convert to Agent Ref

    for my $ID (@DynamicFieldIDs) {

        $Self->_UpdateDynamicFieldConfig(
            ID                 => $ID,
            DynamicFieldObject => $DynamicFieldObject,
        );
    }

    # step three: uninstall the package

    my $Success = $PackageObject->PackageUninstall( String => $Package );
    if ( !$Success ) {
        die "Unistall of DynamicFieldOTOBOAgents failed.";
    }

    print "\tDynamicFieldOTOBOAgents Package uninstalled.\n";

    $DBObject->{dbh}->commit();

    return 1;
}

sub _UpdateDynamicFieldConfig {

    my ( $Self, %Param ) = @_;

    my $ID                 = $Param{'ID'};
    my $DynamicFieldObject = $Param{'DynamicFieldObject'};

    my $DF = $DynamicFieldObject->DynamicFieldGet( ID => $ID );

    my $NewConfig = {
        EditFieldMode         => 'Dropdown',
        Group                 => [],
        ImportSearchAttribute => '',
        MultiValue            => '0',
        Multiselect           => 0,
        PossibleNone          => $DF->{Config}->{PossibleNone} || 0,
        ReferencedObjectType  => 'Agent',
        Tooltip               => '',
    };

    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        ID         => $ID,
        Name       => $DF->{Name},
        Label      => $DF->{Label},
        FieldOrder => $DF->{FieldOrder},
        FieldType  => 'Agent',
        ObjectType => $DF->{ObjectType},
        ValidID    => $DF->{ValidID},
        Config     => $NewConfig,
        UserID     => 1,                   #admin
    );

    if ( !$Success ) {
        die "Unable to set DF Config for " . $DF->{Name} . " ($ID) with:\n $NewConfig\n";
    }

    return;
}

sub _UpdateDynamicFieldValues {

    my ( $Self, %Param ) = @_;

    my $FieldID                 = $Param{'ID'};
    my $DBObject                = $Param{'DBObject'};
    my $DynamicFieldValueObject = $Param{'DynamicFieldValueObject'};

    my @ObjectIDs;
    $DBObject->Prepare(
        SQL  => 'SELECT object_id FROM dynamic_field_value WHERE field_id = ?',
        Bind => [ \$FieldID ],
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @ObjectIDs, $Row[0];
    }

    for my $ObjectID (@ObjectIDs) {

        my $ExistingValues = $DynamicFieldValueObject->ValueGet(
            FieldID  => $FieldID,
            ObjectID => $ObjectID
        );

        for my $ExistingValue ( $ExistingValues->@* ) {

            my $Success = $DynamicFieldValueObject->ValueSet(
                FieldID  => $FieldID,
                ObjectID => $ObjectID,
                Value    => [
                    {
                        ValueText => undef,
                        ValueInt  => $ExistingValue->{ValueText},
                    },
                ],
                UserID => 1    #admin
            );

            if ( !$Success ) {
                die "Unable to set DF Value " . $ExistingValue->{ValueText} . " for object $ObjectID field $FieldID.";
            }
        }
    }

    return;
}

sub _GetOTOBOAGentsDFIDs {

    my ( $Self, %Param ) = @_;

    my $DBObject        = $Param{'DBObject'};
    my $OTOBOAgentsType = 'OTOBOAgents';

    my @Result;
    $DBObject->Prepare(
        SQL  => 'SELECT id FROM dynamic_field WHERE field_type = ?',
        Bind => [ \$OTOBOAgentsType ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    return @Result;
}

1;
