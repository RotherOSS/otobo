package Sisimai::Message;
use v5.26;
use strict;
use warnings;
use Sisimai::RFC1894;
use Sisimai::RFC2045;
use Sisimai::RFC5322;
use Sisimai::RFC5965;
use Sisimai::Address;
use Sisimai::String;
use Sisimai::Order;
use Sisimai::Lhost;

state $Fields1894 = Sisimai::RFC1894->FIELDINDEX;
state $Fields5322 = Sisimai::RFC5322->FIELDINDEX;
state $Fields5965 = Sisimai::RFC5965->FIELDINDEX;
state $FieldTable = { map { lc $_ => $_ } ($Fields1894->@*, $Fields5322->@*, $Fields5965->@*) };
state $Boundaries = ["Content-Type: message/rfc822", "Content-Type: text/rfc822-headers"];
state $MediaTypes = [
    ["message/xdelivery-status",                "message/delivery-status"],
    ["message/disposition-notification",        "message/delivery-status"],
    ["message/global-delivery-status",          "message/delivery-status"],
    ["message/global-disposition-notification", "message/delivery-status"],
    ["message/global-delivery-status",          "message/delivery-status"],
    ["message/global-headers",                  "text/rfc822-headers"],
    ["message/global",                          "message/rfc822"],
];

my $TryOnFirst = [];

sub rise {
    # Constructor of Sisimai::Message
    # @param         [Hash] argvs   Email text data
    # @options argvs [String] data  Entire email message
    # @options argvs [Code]   hook  Reference to callback method
    # @return        [Hash]         Structured email data
    #                [Undef]        If each value of the arguments are missing
    my $class = shift;
    my $argvs = shift            || return undef;
    my $email = $argvs->{'data'} || return undef;
    my $thing = {'from' => '', 'header' => {}, 'rfc822' => '', 'ds' => [], 'catch' => undef};
    my $param = {};

    my $aftersplit = undef;
    my $beforefact = undef;
    my $parseagain = 0;

    while($parseagain < 2) {
        # 1. Split email data to headers and a body part.
        last unless $aftersplit = __PACKAGE__->part(\$email);

        # 2. Convert email headers from text to hash reference
        $thing->{'from'}   = $aftersplit->[0];
        $thing->{'header'} = __PACKAGE__->makemap(\$aftersplit->[1]);

        # 3. Decode and rewrite the "Subject:" header
        if( $thing->{'header'}->{'subject'} ) {
            # Decode MIME-Encoded "Subject:" header
            my $cv = $thing->{'header'}->{'subject'};
            my $cq = Sisimai::RFC2045->is_encoded(\$cv) ? Sisimai::RFC2045->decodeH([split(/[ ]/, $cv)]) : $cv;
            my $cl = lc $cq;
            my $p1 = index($cl, 'fwd:'); $p1 = index($cl, 'fw:') if $p1 < 0;

            # Remove "Fwd:" string from the "Subject:" header
            if( $p1 > -1 ) {
                # Delete quoted strings, quote symbols(>)
                $cq = substr($cq, index($cq, ':') + 1,);
                s/^[>][ ]//gm, s/^[>]$//gm for $aftersplit->[2];
            }
            $thing->{'header'}->{'subject'} = $cq;
        }

        # 4. Rewrite message body for detecting the bounce reason
        $TryOnFirst = Sisimai::Order->make($thing->{'header'}->{'subject'});
        $param = {'hook' => $argvs->{'hook'} || undef, 'mail' => $thing, 'body' => \$aftersplit->[2]};
        last if $beforefact = __PACKAGE__->sift(%$param);
        last unless grep { index($aftersplit->[2], $_) > -1 } @$Boundaries;

        # 5. Try to sift again
        #    There is a bounce message inside of mutipart/*, try to sift the first message/rfc822
        #    part as a entire message body again. rfc3464/1086-a847b090.eml is the email but the
        #    results decodd by sisimai are unstable.
        $parseagain++;
        $email =  Sisimai::RFC5322->part(\$aftersplit->[2], $Boundaries, 1)->[1];
        $email =~ s/\A[\r\n\s]+//m;
        last unless length $email > 128;
    }
    return undef unless $beforefact;

    # 6. Rewrite headers of the original message in the body part
    $thing->{ $_ } = $beforefact->{ $_ } for ('ds', 'catch', 'rfc822');
    my $r = $beforefact->{'rfc822'} || $aftersplit->[2];
    $thing->{'rfc822'} = ref $r ? $r : __PACKAGE__->makemap(\$r, 1);

    return $thing;
}

