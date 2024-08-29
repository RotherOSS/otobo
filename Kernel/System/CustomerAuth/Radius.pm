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

package Kernel::System::CustomerAuth::Radius;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules
use Authen::Radius ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);
our @SoftObjectDependencies = (
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config
    $Self->{Die} = $ConfigObject->Get( 'Customer::AuthModule::Radius::Die' . $Param{Count} );

    # get user table
    $Self->{RadiusHost} = $ConfigObject->Get( 'Customer::AuthModule::Radius::Host' . $Param{Count} )
        || die "Need Customer::AuthModule::Radius::Host$Param{Count} in Kernel/Config.pm";
    $Self->{RadiusSecret} = $ConfigObject->Get( 'Customer::AuthModule::Radius::Password' . $Param{Count} )
        || die "Need Customer::AuthModule::Radius::Password$Param{Count} in Kernel/Config.pm";

    return $Self;
}

sub GetOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need What!"
        );
        return;
    }

    # module options
    my %Option = (
        PreAuth => 0,
    );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need User!"
        );
        return;
    }

    # get params
    my $User        = $Param{User} || '';
    my $Pw          = $Param{Pw}   || '';
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $RemoteAddr  = $ParamObject->RemoteAddr() || 'Got no REMOTE_ADDR env!';
    my $UserID      = '';
    my $GetPw       = '';

    # Debugging can only be activated in the source code,
    # so that sensitive information is not inadvertently leaked.
    my $Debug = 0;
    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $User tried to authenticate (REMOTE_ADDR: $RemoteAddr)",
        );
    }

    # just a note
    if ( !$User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No User given!!! (REMOTE_ADDR: $RemoteAddr)",
        );

        return;
    }

    # just a note
    if ( !$Pw ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "User: $User Authentication without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );

        return;
    }

    # Create a radius object
    my $Radius = Authen::Radius->new(
        Host   => $Self->{RadiusHost},
        Secret => $Self->{RadiusSecret},
    );
    if ( !$Radius ) {
        if ( $Self->{Die} ) {
            die "Can't connect to $Self->{RadiusHost}: $@";
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't connect to $Self->{RadiusHost}: $@",
            );

            return;
        }
    }
    my $AuthResult = $Radius->check_pwd( $User, $Pw );

    # login note
    if ( defined($AuthResult) && $AuthResult == 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $User Authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );

        return $User;
    }

    # just a note
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $User Authentication with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        );

        return;
    }
}

1;
