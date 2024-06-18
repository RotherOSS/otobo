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

package Kernel::System::CustomerAuth;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SystemMaintenance',
);

=head1 NAME

Kernel::System::CustomerAuth - customer authentication module.

=head1 DESCRIPTION

The authentication module for the customer interface.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CustomerAuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load auth modules
    COUNT:
    for my $Count ( '', 1 .. 10 ) {

        my $GenericModule = $ConfigObject->Get("Customer::AuthModule$Count");

        next COUNT if !$GenericModule;

        if ( !$MainObject->Require($GenericModule) ) {
            $MainObject->Die("Can't load backend module $GenericModule! $@");
        }

        $Self->{"AuthBackend$Count"} = $GenericModule->new( %{$Self}, Count => $Count );
    }

    # load 2factor auth modules
    COUNT:
    for my $Count ( '', 1 .. 10 ) {

        my $GenericModule = $ConfigObject->Get("Customer::AuthTwoFactorModule$Count");

        next COUNT if !$GenericModule;

        if ( !$MainObject->Require($GenericModule) ) {
            $MainObject->Die("Can't load backend module $GenericModule! $@");
        }

        $Self->{"AuthTwoFactorBackend$Count"} = $GenericModule->new( %{$Self}, Count => $Count );
    }

    # Initialize last error message
    $Self->{LastErrorMessage} = '';

    return $Self;
}

=head2 GetOption()

Get module options. Currently there is just one option, "PreAuth".

    if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {
        print "No login screen is needed. Authentication is based on some other options. E. g. $ENV{REMOTE_USER}\n";
    }

=cut

sub GetOption {
    my ( $Self, %Param ) = @_;

    return $Self->{AuthBackend}->GetOption(%Param);
}

=head2 Auth()

The authentication function.

    if ( $AuthObject->Auth( User => $User, Pw => $Pw ) ) {
        print "Auth ok!\n";
    }
    else {
        print "Auth invalid!\n";
    }

=cut

sub Auth {
    my ( $Self, %Param ) = @_;

    # get customer user object
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');

    # use all 11 auth backends and return on first true
    my $User;
    COUNT:
    for my $Count ( '', 1 .. 10 ) {

        # next on no config setting
        next COUNT if !$Self->{"AuthBackend$Count"};

        # check auth backend
        $User = $Self->{"AuthBackend$Count"}->Auth(%Param);

        # next on no success
        if ( !$User ) {

            # get error message of auth backend if present
            if ( $Self->{"AuthBackend$Count"}->{AuthError} ) {
                $Self->{LastErrorMessage} = $Self->{"AuthBackend$Count"}->{AuthError};
            }

            next COUNT;
        }

        # check 2factor auth backends
        my $TwoFactorAuth;
        TWOFACTORSOURCE:
        for my $Count ( '', 1 .. 10 ) {

            # return on no config setting
            next TWOFACTORSOURCE if !$Self->{"AuthTwoFactorBackend$Count"};

            # 2factor backend
            my $AuthOk = $Self->{"AuthTwoFactorBackend$Count"}->Auth(
                TwoFactorToken => $Param{TwoFactorToken},
                User           => $User,
            );
            $TwoFactorAuth = $AuthOk ? 'passed' : 'failed';

            last TWOFACTORSOURCE if $AuthOk;
        }

        # if at least one 2factor auth backend was checked but none was successful,
        # it counts as a failed login
        if ( $TwoFactorAuth && $TwoFactorAuth ne 'passed' ) {
            $User = undef;
            last COUNT;
        }

        # remember auth backend
        if ($User) {
            $CustomerUserObject->SetPreferences(
                Key    => 'UserAuthBackend',
                Value  => $Count,
                UserID => $User,
            );

            last COUNT;
        }
    }

    # check if record exists
    if ( !$User ) {
        my %CustomerData = $CustomerUserObject->CustomerUserDataGet( User => $Param{User} );
        if (%CustomerData) {
            my $Count = $CustomerData{UserLoginFailed} || 0;
            $Count++;
            $CustomerUserObject->SetPreferences(
                Key    => 'UserLoginFailed',
                Value  => $Count,
                UserID => $CustomerData{UserLogin},
            );
        }
        return;
    }

    # check if user is valid
    my %CustomerData = $CustomerUserObject->CustomerUserDataGet( User => $User );
    if ( defined $CustomerData{ValidID} && $CustomerData{ValidID} ne 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$User' is set to invalid, can't login!",
        );
        return;
    }

    return $User if !%CustomerData;

    # reset failed logins
    $CustomerUserObject->SetPreferences(
        Key    => 'UserLoginFailed',
        Value  => 0,
        UserID => $CustomerData{UserLogin},
    );

    # on system maintenance customers
    # shouldn't be allowed get into the system
    my $ActiveMaintenance = $Kernel::OM->Get('Kernel::System::SystemMaintenance')->SystemMaintenanceIsActive();

    # check if system maintenance is active
    if ($ActiveMaintenance) {

        $Self->{LastErrorMessage} =
            $ConfigObject->Get('SystemMaintenance::IsActiveDefaultLoginErrorMessage')
            || Translatable("It is currently not possible to login due to a scheduled system maintenance.");

        return;
    }

    # last login preferences update
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    $CustomerUserObject->SetPreferences(
        Key    => 'UserLastLogin',
        Value  => $DateTimeObject->ToEpoch(),
        UserID => $CustomerData{UserLogin},
    );

    return $User;
}

=head2 PreAuth()

Call the PreAuth method of the AuthBackend

    my $PreAuthInfo = $AuthObject->PreAuth(
        RequestedURL => $RequestedURL,
    );

=cut

sub PreAuth {
    my ( $Self, %Param ) = @_;

    return if !$Self->{AuthBackend}->can('PreAuth');

    return $Self->{AuthBackend}->PreAuth(%Param);
}

=head2 PostAuth()

Call the PostAuth method of the AuthBackend

    my $PostAuthInfo = $AuthObject->PostAuth();

=cut

sub PostAuth {
    my ( $Self, %Param ) = @_;

    return if !$Self->{AuthBackend}->can('PostAuth');

    return $Self->{AuthBackend}->PostAuth(%Param);
}

=head2 Logout()

Call the Logout method of the AuthBackend

    my $LogoutInfo = $AuthObject->Logout();

=cut

sub Logout {
    my ( $Self, %Param ) = @_;

    return if !$Self->{AuthBackend}->can('Logout');

    return $Self->{AuthBackend}->Logout(%Param);
}

=head2 GetLastErrorMessage()

Retrieve $Self->{LastErrorMessage} content.

    my $AuthErrorMessage = $AuthObject->GetLastErrorMessage();

    Result:

        $AuthErrorMessage = "An error string message.";

=cut

sub GetLastErrorMessage {
    my ( $Self, %Param ) = @_;

    return $Self->{LastErrorMessage};
}

1;
