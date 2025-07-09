# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::OpenIDConnect::TokenStoreUpdater;
use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::DateTime',
    'Kernel::System::OpenIDConnect::TokenProvider',
    'Kernel::System::OpenIDConnect::TokenRepository',
    'Kernel::System::OpenIDConnect::FunctionalAccountRepository',

);

=head1 NAME

Kernel::System::OpenIDConnect::TokenStoreUpdater - refresh OAuth Tokens via cron scheduler

=head1 DESCRIPTION

Refreshes OAuth Tokens via cron scheduler

=head1 PUBLIC INTERFACE

=head2 new()

create a TokenSToreUpdater object. Do not use it directly, instead use:

     my $TokenStoreUpdaterObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenStoreUpdater');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {

    my ( $Self, %Param ) = @_;

    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LogDir       = $ConfigObject->Get('Home') . '/var/log/';

    my $Log = "TokenStorageUpdater has been called with:\n";

    $Log .= $MainObject->Dump( \%Param );

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );

    my $Success = $DateTimeObject->ToTimeZone(
        TimeZone => 'UTC'
    );

    my $Time = $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S' );

    $Log .= "at $Time.\n";

    my $Tokens;
    eval {

        $Tokens = $Self->RenewTokens(%Param);
    };
    if ($@) {

        $Log .= $MainObject->Dump($@);
    }

    if ($Tokens) {
        $Log .= $MainObject->Dump($Tokens);
    }

    my $FileLocation = $MainObject->FileWrite(
        Directory => $LogDir,
        Filename  => 'tokenupdater.log',
        Content   => \$Log,
    );

    return 1;
}

# helper

sub RenewTokens {

    my ( $Self, %Param ) = @_;

    my $Interval = $Param{Interval};

    my $TokenProvider               = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenProvider');
    my $TokenRepository             = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');
    my $FunctionalAccountRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccountRepository');

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );

    my $Success = $DateTimeObject->ToTimeZone(
        TimeZone => 'UTC'
    );

    my $Epoch = $DateTimeObject->ToEpoch() + $Interval;

    my $Tokens = $TokenRepository->GetList(
        ExpiresAfter => $Epoch
    );

    TOKEN:
    for my $Token (@$Tokens) {

        my $Account = $FunctionalAccountRepository->GetByID( AccountID => $Token->{AccountID} );

        my $Result = $TokenProvider->FetchToken(

            AccountName  => $Account->{Name},
            RefreshToken => $Token->{Token},
        );

        $Token->{Result} = {
            Success => $Result->{Success},
            Error   => $Result->{Error},
        };
    }

    return $Tokens;
}

1;
