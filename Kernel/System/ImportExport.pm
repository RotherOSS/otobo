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

package Kernel::System::ImportExport;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Try::Tiny;

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::Config',
    'Kernel::System::CheckItem',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ImportExport - import, export lib

=head1 DESCRIPTION

All import and export functions.

=head1 PUBLIC INTERFACE

=cut

=head2 new()

Create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 TemplateList()

Return a list of templates as array reference

    my $TemplateList = $ImportExportObject->TemplateList(
        Object => 'Ticket',  # (optional)
        Format => 'CSV'      # (optional)
        UserID => 1,
    );

=cut

sub TemplateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return;
    }

    # create sql string
    my $SQL = 'SELECT id FROM imexport_template WHERE 1=1 ';
    my @BIND;

    if ( $Param{Object} ) {
        $SQL .= 'AND imexport_object = ? ';
        push @BIND, \$Param{Object};
    }
    if ( $Param{Format} ) {
        $SQL .= 'AND imexport_format = ? ';
        push @BIND, \$Param{Format};
    }

    # add order option
    $SQL .= 'ORDER BY id';

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    my @TemplateList = $DBObject->SelectColArray(
        SQL  => $SQL,
        Bind => \@BIND,
    );

    return \@TemplateList;
}

=head2 TemplateGet()

Get a import export template as a hashref.

    my $TemplateData = $ImportExportObject->TemplateGet(
        TemplateID => 3,
        UserID     => 1,
    );

Returns:

    $TemplateData{TemplateID}
    $TemplateData{Number}
    $TemplateData{Object}
    $TemplateData{Format}
    $TemplateData{Name}
    $TemplateData{ValidID}
    $TemplateData{Comment}
    $TemplateData{CreateTime}
    $TemplateData{CreateBy}
    $TemplateData{ChangeTime}
    $TemplateData{ChangeBy}

=cut

sub TemplateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # check if result is already cached
    return $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} }
        if $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} };

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    my @Row = $DBObject->SelectRowArray(
        SQL => 'SELECT id, imexport_object, imexport_format, name, valid_id, comments, '
            . 'create_time, create_by, change_time, change_by FROM imexport_template WHERE id = ?',
        Bind  => [ \$Param{TemplateID} ],
        Limit => 1,
    );

    my %TemplateData;
    $TemplateData{TemplateID} = $Row[0];
    $TemplateData{Object}     = $Row[1];
    $TemplateData{Format}     = $Row[2];
    $TemplateData{Name}       = $Row[3];
    $TemplateData{ValidID}    = $Row[4];
    $TemplateData{Comment}    = $Row[5] || '';
    $TemplateData{CreateTime} = $Row[6];
    $TemplateData{CreateBy}   = $Row[7];
    $TemplateData{ChangeTime} = $Row[8];
    $TemplateData{ChangeBy}   = $Row[9];

    $TemplateData{Number} = sprintf '%06d', $TemplateData{TemplateID};

    # cache the result
    $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} } = \%TemplateData;

    return \%TemplateData;
}

=head2 TemplateAdd()

Add a new import/export template

    my $TemplateID = $ImportExportObject->TemplateAdd(
        Object  => 'Ticket',
        Format  => 'CSV',
        Name    => 'Template Name',
        ValidID => 1,
        Comment => 'Comment',       # (optional)
        UserID  => 1,
    );

=cut

