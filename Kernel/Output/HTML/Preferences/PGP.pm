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

package Kernel::Output::HTML::Preferences::PGP;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::PGP',
    'Kernel::System::Web::Request',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw( UserID UserObject ConfigItem )) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    return if !$Kernel::OM->Get('Kernel::Config')->Get('PGP');

    my @Params = ();
    push(
        @Params,
        {
            %Param,
            Name     => $Self->{ConfigItem}->{PrefKey},
            Block    => 'Upload',
            Filename => $Param{UserData}->{PGPFilename},
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %UploadStuff = $Kernel::OM->Get('Kernel::System::Web::Request')->GetUploadAll(
        Param => 'UserPGPKey',
    );

    return 1 unless $UploadStuff{Content};

    my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

    return 1 unless $PGPObject;

    my $Message = $PGPObject->KeyAdd( Key => $UploadStuff{Content} );
    if ( !$Message ) {
        $Self->{Error} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'Error',
            What => 'Message',
        );

        return;
    }

    my ( $PGPKeyID, $Filename );
    if ( ($PGPKeyID) = $Message =~ m/gpg: key (.*):/ ) {
        my ($Result) = $PGPObject->PublicKeySearch( Search => $PGPKeyID );
        if ($Result) {
            $Filename = "$Result->{Identifier}-$Result->{Bit}-$Result->{Key}.$Result->{Type}";
        }
    }

    $Self->{UserObject}->SetPreferences(
        UserID => $Param{UserData}->{UserID},
        Key    => 'PGPKeyID',                   # new parameter PGPKeyID
        Value  => $PGPKeyID,                    # write KeyID on a per user base, might be undefined
    );
    $Self->{UserObject}->SetPreferences(
        UserID => $Param{UserData}->{UserID},
        Key    => 'PGPFilename',
        Value  => $Filename,                    # might be undefined
    );

    #        $Self->{UserObject}->SetPreferences(
    #            UserID => $Param{UserData}->{UserID},
    #            Key => 'UserPGPKey',
    #            Value => $UploadStuff{Content},
    #        );
    #        $Self->{UserObject}->SetPreferences(
    #            UserID => $Param{UserData}->{UserID},
    #            Key => "PGPContentType",
    #            Value => $UploadStuff{ContentType},
    #        );
    $Self->{Message} = $Message;

    return 1;
}

sub Download {
    my ( $Self, %Param ) = @_;

    my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');
    return 1 if !$PGPObject;

    # get preferences with key parameters
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Param{UserData}->{UserID},
    );

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check if PGPKeyID is there
    if ( !$Preferences{PGPKeyID} ) {
        $LogObject->Log(
            Priority => 'Error',
            Message  => 'Need KeyID to get pgp public key of ' . $Param{UserData}->{UserID},
        );
        return ();
    }
    else {
        $Preferences{PGPKeyContent} = $PGPObject->PublicKeyGet(
            Key => $Preferences{PGPKeyID},
        );
    }

    # return content of key
    if ( !$Preferences{PGPKeyContent} ) {
        $LogObject->Log(
            Priority => 'Error',
            Message  => 'Couldn\'t get ASCII exported pubKey for KeyID ' . $Preferences{'PGPKeyID'},
        );
        return;
    }
    else {
        return (
            ContentType => 'text/plain',
            Content     => $Preferences{PGPKeyContent},
            Filename    => $Preferences{PGPFilename} || $Preferences{PGPKeyID} . '_pgp.asc',
        );
    }
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
