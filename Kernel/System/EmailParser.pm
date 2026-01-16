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

package Kernel::System::EmailParser;

use v5.24;
use strict;
use warnings;

# core modules
use MIME::Base64      qw(decode_base64);
use MIME::QuotedPrint ();

# CPAN modules
use Mail::Internet ();
use MIME::Parser   ();
use MIME::Words    qw(decode_mimewords);
use Mail::Address  ();

# OTOBO modules

our $ObjectManagerDisabled = 1;

=for stopwords iso multipart

=head1 NAME

Kernel::System::EmailParser - parse an email and provide methods implementing OTOBO specific logic

=head1 DESCRIPTION

Parses an email using modules from CPAN. Provide methods that mangle the message and give the content that OTOBO needs.

The module is also used without parsing mails. In this case the instance provides some helper methods.

=head1 PUBLIC INTERFACE

=head2 new()

can be used directly without using the object manager.

When the parameter C<Email> is passed then the passed email is parsed. The parsed mail
can then be accessed via the various accessor methods. The email is passed e.g. in C<Kernel::System::PostMaster::new()>
as a reference of to an array of strings. In this case the lines must keep their trailing newlines.

    use Kernel::System::EmailParser;

    my $ParserObject = Kernel::System::EmailParser->new(
        Email => \@ArrayOfEmailContent,
        Debug => 0,
    );

Alternatively a string or a reference to a string may be passed.

    my $ParserObject = Kernel::System::EmailParser->new(
        Email        => $EmailString,
    );

or

    my $ParserObject = Kernel::System::EmailParser->new(
        Email        => \$EmailString,
    );

Another option is to pass an instance of C<MIME::Entity> in the parameter C<Entity>. This is useful
when an email has been already parsed or a C<MIME::Entity> object has been constructed by OTOBO.

    my $ParserObject = Kernel::System::EmailParser->new(
        Email        => $EmailString,
    );

Sometimes it is useful to have an empty instance on which helper methods can be called.
In the case the parameter C<Mode> must be passed with the value "Standalone".

    my $ParserObject = Kernel::System::EmailParser->new(
        Mode         => 'Standalone',
        Debug        => 0,
    );

The parameter C<Debug> can be used to activate debug output. The default is off.

The parameter C<NoHTMLChecks> may be used to suppress the generation of the plain text message when there
only is HTML content. The default is off. Note the double negation.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # get debug level from parent
    $Self->{Debug} = $Param{Debug} || 0;

    # create empty object just for accessing the helper methods
    return $Self if ( $Param{Mode} && $Param{Mode} eq 'Standalone' );

    # Check the parameters when the method is not called for standalone mode. The email must be passed
    # either as text in the parameter Email or as an instance of MIME::Entity in the parameter Entity.
    if ( !$Param{Email} && !$Param{Entity} ) {
        die 'Need Email or Entity!';
    }

    # Email is either a string, a reference to a string, or a reference to an array of strings.
    # Passing a file handle is not supported.
    if ( $Param{Email} ) {

        # check if Email is a reference to a string
        if ( ref $Param{Email} eq 'SCALAR' ) {
            my @Content = split /\n/, $Param{Email}->$*;
            for my $Line (@Content) {
                $Line .= "\n";
            }
            $Param{Email} = \@Content;
        }

        # check if Email is a plain string
        if ( ref $Param{Email} eq '' ) {
            my @Content = split /\n/, $Param{Email};
            for my $Line (@Content) {
                $Line .= "\n";
            }
            $Param{Email} = \@Content;
        }
        else {
            # nothing to to as $Param{Email} is expected to already be an array of newline terminated strings
        }

        # for GetPlainEmail()
        $Self->{OriginalEmail} = join '', $Param{Email}->@*;

        # create Mail::Internet object
        $Self->{Email} = Mail::Internet->new( $Param{Email} );

        # get a Mail::Header object from the Mail::Internet object
        $Self->{HeaderObject} = $Self->{Email}->head;

        # create MIME::Parser object
        my $Parser = MIME::Parser->new();

        # keep decoded parts in process memory
        $Parser->output_to_core('ALL');

        # do not try to decode message/rfc822, message/partial or message/external-body MIME parts,
        # treat them just as if they were a test/plain part (see bug#1970).
        $Parser->extract_nested_messages(0);

        # finally parse the email
        $Self->{ParserParts} = $Parser->parse_data( $Self->{Email}->as_string() );
    }
    else {

        # an instance of MIME::Entity was passed
        $Self->{ParserParts}  = $Param{Entity};
        $Self->{HeaderObject} = $Param{Entity}->head;    # this time a MIME::Head object
        $Self->{EntityMode}   = 1;
    }

    # get NoHTMLChecks param
    if ( $Param{NoHTMLChecks} ) {
        $Self->{NoHTMLChecks} = $Param{NoHTMLChecks};
    }

    # mangle the already parsed emails, specifically generate the array of attachments
    $Self->GetMessageBody();

    return $Self;
}

