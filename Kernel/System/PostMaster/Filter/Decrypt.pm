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

package Kernel::System::PostMaster::Filter::Decrypt;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::EmailParser ();
use Kernel::Language            qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Crypt::PGP',
    'Kernel::System::Crypt::SMIME',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Get parser object.
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # get communication log object and MessageID
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(JobConfig GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::Decrypt',
                Value         => "Need $Needed!",
            );
            return;
        }
    }

    # Try to get message & encryption method.
    my $Message;
    my $ContentType;
    my $EncryptionMethod = '';

    if ( $Param{GetParam}->{Body} =~ /\A[\s\n]*^-----BEGIN PGP MESSAGE-----/m ) {
        $Message          = $Param{GetParam}->{Body};
        $ContentType      = $Param{GetParam}->{'Content-Type'} || '';
        $EncryptionMethod = 'PGP';
    }
    elsif ( $Param{GetParam}->{'Content-Type'} =~ /application\/(x-pkcs7|pkcs7)/i ) {
        $EncryptionMethod = 'SMIME';
        $ContentType      = $Param{GetParam}->{'Content-Type'} || '';
    }
    else {
        CONTENT:
        for my $Content ( @{ $Param{GetParam}->{Attachment} } ) {
            if ( $Content->{Content} =~ /\A[\s\n]*^-----BEGIN PGP MESSAGE-----/m ) {
                $Message          = $Content->{Content};
                $ContentType      = $Content->{ContentType} || '';
                $EncryptionMethod = 'PGP';
                last CONTENT;
            }
            elsif ( $Content->{Content} =~ /^-----BEGIN PKCS7-----/ ) {
                $Message          = $Content->{Content};
                $ContentType      = $Param{GetParam}->{'Content-Type'} || '';
                $EncryptionMethod = 'SMIME';
                last CONTENT;
            }
        }
    }

    if ( $EncryptionMethod eq 'PGP' ) {

        # Try to decrypt body with PGP.
        $Param{GetParam}->{'X-OTOBO-BodyDecrypted'} = $Self->_DecryptPGP(
            Body        => $Message,
            ContentType => $ContentType,
            %Param
        ) || '';

        # Return PGP decrypted content if encryption is PGP.
        return $Param{GetParam}->{'X-OTOBO-BodyDecrypted'} if $Param{GetParam}->{'X-OTOBO-BodyDecrypted'};
    }
    elsif ( $EncryptionMethod eq 'SMIME' ) {

        # Try to decrypt body with SMIME.
        $Param{GetParam}->{'X-OTOBO-BodyDecrypted'} = $Self->_DecryptSMIME(
            Body        => $Self->{ParserObject}->{Email}->as_string(),
            ContentType => $ContentType,
            %Param
        ) || '';

        # Return SMIME decrypted content if encryption is SMIME
        return $Param{GetParam}->{'X-OTOBO-BodyDecrypted'} if $Param{GetParam}->{'X-OTOBO-BodyDecrypted'};
    }
    else {
        $Param{GetParam}->{'X-OTOBO-BodyDecrypted'} = '';
    }

    return 1;
}

sub _DecryptPGP {
    my ( $Self, %Param ) = @_;

    my $DecryptBody = $Param{Body}        || '';
    my $ContentType = $Param{ContentType} || '';

    # Check if PGP is active
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( !$ConfigObject->Get('PGP') ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::Decrypt',
            Value         => "PGP is not activated",
        );
        return;
    }

    # Check for PGP encryption
    if (
        $DecryptBody !~ m{\A[\s\n]*^-----BEGIN PGP MESSAGE-----}i
        && $ContentType !~ m{application/pgp}i
        )
    {
        return;
    }

    # PGP crypt object
    my $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

    if ( !$CryptObject ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::Decrypt',
            Value         => "Not possible to create crypt object",
        );
        return;
    }

    # Try to decrypt.
    my %Decrypt = $CryptObject->Decrypt( Message => $DecryptBody );

    return if !$Decrypt{Successful};

    my $ParserObject = Kernel::System::EmailParser->new( %{$Self}, Email => $Decrypt{Data} );
    $DecryptBody = $ParserObject->GetMessageBody();

    if ( $Param{JobConfig}->{StoreDecryptedBody} ) {
        $Param{GetParam}->{Body} = $DecryptBody;
    }

    # Return content if successful
    return $DecryptBody;
}

