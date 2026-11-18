package MIME::Decoder::Base64;
use strict;
use warnings;


=head1 NAME

MIME::Decoder::Base64 - encode/decode a "base64" stream


=head1 SYNOPSIS

A generic decoder object; see L<MIME::Decoder> for usage.


=head1 DESCRIPTION

A L<MIME::Decoder> subclass for the C<"base64"> encoding.
The name was chosen to jibe with the pre-existing MIME::Base64
utility package, which this class actually uses to translate each chunk.

=over 4

=item *

When B<decoding>, the input is read one line at a time.
The input accumulates in an internal buffer, which is decoded in
multiple-of-4-sized chunks (plus a possible "leftover" input chunk,
of course).

=item *

When B<encoding>, the input is read 6840 (120 * 57) bytes at a time.
Each section of 57 bytes is encoded as a line containing 76 Base64
characters.

=item *

Some software produces Base64 parts that consist of concatentated
Base64-encoded streams.  While this is not correct according to
RFC 2045, some clients will decode all of the streams and concatenate
the results.  MIME::Decoder::Base64 copies this behavior when decoding.

=back

=head1 SEE ALSO

L<MIME::Decoder>

=head1 AUTHOR

Eryq (F<eryq@zeegee.com>), ZeeGee Software Inc (F<http://www.zeegee.com>).

All rights reserved.  This program is free software; you can redistribute 
it and/or modify it under the same terms as Perl itself.

=cut

use vars qw(@ISA $VERSION);
use MIME::Decoder;
use MIME::Base64 2.04;    
use MIME::Tools qw(debug);

@ISA = qw(MIME::Decoder);

### The package version, both in 1.23 style *and* usable by MakeMaker:
$VERSION = "5.522";

### How many bytes to encode at a time (must be a multiple of 3)
my $EncodeChunkLength = 120 * 57;

### How many bytes to decode at a time?
my $DecodeChunkLength = 32 * 1024;

#------------------------------
#
# decode_it IN, OUT
#
sub decode_it {
    my ($self, $in, $out) = @_;
    my $len_4xN;

    ### Create a suitable buffer:
    my $buffer = ' ' x (120 + $DecodeChunkLength); $buffer = '';
    debug "in = $in; out = $out";

    ### Get chunks until done:
    local($_) = ' ' x $DecodeChunkLength;    
    while ($in->read($_, $DecodeChunkLength)) {
	tr{A-Za-z0-9+/=}{}cd;        ### get rid of non-base64 chars, but '='

	### Concat any new input onto any leftover from the last round:
	$buffer .= $_;

	### Decode every stream that is all here:
	while ($len_4xN = _decodable_stream_length(\$buffer)) {
	    $out->print(decode_base64(substr($buffer, 0, $len_4xN, '')));
	}
    }

    ### No more input remains.  Dispose of anything left in buffer:
    ### Pad to 4-byte multiple, and decode:
    $buffer .= "===";                ### need no more than 3 pad chars

    ### Decode it!
    while ($len_4xN = _decodable_stream_length(\$buffer)) {
	$out->print(decode_base64(substr($buffer, 0, $len_4xN, '')));
    }
    1;
}

#------------------------------
#
# _decodable_stream_length BUFREF
#
# How much of $$BUFREF can be decoded in one go: a whole base64 stream when
# it holds a padding, else the largest multiple of 4 bytes.
#   0 means not enough to work with... get more data!
#
# A part may carry several base64 streams in a row, each ended by its own
# '=' padding, and mainstream MUAs decode them in turn.  decode_base64()
# never looks past a '=', so each padding must end one call and start the
# next.
#
sub _decodable_stream_length {
    my ($bufref) = @_;           ### by reference: called once per stream
    my ($pos_eq, $end_eq);

    ### No padding in sight: extract substring with highest multiple of 4
    ### bytes, and leave the remainder for next time around:
    $pos_eq = index($$bufref, '=');
    return length($$bufref) & ~3 if $pos_eq < 0;

    ### A padding ends the group it sits in, and that group ends the stream;
    ### if that group is not all here yet, wait for the rest of it:
    $end_eq = ($pos_eq | 3) + 1;
    return $end_eq <= length($$bufref) ? $end_eq : 0;
}

#------------------------------
#
# encode_it IN, OUT
#
sub encode_it {
    my ($self, $in, $out) = @_;
    my $encoded;

    my $nread;
    my $buf = '';
    my $nl = $MIME::Entity::BOUNDARY_DELIMITER || "\n";
    while ($nread = $in->read($buf, $EncodeChunkLength)) {
	$encoded = encode_base64($buf, $nl);
	$encoded .= $nl unless ($encoded =~ /$nl\Z/);   ### ensure newline!
	$out->print($encoded);
    }
    1;
}

#------------------------------
1;

