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

package Kernel::System::Console::Command::Maint::Cache::Delete;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Cache',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete cache files created by OTOBO.');
    $Self->AddOption(
        Name        => 'expired',
        Description => 'Delete only caches which are expired by TTL.',
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'type',
        Description => 'Define the type of cache which should be deleted (e.g. Ticket or StdAttachment).',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'keeptype',
        Description => 'Define the type of cache which should be NOT deleted (e.g. Ticket or StdAttachment).',
        Required    => 0,
        Multiple    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # collect options for the method CleanUp of the cache object
    my %CleanUpOptions;
    $CleanUpOptions{Expired} = $Self->GetOption('expired');
    $CleanUpOptions{Type}    = $Self->GetOption('type');

    # Set option KeepTypes for the CleanUp() method.
    # When no --keeptype option is passed then a reference to an empty array is set and
    # this indicates that all types are deleted.
    {
        my @KeepTypes;
        for my $KeepType ( @{ $Self->GetOption('keeptype') // [] } ) {
            push @KeepTypes, $KeepType;
        }
        $CleanUpOptions{KeepTypes} = \@KeepTypes;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $Self->Print("<yellow>Deleting cache...</yellow>\n");
    if ( !$CacheObject->CleanUp(%CleanUpOptions) ) {
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
