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

package Kernel::System::Auth::DB;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;

# core modules
use Digest::SHA ();

# CPAN modules

# OTOBO modules
use Crypt::PasswdMD5 qw(apache_md5_crypt unix_md5_crypt);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
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

    # get user table
    $Self->{UserTable} = $ConfigObject->Get( 'DatabaseUserTable' . $Param{Count} )
        || 'users';
    $Self->{UserTableUserID} = $ConfigObject->Get( 'DatabaseUserTableUserID' . $Param{Count} )
        || 'id';
    $Self->{UserTableUserPW} = $ConfigObject->Get( 'DatabaseUserTableUserPW' . $Param{Count} )
        || 'pw';
    $Self->{UserTableUser} = $ConfigObject->Get( 'DatabaseUserTableUser' . $Param{Count} )
        || 'login';

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
    my $Method      = '';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    my $SQL = "SELECT $Self->{UserTableUserPW}, $Self->{UserTableUserID}, $Self->{UserTableUser} "
        . " FROM "
        . " $Self->{UserTable} "
        . " WHERE "
        . " valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} ) AND "
        . " $Self->{UserTableUser} = '" . $DBObject->Quote($User) . "'";
    $DBObject->Prepare( SQL => $SQL );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $GetPw  = $Row[0];
        $UserID = $Row[1];
        $User   = $Row[2];
    }

    # get needed objects
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # crypt given pw
    my $CryptedPw = '';
    my $Salt      = $GetPw;
    if (
        $ConfigObject->Get('AuthModule::DB::CryptType')
        && $ConfigObject->Get('AuthModule::DB::CryptType') eq 'plain'
        )
    {
        $CryptedPw = $Pw;
        $Method    = 'plain';
    }

    # md5, bcrypt or sha pw
    elsif ( $GetPw !~ /^.{13}$/ ) {

        # md5 pw
        if ( $GetPw =~ m{\A \$.+? \$.+? \$.* \z}xms ) {

            # strip Salt
            my $Magic = '';
            if ( $Salt =~ s/^(\$.+?\$)(.+?)\$.*$/$2/ ) {
                $Magic = $1;    # a successful substitution means a successful match
            }

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

        }

        # sha256 pw
        elsif ( $GetPw =~ m{\A [0-9a-f]{64} \z}xmsi ) {

            my $SHAObject = Digest::SHA->new('sha256');
            $EncodeObject->EncodeOutput( \$Pw );
            $SHAObject->add($Pw);
            $CryptedPw = $SHAObject->hexdigest();
            $Method    = 'sha256';
        }

        # sha512 pw
        elsif ( $GetPw =~ m{\A [0-9a-f]{128} \z}xmsi ) {

            my $SHAObject = Digest::SHA->new('sha512');
            $EncodeObject->EncodeOutput( \$Pw );
            $SHAObject->add($Pw);
            $CryptedPw = $SHAObject->hexdigest();
            $Method    = 'sha512';
        }

        elsif ( $GetPw =~ m{^BCRYPT:} ) {

            # require module, log errors if module was not found
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require('Crypt::Eksblowfish::Bcrypt') )
            {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "User: $User tried to authenticate with bcrypt but 'Crypt::Eksblowfish::Bcrypt' is not installed!",
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
            $Method    = 'sha1';
        }

        # No-13-chars-long crypt pw (e.g. in Fedora28).
        else {
            $EncodeObject->EncodeOutput( \$Pw );
            $EncodeObject->EncodeOutput( \$User );

            # Encode output, needed by crypt() only non utf8 signs.
            $CryptedPw = crypt( $Pw, $User );
            $EncodeObject->EncodeInput( \$CryptedPw );
            $Method = 'crypt';
        }
    }

    # crypt pw
    else {

        # strip Salt only for (Extended) DES, not for any of Modular crypt's
        if ( $Salt !~ /^\$\d\$/ ) {
            $Salt =~ s/^(..).*/$1/;
        }

        # encode output, needed by crypt() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Salt );
        $CryptedPw = crypt( $Pw, $Salt );
        $Method    = 'crypt';
    }

    # Debugging can only be activated in the source code,
    # so that sensitive information is not inadvertently leaked.
    my $Debug = 0;
    if ($Debug) {
        my $EnteredPw  = $CryptedPw;
        my $ExpectedPw = $GetPw;

        # Don't log plaintext passwords.
        if ( $Method eq 'plain' ) {
            $EnteredPw  = 'xxx';
            $ExpectedPw = 'xxx';
        }

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "User: $User tried to authenticate (User ID: $UserID, method: $Method, entered password: $EnteredPw, expected password: $ExpectedPw, salt: $Salt, remote address: $RemoteAddr)",
        );
    }

    # just a note
    if ( !$Pw ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "User: $User without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );

        return;
    }

    # login note
    elsif ( ( ($GetPw) && ($User) && ($UserID) ) && $CryptedPw eq $GetPw ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "User: $User authentication ok (Method: $Method, REMOTE_ADDR: $RemoteAddr).",
        );

        return $User;
    }

    # just a note
    elsif ( ($UserID) && ($GetPw) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "User: $User authentication with wrong Pw!!! (Method: $Method, REMOTE_ADDR: $RemoteAddr)"
        );

        return;
    }

    # just a note
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "User: $User doesn't exist or is invalid!!! (REMOTE_ADDR: $RemoteAddr)"
        );

        return;
    }
}

1;
