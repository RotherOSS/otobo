# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.io/
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

package Plack::Middleware::OTOBO::SecureModeAccessFilter;

use strict;
use warnings;
use v5.24;
use utf8;

use parent qw(Plack::Middleware);

# core modules
use List::Util qw(pairs);

# CPAN modules
use Plack::Util::Accessor qw(rules);

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

=head1 NAME

Plack::Middleware::OTOBO::SecureModeAccessFilter - access checks based on the secure flag

=head1 SYNOPSIS

    # a Plack middleware

=head1 DESCRIPTION

Depends on that L<$Kernel::OM> has been localized and that C<otobo.x.script_file_name> is in the PSGI environment.

=cut

sub prepare_app {
    my ($Self) = @_;

    # set defaults
    if ( !defined $Self->rules ) {
        $Self->rules( [] );
    }

    my @ActualRules;
    RULE:
    for my $Rule ( pairs $Self->rules->@* ) {
        my ( $Allowing, $Condition ) = $Rule->@*;

        # deny access in case of misconfiguration
        if ( !$Allowing || !$Rule || ( $Allowing ne 'allow' && $Allowing ne 'deny' ) ) {
            @ActualRules = ( [ sub { return 1 } => 0 ] );

            last RULE;
        }

        my $Decision = ( $Allowing eq 'allow' ) ? 1 : 0;

        if ( ref $Condition eq 'CODE' ) {
            push @ActualRules, [ $Condition => $Decision ];

            next RULE;
        }

        # check SecureMode
        if ( $Condition eq 'securemode_is_on' ) {
            push @ActualRules, [
                sub {
                    return 1 if $Kernel::OM->Get('Kernel::Config')->Get('SecureMode');
                    return 0;
                },
                => $Decision
            ];

            next RULE;
        }

        # say no when in doubt
        push @ActualRules, [ sub { return 0 } => $Decision ];
    }

    $Self->rules( \@ActualRules );

    return;
}

sub call {
    my ( $Self, $Env ) = @_;

    # evaluate the rules
    my $AccessAllowed;
    RULE:
    for my $Rule ( $Self->rules->@* ) {
        my ( $Check, $Decision ) = $Rule->@*;

        my $CheckResult = $Check->($Env);

        # the check was undecided
        next RULE unless defined $CheckResult;

        # the first not undecided check wins
        $AccessAllowed = $CheckResult ? $Decision : !$Decision;

        last RULE;
    }

    # access is granted when it wasn't explicitly denied
    $AccessAllowed //= 1;

    # continue when access is denied
    return $Self->app->($Env) if $AccessAllowed;

    # access is denied, print the message
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $Content      = join '',
        $LayoutObject->Header(),
        $LayoutObject->Error(
            Message => Translatable('SecureMode active!'),
            Comment => Translatable('If you want to re-run installer.pl, then disable the SecureMode in the SysConfig.'),
        ),
        $LayoutObject->Footer();

    # The HTTP headers of the OTOBO web response object already have been set up.
    # Enhance it with the HTTP status code and the content.
    my $Response = $Kernel::OM->Get('Kernel::System::Web::Response');

    # HTTP status 403: access denied
    $Response->Code(403);

    # return a PSGI result
    return $Response->Finalize( Content => $Content );
}

1;