=head2 GetPlainEmail()

To get back the email message as a string. The returned string includes both the headers
an the body of the MIME message.

    my $UnparsedEmailMessage = $ParserObject->GetPlainEmail();

Usually the cached input is returned. The I<Plain> in the method name means I<not parsed>,
not to be confused with I<referring to text/plain>.

=cut

sub GetPlainEmail {
    my $Self = shift;

    return $Self->{OriginalEmail} || $Self->{Email}->as_string;
}

=head2 GetParam()

gets the value of a header field of the parsed MIME message.
Examples are I<Subject>, I<To>, I<ContentType>, ... .

    my $To = $ParserObject->GetParam( WHAT => 'To' );

RFC 2047, aka MIME words, encodings are decoded. The value is returned as a Perl string
with the UTF-8 flag set to on.

Email addresses are returned as a comma separated list of normalized addresses. The addresses
contain each phrase, proper address, and comment.

An empty string is return as a fallback.

=cut

sub GetParam {
    my ( $Self, %Param ) = @_;

    my $What = $Param{WHAT} || return;

    if ( !$Self->{HeaderObject} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'HeaderObject is needed!',
        );

        return;
    }

    $Self->{HeaderObject}->unfold();          # handle the case when values extend of more than a single line
    $Self->{HeaderObject}->combine($What);    # handle the case when a key is present more than once
    my $Line = $Self->{HeaderObject}->get($What) || '';
    chomp $Line;

    my $ReturnLine;

    # We need to split address lists before decoding; see "6.2. Display of 'encoded-word's"
    # in RFC 2047. Mail::Address routines will quote stuff if necessary (i.e. comma
    # or semicolon found in phrase).
    if ( $What =~ m/^(From|To|Cc)/ ) {
        for my $Address ( Mail::Address->parse($Line) ) {
            $Address->phrase( $Self->_DecodeString( String => $Address->phrase() ) );
            $Address->address( $Self->_DecodeString( String => $Address->address() ) );
            $Address->comment( $Self->_DecodeString( String => $Address->comment() ) );
            $ReturnLine .= ', ' if $ReturnLine;
            $ReturnLine .= $Address->format();
        }
    }
    else {
        $ReturnLine = $Self->_DecodeString( String => $Line );
    }

    $ReturnLine //= '';

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Get: $What; ReturnLine: $ReturnLine; OrigLine: $Line",
        );
    }

    return $ReturnLine;
}

=head2 GetEmailAddress()

To get the senders email address back.

    my $SenderEmail = $ParserObject->GetEmailAddress(
        Email => 'Juergen Weber <juergen.qeber@air.com>',
    );

This method can be used in standalone mode.

=cut

sub GetEmailAddress {
    my ( $Self, %Param ) = @_;

    my $Email = '';
    for my $EmailSplit ( $Self->_MailAddressParse( Email => $Param{Email} ) ) {
        $Email = $EmailSplit->address();
    }

    # return if no email address is there
    return if $Email !~ /@/;

    # return email address
    return $Email;
}

=head2 GetRealname()

to get the sender's C<RealName> aka phrase.

    my $Realname = $ParserObject->GetRealname(
        Email => 'Juergen Weber <juergen.qeber@air.com>',
    );

Returns:

    'Juergen Weber'

This method can be used in standalone mode.

=cut

sub GetRealname {
    my ( $Self, %Param ) = @_;

    my $Realname = '';

    # find "NamePart, NamePart" <some@example.com> (get not recognized by Mail::Address)
    if ( $Param{Email} =~ /"(.+?)"\s+?\<.+?@.+?\..+?\>/ ) {
        $Realname = $1;

        # removes unnecessary blank spaces, if the string has quotes.
        # This is because of bug 6059
        $Realname =~ s/"\s+?(.+?)\s+?"/"$1"/g;

        return $Realname;
    }

    # fallback of Mail::Address
    for my $EmailSplit ( $Self->_MailAddressParse( Email => $Param{Email} ) ) {
        $Realname = $EmailSplit->phrase();
    }

    return $Realname;
}

=head2 SplitAddressLine()

