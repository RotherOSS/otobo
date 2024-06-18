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

package Kernel::System::Console::Command::Maint::Ticket::FulltextIndex;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket::Article',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        'Flag articles to automatically rebuild the article search index or displays the index status. Please use --status or --rebuild option, not both!'
    );
    $Self->AddOption(
        Name        => 'status',
        Description => "Display the current status of the index.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'rebuild',
        Description => "Flag articles to automatically rebuild the article search index.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( !$Self->GetOption('status') && !$Self->GetOption('rebuild') ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Either --status or --rebuild must be given!\n";
    }

    if ( $Self->GetOption('status') && $Self->GetOption('rebuild') ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Either --status or --rebuild must be given, not both!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Self->GetOption('status') ) {
        $Self->Status();
    }

    elsif ( $Self->GetOption('rebuild') ) {
        $Self->Rebuild();
    }

    return $Self->ExitCodeOk();
}

sub Status {
    my ( $Self, %Param ) = @_;

    my %Status     = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchIndexStatus();
    my $Percentage = $Status{ArticlesIndexed} / $Status{ArticlesTotal} * 100;

    my $Color = $Percentage == 100 ? 'green' : 'yellow';

    my $Output = sprintf(
        "Indexed Articles: <$Color>%.1f%%</$Color> (<$Color>%d/%d</$Color>)",
        $Percentage,
        $Status{ArticlesIndexed},
        $Status{ArticlesTotal}
    );

    $Self->Print("$Output\n");

    return 1;
}

sub Rebuild {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Marking all articles for reindexing...</yellow>\n");

    $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchIndexRebuildFlagSet(
        All   => 1,
        Value => 1,
    );

    $Self->Print("<green>Done.</green>\n");

    return 1;
}

1;
