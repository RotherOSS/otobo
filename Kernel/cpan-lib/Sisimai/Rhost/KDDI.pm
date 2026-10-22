package Sisimai::Rhost::KDDI;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from au(KDDI)
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason au.com and ezweb.ne.jp
    # @since v4.22.6
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReFILT => '550 : user unknown',  # The response was: 550 : User unknown
        $Sisimai::Eb::ReUSER => '>: user unknown',     # The response was: 550 <...>: User unknown
    };
    my $issuedcode = lc $argvs->{'diagnosticcode'};
    my $reasontext = '';

    for my $e ( keys %$messagesof ) {
        # Try to match the error message with message patterns defined in $MessagesOf
        next unless rindex($issuedcode, $messagesof->{ $e }) > -1;
        $reasontext = $e;
        last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::KDDI - Detect the bounce reason returned from au (KDDI).

=head1 SYNOPSIS

    use Sisimai::Rhost::KDDI;

=head1 DESCRIPTION

C<Sisimai::Rhost::KDDI> detects the bounce reason from the content of C<Sisimai::Fact> object as an
argument of C<find()> method when the value of C<rhost> of the object is C<msmx.au.com> or C<lsean.ezweb.ne.jp>.
This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2018,2020,2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

