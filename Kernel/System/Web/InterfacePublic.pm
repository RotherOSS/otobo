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

package Kernel::System::Web::InterfacePublic;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Plack::Component);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language             qw(Translatable);
use Kernel::Output::HTML::Layout ();

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

    # a Plack app
    return Kernel::System::Web::InterfacePublic->new(
        Debug     => $Self->{Debug},
    )->to_app->($Env);

=head1 DESCRIPTION

This module generates the HTTP response for F<public.pl>.
It is meant to be used within a Plack request handler.
See F<bin/psgi-bin/otobo.psgi> for the real live usage.

=head1 PRIVATE FUNCTIONS

=head2 _Content()

Generate content.
Set headers in Kernels::System::Web::Request singleton as side effect.
Can die and throw a C<Kernel::System::Web::Exception> exception. That exception
is expected to be caught by the middleware C<Plack::Middleware::HTTPExceptions>.

    my $Content = _Content();

or with debugging:

    my $Content = _Content( Debug => 1 );

=cut

sub _Content {
    my (%IncomingParam) = @_;

    my $Debug = $IncomingParam{Debug} || 0;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Collect object parameters for the Layout object
    my %Param;

    # Get the Session ID in case it was passed as a POST or GET parameter.
    $Param{SessionName} = $ConfigObject->Get('CustomerPanelSessionName')         || 'CSID';
    $Param{SessionID}   = $ParamObject->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
    my $QueryString = $ParamObject->QueryString() || '';

    # TODO: why is the pattern =.+?; not included ?
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
            Debug           => $Debug,
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
    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Kernel::Modules::' . $Param{Action} . '->new',
        );
    }

    my $FrontendObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
        UserID => 1,
        %Param,
        Debug => $Debug,
    );

    # debug info
    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Kernel::Modules::' . $Param{Action} . '->run',
        );
    }

    # Generate output using the frontend, that is Kernel::Modules::*, object.
    # The output is either a string or a IO::Handle like object.
    return $FrontendObject->Run();
}

=head1 PUBLIC INTERFACE

=head2 call()

Generate a PSGI Response object from the content generated by C<_Content()>.
This is the subroutine that is called in F<otobo.psgi>.

    my $Response = $Interface->call();

=cut

sub call {
    my ( $Self, $Env ) = @_;

    my $Debug = $Self->{Debug} || 0;

    # The OTOBO modules which generate the content get their input
    # from the Kernel::System::Web::Request singleton, that is the ParamObject.
    # Make the PSGI environment available to the constructor of the ParamObject.
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Web::Request' => {
            PSGIEnv => $Env,
        },
    );

    # debug info
    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Global handle for $Self->{Interface} started...",
        );
    }

    # Note that the layout object mustn't be created before calling _Content().
    # This is because _Content() might want to set object params before the initial creations.
    # A notable example is the SetCookies parameter.
    my $Content = _Content( Debug => $Debug );

    # The filtered content is a string, regardless of whether the original content is
    # a string, an array reference, or a file handle.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $Content = $LayoutObject->ApplyOutputFilters( Output => $Content );

    # The HTTP headers of the OTOBO web response object already have been set up.
    # Enhance it with the HTTP status code and the content.
    return $Kernel::OM->Get('Kernel::System::Web::Response')->Finalize(
        Content => $Content,
    );
}

1;
