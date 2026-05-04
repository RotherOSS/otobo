# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::StandardTemplate;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::StandardTemplate - standard template lib

=head1 DESCRIPTION

All standard template functions. E. g. to add standard template or other functions.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 StandardTemplateAdd()

add new standard template

    my $ID = $StandardTemplateObject->StandardTemplateAdd(
        Name         => 'New Standard Template',
        Comment      => 'Some comment.',
        Template     => 'Thank you for your email.',
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',                     # or 'Forward' or 'Create'
        ValidID      => 1,
        UserID       => 123,
    );

=cut

sub StandardTemplateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Template ContentType UserID TemplateType)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check if a standard template with this name already exists
    if ( $Self->NameExistsCheck( Name => $Param{Name} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A standard template with the name '$Param{Name}' already exists.",
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO standard_template (name, valid_id, comments, text,
                content_type, create_time, create_by, change_time, change_by, template_type)
            VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?, ?)',
        Bind => [
            \$Param{Name},        \$Param{ValidID}, \$Param{Comment}, \$Param{Template},
            \$Param{ContentType}, \$Param{UserID},  \$Param{UserID},  \$Param{TemplateType},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM standard_template WHERE name = ? AND change_by = ?',
        Bind => [ \$Param{Name}, \$Param{UserID}, ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # clear queue cache, due to Queue <-> Template relations
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Queue',
    );

    return $ID;
}

=head2 StandardTemplateGet()

get standard template attributes

    my %StandardTemplate = $StandardTemplateObject->StandardTemplateGet(
        ID => 123,
    );

Returns:

    %StandardTemplate = (
        ID                       => '123',
        Name                     => 'Simple remplate',
        Comment                  => 'Some comment',
        Template                 => 'Template content',
        ContentType              => 'text/plain',
        TemplateType             => 'Answer',
        PreSelectedTicketStateID => '2',
        ValidID                  => '1',
        CreateTime               => '2010-04-07 15:41:15',
        CreateBy                 => '321',
        ChangeTime               => '2010-04-07 15:59:45',
        ChangeBy                 => '223',
    );

=cut

sub StandardTemplateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!'
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => '
            SELECT name, valid_id, preselected_ticket_state_id, comments, text, content_type,
                create_time, create_by, change_time, change_by ,template_type
            FROM standard_template
            WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        %Data = (
            ID                       => $Param{ID},
            Name                     => $Data[0],
            Comment                  => $Data[3],
            Template                 => $Data[4],
            ContentType              => $Data[5] || 'text/plain',
            PreSelectedTicketStateID => $Data[2],
            ValidID                  => $Data[1],
            CreateTime               => $Data[6],
            CreateBy                 => $Data[7],
            ChangeTime               => $Data[8],
            ChangeBy                 => $Data[9],
            TemplateType             => $Data[10],
        );
    }

    return %Data;
}

=head2 StandardTemplateDelete()

delete a standard template

    $StandardTemplateObject->StandardTemplateDelete(
        ID => 123,
    );

=cut

sub StandardTemplateDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!'
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete queue<->std template relation
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM queue_standard_template WHERE standard_template_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete attachment<->std template relation
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM standard_template_attachment WHERE standard_template_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # sql
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM standard_template WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # clear queue cache, due to Queue <-> Template relations
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Queue',
    );

    return 1;
}

=head2 StandardTemplateUpdate()

update standard template attributes

    $StandardTemplateObject->StandardTemplateUpdate(
        ID                       => 123,
        Name                     => 'New Standard Template',
        Comment                  => 'Some comment.',
        Template                 => 'Thank you for your email.',
        ContentType              => 'text/plain; charset=utf-8',
        TemplateType             => 'Answer',
        PreSelectedTicketStateID => 2, (optional, will be set to null otherwise)
        ValidID                  => 1,
        UserID                   => 123,
    );

=cut

