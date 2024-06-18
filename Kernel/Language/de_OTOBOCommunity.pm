# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::Language::de_OTOBOCommunity;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentStatisticsReportsAdd
    $Self->{Translation}->{'Report Management'} = 'Berichteverwaltung';
    $Self->{Translation}->{'Add Report'} = 'Bericht hinzufügen';

    # Template: AgentStatisticsReportsEdit
    $Self->{Translation}->{'Edit Report'} = 'Bericht bearbeiten';
    $Self->{Translation}->{'Here you can combine several statistics to a report which you can generate as a PDF manually or automatically at configured times.'} =
        'Hier können Sie mehrere Statistiken zu einem Report kombinieren, den Sie dann manuell oder zu festgelegten Zeitpunkten als PDF generieren lassen können.';
    $Self->{Translation}->{'Please note that you can only select charts as statistics output format if you configured one of the renderer binaries on your system.'} =
        'Bitte beachten Sie, dass Sie Diagramme nur dann als Statistik-Ausgabeformat auswählen können, wenn Sie eines der Renderer-Binärdateien auf Ihrem System konfiguriert haben.';
    $Self->{Translation}->{'Configure PhantomJS'} = 'PhantomJS konfigurieren';
    $Self->{Translation}->{'Configure GoogleChrome'} = 'Google Chrome konfigurieren';
    $Self->{Translation}->{'General settings'} = 'Generelle Einstellungen';
    $Self->{Translation}->{'Automatic generation settings'} = 'Einstellungen zur automatischen Erzeugung';
    $Self->{Translation}->{'Automatic generation times (cron)'} = 'Zeitpunkte für die automatische Erzeugung (cron)';
    $Self->{Translation}->{'Specify when the report should be automatically generated in cron format, e. g. "10 1 * * *" for every day at 1:10 am.'} =
        'Geben Sie im Cron-Format an, zu welchen Zeiten der Report automatisch erzeugt werden soll (z. B. "10 1 * * *" für täglich um 1:10 morgens.)';
    $Self->{Translation}->{'Times are in the system timezone.'} = 'Zeiten sind in der System-Zeitzone.';
    $Self->{Translation}->{'Last automatic generation time'} = 'Zuletzt automatisch erzeugt';
    $Self->{Translation}->{'Next planned automatic generation time'} = 'Wird als nächstes planmäßig erzeugt';
    $Self->{Translation}->{'Automatic generation language'} = 'Sprache für automatische Erzeugung';
    $Self->{Translation}->{'The language to be used when the report is automatically generated.'} =
        'Die Sprache, die verwendet werden soll, wenn der Report automatisch erzeugt wird.';
    $Self->{Translation}->{'Email subject'} = 'E-Mail-Betreff';
    $Self->{Translation}->{'Specify the subject for the automatically generated email.'} = 'Geben sie den Betreff für die automatisch erzeugte E-Mail an.';
    $Self->{Translation}->{'Email body'} = 'E-Mail-Inhalt';
    $Self->{Translation}->{'Specify the text for the automatically generated email.'} = 'Geben Sie den Text für die E-Mail an.';
    $Self->{Translation}->{'Email recipients'} = 'E-Mail-Empfänger';
    $Self->{Translation}->{'Specify recipient email addresses (comma separated).'} = 'Geben Sie Empfänger-Email-Adressen an (durch Komma getrennt).';
    $Self->{Translation}->{'Output settings'} = 'Ausgabe-Einstellungen';
    $Self->{Translation}->{'Headline'} = 'Kopfzeile';
    $Self->{Translation}->{'Caption for preamble'} = 'Überschrift der Einleitung';
    $Self->{Translation}->{'Preamble'} = 'Einleitung';
    $Self->{Translation}->{'Caption for epilogue'} = 'Überschrift des Abschlusstextes';
    $Self->{Translation}->{'Epilogue'} = 'Abschlusstext';
    $Self->{Translation}->{'Add statistic to report'} = 'Statistik zum Report hinzufügen';

    # Template: AgentStatisticsReportsOverview
    $Self->{Translation}->{'Statistics Reports'} = 'Statistik-Reports';
    $Self->{Translation}->{'Edit statistics report "%s".'} = 'Statistik-Report "%s" bearbeiten.';
    $Self->{Translation}->{'Delete statistics report "%s"'} = 'Statistik-Report "%s" löschen.';

    # Template: AgentStatisticsReportsView
    $Self->{Translation}->{'View Report'} = 'Bericht anzeigen';
    $Self->{Translation}->{'This statistics report contains configuration errors and can currently not be used.'} =
        'Dieser Statistik-Report enthält Konfigurationsfehler und kann momentan nicht genutzt werden.';

    # Perl Module: Kernel/Modules/AgentStatisticsReports.pm
    $Self->{Translation}->{'Got no %s!'} = 'Keine %s erhalten!';
    $Self->{Translation}->{'Add New Statistics Report'} = 'Neuen Statistik-Report hinzufügen';
    $Self->{Translation}->{'This name is already in use, please choose a different one.'} = 'Dieser Name wird bereits genutzt, bitte verwenden Sie einen anderen.';
    $Self->{Translation}->{'Could not create report.'} = 'Der Report konnte nicht erstellt werden.';
    $Self->{Translation}->{'Need StatsReportID!'} = 'Benötige StatsReportID!';
    $Self->{Translation}->{'Edit Statistics Report'} = 'Statistikreport bearbeiten';
    $Self->{Translation}->{'Could not find report.'} = 'Report konnte nicht gefunden werden.';
    $Self->{Translation}->{'Please provide a valid cron entry.'} = 'Bitte geben Sie einen gültigen Cron-Eintrag an.';
    $Self->{Translation}->{'Could not update report.'} = 'Report konnte nicht aktualisiert werden.';
    $Self->{Translation}->{'View Statistics Report'} = 'Statistikreport anzeigen';
    $Self->{Translation}->{'Delete: Got no StatsReportID!'} = 'Löschen: Keine StatsReportID erhalten!';

    # Perl Module: Kernel/Output/PDF/StatisticsReports.pm
    $Self->{Translation}->{'%s Report'} = '%s Report';
    $Self->{Translation}->{'Error: this graph could not be generated: %s.'} = 'Fehler: Diese Grafik konnte nicht erzeugt werden: %s.';
    $Self->{Translation}->{'Table of Contents'} = 'Inhaltsübersicht';

}

1;
