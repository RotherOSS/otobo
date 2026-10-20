package Sisimai::Reason::OnHold;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::Re___1 }
sub description { 'Sisimai could not decided the reason due to there is no (or less) detailed information for judging the reason' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    return 0;
}

sub true  {
    # On hold, Could not decide the bounce reason...
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: Status code is "OnHold"
    #                                   0: is not "OnHold"
    # @since v4.1.28
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0; return 0 unless $argvs->{'deliverystatus'};

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::Re___1;
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq $Sisimai::Eb::Re___1;
    return 0
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::OnHold - Bounce reason is C<OnHold> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::OnHold;
    print Sisimai::Reason::OnHold->match; # 0

=head1 DESCRIPTION

C<Sisimai::Reason::OnHold> checks the bounce reason is C<OnHold> or not. This class is called only
C<Sisimai::Reason> class. Sisimai will set C<OnHold> to the reason of email bounce if there is no
(or less) detailed information about email bounce for judging the reason.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<OnHold>.

    print Sisimai::Reason::OnHold->text;  # OnHold

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::OnHold->match; # 0;

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<OnHold>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

