package Sisimai::Rhost::Aol;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason for Aol Mail: https://www.aol.com
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                Detected bounce reason
    # @see
    # - Y!Sender Hub/SMTP Error Codes: https://senders.yahooinc.com/smtp-error-codes/
    # - The MX record of Aol points "mx-aol.mail.gm0.yahoodns.net".
    # @since v5.2.0
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReHOST => ["Host or domain name not found"],
        $Sisimai::Eb::Re00MX => ["type=MX: Malformed or unexpected name server reply"],
    };

    my $issuedcode = $argvs->{'diagnosticcode'};
    my $reasontext = '';

    for my $e ( keys %$messagesof ) {
        # Try to find the error message matches with the given error message string
        next unless grep { index($issuedcode, $_) > -1 } $messagesof->{ $e }->@*;
        $reasontext = $e;
        last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::Aol - Detect the bounce reason returned from Aol Mail: https://www.aol.com

=head1 SYNOPSIS

    use Sisimai::Rhost::Aol;

=head1 DESCRIPTION

C<Sisimai::Rhost::Aol> detects the bounce reason from the content of C<Sisimai::Fact> object as an
argument of C<find()> method when the value of C<rhost> of the object is C<*.aol.com>.
This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

