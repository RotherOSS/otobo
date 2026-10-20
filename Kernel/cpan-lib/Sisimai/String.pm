package Sisimai::String;
use feature ':5.10';
use strict;
use warnings;
use Encode;
use Digest::SHA;

my $EncodingsC = [qw/big5-eten gb2312/];
my $EncodingsE = [qw/iso-8859-1/];
my $EncodingsJ = [qw/7bit-jis iso-2022-jp euc-jp shiftjis/];
use Encode::Guess; Encode::Guess->add_suspects(@$EncodingsC, @$EncodingsE, @$EncodingsJ);
sub encodenames { return [@$EncodingsC, @$EncodingsE, @$EncodingsJ] };

sub token {
    # Create the message token from an addresser and a recipient
    # @param    [String] addr1  A sender's email address
    # @param    [String] addr2  A recipient's email address
    # @param    [Integer] epoch Machine time of the email bounce
    # @return   [String]        Message token(MD5 hex digest) or empty string
    #                           if the any argument is missing
    # @see       http://en.wikipedia.org/wiki/ASCII
    # @see       https://metacpan.org/pod/Digest::MD5
    my $class = shift || return '';
    my $addr1 = shift || return '';
    my $addr2 = shift || return '';
    my $epoch = shift // return '';

    # Format: STX(0x02) Sender-Address RS(0x1e) Recipient-Address ETX(0x03)
    return Digest::SHA::sha1_hex(sprintf("\x02%s\x1e%s\x1e%d\x03", lc $addr1, lc $addr2, $epoch));
}

sub is_8bit {
    # The argument is 8-bit text or not
    # @param    [String] argv1  Any string to be checked
    # @return   [Integer]       0: ASCII Characters only
    #                           1: Including 8-bit character
    my $class = shift;
    my $argv1 = shift // return undef;

    return undef unless ref $argv1 eq 'SCALAR';
    return 1 unless $$argv1 =~ /\A[\x00-\x7f]+\z/;
    return 0;
}

sub sweep {
    # Clean the string out
    # @param    [String] argv1  String to be cleaned
    # @return   [Scalar]        Cleaned out string
    # @example  Clean up text
    #   sweep('  neko ') #=> 'neko'
    my $class = shift;
    my $argv1 = shift // return undef;

    chomp $argv1;
    y/ //s, s/\A //g, s/ \z//g, s/ [-]{2,}[^ ].+\z// for $argv1;
    return $argv1;
}

sub aligned {
    # Check if each element of the 2nd argument is aligned in the 1st argument or not
    # @param    [String] argv1  String to be checked
    # @param    [Array]  argv2  List including the ordered strings
    # @return   [Bool]          0, 1
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift || return undef; return undef unless length $$argv1;
    my $argv2 = shift || return undef; return undef unless scalar @$argv2;
    my $align = -1;
    my $right =  0;

    for my $e ( @$argv2 ) {
        # Get the position of each element in the 1st argument using index()
        my $p = index($$argv1, $e, $align + 1);

        last if $p < 0;                 # Break this loop when there is no string in the 1st argument
        $align = length($e) + $p - 1;   # There is an aligned string in the 1st argument
        $right++;
    }
    return 1 if $right == scalar @$argv2;
    return 0;
}

sub ipv4 {
    # Find an IPv4 address from the given string
    # @param    [String] argv1  String including an IPv4 address
    # @return   [Array]         List of IPv4 addresses
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift || return undef; return [] if length $argv0 < 7;
    my $ipv4a = [];

    for my $e ( '(', ')', '[', ']' ) {
        # Rewrite: "mx.example.jp[192.0.2.1]" => "mx.example.jp 192.0.2.1"
        my $p0 = index($argv0, $e); next if $p0 < 0;
        substr($argv0, $p0, 1, ' ');
    }

    IP4A: for my $e ( split(' ', $argv0) ) {
        # Find string including an IPv4 address
        next if index($e, '.') == -1;   # IPv4 address must include "." character

        my $lx = length $e; next if $lx < 7 || $lx > 17; # 0.0.0.0 = 7, [255.255.255.255] = 17
        my $cu = 0;     # Cursor for seeking each octet of an IPv4 address
        my $as = '';    # ASCII Code of each character
        my $eo = '';    # Buffer of each octet of IPv4 Address

        while( $cu < $lx ) {
            # Check whether each character is a number or "." or not
            $as = ord substr($e, $cu++, 1);
            if( $as < 48 || $as > 57 ) {
                # The character is not a number(0-9)
                next IP4A if     $as != 46; # The character is not "."
                next      if     $eo eq ''; # The current buffer is empty
                next IP4A if int $eo > 255; # The current buffer is greater than 255
                $eo = '';
                next;
            }
            $eo .= chr $as;
            next IP4A if int $eo > 255;
        }
        push @$ipv4a, $e;
    }
    return $ipv4a;
}