sub part {
    # Divide email data up headers and a body part.
    # @param         [String] email  Email data
    # @return        [Array]         Email data after split
    # @since v4.14.0
    my $class = shift;
    my $email = shift // return undef;
    my $parts = ['', '', ''];   # 0:From, 1:Header, 2:Body

    $$email =~ s/\A\s+//m;
    $$email =~ s/\r\n/\n/gm if rindex($$email, "\r\n") > -1;

    ($parts->[1], $parts->[2]) = split(/\n\n/, $$email, 2); $parts->[2] ||= "";
    return undef if $parts->[1] eq "" || $parts->[2] eq "";

    if( substr($parts->[1], 0, 5) eq 'From ' ) {
        # From MAILER-DAEMON Tue Feb 11 00:00:00 2014
        $parts->[0] =  [split(/\n/, $parts->[1], 2)]->[0];
        $parts->[0] =~ y/\r\n//d;

    } else {
        # Set pseudo UNIX From line
        $parts->[0] =  'MAILER-DAEMON Tue Feb 11 00:00:00 2014';
    }
    $parts->[1] .= "\n" unless substr($parts->[1], -1, 1) eq "\n";

    for my $e ('image/', 'application/', 'text/html') {
        # https://github.com/sisimai/p5-sisimai/issues/492, Reduce email size
        my $p0 = 0; my $p1 = 0; my $ep = $e eq 'text/html' ? '</html>' : "--\n";
        while(1) {
            # Remove each part from "Content-Type: image/..." to "--\n" (the end of each boundary)
            $p0 = index($parts->[2], 'Content-Type: '.$e, $p0); last if $p0 < 0;
            $p1 = index($parts->[2], $ep, $p0 + 32);            last if $p1 < 0;
            substr($parts->[2], $p0, $p1 - $p0, '');
        }
    }
    $parts->[2] .= "\n";
    return $parts;
}

sub makemap {
    # Convert a text including email headers to a hash reference
    # @param    [String] argv0  Email header data
    # @param    [Bool]   argv1  Decode "Subject:" header
    # @return   [Hash]          Structured email header data
    # @since    v4.25.6
    my $class = shift;
    my $argv0 = shift || return {}; $$argv0 =~ s/^[>]+[ ]//mg;  # Remove '>' indent symbols
    my $argv1 = shift || 0;

    # Select and convert all the headers in $argv0. The following regular expression is based on
    # https://gist.github.com/xtetsuji/b080e1f5551d17242f6415aba8a00239
    my $firstpairs = {$$argv0 =~ /^([\w-]+):[ ]*(.*?)\n(?![\s\t])/gms};
    my $headermaps = {'subject' => ''};
       $headermaps->{ lc $_ } = $firstpairs->{ $_ } for keys %$firstpairs;
    my $receivedby = [];

    for my $e ( values %$headermaps ) { s/\n\s+/ /, y/\t / /s for $e }
    if( index($$argv0, "\nReceived:") > 0 || index($$argv0, "Received:") == 0 ) {
        # Capture values of each Received: header
        my $re = [$$argv0 =~ /^Received:[ ]*(.*?)\n(?![\s\t])/gms];
        for my $e ( @$re ) {
            # 1. Exclude the Received header including "(qmail ** invoked from network)".
            # 2. Convert all consecutive spaces and line breaks into a single space character.
            next if index($e, Sisimai::RFC5322->woReceived->[0]) > 0 || index($e, Sisimai::RFC5322->woReceived->[1]) > 0;

            $e =~ s/\n\s+/ /;
            $e =~ y/\n\t / /s;
            push @$receivedby, $e;
        }
    }
    $headermaps->{'received'} = $receivedby;

    return $headermaps unless $argv1;
    return $headermaps unless length $headermaps->{'subject'};

    # Convert MIME-Encoded subject
    if( Sisimai::String->is_8bit(\$headermaps->{'subject'}) ) {
        # The value of ``Subject'' header is including multibyte character, is not MIME-Encoded text.
        eval {
            # Remove invalid byte sequence
            Encode::decode_utf8($headermaps->{'subject'});
            Encode::encode_utf8($headermaps->{'subject'});
        };
        $headermaps->{'subject'} = 'MULTIBYTE CHARACTERS HAVE BEEN REMOVED' if $@;

    } else {
        # MIME-Encoded subject field or ASCII characters only
        my $r = [];
        if( Sisimai::RFC2045->is_encoded(\$headermaps->{'subject'}) ) {
            # split the Subject: field by " "
            for my $v ( split(/ /, $headermaps->{'subject'}) ) {
                # Insert value to the array if the string is MIME encoded text
                push @$r, $v if Sisimai::RFC2045->is_encoded(\$v);
            }
        } else {
            # Subject line is not MIME encoded
            $r = [$headermaps->{'subject'}];
        }
        $headermaps->{'subject'} = Sisimai::RFC2045->decodeH($r);
    }
    return $headermaps;
}