sub _DecryptSMIME {
    my ( $Self, %Param ) = @_;

    my $DecryptBody = $Param{Body}        || '';
    my $ContentType = $Param{ContentType} || '';

    # Check if SMIME is active
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( !$ConfigObject->Get('SMIME') ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::Decrypt',
            Value         => "SMIME is not activated",
        );
        return;
    }

    # Check for SMIME encryption
    if (
        $DecryptBody !~ m{^-----BEGIN PKCS7-----}i
        && $ContentType !~ m{application/(x-pkcs7|pkcs7)}i
        )
    {
        return;
    }

    # SMIME crypt object
    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    if ( !$SMIMEObject ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::Decrypt',
            Value         => "Not possible to create crypt object",
        );
        return;
    }

    my %SignCheck;

    if (
        $ContentType
        && $ContentType =~ /application\/(x-pkcs7|pkcs7)-mime/i
        && $ContentType !~ /signed/i
        )
    {

        # get all email addresses on article
        my %EmailsToSearch;
        for my $Email (qw(Resent-To Envelope-To To Cc Delivered-To X-Original-To)) {

            my @EmailAddressOnField = $Self->{ParserObject}->SplitAddressLine(
                Line => $Self->{ParserObject}->GetParam( WHAT => $Email ),
            );

            # filter email addresses avoiding repeated and save on hash to search
            for my $EmailAddress (@EmailAddressOnField) {
                my $CleanEmailAddress = $Self->{ParserObject}->GetEmailAddress(
                    Email => $EmailAddress,
                );
                $EmailsToSearch{$CleanEmailAddress} = '1';
            }
        }

        # look for private keys for every email address
        # extract every resulting cert and put it into an hash of hashes avoiding repeated
        my %PrivateKeys;
        for my $EmailAddress ( sort keys %EmailsToSearch ) {
            my @PrivateKeysResult = $SMIMEObject->PrivateSearch(
                Search => $EmailAddress,
            );
            for my $Cert (@PrivateKeysResult) {
                $PrivateKeys{ $Cert->{Filename} } = $Cert;
            }
        }

        # search private cert to decrypt email
        if ( !%PrivateKeys ) {
            $Param{GetParam}{Crypted} = 'Impossible to decrypt: private key not found!';
            return;
        }

        my %Decrypt;
        PRIVATESEARCH:
        for my $CertResult ( values %PrivateKeys ) {

            # decrypt
            %Decrypt = $SMIMEObject->Decrypt(
                Message            => $DecryptBody,
                SearchingNeededKey => 1,
                %{$CertResult},
            );
            last PRIVATESEARCH if ( $Decrypt{Successful} );
        }

        # ok, decryption went fine
        if ( $Decrypt{Successful} ) {
            my $Flag = $Decrypt{Message}
                ?
                ( length( $Decrypt{Message} ) > 50 ? substr( $Decrypt{Message}, 0, 50 ) : $Decrypt{Message} )
                : Translatable('Successful decryption');
            $Param{GetParam}{Crypted}   = $Flag;
            $Param{GetParam}{CryptedOK} = 1;

            # store decrypted data
            my $EmailContent = $Decrypt{Data};

            # now check if the data contains a signature too
            %SignCheck = $SMIMEObject->Verify(
                Message => $Decrypt{Data},
            );

            if ( !%SignCheck ) {
                $Param{GetParam}{Signed} = 'Internal error during verification!';
            }
            elsif ( $SignCheck{SignatureFound} && $SignCheck{Content} ) {
                $EmailContent = $SignCheck{Content};
            }

            # not signed at all
            elsif ( $SignCheck{Message} =~ /^OpenSSL: Error reading S\/MIME message/ ) {
                %SignCheck = ();
            }

            # parse the decrypted email body
            my $ParserObject = Kernel::System::EmailParser->new(
                Email => $EmailContent
            );

            # overwrite the old content
            $Param{GetParam}{Body}                  = $ParserObject->GetMessageBody();
            $Param{GetParam}{'Content-Type'}        = $ParserObject->GetReturnContentType();
            $Param{GetParam}{'Content-Disposition'} = $ParserObject->GetContentDisposition();
            $Param{GetParam}{Charset}               = $ParserObject->GetReturnCharset();
            $Self->{ParserObject}{MessageBody}      = $Param{GetParam}{Body};

            my @Attachments = $ParserObject->GetAttachments();
            if (@Attachments) {
                $Param{GetParam}{Attachment} = \@Attachments;
                $Self->{ParserObject}{Attachments} = \@Attachments;
            }
            $Self->{ParserObject}{MimeEmail} = ( $ParserObject->{ParserParts}->parts() > 0 ? 1 : 0 );
        }

        # unsuccessful decrypt
        else {
            $Param{GetParam}{Crypted} = 'Error while decrypting message!';
            return;
        }
    }

    elsif (
        $ContentType
        && $ContentType =~ /application\/(x-pkcs7|pkcs7)/i
        && $ContentType =~ /signed/i
        )
    {

        # check sign and get clear content
        %SignCheck = $SMIMEObject->Verify(
            Message => $DecryptBody,
        );

        if ( %SignCheck && $SignCheck{Content} ) {

            my @Email = ();
            my @Lines = split( /\n/, $SignCheck{Content} );
            for (@Lines) {
                push( @Email, $_ . "\n" );
            }
            my $ParserObject = Kernel::System::EmailParser->new(
                Email => \@Email,
            );

            # overwrite the old content
            $Param{GetParam}{Body}                  = $ParserObject->GetMessageBody();
            $Param{GetParam}{'Content-Type'}        = $ParserObject->GetReturnContentType();
            $Param{GetParam}{'Content-Disposition'} = $ParserObject->GetContentDisposition();
            $Param{GetParam}{Charset}               = $ParserObject->GetReturnCharset();
            $Self->{ParserObject}{MessageBody}      = $Param{GetParam}{Body};

            my @Attachments = $ParserObject->GetAttachments();
            if (@Attachments) {
                $Param{GetParam}{Attachment} = \@Attachments;
                $Self->{ParserObject}{Attachments} = \@Attachments;
            }
            $Self->{ParserObject}{MimeEmail} = ( $ParserObject->{ParserParts}->parts() > 0 ? 1 : 0 );

        }

        elsif ( !%SignCheck ) {
            $Param{GetParam}{Signed} = 'Internal error during verification!';
            return;
        }
    }

    elsif ( $DecryptBody =~ m{^-----BEGIN PKCS7-----}i ) {
        %SignCheck = $SMIMEObject->Verify( Message => $DecryptBody );
        if ( !%SignCheck ) {
            $Param{GetParam}{Signed} = 'Internal error during verification!';
            return;
        }
    }

    # evaluate verification output
    if (%SignCheck) {

        if ( $SignCheck{SignatureFound} && $SignCheck{Successful} ) {

            # from RFC 3850
            # 3.  Using Distinguished Names for Internet Mail
            #
            #   End-entity certificates MAY contain ...
            #
            #    ...
            #
            #   Sending agents SHOULD make the address in the From or Sender header
            #   in a mail message match an Internet mail address in the signer's
            #   certificate.  Receiving agents MUST check that the address in the
            #   From or Sender header of a mail message matches an Internet mail
            #   address, if present, in the signer's certificate, if mail addresses
            #   are present in the certificate.  A receiving agent SHOULD provide
            #   some explicit alternate processing of the message if this comparison
            #   fails, which may be to display a message that shows the recipient the
            #   addresses in the certificate or other certificate details.

            # as described in bug#5098 and RFC 3850 an alternate mail handling should be
            # made if sender and signer addresses does not match

            # get original sender from email
            my $OrigFrom   = $Self->{ParserObject}->GetParam( WHAT => 'From' );
            my $OrigSender = $Self->{ParserObject}->GetEmailAddress( Email => $OrigFrom );

            # compare sender email to signer email
            my $SignerSenderMatch = 0;
            SIGNER:
            for my $Signer ( @{ $SignCheck{Signers} } ) {
                if ( $OrigSender =~ m{\A \Q$Signer\E \z}xmsi ) {
                    $SignerSenderMatch = 1;
                    last SIGNER;
                }
            }

            # sender email does not match signing certificate!
            if ( !$SignerSenderMatch ) {
                $SignCheck{Successful} = 0;
                $SignCheck{Message} =~ s/successful/failed!/;
                $SignCheck{Message} .= " (signed by "
                    . join( ' | ', @{ $SignCheck{Signers} } )
                    . ")"
                    . ", but sender address $OrigSender: does not match certificate address!";

                my $Flag = $SignCheck{Message}
                    ?
                    ( length( $SignCheck{Message} ) > 50 ? substr( $SignCheck{Message}, 0, 30 ) . '... (see info)' : $SignCheck{Message} )
                    : 'Verification OK.';
                $Param{GetParam}{Signed} = $Flag;
                return;
            }
            else {
                my $Flag = $SignCheck{Message}
                    ?
                    ( length( $SignCheck{Message} ) > 50 ? substr( $SignCheck{Message}, 0, 50 ) : $SignCheck{Message} )
                    : 'Verification OK.';
                $Param{GetParam}{Signed}   = $Flag;
                $Param{GetParam}{SignedOK} = 1;
            }
        }

        # some errors occured
        else {
            $Param{GetParam}{Signed} = 'Signed message, but unable to verify!';
            return;
        }
    }

    # Return content if successful
    return $Param{GetParam}{Body};
}

1;