sub StandardTemplateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ID Name ValidID TemplateType ContentType UserID TemplateType)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( !$Param{PreSelectedTicketStateID} ) {
        $Param{PreSelectedTicketStateID} = undef;
    }

    # check if a standard template with this name already exists
    if (
        $Self->NameExistsCheck(
            Name => $Param{Name},
            ID   => $Param{ID}
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A standard template with the name '$Param{Name}' already exists.",
        );
        return;
    }

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE standard_template
            SET name = ?, text = ?, content_type = ?, comments = ?, valid_id = ?, preselected_ticket_state_id = ?,
                change_time = current_timestamp, change_by = ? ,template_type = ?
            WHERE id = ?',
        Bind => [
            \$Param{Name},    \$Param{Template}, \$Param{ContentType},  \$Param{Comment}, \$Param{PreSelectedTicketStateID},
            \$Param{ValidID}, \$Param{UserID},   \$Param{TemplateType}, \$Param{ID},
        ],
    );

    # clear queue cache, due to Queue <-> Template relations
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Queue',
    );

    return 1;
}

=head2 StandardTemplateLookup()

return the name or the standard template id

    my $StandardTemplateName = $StandardTemplateObject->StandardTemplateLookup(
        StandardTemplateID => 123,
    );

    or

    my $StandardTemplateID = $StandardTemplateObject->StandardTemplateLookup(
        StandardTemplate => 'Std Template Name',
    );

=cut

sub StandardTemplateLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StandardTemplate} && !$Param{StandardTemplateID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no StandardTemplate or StandardTemplateID!'
        );
        return;
    }

    # check if we ask the same request?
    if ( $Param{StandardTemplateID} && $Self->{"StandardTemplateLookup$Param{StandardTemplateID}"} )
    {
        return $Self->{"StandardTemplateLookup$Param{StandardTemplateID}"};
    }
    if ( $Param{StandardTemplate} && $Self->{"StandardTemplateLookup$Param{StandardTemplate}"} ) {
        return $Self->{"StandardTemplateLookup$Param{StandardTemplate}"};
    }

    # get data
    my $SQL;
    my $Suffix;
    my @Bind;
    if ( $Param{StandardTemplate} ) {
        $Suffix = 'StandardTemplateID';
        $SQL    = 'SELECT id FROM standard_template WHERE name = ?';
        @Bind   = ( \$Param{StandardTemplate} );
    }
    else {
        $Suffix = 'StandardTemplate';
        $SQL    = 'SELECT name FROM standard_template WHERE id = ?';
        @Bind   = ( \$Param{StandardTemplateID} );
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {

        # store result
        $Self->{"StandardTemplate$Suffix"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"StandardTemplate$Suffix"} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix!"
        );
        return;
    }

    return $Self->{"StandardTemplate$Suffix"};
}

=head2 StandardTemplateList()

get all valid standard templates

    my %StandardTemplates = $StandardTemplateObject->StandardTemplateList();

Returns:
    %StandardTemplates = (
        1 => 'Some Name',
        2 => 'Some Name2',
        3 => 'Some Name3',
    );

get all standard templates

    my %StandardTemplates = $StandardTemplateObject->StandardTemplateList(
        Valid => 0,
    );

Returns:
    %StandardTemplates = (
        1 => 'Some Name',
        2 => 'Some Name2',
    );

get standard templates from a certain type
    my %StandardTemplates = $StandardTemplateObject->StandardTemplateList(
        Valid => 0,
        Type  => 'Answer',
    );

Returns:
    %StandardTemplates = (
        1 => 'Answer - Some Name',
    );

=cut

sub StandardTemplateList {
    my ( $Self, %Param ) = @_;

    my $Valid = 1;
    if ( defined $Param{Valid} && $Param{Valid} eq '0' ) {
        $Valid = 0;
    }

    my $SQL = '
        SELECT id, name
        FROM standard_template';

    if ($Valid) {
        $SQL .= ' WHERE valid_id IN (' . join ', ',
            $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() . ')';
    }

    my @Bind;
    if ( defined $Param{Type} && $Param{Type} ne '' ) {
        if ($Valid) {
            $SQL .= ' AND';
        }
        else {
            $SQL .= ' WHERE';
        }
        $SQL .= ' template_type = ?';
        push @Bind, \$Param{Type};
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    return %Data;
}

=head2 NameExistsCheck()

    return 1 if another standard template with this name already exists

        $Exist = $StandardTemplateObject->NameExistsCheck(
            Name => 'Some::Template',
            ID => 1, # optional
        );

=cut

sub NameExistsCheck {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM standard_template WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );

    # fetch the result
    my $Flag;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( !$Param{ID} || $Param{ID} ne $Row[0] ) {
            $Flag = 1;
        }
    }
    if ($Flag) {
        return 1;
    }
    return 0;
}

