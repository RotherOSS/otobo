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

package Kernel::Output::HTML::Notification::OutofOfficeCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::User',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData( UserID => $Self->{UserID} );
    return '' if ( !$UserData{OutOfOffice} );

    my $CurSystemDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $OOOStartDTObject  = $Self->_GetOutOfOfficeDateTimeObject(
        UserData => \%UserData,
        Type     => 'Start'
    );
    my $OOOEndDTObject = $Self->_GetOutOfOfficeDateTimeObject(
        UserData => \%UserData,
        Type     => 'End'
    );

    if ( $OOOStartDTObject < $CurSystemDTObject && $OOOEndDTObject > $CurSystemDTObject ) {

        # get layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        return $LayoutObject->Notify(
            Priority => 'Notice',
            Link     => $LayoutObject->{Baselink} . 'Action=AgentPreferences',
            Data     =>
                $LayoutObject->{LanguageObject}->Translate("You have Out of Office enabled, would you like to disable it?"),
        );
    }

    return '';
}

sub _GetOutOfOfficeDateTimeObject {
    my ( $Self, %Param ) = @_;

    my $Type     = $Param{Type};
    my $UserData = $Param{UserData};

    my $DTString = sprintf(
        '%s-%s-%s %s',
        $UserData->{"OutOfOffice${Type}Year"},
        $UserData->{"OutOfOffice${Type}Month"},
        $UserData->{"OutOfOffice${Type}Day"},
        ( $Type eq 'End' ? '23:59:59' : '00:00:00' ),
    );

    return $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $DTString,
        },
    );
}

1;