To get an array of email addresses of an To, Cc or Bcc line back.

    my @Addresses = $ParserObject->SplitAddressLine(
        Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber)',
    );

This returns an array with ('Juergen Weber <juergen.qeber@air.com>', 'me@example.com', 'hans@example.com (Hans Huber)').

This method can be used in standalone mode.

=cut

sub SplitAddressLine {
    my ( $Self, %Param ) = @_;

    my @GetParam;
    for my $Line ( $Self->_MailAddressParse( Email => $Param{Line} ) ) {
        push @GetParam, $Line->format();
    }

    return @GetParam;
}

=head2 GetContentType()

Returns the message body content type.

    my $ContentType = $ParserObject->GetContentType();

For example I<text/plain; charset="iso-8859-1">.
The information is taken from the message header or from the

=cut

sub GetContentType {
    my $Self = shift;

    return $Self->{ContentType} if $Self->{ContentType};
    return $Self->GetParam( WHAT => 'Content-Type' ) || 'text/plain';
}

=head2 GetContentDisposition()

Returns the message body (or from the first attachment) "ContentDisposition" header.

    my $ContentDisposition = $ParserObject->GetContentDisposition();

    (e. g. 'Content-Disposition: attachment; filename="test-123"')

=cut

sub GetContentDisposition {
    my $Self = shift;

    return $Self->{ContentDisposition} if $Self->{ContentDisposition};
    return $Self->GetParam( WHAT => 'Content-Disposition' );
}

=head2 GetCharset()

Returns the message body charset.

    my $Charset = $ParserObject->GetCharset();

For example I<iso-8859-1> or I<utf-8>.
The information is taken from the message header or from the header of the first MIME part.

=cut

sub GetCharset {
    my $Self = shift;

    # return charset of already defined
    if ( defined $Self->{Charset} ) {

        # debug
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Got charset from mime body: $Self->{Charset}",
            );
        }

        return $Self->{Charset};
    }

    if ( !$Self->{HeaderObject} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'HeaderObject is needed!',
        );

        return;
    }

    # find charset
    $Self->{HeaderObject}->unfold;
    my $Line = $Self->{HeaderObject}->get('Content-Type') || '';
    chomp $Line;
    my %Data = $Self->GetContentTypeParams( ContentType => $Line );

    # check content type (only do charset decode if no Content-Type or ContentType
    # with text/* exists) if it's not a text content type (e. g. pdf, png, ...),
    # return no charset
    if ( $Data{ContentType} && $Data{ContentType} !~ /text/i ) {

        # debug
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  =>
                    "Got no charset from email body because of ContentType ($Data{ContentType})!",
            );
        }

        # remember charset
        $Self->{Charset} = '';

        # return charset
        return '';
    }

    # return charset if it can be detected
    if ( $Data{Charset} ) {

        # debug
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Got charset from email body: $Data{Charset}",
            );
        }

        # remember charset
        $Self->{Charset} = $Data{Charset};

        # return charset
        return $Data{Charset};
    }

    # if there is no available header for charset and content type, use
    # iso-8859-1 as charset

    # debug
    if ( $Self->{Debug} > 0 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Got no charset from email body! Take iso-8859-1!',
        );
    }

    # remember charset
    $Self->{Charset} = 'ISO-8859-1';

    # return charset
    return 'ISO-8859-1';
}

=head2 GetReturnContentType()

Returns the new message body (or from the first attachment) "ContentType" header
(maybe the message is converted to utf-8).

    my $ContentType = $ParserObject->GetReturnContentType();

(e. g. 'text/plain; charset="utf-8"')

=cut

sub GetReturnContentType {
    my $Self = shift;

    my $ContentType = $Self->GetContentType();
    $ContentType =~ s/(charset=)(.*)/$1utf-8/ig;

    # debug
    if ( $Self->{Debug} > 0 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Changed ContentType from '"
                . $Self->GetContentType()
                . "' to '$ContentType'.",
        );
    }

    return $ContentType;
}

=head2 GetReturnCharset()

Returns the charset of the new message body "Charset".

    my $Charset = $ParserObject->GetReturnCharset();

Always returns the string C<'utf-8'>.

=cut

sub GetReturnCharset {
    return 'utf-8';
}

=head2 GetMessageBody()

This method is already called in the constructor. In the case of MIME mails this message
calls C<GetAttachments()>.

Returns the message body (or from the first attachment) from the email.

    my $Body = $ParserObject->GetMessageBody();

There are also several side effects.

In the case of a not multipart HTML-only mail extract the plain text and return it.
Add the HTML as the first attachment.

