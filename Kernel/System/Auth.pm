# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::Auth;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SystemMaintenance',
    'Kernel::System::User',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Auth - agent authentication and synchronization module.

=head1 DESCRIPTION

The authentication and synchronization module for the agent interface.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # load auth modules
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    AUTH_COUNT:
    for my $AuthCount ( '', 1 .. 10 ) {

        my $AuthModule = $ConfigObject->Get("AuthModule$AuthCount");

        next AUTH_COUNT unless $AuthModule;

        if ( !$MainObject->Require($AuthModule) ) {
            $MainObject->Die("Can't load backend module $AuthModule! $@");
        }

        $Self->{"AuthBackend$AuthCount"} = $AuthModule->new(
            Count => $AuthCount
        );
    }

    # load 2factor auth modules
    TWO_FACTOR_COUNT:
    for my $TwoFactorCount ( '', 1 .. 10 ) {

        my $TwoFactorModule = $ConfigObject->Get("AuthTwoFactorModule$TwoFactorCount");

        next TWO_FACTOR_COUNT unless $TwoFactorModule;

        if ( !$MainObject->Require($TwoFactorModule) ) {
            $MainObject->Die("Can't load backend module $TwoFactorModule! $@");
        }

        $Self->{"AuthTwoFactorBackend$TwoFactorCount"} = $TwoFactorModule->new(
            %{$Self},
            Count => $TwoFactorCount
        );
    }

    # load sync modules
    SYNC_COUNT:
    for my $SyncCount ( '', 1 .. 10 ) {

        my $SyncModule = $ConfigObject->Get("AuthSyncModule$SyncCount");

        if ( !$MainObject->Require($SyncModule) ) {
            $MainObject->Die("Can't load backend module $SyncModule! $@");
        }

        $Self->{"AuthSyncBackend$SyncCount"} = $SyncModule->new(
            %{$Self},
            Count => $SyncCount
        );
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

    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # use all 11 auth backends and return on first true
    my $User;
    COUNT:
    for my $Count ( '', 1 .. 10 ) {

        # handle only the already loaded auth backends
        next COUNT unless $Self->{"AuthBackend$Count"};

        # check auth backend
        $User = $Self->{"AuthBackend$Count"}->Auth(%Param);

        # try the next auth backend on no success
        if ( !$User ) {

            # get error message of auth backend if present
            if ( $Self->{"AuthBackend$Count"}->{AuthError} ) {
                $Self->{LastErrorMessage} = $Self->{"AuthBackend$Count"}->{AuthError};
            }

            next COUNT;
        }

        # Sync will happen before two factor authentication (if configured)
        # because user might not exist before being created in sync (see bug #11966).
        # A failed two factor auth after successful sync will result
        # in a new or updated user but no information or permission leak.

        # Sync via the explicitly configured auth sync backend for the current auth backend.
        # This is the backend which has just verified the authentication.
        # $AuthSyncBackend must be the key for one of the already loaded auth sync backends.
        # Only a single backend is supported in this case.
        my $AuthSyncBackend = $ConfigObject->Get("AuthModule::UseSyncBackend$Count");
        if ( defined $AuthSyncBackend ) {

            if ($AuthSyncBackend) {

                # sync via the configured backend
                $Self->{$AuthSyncBackend}->Sync( %Param, User => $User );
            }
            else {
                # do nothing
                # if $AuthSyncBackend is defined but empty, don't sync with any backend
            }
        }

        # When there sync backend is not declared then run all of the potentially 11 sync backends.
        # The user is created in the database on the first match.
        # This means that different backend can provide different pieces,
        # or that later backends may overwrite data from previous backends.
        else {
            SYNC_COUNT:
            for my $SyncCount ( '', 1 .. 10 ) {

                # handle only the loaded backends
                next SYNC_COUNT unless $Self->{"AuthSyncBackend$SyncCount"};

                # sync backend
                $Self->{"AuthSyncBackend$SyncCount"}->Sync(
                    %Param,
                    User => $User
                );
            }
        }

        # Having no UserID at this point means
        # that authentication was ok but user didn't exist before
        # and wasn't created in sync module.
        # We will skip two factor authentication even if configured
        # because we don't have user data to compare the otp anyway.
        # This will not count as a failed login.
        my $UserID = $UserObject->UserLookup(
            UserLogin => $User,
        );

        last COUNT if !$UserID;

        # check 2factor auth backends
        my $TwoFactorAuth;
        TWO_FACTOR_COUNT:
        for my $TwoFactorCount ( '', 1 .. 10 ) {

            # return on no config setting
            next TWO_FACTOR_COUNT unless $Self->{"AuthTwoFactorBackend$TwoFactorCount"};

            # 2factor backend
            my $AuthOk = $Self->{"AuthTwoFactorBackend$TwoFactorCount"}->Auth(
                TwoFactorToken => $Param{TwoFactorToken},
                User           => $User,
                UserID         => $UserID,
            );
            $TwoFactorAuth = $AuthOk ? 'passed' : 'failed';

            last TWO_FACTOR_COUNT if $AuthOk;
        }

        # if at least one 2factor auth backend was checked but none was successful,
        # it counts as a failed login
        if ( $TwoFactorAuth && $TwoFactorAuth ne 'passed' ) {
            $User = undef;

            last COUNT;
        }

        # remember auth backend
        $UserObject->SetPreferences(
            Key    => 'UserAuthBackend',
            Value  => $Count,
            UserID => $UserID,
        );

        last COUNT;
    }

    # return if no auth user
    if ( !$User ) {

        # remember failed logins
        my $UserID = $UserObject->UserLookup(
            UserLogin => $Param{User},
        );

        return if !$UserID;

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
            Valid  => 1,
        );

        my $FailedCount = $User{UserLoginFailed} || 0;
        $FailedCount++;

        $UserObject->SetPreferences(
            Key    => 'UserLoginFailed',
            Value  => $FailedCount,
            UserID => $UserID,
        );

        # set agent to invalid-temporarily if max failed logins reached
        my $Config = $ConfigObject->Get('PreferencesGroups');
        my $PasswordMaxLoginFailed;

        if ( $Config && $Config->{Password} && $Config->{Password}->{PasswordMaxLoginFailed} ) {
            $PasswordMaxLoginFailed = $Config->{Password}->{PasswordMaxLoginFailed};
        }

        return if !%User;
        return if !$PasswordMaxLoginFailed;
        return if $FailedCount < $PasswordMaxLoginFailed;

        my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
            Valid => 'invalid-temporarily',
        );

        # Make sure not to accidentially overwrite the password.
        delete $User{UserPw};

        my $Update = $UserObject->UserUpdate(
            %User,
            ValidID      => $ValidID,
            ChangeUserID => 1,
        );

        return if !$Update;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Login failed $FailedCount times. Set $User{UserLogin} to "
                . "'invalid-temporarily'.",
        );

        return;
    }

    # remember login attributes
    my $UserID = $UserObject->UserLookup(
        UserLogin => $User,
    );

    return $User if !$UserID;

    # on system maintenance just admin users
    # should be allowed to get into the system
    my $ActiveMaintenance = $Kernel::OM->Get('Kernel::System::SystemMaintenance')->SystemMaintenanceIsActive();

    # reset failed logins
    $UserObject->SetPreferences(
        Key    => 'UserLoginFailed',
        Value  => 0,
        UserID => $UserID,
    );

    # check if system maintenance is active
    if ($ActiveMaintenance) {

        # check if user is allow to login
        # get current user groups
        my %Groups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $UserID,
            Type   => 'move_into',
        );

        # reverse groups hash for easy look up
        %Groups = reverse %Groups;

        # check if the user is in the Admin group
        # if that is not the case return
        if ( !$Groups{admin} ) {

            $Self->{LastErrorMessage} =
                $ConfigObject->Get('SystemMaintenance::IsActiveDefaultLoginErrorMessage')
                || Translatable("It is currently not possible to login due to a scheduled system maintenance.");

            return;
        }
    }

    # last login preferences update
    $UserObject->SetPreferences(
        Key    => 'UserLastLogin',
        Value  => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
        UserID => $UserID,
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