sub tidy {
    # Tidy up each field name and format
    # @param    [String] argv0 Strings including field and value used at an email
    # @return   [String]       Strings tidied up
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift || return '';
    my $email = '';
    my @lines = split("\n", $$argv0);
    my $index = -1;

    for my $e ( @lines ) {
        # Find and tidy up fields defined in RFC5322, RFC1894, and RFC5965
        # 1. Find a field label defined in RFC5322, RFC1894, or RFC5965 from this line
        my $p0 = index($e, ':');
        my $cf = substr(lc $e, 0, $p0); chop $cf if substr($cf, -1, 1) eq ' ';
        my $fn = $FieldTable->{ $cf } || '';

        # There is neither ":" character nor the field listed in $FieldTable
        $index++;
        if( $fn eq '' ){ $email .= $e."\n"; next }

        # 2. Tidy up a sub type of each field defined in RFC1894 such as Reporting-MTA: DNS;...
        my $ab = [];
        my $bf = substr($e, $p0 + 1,);
        my $p1 = index($bf, ';');
        while(1) {
            # Such as Diagnostic-Code, Remote-MTA, and so on
            # - Before: Diagnostic-Code: SMTP;550 User unknown
            # - After:  Diagnostic-Code: smtp; 550 User unknown
            last unless grep { $fn eq $_ } (@$Fields1894, 'Content-Type');

            if( $p1 > 0 ) {
                # The field including one or more ";"
                for my $f (split(';', $bf)) {
                    # 2-1. Trim leading and trailing space characters from the current buffer
                    while( index($f, ' ') == 0 )    { $f = substr($f, 1,) }
                    while( substr($f, -1, 1) eq ' '){ $f = substr($f, 0, length($f) - 1) }
                    my $ps = '';

                    # 2-2. Convert some parameters to the lower-cased string
                    while(1) {
                        # For example,
                        # - Content-Type: Message/delivery-status => message/delivery-status
                        # - Content-Type: Charset=UTF8            => charset=utf8
                        # - Reporting-MTA: DNS; ...               => dns
                        # - Final-Recipient: RFC822; ...          => rfc822
                        last if index($f, ' ') > 0;

                        my $p2 = index($f, '='); if( $p2 > 0 ) {
                            # charset=, boundary=, and other pairs divided by "="
                            $ps = lc substr($f, 0, $p2);
                            substr($f, 0, $p2, $ps);
                        }
                        $f = lc $f if $ps ne 'boundary';
                        $f = 'rfc822' if $f eq 'rfc/822';
                        last;
                    }
                    push @$ab, $f;
                }

                if( $fn eq 'Diagnostic-Code' ) {
                    # Diagnostic-Code: x-unix;
                    #   /var/email/kijitora/Maildir/tmp/1000000000.A000000B00000.neko22:
                    #   Disk quota exceeded
                    push @$ab, '' if scalar @$ab == 1 && index($lines[$index + 1], " ") == 0;
                }
                $bf = join('; ', @$ab); $ab = []; # Insert " " (space characer) immediately after ";"

            } else {
                # There is no ";" in the field
                # Arrival-Date, Last-Attempt-Date
                # X-Original-Message-ID
                last if index($fn, '-Date') > 0 || index($fn, '-Message-ID') > 0;
                $bf = lc $bf;
            }
            last;
        }

        # 3. Tidy up a value, and a parameter of Content-Type: field
        if( $fn eq "Content-Type" ) {
            # Replace the value of "Content-Type" field
            for my $f ( @$MediaTypes ) {
                # - Before: Content-Type: message/xdelivery-status; ...
                # - After:  Content-Type: message/delivery-status; ...
                $p1 = index($bf, $f->[0]); next if $p1 < 0;
                substr($bf, $p1, length $f->[0], $f->[1]);
            }
        }

        # 4. Concatenate the field name and the field value
        for my $f ( split(' ', $bf) ) {
            # Remove redundant space characters
            push @$ab, $f if length $f > 0;
        }
        $email .= sprintf("%s: %s\n", $fn, join(' ', @$ab));
    }

    # 5. Convert the lower-cased SMTP command to the upper-cased.
    $email =~ s/after end of data:/after end of DATA:/g;
    $email .= "\n" if substr($email, -2, 2) ne "\n\n";
    return \$email;
}