sub TemplateAdd {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(Object Format Name ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # set default values
    $Param{Comment} ||= '';

    # get CheckItem object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # cleanup given params
    for my $Argument (qw(Object Format)) {
        $CheckItemObject->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        );
    }
    for my $Argument (qw(Name Comment)) {
        $CheckItemObject->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # find exiting template with same name
    $DBObject->Prepare(
        SQL   => 'SELECT id FROM imexport_template WHERE imexport_object = ? AND name = ?',
        Bind  => [ \$Param{Object}, \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $NoAdd;
    while ( $DBObject->FetchrowArray() ) {
        $NoAdd = 1;
    }

    # abort insert of new template, if template name already exists
    if ($NoAdd) {
        $LogObject->Log(
            Priority => 'error',
            Message  =>
                "Can't add new template! Template with same name already exists in this object.",
        );

        return;
    }

    # insert new template
    return unless $DBObject->Do(
        SQL => <<'END_SQL',
INSERT INTO imexport_template (
    imexport_object, imexport_format, name, valid_id, comments,
    create_time, create_by, change_time, change_by
  )
  VALUES (
    ?, ?, ?, ?, ?,
    current_timestamp, ?, current_timestamp, ?
  )
END_SQL
        Bind => [
            \$Param{Object}, \$Param{Format}, \$Param{Name}, \$Param{ValidID}, \$Param{Comment},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # find id of new template
    # TODO: use the insert_id when that functionality becomes available
    my ($TemplateID) = $DBObject->SelectRowArray(
        SQL   => 'SELECT id FROM imexport_template WHERE imexport_object = ? AND name = ?',
        Bind  => [ \$Param{Object}, \$Param{Name} ],
        Limit => 1,
    );

    return $TemplateID;
}

=head2 TemplateUpdate()

Update a existing import/export template

    my $True = $ImportExportObject->TemplateUpdate(
        TemplateID => 123,
        Name       => 'Template Name',
        ValidID    => 1,
        Comment    => 'Comment',        # (optional)
        UserID     => 1,
    );

=cut

sub TemplateUpdate {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID Name ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # set default values
    $Param{Comment} ||= '';

    # cleanup given params
    for my $Argument (qw(Name Comment)) {
        $Kernel::OM->Get('Kernel::System::CheckItem')->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get the object of this template id
    $DBObject->Prepare(
        SQL   => 'SELECT imexport_object FROM imexport_template WHERE id = ?',
        Bind  => [ \$Param{TemplateID} ],
        Limit => 1,
    );

    # fetch the result
    my $Object;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Object = $Row[0];
    }

    if ( !$Object ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Can't update template because it hasn't been found!",
        );

        return;
    }

    # find exiting template with same name
    $DBObject->Prepare(
        SQL   => 'SELECT id FROM imexport_template WHERE imexport_object = ? AND name = ?',
        Bind  => [ \$Object, \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $Update = 1;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Param{TemplateID} ne $Row[0] ) {
            $Update = 0;
        }
    }

    if ( !$Update ) {
        $LogObject->Log(
            Priority => 'error',
            Message  =>
                "Can't update template! Template with same name already exists in this object.",
        );

        return;
    }

    # reset cache
    delete $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} };

    # update template
    return $DBObject->Do(
        SQL => 'UPDATE imexport_template SET name = ?,'
            . 'valid_id = ?, comments = ?, '
            . 'change_time = current_timestamp, change_by = ? '
            . 'WHERE id = ?',
        Bind => [
            \$Param{Name},   \$Param{ValidID}, \$Param{Comment},
            \$Param{UserID}, \$Param{TemplateID},
        ],
    );
}

=head2 TemplateDelete()

Delete existing import/export templates

    my $True = $ImportExportObject->TemplateDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->TemplateDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub TemplateDelete {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( !ref $Param{TemplateID} ) {
        $Param{TemplateID} = [ $Param{TemplateID} ];
    }
    elsif ( ref $Param{TemplateID} ne 'ARRAY' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'TemplateID must be an array reference or a string!',
        );

        return;
    }

    # delete existing search data
    $Self->SearchDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # delete all mapping data
    for my $TemplateID ( @{ $Param{TemplateID} } ) {
        $Self->MappingDelete(
            TemplateID => $TemplateID,
            UserID     => $Param{UserID},
        );
    }

    # delete existing format data
    $Self->FormatDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # delete existing object data
    $Self->ObjectDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # create the template id string
    my $TemplateIDString = join q{, }, map {'?'} @{ $Param{TemplateID} };

    # create and add bind parameters
    my @BIND = map { \$_ } @{ $Param{TemplateID} };

    # reset cache
    delete $Self->{Cache}->{TemplateGet};

    # delete templates
    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "DELETE FROM imexport_template WHERE id IN ( $TemplateIDString )",
        Bind => \@BIND,
    );
}

=head2 ObjectList()

Return a list of available objects as hash reference.

    my $ObjectList = $ImportExportObject->ObjectList();

Return an empty list when there is no, or an incorrect, setting in the SysConfig.

=cut

sub ObjectList {
    my ($Self) = @_;

    # get the backend registrations which have been added by other OTOBO packages
    my $ModuleList = $Kernel::OM->Get('Kernel::Config')->Get('ImportExport::ObjectBackendRegistration');

    return unless $ModuleList;
    return unless ref $ModuleList eq 'HASH';

    # create the object list, may be empty
    my %Key2Name =
        map { $_ => $ModuleList->{$_}->{Name} }
        keys $ModuleList->%*;

    return \%Key2Name;
}

=head2 ObjectAttributesGet()

Get the attributes of an object backend as array/hash reference

    my $Attributes = $ImportExportObject->ObjectAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub ObjectAttributesGet {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load backend
    my $Backend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::ObjectBackend::' . $TemplateData->{Object}
    );

    return unless $Backend;

    # get an attribute list of the object
    my $Attributes = $Backend->ObjectAttributesGet(
        UserID => $Param{UserID},
    );

    return $Attributes;
}

