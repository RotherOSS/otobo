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

package Kernel::System::CSV;

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules
use Text::CSV ();
use Excel::Writer::XLSX;

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::CSV - CSV lib

=head1 DESCRIPTION

All csv functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CSVObject = $Kernel::OM->Get('Kernel::System::CSV');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 Array2CSV()

Returns a CSV formatted string based on a array with head data.

    $CSV = $CSVObject->Array2CSV(
        WithHeader => [ 'RowA', 'RowB', ],   # optional
        Head       => [ 'RowA', 'RowB', ],   # optional
        Data       => [
            [ 1, 4 ],
            [ 7, 3 ],
            [ 1, 9 ],
            [ 34, 4 ],
        ],
        Separator => ';',  # optional separator (default is ;)
        Quote     => '"',  # optional quote (default is ")
        Format    => 'CSV', # optional format [Excel|CSV ] (default is CSV)
    );

=cut

sub Array2CSV {
    my ( $Self, %Param ) = @_;

    # check required params
    for (qw(Data)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Got no $_ param!"
            );
            return;
        }
    }

    my @Head;
    my @Data = ( ['##No Data##'] );
    if ( $Param{Head} ) {
        @Head = @{ $Param{Head} };
    }
    if ( $Param{Data} ) {
        @Data = @{ $Param{Data} };
    }
    my @WithHeader;
    if ( $Param{WithHeader} ) {
        @WithHeader = @{ $Param{WithHeader} };
    }

    # get format
    $Param{Format} //= 'CSV';

    my $Output = '';

    if ( $Param{Format} eq 'Excel' ) {

        open my $FileHandle, '>', \$Output;    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)
        if ( !$FileHandle ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Failed to open FileHandle: $!",
            );
            return;
        }
        my $Workbook     = Excel::Writer::XLSX->new($FileHandle);
        my $Worksheet    = $Workbook->add_worksheet();
        my $HeaderFormat = $Workbook->add_format(
            bold       => 1,
            num_format => '@',
        );

        # We will try to determine the appropriate length for each column.
        my @ColumnLengths;
        my $Row = 0;

        my @Rows = ( \@Head, @Data );

        if ( scalar @WithHeader ) {

            # Adds \@WithHeader to the beggining of @Rows, if not empty.
            #    Otherwise it adds empty first row - see bug#12467.
            unshift @Rows, \@WithHeader;
        }

        for my $DataRaw (@Rows) {
            COL:
            for my $Col ( 0 .. ( scalar @{ $DataRaw // [] } ) - 1 ) {
                next COL if !defined( $DataRaw->[$Col] );
                my $CellLength = length( $DataRaw->[$Col] );
                $CellLength = 30 if ( $CellLength > 30 );
                if ( !defined $ColumnLengths[$Col] || $ColumnLengths[$Col] < $CellLength ) {
                    $ColumnLengths[$Col] = $CellLength;
                }
                if ( $Row == 0 && @Head ) {

                    # Format header nicely if present.
                    $Worksheet->write( $Row, $Col, "$DataRaw->[$Col]", $HeaderFormat );
                }
                else {
                    # There are major problems with data recognition in Excel. OTOBO
                    #   ticket numbers will be recognized as numbers, but they are so big that
                    #   Excel will (incorrectly) round them. Prevent this by using write_string()
                    #   to protect the data. This might trigger formatting notifications in Excel,
                    #   but these can be turned off.
                    $Worksheet->write_string( $Row, $Col, "$DataRaw->[$Col]" );
                }
            }
            $Row++;
        }

        # Now apply column lengths.
        my $Col = 0;
        for my $ColumnLength (@ColumnLengths) {
            $Worksheet->set_column( $Col, $Col, $ColumnLength );
            $Col++;
        }

        $Workbook->close();
    }
    else {
        # get separator
        if ( !defined $Param{Separator} || $Param{Separator} eq '' ) {
            $Param{Separator} = ';';
        }

        # get separator
        if ( !defined $Param{Quote} ) {
            $Param{Quote} = '"';
        }

        # create new CSV backend object, uses Text::CSV_XS by default
        my $CSV = Text::CSV->new(
            {
                quote_char          => $Param{Quote},
                escape_char         => $Param{Quote},
                sep_char            => $Param{Separator},
                eol                 => '',
                always_quote        => 1,
                binary              => 1,
                keep_meta_info      => 0,
                allow_loose_quotes  => 0,
                allow_loose_escapes => 0,
                allow_whitespace    => 0,
                verbatim            => 0,
            }
        );

        # set header if given
        if (@WithHeader) {
            my $Status = $CSV->combine(@WithHeader);
            $Output .= $CSV->string() . "\n";
        }

        # if we have head param fill in header
        if (@Head) {
            my $Status = $CSV->combine(@Head);
            $Output .= $CSV->string() . "\n";
        }

        # fill in data
        for my $Row (@Data) {
            my $Status = $CSV->combine( @{$Row} );
            if ($Status) {
                $Output .= $CSV->string() . "\n";
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Failed to build line: ' . $CSV->error_input(),
                );
            }
        }

    }

    return $Output;
}

=head2 CSV2Array()

Returns an array with parsed CSV data.

    my $RefArray = $CSVObject->CSV2Array(
        String    => $CSVString,
        Separator => ';', # optional separator (default is ;)
        Quote     => '"', # optional quote (default is ")
    );

=cut

sub CSV2Array {
    my ( $Self, %Param ) = @_;

    # create new CSV backend object, uses Text::CSV_XS by default
    my $CSV = Text::CSV->new(
        {
            quote_char          => $Param{Quote} // '"',
            escape_char         => $Param{Quote}     || '"',
            sep_char            => $Param{Separator} || ";",
            eol                 => '',
            always_quote        => 0,
            binary              => 1,
            keep_meta_info      => 0,
            allow_loose_quotes  => 0,
            allow_loose_escapes => 0,
            allow_whitespace    => 0,
            verbatim            => 0,
        }
    );

    # do some dos/unix file conversions
    $Param{String} =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;

    # parse all CSV data line by line (allows newlines in data fields)
    my @Array;
    my $LineCounter = 1;
    open my $FileHandle, '<', \$Param{String};    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)
    while ( my $ColRef = $CSV->getline($FileHandle) ) {
        push @Array, $ColRef;
        $LineCounter++;
    }

    # log error if occurred and exit
    if ( !$CSV->eof() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Failed to parse CSV line ' . $LineCounter
                . ' (input: ' . $CSV->error_input()
                . ', error: ' . $CSV->error_diag() . ')',
        );

        return;
    }

    return \@Array;
}

1;