sub sift {
    # Sift a bounce mail with each MTA module
    # @param               [Hash] argvs    Processing message entity.
    # @param options argvs [Hash] mail     Email message entity
    # @param options mail  [String] from   From line of mbox
    # @param options mail  [Hash]   header Email header data
    # @param options mail  [String] rfc822 Original message part
    # @param options mail  [Array]  ds     Delivery status list(decoded data)
    # @param options argvs [String] body   Email message body
    # @param options argvs [Code]   hook   Hook method to be called
    # @return              [Hash]          Decoded and structured bounce mails
    my $class = shift;
    my $argvs = { @_ };

    my $mailheader = $argvs->{'mail'}->{'header'} || return undef;
    my $bodystring = $argvs->{'body'}             || return undef;
    my $hookmethod = $argvs->{'hook'}             || undef;
    my $havecaught = undef;

    state $defaultset = Sisimai::Order->another;
    state $lhosttable = Sisimai::Lhost->path;

    $mailheader->{'from'}         //= '';
    $mailheader->{'subject'}      //= '';
    $mailheader->{'content-type'} //= '';

    # Tidy up each field name and value in the entire message body
    $$bodystring =  __PACKAGE__->tidy($bodystring)->$*;

    # Decode BASE64 Encoded message body
    my $mesgformat = lc($mailheader->{'content-type'} || '');
    my $ctencoding = lc($mailheader->{'content-transfer-encoding'} || '');

    if( index($mesgformat, 'text/plain') == 0 || index($mesgformat, 'text/html') == 0 ) {
        # Content-Type: text/plain; charset=UTF-8
        if( $ctencoding eq 'base64' ) {
            # Content-Transfer-Encoding: base64
            $bodystring = Sisimai::RFC2045->decodeB($bodystring);

        } elsif( $ctencoding eq 'quoted-printable' ) {
            # Content-Transfer-Encoding: quoted-printable
            $bodystring = Sisimai::RFC2045->decodeQ($bodystring);
        }

        # Content-Type: text/html;...
        $bodystring = Sisimai::String->to_plain($bodystring, 1) if index($mesgformat, 'text/html') > -1;

    } elsif( index($mesgformat, 'multipart/') == 0 ) {
        # In case of Content-Type: multipart/*
        my $p = Sisimai::RFC2045->makeflat($mailheader->{'content-type'}, $bodystring);
        $bodystring = $p if defined $p && length $$p;
    }
    $$bodystring =~ tr/\r//d;
    $$bodystring =~ s/\t/ /g;

    if( ref $hookmethod eq 'CODE' ) {
        # Call hook method
        my $p = {'headers' => $mailheader, 'message' => $$bodystring};
        eval { $havecaught = $hookmethod->($p) };
        warn sprintf(" ***warning: Something is wrong in hook method 'hook': %s", $@) if $@;
    }

    my $haveloaded = {};
    my $havesifted = undef;
    my $modulename = '';
    DECODER: while(1) {
        # 1. MTA Module Candidates to be tried on first
        # 2. Sisimai::Lhost::*
        # 3. Sisimai::RFC3464
        # 4. Sisimai::ARF
        # 5. Sisimai::RFC3834
        TRY_ON_FIRST_AND_DEFAULTS: for my $r ( @$TryOnFirst, @$defaultset ) {
            # Try MTA module candidates
            next if exists $haveloaded->{ $r };
            require $lhosttable->{ $r };
            $havesifted = $r->inquire($mailheader, $bodystring);
            $haveloaded->{ $r } = 1;
            $modulename = $r;
            last(DECODER) if $havesifted;
        }

        # When the all of Sisimai::Lhost::* modules did not return bounce data, call Sisimai::RFC3464;
        require Sisimai::RFC3464;
        $havesifted = Sisimai::RFC3464->inquire($mailheader, $bodystring);
        if( $havesifted ){ $modulename = 'RFC3464'; last(DECODER) }

        # Feedback Loop message
        require Sisimai::ARF;
        $havesifted = Sisimai::ARF->inquire($mailheader, $bodystring);
        if( $havesifted ){ $modulename = "ARF"; last(DECODER) }

        # Try to sift the message as auto reply message defined in RFC3834
        require Sisimai::RFC3834;
        $havesifted = Sisimai::RFC3834->inquire($mailheader, $bodystring);
        if( $havesifted ){ $modulename = 'RFC3834'; last(DECODER) }

        last; # as of now, we have no sample email for coding this block

    } # End of while(DECODER)
    return undef unless $havesifted;

    $havesifted->{'catch'} = $havecaught;
    $modulename =~ s/\A.+:://; $_->{'agent'} ||= $modulename for $havesifted->{'ds'}->@*;
    return $havesifted;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Message - Converts the bounce email text to the data structure.

=head1 SYNOPSIS

    use Sisimai::Mail;
    use Sisimai::Message;

    my $mailbox = Sisimai::Mail->new('/var/mail/root');
    while( my $r = $mailbox->read ) {
        my $p = Sisimai::Message->rise('data' => $r);
    }

    my $notmail = '/home/neko/Maildir/cur/22222';       # is not a bounce email
    my $mailobj = Sisimai::Mail->new($notmail);
    while( my $r = $mailobj->read ) {
        my $p = Sisimai::Message->rise('data' => $r);   # $p is "undef"
    }

=head1 DESCRIPTION

C<Sisimai::Message> converts the bounce email text to the data structure. It resolves the email text
into the UNIX From line, the header part of the mail, the delivery status, and RFC822 header part lines.
When the email given as a argument of C<new()> method is not a bounce email, the method returns C<undef>.

=head1 CLASS METHODS

=head2 C<B<rise(I<Hash reference>)>>

C<rise()> method is a constructor of C<Sisimai::Message>

    my $mailtxt = 'Entire email text';
    my $message = Sisimai::Message->rise('data' => $mailtxt);

=head1 INSTANCE METHODS

=head2 C<B<(from)>>

C<from()> method returns the UNIX From line of the email.

    print $message->from;

=head2 C<B<header()>>

C<header()> method returns the header part of the email.

    print $message->header->{'subject'};    # Returned mail: see transcript for details

=head2 C<B<ds()>>

C<ds()> method returns an array reference which include contents of the delivery status.

    for my $e ( $message->ds->@* ) {
        print $e->{'status'};   # 5.1.1
        print $e->{'recipient'};# neko@example.jp
    }

=head2 C<B<rfc822()>>

C<rfc822()> method returns a hash reference which include the header part of the original message.

    print $message->rfc822->{'from'};   # cat@example.com
    print $message->rfc822->{'to'};     # neko@example.jp

=head2 C<B<catch()>>

C<catch()> method returns any data generated by user-defined method passed at the C<c___> argument
of C<new()> constructor.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

