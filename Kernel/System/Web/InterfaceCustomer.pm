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

package Kernel::System::Web::InterfaceCustomer;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use Time::HiRes qw();

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);
use Kernel::Language qw(Translatable);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
    'Kernel::System::Cache',
    'Kernel::System::CustomerAuth',
    'Kernel::System::CustomerGroup',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::Email',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Scheduler',
    'Kernel::System::DateTime',
    'Kernel::System::Web::Request',
    'Kernel::System::Web::Response',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Web::InterfaceCustomer - the customer web interface

=head1 SYNOPSIS

    use Kernel::System::Web::InterfaceCustomer;

    # a Plack request handler
    my $App = sub {
        my $Env = shift;

        my $Interface = Kernel::System::Web::InterfaceCustomer->new(
            # Debug => 1
            PSGIEnv    => $Env,
        );

        # generate content (actually headers are generated as a side effect)
        my $Content = $Interface->Content();

        # assuming all went well and HTML was generated
        return [
            '200',
            [ 'Content-Type' => 'text/html' ],
            $Content
        ];
    };

=head1 DESCRIPTION

This module generates the HTTP response for F<customer.pl>.
This class is meant to be used within a Plack request handler.
See F<bin/psgi-bin/otobo.psgi> for the real live usage.

=head1 PUBLIC INTERFACE

=head2 new()

create the web interface object for F<customer.pl>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # start with an empty hash for the new object
    my $Self = bless {}, $Type;

    # set debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # performance log based on high resolution timestamps
    $Self->{PerformanceLogStart} = Time::HiRes::time();

    # register object params
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => $Kernel::OM->Get('Kernel::Config')->Get('CGILogPrefix') || 'Customer',
        },
        'Kernel::System::Web::Request' => {
            PSGIEnv => $Param{PSGIEnv} || 0,
        },
    );

    # debug info
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Global handle started...',
        );
    }

    return $Self;
}

=head2 Content()

execute the object.
Set headers in Kernels::System::Web::Request singleton as side effect.

    my $Content = $Interface->Content();

=cut

