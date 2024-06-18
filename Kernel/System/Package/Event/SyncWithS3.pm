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

package Kernel::System::Package::Event::SyncWithS3;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Mojo::JSON qw(encode_json);

# OTOBO modules
use Kernel::System::Storage::S3 ();

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }

    # submitting JSON to S3
    # TODO: get a more sensible content
    my $JSONContent     = encode_json( \%Param );
    my $StorageS3Object = Kernel::System::Storage::S3->new();
    my $EventFileName   = 'event_package.json';
    my $EventFilePath   = join '/', 'Kernel', 'Config', 'Files', $EventFileName;

    # write to S3,
    # give up when the JSON could not be stored
    return unless $StorageS3Object->StoreObject(
        Key     => $EventFilePath,
        Headers => { 'Content-Type' => 'application/json' },
        Content => $JSONContent,
    );

    # extra copy in the file system with the same timestamp as in S3
    my $TargetLocation = "/opt/otobo/Kernel/Config/Files/$EventFileName";

    return $StorageS3Object->SaveObjectToFile(
        Key      => $EventFilePath,
        Location => $TargetLocation,
    );
}

1;
