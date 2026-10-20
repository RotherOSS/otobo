package Sisimai::RFC2045;
use feature ':5.10';
use strict;
use warnings;
use Encode;
use MIME::Base64 ();
use MIME::QuotedPrint ();
use Sisimai::String;

sub is_encoded {
    # Check that the argument is MIME-Encoded string or not
    # @param    [String] argv0  String to be checked
    # @return   [Boolean]       0: Not MIME encoded string
    #                           1: MIME encoded string
    my $class = shift;
    my $argv0 = shift || return undef;
    my $text1 = $$argv0; $text1 =~ y/"//d;
    my @piece = ($text1);
    my $mime1 = 0;

    # Multiple MIME-Encoded strings in a line
    @piece = split(' ', $text1) if rindex($text1, ' ') > -1;
    while( my $e = shift @piece ) {
        # Check all the string in the array
        next unless $e =~ /[ \t]*=[?][-_0-9A-Za-z]+[?][BbQq][?].+[?]=?[ \t]*/;
        $mime1 = 1;
    }
    return $mime1;
}

sub decodeH {
    # Decode MIME-Encoded string in an email header
    # @param    [Array] argvs   Reference to an array including MIME-Encoded text
    # @return   [String]        MIME-Decoded text
    my $class = shift;
    my $argvs = shift || return '';

    my $ctxcharset = '';
    my $qbencoding = '';
    my @textblocks;

    while( my $e = shift @$argvs ) {
        # Check and decode each element
        s/\A[ \t]+//g, s/[ \t]+\z//g, y/"//d for $e;

        if( __PACKAGE__->is_encoded(\$e) ) {
            # =?utf-8?B?55m954yr44Gr44KD44KT44GT?=
            next unless $e =~ m{\A(.*)=[?]([-_0-9A-Za-z]+)[?]([BbQq])[?](.+)[?]=?(.*)\z};
            $ctxcharset ||= lc $2;
            $qbencoding ||= uc $3;

            push @textblocks, $1;
            push @textblocks, $qbencoding eq 'B'
                ? MIME::Base64::decode($4)
                : MIME::QuotedPrint::decode($4);
            $textblocks[-1] =~ y/\r\n//d;
            push @textblocks, $5;

        } else {
            push @textblocks, scalar @textblocks ? ' '.$e : $e;
        }
    }
    return '' unless scalar @textblocks;

    my $p = join('', @textblocks);
    if( $ctxcharset && $qbencoding ) {
        # utf-8 => utf8
        $ctxcharset = 'utf8' if $ctxcharset eq 'utf-8';

        unless( $ctxcharset eq 'utf8' ) {
            # Characterset is not UTF-8
            eval { Encode::from_to($p, $ctxcharset, 'utf8') };
            $p = 'FAILED TO CONVERT THE SUBJECT' if $@;
        }
    }
    return $p;
}

sub decodeB {
    # Decode MIME BASE64 Encoded string
    # @param    [String] argv0   MIME Encoded text
    # @return   [String]         MIME-Decoded text
    my $class = shift;
    my $argv0 = shift // return undef;

    my $p = $$argv0 =~ m|([+/=0-9A-Za-z\r\n]+)| ? MIME::Base64::decode($1) : '';
    return \$p;
}

sub decodeQ {
    # Decode MIME Quoted-Printable Encoded string
    # @param    [String] argv0  Entire MIME-Encoded text
    # @param    [String] argv1  The value of Content-Type: header
    # @return   [String]        MIME Decoded text
    my $class = shift;
    my $argv0 = shift // return undef;

    my $p = MIME::QuotedPrint::decode($$argv0) || '';
    return \$p;
}

sub parameter {
    # Find a value of specified field name from Content-Type: header
    # @param    [String] argv0  The value of Content-Type: header
    # @param    [String] argv1  Lower-cased attribute name of the parameter
    # @return   [String]        The value of the parameter
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift || return undef;
    my $argv1 = shift || '';

    my $parameterq = length $argv1 > 0 ? $argv1.'=' : '';
    my $paramindex = length $argv1 > 0 ? index($argv0, $parameterq) : 0;
    return '' if $paramindex == -1;

    # Find the value of the parameter name specified in $argv1
    my $foundtoken =  [split(';', substr($argv0, $paramindex + length($parameterq)), 2)]->[0];
       $foundtoken =  lc $foundtoken unless $argv1 eq 'boundary';
       $foundtoken =~ y/"'//d;
    return $foundtoken;
}