In case the first attachment is a text/html part add the suffix '.html' to the
file name of the first attachment.

In the case multipart Emails get the properties Charset and ContentType from the first attachment
and cache them. The cached values will be used in C<GetCharset()> and in C<GetContentType()>.

=cut

sub GetMessageBody {
    my ( $Self, %Param ) = @_;

    # check if message body is already there
    return $Self->{MessageBody} if defined $Self->{MessageBody};

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    if ( !$Self->{EntityMode} && $Self->{ParserParts}->parts == 0 ) {
        $Self->{MimeEmail} = 0;
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => q{It's a plain (not MIME) email!},
            );
        }
        my $BodyStrg = join '', @{ $Self->{Email}->body };

        # quoted printable!
        if ( $Self->GetParam( WHAT => 'Content-Transfer-Encoding' ) =~ /quoted-printable/i ) {
            $BodyStrg = MIME::QuotedPrint::decode($BodyStrg);
        }

        # base64 decode
        elsif ( $Self->GetParam( WHAT => 'Content-Transfer-Encoding' ) =~ /base64/i ) {
            $BodyStrg = decode_base64($BodyStrg);
        }

        # charset decode
        if ( $Self->GetCharset() ) {
            $Self->{MessageBody} = $EncodeObject->Convert2CharsetInternal(
                Text  => $BodyStrg,
                From  => $Self->GetCharset(),
                Check => 1,
            );
        }
        else {
            $Self->{MessageBody} = $BodyStrg;
        }

        # check if the mail contains only HTML (store it as attachment and add text/plain)
        $Self->CheckMessageBody();

        # return message body
        return $Self->{MessageBody};
    }
    else {
        $Self->{MimeEmail} = 1;
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => q{It's a MIME email!},
            );
        }

        # Check if there is a valid attachment there, if yes, return
        #   the first attachment (normally text/plain) as message body.
        # For multipart/mixed emails, PartsAttachments() will concatenate subsequent
        #   body MIME parts into just one attachment.
        my @Attachments = $Self->GetAttachments();
        if ( @Attachments > 0 ) {
            $Self->{Charset}     = $Attachments[0]->{Charset};
            $Self->{ContentType} = $Attachments[0]->{ContentType};
            if ( $Self->{Debug} > 0 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "First attachment ContentType: $Self->{ContentType}",
                );
            }

            # check if charset is given, set iso-8859-1 if content is text
            if ( !$Self->{Charset} && $Self->{ContentType} =~ /\btext\b/ ) {
                $Self->{Charset} = 'iso-8859-1';
            }

            # check if charset exists
            if ( $Self->GetCharset() ) {
                $Self->{MessageBody} = $EncodeObject->Convert2CharsetInternal(
                    Text  => $Attachments[0]->{Content},
                    From  => $Self->GetCharset(),
                    Check => 1,
                );
            }
            else {
                $Self->{Charset}     = 'us-ascii';
                $Self->{ContentType} = 'text/plain';
                $Self->{MessageBody} = '- no text message => see attachment -';
            }

            # check if it's a html-only email (store it as attachment and add text/plain)
            $Self->CheckMessageBody();

            # return message body
            return $Self->{MessageBody};
        }
        else {
            if ( $Self->{Debug} > 0 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => 'No attachments returned from GetAttachments(), just an empty attachment!?',
                );
            }

            # return empty attachment
            $Self->{Charset}     = 'iso-8859-1';
            $Self->{ContentType} = 'text/plain';

            return '-';
        }
    }

    return;
}

=head2 GetAttachments()

Note that in the case of MIME mails this message is already called when constructing the object instance.
Successive calls of the method return the cached array.

Returns an array of the email attachments.

    my @Attachments = $ParserObject->GetAttachments();
    for my $Attachment (@Attachments) {
        print $Attachment->{Filename};
        print $Attachment->{Charset};
        print $Attachment->{MimeType};
        print $Attachment->{ContentType};
        print $Attachment->{Content};

        # optional
        print $Attachment->{ContentID};
        print $Attachment->{ContentAlternative};
        print $Attachment->{ContentMixed};
    }

Note that there is an OTOBO specific logic for the list of attachments.
That logic is implemented in the method C<PartsAttachments()>.

=cut

sub GetAttachments {
    my ( $Self, %Param ) = @_;

    # return if it's no mime email
    return unless $Self->{MimeEmail};

    # return if it is already parsed
    return $Self->{Attachments}->@* if $Self->{Attachments};

    # mangle the nested MIME parts of the email
    $Self->PartsAttachments( Part => $Self->{ParserParts} );

    # return if no attachments are found
    return unless $Self->{Attachments};

    # return attachments
    return $Self->{Attachments}->@*;
}

