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

package Kernel::GenericInterface::Operation::Common;

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Common - Base class for all Operations

=head1 PUBLIC INTERFACE

=head2 Auth()

performs user or customer user authorization

    my ( $UserID, $UserType ) = $CommonObject->Auth(
        Data => {
            SessionID         => 'AValidSessionIDValue'     # the ID of the user session
            UserLogin         => 'Agent',                   # if no SessionID is given UserLogin or
                                                            #   CustomerUserLogin is required
            CustomerUserLogin => 'Customer',
            Password          => 'some password',           # user password
        },
    );

returns in case of successful authentication:

    (
        1,       # the UserID from login or session data
        'Agent', # 'Agent' or 'Customer', the UserType.
    );

returns in case of failed authentication:

    (
        0, # indicate that the user was not authenticated
    )

=cut

sub Auth {
    my ( $Self, %Param ) = @_;

    my $SessionID = $Param{Data}->{SessionID} || '';

    # check if a valid SessionID is present
    if ($SessionID) {
        my $ValidSessionID;

        # get session object
        my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        if ($SessionID) {
            $ValidSessionID = $SessionObject->CheckSessionID( SessionID => $SessionID );
        }

        return 0 unless $ValidSessionID;

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $SessionID,
        );

        # get UserID from SessionIDData
        if ( $UserData{UserID} && $UserData{UserType} ne 'Customer' ) {
            return ( $UserData{UserID}, $UserData{UserType} );
        }
        elsif ( $UserData{UserLogin} && $UserData{UserType} eq 'Customer' ) {

            # if UserCustomerLogin
            return ( $UserData{UserLogin}, $UserData{UserType} );
        }

        return 0;
    }

    if ( $Param{Data}->{UserLogin} ) {

        my $UserID = $Self->_AuthUser(%Param);

        # if UserLogin
        if ($UserID) {
            return ( $UserID, 'User' );
        }
    }
    elsif ( $Param{Data}->{CustomerUserLogin} ) {

        my $CustomerUserID = $Self->_AuthCustomerUser(%Param);

        # if UserCustomerLogin
        if ($CustomerUserID) {
            return ( $CustomerUserID, 'Customer' );
        }
    }

    return 0;
}

=head2 ReturnError()

helper function to return an error message.

    my $Return = $CommonObject->ReturnError(
        ErrorCode    => Ticket.AccessDenied,
        ErrorMessage => 'You don't have rights to access this ticket',
    );

=cut

sub ReturnError {
    my ( $Self, %Param ) = @_;

    $Self->{DebuggerObject}->Error(
        Summary => $Param{ErrorCode},
        Data    => $Param{ErrorMessage},
    );

    # return structure
    return {
        Success      => 1,
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
        Data         => {
            Error => {
                ErrorCode    => $Param{ErrorCode},
                ErrorMessage => $Param{ErrorMessage},
            },
        },
    };
}

=begin Internal:

=head2 _AuthUser()

performs user authentication

    my $UserID = $CommonObject->_AuthUser(
        UserLogin => 'Agent',
        Password  => 'some password',           # plain text password
    );

returns

    $UserID = 1;                                # the UserID from login or session data

=cut

sub _AuthUser {
    my ( $Self, %Param ) = @_;

    my $ReturnData = 0;

    # get params
    my $PostUser = $Param{Data}->{UserLogin} || '';
    my $PostPw   = $Param{Data}->{Password}  || '';

    # check submitted data
    my $User = $Kernel::OM->Get('Kernel::System::Auth')->Auth(
        User => $PostUser,
        Pw   => $PostPw,
    );

    # login is valid
    if ($User) {

        # get UserID
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $User,
        );
        $ReturnData = $UserID;
    }

    return $ReturnData;
}

=head2 _AuthCustomerUser()

performs customer user authentication

    my $UserID = $CommonObject->_AuthCustomerUser(
        UserLogin => 'Agent',
        Password  => 'some password',           # plain text password
    );

returns

    $UserID = 1;                               # the UserID from login or session data

=cut

sub _AuthCustomerUser {
    my ( $Self, %Param ) = @_;

    my $ReturnData = $Param{Data}->{CustomerUserLogin} || 0;

    # get params
    my $PostUser = $Param{Data}->{CustomerUserLogin} || '';
    my $PostPw   = $Param{Data}->{Password}          || '';

    # check submitted data
    my $User = $Kernel::OM->Get('Kernel::System::CustomerAuth')->Auth(
        User => $PostUser,
        Pw   => $PostPw,
    );

    # login is invalid
    if ( !$User ) {
        $ReturnData = 0;
    }

    return $ReturnData;
}

=end Internal:

=cut

1;