=head2 ObjectDataGet()

Get the object data from a template

    my $ObjectDataRef = $ImportExportObject->ObjectDataGet(
        TemplateID => 3,
        UserID     => 1,
    );

=cut

sub ObjectDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database, may be empty
    my %ObjectData = $DBObject->SelectMapping(
        SQL => <<'END_SQL',
SELECT data_key, data_value
  FROM imexport_object
  WHERE template_id = ?
END_SQL
        Bind => [ \$Param{TemplateID} ],
    );

    return \%ObjectData;
}

=head2 ObjectDataSave()

Save the object data of a template

    my $True = $ImportExportObject->ObjectDataSave(
        TemplateID => 123,
        ObjectData => $HashRef,
        UserID     => 1,
    );

=cut

sub ObjectDataSave {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID ObjectData UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( ref $Param{ObjectData} ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'ObjectData must be a hash reference!',
        );

        return;
    }

    # delete existing object data
    $Self->ObjectDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( sort keys %{ $Param{ObjectData} } ) {

        my $DataValue = $Param{ObjectData}->{$DataKey};

        next DATAKEY if !defined $DataKey;
        next DATAKEY if !defined $DataValue;

        # insert one row
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => 'INSERT INTO imexport_object '
                . '(template_id, data_key, data_value) VALUES '
                . '(?, ?, ?)',
            Bind => [ \$Param{TemplateID}, \$DataKey, \$DataValue ],
        );
    }

    return 1;
}

=head2 ObjectDataDelete()

Delete the existing object data of a template

    my $True = $ImportExportObject->ObjectDataDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->ObjectDataDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub ObjectDataDelete {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( !ref $Param{TemplateID} ) {
        $Param{TemplateID} = [ $Param{TemplateID} ];
    }
    elsif ( ref $Param{TemplateID} ne 'ARRAY' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'TemplateID must be an array reference or a string!',
        );

        return;
    }

    # create the template id string
    my $TemplateIDString = join q{, }, map {'?'} @{ $Param{TemplateID} };

    # create and add bind parameters
    my @BIND = map { \$_ } @{ $Param{TemplateID} };

    # delete templates
    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "DELETE FROM imexport_object WHERE template_id IN ( $TemplateIDString )",
        Bind => \@BIND,
    );
}

=head2 FormatList()

Return a list of available formats as hash reference.

    my $FormatList = $ImportExportObject->FormatList();

=cut

sub FormatList {
    my ( $Self, %Param ) = @_;

    # get the registered formatting backends, e.g. for CSV
    my $ModuleList = $Kernel::OM->Get('Kernel::Config')->Get('ImportExport::FormatBackendRegistration');

    return unless $ModuleList;
    return unless ref $ModuleList eq 'HASH';

    # create the format list, may be empty
    my %Key2Name =
        map { $_ => $ModuleList->{$_}->{Name} }
        keys $ModuleList->%*;

    return \%Key2Name;
}

=head2 FormatterCanHandleReferences()

Inform the caller whether the formatter backend needs help with references.

    my $FormatterCanHandleReferences = $ImportExportObject->FormatterCanHandleReferences(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub FormatterCanHandleReferences {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Format} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load backend
    my $FormatBackend = try {
        $Kernel::OM->Get( 'Kernel::System::ImportExport::FormatBackend::' . $TemplateData->{Format} );
    }
    catch {
        # ignore exception
        undef;
    };

    return unless $FormatBackend;

    # delegate to the formatter backend
    return $FormatBackend->CanHandleReferences(
        UserID => $Param{UserID},
    );
}

=head2 FormatAttributesGet()

Get the attributes of a format backend as array/hash reference

    my $Attributes = $ImportExportObject->FormatAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub FormatAttributesGet {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Format} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load backend
    my $Backend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::FormatBackend::' . $TemplateData->{Format}
    );

    return unless $Backend;

    # delegate to the formatter backend
    return $Backend->FormatAttributesGet(
        UserID => $Param{UserID},
    );
}

=head2 FormatDataGet()

Get the format data from a template

    my $FormatDataRef = $ImportExportObject->FormatDataGet(
        TemplateID => 3,
        UserID     => 1,
    );

=cut

sub FormatDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    $DBObject->Prepare(
        SQL  => 'SELECT data_key, data_value FROM imexport_format WHERE template_id = ?',
        Bind => [ \$Param{TemplateID} ],
    );

    # fetch the result
    my %FormatData;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $FormatData{ $Row[0] } = $Row[1];
    }

    return \%FormatData;
}