=head2 PartsAttachments()

This method is intended only for internal use. It implements the OTOBO specific logic for the potentially nested
parts of the MIME message.

=over 4

=item It is marked whether the attachment is within a multipart/alternative or a multipart/mixed

=item The default content type is I<text/plain>

=item Rename attachments with the file name I<file-1> to I<File-1>

=item Rename attachments with the file name I<file-2> to I<File-2>

=item The text/plain and text/html parts of multipart/mixed parts are merged

=back

The rules for merging sub parts of multipart/mixed are like:

=over 4

=item For each text/plain or text/html part it is known whether the part is contained in a multipart/mixed or multipart/alternative part

=item It is possible to be in both a mixed and a alternative part

=item the exact hierarchy is not considered

=item only parts in multipart/mixed are merged

=item text/plain parts are appended to the first text/plain part when there already is a text/plain part and the part is in multipart/alternative

=item text/html parts are appended to the first text/html part when there already is a text/html part and the part is in multipart/alternative

=item when not in multipart/alternative all text/plain and text/html parts are coerced and merged together. The type of the merged part is the type of the first encountered part

=back

The merging kind of assumes that the structure is not complex and that in an alternative text/plain comes before text/html.
Implicitly it is also assumed that there are no attachments before the text/plain or text/html part.

The result is noted in C<$Self->{Attachments}> which is a array of hash references. The structure
of the hash references is documented in the method C<GetAttachments()>.

=cut