sub boundary {
    # Get a boundary string
    # @param    [String]  argv0 The value of Content-Type header
    # @param    [Integer] start -1: boundary string itself
    #                            0: Start of boundary
    #                            1: End of boundary
    # @return   [String] Boundary string
    my $class = shift;
    my $argv0 = shift || return undef;
    my $start = shift // -1;
    my $btext = __PACKAGE__->parameter($argv0, 'boundary') || return '';

    # Content-Type: multipart/mixed; boundary=Apple-Mail-5--931376066
    # Content-Type: multipart/report; report-type=delivery-status;
    #    boundary="n6H9lKZh014511.1247824040/mx.example.jp"
    $btext =  '--'.$btext if $start > -1;
    $btext =  $btext.'--' if $start >  0;
    return $btext;
}

sub haircut {
    # Cut header fields except Content-Type, Content-Transfer-Encoding from multipart/* block
    # @param    [String] block  multipart/* block text
    # @param    [Boolean] heads 1 = Returns only Content-(Type|Transfer-Encoding) headers
    # @return   [Array]         Two headers and body part of multipart/* block
    # @since v5.0.0
    my $class = shift;
    my $block = shift // return undef;
    my $heads = shift // undef;

    my($upperchunk, $lowerchunk) = split("\n\n", $$block, 2);
    return ['', ''] unless $upperchunk;
    return ['', ''] unless index($upperchunk, 'Content-Type:') > -1;

    my $headerpart = ['', ''];  # ["text/plain; charset=iso-2022-jp; ...", "quoted-printable"]
    my $multipart1 = [];        # [@$headerpart, "body"]

    for my $e ( split("\n", $upperchunk) ) {
        # Remove fields except Content-Type:, and Content-Transfer-Encoding: in each part
        # of multipart/* block such as the following:
        #   Date: Thu, 29 Apr 2018 22:22:22 +0900
        #   MIME-Version: 1.0
        #   Message-ID: ...
        #   Content-Transfer-Encoding: quoted-printable
        #   Content-Type: text/plain; charset=us-ascii
        if( index($e, 'Content-Type:') == 0 ) {
            # Content-Type: ***
            my $v = [split(' ', $e, 2)]->[-1];
            $headerpart->[0] = index($v, 'boundary=') > -1 ? $v : lc $v;

        } elsif( index($e, 'Content-Transfer-Encoding:') == 0 ) {
            # Content-Transfer-Encoding: ***
            $headerpart->[1] = lc [split(' ', $e, 2)]->[-1];

        } elsif( index($e, 'boundary=') > -1 || index($e, 'charset=') > -1 ) {
            # "Content-Type" field has boundary="..." or charset="utf-8"
            next unless length $headerpart->[0];
            $headerpart->[0] .= " ".$e;
            $headerpart->[0] =~ s/\s\s+/ /g;
        }
    }
    return $headerpart if $heads;

    my $mediatypev = lc $headerpart->[0];
    my $ctencoding = $headerpart->[1];
    push @$multipart1, @$headerpart, '';

    UPPER: while(1) {
        # Make a body part at the 2nd element of $multipart1
        $multipart1->[2] = sprintf("Content-Type: %s\n", $headerpart->[0]);

        # Do not append Content-Transfer-Encoding: header when the part is the original message:
        # Content-Type is message/rfc822 or text/rfc822-headers, or message/delivery-status or
        # message/feedback-report
        last if index($mediatypev, '/rfc822') > -1;
        last if index($mediatypev, '/delivery-status') > -1;
        last if index($mediatypev, '/feedback-report') > -1;
        last if length $ctencoding == 0;

        $multipart1->[2] .= sprintf("Content-Transfer-Encoding: %s\n", $ctencoding);
        last;
    }

    LOWER: while(1) {
        # Append LF before the lower chunk into the 2nd element of $multipart1
        last if length $lowerchunk == 0;
        last if substr($lowerchunk, 0, 1) eq "\n";

        $multipart1->[2] .= "\n";
        last;
    }
    $multipart1->[2] .= $lowerchunk;
    return $multipart1;
}

