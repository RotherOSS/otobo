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

package Kernel::Output::HTML::CustomerUser::OverviewAddressBook;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerUser',
    'Kernel::System::Log',
    'Kernel::System::JSON',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = \%Param;
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !$Param{CustomerUserIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerUserIDs!',
        );
        return;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my @IDs = @{ $Param{CustomerUserIDs} };

    my @ShowColumns;
    if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
        @ShowColumns = @{ $Param{ShowColumns} };
    }

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    my @RecordHeaderColumns;

    # Build the column header for the output in the result page.
    if (@ShowColumns) {
        for my $Column (@ShowColumns) {

            my $CSS = 'OverviewHeader';
            my $OrderBy;

            # Set the correct Set CSS class and order by link.
            if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                    $OrderBy = 'Down';
                    $CSS .= ' SortAscendingLarge';
                }
                else {
                    $OrderBy = 'Up';
                    $CSS .= ' SortDescendingLarge';
                }
            }
            else {
                $OrderBy = 'Up';
            }

            # Get more information from the current field for the output (e.g. label).
            my %FieldConfig = $CustomerUserObject->GetFieldConfig(
                FieldName => $Column,
            );

            push @RecordHeaderColumns, {
                Name    => $Column,
                Label   => $FieldConfig{Label},
                CSS     => $CSS,
                OrderBy => $OrderBy,
            };
        }
    }

    my @RecordDataColumns;
    my $Output  = '';
    my $Counter = 0;

    # Show customer user if there are some given from the search result.
    if (@IDs) {

        ID:
        for my $ID (@IDs) {
            $Counter++;
            if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

                my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                    User => $ID,
                );

                next ID if !%CustomerUser;

                # Disable the already selected customer user in the result table.
                if ( $Param{LookupExcludeUserLogins}->{$ID} || !$CustomerUser{ $Param{CustomerTicketTextField} } ) {
                    $CustomerUser{Disabled} = 1;
                }

                # Set the checkbox for the already selected customer user to 'checked'.
                if ( $Param{LookupExcludeUserLogins}->{$ID} ) {
                    $CustomerUser{AlreadySelected} = 1;
                }

                push @RecordDataColumns, {
                    %CustomerUser,
                };
            }
        }
    }

    # Create the recipient json string for the output in the input field.
    $Param{RecipientsJSON} = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Recipients},
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentCustomerUserAddressBookOverview',
        Data         => {
            %Param,
            RecordHeaderColumns => \@RecordHeaderColumns,
            RecordDataColumns   => \@RecordDataColumns,
            Type                => $Self->{ViewType},
            ColumnCount         => scalar @ShowColumns + 1,
        },
    );

    return $Output;
}

1;
