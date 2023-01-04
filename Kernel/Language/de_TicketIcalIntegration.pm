# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Language::de_TicketIcalIntegration;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Notification
    $Self->{Translation}->{'Participation notification'} = "Benachrichtigung über Terminanfrage";
    $Self->{Translation}->{'You have %s open appointment participation.'}  = "Sie haben %s offene Terminanfrage.";
    $Self->{Translation}->{'You have %s open appointment participations.'} = "Sie haben %s offene Terminanfragen.";

    # Appointment Edit Dialog
    $Self->{Translation}->{'Invite'}             = "Einladen";
    $Self->{Translation}->{'Other participants'} = "Weitere Teilnehmende";
    $Self->{Translation}->{'Invitation'}         = "Einladung";
    $Self->{Translation}->{'Participation'}      = "Terminanfragen";
    $Self->{Translation}->{'Participations'}     = "Terminanfragen";
    $Self->{Translation}->{'Participants'}       = "Teilnehmende";

    # Participations Overview
    $Self->{Translation}->{'Participant'}                              = "Teilnahme von";
    $Self->{Translation}->{'Inviter'}                                  = "Einladung von";
    $Self->{Translation}->{'Calendar/Ticket#'}                          = "Kalender/Ticket#";
    $Self->{Translation}->{'Accept'}                                   = "Annehmen";
    $Self->{Translation}->{'Accepted'}                                 = "Angenommen";
    $Self->{Translation}->{'Accept Tentatively'}                       = "Vorläufig annehmen";
    $Self->{Translation}->{'Accepted Tentatively'}                     = "Vorläufig angenommen";
    $Self->{Translation}->{'Decline'}                                  = "Ablehnen";
    $Self->{Translation}->{'Declined'}                                 = "Abgelehnt";
    $Self->{Translation}->{'Manage Participations'}                    = "Terminanfragen verwalten";
    $Self->{Translation}->{'Appointment Participation manage screen.'} = "Übersicht über Terminanfragen";
    $Self->{Translation}->{'My Participations'}                        = "Meine Terminanfragen";
    $Self->{Translation}->{'My Ticket Participations'}                 = "Meine Ticket-Terminanfragen";

    # Widgets
    $Self->{Translation}->{'Invitations'}                         = "Termineinladungen";
    $Self->{Translation}->{'You have a conflicting appointment.'} = "Im ausgewählten Kalender befindet sich ein überschneidender Termin.";

    # $$STOP$$
    return;
}

1;
