# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::ProcessManagement::Activity;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ProcessManagement::Activity - Activities lib

=head1 DESCRIPTION

All Process Management Activity functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ActivityObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ActivityGet()

    Get Activity info
    Returned activity dialogs are limited to given interface

    my $Activity = $ActivityObject->ActivityGet(
        ActivityEntityID => 'A1',
        Interface        => ['AgentInterface'],   # ['AgentInterface'] or ['CustomerInterface'] or ['AgentInterface', 'CustomerInterface'] or 'all'
    );

    Returns:

    $Activity = {
          'Name'           => 'Activity 3'
          'CreateTime'     => '08-02-2012 13:37:00',
          'ChangeBy'       => '2',
          'ChangeTime'     => '09-02-2012 13:37:00',
          'CreateBy'       => '3',
          'ActivityDialog' => {
              '1' => 'AD5',
              '3' => 'AD7',
              '2' => 'AD6',
            },
        };

=cut

sub ActivityGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ActivityEntityID Interface)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Activity = $ConfigObject->Get('Process::Activity');

    if ( !IsHashRefWithData($Activity) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Activity config!'
        );
        return;
    }

    my $ActivityEntity = $Activity->{ $Param{ActivityEntityID} };

    if ( !IsHashRefWithData($ActivityEntity) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No data for Activity '$Param{ActivityEntityID}' found!"
        );
        return;
    }

    # limit activity dialogs by interface
    return $ActivityEntity if ref $Param{Interface} ne 'ARRAY' && $Param{Interface} eq 'all';
    if ( ref $Param{Interface} ne 'ARRAY' && $Param{Interface} ne 'all' ) {
        $Param{Interface} = [ $Param{Interface} ];
    }

    # get activity dialogs
    my $ActivityDialogs = $ConfigObject->Get('Process::ActivityDialog');

    if ( IsHashRefWithData( $ActivityEntity->{ActivityDialog} ) ) {

        # filter activity dialogs
        ACTIVITYDIALOG:
        for my $ActivityDialogID ( sort keys %{ $ActivityEntity->{ActivityDialog} } ) {
            my $ActivityDialog = $ActivityEntity->{ActivityDialog}->{$ActivityDialogID};
            if ( IsHashRefWithData($ActivityDialog) ) {
                $ActivityDialog = $ActivityDialog->{ActivityDialogEntityID};
            }
            for my $Interface ( @{ $Param{Interface} } ) {

                # keep activity dialog if interface is included in activity dialog configuration
                if (
                    grep { $_ eq $Interface } @{ $ActivityDialogs->{$ActivityDialog}->{Interface} }
                    )
                {
                    next ACTIVITYDIALOG;
                }
            }

            # remove activity dialog if no match could be found
            delete $ActivityEntity->{ActivityDialog}->{$ActivityDialogID};
        }
    }

    return $ActivityEntity;
}

=head2 ActivityList()

    Get a list of all Activities

    my $Activities = $ActivityObject->ActivityList();

    Returns:

    $ActivityList = {
        'A1' => 'Activity 1',
        'A2' => 'Activity 2',
        'A3' => '',
    };

=cut

sub ActivityList {
    my ( $Self, %Param ) = @_;

    my $Activities = $Kernel::OM->Get('Kernel::Config')->Get('Process::Activity');

    if ( !IsHashRefWithData($Activities) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Activity config!'
        );
        return;
    }

    my %ActivityList = map { $_ => $Activities->{$_}->{Name} || '' } keys %{$Activities};

    return \%ActivityList;
}

1;
