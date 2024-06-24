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

package Kernel::System::Ticket::Event::NotificationEvent::Transport::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

=head1 NAME

Kernel::System::Ticket::Event::NotificationEvent::Transport::Base - common notification event transport functions

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

=head2 _ReplaceTicketAttributes()

returns the specified field with replaced OTOBO-tags

    $RecipientEmail = $Self->_ReplaceTicketAttributes(
        Ticket => $Param{Ticket},
        Field  => $RecipientEmail,
    );

    for example: $RecipientEmail = '<OTOBO_TICKET_DynamicField_Name1>';

returns:

    $RecipientEmail = 'foo@bar.com';

=cut

sub _ReplaceTicketAttributes {
    my ( $Self, %Param ) = @_;

    return if !$Param{Field};

    # get needed objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # replace ticket attributes such as <OTOBO_Ticket_DynamicField_Name1> or
    # <OTOBO_TICKET_DynamicField_Name1>
    # <OTOBO_Ticket_*> is deprecated and should be removed in further versions of OTOBO
    my $Count = 0;
    REPLACEMENT:
    while (
        $Param{Field}
        && $Param{Field} =~ m{<OTOBO_TICKET_([A-Za-z0-9_]+)>}msxi
        && $Count++ < 1000
        )
    {
        my $TicketAttribute = $1;

        if ( $TicketAttribute =~ m{DynamicField_(\S+?)_Value} ) {
            my $DynamicFieldName = $1;

            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFieldName,
            );
            next REPLACEMENT if !$DynamicFieldConfig;

            # get the display value for each dynamic field
            my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                DynamicFieldConfig => $DynamicFieldConfig,
                Key                => $Param{Ticket}->{"DynamicField_$DynamicFieldName"},
            );

            my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $DisplayValue,
            );

            $Param{Field} =~ s{<OTOBO_TICKET_$TicketAttribute>}{$DisplayValueStrg->{Value} // ''}ige;

            next REPLACEMENT;
        }

        # if ticket value is scalar substitute all instances (as strings)
        # this will allow replacements for "<OTOBO_TICKET_Title> <OTOBO_TICKET_Queue"
        if ( !ref $Param{Ticket}->{$TicketAttribute} ) {
            $Param{Field} =~ s{<OTOBO_TICKET_$TicketAttribute>}{$Param{Ticket}->{$TicketAttribute} // ''}ige;
        }
        else {
            # if the value is an array (e.g. a multiselect dynamic field) set the value directly
            # this unfortunately will not let a combination of values to be replaced
            $Param{Field} = $Param{Ticket}->{$TicketAttribute};
        }
    }

    return $Param{Field};
}

1;