sub PartsAttachments {
    my ( $Self, %Param ) = @_;

    my $Part               = $Param{Part}               || $Self->{ParserParts};
    my $PartCounter        = $Param{PartCounter}        || 0;
    my $SubPartCounter     = $Param{SubPartCounter}     || 0;
    my $ContentAlternative = $Param{ContentAlternative} || '';
    my $ContentMixed       = $Param{ContentMixed}       || '';

    # recursive descent when there are subparts
    if ( $Part->parts() > 0 ) {

        # check if it's an alternative part
        $Part->head()->unfold();
        $Part->head()->combine('Content-Type');
        my $ContentType = $Part->head()->get('Content-Type');
        if ( $ContentType && $ContentType =~ /multipart\/alternative;/i ) {
            $ContentAlternative = 1;
        }
        if ( $ContentType && $ContentType =~ /multipart\/mixed;/i ) {
            $ContentMixed = 1;
        }
        $PartCounter++;
        for my $Part ( $Part->parts() ) {
            $SubPartCounter++;
            if ( $Self->{Debug} > 0 ) {
                print STDERR "Sub part($PartCounter/$SubPartCounter)!\n";
            }
            $Self->PartsAttachments(
                Part               => $Part,
                PartCounter        => $PartCounter,
                ContentAlternative => $ContentAlternative,
                ContentMixed       => $ContentMixed,
            );
        }

        return 1;
    }

    # look at the terminals, that is MIME parts that have no sub parts

    # get attachment meta stuff
    my %PartData;

    if ($ContentAlternative) {
        $PartData{ContentAlternative} = $ContentAlternative;
    }

    # get ContentType
    $Part->head()->unfold();
    $Part->head()->combine('Content-Type');

    # get Content-Type, use text/plain if no content type is given
    $PartData{ContentType} = $Part->head()->get('Content-Type') || 'text/plain;';
    chomp $PartData{ContentType};

    # Fix for broken content type headers, see bug#7913 or DuplicatedContentTypeHeader.t.
    $PartData{ContentType} =~ s{\r?\n}{}smxg;

    # get mime type
    $PartData{MimeType} = $Part->head()->mime_type();

    # get charset
    my %Data = $Self->GetContentTypeParams( ContentType => $PartData{ContentType} );
    if ( $Data{Charset} ) {
        $PartData{Charset} = $Data{Charset};
    }
    else {
        $PartData{Charset} = '';
    }

    # get content (if possible)
    if ( $Part->bodyhandle() ) {
        $PartData{Content} = $Part->bodyhandle()->as_string();
        if ( !$PartData{Content} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Empty attachment part ($PartCounter)",
            );
        }
    }

    # log error if there is an corrupt MIME email
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "Was not able to parse corrupt MIME email! Skipped attachment ($PartCounter)",
        );

        return;
    }

    # check if there is no recommended_filename or subject -> add file-NoFilenamePartCounter
    if ( $Part->head()->recommended_filename() ) {
        $PartData{Filename} = $Self->_DecodeString(
            String => $Part->head()->recommended_filename(),
            Encode => 'utf-8',
        );

        # cleanup filename
        $PartData{Filename} = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
            Filename => $PartData{Filename},
            Type     => 'Local',
        );

        $PartData{ContentDisposition} = $Part->head()->get('Content-Disposition');
        if ( $PartData{ContentDisposition} ) {
            my %Data = $Self->GetContentTypeParams(
                ContentType => $PartData{ContentDisposition},
            );
            if ( $Data{Charset} ) {
                $PartData{Charset} = $Data{Charset};
            }
        }
        else {
            $PartData{Charset} = '';
        }

        # check if reserved filename file-1 or file-2 is already used
        COUNT:
        for my $Count ( 1 .. 2 ) {
            if ( $PartData{Filename} eq "file-$Count" ) {
                $PartData{Filename} = "File-$Count";

                last COUNT;
            }
        }
    }

    # Guess the filename for nested messages (see bug#1970).
    elsif ( $PartData{ContentType} eq 'message/rfc822' ) {

        my ($SubjectString) = $Part->as_string() =~ m/^Subject: ([^\n]*(\n[ \t][^\n]*)*)/m;
        my $Subject = '';
        if ($SubjectString) {
            $Subject = $Self->_DecodeString( String => $SubjectString ) . '.eml';
        }

        # cleanup filename
        if ($Subject) {
            $Subject = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
                Filename => $Subject,
                Type     => 'Local',
            );
        }

        if ( $Subject eq '' ) {
            $Self->{NoFilenamePartCounter}++;
            $Subject = "Untitled-$Self->{NoFilenamePartCounter}" . '.eml';
        }
        $PartData{Filename} = $Subject;
    }
    else {
        $Self->{NoFilenamePartCounter}++;
        $PartData{Filename} = "file-$Self->{NoFilenamePartCounter}";
    }

    # parse/get Content-Id, Content-Location and Disposition for html email attachments
    $PartData{ContentID}       = $Part->head()->get('Content-Id');
    $PartData{ContentLocation} = $Part->head()->get('Content-Location');
    $PartData{Disposition}     = $Part->head()->get('Content-Disposition');

    if ( $PartData{ContentID} ) {
        chomp $PartData{ContentID};
    }
    elsif ( $PartData{ContentLocation} ) {
        chomp $PartData{ContentLocation};
        $PartData{ContentID} = $PartData{ContentLocation};
    }
    if ( $PartData{Disposition} ) {
        chomp $PartData{Disposition};
        $PartData{Disposition} = lc $PartData{Disposition};
    }

    # get attachment size
    $PartData{Filesize} = bytes::length( $PartData{Content} );

    # debug
    if ( $Self->{Debug} > 0 ) {
        print STDERR
            "->GotArticle::Atm: '$PartData{Filename}' '$PartData{ContentType}' ($PartData{Filesize})\n";
    }

    # For multipart/mixed emails, we check for all text/plain or text/html MIME parts which are
    #   body elements, and concatenate them into the first relevant attachment, to stay in line
    #   with OTOBO file-1 and file-2 attachment handling.
    #
    # HTML parts will just be concatenated, so that the attachment has two complete HTML documents
    #   inside. Browsers tolerate this.
    #
    # The first found body part determines the content type to be used. So if it is text/plain, subsequent
    #   text/html body parts will be converted to plain text, and vice versa. In case of multipart/alternative,
    #   a text/plain and a text/html body attachment can coexist.
    if (
        $ContentMixed
        && ( !$PartData{Disposition} || $PartData{Disposition} eq 'inline' )
        && ( $PartData{ContentType} =~ /text\/(?:html|plain)/i )
        )
    {
        # Is it a plain or HTML body?
        my $MimeType       = $PartData{ContentType} =~ /text\/html/i ? 'text/html' : 'text/plain';
        my $TargetMimeType = $MimeType;

        my $BodyAttachmentKey = "MultipartMixedBodyAttachment$MimeType";

        if ( !$Self->{FirstBodyAttachmentKey} ) {

            # Remember the first found attachment.
            $Self->{FirstBodyAttachmentKey}      = $BodyAttachmentKey;
            $Self->{FirstBodyAttachmentMimeType} = $MimeType;
        }
        elsif ( !$ContentAlternative ) {

            # For multipart/alternative, we allow both text/plain and text/html. Otherwise, concatenate
            #   all subsequent elements to the first found body element.
            $BodyAttachmentKey = $Self->{FirstBodyAttachmentKey};
            $TargetMimeType    = $Self->{FirstBodyAttachmentMimeType};
        }

        # For concatenating multipart/mixed text parts, we have to convert all of them to utf-8 to be sure that
        #   the contents fit together and that all characters can be displayed.
        $PartData{Content} = $Kernel::OM->Get('Kernel::System::Encode')->Convert2CharsetInternal(
            Text  => $PartData{Content},
            From  => $PartData{Charset},
            Check => 1,
        );
        $PartData{ContentType} = "$MimeType; charset=utf-8";
        my $OldCharset = $PartData{Charset};
        $PartData{Charset} = "utf-8";

        # Also replace charset in meta tags of HTML emails.
        if ( $MimeType eq 'text/html' ) {
            $PartData{Content} =~ s/(<meta[^>]+charset=("|'|))\Q$OldCharset\E/$1utf-8/gi;
        }

        $PartData{Filesize} = bytes::length( $PartData{Content} );

        # Is it a subsequent body element? Then concatenate it to the first one and skip it as attachment.
        if ( $Self->{$BodyAttachmentKey} ) {

            # This concatenation only works if all parts have the utf-8 flag on (from Convert2CharsetInternal).
            if ( $MimeType ne $TargetMimeType ) {
                my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
                if ( $TargetMimeType eq 'text/html' ) {
                    my $HTMLContent = $HTMLUtilsObject->ToHTML(
                        String => $PartData{Content},
                    );
                    $PartData{Content} = $HTMLUtilsObject->DocumentComplete(
                        String => $HTMLContent,
                    );
                }
                else {
                    $PartData{Content} = $HTMLUtilsObject->ToAscii(
                        String => $PartData{Content},
                    );
                }
                $PartData{Filesize} = bytes::length( $PartData{Content} );
            }
            $Self->{$BodyAttachmentKey}->{Content} .= $PartData{Content};
            $Self->{$BodyAttachmentKey}->{Filesize} += $PartData{Filesize};

            # Don't create an attachment for this part, as it was concatenated to the first body element.
            return 1;
        }

        # Remember the first found body element for possible later concatenation.
        $Self->{$BodyAttachmentKey} = \%PartData;
    }

    push $Self->{Attachments}->@*, \%PartData;

    return 1;
}

=head2 GetReferences()

To get an array of reference ids of the parsed email

    my @References = $ParserObject->GetReferences();

This returns an array with ('fasfda@host.de', '4124.2313.1231@host.com').

=cut

sub GetReferences {
    my ( $Self, %Param ) = @_;

    # get references ids
    my @ReferencesAll;
    my $ReferencesString = $Self->GetParam( WHAT => 'References' );
    if ($ReferencesString) {
        push @ReferencesAll, ( $ReferencesString =~ /<([^>]+)>/g );
    }

    # get in reply to id
    my $InReplyToString = $Self->GetParam( WHAT => 'In-Reply-To' );
    if ($InReplyToString) {
        chomp $InReplyToString;
        $InReplyToString =~ s/.*?<([^>]+)>.*/$1/;
        push @ReferencesAll, $InReplyToString;
    }

    # get uniq
    my %Checked;
    my @References;
    for my $Reference ( reverse @ReferencesAll ) {
        if ( !$Checked{$Reference} ) {
            push @References, $Reference;
        }
        $Checked{$Reference} = 1;
    }

    return @References;
}

# just for internal
sub GetContentTypeParams {
    my ( $Self, %Param ) = @_;

    return unless $Param{ContentType};

    if ( $Param{ContentType} =~ /charset\s*=.+?/i ) {
        $Param{Charset} = $Param{ContentType};
        $Param{Charset} =~ s/.*?charset\s*=\s*(.*?)/$1/i;
        $Param{Charset} =~ s/"|'//g;
        $Param{Charset} =~ s/(.+?)(;|\s).*/$1/g;
    }
    if ( !$Param{Charset} ) {
        if (
            $Param{ContentType}
            =~ /\?(iso-\d{3,4}-(\d{1,2}|[A-z]{1,2})|utf(-8|8)|windows-\d{3,5}|koi8-.+?|cp(-|)\d{2,4}|big5(|.+?)|shift(_|-)jis|euc-.+?|tcvn|visii|vps|gb.+?)\?/i
            )
        {
            $Param{Charset} = $1;
        }
        elsif ( $Param{ContentType} =~ /name\*0\*=(utf-8|utf8)/i ) {
            $Param{Charset} = $1;
        }
        elsif (
            $Param{ContentType}
            =~ /filename\*=(iso-\d{3,4}-(\d{1,2}|[A-z]{1,2})|utf(-8|8)|windows-\d{3,5}|koi8-.+?|cp(-|)\d{2,4}|big5(|.+?)|shift(_|-)jis|euc-.+?|tcvn|visii|vps|gb.+?)''/i
            )
        {
            $Param{Charset} = $1;
        }
    }
    if ( $Param{ContentType} =~ /Content-Type:\s{0,1}(.+?\/.+?)(;|'|"|\s)/i ) {
        $Param{MimeType} = $1;
        $Param{MimeType} =~ s/"|'//g;
    }

    return %Param;
}

# just for internal, details document in GetMessageBody()
sub CheckMessageBody {
    my ( $Self, %Param ) = @_;

    # if already checked, just return
    return if $Self->{MessageChecked};

    # return if no auto convert from html2text is needed
    return if !$Kernel::OM->Get('Kernel::Config')->Get('PostmasterAutoHTML2Text');

    # return if no auto convert from html2text is needed
    return if $Self->{NoHTMLChecks};

    # check if it's just a html email (store it as attachment and add text/plain)
    if ( $Self->GetReturnContentType() =~ /text\/html/i ) {
        $Self->{MessageChecked} = 1;

        # add html email as attachment (if needed)
        if ( !$Self->{MimeEmail} ) {
            push(
                @{ $Self->{Attachments} },
                {
                    Charset     => $Self->GetCharset(),
                    ContentType => $Self->GetReturnContentType(),
                    Content     => $Self->{MessageBody},
                    Filename    => 'file-1',                        # not sure why this isn't file-1.html
                }
            );
        }

        # add .html suffix to filename if not already there
        else {
            if ( $Self->{Attachments}->[0]->{Filename} ) {
                if ( $Self->{Attachments}->[0]->{Filename} !~ /\.(htm|html)/i ) {
                    $Self->{Attachments}->[0]->{Filename} .= '.html';
                }
            }
        }

        # remember to be a mime email now
        $Self->{MimeEmail} = 1;

        # convert from html to ascii
        $Self->{MessageBody} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Self->{MessageBody},
        );

        $Self->{ContentType} = 'text/plain';
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => q{It's an HTML only email, added ascii dump, attached HTML email as attachment.},
            );
        }
    }

    return;
}

