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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

for my $TicketHook ( 'Ticket#', 'Call#', 'Ticket' ) {

    for my $TicketSubjectConfig ( 'Right', 'Left' ) {

        # make sure that the TicketObject gets recreated for each loop.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

        $ConfigObject->Set(
            Key   => 'Ticket::Hook',
            Value => $TicketHook,
        );
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFormat',
            Value => $TicketSubjectConfig,
        );
        $ConfigObject->Set(
            Key   => 'Ticket::NumberGenerator',
            Value => 'Kernel::System::Ticket::Number::DateChecksum',
        );
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectRe',
            Value => 'RE',
        );
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFwd',
            Value => 'AW',
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # check GetTNByString
        my $Tn     = $TicketObject->TicketCreateNumber() || 'NONE!!!';
        my $String = 'Re: ' . $TicketObject->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject      => 'Some Test',
        );
        my $TnGet = $TicketObject->GetTNByString($String) || 'NOTHING FOUND!!!';
        $Self->Is(
            $TnGet,
            $Tn,
            "GetTNByString() (DateChecksum: true eq)",
        );
        $Self->IsNot(
            $TicketObject->GetTNByString('Ticket#: 200206231010138') || '',
            $Tn,
            "GetTNByString() (DateChecksum: false eq)",
        );
        $Self->False(
            $TicketObject->GetTNByString("Ticket#: 1234567") || 0,
            "GetTNByString() (DateChecksum: false)",
        );

        my $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Re: [' . $TicketHook . ': 2004040510440485] Re: RE: Some Subject',
        );
        $Self->Is(
            $NewSubject,
            'Some Subject',
            "TicketSubjectClean() Re:",
        );

        # TicketSubjectClean()
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Re[5]: [' . $TicketHook . ': 2004040510440485] Re: RE: WG: Some Subject',
        );
        $Self->Is(
            $NewSubject,
            'WG: Some Subject',
            "TicketSubjectClean() Re[5]:",
        );

        # TicketSubjectClean()
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Re[5]: Re: RE: WG: Some Subject [' . $TicketHook . ': 2004040510440485]',
        );
        $Self->Is(
            $NewSubject,
            'WG: Some Subject',
            "TicketSubjectClean() Re[5]",
        );

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject      => "Re: [$TicketHook: 2004040510440485] Re: RE: WG: Some Subject",
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                'RE: [' . $TicketHook . '2004040510440485] WG: Some Subject',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'RE: WG: Some Subject [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        # check Ticket::SubjectRe with "Antwort"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectRe',
            Value => 'Antwort',
        );
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Antwort: ['
                . $TicketHook
                . ': 2004040510440485] Antwort: Antwort: Some Subject2',
        );
        $Self->Is(
            $NewSubject,
            'Some Subject2',
            "TicketSubjectClean() Antwort:",
        );

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject      => '[' . $TicketHook . ':2004040510440485] Antwort: Antwort: Some Subject2',
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                'Antwort: [' . $TicketHook . '2004040510440485] Some Subject2',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'Antwort: Some Subject2 [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        # check Ticket::SubjectRe with "Antwort"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectRe',
            Value => '',
        );
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'RE: ['
                . $TicketHook
                . ': 2004040510440485] Antwort: Antwort: Some Subject2',
        );
        $Self->Is(
            $NewSubject,
            'RE: Antwort: Antwort: Some Subject2',
            "TicketSubjectClean() Re: Antwort:",
        );

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject      => 'Re: [' . $TicketHook . ': 2004040510440485] Re: Antwort: Some Subject2',
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                '[' . $TicketHook . '2004040510440485] Re: Re: Antwort: Some Subject2',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'Re: Re: Antwort: Some Subject2 [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        $ConfigObject->Set(
            Key   => 'Ticket::SubjectRe',
            Value => 'Re',
        );

        # TicketSubjectClean()
        # check Ticket::SubjectFwd with "FWD"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFwd',
            Value => 'FWD',
        );

        # TicketSubjectBuild()
        $NewSubject = $TicketObject->TicketSubjectBuild(
            TicketNumber => '2004040510440485',
            Subject      => "Re: [$TicketHook: 2004040510440485] Re: RE: WG: Some Subject",
            Action       => 'Forward',
        );
        if ( $TicketSubjectConfig eq 'Left' ) {
            $Self->Is(
                $NewSubject,
                'FWD: [' . $TicketHook . '2004040510440485] WG: Some Subject',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }
        else {
            $Self->Is(
                $NewSubject,
                'FWD: WG: Some Subject [' . $TicketHook . '2004040510440485]',
                "TicketSubjectBuild() $TicketSubjectConfig ($NewSubject)",
            );
        }

        # check Ticket::SubjectFwd with "WG"
        $ConfigObject->Set(
            Key   => 'Ticket::SubjectFwd',
            Value => 'WG',
        );
        $NewSubject = $TicketObject->TicketSubjectClean(
            TicketNumber => '2004040510440485',
            Subject      => 'Antwort: ['
                . $TicketHook
                . ': 2004040510440485] WG: Fwd: Some Subject2',
            Action => 'Forward',
        );
        $Self->Is(
            $NewSubject,
            'Antwort: WG: Fwd: Some Subject2',
            "TicketSubjectClean() Antwort:",
        );
    }
}

$Self->DoneTesting();
