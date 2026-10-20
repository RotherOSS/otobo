package Sisimai::Reason::SystemFull;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReDISK }
sub description { "Email rejected due to a destination mail server's disk is full" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        'exceeded storage allocation',   # MS Exchange
        'mail system full',
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is system full or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is system full
    #                                   0: is not system full
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SystemFull - Bounce reason is C<SystemFull> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SystemFull;
    print Sisimai::Reason::SystemFull->match('Mail System Full');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::SystemFull> checks the bounce reason is C<SystemFull> or not. This class is called
only C<Sisimai::Reason> class.

This is the error that the destination mail server's storage (or spool) is full. Sisimai will set
C<SystemFull> to the reason of email bounce if the value of C<Status:> field in a bounce email is
C<4.3.1> or C<5.3.1>.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<SystemFull>.

    print Sisimai::Reason::SystemFull->text;  # SystemFull

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::SystemFull->match('Mail System Full');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<SystemFull>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

