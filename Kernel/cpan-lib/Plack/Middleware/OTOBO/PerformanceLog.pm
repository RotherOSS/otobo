# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2025 Rother OSS GmbH, https://otobo.io/
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

package Plack::Middleware::OTOBO::PerformanceLog;

use v5.24;
use strict;
use warnings;
use utf8;

use parent qw(Plack::Middleware);

# core modules
use Time::HiRes    qw(gettimeofday tv_interval);

# CPAN modules
use Plack::Util::Accessor qw(interface);

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

=head1 NAME

Plack::Middleware::OTOBO::PerformanceLog - write a performance log

=head1 SYNOPSIS

    # a Plack middleware

=head1 DESCRIPTION

Depends on that L<$Kernel::OM> has been localized.

=cut

sub prepare_app {
    my ($Self) = @_;

    # set defaults
    $Self->interface( 'unknown' ) unless defined $Self->interface;

    return;
}

sub call {
    my ( $Self, $Env ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # simply proceed when performance logging is deactivated
    return $Self->app->($Env) unless $ConfigObject->Get('PerformanceLog');

    # track the start time of the requests
    my ($StartSeconds, $StartMicroSeconds) = gettimeofday;

    # do the actual work
    my $Res = $Self->app->($Env);

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # drop old session id (if exists)
    my $SessionName = $ConfigObject->Get('SessionName') || 'SessionID';
    my $QueryString = $ParamObject->QueryString() || '';
    my $Action = $ParamObject->GetParam( Param => 'Action' );
    my $Subaction = $ParamObject->GetParam( Param => 'Subaction' );

    # TODO: why is the pattern =.+?; not included ?
    $QueryString =~ s/(\?|&|;|)$SessionName(=&|=;|=.+?&|=.+?$)/;/g;

    # a fallback for the query string when the action is missing
    if ( ( !$QueryString && $Action ) || $QueryString !~ /Action=/ ) {
        $QueryString = "Action=$Action;Subaction=$Subaction";
    }

    # Write to PerformanceLog file only if it is smaller than size limit.
    # The limit is given in MB.
    my $File = $ConfigObject->Get('PerformanceLog::File');
    if ( -s $File < ( 1024 * 1024 * $ConfigObject->Get('PerformanceLog::FileMax') ) ) {

        # Hoping that appending lines to a file is atomic.
        if ( open my $Out, '>>', $File ) {    ## no critic qw(OTOBO::ProhibitOpen)

            my $Duration = tv_interval([$StartSeconds, $StartMicroSeconds]);
            my $Interface = $Self->interface;
            say $Out join '::',
                "$StartSeconds.$StartMicroSeconds",
                $Self->interface(),
                $Duration,
                'unused',
                $QueryString;
            close $Out;

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Response::$Interface: $Duration taken (URL:$QueryString)",
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

    return $Res;
}

1;
