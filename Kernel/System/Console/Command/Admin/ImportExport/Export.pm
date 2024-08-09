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

package Kernel::System::Console::Command::Admin::ImportExport::Export;

use v5.24;
use strict;
use warnings;
use utf8;
use re '/aa';

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use File::Path qw(mkpath);

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::ImportExport',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('This is a tool for exporting items. The specifics are defined in an ImportExport template.');
    $Self->AddOption(
        Name        => 'template-number',
        Description => 'the number of the ImportExport template that specifies the export',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/,
    );
    $Self->AddOption(
        Name        => 'chunk-size',
        Description => 'Activate chunked export by specifying the chunk size.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/,
    );
    $Self->AddArgument(
        Name        => 'destination',
        Description => (
            join ' ',
            'The path to a file or directory where data should be exported.',
            'For chunked exports specify a directory.',
            'For non-chunked exports specify a file.'
        ),
        Required   => 1,
        ValueRegex => qr/.*/,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TemplateID = $Self->GetOption('template-number');

    # get template data
    my $TemplateData = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    if ( !$TemplateData->{TemplateID} ) {
        $Self->PrintError("Template $TemplateID not found!.\n");
        $Self->PrintError("Export aborted..\n");

        return $Self->ExitCodeError;
    }

    # Setup for chunking.
    # The ChunkSize is optional. An undefined ChunkSize indicates a single file export
    my $ChunkSize    = $Self->GetOption('chunk-size');
    my $IsChunked    = defined $ChunkSize ? 1 : 0;
    my $ChunkCounter = 1;

    $Self->PrintWarning('Exporting ...');
    $Self->Print( ( '=' x 69 ) . "\n" );

    # either file or dir
    my $Destination = $Self->GetArgument('destination');

    # create output dir if needed
    if ( $Destination && $IsChunked ) {
        mkpath( $Destination, 0, 0775 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
    }

    # for summing up the chunks
    my %Total = (
        Success => 0,
        Failed  => 0,
    );

    # export data
    CHUNKING:
    while (1) {

        $Self->Print( ( '-' x 69 ) . "\n" );
        if ($IsChunked) {
            $Self->Print("Exporting chunk $ChunkCounter...\n");
        }

        my $Result = $Kernel::OM->Get('Kernel::System::ImportExport')->Export(
            ChunkSize  => $ChunkSize,
            TemplateID => $TemplateID,
            UserID     => 1,
        );

        if ( !$Result ) {
            $Self->PrintError("Error occurred. Export impossible! See Syslog for details.\n");

            return $Self->ExitCodeError;
        }

        $Self->PrintOk("Success: $Result->{Success} succeeded");
        if ( $Result->{Failed} ) {
            $Self->PrintError("$Result->{Failed} failed.\n");
        }
        else {
            $Self->PrintOk("Error: $Result->{Failed} failed.");
        }

        # sum up the total
        $Total{Success} += $Result->{Success} // 0;
        $Total{Failed}  += $Result->{Failed}  // 0;

        if ($Destination) {

            # Concatenate the lines, making sure that there is a line break after the last line.
            # This makes `wc -l` report the actual number of lines in a file.
            my $FileContent = join '', map { $_ . "\n" } $Result->{DestinationContent}->@*;

            # save destination content to file
            # add some leading 0s in order to have simple alphabetical ordering
            my $FormattedChunkCounter = sprintf '%06d', $ChunkCounter;
            my $Location              = $IsChunked
                ?
                File::Spec->catfile( $Destination, "chunk_$FormattedChunkCounter.csv" )
                :
                $Destination;
            my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
                Location => $Location,
                Content  => \$FileContent,
            );

            if ( !$Success ) {
                $Self->PrintError("Can't write file $Destination.\nExport aborted.\n");

                return $Self->ExitCodeError;
            }

            $Self->PrintOk("File $Destination saved.");
        }

        # not all backends support chunking
        last CHUNKING unless defined $Result->{ChunkingFinished};
        last CHUNKING if $Result->{ChunkingFinished};
    }
    continue {
        $ChunkCounter++;
    }

    # report the total
    if ($IsChunked) {
        $Self->Print(
            join '',
            "\n",
            "Total after exporting $ChunkCounter chunk(s):\n",
            "Success: $Total{Success}\n",
            "Failed : $Total{Failed}\n",
            "\n"
        );
    }

    $Self->PrintOk('Export complete.');
    $Self->Print( ( '-' x 69 ) . "\n" );
    $Self->PrintOk('Done.');

    return $Self->ExitCodeOk;
}

1;
