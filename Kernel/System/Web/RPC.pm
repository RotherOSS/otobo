# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

package OTOBO::RPC;    ## no critic (Modules::RequireFilenameMatchesPackage)

=head1 NAME

OTOBO::RPC - subroutines for the SOAP service F<rpc.pl>

=head1 SYNOPSIS

    # see the app $RPCApp in bin/psgi-bin/otobo.psgi

=head1 DESCRIPTION

The SOAP service F<rpc.pl> will dispatch to this module. Note that the package name L<OTOBO::RPC> diverges
from the file name F<Kernel/System/Web/RPC.pm>. This is intended as L<SOAP::Lite> dispatches based on the package name.

The module is not managed with the object manager.

=head1 SUBROUTINES

=cut

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

## nofilter(TidyAll::Plugin::OTOBO::Perl::ObjectManagerCreation)

our $ObjectManagerDisabled = 1;

=head2 new()

Constructor for a dummy object, as L<SOAP::Lite> dispatches on objects.

=cut

sub new {
    my $Self = shift;

    my $Class = ref($Self) || $Self;

    return bless {} => $Class;
}

=head2 Dispatch()

Call the methods that were requested by the SOAP client.

=cut

sub Dispatch {
    my ( $Self, $User, $Pw, $Object, $Method, %Param ) = @_;

    $User ||= '';
    $Pw   ||= '';
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'OTOBO-RPC',
        },
    );

    my %CommonObject;

    $CommonObject{ConfigObject}          = $Kernel::OM->Get('Kernel::Config');
    $CommonObject{CustomerCompanyObject} = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    $CommonObject{CustomerUserObject}    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    $CommonObject{EncodeObject}          = $Kernel::OM->Get('Kernel::System::Encode');
    $CommonObject{GroupObject}           = $Kernel::OM->Get('Kernel::System::Group');
    $CommonObject{LinkObject}            = $Kernel::OM->Get('Kernel::System::LinkObject');
    $CommonObject{LogObject}             = $Kernel::OM->Get('Kernel::System::Log');
    $CommonObject{PIDObject}             = $Kernel::OM->Get('Kernel::System::PID');
    $CommonObject{QueueObject}           = $Kernel::OM->Get('Kernel::System::Queue');
    $CommonObject{SessionObject}         = $Kernel::OM->Get('Kernel::System::AuthSession');
    $CommonObject{TicketObject}          = $Kernel::OM->Get('Kernel::System::Ticket');

    # We want to keep providing the TimeObject as legacy API for now.
    ## nofilter(TidyAll::Plugin::OTOBO::Migrations::OTOBO10::TimeObject)
    $CommonObject{TimeObject} = $Kernel::OM->Get('Kernel::System::Time');
    $CommonObject{UserObject} = $Kernel::OM->Get('Kernel::System::User');

    my $RequiredUser     = $CommonObject{ConfigObject}->Get('SOAP::User');
    my $RequiredPassword = $CommonObject{ConfigObject}->Get('SOAP::Password');

    if (
        !defined $RequiredUser
        || !length $RequiredUser
        || !defined $RequiredPassword || !length $RequiredPassword
        )
    {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
        );
        return;
    }

    if ( $User ne $RequiredUser || $Pw ne $RequiredPassword ) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "Auth for user $User (pw $Pw) failed!",
        );

        return;
    }

    if ( !$CommonObject{$Object} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "No such Object $Object!",
        );
        return "No such Object $Object!";
    }

    return $CommonObject{$Object}->$Method(%Param);
}

=head2 DispatchMultipleTicketMethods()

to dispatch multiple ticket methods and get the TicketID

    my $TicketID = $RPC->DispatchMultipleTicketMethods(
        $SOAP_User,
        $SOAP_Pass,
        'TicketObject',
        [ { Method => 'TicketCreate', Parameter => \%TicketData }, { Method => 'ArticleCreate', Parameter => \%ArticleData } ],
    );

=cut

sub DispatchMultipleTicketMethods {
    my ( $Self, $User, $Pw, $Object, $MethodParamArrayRef ) = @_;

    $User ||= '';
    $Pw   ||= '';

    # common objects
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'OTOBO-RPC',
        },
    );

    my %CommonObject;

    $CommonObject{ConfigObject}          = $Kernel::OM->Get('Kernel::Config');
    $CommonObject{CustomerCompanyObject} = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    $CommonObject{CustomerUserObject}    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    $CommonObject{EncodeObject}          = $Kernel::OM->Get('Kernel::System::Encode');
    $CommonObject{GroupObject}           = $Kernel::OM->Get('Kernel::System::Group');
    $CommonObject{LinkObject}            = $Kernel::OM->Get('Kernel::System::LinkObject');
    $CommonObject{LogObject}             = $Kernel::OM->Get('Kernel::System::Log');
    $CommonObject{PIDObject}             = $Kernel::OM->Get('Kernel::System::PID');
    $CommonObject{QueueObject}           = $Kernel::OM->Get('Kernel::System::Queue');
    $CommonObject{SessionObject}         = $Kernel::OM->Get('Kernel::System::AuthSession');
    $CommonObject{TicketObject}          = $Kernel::OM->Get('Kernel::System::Ticket');
    $CommonObject{TimeObject}            = $Kernel::OM->Get('Kernel::System::Time');
    $CommonObject{UserObject}            = $Kernel::OM->Get('Kernel::System::User');

    my $RequiredUser     = $CommonObject{ConfigObject}->Get('SOAP::User');
    my $RequiredPassword = $CommonObject{ConfigObject}->Get('SOAP::Password');

    if (
        !defined $RequiredUser
        || !length $RequiredUser
        || !defined $RequiredPassword || !length $RequiredPassword
        )
    {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
        );
        return;
    }

    if ( $User ne $RequiredUser || $Pw ne $RequiredPassword ) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "Auth for user $User (pw $Pw) failed!",
        );
        return;
    }

    if ( !$CommonObject{$Object} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "No such Object $Object!",
        );
        return "No such Object $Object!";
    }

    my $TicketID;
    my $Counter;

    for my $MethodParamEntry ( @{$MethodParamArrayRef} ) {

        my $Method    = $MethodParamEntry->{Method};
        my %Parameter = %{ $MethodParamEntry->{Parameter} };

        # push ticket id to params if there is no ticket id
        if ( !$Parameter{TicketID} && $TicketID ) {
            $Parameter{TicketID} = $TicketID;
        }

        my $ReturnValue = $CommonObject{$Object}->$Method(%Parameter);

        # remember ticket id if method was TicketCreate
        if ( !$Counter && $Object eq 'TicketObject' && $Method eq 'TicketCreate' ) {
            $TicketID = $ReturnValue;
        }

        $Counter++;
    }

    return $TicketID;
}

1;
