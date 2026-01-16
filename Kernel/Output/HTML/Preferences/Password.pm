# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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

package Kernel::Output::HTML::Preferences::Password;

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules
use Math::Random::Secure qw(irand);

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {%Param}, $Type;

    for my $Needed (qw(UserID UserObject ConfigItem)) {
        die "Got no $Needed!" unless $Self->{$Needed};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # check if we need to show password change option

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'AuthModule'
        : 'Customer::AuthModule';

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get auth module
    my $Module      = $ConfigObject->Get($AuthModule);
    my $AuthBackend = $Param{UserData}->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $ConfigObject->Get( $AuthModule . $AuthBackend );
    }

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;

    my @Params = (
        {
            %Param,
            Key   => Translatable('Current password'),
            Name  => 'CurPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => Translatable('New password'),
            Name  => 'NewPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => Translatable('Verify password'),
            Name  => 'NewPw1',
            Raw   => 1,
            Block => 'Password'
        },
    );

    # set the TwoFactorModue setting name depending on the interface
    my $AuthTwoFactorModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'AuthTwoFactorModule'
        : 'Customer::AuthTwoFactorModule';

    # show 2 factor password input if we have at least one backend enabled
    COUNT:
    for my $Count ( '', 1 .. 10 ) {
        next COUNT if !$ConfigObject->Get( $AuthTwoFactorModule . $Count );

        push @Params, {
            %Param,
            Key   => '2 Factor Token',
            Name  => 'TwoFactorToken',
            Raw   => 1,
            Block => 'Password',
        };

        last COUNT;
    }

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # pref update db
    return 1 if $ConfigObject->Get('DemoSystem');

    # get password from form
    my $CurPw;
    if ( $Param{GetParam}->{CurPw} && $Param{GetParam}->{CurPw}->[0] ) {
        $CurPw = $Param{GetParam}->{CurPw}->[0];
    }
    my $Pw;
    if ( $Param{GetParam}->{NewPw} && $Param{GetParam}->{NewPw}->[0] ) {
        $Pw = $Param{GetParam}->{NewPw}->[0];
    }
    my $Pw1;
    if ( $Param{GetParam}->{NewPw1} && $Param{GetParam}->{NewPw1}->[0] ) {
        $Pw1 = $Param{GetParam}->{NewPw1}->[0];
    }

    # get the two factor token from form
    my $TwoFactorToken;
    if ( $Param{GetParam}->{TwoFactorToken} && $Param{GetParam}->{TwoFactorToken}->[0] ) {
        $TwoFactorToken = $Param{GetParam}->{TwoFactorToken}->[0];
    }

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'Auth'
        : 'CustomerAuth';

    my $AuthObject = $Kernel::OM->Get( 'Kernel::System::' . $AuthModule );

    return 1 unless $AuthObject;

    my $Login = $Param{UserData}->{UserLogin};

    # validate current password
    if (
        !$AuthObject->Auth(
            User           => $Login,
            Pw             => $CurPw,
            TwoFactorToken => $TwoFactorToken || '',
        )
        )
    {
        $Self->{Error} = $LanguageObject->Translate('The current password is not correct. Please try again!');
        return;
    }

    # check if pw is true
    if ( !$Pw || !$Pw1 ) {
        $Self->{Error} = $LanguageObject->Translate('Please supply your new password!');
        return;
    }

    # compare pws
    if ( $Pw ne $Pw1 ) {
        $Self->{Error} = $LanguageObject->Translate(
            'Can\'t update password, the new password and the repeated password do not match.'
        );
        return;
    }

    # check pw
    my $Config = $Self->{ConfigItem};

    # check if password is not matching PasswordRegExp
    if ( $Config->{PasswordRegExp} && $Pw !~ /$Config->{PasswordRegExp}/ ) {
        $Self->{Error} = $LanguageObject->Translate(
            'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.'
        );
        return;
    }

    # check min size of password
    if ( $Config->{PasswordMinSize} && length $Pw < $Config->{PasswordMinSize} ) {
        $Self->{Error} = $LanguageObject->Translate(
            'Can\'t update password, it must be at least %s characters long!',
            $Config->{PasswordMinSize}
        );
        return;
    }

    # check min 2 lower and 2 upper char
    if (
        $Config->{PasswordMin2Lower2UpperCharacters}
        && ( $Pw !~ /[A-Z].*[A-Z]/ || $Pw !~ /[a-z].*[a-z]/ )
        )
    {
        $Self->{Error} = $LanguageObject->Translate(
            'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!'
        );
        return;
    }

    # check min 1 digit password
    if ( $Config->{PasswordNeedDigit} && $Pw !~ /\d/ ) {
        $Self->{Error} = $LanguageObject->Translate('Can\'t update password, it must contain at least 1 digit!');
        return;
    }

    # check min 2 char password
    if ( $Config->{PasswordMin2Characters} && $Pw !~ /\w.*\w/ ) {
        $Self->{Error} = $LanguageObject->Translate('Can\'t update password, it must contain at least 2 letter characters!');
        return;
    }

    # check min 3 of lower case, upper case, numbers, special characters
    if ( $Config->{PasswordMin3of4} ) {
        my $PwCount = 0;
        if ( $Pw =~ /\d/ ) {
            $PwCount++;
        }
        if ( $Pw =~ /[A-Z]/ ) {
            $PwCount++;
        }
        if ( $Pw =~ /[a-z]/ ) {
            $PwCount++;
        }
        if ( $Pw =~ /\W/ ) {
            $PwCount++;
        }
        if ( $PwCount < 3 ) {
            $Self->{Error} = $LanguageObject->Translate(
                'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!'
            );
            return;
        }
    }

    # The password history is optional
    my $HistoryCount   = $Self->{ConfigItem}->{PasswordHistory};     # actual history is one more
    my $HistoryEnabled = $HistoryCount ? 1 : 0;
    my $MainObject     = $Kernel::OM->Get('Kernel::System::Main');
    if ($HistoryEnabled) {

        # password history is only maintained with bcrypt
        if ( !$MainObject->Require('Crypt::Eksblowfish::Bcrypt') ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'warning',
                Message  => "Password is not recorded in password history because 'Crypt::Eksblowfish::Bcrypt' is not installed!",
            );

            $HistoryEnabled = 0;
        }
    }

    my @HistoricCryptedPws;
    if ($HistoryEnabled) {

        # md5 sum for new pw, needed for password history check, computed lazily
        my $MD5Pw;

        # remove UTF8 flag, required by Crypt::Eksblowfish::Bcrypt
        my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');
        $EncodeObject->EncodeOutput( \$Pw );

        HISTORY:
        for my $Count ( '', 1 .. $HistoryCount ) {
            my $HistoryKey   = 'UserLastPw' . $Count;
            my $OldCryptedPw = $Param{UserData}->{$HistoryKey};

            next HISTORY unless $OldCryptedPw;

            # remember history
            push @HistoricCryptedPws, $OldCryptedPw;

            # for checking ww also support the old md5 hash
            if ( $OldCryptedPw =~ m/^\$2[axyb]?\$/ ) {

                # Calculate password hash, prepended by the settings
                # Using the old crytped password ensures that the same
                # cost and the same salt is used.
                my $CryptedPw = Crypt::Eksblowfish::Bcrypt::bcrypt( $Pw, $OldCryptedPw );

                next HISTORY unless $CryptedPw eq $OldCryptedPw;

                # if already used, complain about
                $Self->{Error} = "Can\'t update password, this password has already been used. Please choose a new one!";

                return;
            }
            else {
                $MD5Pw //= $MainObject->MD5sum( String => $Pw );    # lazily compute MD5sum in first interation

                # password not used yet
                next HISTORY unless $MD5Pw eq $OldCryptedPw;

                # if already used, complain about
                $Self->{Error} = "Can't update password, this password has already been used. Please choose a new one!";

                return;
            }
        }
    }

    # set new password
    my $Success = $Self->{UserObject}->SetPassword(
        UserLogin => $Login,
        PW        => $Pw,
    );

    return unless $Success;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTime     = $DateTimeObject->ToEpoch();

    # set password change time
    $Self->{UserObject}->SetPreferences(
        UserID => $Param{UserData}->{UserID},
        Key    => 'UserLastPwChangeTime',
        Value  => $SystemTime,
    );
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserLastPwChangeTime',
        Value     => $SystemTime,
    );

    if ($HistoryEnabled) {

        # only bcrypt is supported
        my $AlgoIdentifier = '2a';    # indicate bcrypt, Modular CryptFormat

        # take the cost from the agent config
        my $Cost = $ConfigObject->Get("AuthModule::DB::bcryptCost") // 12;

        # Don't allow values smaller than 9 for security.
        $Cost = 9 if $Cost < 9;

        # Current Crypt::Eksblowfish::Bcrypt limit is 31.
        $Cost = 31 if $Cost > 31;

        # Bcrypt uses non-standard Base64 alphabet for it's salt
        # The randomness comes from 16*8=128=2^6 random bits, these bits
        # can be packed into 22 Base64 characters. 128/6 = 21.33...
        my $RandomBytes = join '',
            map {chr}
            map { irand(256) }
            ( 1 .. 16 );
        my $Salt = Crypt::Eksblowfish::Bcrypt::en_base64($RandomBytes);

        # Calculate password hash, prepended by the settings
        my $Settings  = join '$', '', $AlgoIdentifier, $Cost, $Salt;
        my $CryptedPw = Crypt::Eksblowfish::Bcrypt::bcrypt( $Pw, $Settings );

        # add hash of the new password to password history
        unshift @HistoricCryptedPws, $CryptedPw;

        # add the historical password hashes
        HISTORY:
        for my $Count ( '', 1 .. $HistoryCount ) {
            my $HistoryKey   = 'UserLastPw' . $Count;
            my $HistoryValue = shift @HistoricCryptedPws;    # when history is full, then the last obsolete entry is not shifted out
            $Self->{UserObject}->SetPreferences(
                UserID => $Param{UserData}->{UserID},
                Key    => $HistoryKey,
                Value  => $HistoryValue,                     # undefined or empty is fine
            );
        }
    }

    $Self->{Message} = $LanguageObject->Translate('Preferences updated successfully!');

    return 1;
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