=head2 FormatDataSave()

Save the format data of a template

    my $True = $ImportExportObject->FormatDataSave(
        TemplateID => 123,
        FormatData => $HashRef,
        UserID     => 1,
    );

=cut

sub FormatDataSave {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID FormatData UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( ref $Param{FormatData} ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'FormatData must be a hash reference!',
        );

        return;
    }

    # delete existing format data
    $Self->FormatDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( sort keys %{ $Param{FormatData} } ) {

        my $DataValue = $Param{FormatData}->{$DataKey};

        next DATAKEY if !defined $DataKey;
        next DATAKEY if !defined $DataValue;

        # insert one row
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => 'INSERT INTO imexport_format '
                . '(template_id, data_key, data_value) VALUES (?, ?, ?)',
            Bind => [ \$Param{TemplateID}, \$DataKey, \$DataValue ],
        );
    }

    return 1;
}

=head2 FormatDataDelete()

Delete the existing format data of a template

    my $True = $ImportExportObject->FormatDataDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->FormatDataDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub FormatDataDelete {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( !ref $Param{TemplateID} ) {
        $Param{TemplateID} = [ $Param{TemplateID} ];
    }
    elsif ( ref $Param{TemplateID} ne 'ARRAY' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'TemplateID must be an array reference or a string!',
        );

        return;
    }

    # create the template id string
    my $TemplateIDString = join q{, }, map {'?'} @{ $Param{TemplateID} };

    # create and add bind parameters
    my @BIND = map { \$_ } @{ $Param{TemplateID} };

    # delete templates
    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "DELETE FROM imexport_format WHERE template_id IN ( $TemplateIDString )",
        Bind => \@BIND,
    );
}

=head2 MappingList()

Return a list of mapping IDs sorted by position as array reference

    my $MappingIDs = $ImportExportObject->MappingList(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # ask database
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @MappingIDs = $DBObject->SelectColArray(
        SQL => <<'END_SQL',
SELECT id
  FROM imexport_mapping
  WHERE template_id = ?
  ORDER BY position
END_SQL
        Bind => [ \$Param{TemplateID} ],
    );

    return \@MappingIDs;
}

=head2 MappingAdd()

Add a new mapping data row

    my $MappingID = $ImportExportObject->MappingAdd(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # find maximum position
    $DBObject->Prepare(
        SQL   => 'SELECT max(position) FROM imexport_mapping WHERE template_id = ?',
        Bind  => [ \$Param{TemplateID} ],
        Limit => 1,
    );

    # fetch the result
    my $NewPosition = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if ( defined $Row[0] ) {
            $NewPosition = $Row[0];
            $NewPosition++;
        }
    }

    # insert a new mapping data row
    return if !$DBObject->Do(
        SQL  => 'INSERT INTO imexport_mapping (template_id, position) VALUES (?, ?)',
        Bind => [ \$Param{TemplateID}, \$NewPosition ],
    );

    # find id of new mapping data row
    $DBObject->Prepare(
        SQL   => 'SELECT id FROM imexport_mapping WHERE template_id = ? AND position = ?',
        Bind  => [ \$Param{TemplateID}, \$NewPosition ],
        Limit => 1,
    );

    # fetch the result
    my $MappingID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $MappingID = $Row[0];
    }

    return $MappingID;
}

=head2 MappingDelete()

