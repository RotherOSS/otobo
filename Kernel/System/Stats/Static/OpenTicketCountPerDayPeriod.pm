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

package Kernel::System::Stats::Static::OpenTicketCountPerDayPeriod;
## nofilter(TidyAll::Plugin::OTOBO::Perl::Time)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::Queue',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 1,
    );

    return %Behaviours;
}

sub Param {
    my $Self = shift;

    # Get possible queues for selection
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %Queues      = $QueueObject->GetAllQueues();

    my @Params = (
        {
            Frontend   => 'Queue',
            Name       => 'Queue',
            Multiple   => 1,
            Size       => 0,
            SelectedID => 0,
            Data       => \%Queues,
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{Queue};

    # get language object
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    my $Year   = $Param{Year};
    my $Month  = $Param{Month};
    my $Day    = $Param{Day};
    my @Queues = @{ $Param{Queue} };

    # Save ticket create timeslots in hash (key=start, value=stop)
    my %CreateTimeBetweenDays;
    $CreateTimeBetweenDays{'0'}  = '10';
    $CreateTimeBetweenDays{'11'} = '30';
    $CreateTimeBetweenDays{'31'} = '50';
    $CreateTimeBetweenDays{'51'} = '70';
    $CreateTimeBetweenDays{71}   = 90;
    $CreateTimeBetweenDays{91}   = 100;
    $CreateTimeBetweenDays{101}  = 200;
    $CreateTimeBetweenDays{201}  = 300;
    $CreateTimeBetweenDays{301}  = 400;
    $CreateTimeBetweenDays{401}  = 500;

    # Generate header row for stats
    my @Stats;
    my @HeaderRow;
    for my $Start ( sort { $a <=> $b } keys %CreateTimeBetweenDays ) {
        push @HeaderRow, $Start . ' - ' . $CreateTimeBetweenDays{$Start} . ' ' . $LanguageObject->Translate('Days');
    }

    # Define search criteria, we search tickets they are now open and created between start end until time
    my $StateType = 'Open';

    for my $SelectedQueue (@Queues) {

        push @Stats, $Self->_GetDBDataPerQueue(
            Result                => 'COUNT',
            StateTyp              => $StateType,
            QueueID               => $SelectedQueue,
            CreateTimeBetweenDays => \%CreateTimeBetweenDays,
            UserID                => 1,
        );
    }

    my $Title = "";
    return ( [$Title], [ $LanguageObject->Translate('Queues / Tickets'), @HeaderRow ], @Stats );
}

sub _GetDBDataPerQueue {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
    my @StatsRow     = $QueueObject->QueueLookup( QueueID => $Param{QueueID} );

    for my $TicketCreateStart ( sort { $a <=> $b } keys %{ $Param{CreateTimeBetweenDays} } ) {

        # Create TimeObject for ticket create time start
        my $DateTimeObjectFrom = $Kernel::OM->Create(
            'Kernel::System::DateTime'
        );

        # Substract TicketCreateStart days
        my $Success = $DateTimeObjectFrom->Subtract(
            Days => $TicketCreateStart,
        );

        # Export date in string format
        my $TicketCreateFrom = $DateTimeObjectFrom->Format( Format => '%Y-%m-%d %H:%M:%S' );

        # Create TimeObject for ticket create time end
        my $DateTimeObjectUntil = $Kernel::OM->Create(
            'Kernel::System::DateTime'
        );

        # Substract end date days
        my $SuccessUntil = $DateTimeObjectUntil->Subtract(
            Days => $Param{CreateTimeBetweenDays}{$TicketCreateStart},
        );

        # Export to string format
        my $TicketCreateUntil = $DateTimeObjectUntil->Format( Format => '%Y-%m-%d %H:%M:%S' );

        my $TicketCount = $TicketObject->TicketSearch(
            Result                    => $Param{Result},
            QueueIDs                  => [ $Param{QueueID} ],
            StateTyp                  => $Param{StateType},
            TicketCreateTimeOlderDate => $TicketCreateFrom,
            TicketCreateTimeNewerDate => $TicketCreateUntil,
            UserID                    => 1,
        );
        push @StatsRow, $TicketCount;
    }
    return \@StatsRow;
}

1;
