package Sisimai::Rhost::Cloudflare;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason for Cloudflare Email Routing
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                Detected bounce reason
    # @since v5.2.1
    # @see https://developers.cloudflare.com/email-routing/postmaster/
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        # - 554 <YOUR_IP_ADDRESS> found on one or more RBLs (abusixip). Refer to
        #   https://developers.cloudflare.com/email-routing/postmaster/#spam-and-abusive-traffic/
        $Sisimai::Eb::ReBLOC => ["found on one or more DNSBLs"],
        $Sisimai::Eb::RePROC => ["Upstream error"],
    };
    for my $e ( keys %$messagesof ) {
        # Try to find the error message matches with the given error message string
        return $e if grep { index($argvs->{"diagnosticcode"}, $_) > -1 } $messagesof->{ $e }->@*;
    }
    return "";
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::Cloudflare - Detect the bounce reason returned from Cloudflare Email Routing

=head1 SYNOPSIS

    use Sisimai::Rhost::Cloudflare;

=head1 DESCRIPTION

C<Sisimai::Rhost::Cloudflare> detects the bounce reason from the content of C<Sisimai::Fact> object
as an argument of C<find()> method when the value of C<rhost> of the object is C<*.mx.cloudflare.net>.
This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2025-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