sub levelout {
    # Split argv1: multipart/* blocks by a boundary string in argv0
    # @param    [String] argv0  The value of Content-Type header
    # @param    [String] argv1  A pointer to multipart/* message blocks
    # @return   [Array]         List of each part of multipart/*
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift || return [];
    my $argv1 = shift || return [];

    return [] unless length $argv0;
    return [] unless length $$argv1;

    my $boundary01 = __PACKAGE__->boundary($argv0, 0) || return [];
    my $multiparts = [split(/\Q$boundary01\E\n/, $$argv1)];
    my $partstable = [];

    # Remove empty or useless preamble and epilogue of multipart/* block
    shift @$multiparts if length $multiparts->[0]  < 8;
    pop   @$multiparts if length $multiparts->[-1] < 8;

    while( my $e = shift @$multiparts ) {
        # Check each part and breaks up internal multipart/* block
        my $f = __PACKAGE__->haircut(\$e);
        if( index($f->[0], 'multipart/') > -1 ) {
            # There is nested multipart/* block
            my $boundary02 = __PACKAGE__->boundary($f->[0], -1) || next;
            my $bodyinside = [split(/\n\n/, $f->[-1], 2)]->[-1];
            next unless length $bodyinside > 8;
            next unless index($bodyinside, $boundary02) > -1;

            my $v = __PACKAGE__->levelout($f->[0], \$bodyinside);
            push @$partstable, @$v if scalar @$v;

        } else {
            # The part is not a multipart/* block
            my $b = length $f->[-1] ? $f->[-1] : $e;
            my $v = [$f->[0], $f->[1], length $f->[0] ? [split("\n\n", $b, 2)]->[-1] : $b];
            push @$partstable, $v;
        }
    }
    return [] unless scalar @$partstable;

    # Remove $boundary01.'--' and strings from the boundary to the end of the body part.
    chomp $boundary01;
    my $b = $partstable->[-1]->[2];
    my $p = index($b, $boundary01.'--');
    substr($partstable->[-1]->[2], $p, length $b, "") if $p > -1;

    return $partstable;
}

