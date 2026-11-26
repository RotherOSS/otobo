package MIME::Base32;

use 5.008001;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT    = qw(encode_base32 decode_base32);
our @EXPORT_OK = qw(
    encode_rfc3548 decode_rfc3548 encode_09AV decode_09AV
    encode_base32hex decode_base32hex
);

our $VERSION = "1.303";
$VERSION = eval $VERSION;

sub encode         { return encode_base32(@_) }
sub encode_rfc3548 { return encode_base32(@_) }

sub encode_base32 {
    my $arg = shift;
    return '' unless defined($arg);    # mimic MIME::Base64

    $arg = unpack('B*', $arg);
    $arg =~ s/(.....)/000$1/g;
    my $l = length($arg);
    if ($l & 7) {
        my $e = substr($arg, $l & ~7);
        $arg = substr($arg, 0, $l & ~7);
        $arg .= "000$e" . '0' x (5 - length $e);
    }
    $arg = pack('B*', $arg);
    $arg =~ tr|\0-\37|A-Z2-7|;
    return $arg;
}

sub decode         { return decode_base32(@_) }
sub decode_rfc3548 { return decode_base32(@_) }

sub decode_base32 {
    my $arg = uc(shift || '');    # mimic MIME::Base64

    $arg =~ tr|A-Z2-7|\0-\37|;
    $arg = unpack('B*', $arg);
    $arg =~ s/000(.....)/$1/g;
    my $l = length $arg;
    $arg = substr($arg, 0, $l & ~7) if $l & 7;
    $arg = pack('B*', $arg);
    return $arg;
}

sub encode_09AV { return encode_base32hex(@_) }

sub encode_base32hex {
    my $arg = shift;
    return '' unless defined($arg);    # mimic MIME::Base64

    $arg = unpack('B*', $arg);
    $arg =~ s/(.....)/000$1/g;
    my $l = length($arg);
    if ($l & 7) {
        my $e = substr($arg, $l & ~7);
        $arg = substr($arg, 0, $l & ~7);
        $arg .= "000$e" . '0' x (5 - length $e);
    }
    $arg = pack('B*', $arg);
    $arg =~ tr|\0-\37|0-9A-V|;
    return $arg;
}

sub decode_09AV { return decode_base32hex(@_) }

sub decode_base32hex {
    my $arg = uc(shift || '');    # mimic MIME::Base64

    $arg =~ tr|0-9A-V|\0-\37|;
    $arg = unpack('B*', $arg);
    $arg =~ s/000(.....)/$1/g;
    my $l = length($arg);
    $arg = substr($arg, 0, $l & ~7) if $l & 7;
    $arg = pack('B*', $arg);
    return $arg;
}

1;

=encoding utf8

=head1 NAME

MIME::Base32 - Base32 encoder and decoder

=head1 SYNOPSIS

    #!/usr/bin/env perl
    use strict;
    use warnings;
    use MIME::Base32;

    my $encoded = encode_base32('Aladdin: open sesame');
    my $decoded = decode_base32($encoded);

=head1 DESCRIPTION

This module is for encoding/decoding data much the way that L<MIME::Base64> does.

Prior to version 1.0, L<MIME::Base32> used the C<base32hex> (or C<[0-9A-V]>) encoding and
decoding methods by default. If you need to maintain that behavior, please call
C<encode_base32hex> or C<decode_base32hex> functions directly.

Now, in accordance with L<RFC-3548, Section 5|https://tools.ietf.org/html/rfc3548#section-5>,
L<MIME::Base32> uses the C<encode_base32> and C<decode_base32> functions by default.

=head1 FUNCTIONS

The following primary functions are provided:

=head2 decode

Synonym for C<decode_base32>

=head2 decode_rfc3548

Synonym for C<decode_base32>

=head2 decode_base32

    my $string = decode_base32($encoded_data);

Decode some encoded data back into a string of text or binary data.

=head2 decode_09AV

Synonym for C<decode_base32hex>

=head2 decode_base32hex

    my $string_or_binary_data = MIME::Base32::decode_base32hex($encoded_data);

Decode some encoded data back into a string of text or binary data.

=head2 encode

Synonym for C<encode_base32>

=head2 encode_rfc3548

Synonym for C<encode_base32>

=head2 encode_base32

    my $encoded = encode_base32("some string");

Encode a string of text or binary data.

=head2 encode_09AV

Synonym for C<encode_base32hex>

=head2 encode_base32hex

    my $encoded = MIME::Base32::encode_base32hex("some string");

Encode a string of text or binary data. This uses the C<hex> (or C<[0-9A-V]>) method.

=head1 AUTHORS

Jens Rehsack - <rehsack@cpan.org> - Current maintainer

Chase Whitener

Daniel Peder - sponsored by Infoset s.r.o., Czech Republic
 - <Daniel.Peder@InfoSet.COM> http://www.infoset.com - Original author

=head1 BUGS

Before reporting any new issue, bug or alike, please check
L<https://rt.cpan.org/Dist/Display.html?Queue=MIME-Base32>,
L<https://github.com/perl5-utils/MIME-Base32/issues> or
L<https://github.com/perl5-utils/MIME-Base32/pulls>, respectively, whether
the issue is already reported.

Please report any bugs or feature requests to
C<bug-mime-base32 at rt.cpan.org>, or through the web interface at
L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=MIME-Base32>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

Any and all criticism, bug reports, enhancements, fixes, etc. are appreciated.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MIME::Base32

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<https://rt.cpan.org/Dist/Display.html?Name=MIME-Base32>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MIME-Base32>

=item * MetaCPAN

L<https://metacpan.org/release/MIME-Base32>

=back

=head1 COPYRIGHT AND LICENSE INFORMATION

Copyright (c) 2003-2010 Daniel Peder.  All rights reserved.
Copyright (c) 2015-2016 Chase Whitener.  All rights reserved.
Copyright (c) 2016 Jens Rehsack.  All rights reserved.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<MIME::Base64>, L<RFC-3548|https://tools.ietf.org/html/rfc3548#section-5>

=cut
