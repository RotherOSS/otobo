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

## nofilter(TidyAll::Plugin::OTOBO::Migrations::OTOBO10::TimeObject)

package Kernel::Modules::BasePassword;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
    'Kernel::System::CustomerUser',
    'Kernel::System::Group',
    'Kernel::System::Main',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
    'Kernel::System::Time',
);

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $TimeObject        = $Kernel::OM->Get('Kernel::System::Time');

    # cancel password action if an AgentInfo should be shown
    # to prevent enless redirect loop
    return if $Self->{Action} && $Self->{Action} eq 'AgentInfo';

    # return if password max time is not configured
    my $Config = $Self->_PreferencesGroupsGet();

    return if !$Config;
    return if !$Config->{Password};
    return if !$Config->{Password}->{PasswordMaxValidTimeInDays};

    # check auth module
    my $Module = $Self->_AuthModuleGet();

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;

    # redirect if password change time is in scope
    my $PasswordMaxValidTimeInDays = $Config->{Password}->{PasswordMaxValidTimeInDays} * 60 * 60 * 24;
    my $PasswordMaxValidTill       = $TimeObject->SystemTime() - $PasswordMaxValidTimeInDays;

    # skip public frontends
    my $FrontendType = $Self->_FrontendTypeGet();
    return if !$FrontendType;
    return if $FrontendType eq 'Public';

    # ignore pre application module if it is calling self
    return
        if $Self->{Action} =~ /^(CustomerPassword|AgentPassword|AdminPackage|AdminSystemConfiguration|CustomerAccept)/;

    # if last change time is over x days
    if ( !$Self->{UserLastPwChangeTime} || $Self->{UserLastPwChangeTime} < $PasswordMaxValidTill ) {

        # remember requested url
        $AuthSessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => $Self->{RequestedURL} // '',
        );

        return $Self->_RedirectPasswordDialog();
    }
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $MainObject        = $Kernel::OM->Get('Kernel::System::Main');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');

    # check config
    my $Config = $Self->_PreferencesGroupsGet();
    $Self->_FatalError( Message => 'No Config Params available' ) if !$Config;
    $Self->_FatalError( Message => 'No Config Params available' ) if !$Config->{Password};

    # check auth module
    my $Module = $Self->_AuthModuleGet();

    # return on no pw reset backends
    if ( $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i ) {
        return $Self->_Screen(
            Error => "No Password reset backend is used ($Module)! Can't set Password!"
        );
    }

    # change password
    if ( $Self->{Subaction} eq 'Change' ) {

        # load backend
        if ( !$MainObject->Require('Kernel::Output::HTML::Preferences::Password') ) {
            $Self->_FatalError();
        }

        # generate object
        my $Object = Kernel::Output::HTML::Preferences::Password->new(
            %{$Self},
            ConfigItem => $Config->{Password},
            UserID     => $Self->{UserID},
        );

        my $FrontendType = $Self->_FrontendTypeGet();

        # Agent
        my %UserData;
        if ( $FrontendType eq 'Agent' ) {
            %UserData = $Self->{UserObject}->GetUserData(
                UserID => $Self->{UserID},
            );
        }
        else {
            %UserData = $Self->{UserObject}->CustomerUserDataGet(
                User => $Self->{UserID},
            );
        }

        # run password change
        my $Success = $Object->Run(
            GetParam => {
                CurPw  => [ $ParamObject->GetParam( Param => 'CurPw' ) ],
                NewPw  => [ $ParamObject->GetParam( Param => 'NewPw' ) ],
                NewPw1 => [ $ParamObject->GetParam( Param => 'NewPw1' ) ],
            },
            UserData => \%UserData,
        );

        # show screen with error again
        if ( !$Success ) {
            my $Error = $Object->Error() || $Object->Message();
            return $Self->_Screen( Error => $Error );
        }

        # remove requested url
        $AuthSessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect to original requested url
        return $LayoutObject->Redirect( OP => "$Self->{UserRequestedURL}" );
    }

    # show change screen
    return $Self->_Screen();
}

sub _Screen {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    # show info
    my $Config = $Self->_PreferencesGroupsGet();
    my $Output = $Self->_Header();
    $Output .= $Self->_NavigationBar();

    # show policy
    my @Policy = qw(PasswordHistory PasswordMinSize PasswordMin2Lower2UpperCharacters PasswordMin2Characters PasswordNeedDigit PasswordMaxValidTimeInDays);
    POLICY:
    for my $Block (@Policy) {
        next POLICY if !$Config->{Password}->{$Block};
        $LayoutObject->Block(
            Name => $Block,
            Data => { %Param, %{ $Config->{Password} } },
        );
    }

    # show sysconfig settings link if admin
    my $HasAdminPermission = $GroupObject->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => 'admin',
        Type      => 'ro',
    );
    if ($HasAdminPermission) {
        $LayoutObject->Block(
            Name => 'AdminConfig',
            Data => { %Param, %{ $Config->{Password} } },
        );
    }

    $Output .= $Self->_OutputTemplate(
        %Param,
        %{ $Config->{Password} },
    );
    $Output .= $Self->_Footer();

    return $Output;
}

=head2 _AuthModuleGet()