Delete existing mapping data rows

    my $True = $ImportExportObject->MappingDelete(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->MappingDelete(
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( defined $Param{MappingID} ) {

        # delete existing object mapping data
        $Self->MappingObjectDataDelete(
            MappingID => $Param{MappingID},
            UserID    => $Param{UserID},
        );

        # delete existing format mapping data
        $Self->MappingFormatDataDelete(
            MappingID => $Param{MappingID},
            UserID    => $Param{UserID},
        );

        # delete one mapping row
        $DBObject->Do(
            SQL  => 'DELETE FROM imexport_mapping WHERE id = ?',
            Bind => [ \$Param{MappingID} ],
        );

        # rebuild mapping positions
        $Self->MappingPositionRebuild(
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );

        return 1;
    }
    else {

        # get mapping list
        my $MappingIDs = $Self->MappingList(
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );

        for my $MappingID ( $MappingIDs->@* ) {

            # delete existing object mapping data
            $Self->MappingObjectDataDelete(
                MappingID => $MappingID,
                UserID    => $Param{UserID},
            );

            # delete existing format mapping data
            $Self->MappingFormatDataDelete(
                MappingID => $MappingID,
                UserID    => $Param{UserID},
            );
        }

        # delete all mapping rows of this template
        return $DBObject->Do(
            SQL  => 'DELETE FROM imexport_mapping WHERE template_id = ?',
            Bind => [ \$Param{TemplateID} ],
        );
    }
}

=head2 MappingUp()

Move an mapping data row up

    my $True = $ImportExportObject->MappingUp(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingUp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get mapping data list
    my $MappingIDs = $Self->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return 1 if $Param{MappingID} == $MappingIDs->[0];

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    $DBObject->Prepare(
        SQL  => 'SELECT position FROM imexport_mapping WHERE id = ?',
        Bind => [ \$Param{MappingID} ],
    );

    # fetch the result
    my $Position;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Position = $Row[0];
    }

    return 1 if !$Position;

    my $PositionUpper = $Position - 1;

    # update positions
    $DBObject->Do(
        SQL  => 'UPDATE imexport_mapping SET position = ? WHERE template_id = ? AND position = ?',
        Bind => [ \$Position, \$Param{TemplateID}, \$PositionUpper ],
    );
    $DBObject->Do(
        SQL  => 'UPDATE imexport_mapping SET position = ? WHERE id = ?',
        Bind => [ \$PositionUpper, \$Param{MappingID} ],
    );

    return 1;
}

=head2 MappingDown()

Move an mapping data row down

    my $True = $ImportExportObject->MappingDown(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingDown {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get mapping data list
    my $MappingIDs = $Self->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return 1 if $Param{MappingID} == $MappingIDs->[-1];

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    $DBObject->Prepare(
        SQL  => 'SELECT position FROM imexport_mapping WHERE id = ?',
        Bind => [ \$Param{MappingID} ],
    );

    # fetch the result
    my $Position;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Position = $Row[0];
    }

    my $PositionDown = $Position + 1;

    # update positions
    $DBObject->Do(
        SQL  => 'UPDATE imexport_mapping SET position = ? WHERE template_id = ? AND position = ?',
        Bind => [ \$Position, \$Param{TemplateID}, \$PositionDown ],
    );
    $DBObject->Do(
        SQL  => 'UPDATE imexport_mapping SET position = ? WHERE id = ?',
        Bind => [ \$PositionDown, \$Param{MappingID} ],
    );

    return 1;
}

=head2 MappingPositionRebuild()

Rebuild the positions of a mapping list

    my $True = $ImportExportObject->MappingPositionRebuild(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingPositionRebuild {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get mapping data list
    my $MappingIDs = $Self->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # update position
    my $Counter = 0;
    for my $MappingID ( $MappingIDs->@* ) {
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => 'UPDATE imexport_mapping SET position = ? WHERE id = ?',
            Bind => [ \$Counter, \$MappingID ],
        );
        $Counter++;
    }

    return 1;
}

=head2 MappingObjectAttributesGet()

Get the attributes of an object backend as array/hash reference

    my $Attributes = $ImportExportObject->MappingObjectAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingObjectAttributesGet {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load backend
    my $Backend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::ObjectBackend::' . $TemplateData->{Object}
    );

    return unless $Backend;

    # get an attribute list of the object
    my $Attributes = $Backend->MappingObjectAttributesGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return $Attributes;
}

=head2 MappingObjectDataDelete()

Delete the existing object data of a mapping

    my $True = $ImportExportObject->MappingObjectDataDelete(
        MappingID => 123,
        UserID    => 1,
    );

    or

    my $True = $ImportExportObject->MappingObjectDataDelete(
        MappingID => [1,44,166,5],
        UserID    => 1,
    );

=cut

sub MappingObjectDataDelete {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( !ref $Param{MappingID} ) {
        $Param{MappingID} = [ $Param{MappingID} ];
    }
    elsif ( ref $Param{MappingID} ne 'ARRAY' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'MappingID must be an array reference or a string!',
        );

        return;
    }

    # create the template id string
    my $MappingIDString = join q{, }, map {'?'} @{ $Param{MappingID} };

    # create and add bind parameters
    my @BIND = map { \$_ } @{ $Param{MappingID} };

    # delete mapping object data
    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "DELETE FROM imexport_mapping_object WHERE mapping_id IN ( $MappingIDString )",
        Bind => \@BIND,
    );
}

=head2 MappingObjectDataSave()

Save the object data of a mapping

    my $True = $ImportExportObject->MappingObjectDataSave(
        MappingID         => 123,
        MappingObjectData => $HashRef,
        UserID            => 1,
    );

=cut

