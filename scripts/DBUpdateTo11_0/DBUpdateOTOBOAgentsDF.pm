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
    'Kernel::System::YAML',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBUpdateOTOBOAgentsDF - Update OTOBOAgents Dynamic Fields
from the OTOBOAgents packages and convert to standard Agent-Ref Dynamic fields.

=cut

use parent qw(scripts::DBUpdateTo11_0::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    # check if already converted

    if ( !$Self->_HasOTOBOAgentsDynamicFields( DBObject => $DBObject ) ) {

        print "No Dynamic Fields of type OTOBOAgent to convert. Done.\n";
        return 1;
    }

    $DBObject->BeginWork();

    # get info for all installed OTOBOAgents DFs

    my @DynamicFields = $Self->_GetOTOBOAGentsDFs( DBObject => $DBObject );

    # first upgrade the DF values

    for my $DF (@DynamicFields) {
        my $Id = $DF->[0];

        $Self->_UpdateDynamicFieldValues(
            Id       => $Id,
            DBObject => $DBObject
        );
    }

    # second step convert to Agent Ref

    for my $DF (@DynamicFields) {
        my $Id     = $DF->[0];
        my $Config = $DF->[7];

        $Self->_UpdateDynamicFieldConfig(
            Id         => $Id,
            Config     => $Config,
            DBObject   => $DBObject,
            YAMLObject => $YAMLObject,
        );
    }

#    $DBObject->Rollback();

    $DBObject->{dbh}->commit();

    return 1;
}


sub _UpdateDynamicFieldConfig {

    my ( $Self, %Param ) = @_;

    my $Id         = $Param{'Id'};
    my $ConfigYaml = $Param{'Config'};
    my $DBObject   = $Param{'DBObject'};
    my $YAMLObject = $Param{'YAMLObject'};

    my $OldConfig = $YAMLObject->Load( Data => $ConfigYaml );

    my $NewConfig = {
        EditFieldMode         => 'Dropdown',
        Group                 => [],
        ImportSearchAttribute => '',
        MultiValue            => '0',
        Multiselect           => 0,
        PossibleNone          => $OldConfig->{PossibleNone} || 0,
        ReferencedObjectType  => 'Agent',
        Tooltip               => '',
    };

    if( exists $OldConfig->{Link} ) {
        $NewConfig->{Link} = $OldConfig->{Link};
    }

    my $NewConfigYaml = $YAMLObject->Dump( Data => $NewConfig );

    # print "UPDATE dynamic_field SET field_type = 'Agent', config = '$NewConfigYaml' WHERE field_type = 'OTOBOAgents' AND id = $Id \n";

    $DBObject->Do(
        SQL => "UPDATE dynamic_field SET field_type  = 'Agent', config = ? WHERE field_type = 'OTOBOAgents' AND id = ? ",
        Bind => [ \$NewConfigYaml, \$Id ],
    );

    return;
}

sub _UpdateDynamicFieldValues {

    my ( $Self, %Param ) = @_;

    my $FieldId  = $Param{'Id'};
    my $DBObject = $Param{'DBObject'};

    my @Values;
    $DBObject->Prepare(
        SQL  => 'SELECT id, field_id, object_id, value_text, value_date, value_int FROM dynamic_field_value WHERE field_id = ?',
        Bind => [ \$FieldId ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Values, \@Row;
    }

    for my $Value (@Values) {

        my $Id        = $Value->[0];
        my $ValueText = $Value->[3];

        # print "UPDATE dynamic_field_value SET value_text = NULL, value_int = $ValueText WHERE field_id = $FieldId AND id = $Id \n";

        $DBObject->Do(
            SQL => 'UPDATE dynamic_field_value SET value_text = NULL, value_int = ? WHERE field_id = ? AND id = ?',
            Bind => [ \$ValueText, \$FieldId, \$Id ],
        );
    }

    return;
}


sub _GetOTOBOAGentsDFs {

    my ( $Self, %Param ) = @_;

    my $DBObject        = $Param{'DBObject'};
    my $OTOBOAgentsType = 'OTOBOAgents';

    my @Result;
    $DBObject->Prepare(
        SQL  => 'SELECT id, internal_field, name, label, field_order, field_type, object_type, config, valid_id, change_time, change_by FROM dynamic_field WHERE field_type = ?',
        Bind => [ \$OTOBOAgentsType ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Result, \@Row;
    }

    return @Result;
}

sub _HasOTOBOAgentsDynamicFields {

    my ( $Self, %Param ) = @_;

    my $DBObject        = $Param{'DBObject'};
    my $OTOBOAgentsType = 'OTOBOAgents';

    $DBObject->Prepare(
        SQL  => 'SELECT COUNT(id) FROM dynamic_field WHERE field_type = ?',
        Bind => [ \$OTOBOAgentsType ],
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {

        my $Count = $Row[0];
        return $Count;
    }

    return 0;
}

sub _ReportError {

    my ( $Self, %Param ) = @_;

    my $Message = $Param{'Message'};

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Message,
    );

    return;
}

1;
