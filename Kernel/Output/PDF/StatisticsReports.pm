# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::Output::PDF::StatisticsReports;

use v5.26;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use File::stat qw(stat);

# CPAN modules
use Gnuplot::Builder::Script  qw();
use Gnuplot::Builder::Dataset qw();
use Gnuplot::Builder::Process qw();
use List::AllUtils            qw(any first indexes);

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::Output::HTML::Statistics::View',
    'Kernel::System::FileTemp',
    'Kernel::System::Main',
    'Kernel::System::PDF',
    'Kernel::System::Stats',
    'Kernel::System::StatsReport',
    'Kernel::System::User',
);

sub new {
    my ($Type) = @_;

    return bless {}, $Type;
}

sub GeneratePDF {
    my ( $Self, %Param ) = @_;

    my %StatsReport  = %{ $Param{StatsReport} };
    my $UserLanguage = $Param{UserLanguage};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Always create a new instance here. This might be called from a script to produce
    #   several reports in one process, and that fails with one instance.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::PDF'] );
    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $GoogleChromeBinary = $Kernel::OM->Get('Kernel::Config')->Get('GoogleChrome::Bin');
    my $BrowserFound       = $GoogleChromeBinary ? 1 : 0;
    my $GnuplotBinary      = $Kernel::OM->Get('Kernel::Config')->Get('Gnuplot::Bin');
    my $GnuplotFound       = $GnuplotBinary ? 1 : 0;

    my $Page = $LayoutObject->{LanguageObject}->Translate('Page');
    my $Time = $LayoutObject->{Time};

    # get maximum number of pages
    my $MaxPages = $ConfigObject->Get('PDF::MaxPages');
    if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
        $MaxPages = 100;
    }

    my $Title = $StatsReport{Config}->{Title};

    # page params
    my %PageParam;
    $PageParam{PageOrientation} = 'landscape';
    $PageParam{MarginTop}       = 30;
    $PageParam{MarginRight}     = 40;
    $PageParam{MarginBottom}    = 40;
    $PageParam{MarginLeft}      = 40;

    #$PageParam{HeaderRight}     = $ConfigObject->Get('Stats::StatsHook') . $Stat->{StatNumber};
    #$PageParam{HeadlineLeft}    = $Title;

    # create new pdf document
    my $PageCounter = 1;

    $PDFObject->DocumentNew(
        Title  => $ConfigObject->Get('Product') . ': ' . $Title,
        Encode => 'utf8',
    );

    # Cover page
    $PDFObject->PageNew(
        %PageParam,
    );
    $PageCounter++;

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => 'middle',
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => +44,
    );

    my $FallbackHeadline = $LayoutObject->{LanguageObject}->Translate( "%s Report", 'OTOBO' );
    $PDFObject->Text(
        Text     => $StatsReport{Config}->{Headline} || $FallbackHeadline,
        FontSize => 20,
        Align    => 'center',
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -20,
    );

    $PDFObject->Text(
        Text     => $Title,
        FontSize => 15,
        Align    => 'center',
        Color    => '#555555',
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -20,
    );

    $PDFObject->Text(
        Text     => $Time,
        FontSize => 9,
        Align    => 'center',
        Color    => '#555555',
    );

    # Insert an empty page for the TOC, to be filled later
    $PDFObject->PageNew(
        %PageParam,
        FooterRight => $Page . ' ' . $PageCounter++,
    );

    my $TOCPage = $PDFObject->{Page};    # sorry :D

    $PDFObject->PageNew(
        %PageParam,
        FooterRight => $Page . ' ' . $PageCounter++,
    );

    my $OutputParagraph = sub {
        my %Param = @_;

        my $Text = $Param{Text};

        while ($Text) {
            my %Result = $PDFObject->Text(
                %Param,
                Text => $Text,
            );
            $Text = $Result{LeftOver};

            if ($Text) {
                if ( $PageCounter >= $MaxPages ) {
                    return;
                }
                $PDFObject->PageNew(
                    %PageParam,
                    FooterRight => $Page . ' ' . $PageCounter++,
                );
            }
        }

        return 1;
    };

    my $ChapterCounter = 1;
    my @Chapters;

    # output preamble
    if ( $StatsReport{Config}->{Preamble} && $PageCounter <= $MaxPages ) {
        my $FallbackCaption = $LayoutObject->{LanguageObject}->Translate("Preamble");
        my $Caption         = $ChapterCounter++ . ' ' . ( $StatsReport{Config}->{PreambleCaption} || $FallbackCaption );
        push(
            @Chapters,
            {
                Caption => $Caption,
                Page    => $PageCounter - 1
            }
        );
        $PDFObject->Text(
            Text     => $Caption,
            FontSize => 13,
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -13,
        );

        $OutputParagraph->(
            Text     => $StatsReport{Config}->{Preamble},
            FontSize => 9,
        );

        $PDFObject->PageNew(
            %PageParam,
            FooterRight => $Page . ' ' . $PageCounter++,
        );
    }

    my $StatCounter       = 0;
    my $TranslateTimeZone = $LayoutObject->{LanguageObject}->Translate('Time Zone');

    STAT_CONFIG:
    for my $StatConfig ( ( $StatsReport{Config}->{StatsConfiguration} // [] )->@* ) {
        next STAT_CONFIG unless ref $StatConfig;

        my $StatID = $StatConfig->{StatGetParams}->{StatID};

        next STAT_CONFIG unless $StatID;

        my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
            StatID => $StatID,
        );

        my %GetParam = eval {
            $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsGet(
                Stat         => $Stat,
                UserGetParam => $StatConfig->{StatGetParams},
            );
        };

        next STAT_CONFIG if $@;

        # Check available formats from stat
        my $FirstFoundFormat = first {m/^(?:Gnuplot|D3|Print)/} ( $Stat->{Format} // [] )->@*;

        # Use the format selected by the user or the first available format.
        my $Format = $StatConfig->{StatGetParams}->{Format} || $FirstFoundFormat;

        # Skip stat if format is wrong.
        next STAT_CONFIG unless $Format =~ m/^(?:Gnuplot|D3|Print)/;

        # each stat is on a new page
        if ( $StatCounter++ > 0 ) {
            $PDFObject->PageNew(
                %PageParam,
                FooterRight => $Page . ' ' . $PageCounter++,
            );
        }

        my @StatArray = @{
            $Kernel::OM->Get('Kernel::System::Stats')->StatsRun(
                StatID       => $StatID,
                GetParam     => \%GetParam,
                UserID       => $Param{UserID},
                UserLanguage => $UserLanguage,
            );
        };

        shift @StatArray;    # the TitleArrayRef is not used
        my $HeadArrayRef = shift @StatArray;

        my %StatReportSettings = %{ $StatConfig->{StatReportSettings} // {} };

        my $Caption = $ChapterCounter++ . ' ' . ( $StatReportSettings{Title} || $Stat->{Title} );

        # If a time zone was selected
        if ( $StatConfig->{StatGetParams}->{TimeZone} ) {
            $Caption .= " ($TranslateTimeZone $StatConfig->{StatGetParams}->{TimeZone})";
        }

        push @Chapters,
            {
                Caption => $Caption,
                Page    => $PageCounter - 1
            };
        $PDFObject->Text(
            Text     => $Caption,
            FontSize => 13,
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -13,
        );

        if ( $StatReportSettings{Preface} ) {
            $OutputParagraph->(
                Text     => $StatReportSettings{Preface},
                FontSize => 9,
            );
            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );
        }

        # Direct table output in PDF when the format is 'Print' or there is no chart drawing command
        if (
            ( !( $Format =~ m/^D3::/ && $BrowserFound ) )
            &&
            ( !( $Format =~ m/^Gnuplot::/ && $GnuplotFound ) )
            )
        {
            # if array = empty
            if ( !@StatArray ) {
                push @StatArray, [ ' ', 0 ];
            }

            # create the header
            my $CellData;
            my $CounterRow  = 0;
            my $CounterHead = 0;
            for my $Content ( $HeadArrayRef->@* ) {
                $CellData->[$CounterRow]->[$CounterHead]->{Content} = $Content;
                $CellData->[$CounterRow]->[$CounterHead]->{Font}    = 'ProportionalBold';
                $CounterHead++;
            }
            if ( $CounterHead > 0 ) {
                $CounterRow++;
            }

            # create the content array
            for my $Row (@StatArray) {
                my $CounterColumn = 0;
                for my $Content ( @{$Row} ) {
                    $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
                    $CounterColumn++;
                }
                $CounterRow++;
            }

            # output 'No matches found', if no content was given
            if ( !$CellData->[0]->[0] ) {
                $CellData->[0]->[0]->{Content} = $LayoutObject->{LanguageObject}->Translate('No matches found.');
            }

            # table params
            my %TableParam;
            $TableParam{CellData}            = $CellData;
            $TableParam{Type}                = 'Cut';
            $TableParam{FontSize}            = 6;
            $TableParam{Border}              = 0;
            $TableParam{BackgroundColorEven} = '#DDDDDD';
            $TableParam{Padding}             = 4;

            PAGE:
            while ( $PageCounter <= $MaxPages ) {

                # output table (or a fragment of it)
                %TableParam = $PDFObject->Table( %TableParam, );

                # stop output or output next page
                last PAGE if $TableParam{State};

                $PDFObject->PageNew(
                    %PageParam,
                    FooterRight => $Page . ' ' . $PageCounter++,
                );
            }

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );
        }

        # Generate an image and embed it in the PDF
        # Gnuplot charts: generate PDF with Gnuplot
        # D3 charts:      load the chart in Chrome and save a screenshot as PNG
        else {
            my $Home         = $Kernel::OM->Get('Kernel::Config')->Get('Home');
            my $TempImageDir = $Kernel::OM->Get('Kernel::System::FileTemp')->TempDir();
            my $TempImageFilename;
            my $CommandOutput;

            if ( $Format =~ m/^D3::/ ) {
                $TempImageFilename = "$TempImageDir/screenshot.png";    # Chrome requires this file name

                # This is needed because we run this function also from a console commands where
                #   there is no Action initially.
                local $LayoutObject->{Action} = 'AgentStatisticsReports';

                # Generate local file URLs for Chrome or (ok, this is a hack).
                local $ConfigObject->{'Frontend::WebPath'}        = "file://$Home/var/httpd/htdocs/";
                local $ConfigObject->{'Frontend::JavaScriptPath'} = "file://$Home/var/httpd/htdocs/js/";
                my $Output = join '',
                    $LayoutObject->Header( Type => 'Small' ),
                    $LayoutObject->Output(
                        Data => {
                            RawData => [
                                [$Title],    # not used
                                $HeadArrayRef,
                                @StatArray,
                            ],
                            Format => $Format,
                        },
                        TemplateFile => 'StatisticsReports/Graph2PNG',
                    ),
                    $LayoutObject->Footer( Type => 'Small' );

                # Remove HTTP headers
                $Output =~ s{\A.*?(<!DOCTYPE)}{$1}smx;

                my ( $TempHTMLFH, $TempHTMLFilename ) = $Kernel::OM->Get('Kernel::System::FileTemp')->TempFile(
                    Suffix => '.html',
                );
                close $TempHTMLFH;
                $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
                    Location => $TempHTMLFilename,
                    Mode     => 'utf8',
                    Content  => \$Output,
                );

                # Chrome outputs with a fixed "screenshot.png" file name in the current folder.
                #   Attempt to use --virtual-time-budget to wait for the chart to be rendered.
                #
                #   FIXME: If --disable-gpu is used in the command below (or if GPU acceleration is not supported),
                #   subsequent call to $PDFObject->Image() <PDF::API2::image_png() internally> will be extremely slow.
                #   The real reason is still unknown.
                $CommandOutput
                    = `cd $TempImageDir; '$GoogleChromeBinary' --no-sandbox --headless --virtual-time-budget=2500 --window-size=1200,900 --screenshot $TempHTMLFilename 2>&1`;
                if ($!) {
                    $CommandOutput .= "$!";
                }
                chomp $CommandOutput;
            }
            elsif ( $Format =~ m/^Gnuplot::/ ) {

                # The default Gnuplot command to 'gnuplot --persist'. Looking for gnuplot in PATH works fine,
                # but the OTOBO convention is to use the configured executable.
                local $ENV{PERL_GNUPLOT_BUILDER_PROCESS_COMMAND} = "$GnuplotBinary --persist";

                # The location where gnuplot writes the graph
                $TempImageFilename = "$TempImageDir/gnuplot.pdf";

                # The terminal and tha output file name are the same for all Gnuplot formats.
                # The size is hardcoded to fit on A4 paper. There is no special reason for the x:y ratio,
                # just trial and error.
                # 'chromium --screenshot' gives an 800:600 image, but leaves quite some empty space.
                my $Builder = Gnuplot::Builder::Script->new(

                    #'terminal pdfcairo background' => 'rgb "gray90"',   # no background, tranparent in case of overlaps
                    auto                     => [qw(x y)],          # autosize x- and y-axis to fit the data
                    'terminal pdfcairo size' => '26.8cm,13.4cm',    # A4 landscape is 29,7 x 21.0 cm²
                    'terminal pdfcairo font' => '",12"',            # no special font, but small font size
                    'terminal pdfcairo'      => 'square',           # rectangular ending of the bars
                    bmargin                  => 'at screen 0.1',    # increase the bottom margin in order to accomodate the two line x-labels
                    key                      => 'above',            # place the legend above the plot
                );
                $Builder->setq( output => $TempImageFilename );

                # Example for the incoming data:
                # $HeadArrayRef = [
                #                   "Queue",
                #                   "closed successful",
                #                   "closed unsuccessful",
                #                   "merged",
                #                   "new",
                #                   "open",
                #                   "pending auto close+",
                #                   "pending auto close-",
                #                   "pending reminder",
                #                   "removed",
                #                   "Sum",
                #                 ]
                # \@StatArray = [
                #                 ["Junk", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                #                 ["Misc", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                #                 ["Postmaster", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                #                 ["Raw", 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
                #                 ["fill-up-queue10561661", 0, 0, 0, 11, 0, 0, 0, 0, 0, 11],
                #                 ["fill-up-queue1694343", 0, 0, 0, 13, 0, 0, 0, 0, 0, 13],
                #                 ["fill-up-queue2158423", 0, 0, 0, 10, 0, 0, 0, 0, 0, 10],
                #                 ["fill-up-queue24956368", 0, 0, 0, 17, 0, 0, 0, 0, 0, 17],
                #                 ["Sum", 0, 0, 0, 223, 0, 0, 0, 0, 0, 223],
                #               ]

                my @Datasets;
                {
                    # The incoming data contains a column that sums up the previous elements in the row.
                    # It also contains a row that sums up the previous elements of the column.
                    # Both must be removed for the bar chart as otherwise the chart would be dominated
                    # by the sum values.
                    @StatArray = grep { $_->[0] ne 'Sum' } @StatArray;

                    # First find the indexes of the non 'Sum' colums
                    my @NonSumColNums = indexes { $_ ne 'Sum' } $HeadArrayRef->@*;

                    # As a workaround for long labels on the x-axis, we put every other label on a new line.
                    # A line break is indicated by the two characters '\' and 'n', not by a literal newline.
                    my @XLabelsOnTwoLines = map { ( $_ % 2 ? '\n' : '' ) . $HeadArrayRef->[$_] } 0 .. $HeadArrayRef->$#*;
                    unshift @StatArray, \@XLabelsOnTwoLines;

                    # Transpose as D3 and Gnuplot seem to see the data differently
                    my @TransposedStatArray;
                    for my $Row ( 0 .. $#StatArray ) {
                        for my $Col ( 0 .. $StatArray[$Row]->$#* ) {
                            $TransposedStatArray[$Col][$Row] = $StatArray[$Row][$Col];
                        }
                    }

                    # It is easier to remove rows than colums. So remove the Sum rows from the transposed stats array.
                    @TransposedStatArray = @TransposedStatArray[@NonSumColNums];

                    my $BoxKeys = shift @TransposedStatArray;
                    my @InlineData =
                        map { join ' ', $_->@* }
                        map { $_->[0] = qq{"$_->[0]"}; $_ }
                        @TransposedStatArray;

                    # for stacked area we need to sum up the colums to the left
                    if ( $Format eq 'Gnuplot::StackedAreaChart' ) {
                        $Builder->add(<<~'END_SCRIPT');
                            firstcol=2
                            cumulated(i)=((i>firstcol)?column(i)+cumulated(i-1):(i==firstcol)?column(i):1/0)
                            END_SCRIPT
                    }

                    my $MaxCol = $BoxKeys->@*;
                    if ( $Format eq 'Gnuplot::StackedAreaChart' ) {

                        # The first dataset holds the table
                        my $Dataset = Gnuplot::Builder::Dataset->new(q{'-'});
                        my $Sum     = join '+', map { '$' . $_ } ( 2 .. $MaxCol );
                        $Dataset->set_data( join "\n", @InlineData );
                        $Dataset->set( using => "($Sum):xticlabels(1)" );
                        $Dataset->setq( title => $BoxKeys->[ $MaxCol - 1 ] );
                        push @Datasets, $Dataset;
                        for my $Col ( 3 .. $MaxCol - 1 ) {
                            my $ChildDataset = $Dataset->new_child;
                            $ChildDataset->setq_source('');    # use data from the previous dataset

                            # See https://newspaint.wordpress.com/2013/09/11/creating-a-filled-stack-graph-in-gnuplot/
                            # sum up data
                            my $Sum = join '+', map { '$' . $_ } ( $Col .. $MaxCol );
                            $ChildDataset->set( using => "($Sum)" );
                            $ChildDataset->setq( title => $BoxKeys->[ $Col - 1 ] );    # 0-based
                            push @Datasets, $ChildDataset;
                        }
                    }
                    else {

                        # The first dataset holds the table
                        my $Dataset = Gnuplot::Builder::Dataset->new(q{'-'});
                        $Dataset->set_data( join "\n", @InlineData );
                        $Dataset->set( using => '2:xticlabels(1)' );
                        $Dataset->setq( title => $BoxKeys->[1] );
                        push @Datasets, $Dataset;
                        for my $Col ( 3 .. $MaxCol ) {
                            my $ChildDataset = $Dataset->new_child;
                            $ChildDataset->setq_source('');                            # use data from the previous dataset
                            $ChildDataset->set( using => $Col );
                            $ChildDataset->setq( title => $BoxKeys->[ $Col - 1 ] );    # 0-based
                            push @Datasets, $ChildDataset;
                        }
                    }
                }

                if ( $Format eq 'Gnuplot::LineChart' ) {
                    $Builder->set(
                        'style data' => 'lines',
                    );
                }
                elsif ( $Format eq 'Gnuplot::StackedAreaChart' ) {
                    $Builder->set(
                        'style data' => 'filledcurve x1',    # color down to the x-axis
                    );
                }
                elsif ( any { $Format eq $_ } qw(Gnuplot::ClusteredBarChart Gnuplot::StackedBarChart) ) {

                    # The format of the graph determines the histogram style. Default is 'cluster'.
                    my $HistogramStyle = $Format eq 'Gnuplot::StackedBarChart' ? 'rowstacked' : 'cluster';
                    $Builder->set(
                        'style data'      => 'histogram',
                        'style histogram' => "$HistogramStyle gap 1",
                        'style fill'      => 'solid noborder',
                    );
                }

                my $PlotOut = $Builder->plot(@Datasets);

                # Finish pending work before drawing a new chart.
                # This avoids failures when charts are drawn in quick succession
                Gnuplot::Builder::Process->wait_all;
            }

            my $TempImageStat = stat $TempImageFilename;
            if ( $TempImageStat && $TempImageStat->size ) {
                $PDFObject->Image(
                    File   => $TempImageFilename,
                    Width  => 1200 * ( 300 / 72 ),    # width in dots for 300 dpi
                    Height => 900 * ( 300 / 72 ),     # height in dots for 300 dpi
                );
            }
            else {
                my $Messages = $LayoutObject->{LanguageObject}->Translate(
                    'Error: this graph could not be generated: %s.',
                    $CommandOutput
                );
                $PDFObject->Text(
                    Text     => $Messages,
                    FontSize => 9,
                    Color    => '#FF000',
                );

                $PDFObject->PositionSet(
                    Move => 'relativ',
                    Y    => -6,
                );
            }
        }

        if ( $StatReportSettings{Postface} ) {
            $OutputParagraph->(
                Text     => $StatReportSettings{Postface},
                FontSize => 9,
            );
            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );
        }
    }

    # output epilogue
    if ( $StatsReport{Config}->{Epilogue} && $PageCounter < $MaxPages ) {
        $PDFObject->PageNew(
            %PageParam,
            FooterRight => $Page . ' ' . $PageCounter++,
        );

        my $FallbackCaption = $LayoutObject->{LanguageObject}->Translate("Epilogue");
        my $Caption         = $ChapterCounter++ . ' ' . ( $StatsReport{Config}->{EpilogueCaption} || $FallbackCaption );
        push(
            @Chapters,
            {
                Caption => $Caption,
                Page    => $PageCounter - 1
            }
        );
        $PDFObject->Text(
            Text     => $Caption,
            FontSize => 13,
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -13,
        );

        $OutputParagraph->(
            Text     => $StatsReport{Config}->{Epilogue},
            FontSize => 9,
        );
    }

    # Generate TOC
    {
        local $PDFObject->{Page} = $TOCPage;

        $PDFObject->PositionSet(
            X => 'left',
            Y => 'top',
        );

        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Table of Contents'),
            FontSize => 13,
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -13,
        );

        for my $Chapter (@Chapters) {
            $PDFObject->Text(
                Text     => $Chapter->{Caption},
                FontSize => 9,
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => +9,
            );

            $PDFObject->Text(
                Text     => $Chapter->{Page},
                FontSize => 9,
                Align    => 'right',
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );
        }
    }

    # return the pdf document
    return $PDFObject->DocumentOutput();
}

1;