sub to_plain {
    # Convert given HTML text to plain text
    # @param    [Scalar]  argv1 HTML text(reference to string)
    # @param    [Integer] loose Loose check flag
    # @return   [Scalar]        Plain text(reference to string)
    my $class = shift;
    my $argv1 = shift // return \'';
    my $loose = shift // 0;
    return \'' unless ref $argv1 eq 'SCALAR';

    my $plain = $$argv1;
    state $match = {
        'html' => qr|<html[ >].+?</html>|sim,
        'body' => qr|<head>.+</head>.*<body[ >].+</body>|sim,
    };

    if( $loose || $plain =~ $match->{'html'} || $plain =~ $match->{'body'} ) {
        # <html> ... </html>
        # 1. Remove <head>...</head>
        # 2. Remove <style>...</style>
        # 3. <a href = 'http://...'>...</a> to " http://... "
        # 4. <a href = 'mailto:...'>...</a> to " Value <mailto:...> "
        s|<head>.+</head>||gsim,
        s|<style.+?>.+</style>||gsim,
        s|<a\s+href\s*=\s*['"](https?://.+?)['"].*?>(.*?)</a>| [$2]($1) |gsim,
        s|<a\s+href\s*=\s*["']mailto:([^\s]+?)["']>(.*?)</a>| [$2](mailto:$1) |gsim,
        s/<[^<@>]+?>\s*/ /g,    # Delete HTML tags except <neko@example.jp>
        s/&lt;/</g,             # Convert to left angle brackets
        s/&gt;/>/g,             # Convert to right angle brackets
        s/&amp;/&/g,            # Convert to "&"
        s/&quot;/"/g,           # Convert to '"'
        s/&apos;/'/g,           # Convert to "'"
        s/&nbsp;/ /g for $plain;

        if( length($$argv1) > length($plain) ) {
            $plain =~ y/ //s;
            $plain .= "\n"
        }
    }
    return \$plain;
}

sub to_utf8 {
    # Convert given string to UTF-8
    # @param    [String] argv1  String to be converted
    # @param    [String] argv2  Encoding name before converting
    # @return   [String]        UTF-8 Encoded string
    my $class = shift;
    my $argv1 = shift || return \'';
    my $argv2 = shift;

    state $dontencode = ['utf8', 'utf-8', 'us-ascii', 'ascii'];
    my $tobeutf8ed = $$argv1;
    my $encodefrom = lc $argv2 || '';
    my $hasencoded = undef;
    my $hasguessed = Encode::Guess->guess($tobeutf8ed);
    my $encodingto = ref $hasguessed ? lc($hasguessed->name) : '';

    if( $encodefrom ) {
        # The 2nd argument is a encoding name of the 1st argument
        while(1) {
            # Encode a given string when the encoding of the string is neigther
            # utf8 nor ascii.
            last if grep { $encodefrom eq $_ } @$dontencode;
            last if grep { $encodingto eq $_ } @$dontencode;

            eval {
                # Try to convert the string to UTF-8
                Encode::from_to($tobeutf8ed, $encodefrom, 'utf8');
                $hasencoded = 1;
            };
            last;
        }
    }
    return \$tobeutf8ed if $hasencoded;
    return \$tobeutf8ed unless $encodingto;
    return \$tobeutf8ed if grep { $encodingto eq $_ } @$dontencode;

    # a. The 2nd argument was not given or failed to convert from $encodefrom to UTF-8
    # b. Guessed encoding name is available, try to encode using it.
    # c. Encode a given string when the encoding of the string is neigther utf8 nor ascii.
    eval { Encode::from_to($tobeutf8ed, $encodingto, 'utf8') };
    return \$tobeutf8ed;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::String - String related class

=head1 SYNOPSIS

    use Sisimai::String;
    my $s = 'envelope-sender@example.jp';
    my $r = 'envelope-recipient@example.org';
    my $t = time();

    print Sisimai::String->token($s, $r, $t);  # 2d635de42a44c54b291dda00a93ac27b
    print Sisimai::String->is_8bit(\'猫');     # 1
    print Sisimai::String->sweep(' neko cat ');# 'neko cat'

    print Sisimai::String->to_utf8('^[$BG-^[(B', 'iso-2022-jp');  # 猫
    print Sisimai::String->to_plain('<html>neko</html>');   # neko

=head1 DESCRIPTION

Sisimai::String provide utilities for dealing string

=head1 CLASS METHODS

=head2 C<B<token(I<sender>, I<recipient>)>>

C<token()> generates a token: Unique string generated by an envelope sender address and a envelope
recipient address.

    my $s = 'envelope-sender@example.jp';
    my $r = 'envelope-recipient@example.org';

    print Sisimai::String->token($s, $r);    # 2d635de42a44c54b291dda00a93ac27b

=head2 C<B<is_8bit(I<Reference to String>)>>

C<is_8bit()> checks the argument include any 8bit character or not.

    print Sisimai::String->is_8bit(\'cat');  # 0;
    print Sisimai::String->is_8bit(\'ねこ'); # 1;

=head2 C<B<sweep(I<String>)>>

C<sweep()> clean the argument string up: remove trailing spaces, squeeze spaces.

    print Sisimai::String->sweep(' cat neko ');  # 'cat neko';
    print Sisimai::String->sweep(' nyaa   !!');  # 'nyaa !!';

C<aligned> checks if each element of the 2nd argument is aligned in the 1st argument or not.

    my $v = 'Final-Recipient: rfc822; <nekochan@example.jp>';
    print Sisimai::String->aligned(\$v, ['rfc822', '<', '@', '>']);  # 1
    print Sisimai::String->aligned(\$v, [' <', '@', 'rfc822']);      # 0
    print Sisimai::String->aligned(\$v, ['example', '@', 'neko']);   # 0

=head2 C<B<ipv4(I<String>)>>

C<ipv4> return all the IPv4 address found in the given string.

    my $v = "connection refused from 192.0.2.1, DNSBL returned 127.0.0.2";
    my $p = Sisimai::String->ipv4($v); # ["192.0.2.1", "127.0.0.2"]

=head2 C<B<to_plain(I<Reference to String>, [I<Loose Check>])>>

C<to_plain> converts given string as HTML to plain text.

    my $v = '<html>neko</html>';
    print Sisimai::String->to_plain($v);    # neko

=head2 C<B<to_utf8(I<Reference to String>, [I<Encoding>])>>

C<to_utf8> converts given string to UTF-8.

    my $v = '^[$BG-^[(B';   # ISO-2022-JP
    print Sisimai::String->to_utf8($v, 'iso-2022-jp');  # 猫


=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2019,2021-2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