=begin Internal:

=head2 _DecodeString()

Decode all encoded substrings.

    my $Result = $Self->_DecodeString(
        String => 'some text',
    );

=cut

sub _DecodeString {
    my ( $Self, %Param ) = @_;

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    my $DecodedString;
    my $BufferedString;
    my $PrevEncoding;

    $BufferedString = '';

    for my $Entry ( decode_mimewords( $Param{String} ) ) {
        if (
            $BufferedString ne ''
            && ( !$PrevEncoding || !$Entry->[1] || lc($PrevEncoding) ne lc( $Entry->[1] ) )
            )
        {
            my $Encoding = $EncodeObject->FindAsciiSupersetEncoding(
                Encodings => [ $PrevEncoding, $Param{Encode}, $Self->GetCharset() ],
            );
            $DecodedString .= $EncodeObject->Convert2CharsetInternal(
                Text  => $BufferedString,
                From  => $Encoding,
                Check => 1,
            );
            $BufferedString = '';
        }
        $BufferedString .= $Entry->[0];
        $PrevEncoding = $Entry->[1];
    }

    if ( $BufferedString ne '' ) {
        my $Encoding = $EncodeObject->FindAsciiSupersetEncoding(
            Encodings => [ $PrevEncoding, $Param{Encode}, $Self->GetCharset() ],
        );
        $DecodedString .= $EncodeObject->Convert2CharsetInternal(
            Text  => $BufferedString,
            From  => $Encoding,
            Check => 1,
        );
    }

    return $DecodedString;
}

=head2 _MailAddressParse()

    my @Chunks = $ParserObject->_MailAddressParse(Email => $Email);

Wrapper for C<Mail::Address->parse($Email)>, but cache it, since it's
not too fast, and often called.

=cut

sub _MailAddressParse {
    my ( $Self, %Param ) = @_;

    my $Email = $Param{Email};

    my $Cache = $Self->{EmailCache};

    return $Cache->{$Email}->@* if $Cache->{$Email};

    my @Chunks = Mail::Address->parse($Email);
    $Cache->{$Email} = \@Chunks;

    return @Chunks;
}

=end Internal:

=cut

1;
