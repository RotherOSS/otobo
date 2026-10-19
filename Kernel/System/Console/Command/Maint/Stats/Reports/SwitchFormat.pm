# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::Console::Command::Maint::Stats::Reports::SwitchFormat;

use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::System::StatsReport',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Change the way the charts are generated');

    $Self->AddOption(
        Name        => 'd3-to-gnuplot',
        Description => "Changes the output formats of the statistics that start with D3:: to Gnuplot::.",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'gnuplot-to-d3',
        Description => "Changes the output formats of the statistics that start with D3:: to Gnuplot::.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # sanity check of the options
    my $ConvertToGnuplot = $Self->GetOption('d3-to-gnuplot');
    my $ConvertToD3      = $Self->GetOption('gnuplot-to-d3');

    if ( $ConvertToGnuplot && $ConvertToD3 ) {
        $Self->PrintError("Pass either --d3-to-gnuplot or --gnuplot-to-d3");

        return $Self->ExitCodeError();
    }

    if ( !$ConvertToGnuplot && !$ConvertToD3 ) {
        $Self->PrintError("Pass one of --d3-to-gnuplot or --gnuplot-to-d3");

        return $Self->ExitCodeError();
    }

    $Self->Print("<yellow>Adapting the statistics report configuration...</yellow>\n");

    my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

    # Loop over all reports
    my $StatsReportID2Name = $StatsReportObject->StatsReportList;

    if ( ref $StatsReportID2Name ne 'HASH' ) {
        $Self->PrintW("List of statistics reports could not be retrieved.");

        return $Self->ExitCodeError();
    }
    elsif ( !$StatsReportID2Name->%* ) {
        $Self->PrintWarning("There are no statistics reports. There is nothing to do.\n");

        return $Self->ExitCodeOk();
    }

    my $NumChangedReports = 0;
    ID:
    for my $ID ( keys $StatsReportID2Name->%* ) {
        my $Name = $StatsReportID2Name->{$ID};

        my $StatsReport = $StatsReportObject->StatsReportGet(
            ID => $ID,
        );

        # check the sanity of the statistics report
        if ( !IsHashRefWithData($StatsReport) ) {
            $Self->PrintError(qq{Skipping the report "$Name" ($ID) as no data was found});

            next ID;
        }
        if ( !IsHashRefWithData( $StatsReport->{Config} ) ) {
            $Self->PrintError(qq{Skipping the report "$Name" ($ID) as no configuration was found});

            next ID;
        }
        if ( !IsArrayRefWithData( $StatsReport->{Config}->{StatsConfiguration} ) ) {
            $Self->PrintError(qq{Skipping the report "$Name" ($ID) as no statistics configuration was found});

            next ID;
        }

        # loop over the statistics in the report
        my $NumChangedStats = 0;
        STAT_CONFIG:
        for my $StatConfig ( $StatsReport->{Config}->{StatsConfiguration}->@* ) {
            if ( !IsHashRefWithData($StatConfig) ) {
                $Self->PrintError("Skipping a statistic config was not found");

                next STAT_CONFIG;
            }
            if ( !IsHashRefWithData( $StatConfig->{StatGetParams} ) ) {
                $Self->PrintError("Skipping a StatGetParams of statistic config was not found");

                next STAT_CONFIG;
            }

            my $Format = $StatConfig->{StatGetParams}->{Format};
            if ( !$Format ) {
                $Self->PrintError("Skipping as no format was found in statistic config");

                next STAT_CONFIG;
            }

            if ( $ConvertToGnuplot && $Format =~ m/^D3::/ ) {
                $StatConfig->{StatGetParams}->{Format} =~ s/^D3/Gnuplot/;
                $NumChangedStats++;
            }
            elsif ( $ConvertToD3 && $Format =~ m/^Gnuplot::/ ) {
                $StatConfig->{StatGetParams}->{Format} =~ s/^Gnuplot/D3/;
                $NumChangedStats++;
            }
        }

        if ($NumChangedStats) {
            my $UpdateSuccess = $StatsReportObject->StatsReportUpdate(
                ID      => $ID,
                Name    => $Name,
                Config  => $StatsReport->{Config},
                ValidID => $StatsReport->{ValidID},
                UserID  => 1,
            );
            if ( !$UpdateSuccess ) {
                $Self->PrintError(qq{Could not update the statistics report "$Name"});

                next ID;
            }

            $Self->PrintOk(qq{converted "$Name" ($ID)});

            # count the updates
            $NumChangedReports++;
        }
        else {
            $Self->PrintOk(qq{no conversion needed for "$Name" ($ID)});
        }
    }

    $Self->PrintOk("Converted $NumChangedReports statistics reports.\n");
    $Self->PrintOk("Done.\n");

    return $Self->ExitCodeOk();
}

1;