sub MappingObjectDataSave {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(MappingID MappingObjectData UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( ref $Param{MappingObjectData} ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'MappingObjectData must be a hash reference!',
        );

        return;
    }

    # delete existing object mapping data
    $Self->MappingObjectDataDelete(
        MappingID => $Param{MappingID},
        UserID    => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( sort keys %{ $Param{MappingObjectData} } ) {

        my $DataValue = $Param{MappingObjectData}->{$DataKey};

        next DATAKEY if !defined $DataKey;
        next DATAKEY if !defined $DataValue;

        # insert one mapping object row
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => 'INSERT INTO imexport_mapping_object '
                . '(mapping_id, data_key, data_value) VALUES (?, ?, ?)',
            Bind => [ \$Param{MappingID}, \$DataKey, \$DataValue ],
        );
    }

    return 1;
}

=head2 MappingObjectDataGet()

gets the object data of a mapping.

    my $MappingObjectData = $ImportExportObject->MappingObjectDataGet(
        MappingID => 123,
        UserID    => 1,
    );

Returns:

    $MappingObjectData =

=cut

sub MappingObjectDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # ask database
    my %MappingObjectData = $Kernel::OM->Get('Kernel::System::DB')->SelectMapping(
        SQL => <<'END_SQL',
SELECT data_key, data_value
  FROM imexport_mapping_object
  WHERE mapping_id = ?
END_SQL
        Bind => [ \$Param{MappingID} ],
    );

    return \%MappingObjectData;
}

=head2 MappingFormatAttributesGet()

Get the attributes of an format backend as array/hash reference

    my $Attributes = $ImportExportObject->MappingFormatAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingFormatAttributesGet {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Format} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load backend
    my $Backend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::FormatBackend::' . $TemplateData->{Format}
    );

    return unless $Backend;

    # get an attribute list of the format
    my $Attributes = $Backend->MappingFormatAttributesGet(
        UserID => $Param{UserID},
    );

    return $Attributes;
}

=head2 MappingFormatDataDelete()

Delete the existing format data of a mapping

    my $True = $ImportExportObject->MappingFormatDataDelete(
        MappingID => 123,
        UserID    => 1,
    );

    or

    my $True = $ImportExportObject->MappingFormatDataDelete(
        MappingID => [1,44,166,5],
        UserID    => 1,
    );

=cut

sub MappingFormatDataDelete {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( !ref $Param{MappingID} ) {
        $Param{MappingID} = [ $Param{MappingID} ];
    }
    elsif ( ref $Param{MappingID} ne 'ARRAY' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'MappingID must be an array reference or a string!',
        );

        return;
    }

    # create the template id string
    my $MappingIDString = join q{, }, map {'?'} @{ $Param{MappingID} };

    # create and add bind parameters
    my @BIND = map { \$_ } @{ $Param{MappingID} };

    # delete mapping format data
    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "DELETE FROM imexport_mapping_format WHERE mapping_id IN ( $MappingIDString )",
        Bind => \@BIND,
    );
}

=head2 MappingFormatDataSave()

Save the format data of a mapping

    my $True = $ImportExportObject->MappingFormatDataSave(
        MappingID         => 123,
        MappingFormatData => $HashRef,
        UserID            => 1,
    );

=cut

sub MappingFormatDataSave {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(MappingID MappingFormatData UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( ref $Param{MappingFormatData} ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'MappingFormatData must be a hash reference!',
        );

        return;
    }

    # delete existing format mapping data
    $Self->MappingFormatDataDelete(
        MappingID => $Param{MappingID},
        UserID    => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( sort keys %{ $Param{MappingFormatData} } ) {

        my $DataValue = $Param{MappingFormatData}->{$DataKey};

        next DATAKEY if !defined $DataKey;
        next DATAKEY if !defined $DataValue;

        # insert one mapping format row
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => 'INSERT INTO imexport_mapping_format '
                . '(mapping_id, data_key, data_value) VALUES (?, ?, ?)',
            Bind => [ \$Param{MappingID}, \$DataKey, \$DataValue ],
        );
    }

    return 1;
}

=head2 MappingFormatDataGet()

Get the format data of a mapping

    my $ObjectDataRef = $ImportExportObject->MappingFormatDataGet(
        MappingID => 123,
        UserID    => 1,
    );

=cut

sub MappingFormatDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    $DBObject->Prepare(
        SQL  => 'SELECT data_key, data_value FROM imexport_mapping_format WHERE mapping_id = ?',
        Bind => [ \$Param{MappingID} ],
    );

    # fetch the result
    my %MappingFormatData;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $MappingFormatData{ $Row[0] } = $Row[1];
    }

    return \%MappingFormatData;
}