sub Content {    ## no critic qw(Subroutines::RequireFinalReturn)
    my $Self = shift;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Check if https forcing is active, and redirect if needed.
    if ( $ConfigObject->Get('HTTPSForceRedirect') ) {

        # Allow HTTPS to be 'on' in a case insensitive way.
        # In OTOBO 10.0.1 it had to be lowercase 'on'.
        my $HTTPS = $ParamObject->HTTPS('HTTPS') // '';
        if ( lc $HTTPS ne 'on' ) {
            my $Host         = $ParamObject->HTTP('HOST') || $ConfigObject->Get('FQDN');
            my $RequestURI   = $ParamObject->RequestURI();
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            $LayoutObject->Redirect( ExtURL => "https://$Host$RequestURI" );    # throw a Kernel::System::Web::Exception exception
        }
    }

    # get common framework params
    my %Param;
    $Param{SessionName} = $ConfigObject->Get('CustomerPanelSessionName')         || 'CSID';
    $Param{SessionID}   = $ParamObject->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
    my $QueryString = $ParamObject->QueryString() || '';
    $QueryString =~ s/(\?|&|;|)$Param{SessionName}(=&|=;|=.+?&|=.+?$)/;/g;

    # define framework params
    {
        my %FrameworkParams = (
            Lang         => '',
            Action       => '',
            Subaction    => '',
            RequestedURL => $QueryString,
        );
        for my $Key ( sort keys %FrameworkParams ) {
            $Param{$Key} = $ParamObject->GetParam( Param => $Key ) || $FrameworkParams{$Key};
        }
    }

    # validate language
    if ( $Param{Lang} && $Param{Lang} !~ m{\A[a-z]{2}(?:_[A-Z]{2})?\z}xms ) {
        delete $Param{Lang};
    }

    # Check if the browser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    if ( $ConfigObject->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $ParamObject->GetCookie( Key => $Param{SessionName} );
        if ( $Param{SessionIDCookie} ) {
            $Param{SessionID} = $Param{SessionIDCookie};
        }
    }

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            Lang => $Param{Lang},
        },
        'Kernel::Language' => {
            UserLanguage => $Param{Lang}
        },
    );

    # Restrict Cookie to HTTPS if it is used.
    my $CookieSecureAttribute = $ConfigObject->Get('HttpType') eq 'https' ? 1 : undef;

    my $DBCanConnect = $Kernel::OM->Get('Kernel::System::DB')->Connect();

    if ( !$DBCanConnect || $ParamObject->Error() ) {
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        if ( !$DBCanConnect ) {
            $LayoutObject->CustomerFatalError(
                Comment => Translatable('Please contact the administrator.'),
            );    # throws a Kernel::System::Web::Exception
        }
        if ( $ParamObject->Error() ) {
            $LayoutObject->CustomerFatalError(
                Message => $ParamObject->Error(),
                Comment => Translatable('Please contact the administrator.'),
            );    # throws a Kernel::System::Web::Exception
        }
    }

    # get common application and add-on application params
    my %CommonObjectParam = %{ $ConfigObject->Get('CustomerFrontend::CommonParam') };
    for my $Key ( sort keys %CommonObjectParam ) {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non-word chars)
    $Param{Action} =~ s/\W//g;

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # check request type
    if ( $Param{Action} eq 'PreLogin' ) {
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        $Param{RequestedURL} ||= 'Action=CustomerDashboard';

        # login screen
        return $LayoutObject->CustomerLogin(
            Title => 'Login',
            Mode  => 'PreLogin',
            %Param,
        );
    }
    elsif ( $Param{Action} eq 'Login' ) {

        # get params
        my $PostUser = $ParamObject->GetParam( Param => 'User' ) || '';

        my $PreventBruteForceConfig = $ConfigObject->Get('SimpleBruteForceProtection::GeneralSettings');

        # if simplebruteforceconfig is valid
        if ( $PreventBruteForceConfig && $PostUser ) {

            # check if the login is banned
            my $CacheObject   = $Kernel::OM->Get('Kernel::System::Cache');
            my $CheckHashUser = $CacheObject->Get(
                Type => 'BannedLoginsCustomer',
                Key  => $PostUser,
            );

            # check if Cache CheckHashUser exists
            if ($CheckHashUser) {
                my %BanStatus = $Self->_CheckAndRemoveFromBannedList(
                    PostUser                => $PostUser,
                    PreventBruteForceConfig => $PreventBruteForceConfig,
                );

                if ( $BanStatus{Banned} ) {

                    # output error message
                    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

                    return $LayoutObject->CustomerLogin(
                        %Param,
                        Title   => 'Login',
                        Message => $LayoutObject->{LanguageObject}->Translate(
                            'Too many failed login attempts, please retry in %s s.',
                            $BanStatus{ResidualTime}
                        ),
                        LoginFailed => 1,
                        MessageType => 'Error',
                        User        => $PostUser,
                    );
                }
            }
        }

        my $PostPw = $ParamObject->GetParam(
            Param => 'Password',
            Raw   => 1
        ) || '';
        my $PostTwoFactorToken = $ParamObject->GetParam(
            Param => 'TwoFactorToken',
            Raw   => 1
        ) || '';

        # create AuthObject
        my $AuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');

        # check submitted data
        my $User = $AuthObject->Auth(
            User           => $PostUser,
            Pw             => $PostPw,
            TwoFactorToken => $PostTwoFactorToken,
        );

        # additional tasks / info
        my $PostAuth = $AuthObject->PostAuth();

        if ($PostAuth) {
            $Param{RequestedURL} = $PostAuth->{RequestedURL} // $Param{RequestedURL};
        }

        # login is invalid
        if ( !$User ) {

            my $Expires = '+' . $ConfigObject->Get('SessionMaxTime') . 's';
            if ( !$ConfigObject->Get('SessionUseCookieAfterBrowserClose') ) {
                $Expires = '';
            }

            # tentatively set an useless cookie, for checking cookie support
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
            $LayoutObject->SetCookie(
                Key      => 'OTOBOBrowserHasCookie',
                Value    => 1,
                Expires  => $Expires,
                Path     => $ConfigObject->Get('ScriptAlias'),
                Secure   => $CookieSecureAttribute,
                HTTPOnly => 1,
            );

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );

                # throw a Kernel::System::Web::Exception that redirects
                $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL') . "?Reason=LoginFailed&RequestedURL=$Param{RequestedURL}",
                );
            }

            if ( $PreventBruteForceConfig && $PostUser ) {

                # prevent brute force
                my $Banned = $Self->_StoreFailedLogins(
                    PostUser                => $PostUser,
                    PreventBruteForceConfig => $PreventBruteForceConfig,
                );

                if ($Banned) {
                    return $LayoutObject->CustomerLogin(
                        %Param,
                        Title   => 'Login',
                        Message => $LayoutObject->{LanguageObject}->Translate(
                            'Too many failed login attempts, please retry in %s s.',
                            $PreventBruteForceConfig->{BanDuration}
                        ),
                        LoginFailed => 1,
                        MessageType => 'Error',
                        User        => $PostUser,
                    );
                }
            }

            # show normal login
            return $LayoutObject->CustomerLogin(
                Title   => 'Login',
                Message => $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
                    Type => 'Info',
                    What => 'Message',
                    )
                    || $AuthObject->GetLastErrorMessage()
                    || Translatable('Login failed! Your user name or password was entered incorrectly.'),
                LoginFailed => 1,
                User        => $PostUser,
                %Param,
            );
        }

        # login is successful
        my %UserData = $UserObject->CustomerUserDataGet(
            User  => $User,
            Valid => 1,
        );

        # check if the browser supports cookies
        if ( $ParamObject->GetCookie( Key => 'OTOBOBrowserHasCookie' ) ) {
            $Kernel::OM->ObjectParamAdd(
                'Kernel::Output::HTML::Layout' => {
                    BrowserHasCookie => 1,
                },
            );
        }

        # check needed data
        if ( !$UserData{UserID} || !$UserData{UserLogin} ) {

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {

                # throw a Kernel::System::Web::Exception that redirects
                $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL') . '?Reason=SystemError',
                );
            }

            # show need user data error message
            return $LayoutObject->CustomerLogin(
                Title   => 'Error',
                Message =>
                    Translatable(
                        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.'
                    ),
                %Param,
            );
        }

        # create datetime object
        my $SessionDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

        # Remove certain user attributes that are not needed to be stored in the session.
        #   - SMIME Certificate could be in binary format, if session backend in DB (default)
        #   it wont be possible to be saved in certain databases (see bug#14405).
        my %UserSessionData = %UserData;
        delete $UserSessionData{UserSMIMECertificate};

        # create new session id
        my $NewSessionID = $SessionObject->CreateSessionID(
            %UserSessionData,
            UserLastRequest => $SessionDTObject->ToEpoch(),
            UserType        => 'Customer',
            SessionSource   => 'CustomerInterface',
        );

        # show error message if no session id has been created
        if ( !$NewSessionID ) {

            # get error message
            my $Error = $SessionObject->SessionIDErrorMessage() || '';

            # output error message
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            return $LayoutObject->CustomerLogin(
                Title   => 'Login',
                Message => $Error,
                %Param,
            );
        }

        # execution in 20 seconds
        my $ExecutionTimeObj = $SessionDTObject->Clone();
        $ExecutionTimeObj->Add( Seconds => 20 );
        my $ExecutionTime = $ExecutionTimeObj->ToString();

        # add a asynchronous executor scheduler task to count the concurrent user
        $Kernel::OM->Get('Kernel::System::Scheduler')->TaskAdd(
            ExecutionTime            => $ExecutionTime,
            Type                     => 'AsynchronousExecutor',
            Name                     => 'PluginAsynchronous::ConcurrentUser',
            MaximumParallelInstances => 1,
            Data                     => {
                Object   => 'Kernel::System::SupportDataCollector::PluginAsynchronous::OTOBO::ConcurrentUsers',
                Function => 'RunAsynchronous',
            },
        );

        my $UserTimeZone = $Self->_UserTimeZoneGet(%UserData);

        $SessionObject->UpdateSessionID(
            SessionID => $NewSessionID,
            Key       => 'UserTimeZone',
            Value     => $UserTimeZone,
        );

        # check if the time zone offset reported by the user's browser differs from that
        # of the OTOBO user's time zone offset
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                TimeZone => $UserTimeZone,
            },
        );
        my $OTOBOUserTimeZoneOffset = $DateTimeObject->Format( Format => '%{offset}' ) / 60;
        my $BrowserTimeZoneOffset   = ( $ParamObject->GetParam( Param => 'TimeZoneOffset' ) || 0 ) * -1;

        # TimeZoneOffsetDifference contains the difference of the time zone offset between
        # the user's OTOBO time zone setting and the one reported by the user's browser.
        # If there is a difference it can be evaluated later to e. g. show a message
        # for the user to check his OTOBO time zone setting.
        my $UserTimeZoneOffsetDifference = abs( $OTOBOUserTimeZoneOffset - $BrowserTimeZoneOffset );
        $SessionObject->UpdateSessionID(
            SessionID => $NewSessionID,
            Key       => 'UserTimeZoneOffsetDifference',
            Value     => $UserTimeZoneOffsetDifference,
        );

        # create a new LayoutObject with SessionIDCookie
        my $Expires = '+' . $ConfigObject->Get('SessionMaxTime') . 's';
        if ( !$ConfigObject->Get('SessionUseCookieAfterBrowserClose') ) {
            $Expires = '';
        }

        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                SetCookies => {
                    SessionIDCookie => $ParamObject->SetCookie(
                        Key      => $Param{SessionName},
                        Value    => $NewSessionID,
                        Expires  => $Expires,
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => $CookieSecureAttribute,
                        HTTPOnly => 1,
                    ),

                    # delete the OTOBOBrowserHasCookie cookie
                    OTOBOBrowserHasCookie => $ParamObject->SetCookie(
                        Key      => 'OTOBOBrowserHasCookie',
                        Value    => '',
                        Expires  => '-1y',
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => $CookieSecureAttribute,
                        HTTPOnly => 1,
                    ),
                },
                SessionID   => $NewSessionID,
                SessionName => $Param{SessionName},
            },
        );

        # redirect with new session id and old params
        # prepare old redirect URL -- do not redirect to Login or Logout (loop)!
        if ( $Param{RequestedURL} =~ /Action=(Logout|Login|LostPassword|PreLogin)/ ) {
            $Param{RequestedURL} = '';
        }

        # redirect with new session id
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        $LayoutObject->Redirect(
            OP    => $Param{RequestedURL},
            Login => 1,
        );    # throws a Kernel::System::Web::Exception
    }

    # logout
    elsif ( $Param{Action} eq 'Logout' ) {

        # check session id
        if ( !$SessionObject->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # new layout object
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );

                $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                        . "?Reason=InvalidSessionID;RequestedURL=$Param{RequestedURL}",
                );    # throws a Kernel::System::Web::Exception
            }

            # show login screen
            return $LayoutObject->CustomerLogin(
                Title   => 'Logout',
                Message => Translatable('Session invalid. Please log in again.'),
                %Param,
            );
        }

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        $UserData{UserTimeZone} = $Self->_UserTimeZoneGet(%UserData);

        # create a new LayoutObject with '%Param' and '%UserData'
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                SetCookies => {

                    # delete the OTOBO session cookie
                    SessionIDCookie => $ParamObject->SetCookie(
                        Key      => $Param{SessionName},
                        Value    => '',
                        Expires  => '-1y',
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => $CookieSecureAttribute,
                        HTTPOnly => 1,
                    ),
                },
                %Param,
                %UserData,
            },
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # remove session id
        if ( !$SessionObject->RemoveSessionID( SessionID => $Param{SessionID} ) ) {
            $LayoutObject->CustomerFatalError(
                Comment => Translatable('Please contact the administrator.')
            );    # throws a Kernel::System::Web::Exception
        }

        # redirect to alternate login
        if ( $ConfigObject->Get('CustomerPanelLogoutURL') ) {
            $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('CustomerPanelLogoutURL'),
            );    # throws a Kernel::System::Web::Exception
        }

        # try auth module specific logout
        my $LogoutInfo = $Kernel::OM->Get('Kernel::System::CustomerAuth')->Logout();
        if ( $LogoutInfo && $LogoutInfo->{LogoutURL} ) {
            $LayoutObject->Redirect(
                ExtURL => $LogoutInfo->{LogoutURL},
            );    # throws a Kernel::System::Web::Exception
        }

        # show logout screen
        return $LayoutObject->CustomerLogin(
            Title       => 'Logout',
            Message     => $LayoutObject->{LanguageObject}->Translate('Logout successful.'),
            MessageType => 'Success',
            %Param,
        );
    }

    # lost password
    elsif ( $Param{Action} eq 'CustomerLostPassword' ) {

        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # check feature
        if ( !$ConfigObject->Get('CustomerPanelLostPassword') ) {

            # show normal login
            return $LayoutObject->CustomerLogin(
                Title   => 'Login',
                Message => Translatable('Feature not active!'),
            );
        }

        # get params
        my $User  = $ParamObject->GetParam( Param => 'User' )  || '';
        my $Token = $ParamObject->GetParam( Param => 'Token' ) || '';

        # get user login by token
        if ( !$User && $Token ) {

            # Prevent extracting password reset token character-by-character via wildcard injection
            # The wild card characters "%" and "_" could be used to match arbitrary character.
            if ( $Token !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

                # Security: pretend that password reset instructions were actually sent to
                #   make sure that users cannot find out valid usernames by
                #   just trying and checking the result message.
                return $LayoutObject->Login(
                    Title       => 'Login',
                    Message     => Translatable('Sent password reset instructions. Please check your email.'),
                    MessageType => 'Success',
                    %Param,
                );
            }

            my %UserList = $UserObject->SearchPreferences(
                Key   => 'UserToken',
                Value => $Token,
            );
            USER_ID:
            for my $UserID ( sort keys %UserList ) {
                my %UserData = $UserObject->CustomerUserDataGet(
                    User  => $UserID,
                    Valid => 1,
                );
                if (%UserData) {
                    $User = $UserData{UserLogin};

                    last USER_ID;
                }
            }
        }

        # get user data
        my %UserData = $UserObject->CustomerUserDataGet(
            User => $User,
        );

        # verify customer user is valid when requesting password reset
        my @ValidIDs    = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
        my $UserIsValid = grep { $UserData{ValidID} && $UserData{ValidID} == $_ } @ValidIDs;
        if ( !$UserData{UserID} || !$UserIsValid ) {

            # Security: pretend that password reset instructions were actually sent to
            #   make sure that users cannot find out valid usernames by
            #   just trying and checking the result message.
            return $LayoutObject->CustomerLogin(
                Title       => 'Login',
                Message     => Translatable('Sent password reset instructions. Please check your email.'),
                MessageType => 'Success',
            );
        }

        # create email object
        my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

        # send password reset token
        if ( !$Token ) {

            # generate token
            $UserData{Token} = $UserObject->TokenGenerate(
                UserID => $UserData{UserID},
            );

            # send token notify email with link
            my $Body = $ConfigObject->Get('CustomerPanelBodyLostPasswordToken')
                || 'ERROR: CustomerPanelBodyLostPasswordToken is missing!';
            my $Subject = $ConfigObject->Get('CustomerPanelSubjectLostPasswordToken')
                || 'ERROR: CustomerPanelSubjectLostPasswordToken is missing!';
            for ( sort keys %UserData ) {
                $Body =~ s/<OTOBO_$_>/$UserData{$_}/gi;
            }
            my $Sent = $EmailObject->Send(
                To       => $UserData{UserEmail},
                Subject  => $Subject,
                Charset  => $LayoutObject->{UserCharset},
                MimeType => 'text/plain',
                Body     => $Body
            );
            if ( !$Sent->{Success} ) {
                $LayoutObject->FatalError(
                    Comment => Translatable('Please contact the administrator.'),
                );    # throws a Kernel::System::Web::Exception
            }

            return $LayoutObject->CustomerLogin(
                Title       => 'Login',
                Message     => Translatable('Sent password reset instructions. Please check your email.'),
                MessageType => 'Success',
                %Param,
            );
        }

        # reset password
        # check if token is valid
        my $TokenValid = $UserObject->TokenCheck(
            Token  => $Token,
            UserID => $UserData{UserID},
        );

        if ( !$TokenValid ) {
            return $LayoutObject->CustomerLogin(
                Title   => 'Login',
                Message => Translatable('Invalid Token!'),
                %Param,
            );
        }

        # get new password
        $UserData{NewPW} = $UserObject->GenerateRandomPassword();

        # update new password
        my $Success = $UserObject->SetPassword(
            UserLogin => $User,
            PW        => $UserData{NewPW}
        );

        if ( !$Success ) {
            return $LayoutObject->CustomerLogin(
                Title   => 'Login',
                Message => Translatable('Reset password unsuccessful. Please contact the administrator.'),
                User    => $User,
            );
        }

        # send notify email
        my $Body = $ConfigObject->Get('CustomerPanelBodyLostPassword')
            || 'New Password is: <OTOBO_NEWPW>';
        my $Subject = $ConfigObject->Get('CustomerPanelSubjectLostPassword')
            || 'New Password!';
        for ( sort keys %UserData ) {
            $Body =~ s/<OTOBO_$_>/$UserData{$_}/gi;
        }
        my $Sent = $EmailObject->Send(
            To       => $UserData{UserEmail},
            Subject  => $Subject,
            Charset  => $LayoutObject->{UserCharset},
            MimeType => 'text/plain',
            Body     => $Body
        );

        if ( !$Sent->{Success} ) {
            $LayoutObject->CustomerFatalError(
                Comment => Translatable('Please contact the administrator.'),
            );    # throws a Kernel::System::Web::Exception
        }
        my $Message = $LayoutObject->{LanguageObject}->Translate(
            'Sent new password to %s. Please check your email.',
            $UserData{UserEmail},
        );

        return $LayoutObject->CustomerLogin(
            Title       => 'Login',
            Message     => $Message,
            User        => $User,
            MessageType => 'Success',
        );
    }

    # create new customer account
    elsif ( $Param{Action} eq 'CustomerCreateAccount' ) {

        # new layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # check feature
        if ( !$ConfigObject->Get('CustomerPanelCreateAccount') ) {

            # show normal login
            return $LayoutObject->CustomerLogin(
                Title   => 'Login',
                Message => Translatable('Feature not active!'),
            );
        }

        # get params
        my %GetParams;
        for my $Entry ( @{ $ConfigObject->Get('CustomerUser')->{Map} } ) {
            $GetParams{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[1] )
                || '';
        }
        $GetParams{ValidID} = 1;

        # check needed params
        if ( !$GetParams{UserCustomerID} ) {
            $GetParams{UserCustomerID} = $GetParams{UserEmail};
        }
        if ( !$GetParams{UserLogin} ) {
            $GetParams{UserLogin} = $GetParams{UserEmail};
        }

        # get new password
        $GetParams{UserPassword} = $UserObject->GenerateRandomPassword();

        # get user data
        my %UserData = $UserObject->CustomerUserDataGet( User => $GetParams{UserLogin} );
        if ( $UserData{UserID} || !$GetParams{UserLogin} ) {

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'SignupError',
                Value => 1,
            );

            return $LayoutObject->CustomerLogin(
                Title         => 'Login',
                Message       => Translatable('This e-mail address already exists. Please log in or reset your password.'),
                UserTitle     => $GetParams{UserTitle},
                UserFirstname => $GetParams{UserFirstname},
                UserLastname  => $GetParams{UserLastname},
                UserEmail     => $GetParams{UserEmail},
            );
        }

        # check for mail address restrictions
        my @Whitelist = @{
            $ConfigObject->Get('CustomerPanelCreateAccount::MailRestrictions::Whitelist') // []
        };
        my @Blacklist = @{
            $ConfigObject->Get('CustomerPanelCreateAccount::MailRestrictions::Blacklist') // []
        };

        my $WhitelistMatched;
        for my $WhitelistEntry (@Whitelist) {
            my $Regex = eval {qr/$WhitelistEntry/i};
            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        $LayoutObject->{LanguageObject}->Translate(
                            'The customer panel mail address whitelist contains the invalid regular expression $WhitelistEntry, please check and correct it.'
                        ),
                );
            }
            elsif ( $GetParams{UserEmail} =~ $Regex ) {
                $WhitelistMatched++;
            }
        }
        my $BlacklistMatched;
        for my $BlacklistEntry (@Blacklist) {
            my $Regex = eval {qr/$BlacklistEntry/i};
            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        $LayoutObject->{LanguageObject}->Translate(
                            'The customer panel mail address blacklist contains the invalid regular expression $BlacklistEntry, please check and correct it.'
                        ),
                );
            }
            elsif ( $GetParams{UserEmail} =~ $Regex ) {
                $BlacklistMatched++;
            }
        }

        if ( ( @Whitelist && !$WhitelistMatched ) || ( @Blacklist && $BlacklistMatched ) ) {

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'SignupError',
                Value => 1,
            );

            return $LayoutObject->CustomerLogin(
                Title         => 'Login',
                Message       => Translatable('This email address is not allowed to register. Please contact support staff.'),
                UserTitle     => $GetParams{UserTitle},
                UserFirstname => $GetParams{UserFirstname},
                UserLastname  => $GetParams{UserLastname},
                UserEmail     => $GetParams{UserEmail},
            );
        }

        # create account
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $Now = $DateTimeObject->ToString();

        my $Add = $UserObject->CustomerUserAdd(
            %GetParams,
            Comment => $LayoutObject->{LanguageObject}->Translate( 'Added via Customer Panel (%s)', $Now ),
            ValidID => 1,
            UserID  => $ConfigObject->Get('CustomerPanelUserID'),
        );
        if ( !$Add ) {

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'SignupError',
                Value => 1,
            );

            return $LayoutObject->CustomerLogin(
                Title         => 'Login',
                Message       => Translatable('Customer user can\'t be added!'),
                UserTitle     => $GetParams{UserTitle},
                UserFirstname => $GetParams{UserFirstname},
                UserLastname  => $GetParams{UserLastname},
                UserEmail     => $GetParams{UserEmail},
            );
        }

        # send notify email
        my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');
        my $Body        = $ConfigObject->Get('CustomerPanelBodyNewAccount')
            || 'No Config Option found!';
        my $Subject = $ConfigObject->Get('CustomerPanelSubjectNewAccount')
            || 'New OTOBO Account!';
        for ( sort keys %GetParams ) {
            $Body =~ s/<OTOBO_$_>/$GetParams{$_}/gi;
        }

        # send account info
        my $Sent = $EmailObject->Send(
            To       => $GetParams{UserEmail},
            Subject  => $Subject,
            Charset  => $LayoutObject->{UserCharset},
            MimeType => 'text/plain',
            Body     => $Body
        );
        if ( !$Sent->{Success} ) {
            return join '',
                $LayoutObject->CustomerHeader(
                    Area  => 'Core',
                    Title => 'Error'
                ),
                $LayoutObject->CustomerWarning(
                    Comment => Translatable('Can\'t send account info!')
                ),
                $LayoutObject->CustomerFooter();
        }

        # show sent account info
        if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {

            # redirect to alternate login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );

            $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                    . "?RequestedURL=$Param{RequestedURL};User=$GetParams{UserLogin};"
                    . "Email=$GetParams{UserEmail};Reason=NewAccountCreated",
            );    # throws a Kernel::System::Web::Exception
        }

        my $AccountCreatedMessage = $LayoutObject->{LanguageObject}->Translate(
            'New account created. Sent login information to %s. Please check your email.',
            $GetParams{UserEmail},
        );

        # login screen
        return $LayoutObject->CustomerLogin(
            Title       => 'Login',
            Message     => $AccountCreatedMessage,
            User        => $GetParams{UserLogin},
            MessageType => 'Success',
        );
    }

    # show login site
    elsif ( !$Param{SessionID} ) {

        # create AuthObject
        my $AuthObject   = $Kernel::OM->Get('Kernel::System::CustomerAuth');
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

            # automatic login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );

            my $PreAuth = $AuthObject->PreAuth(
                RequestedURL => $Param{RequestedURL},
            );

            if ( $PreAuth && $PreAuth->{RedirectURL} ) {

                if ( $ConfigObject->Get('SessionUseCookie') ) {

                    # always set a cookie, so that
                    # we know already if the browser supports cookies.
                    # ( the session cookie isn't available at that time ).

                    my $Expires = '+' . $ConfigObject->Get('SessionMaxTime') . 's';
                    if ( !$ConfigObject->Get('SessionUseCookieAfterBrowserClose') ) {
                        $Expires = '';
                    }

                    # set a cookie tentatively for checking cookie support
                    $LayoutObject->SetCookie(
                        Key      => 'OTOBOBrowserHasCookie',
                        Value    => 1,
                        Expires  => $Expires,
                        Path     => $ConfigObject->Get('ScriptAlias'),
                        Secure   => $CookieSecureAttribute,
                        HttpOnly => 1,
                    );
                }

                $LayoutObject->Redirect(
                    ExtURL => $PreAuth->{RedirectURL},
                );    # throws a Kernel::System::Web::Exception
            }

            $LayoutObject->Redirect(
                OP => "Action=PreLogin&RequestedURL=$Param{RequestedURL}",
            );        # throws a Kernel::System::Web::Exception
        }
        elsif ( $ConfigObject->Get('CustomerPanelLoginURL') ) {

            # redirect to alternate login
            $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );

            $LayoutObject->Redirect(
                ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                    . "?RequestedURL=$Param{RequestedURL}",
            );        # throws a Kernel::System::Web::Exception
        }

        # login screen
        return $LayoutObject->CustomerLogin(
            Title => 'Login',
            %Param,
        );
    }

    # run modules if a version value exists
    elsif ( $Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {

        # check session id
        if ( !$SessionObject->CheckSessionID( SessionID => $Param{SessionID} ) ) {

            # create new LayoutObject with new '%Param'
            $Kernel::OM->ObjectParamAdd(
                'Kernel::Output::HTML::Layout' => {
                    SetCookies => {

                        # delete the OTOBO session cookie
                        SessionIDCookie => $ParamObject->SetCookie(
                            Key      => $Param{SessionName},
                            Value    => '',
                            Expires  => '-1y',
                            Path     => $ConfigObject->Get('ScriptAlias'),
                            Secure   => $CookieSecureAttribute,
                            HTTPOnly => 1,
                        ),
                    },
                    %Param,
                },
            );

            # if the wrong scheme is used, delete also the "other" cookie - issue #251
            my ($RequestScheme) = split '/', $ParamObject->ServerProtocol, 2;
            if ( $RequestScheme ne $ConfigObject->Get('HttpType') ) {
                $Kernel::OM->ObjectParamAdd(
                    'Kernel::Output::HTML::Layout' => {
                        SetCookies => {

                            # delete the OTOBO session cookie
                            SessionIDCookiehttp => $ParamObject->SetCookie(
                                Key      => $Param{SessionName},
                                Value    => '',
                                Expires  => '-1y',
                                Path     => $ConfigObject->Get('ScriptAlias'),
                                Secure   => '',
                                HTTPOnly => 1,
                            ),

                            # delete the OTOBO session cookie
                            SessionIDCookiehttps => $ParamObject->SetCookie(
                                Key      => $Param{SessionName},
                                Value    => '',
                                Expires  => '-1y',
                                Path     => $ConfigObject->Get('ScriptAlias'),
                                Secure   => 1,
                                HTTPOnly => 1,
                            ),
                        },
                        %Param,
                    },
                );
            }

            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # create AuthObject
            my $AuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');
            if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {

                # automatic re-login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );

                my $PreAuth = $AuthObject->PreAuth(
                    RequestedURL => $Param{RequestedURL},
                );

                if ( $PreAuth && $PreAuth->{RedirectURL} ) {
                    $LayoutObject->Redirect(
                        ExtURL => $PreAuth->{RedirectURL},
                    );    # throws a Kernel::System::Web::Exception
                }

                $LayoutObject->Redirect(
                    OP => "?Action=PreLogin&RequestedURL=$Param{RequestedURL}",
                );        # throws a Kernel::System::Web::Exception
            }
            elsif ( $ConfigObject->Get('CustomerPanelLoginURL') ) {

                # redirect to alternate login
                $Param{RequestedURL} = $LayoutObject->LinkEncode( $Param{RequestedURL} );

                $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL')
                        . "?Reason=InvalidSessionID&RequestedURL=$Param{RequestedURL}",
                );        # throws a Kernel::System::Web::Exception
            }

            # show login
            return $LayoutObject->CustomerLogin(
                Title   => 'Login',
                Message =>
                    $LayoutObject->{LanguageObject}->Translate( $SessionObject->SessionIDErrorMessage() ),
                %Param,
            );
        }

        # get session data
        my %UserData = $SessionObject->GetSessionIDData(
            SessionID => $Param{SessionID},
        );

        $UserData{UserTimeZone} = $Self->_UserTimeZoneGet(%UserData);

        # check needed data
        if ( !$UserData{UserID} || !$UserData{UserLogin} || $UserData{UserType} ne 'Customer' ) {

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            # redirect to alternate login
            if ( $ConfigObject->Get('CustomerPanelLoginURL') ) {
                $LayoutObject->Redirect(
                    ExtURL => $ConfigObject->Get('CustomerPanelLoginURL') . '?Reason=SystemError',
                );    # throws a Kernel::System::Web::Exception
            }

            # show login screen
            return $LayoutObject->CustomerLogin(
                Title   => 'Error',
                Message => Translatable('Error: invalid session.'),
                %Param,
            );
        }

        # check module registry
        my $ModuleReg = $ConfigObject->Get('CustomerFrontend::Module')->{ $Param{Action} };
        if ( !$ModuleReg ) {

            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
            );

            $LayoutObject->CustomerFatalError(
                Comment => Translatable('Please contact the administrator.'),
            );    # throws a Kernel::System::Web::Exception
        }

        # module permission check for action
        if (
            ref $ModuleReg->{GroupRo} eq 'ARRAY'
            && !scalar @{ $ModuleReg->{GroupRo} }
            && ref $ModuleReg->{Group} eq 'ARRAY'
            && !scalar @{ $ModuleReg->{Group} }
            )
        {
            $Param{AccessRo} = 1;
            $Param{AccessRw} = 1;
        }
        else {

            ( $Param{AccessRo}, $Param{AccessRw} ) = $Self->_CheckModulePermission(
                ModuleReg => $ModuleReg,
                %UserData,
            );

            if ( !$Param{AccessRo} ) {

                # new layout object
                my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'No Permission to use this frontend action module!'
                );

                $LayoutObject->CustomerFatalError(
                    Comment => Translatable('Please contact the administrator.'),
                );    # throws a Kernel::System::Web::Exception
            }

        }

        my $NavigationConfig = $ConfigObject->Get('CustomerFrontend::Navigation')->{ $Param{Action} };

        # module permission check for submenu item
        if ( IsHashRefWithData($NavigationConfig) ) {

            KEY:
            for my $Key ( sort keys %{$NavigationConfig} ) {
                next KEY if $Key                 !~ m/^\d+/i;
                next KEY if $Param{RequestedURL} !~ m/Subaction/i;

                my @ModuleNavigationConfigs;

                # FIXME: Support both old (HASH) and new (ARRAY of HASH) navigation configurations, for reasons of
                #   backwards compatibility. Once we are sure everything has been migrated correctly, support for
                #   HASH-only configuration can be dropped in future major release.
                if ( IsHashRefWithData( $NavigationConfig->{$Key} ) ) {
                    push @ModuleNavigationConfigs, $NavigationConfig->{$Key};
                }
                elsif ( IsArrayRefWithData( $NavigationConfig->{$Key} ) ) {
                    push @ModuleNavigationConfigs, @{ $NavigationConfig->{$Key} };
                }

                # Skip incompatible configuration.
                else {
                    next KEY;
                }

                ITEM:
                for my $Item (@ModuleNavigationConfigs) {
                    if (
                        $Item->{Link} !~ m/Subaction=/i
                        || $Item->{Link} !~ m/$Param{Subaction}/i
                        )
                    {
                        next ITEM;
                    }
                    $Param{AccessRo} = 0;
                    $Param{AccessRw} = 0;

                    # module permission check for submenu item
                    if (
                        ref $Item->{GroupRo} eq 'ARRAY'
                        && !scalar @{ $Item->{GroupRo} }
                        && ref $Item->{Group} eq 'ARRAY'
                        && !scalar @{ $Item->{Group} }
                        )
                    {
                        $Param{AccessRo} = 1;
                        $Param{AccessRw} = 1;
                    }
                    else {

                        ( $Param{AccessRo}, $Param{AccessRw} ) = $Self->_CheckModulePermission(
                            ModuleReg => $Item,
                            %UserData,
                        );

                        if ( !$Param{AccessRo} ) {

                            # new layout object
                            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'error',
                                Message  => 'No Permission to use this frontend subaction module!'
                            );

                            $LayoutObject->CustomerFatalError(
                                Comment => Translatable('Please contact the administrator.')
                            );    # throws a Kernel::System::Web::Exception
                        }
                    }
                }
            }
        }

        # create new LayoutObject with new '%Param' and '%UserData'
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                %Param,
                %UserData,
                ModuleReg => $ModuleReg,
            },
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Output::HTML::Layout'] );

        # update last request time
        if (
            !$ParamObject->IsAJAXRequest()
            || $Param{Action} eq 'CustomerVideoChat'
            )
        {
            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

            $SessionObject->UpdateSessionID(
                SessionID => $Param{SessionID},
                Key       => 'UserLastRequest',
                Value     => $DateTimeObject->ToEpoch(),
            );
        }

        # pre application module
        my $PreModule = $ConfigObject->Get('CustomerPanelPreApplicationModule');
        if ( $Param{Action} ne 'CustomerGenericContent' && $PreModule ) {
            my %PreModuleList;
            if ( ref $PreModule eq 'HASH' ) {
                %PreModuleList = %{$PreModule};
            }
            else {
                $PreModuleList{Init} = $PreModule;
            }

            MODULE:
            for my $PreModuleKey ( sort keys %PreModuleList ) {
                my $PreModule = $PreModuleList{$PreModuleKey};
                next MODULE if !$PreModule;
                next MODULE if !$Kernel::OM->Get('Kernel::System::Main')->Require($PreModule);

                # debug info
                if ( $Self->{Debug} ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => "CustomerPanelPreApplication module $PreModule is used.",
                    );
                }

                my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

                # use module
                my $PreModuleObject = $PreModule->new(
                    %Param,
                    %UserData,

                );
                my $Output = $PreModuleObject->PreRun();

                return $Output if $Output;
            }
        }

        # debug info
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'Kernel::Modules::' . $Param{Action} . '->new',
            );
        }

        my $FrontendObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
            %Param,
            %UserData,
            ModuleReg => $ModuleReg,
            Debug     => $Self->{Debug},
        );

        # debug info
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'Kernel::Modules::' . $Param{Action} . '->run',
            );
        }

        # ->Run $Action with $FrontendObject
        my $Output = $FrontendObject->Run();

        # log request time for AdminPerformanceLog
        if ( $ConfigObject->Get('PerformanceLog') ) {
            my $File = $ConfigObject->Get('PerformanceLog::File');

            # Write to PerformanceLog file only if it is smaller than size limit (see bug#14747).
            if ( -s $File < ( 1024 * 1024 * $ConfigObject->Get('PerformanceLog::FileMax') ) ) {
                if ( open my $Out, '>>', $File ) {    ## no critic qw(OTOBO::ProhibitOpen)

                    # a fallback for the query string when the action is missing
                    if ( ( !$QueryString && $Param{Action} ) || $QueryString !~ /Action=/ ) {
                        $QueryString = 'Action=' . $Param{Action} . ';Subaction=' . $Param{Subaction};
                    }

                    my $Now = Time::HiRes::time();
                    print $Out join '::',
                        $Now,
                        'Customer',
                        ( $Now - $Self->{PerformanceLogStart} ),
                        $UserData{UserLogin},    # not used in the AdminPerformanceLog frontend
                        "$QueryString\n";
                    close $Out;

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => 'Response::Customer: '
                            . ( $Now - $Self->{PerformanceLogStart} )
                            . "s taken (URL:$QueryString:$UserData{UserLogin})",
                    );
                }
                else {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Can't write $File: $!",
                    );
                }
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "PerformanceLog file '$File' is too large, you need to reset it in PerformanceLog page!",
                );
            }
        }

        return $Output;
    }

    # throws a Kernel::System::Web::Exception
    my %Data = $SessionObject->GetSessionIDData(
        SessionID => $Param{SessionID},
    );
    $Data{UserTimeZone} = $Self->_UserTimeZoneGet(%Data);
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
            %Data,
        },
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->CustomerFatalError(
        Comment => Translatable('Please contact the administrator.'),
    );
}