sub makeflat {
    # Make flat multipart/* part blocks and decode
    # @param    [String] argv0  The value of Content-Type header
    # @param    [String] argv1  A pointer to multipart/* message blocks
    # @return   [String]        Message body
    my $class = shift;
    my $argv0 = shift // return undef;
    my $argv1 = shift // return undef;

    return \'' unless index($argv0, 'multipart/') > -1;
    return \'' unless index($argv0, 'boundary=')  > -1;

    my $iso2022set = qr/charset=["']?(iso-2022-[-a-z0-9]+)['"]?\b/;
    my $multiparts = __PACKAGE__->levelout($argv0, $argv1);
    my $flattenout = '';

    while( my $e = shift @$multiparts ) {
        # Pick only the following parts Sisimai::Lhost will use, and decode each part
        # - text/plain, text/rfc822-headers
        # - message/delivery-status, message/rfc822, message/partial, message/feedback-report
        my $istexthtml = 0;
        my $mediatypev = __PACKAGE__->parameter($e->[0]) || 'text/plain';
        next if index($mediatypev, 'text/') != 0 && index($mediatypev, 'message/') != 0;

        if( $mediatypev eq 'text/html' ) {
            # Skip text/html part when the value of Content-Type: header in an internal part of
            # multipart/* includes multipart/alternative;
            next if index($argv0, 'multipart/alternative') > -1;
            $istexthtml = 1;
        }
        my $ctencoding = $e->[1] || '';
        my $bodyinside = $e->[2];
        my $bodystring = '';

        if( length $ctencoding ) {
            # Check the value of Content-Transfer-Encoding: header
            if( $ctencoding eq 'base64' ) {
                # Content-Transfer-Encoding: base64
                $bodystring = __PACKAGE__->decodeB(\$bodyinside)->$*;

            } elsif( $ctencoding eq 'quoted-printable') {
                # Content-Transfer-Encoding: quoted-printable
                $bodystring = __PACKAGE__->decodeQ(\$bodyinside)->$*;

            } elsif( $ctencoding eq '7bit' ) {
                # Content-Transfer-Encoding: 7bit
                if( lc $e->[0] =~ $iso2022set ) {
                    # Content-Type: text/plain; charset=ISO-2022-JP
                    $bodystring = Sisimai::String->to_utf8(\$bodyinside, $1)->$*;

                } else {
                    # No "charset" parameter in the value of Content-Type: header
                    $bodystring = $bodyinside;
                }
            } else {
                # Content-Transfer-Encoding: 8bit, binary, and so on
                $bodystring = $bodyinside;
            }

            # Try to delete HTML tags inside of text/html part whenever possible
            $bodystring = Sisimai::String->to_plain(\$bodystring)->$* if $istexthtml;
            next unless $bodystring;
            $bodystring =~ s|\r\n|\n|g if index($bodystring, "\r\n") > -1;    # Convert CRLF to LF

        } else {
            # There is no Content-Transfer-Encoding header in the part
            $bodystring .= $bodyinside;
        }

        if( index($mediatypev, '/delivery-status') > -1 ||
            index($mediatypev, '/feedback-report') > -1 ||
            index($mediatypev, '/rfc822')          > -1 ) {
            # Add Content-Type: header of each part (will be used as a delimiter at Sisimai::Lhost) into
            # the body inside when the value of Content-Type: is message/delivery-status, message/rfc822,
            # or text/rfc822-headers
            $bodystring = sprintf("Content-Type: %s\n%s", $mediatypev, $bodystring);
        }

        # Append "\n" when the last character of $bodystring is not LF
        $bodystring .= "\n\n" unless substr($bodystring, -2, 2) eq "\n\n";
        $flattenout .= $bodystring;
    }
    return \$flattenout;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::RFC2045 - MIME Utilities

=head1 SYNOPSIS

    use Sisimai::RFC2045;

    my $e = '=?utf-8?B?55m954yr44Gr44KD44KT44GT?=';
    my $v = Sisimai::RFC2045->is_encoded(\$e);
    print $v;   # 1

    my $x = Sisimai::RFC2045->decodeH([$e]);
    print $x;

=head1 DESCRIPTION

Sisimai::RFC2045 is MIME Utilities for C<Sisimai>, is formerly known as C<Sisimai::MIME>.

=head1 CLASS METHODS

=head2 C<B<is_encoded(I<Scalar Reference>)>>

C<is_encoded()> returns that the argument is MIME-Encoded string or not.

    my $e = '=?utf-8?B?55m954yr44Gr44KD44KT44GT?=';
    my $v = Sisimai::RFC2045->is_encoded(\$e);  # 1

=head2 C<B<decodeH(I<Array-Ref>)>>

C<decodeH()> is a decoder method for getting the original string from MIME-Encoded string in email
headers.

    my $r = '=?utf-8?B?55m954yr44Gr44KD44KT44GT?=';
    my $v = Sisimai::RFC2045->decodeH([$r]);

=head2 C<B<decodeB(I<\String>)>>

C<decodeB> is a decoder method for getting the original string from MIME Base64 encoded string.

    my $r = '44Gr44KD44O844KT';
    my $v = Sisimai::RFC2045->decodeB(\$r);

=head2 C<B<decodeQ(I<\String>)>>

C<decodeQ> is a decoder method for getting the original string from MIME quoted-printable encoded string.

    my $r = '=4e=65=6b=6f';
    my $v = Sisimai::RFC2045->decodeQ(\$r);

=head2 C<B<parameter(I<String>, I<String>)>>

C<parameter()> returns the value of parameter in Content-Type header.

    my $r = 'Content-Type: multipart/mixed; boundary=Apple-Mail-1-526612466'; charset=utf8;
    print Sisimai::RFC2045->parameter($r, 'charset');  # utf8
    print Sisimai::RFC2045->parameter($r, 'boundary'); # Apple-Mail-1-526612466
    print Sisimai::RFC2045->parameter($r);             # multipart/mixed

=head2 C<B<boundary(I<String>, I<Integer>)>>

C<boundary()> returns a boundary string from the value of Content-Type header.

    my $r = 'Content-Type: multipart/mixed; boundary=Apple-Mail-1-526612466';
    my $v = Sisimai::RFC2045->boundary($r);
    print $v;   # Apple-Mail-1-526612466

    print Sisimai::RFC2045->boundary($r, 0); # --Apple-Mail-1-526612466
    print Sisimai::RFC2045->boundary($r, 1); # --Apple-Mail-1-526612466--

=head2 C<B<haircut(I<\String>, I<Boolean>)>>

C<haircut()> remove unused headers from multipart/* block.

=head2 C<B<levelout(I<String>, I<\String>)>>

C<levelout> breaks multipart/* message block into each part and returns an array reference.

=head2 C<B<makeflat(I<String>, I<\String>)>>

C<makeflat> makes flat multipart/* message: This method breaks multipart/* block into each part, remove
parts which are not needed to parse a bounce message such as image/* MIME type, and decode an encoded
text part (text/*, message/*) in a body of each part that has C<Content-Transfer-Encoding> header and
the value of the header is quoted-printabe, base64, or 7bit.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018-2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

