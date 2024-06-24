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

package Kernel::System::Web::InterfacePublic;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use Time::HiRes ();

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Web::Request',
    'Kernel::System::Web::Response',
);

=head1 NAME

Kernel::System::Web::InterfacePublic - the public web interface

=head1 SYNOPSIS

    use Kernel::System::Web::InterfacePublic;

    # a Plack request handler
    my $App = sub {
        my $Env = shift;

        my $Interface = Kernel::System::Web::InterfacePublic->new(
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

This module generates the HTTP response for F<public.pl>.
This class is meant to be used within a Plack request handler.
See F<bin/psgi-bin/otobo.psgi> for the real live usage.

=head1 PUBLIC INTERFACE

=head2 new()

create the web interface object for F<public.pl>.

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
            LogPrefix => $Kernel::OM->Get('Kernel::Config')->Get('CGILogPrefix') || 'Public',
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

sub Content {
    my $Self = shift;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Check if https forcing is active, and redirect if needed.
    if ( $ConfigObject->Get('HTTPSForceRedirect') && !$ParamObject->HttpsIsOn ) {
        my $Host         = $ParamObject->Header('Host') || $ConfigObject->Get('FQDN');
        my $RequestURI   = $ParamObject->RequestURI();
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        $LayoutObject->Redirect( ExtURL => "https://$Host$RequestURI" );    # throw a Kernel::System::Web::Exception exception
    }

    # get common framework params
    my %Param;
    $Param{SessionName} = $ConfigObject->Get('CustomerPanelSessionName')         || 'CSID';
    $Param{SessionID}   = $ParamObject->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
    my $QueryString = $ParamObject->QueryString() || '';
    $QueryString =~ s/(\?|&|;|)$Param{SessionName}(=&|=;|=.+?&|=.+?$)/;/g;

    # define framework params
    my $FrameworkParams = {
        Lang         => '',
        Action       => '',
        Subaction    => '',
        RequestedURL => $QueryString,
    };
    for my $Key ( sort keys %{$FrameworkParams} ) {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key )
            || $FrameworkParams->{$Key};
    }

    # validate language
    if ( $Param{Lang} && $Param{Lang} !~ m{\A[a-z]{2}(?:_[A-Z]{2})?\z}xms ) {
        delete $Param{Lang};
    }

    # check if the browser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    if ( $ConfigObject->Get('SessionUseCookie') ) {
        $Param{SessionIDCookie} = $ParamObject->GetCookie( Key => $Param{SessionName} );
        if ( $Param{SessionIDCookie} ) {
            $Param{SessionID} = $Param{SessionIDCookie};
        }
    }

    # get common application and add-on application params
    # Important!
    # This must be done before creating the layout object,
    # because otherwise the action parameter is not passed and then
    # the loader can not load module specific JavaScript and CSS
    # For details see bug: http://bugs.otrs.org/show_bug.cgi?id=6471
    my %CommonObjectParam = %{ $ConfigObject->Get('PublicFrontend::CommonParam') };
    for my $Key ( sort keys %CommonObjectParam ) {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key ) || $CommonObjectParam{$Key};
    }

    # security check Action Param (replace non-word chars)
    $Param{Action} =~ s/\W//g;

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
            SessionIDCookie => 1,
            Debug           => $Self->{Debug},
        },
    );

    my $DBCanConnect = $Kernel::OM->Get('Kernel::System::DB')->Connect();

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$DBCanConnect ) {

        # Show error without showing neither the last logmessage not the last traceback.
        $LayoutObject->PublicFatalError(
            Message => Translatable('Could not connect to the database.'),
            Comment => Translatable('Please contact the administrator.'),
        );    # throws a Kernel::System::Web::Exception
    }

    if ( $ParamObject->Error() ) {

        # Show error without showing neither the last logmessage not the last traceback.
        $LayoutObject->PublicFatalError(
            Message => $ParamObject->Error(),
            Comment => Translatable('Please contact the administrator.'),
        );    # throws a Kernel::System::Web::Exception
    }

    # run modules if a version value exists
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {

        # Show error without showing neither the last logmessage not the last traceback.
        $LayoutObject->PublicFatalError(
            Message => sprintf( Translatable(q{The action '%s' is not available.}), $Param{Action} ),
            Comment => Translatable('Please contact the administrator.'),
        );    # throws a Kernel::System::Web::Exception
    }

    # module registry
    my $ModuleReg = $ConfigObject->Get('PublicFrontend::Module')->{ $Param{Action} };
    if ( !$ModuleReg ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
        );

        # Show error without showing neither the last logmessage not the last traceback.
        $LayoutObject->PublicFatalError(
            Message => sprintf( Translatable(q{The action '%s' is not allowed.}), $Param{Action} ),
            Comment => Translatable('Please contact the administrator.'),
        );    # throws a Kernel::System::Web::Exception
    }

    # debug info
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Kernel::Modules::' . $Param{Action} . '->new',
        );
    }

    my $FrontendObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
        UserID => 1,
        %Param,
        Debug => $Self->{Debug},
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

    # add extra scope in order to reduce diffs to InterfaceAgent
    {

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
                        'Public',
                        ( $Now - $Self->{PerformanceLogStart} ),
                        '-',    # not used in the AdminPerformanceLog frontend
                        "$QueryString\n";
                    close $Out;

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => 'Response::Public: '
                            . ( $Now - $Self->{PerformanceLogStart} )
                            . "s taken (URL:$QueryString:-)",
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
    }

    return $Output;
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

1;
