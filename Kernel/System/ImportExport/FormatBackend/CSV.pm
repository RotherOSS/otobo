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

package Kernel::System::ImportExport::FormatBackend::CSV;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Text::CSV ();

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::ImportExport',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ImportExport::FormatBackend::CSV - import/export backend for CSV

=head1 DESCRIPTION

All functions to import and export a CSV formatted file. CSV stands comma separated values.

=cut

=head2 new()

Create an object.

    my $ImportExportCSVBackendObject = $Kernel::OM->Get('Kernel::System::ImportExport::FormatBackend::CSV');

=cut

sub new {
    my ($Type) = @_;

    return bless {

        # The formatter can't handle references by itself.
        # References are expected to have been serialized to JSON.
        CanHandleReferences => 0,

        # define available separators
        AvailableSeparators => {
            Tabulator => "\t",
            Semicolon => ';',
            Colon     => ':',
            Dot       => '.',
            Comma     => ',',
        },
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

Get the format attributes of a format as array/hash reference

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
            Key   => 'ColumnSeparator',
            Name  => Translatable('Column Separator'),
            Input => {
                Type => 'Selection',
                Data => {
                    Tabulator => Translatable('Tabulator (TAB)'),
                    Semicolon => Translatable('Semicolon (;)'),
                    Colon     => Translatable('Colon (:)'),
                    Dot       => Translatable('Dot (.)'),
                    Comma     => Translatable('Comma (,)'),
                },
                Required     => 1,
                Translation  => 1,
                PossibleNone => 1,
            },
        },
        {
            Key   => 'Charset',
            Name  => Translatable('Charset'),
            Input => {
                Type         => 'Text',
                ValueDefault => 'UTF-8',
                Required     => 1,
                Translation  => 0,
                Size         => 20,
                MaxLength    => 20,
                Readonly     => 1,
            },
        },
        {
            Key   => 'IncludeColumnHeaders',
            Name  => Translatable('Include Column Headers'),
            Input => {
                Type => 'Selection',
                Data => {
                    0 => Translatable('No'),
                    1 => Translatable('Yes'),
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

    my $Attributes = [
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

    return $Attributes;
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

    # get charset
    my $Charset = $FormatData->{Charset} ||= '';

    # check the charset
    if ( $Charset ne 'UTF-8' ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No valid charset found for the template id $Param{TemplateID}. Charset must be UTF-8!",
        );

        return;
    }

    # get separator
    $FormatData->{ColumnSeparator} ||= '';
    my $Separator = $Self->{AvailableSeparators}->{ $FormatData->{ColumnSeparator} } || '';

    # check the separator
    if ( !$Separator ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No valid separator found for the template id $Param{TemplateID}",
        );

        return;
    }

    # create the parser object
    my $ParseObject = Text::CSV->new(
        {
            quote_char          => '"',
            escape_char         => '"',
            sep_char            => $Separator,
            eol                 => '',
            always_quote        => 1,
            binary              => 1,
            keep_meta_info      => 0,
            allow_loose_quotes  => 0,
            allow_loose_escapes => 0,
            allow_whitespace    => 0,
            blank_is_undef      => 0,
            verbatim            => 0,
        }
    );

    # create an in memory temp file and open it
    my $FileContent = '';
    open my $FH, '+<', \$FileContent;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)

    # write source content
    print $FH ${ $Param{SourceContent} };

    # rewind file handle
    seek $FH, 0, 0;

    # parse the content
    my $LineCount = 1;
    my @ImportData;

    # it is important to use this syntax "while ( !eof($FH) )"
    # as the CPAN module Text::CSV_XS might show errors if the
    # getline call is within the while test
    # have a look at http://bugs.otobo.org/show_bug.cgi?id=9270
    while ( !eof($FH) ) {
        my $Column = $ParseObject->getline($FH);
        push @ImportData, $Column;
        $LineCount++;
    }

    # error handling
    my ( $ParseErrorCode, $ParseErrorString ) = $ParseObject->error_diag();
    if ($ParseErrorCode) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ImportError at line $LineCount, "
                . "ErrorCode: $ParseErrorCode '$ParseErrorString' ",
        );
    }

    # close the in memory file handle
    close $FH;

    # set utf8 flag
    for my $Row (@ImportData) {
        for my $Cell ( @{$Row} ) {
            Encode::_utf8_on($Cell);
        }
    }

    return \@ImportData;
}

=head2 ExportDataSave()

exports one item of the export data. In the case of CSV one item
corresponds to a line in the output.

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

    # get charset
    my $Charset = $FormatData->{Charset} ||= '';

    # check the charset
    if ( $Charset ne 'UTF-8' ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No valid charset found for the template id $Param{TemplateID}. Charset must be UTF-8!",
        );

        return;
    }

    # get columnn separator
    $FormatData->{ColumnSeparator} ||= '';
    my $Separator = $Self->{AvailableSeparators}->{ $FormatData->{ColumnSeparator} } || '';

    # check the separator
    if ( !$Separator ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No valid separator found for the template id $Param{TemplateID}",
        );

        return;
    }

    # create the parser object
    my $ParseObject = Text::CSV->new(
        {
            quote_char          => '"',
            escape_char         => '"',
            sep_char            => $Separator,
            eol                 => '',
            always_quote        => 1,
            binary              => 1,
            keep_meta_info      => 0,
            allow_loose_quotes  => 0,
            allow_loose_escapes => 0,
            allow_whitespace    => 0,
            blank_is_undef      => 0,
            verbatim            => 0,
        }
    );

    if ( !$ParseObject->combine( @{ $Param{ExportDataRow} } ) ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't combine the export data to a string!",
        );

        return;
    }

    # create the CSV string
    my $String = $ParseObject->string;

    # set utf8 flag
    Encode::_utf8_on($String);

    return $String;
}

1;