=head2 SearchAttributesGet()

gets the search attributes of an object backend as a reference to an array of hash references.

    my $Attributes = $ImportExportObject->SearchAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub SearchAttributesGet {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load backend
    my $Backend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::ObjectBackend::' . $TemplateData->{Object}
    );

    return unless $Backend;

    # get an search attribute list of an object
    return $Backend->SearchAttributesGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );
}

=head2 SearchDataGet()

Get the search data from a template

    my $SearchDataRef = $ImportExportObject->SearchDataGet(
        TemplateID => 3,
        UserID     => 1,
    );

=cut

sub SearchDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    $DBObject->Prepare(
        SQL  => 'SELECT data_key, data_value FROM imexport_search WHERE template_id = ?',
        Bind => [ \$Param{TemplateID} ],
    );

    # fetch the result
    my %SearchData;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @{ $SearchData{ $Row[0] } }, $Row[1];
    }

# TODO: return and use arrays if the data contains arrays; there should be no reason for this #####-stuff, except backwards compatibility (also change in SearchDataSave())
    return { map { $_ => join( '#####', $SearchData{$_}->@* ) } keys %SearchData };
}

=head2 SearchDataSave()

Save the search data of a template

    my $True = $ImportExportObject->SearchDataSave(
        TemplateID => 123,
        SearchData => $HashRef,
        UserID     => 1,
    );

=cut

sub SearchDataSave {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID SearchData UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( ref $Param{SearchData} ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'SearchData must be a hash reference!',
        );

        return;
    }

    # delete existing search data
    $Self->SearchDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( sort keys %{ $Param{SearchData} } ) {

        # quote
        my $DataValue = $Param{SearchData}->{$DataKey};

        next DATAKEY if !$DataKey;
        next DATAKEY if !$DataValue;

        VALUE:
        for my $SingleValue ( split /#####/, $DataValue ) {
            next VALUE unless $SingleValue;    # TODO: why is '0' not allowed ?

            # insert one row
            $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => 'INSERT INTO imexport_search '
                    . '(template_id, data_key, data_value) VALUES (?, ?, ?)',
                Bind => [ \$Param{TemplateID}, \$DataKey, \$SingleValue ],
            );
        }
    }

    return 1;
}

=head2 SearchDataDelete()

Delete the existing search data of a template

    my $True = $ImportExportObject->SearchDataDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->SearchDataDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub SearchDataDelete {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( !ref $Param{TemplateID} ) {
        $Param{TemplateID} = [ $Param{TemplateID} ];
    }
    elsif ( ref $Param{TemplateID} ne 'ARRAY' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'TemplateID must be an array reference or a string!',
        );

        return;
    }

    # create the template id string
    my $TemplateIDString = join q{, }, map {'?'} @{ $Param{TemplateID} };

    # create and add bind parameters
    my @BIND = map { \$_ } @{ $Param{TemplateID} };

    # delete templates
    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "DELETE FROM imexport_search WHERE template_id IN ( $TemplateIDString )",
        Bind => \@BIND,
    );
}

=head2 Export()

Export function

    my $ResultRef = $ImportExportObject->Export(
        TemplateID => 123,
        UserID     => 1,
    );

returns something like

    $ResultRef = {
        Success   => 2,
        Failed    => 0,
        DestinationContent => [
            [ 'Attr_1a', 'Attr_1b', 'Attr_1c', ],
            [ 'Attr_2a', 'Attr_2b', 'Attr_3c', ],
        ],
    };

=cut