Returns the Auth module for the correct interface.

    my $Module = $Self->_AuthModuleGet();

Returns:

    my $Module = '...';

=cut

sub _AuthModuleGet {
    my ( $Self, %Param ) = @_;

    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $UserObject         = $Kernel::OM->Get('Kernel::System::User');

    my $FrontendType = $Self->_FrontendTypeGet();

    my $Module;

    # Agent
    if ( $FrontendType eq 'Agent' ) {
        $Module = $ConfigObject->Get('AuthModule');
        return $Module if !$LayoutObject->{UserID};

        my %User = $UserObject->GetUserData(
            UserID => $LayoutObject->{UserID},
        );
        return $Module if !%User || !$User{UserAuthBackend};

        $Module = $ConfigObject->Get( 'AuthModule' . $User{UserAuthBackend} ) || $Module;
        return $Module;
    }

    # Customer user
    $Module = $ConfigObject->Get('Customer::AuthModule');
    return $Module if !$LayoutObject->{UserID};

    my %User = $CustomerUserObject->CustomerUserDataGet(
        User => $LayoutObject->{UserID},
    );
    return $Module if !%User || !$User{UserAuthBackend};

    $Module = $ConfigObject->Get( 'Customer::AuthModule' . $User{UserAuthBackend} ) || $Module;
    return $Module;
}

=head2 _RedirectPasswordDialog()

Redirects to the password dialog for the correct interface.

    my $Redirect = $Self->_RedirectPasswordDialog();

Returns:

    my $Redirect = '...';

=cut

sub _RedirectPasswordDialog {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FrontendType = $Self->_FrontendTypeGet();

    return $LayoutObject->Redirect( OP => 'Action=AgentPassword' ) if $FrontendType eq 'Agent';
    return $LayoutObject->Redirect( OP => 'Action=CustomerPassword' );
}

=head2 _PreferencesGroupsGet()

Returns the preferences for the correct interface.

    my $Config = $Self->_PreferencesGroupsGet();

Returns:

    my $Config = {};

=cut

sub _PreferencesGroupsGet {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $FrontendType = $Self->_FrontendTypeGet();

    return $ConfigObject->Get('PreferencesGroups') if $FrontendType eq 'Agent';
    return $ConfigObject->Get('CustomerPreferencesGroups');
}

=head2 _FatalError()

Returns a fatal error for the correct interface.

    my $FatalError = $Self->_FatalError(%Param);

Returns:

    my $FatalError = '...';

=cut

sub _FatalError {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FrontendType = $Self->_FrontendTypeGet();

    return $LayoutObject->FatalError(%Param) if $FrontendType eq 'Agent';
    return $LayoutObject->CustomerFatalError(%Param);
}

=head2 _Header()

Returns the header for the correct interface.

    my $Output = $Self->_Header();

Returns:

    my $Output = '...';

=cut

sub _Header {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FrontendType = $Self->_FrontendTypeGet();

    return $LayoutObject->Header() if $FrontendType eq 'Agent';
    return $LayoutObject->CustomerHeader();
}

=head2 _NavigationBar()

Returns the navigation bar for the correct interface.

    my $Output = $Self->_NavigationBar();

Returns:

    my $Output = '...';

=cut

sub _NavigationBar {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FrontendType = $Self->_FrontendTypeGet();

    return $LayoutObject->NavigationBar() if $FrontendType eq 'Agent';
    return $LayoutObject->CustomerNavigationBar();
}

=head2 _OutputTemplate()

Description.

    my $Output = $Self->_OutputTemplate(%Param);

Returns:

    my $Output = '...';

=cut

sub _OutputTemplate {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FrontendType = $Self->_FrontendTypeGet();

    my $TemplateFile = 'CustomerPassword';
    if ( $FrontendType eq 'Agent' ) {
        $TemplateFile = 'AgentPassword';
    }

    return $LayoutObject->Output(
        Data         => \%Param,
        TemplateFile => $TemplateFile,
    );
}

=head2 _Footer()

Returns the footer for the correct interface.

    my $Output = $Self->_Footer();

Returns:

    my $Output = '...';

=cut

sub _Footer {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FrontendType = $Self->_FrontendTypeGet();

    return $LayoutObject->Footer() if $FrontendType eq 'Agent';
    return $LayoutObject->CustomerFooter();
}

=head2 _FrontendTypeGet()

This function returns the type of the action.

    my $FrontendType = $Self->_FrontendTypeGet();

Returns:

    my $FrontendType = 'Agent';
    my $FrontendType = 'Customer';
    my $FrontendType = 'Public';

=cut

sub _FrontendTypeGet {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $FrontendModules         = $ConfigObject->Get('Frontend::Module')         || {};
    my $CustomerFrontendModules = $ConfigObject->Get('CustomerFrontend::Module') || {};
    my $PublicFrontendModules   = $ConfigObject->Get('PublicFrontend::Module')   || {};

    return 'Agent'    if $FrontendModules->{ $Self->{Action} };
    return 'Customer' if $CustomerFrontendModules->{ $Self->{Action} };
    return 'Public'   if $PublicFrontendModules->{ $Self->{Action} };
    return;
}

1;
