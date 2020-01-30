# --
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_oooCustomer;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Login
    $Self->{Translation}->{'Your Tickets. Your OTOBO.'}   = 'Deine Tickets. Dein OTOBO.';

    # Dashboard
    $Self->{Translation}->{'# FAQ Article № 1'} = '# FAQ Artikel № 1';
    $Self->{Translation}->{'List of features coming with the OTOBO beta version.'} = 'Liste der Features, die in der OTOBO beta Version enthalten sein werden.';
    $Self->{Translation}->{'Show >'} = 'Anzeigen >';
    $Self->{Translation}->{'Message of the day'} = 'Aktuelle Informationen';
    $Self->{Translation}->{'Welcome %s, to your OTOBO.'} = 'Willkommen %s, in Deinem OTOBO.';
    $Self->{Translation}->{'Have fun exploring this preliminary version of the OTOBO customer interface!'} = 'Viel Spaß beim Ansehen dieser im Aufbau befindlichen Kundenansicht von OTOBO!';
    $Self->{Translation}->{'Your last tickets'} = 'Deine letzten Tickets';
    $Self->{Translation}->{'Your external tools'} = 'Externe Tools';

    return;

}

1;