=head2 ExportTemplates()

Returns data structures ready for export for each template. Optionally filterable by giving a list of desired templates.

    my $ExportData = $StandardTemplateObject->ExportTemplates(
        Templates => [          # (optional) restrict templates to given ones
            'TemplateName01',
            'TemplateName02'
        ],
    );

=cut

sub ExportTemplates {
    my ( $Self, %Param ) = @_;

    my %TemplateFilter;
    if ( IsArrayRefWithData( $Param{Templates} ) ) {
        %TemplateFilter = map { $_ => 1 } $Param{Templates}->@*;
    }

    # get necessary objects
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    # fetch lookup lists
    my %TemplateList = $Self->StandardTemplateList(
        Valid => 0,
    );

    my %ExportData;
    TEMPLATEID:
    for my $TemplateID ( sort keys %TemplateList ) {

        my %TemplateData = $Self->StandardTemplateGet(
            ID => $TemplateID,
        );

        if (%TemplateFilter) {
            next TEMPLATEID unless $TemplateFilter{ $TemplateData{Name} };
        }

        # translate IDs into names or name-like identifiers
        ATTRIBUTE:
        for my $Attribute ( keys %TemplateData ) {

            next ATTRIBUTE unless $Attribute =~ /ID/;

            if ( $Attribute eq 'ValidID' ) {
                my $Valid = $ValidObject->ValidLookup(
                    ValidID => $TemplateData{ValidID},
                );
                $TemplateData{Valid} = $Valid;
                delete $TemplateData{ValidID};
            }
        }

        # delete unneeded attributes to avoid bloating the export
        delete $TemplateData{ChangeBy};
        delete $TemplateData{ChangeTime};
        delete $TemplateData{CreateBy};
        delete $TemplateData{CreateTime};
        delete $TemplateData{ID};

        $ExportData{ $TemplateData{Name} } = \%TemplateData;
    }

    return \%ExportData;
}

=head2 ImportTemplates()

Imports new templates and optionally updates existing ones.

    my $Success = $StandardTemplateObject->ImportTemplates(
        Templates             => {
            'TemplateName01' => {
                # Template data
            },
            'TemplateName02' => {
                # Template data
            },
        },
        OverwriteExistingEntities => (0|1),
        UserID                    => 1,
    );

=cut

sub ImportTemplates {
    my ( $Self, %Param ) = @_;

    my $UserID = $Self->{UserID} || $Param{UserID};

    # get necessary objects
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    # fetch lookup lists
    my %TemplateList = $Self->StandardTemplateList(
        Valid => 0,
    );
    my %TemplateLookup = reverse %TemplateList;

    TEMPLATENAME:
    for my $TemplateName ( keys $Param{Templates}->%* ) {
        my $TemplateData = $Param{Templates}{$TemplateName};

        my $TemplateID = $TemplateLookup{ $TemplateData->{Name} };

        # skip if template with same name exists and overwrite is not set
        next TEMPLATENAME if ( !$Param{OverwriteExistingEntities} && $TemplateID );

        # translate named data back to IDs
        $TemplateData->{ValidID} = $ValidObject->ValidLookup(
            Valid => $TemplateData->{Valid},
        );

        # update
        if ($TemplateID) {
            my $Success = $Self->StandardTemplateUpdate(
                $TemplateData->%*,
                ID     => $TemplateID,
                UserID => $UserID,
            );
            return unless $Success;
        }

        # create
        else {
            my $TemplateID = $Self->StandardTemplateAdd(
                $TemplateData->%*,
                UserID => $UserID,
            );
            return unless $TemplateID;
        }
    }

    return 1;
}

1;