=head2 Response()

Generate a PSGI Response object from the content generated by C<Content()>.

    my $Response = $Interface->Response();

=cut

sub Response {
    my ($Self) = @_;

    # Note that the layout object mustn't be created before calling Content().
    # This is because Content() might want to set object params before the initial creations.
    # A notable example is the SetCookies parameter.
    my $Content = $Self->Content();

    # The filtered content is a string, regardless of whether the original content is
    # a string, an array reference, or a file handle.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $Content = $LayoutObject->ApplyOutputFilters( Output => $Content );

    # The HTTP headers of the OTOBO web response object already have been set up.
    # Enhance it with the HTTP status code and the content.
    return $Kernel::OM->Get('Kernel::System::Web::Response')->Finalize( Content => $Content );
}

=begin Internal:

=head2 _StoreFailedLogins()

=cut

sub _StoreFailedLogins {
    my ( $Self, %Param ) = @_;
    my $CurrentTimeObject   = $Kernel::OM->Create('Kernel::System::DateTime');
    my $CurrentNewTimeStamp = $CurrentTimeObject->ToString();
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $CheckHash           = $CacheObject->Get(
        Type => 'FailedLoginsCustomer',
        Key  => $Param{PostUser},
    );

    if ( !$CheckHash ) {
        $CacheObject->Set(
            Type  => 'FailedLoginsCustomer',
            Key   => $Param{PostUser},
            Value => [$CurrentNewTimeStamp],
            TTL   => $Param{PreventBruteForceConfig}{KeepCacheDuration},
        );

        return 0;
    }

    my @LoginTryArray = @{$CheckHash};

    # delete expired cache entries
    LOGIN:
    for my $LoginTime ( @{$CheckHash} ) {
        my $LoginTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $LoginTime,
            },
        );
        my $Offset = $CurrentTimeObject->Delta(
            DateTimeObject => $LoginTimeObject,
        );

        if ( $Offset->{AbsoluteSeconds} > $Param{PreventBruteForceConfig}->{KeepCacheDuration} ) {
            shift @LoginTryArray;
        }
        else {
            last LOGIN;
        }
    }

    # add new failed login to cache
    push @LoginTryArray, $CurrentNewTimeStamp;
    $CacheObject->Set(
        Type  => 'FailedLoginsCustomer',
        Key   => $Param{PostUser},
        Value => \@LoginTryArray,
        TTL   => $Param{PreventBruteForceConfig}{KeepCacheDuration},
    );

    if ( scalar @LoginTryArray >= $Param{PreventBruteForceConfig}{MaxAttempt} ) {
        $CacheObject->Set(
            Type  => 'BannedLoginsCustomer',
            Key   => $Param{PostUser},
            Value => $CurrentNewTimeStamp,
            TTL   => $Param{PreventBruteForceConfig}{BanDuration},
        );
        return 1;
    }

    return 0;
}

