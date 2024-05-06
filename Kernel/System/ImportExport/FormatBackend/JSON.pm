# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::ImportExport::FormatBackend::JSON;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::ImportExport',
    'Kernel::System::Log',
    'Kernel::System::JSON',
);

=head1 NAME

Kernel::System::ImportExport::FormatBackend::JSON - ImportExport format backend for JSON

=head1 DESCRIPTION

All functions to import and export a JSON formatted file.
Currently concatenated JSON is being exported.

=cut

=head2 new()

Create an object.

    my $ImportExportCSVBackendObject = $Kernel::OM->Get('Kernel::System::ImportExport::FormatBackend::CSV');

=cut

sub new {
    my ($Type) = @_;

    return bless {

        # The formatter handles references by itself.
        CanHandleReferences => 1,
    }, $Type;
}

=head2 CanHandleReferences()

Inform the caller whether data structures can be handled be the formatter.

    my $DoSerializeReferences = $FormatBackend->CanHandleReferences();

=cut

sub CanHandleReferences {
    my ($Self) = @_;

    return $Self->{CanHandleReferences};
}

=head2 FormatAttributesGet()

gets the format attributes of a format as reference to an array of hash references.

    my $Attributes = $FormatBackend->FormatAttributesGet(
        UserID => 1,
    );

=cut

sub FormatAttributesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return;
    }

    return [
        {
            Key   => 'Pretty',
            Name  => Translatable('Pretty print the exported concatenated JSON'),
            Input => {
                Type => 'Selection',
                Data => {
                    1 => Translatable('Yes'),    # pretty print per default
                    0 => Translatable('No'),
                },
                Translation  => 1,
                PossibleNone => 0,
            },
        },
    ];
}

=head2 MappingFormatAttributesGet()

Get the mapping attributes of an format as array/hash reference

    my $Attributes = $FormatBackend->MappingFormatAttributesGet(
        UserID => 1,
    );

=cut

sub MappingFormatAttributesGet {
    my ( $Self, %Param ) = @_;

    # check needed object
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return;
    }

    return [
        {
            Key   => 'Column',
            Name  => Translatable('Column'),
            Input => {
                Type     => 'TT',
                Data     => '',
                Required => 0,
            },
        },
    ];
}

=head2 ImportDataGet()

Get import data as C<2D-array> reference

    my $ImportData = $FormatBackend->ImportDataGet(
        TemplateID    => 123,
        SourceContent => $StringRef,  # (optional)
        UserID        => 1,
    );

=cut

sub ImportDataGet {
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

    return [] unless defined $Param{SourceContent};

    # check source content
    if ( ref $Param{SourceContent} ne 'SCALAR' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'SourceContent must be a scalar reference',
        );

        return;
    }

    # get format data
    my $FormatData = $Kernel::OM->Get('Kernel::System::ImportExport')->FormatDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check format data
    if ( !$FormatData || ref $FormatData ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No format data found for the template id $Param{TemplateID}",
        );

        return;
    }

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my $ImportData = $JSONObject->Decode(
        Data => $Param{SourceContent},
    );

    return unless defined $ImportData;
    return unless ref $ImportData eq 'ARRAY';
    return $ImportData;
}

=head2 ExportDataSave()

exports one item of the export data. When the formatting option 'Pretty'
is selected, then one item corresponds to multiple lines in the output.

    my $DestinationContent = $FormatBackend->ExportDataSave(
        TemplateID    => 123,
        ExportDataRow => $ArrayRef,
        UserID        => 1,
    );

=cut

sub ExportDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID ExportDataRow UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # check export data row
    if ( ref $Param{ExportDataRow} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ExportDataRow must be an array reference',
        );

        return;
    }

    # get format data
    my $FormatData = $Kernel::OM->Get('Kernel::System::ImportExport')->FormatDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check format data
    if ( !$FormatData || ref $FormatData ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No format data found for the template id $Param{TemplateID}",
        );

        return;
    }

    # pretty output unless otherwise requested
    my $Pretty = $FormatData->{Pretty} // 1;

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    return $JSONObject->Encode(
        Data     => $Param{ExportDataRow},
        Pretty   => $Pretty,
        SortKeys => 1,
    );

}

1;
