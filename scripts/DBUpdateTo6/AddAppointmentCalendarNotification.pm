# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package scripts::DBUpdateTo6::AddAppointmentCalendarNotification;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::NotificationEvent',
    'Kernel::System::Valid',
);

=head1 NAME

scripts::DBUpdateTo6::AddAppointmentCalendarNotification - Add AppointmentCalendar notification.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my %AppointmentNotifications = (
        'Appointment reminder notification' => {
            Data => {
                NotificationType       => ['Appointment'],
                VisibleForAgent        => [1],
                VisibleForAgentTooltip => [
                    'You will receive a notification each time a reminder time is reached for one of your appointments.'
                ],
                Events                => ['AppointmentNotification'],
                Recipients            => ['AppointmentAgentReadPermissions'],
                SendOnOutOfOffice     => [1],
                Transports            => ['Email'],
                AgentEnabledByDefault => ['Email'],
            },
            Message => {
                'de' => {
                    'Body' => 'Hallo &lt;OTOBO_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
Termin &quot;&lt;OTOBO_APPOINTMENT_TITLE&gt;&quot; hat seine Benachrichtigungszeit erreicht.<br />
<br />
Beschreibung: &lt;OTOBO_APPOINTMENT_DESCRIPTION&gt;<br />
Standort: &lt;OTOBO_APPOINTMENT_LOCATION&gt;<br />
Kalender: <span style="color: &lt;OTOBO_CALENDAR_COLOR&gt;;">■</span> &lt;OTOBO_CALENDAR_CALENDARNAME&gt;<br />
Startzeitpunkt: &lt;OTOBO_APPOINTMENT_STARTTIME&gt;<br />
Endzeitpunkt: &lt;OTOBO_APPOINTMENT_ENDTIME&gt;<br />
Ganztägig: &lt;OTOBO_APPOINTMENT_ALLDAY&gt;<br />
Wiederholung: &lt;OTOBO_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTOBO_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Erinnerung: <OTOBO_APPOINTMENT_TITLE>',
                },
                'en' => {
                    'Body' => 'Hi &lt;OTOBO_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
appointment &quot;&lt;OTOBO_APPOINTMENT_TITLE&gt;&quot; has reached its notification time.<br />
<br />
Description: &lt;OTOBO_APPOINTMENT_DESCRIPTION&gt;<br />
Location: &lt;OTOBO_APPOINTMENT_LOCATION&gt;<br />
Calendar: <span style="color: &lt;OTOBO_CALENDAR_COLOR&gt;;">■</span> &lt;OTOBO_CALENDAR_CALENDARNAME&gt;<br />
Start date: &lt;OTOBO_APPOINTMENT_STARTTIME&gt;<br />
End date: &lt;OTOBO_APPOINTMENT_ENDTIME&gt;<br />
All-day: &lt;OTOBO_APPOINTMENT_ALLDAY&gt;<br />
Repeat: &lt;OTOBO_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTOBO_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Reminder: <OTOBO_APPOINTMENT_TITLE>',
                },
                'hu' => {
                    'Body' => 'Kedves &lt;OTOBO_NOTIFICATION_RECIPIENT_UserFirstname&gt;!<br />
<br />
A következő esemény elérte az értesítési idejét: &lt;OTOBO_APPOINTMENT_TITLE&gt;<br />
<br />
Leírás: &lt;OTOBO_APPOINTMENT_DESCRIPTION&gt;<br />
Hely: &lt;OTOBO_APPOINTMENT_LOCATION&gt;<br />
Naptár: <span style="color: &lt;OTOBO_CALENDAR_COLOR&gt;;">■</span> &lt;OTOBO_CALENDAR_CALENDARNAME&gt;<br />
Kezdési dátum: &lt;OTOBO_APPOINTMENT_STARTTIME&gt;<br />
Befejezési dátum: &lt;OTOBO_APPOINTMENT_ENDTIME&gt;<br />
Egész napos: &lt;OTOBO_APPOINTMENT_ALLDAY&gt;<br />
Ismétlődés: &lt;OTOBO_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTOBO_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Emlékeztető: <OTOBO_APPOINTMENT_TITLE>',
                },
                'sr_Cyrl' => {
                    'Body' => 'Здраво &lt;OTOBO_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
време је за обавештење у вези термина &quot;&lt;OTOBO_APPOINTMENT_TITLE&gt;&quot;.<br />
<br />
Опис: &lt;OTOBO_APPOINTMENT_DESCRIPTION&gt;<br />
Локација: &lt;OTOBO_APPOINTMENT_LOCATION&gt;<br />
Календар: <span style="color: &lt;OTOBO_CALENDAR_COLOR&gt;;">■</span> &lt;OTOBO_CALENDAR_CALENDARNAME&gt;<br />
Датум почетка: &lt;OTOBO_APPOINTMENT_STARTTIME&gt;<br />
Датум краја: &lt;OTOBO_APPOINTMENT_ENDTIME&gt;<br />
Целодневно: &lt;OTOBO_APPOINTMENT_ALLDAY&gt;<br />
Понављање: &lt;OTOBO_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTOBO_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Подсетник: <OTOBO_APPOINTMENT_TITLE>',
                },
                'sr_Latn' => {
                    'Body' => 'Zdravo &lt;OTOBO_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
vreme je za obaveštenje u vezi termina &quot;&lt;OTOBO_APPOINTMENT_TITLE&gt;&quot;.<br />
<br />
Opis: &lt;OTOBO_APPOINTMENT_DESCRIPTION&gt;<br />
Lokacije: &lt;OTOBO_APPOINTMENT_LOCATION&gt;<br />
Kalendar: <span style="color: &lt;OTOBO_CALENDAR_COLOR&gt;;">■</span> &lt;OTOBO_CALENDAR_CALENDARNAME&gt;<br />
Datum početka: &lt;OTOBO_APPOINTMENT_STARTTIME&gt;<br />
Datum kraja: &lt;OTOBO_APPOINTMENT_ENDTIME&gt;<br />
Celodnevno: &lt;OTOBO_APPOINTMENT_ALLDAY&gt;<br />
Ponavljanje: &lt;OTOBO_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTOBO_CONFIG_HttpType&gt;://&lt;OTOBO_CONFIG_FQDN&gt;/&lt;OTOBO_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTOBO_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTOBO_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Podsetnik: <OTOBO_APPOINTMENT_TITLE>',
                },
            },
        },
    );

    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    # Get all notifications of appointment type.
    my %NotificationList = $NotificationEventObject->NotificationList(
        Type => 'Appointment',
    );
    my %NotificationListReverse = reverse %NotificationList;

    NEWNOTIFICATION:
    for my $NotificationName ( sort keys %AppointmentNotifications ) {

        # Do not add new notification if one with the same name exists.
        next NEWNOTIFICATION if $NotificationListReverse{$NotificationName};

        # Add new event notification.
        my $ID = $NotificationEventObject->NotificationAdd(
            Name    => $NotificationName,
            Data    => $AppointmentNotifications{$NotificationName}->{Data},
            Message => $AppointmentNotifications{$NotificationName}->{Message},
            Comment => '',
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );

        return if !$ID;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
