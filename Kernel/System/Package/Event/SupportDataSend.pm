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

package Kernel::System::Package::Event::SupportDataSend;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::SystemData',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get system data object
    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    my $RegistrationState = $SystemDataObject->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    # do nothing if system is not register
    return 1 if $RegistrationState ne 'registered';

    my $SupportDataSending = $SystemDataObject->SystemDataGet(
        Key => 'Registration::SupportDataSending',
    ) || 'No';

    # return if Data Sending is not activated
    return 1 if $SupportDataSending ne 'Yes';

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SupportDataCollector',
        Key  => 'DataCollect',
    );

    # get time object
    my $NewUpdateDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $NewUpdateDateTimeObject->Add( Hours => 1 );

    # get current update time
    my $CurrentUpdateTime = $SystemDataObject->SystemDataGet(
        Key => 'Registration::NextUpdateTime',
    );

    # if there is no update time set it for 1 hour
    if ( !defined $CurrentUpdateTime ) {
        $SystemDataObject->SystemDataAdd(
            Key    => 'Registration::NextUpdateTime',
            Value  => $NewUpdateDateTimeObject->ToString(),
            UserID => 1,
        );
        return 1;
    }

    my $CurrentUpdateDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $CurrentUpdateTime,
        }
    );

    # return success if the next update is schedule in or less than 1 hour
    return 1 if $CurrentUpdateDateTimeObject <= $NewUpdateDateTimeObject;

    # otherwise update next update for 1 hour
    $SystemDataObject->SystemDataUpdate(
        Key    => 'Registration::NextUpdateTime',
        Value  => $NewUpdateDateTimeObject->ToString(),
        UserID => 1,
    );
    return 1;
}

1;