sub Export {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} || !$TemplateData->{Format} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load object backend
    my $ObjectBackend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::ObjectBackend::' . $TemplateData->{Object}
    );

    return unless $ObjectBackend;

    # load format backend
    my $FormatBackend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::FormatBackend::' . $TemplateData->{Format}
    );

    return unless $FormatBackend;

    # get export data,
    # passing the template ID gives the backend access to the mapping list
    # and to the export format.
    my $ExportData = $ObjectBackend->ExportDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # get format data
    my $FormatData = $Self->FormatDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # if column headers should be included in the export
    if ( $FormatData->{IncludeColumnHeaders} ) {

        # get object attributes (the name of the columns)
        my $MappingObjectAttributes = $Self->MappingObjectAttributesGet(
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );

        # create a lookup hash for the object attribute names
        my %AttributeLookup = map { $_->{Key} => $_->{Value} } @{ $MappingObjectAttributes->[0]->{Input}->{Data} };

        # get mapping data list
        my $MappingIDs = $Self->MappingList(
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );

        # get the column names
        my @ColumnNames;
        for my $MappingID ( $MappingIDs->@* ) {

            # get mapping object data
            my $MappingObjectData = $Self->MappingObjectDataGet(
                MappingID => $MappingID,
                UserID    => $Param{UserID},
            );

            # get the column name
            my $ColumnName = $AttributeLookup{ $MappingObjectData->{Key} };

            push @ColumnNames, $ColumnName;
        }

        # add column headers as first row
        unshift $ExportData->@*, \@ColumnNames;
    }

    my %Result = (
        Success            => 0,
        Failed             => 0,
        DestinationContent => [],
    );

    EXPORTDATAROW:
    for my $ExportDataRow ( @{$ExportData} ) {

        # export one row
        my $DestinationContentRow = $FormatBackend->ExportDataSave(
            TemplateID    => $Param{TemplateID},
            ExportDataRow => $ExportDataRow,
            UserID        => $Param{UserID},
        );

        if ( !defined $DestinationContentRow ) {
            $Result{Failed}++;

            next EXPORTDATAROW;
        }

        # add row to destination content
        push @{ $Result{DestinationContent} }, $DestinationContentRow;
        $Result{Success}++;
    }

    # writing the header line does not count a success
    if ( $FormatData->{IncludeColumnHeaders} ) {
        $Result{Success}--;
    }

    # log result
    $LogObject->Log(
        Priority => 'notice',
        Message  => "Export of $Result{Failed} records ($TemplateData->{Object}): failed!",
    );
    $LogObject->Log(
        Priority => 'notice',
        Message  => "Export of $Result{Success} records ($TemplateData->{Object}): successful!",
    );

    return \%Result;
}

=head2 Import()

Import function

    my $ResultRef = $ImportExportObject->Import(
        TemplateID    => 123,
        SourceContent => $StringRef,  # (optional)
        UserID        => 1,
    );

=cut

sub Import {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Disable the cache for faster import.
    $CacheObject->Configure(
        CacheInMemory  => 0,
        CacheInBackend => 0,
    );

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} || !$TemplateData->{Format} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} is incomplete!",
        );

        return;
    }

    # load object backend
    my $ObjectBackend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::ObjectBackend::' . $TemplateData->{Object}
    );

    return unless $ObjectBackend;

    # load format backend
    my $FormatBackend = $Kernel::OM->Get(
        'Kernel::System::ImportExport::FormatBackend::' . $TemplateData->{Format}
    );

    return unless $FormatBackend;

    # get import data
    my $ImportData = $FormatBackend->ImportDataGet(
        TemplateID    => $Param{TemplateID},
        SourceContent => $Param{SourceContent},
        UserID        => $Param{UserID},
    );

    return unless $ImportData;

    # get format data
    my $FormatData = $Self->FormatDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # if column headers are activated, the first row must be removed
    if ( $FormatData->{IncludeColumnHeaders} ) {
        shift @{$ImportData};
    }

    # Number of successfully and not successfully imported rows
    my %Result = (
        Object  => $TemplateData->{Object},
        Success => 0,
        Failed  => 0,
        RetCode => {},
        Counter => 0,
    );
    IMPORTDATAROW:
    for my $ImportDataRow ( $ImportData->@* ) {

        $Result{Counter}++;

        # import a single row
        my ( $ID, $RetCode ) = $ObjectBackend->ImportDataSave(
            TemplateID    => $Param{TemplateID},
            ImportDataRow => $ImportDataRow,
            Counter       => $Result{Counter},
            UserID        => $Param{UserID},
        );

        if ( !$ID ) {

            # count DuplicateName entries as errors
            if ( $RetCode && $RetCode =~ m{ \A DuplicateName }xms ) {
                $Result{RetCode}->{$RetCode}++;
            }
            $Result{Failed}++;
        }
        else {
            $Result{RetCode}->{$RetCode}++;
            $Result{Success}++;
        }
    }

    # log result
    $LogObject->Log(
        Priority => 'notice',
        Message  =>
            "Import of $Result{Counter} $Result{Object} records: "
            . "$Result{Failed} failed, $Result{Success} succeeded",
    );
    for my $RetCode ( sort keys %{ $Result{RetCode} } ) {
        my $Count = $Result{RetCode}->{$RetCode} || 0;
        $LogObject->Log(
            Priority => 'notice',
            Message  =>
                "Import of $Result{Counter} $Result{Object} records: $Count $RetCode",
        );
    }
    if ( $Result{Failed} ) {
        $LogObject->Log(
            Priority => 'notice',
            Message  => "Last processed line number of import file: $Result{Counter}",
        );
    }

    return \%Result;
}

1;
