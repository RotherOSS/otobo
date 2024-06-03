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

use strict;
use warnings;

# core modules
use Time::HiRes qw();

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

create public web interface object

    use Kernel::System::Web::InterfacePublic;

    my $Debug = 0;
    my $Interface = Kernel::System::Web::InterfacePublic->new(
        Debug      => $Debug,
        WebRequest => CGI::PSGI->new($env), # optional, e. g. if PSGI is used
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # performance log based on high resolution timestamps
    $Self->{PerformanceLogStart} = Time::HiRes::time();

    # register object params
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => $Kernel::OM->Get('Kernel::Config')->Get('CGILogPrefix'),
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

=head2 Run()

execute the object

    $Interface->Run();

=cut

sub Run {
    my $Self = shift;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $QueryString = $ENV{QUERY_STRING} || '';

    # Check if https forcing is active, and redirect if needed.
    if ( $ConfigObject->Get('HTTPSForceRedirect') ) {

        # Some web servers do not set HTTPS environment variable, so it's not possible to easily know if we are using
        #   https protocol. Look also for similarly named keys in environment hash, since this should prevent loops in
        #   certain cases.
        if (
            (
                !defined $ENV{HTTPS}
                && !grep {/^HTTPS(?:_|$)/} keys %ENV
            )
            || $ENV{HTTPS} ne 'on'
            )
        {
            my $Host = $ENV{HTTP_HOST} || $ConfigObject->Get('FQDN');

            # Redirect with 301 code. Add two new lines at the end, so HTTP headers are validated correctly.
            print "Status: 301 Moved Permanently\nLocation: https://$Host$ENV{REQUEST_URI}\n\n";
            return;
        }
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %Param;

    # get session id
    $Param{SessionName} = $ConfigObject->Get('CustomerPanelSessionName')         || 'CSID';
    $Param{SessionID}   = $ParamObject->GetParam( Param => $Param{SessionName} ) || '';

    # drop old session id (if exists)
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
        return 1;
    }

    # module registry
    my $ModuleReg = $ConfigObject->Get('PublicFrontend::Module')->{ $Param{Action} };
    if ( !$ModuleReg ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "Module Kernel::Modules::$Param{Action} not registered in Kernel/Config.pm!",
        );
        $LayoutObject->CustomerFatalError(
            Comment => Translatable('Please contact the administrator.'),
        );
        return;
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
    $LayoutObject->Print( Output => \$FrontendObject->Run() );

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

    return 1;
}

sub DESTROY {
    my $Self = shift;

    # debug info
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Global handle stopped.',
        );
    }

    return 1;
}

1;
