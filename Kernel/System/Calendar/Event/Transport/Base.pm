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

package Kernel::System::Calendar::Event::Transport::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
);

=head1 NAME

Kernel::System::Calendar::Event::Transport::Base - common notification event transport functions

=head1 PUBLIC INTERFACE

=head2 SendNotification()

send a notification using an specified transport

    my $Success = $TransportObject->SendNotification(
        TicketID     => $Param{Data}->{TicketID},
        UserID       => $Param{UserID},
        Notification => \%Notification,
        Recipient    => {
            UserID        => 123,
            UserLogin     => 'some login',
            UserTitle     => 'some title',
            UserFirstname => 'some first name',
            UserLastname  => 'some last name'.
            # ...
        },
        Event                 => $Param{Event},
        Attachments           => \@Attachments,         # optional
    );

returns

    $Success = 1;       # or false in case of an error

=cut

=head2 GetTransportRecipients()

generates a list of recipients exclusive for a determined transport, the content of the list is
usually an attribute of an Agent or Customer and it depends on each transport

    my @TransportRecipients = $TransportObject->GetTransportRecipients(
        Notification => \%Notification,
    );

returns:

    @TransportRecipents = (
        {
            UserEmail     => 'some email',       # optional
            UserFirstname => 'some name',        # optional
            # ...                                # optional
        }
    );

or
    @TransportRecipients = undef;   in case of an error

=cut

=head2 TransportSettingsDisplayGet()

generates and returns the HTML code to display exclusive settings for each transport.

    my $HTMLOutput = $TransportObject->TransportSettingsDisplayGet(
        Data => $NotificationDataAttribute,           # as retrieved from Kernel::System::NotificationEvent::NotificationGet()
    );

returns

    $HTMLOutput = 'some HTML code';

=cut

=head2 TransportParamSettingsGet()

gets specific parameters from the web request and put them back in the GetParam attribute to be
saved in the notification as the standard parameters

    my $Success = $TransportObject->TransportParamSettingsGet(
        GetParam => $ParmHashRef,
    );

returns

    $Success = 1;       # or false in case of a failure

=cut

=head2 IsUsable();

returns if the transport can be used in the system environment,

    my $Success = $TransportObject->IsUsable();

returns

    $Success = 1;       # or false

=cut

=head2 GetTransportEventData()

returns the needed event information after a notification has been sent

    my $EventData = $TransportObject-> GetTransportEventData();

returns:

    $EventData = {
        Event => 'ArticleAgentNotification',    # or 'ArticleCustomerNotification'
        Data  => {
            TicketID  => 123,
            ArticleID => 123,                   # optional
        },
        UserID => 123,
    );

=cut

sub GetTransportEventData {
    my ( $Self, %Param ) = @_;

    return $Self->{EventData} // {};
}

1;
