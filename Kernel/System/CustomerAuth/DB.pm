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

package Kernel::System::CustomerAuth::DB;

use v5.24;
use strict;
use warnings;

# core modules
use Digest::SHA;

# CPAN modules
use Crypt::PasswdMD5 qw(unix_md5_crypt apache_md5_crypt);

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # get database object
    $Self->{DBObject} = $Kernel::OM->Get('Kernel::System::DB');

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # config options
    $Self->{Table} = $ConfigObject->Get( 'Customer::AuthModule::DB::Table' . $Param{Count} )
        || die "Need CustomerAuthModule::DB::Table$Param{Count} in Kernel/Config.pm!";
    $Self->{Key} = $ConfigObject->Get( 'Customer::AuthModule::DB::CustomerKey' . $Param{Count} )
        || die "Need CustomerAuthModule::DB::CustomerKey$Param{Count} in Kernel/Config.pm!";
    $Self->{Pw} = $ConfigObject->Get( 'Customer::AuthModule::DB::CustomerPassword' . $Param{Count} )
        || die "Need CustomerAuthModule::DB::CustomerPw$Param{Count} in Kernel/Config.pm!";
    $Self->{CryptType} = $ConfigObject->Get( 'Customer::AuthModule::DB::CryptType' . $Param{Count} )
        || '';

    if ( $ConfigObject->Get( 'Customer::AuthModule::DB::DSN' . $Param{Count} ) ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            DatabaseDSN =>
                $ConfigObject->Get( 'Customer::AuthModule::DB::DSN' . $Param{Count} ),
            DatabaseUser =>
                $ConfigObject->Get( 'Customer::AuthModule::DB::User' . $Param{Count} ),
            DatabasePw =>
                $ConfigObject->Get( 'Customer::AuthModule::DB::Password' . $Param{Count} ),
            Type => $ConfigObject->Get( 'Customer::AuthModule::DB::Type' . $Param{Count} )
                || '',
            )
            || die "Can't connect to "
            . $ConfigObject->Get( 'Customer::AuthModule::DB::DSN' . $Param{Count} );

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

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
    my $User       = $Param{User}      || '';
    my $Pw         = $Param{Pw}        || '';
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    my $UserID     = '';
    my $GetPw      = '';
    my $Method     = '';

    # sql query
    $Self->{DBObject}->Prepare(
        SQL => "
            SELECT $Self->{Pw}, $Self->{Key} FROM $Self->{Table} WHERE
            $Self->{Key} = ?
            ",
        Bind => [ \$Param{User} ],
    );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $GetPw  = $Row[0] || '';
        $UserID = $Row[1];
    }

    # check if user exists in auth table
    if ( !$UserID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: No auth record in '$Self->{Table}' for '$User' "
                . "(REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # crypt given pw
    my $CryptedPw = '';
    my $Salt      = $GetPw;

    if ( $Self->{CryptType} eq 'plain' ) {
        $CryptedPw = $Pw;
        $Method    = 'plain';
    }

    # md5 or sha pw
    elsif ( $GetPw !~ /^.{13}$/ ) {

        # md5 pw
        if ( $GetPw =~ m{\A \$.+? \$.+? \$.* \z}xms ) {

            # strip Salt
            $Salt =~ s/^(\$.+?\$)(.+?)\$.*$/$2/;
            my $Magic = $1;

            # encode output, needed by unix_md5_crypt() only non utf8 signs
            $EncodeObject->EncodeOutput( \$Pw );
            $EncodeObject->EncodeOutput( \$Salt );

            if ( $Magic eq '$apr1$' ) {
                $CryptedPw = apache_md5_crypt( $Pw, $Salt );
                $Method    = 'apache_md5_crypt';
            }
            else {
                $CryptedPw = unix_md5_crypt( $Pw, $Salt );
                $Method    = 'unix_md5_crypt';
            }
            $EncodeObject->EncodeInput( \$CryptedPw );
        }

        # sha256 pw
        elsif ( $GetPw =~ m{\A [0-9a-f]{64} \z}xmsi ) {

            my $SHAObject = Digest::SHA->new('sha256');
            $EncodeObject->EncodeOutput( \$Pw );
            $SHAObject->add($Pw);
            $CryptedPw = $SHAObject->hexdigest();
            $EncodeObject->EncodeInput( \$CryptedPw );
            $Method = 'sha256';
        }

        # sha512 pw
        elsif ( $GetPw =~ m{\A [0-9a-f]{128} \z}xmsi ) {

            my $SHAObject = Digest::SHA->new('sha512');
            $EncodeObject->EncodeOutput( \$Pw );
            $SHAObject->add($Pw);
            $CryptedPw = $SHAObject->hexdigest();
            $EncodeObject->EncodeInput( \$CryptedPw );
            $Method = 'sha512';
        }

        elsif ( $GetPw =~ m{^BCRYPT:} ) {

            # require module, log errors if module was not found
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require('Crypt::Eksblowfish::Bcrypt') )
            {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "CustomerUser: $User tried to authenticate with bcrypt but 'Crypt::Eksblowfish::Bcrypt' is not installed!",
                );
                return;
            }

            # get salt and cost from stored PW string
            my ( $Cost, $Salt, $Base64Hash ) = $GetPw =~ m{^BCRYPT:(\d+):(.{16}):(.*)$}xms;

            # remove UTF8 flag, required by Crypt::Eksblowfish::Bcrypt
            $EncodeObject->EncodeOutput( \$Pw );

            # calculate password hash with the same cost and hash settings
            my $Octets = Crypt::Eksblowfish::Bcrypt::bcrypt_hash(
                {
                    key_nul => 1,
                    cost    => $Cost,
                    salt    => $Salt,
                },
                $Pw
            );

            $CryptedPw = "BCRYPT:$Cost:$Salt:" . Crypt::Eksblowfish::Bcrypt::en_base64($Octets);
            $Method    = 'bcrypt';
        }

        # sha1 pw
        elsif ( $GetPw =~ m{\A [0-9a-f]{40} \z}xmsi ) {

            my $SHAObject = Digest::SHA->new('sha1');

            # encode output, needed by sha1_hex() only non utf8 signs
            $EncodeObject->EncodeOutput( \$Pw );

            $SHAObject->add($Pw);
            $CryptedPw = $SHAObject->hexdigest();
            $EncodeObject->EncodeInput( \$CryptedPw );
            $Method = 'sha1';
        }

        # No-13-chars-long crypt pw (e.g. in Fedora28).
        else {
            my $SaltUser = $User;
            $EncodeObject->EncodeOutput( \$Pw );
            $EncodeObject->EncodeOutput( \$SaltUser );

            # Encode output, needed by crypt() only non utf8 signs.
            $CryptedPw = crypt( $Pw, $SaltUser );
            $EncodeObject->EncodeInput( \$CryptedPw );
            $Method = 'crypt';
        }
    }

    # crypt pw
    else {

        # strip salt only for (Extended) DES, not for any of modular crypt's
        if ( $Salt !~ /^\$\d\$/ ) {
            $Salt =~ s/^(..).*/$1/;
        }

        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Salt );

        # encode output, needed by crypt() only non utf8 signs
        $CryptedPw = crypt( $Pw, $Salt );
        $EncodeObject->EncodeInput( \$CryptedPw );
        $Method = 'crypt';
    }

    # just in case!
    if ( $Self->{Debug} > 0 ) {
        my $EnteredPw  = $CryptedPw;
        my $ExpectedPw = $GetPw;

        # Don't log plaintext passwords.
        if ( $Self->{CryptType} eq 'plain' ) {
            $EnteredPw  = 'xxx';
            $ExpectedPw = 'xxx';
        }

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "CustomerUser: $User tried to authenticate (User ID: $UserID, method: $Method, entered password: $EnteredPw, expected password: $ExpectedPw, salt: $Salt, remote address: $RemoteAddr)",
        );
    }

    # just a note
    if ( !$Pw ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "CustomerUser: $User authentication without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # login note
    elsif ( ( $GetPw && $User && $UserID ) && $CryptedPw eq $GetPw ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $User Authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }

    # just a note
    elsif ( $UserID && $GetPw ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "CustomerUser: $User Authentication with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }

    # just a note
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "CustomerUser: $User doesn't exist or is invalid!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }
}

sub DESTROY {
    my $Self = shift;

    # disconnect if it's not a parent DBObject
    if ( $Self->{NotParentDBObject} ) {
        if ( $Self->{DBObject} ) {
            $Self->{DBObject}->Disconnect();
        }
    }
    return 1;
}

1;
