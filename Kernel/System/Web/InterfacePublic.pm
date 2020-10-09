# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

use strict;
use warnings;

# core modules

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
);

=head1 NAME

Kernel::System::Web::InterfacePublic - the public web interface

=head1 DESCRIPTION

the global public web interface

=head1 PUBLIC INTERFACE

=head2 new()

create the web interface object for 'public.pl'.

    use Kernel::System::Web::InterfacePublic;

    my $Interface = Kernel::System::Web::InterfacePublic->new();

    # with debugging enabled
    my $Interface = Kernel::System::Web::InterfacePublic->new(
        Debug => 1
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # start with an empty hash for the new object
    my $Self = bless {}, $Type;

    # get debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # performance log
    $Self->{PerformanceLogStart} = time();

    # register object params
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => $Kernel::OM->Get('Kernel::Config')->Get('CGILogPrefix') || 'Public',
        },
        'Kernel::System::Web::Request' => {
            WebRequest => $Param{WebRequest} || 0,
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

=head2 HeaderAndContent()

execute the object

    $Interface->HeaderAndContent();

=cut

sub HeaderAndContent {
    my $Self = shift;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Check if https forcing is active, and redirect if needed.
    if ( $ConfigObject->Get('HTTPSForceRedirect') ) {

        # Allow HTTPS to be 'on' in a case insensitive way.
        # In OTOBO 10.0.1 it had to be lowercase 'on'.
        my $HTTPS = $ParamObject->HTTPS('HTTPS') // '';
        if ( lc $HTTPS ne 'on' ) {
            my $Host       = $ParamObject->HTTP('HOST') || $ConfigObject->Get('FQDN');
            my $RequestURI = $ParamObject->RequestURI();

            # Redirect with 301 code. Add two new lines at the end, so HTTP headers are validated correctly.
            return "Status: 301 Moved Permanently\nLocation: https://$Host$RequestURI\n\n";
        }
    }

    # get common framework params
    my %Param;
    $Param{SessionName} = $ConfigObject->Get('CustomerPanelSessionName')         || 'CSID';
    $Param{SessionID}   = $ParamObject->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
    my $QueryString = $ParamObject->EnvQueryString() || '';
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
        $LayoutObject->CustomerFatalError(
            Comment => Translatable('Please contact the administrator.'),
        );
    }
    if ( $ParamObject->Error() ) {
        $LayoutObject->CustomerFatalError(
            Message => $ParamObject->Error(),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # run modules if a version value exists
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {
        $LayoutObject->CustomerFatalError(
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # module registry
    my $ModuleReg = $ConfigObject->Get('PublicFrontend::Module')->{ $Param{Action} };
    if ( !$ModuleReg ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
        );
        $LayoutObject->CustomerFatalError(
            Comment => Translatable('Please contact the administrator.'),
        );
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
    $LayoutObject->ApplyOutputFilters( Output => \$Output );

    # log request time
    if ( $ConfigObject->Get('PerformanceLog') ) {
        if ( ( !$QueryString && $Param{Action} ) || $QueryString !~ /Action=/ ) {
            $QueryString = 'Action=' . $Param{Action} . '&Subaction=' . $Param{Subaction};
        }
        my $File = $ConfigObject->Get('PerformanceLog::File');
        ## no critic
        if ( open my $Out, '>>', $File ) {
            ## use critic
            print $Out time()
                . '::Public::'
                . ( time() - $Self->{PerformanceLogStart} )
                . "::-::$QueryString\n";
            close $Out;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'Response::Public: '
                    . ( time() - $Self->{PerformanceLogStart} )
                    . "s taken (URL:$QueryString)",
            );
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't write $File: $!",
            );
        }
    }

    return $Output;
}

1;