sub _CheckAndRemoveFromBannedList {
    my ( $Self, %Param ) = @_;

    # get cache
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $BanTime = $CacheObject->Get(
        Type => 'BannedLoginsCustomer',
        Key  => $Param{PostUser},
    );

    if ( !$BanTime ) {
        return (
            Banned => 0,
        );
    }

    # calculate elapsed time
    my $CurTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $BanTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $BanTime,
        },
    );
    my $Offset = $CurTimeObject->Delta(
        DateTimeObject => $BanTimeObject,
    );

    # if the ban duration has been surpassed, delete the cache entry
    if ( $Offset->{AbsoluteSeconds} > $Param{PreventBruteForceConfig}{BanDuration} ) {
        $CacheObject->Delete(
            Type => 'BannedLoginsCustomer',
            Key  => $Param{PostUser},
        );
        return (
            Banned => 0,
        );
    }

    return (
        Banned       => 1,
        ResidualTime => $Param{PreventBruteForceConfig}{BanDuration} - $Offset->{AbsoluteSeconds},
    );
}

=head2 _CheckModulePermission()

module permission check

    ($AccessRo, $AccessRw = $AutoResponseObject->_CheckModulePermission(
        ModuleReg => $ModuleReg,
        %UserData,
    );

=cut

sub _CheckModulePermission {
    my ( $Self, %Param ) = @_;

    my $AccessRo = 0;
    my $AccessRw = 0;

    PERMISSION:
    for my $Permission (qw(GroupRo Group)) {
        my $AccessOk = 0;
        my $Group    = $Param{ModuleReg}->{$Permission};

        next PERMISSION if !$Group;

        my $GroupObject = $Kernel::OM->Get('Kernel::System::CustomerGroup');

        if ( IsArrayRefWithData($Group) ) {
            GROUP:
            for my $Item ( @{$Group} ) {
                next GROUP if !$Item;
                next GROUP if !$GroupObject->PermissionCheck(
                    UserID    => $Param{UserID},
                    GroupName => $Item,
                    Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',
                );

                $AccessOk = 1;
                last GROUP;
            }
        }
        else {
            my $HasPermission = $GroupObject->PermissionCheck(
                UserID    => $Param{UserID},
                GroupName => $Group,
                Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',
            );
            if ($HasPermission) {
                $AccessOk = 1;
            }
        }
        if ( $Permission eq 'Group' && $AccessOk ) {
            $AccessRo = 1;
            $AccessRw = 1;
        }
        elsif ( $Permission eq 'GroupRo' && $AccessOk ) {
            $AccessRo = 1;
        }
    }

    return ( $AccessRo, $AccessRw );
}

=head2 _UserTimeZoneGet()

Get time zone for the current user. This function will validate passed time zone parameter and return default user time
zone if it's not valid.

    my $UserTimeZone = $Self->_UserTimeZoneGet(
        UserTimeZone => 'Europe/Berlin',
    );

=cut

sub _UserTimeZoneGet {
    my ( $Self, %Param ) = @_;

    my $UserTimeZone;

    # Return passed time zone only if it's valid. It can happen that user preferences or session store an old-style
    #   offset which is not valid anymore. In this case, return the default value.
    #   Please see bug#13374 for more information.
    if (
        $Param{UserTimeZone}
        && Kernel::System::DateTime->IsTimeZoneValid( TimeZone => $Param{UserTimeZone} )
        )
    {
        $UserTimeZone = $Param{UserTimeZone};
    }

    $UserTimeZone ||= Kernel::System::DateTime->UserDefaultTimeZoneGet();

    return $UserTimeZone;
}

=end Internal:

=cut

1;
