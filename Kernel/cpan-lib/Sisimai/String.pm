package Sisimai::String;
use v5.26;
use strict;
use warnings;
use Encode;

my $EncodingsC = [qw/big5-eten gb2312/];
my $EncodingsE = [qw/iso-8859-1/];
my $EncodingsJ = [qw/7bit-jis iso-2022-jp euc-jp shiftjis/];
use Encode::Guess; Encode::Guess->add_suspects(@$EncodingsC, @$EncodingsE, @$EncodingsJ);
sub encodenames { return [@$EncodingsC, @$EncodingsE, @$EncodingsJ] };

sub is_8bit {
    # The argument is 8-bit text or not
    # @param    [String] argv1  Any string to be checked
    # @return   [Integer]       0: ASCII Characters only
    #                           1: Including 8-bit character
    my $class = shift;
    my $argv1 = shift // return 0; return 0 if ref $argv1 ne 'SCALAR';
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
    my $argv1 = shift // return "";

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
    my $argv1 = shift || return 0; return 0 unless length $$argv1;
    my $argv2 = shift || return 0; return 0 unless scalar @$argv2;
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

sub to_plain {
    # Convert given HTML text to plain text
    # @param    [Scalar]  argv1 HTML text(reference to string)
    # @param    [Integer] loose Loose check flag
    # @return   [Scalar]        Plain text(reference to string)
    my $class = shift;
    my $argv1 = shift // return undef; return undef if ref $argv1 ne 'SCALAR';
    my $loose = shift // 0;
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
        my $cv =  lc $plain;
        $plain =~ s|<head>.+?</head>||gsim      if index($cv, '</head>')  > -1;
        $plain =~ s|<style.+?>.+?</style>||gsim if index($cv, '</style>') > -1;

        s|<a\s+href\s*=\s*(['"])(https?://[^'"]+?)\1[^>]*?>(.*?)</a>| [$3]($2) |gsim,
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
    my $argv1 = shift || return "";
    my $argv2 = shift;

    state $dontencode = ['utf8', 'utf-8', 'us-ascii', 'ascii'];
    my $tobeutf8ed = $$argv1;
    my $encodefrom = lc $argv2 || '';
    my $hasencoded = 0;
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

    print Sisimai::String->is_8bit(\'猫');     # 1
    print Sisimai::String->sweep(' neko cat ');# 'neko cat'

    print Sisimai::String->to_utf8('^[$BG-^[(B', 'iso-2022-jp');  # 猫
    print Sisimai::String->to_plain('<html>neko</html>');   # neko

=head1 DESCRIPTION

C<Sisimai::String> provide utilities for dealing various strings

=head1 CLASS METHODS

=head2 C<B<is_8bit(I<Reference to String>)>>

C<is_8bit()> method checks the argument include any 8bit character or not.

    print Sisimai::String->is_8bit(\'cat');  # 0;
    print Sisimai::String->is_8bit(\'ねこ'); # 1;

=head2 C<B<sweep(I<String>)>>

C<sweep()> method clean the argument string up: remove trailing spaces, squeeze spaces.

    print Sisimai::String->sweep(' cat neko ');  # 'cat neko';
    print Sisimai::String->sweep(' nyaa   !!');  # 'nyaa !!';

C<aligned> method checks if each element of the 2nd argument is aligned in the 1st argument or not.

    my $v = 'Final-Recipient: rfc822; <nekochan@example.jp>';
    print Sisimai::String->aligned(\$v, ['rfc822', '<', '@', '>']);  # 1
    print Sisimai::String->aligned(\$v, [' <', '@', 'rfc822']);      # 0
    print Sisimai::String->aligned(\$v, ['example', '@', 'neko']);   # 0

=head2 C<B<to_plain(I<Reference to String>, [I<Loose Check>])>>

C<to_plain> method converts given string as an HTML to the plain text.

    my $v = '<html>neko</html>';
    print Sisimai::String->to_plain($v);    # neko

=head2 C<B<to_utf8(I<Reference to String>, [I<Encoding>])>>

C<to_utf8> method converts given string to UTF-8.

    my $v = '^[$BG-^[(B';   # ISO-2022-JP
    print Sisimai::String->to_utf8($v, 'iso-2022-jp');  # 猫

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2019,2021-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

