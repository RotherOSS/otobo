package Sisimai::Reason::Suppressed;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReSTOP }
sub description { "Email was not delivered due to being listed in the suppression list of MTA" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.2.0
    return 0;
}

sub true {
    # Whether the address is is the suppression list or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: The address is in the suppression list
    #                                   0: is not in the suppression list
    # @since v5.2.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReSTOP;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Suppressed - Bounce reason is C<Suppressed> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::Suppressed;
    print Sisimai::Reason::Suppressed->match('address neko@example.jp in the suppression list'); # 1

=head1 DESCRIPTION

C<Sisimai::Reason::Suppressed> checks the bounce reason is C<Suppressed> or not. This class is called
only C<Sisimai::Reason> class.

This is the error that the recipient adddress is listed in the suppression list of the relay server,
and was not delivered.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<Suppressed>.

    print Sisimai::Reason::Suppressed->text;  # Suppressed

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::Suppressed->match('address cat@example.jp is in the suppression list'); # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<Suppressed>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

