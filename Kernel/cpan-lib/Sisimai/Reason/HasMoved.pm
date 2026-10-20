package Sisimai::Reason::HasMoved;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReMOVE }
sub description { "Email rejected due to user's mailbox has moved and is not forwarded automatically" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.25
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [' has been replaced by '];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Whether the address has moved or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: The address has moved
    #                                   0: Has not moved
    # @since v4.1.25
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    require Sisimai::SMTP::Command;
    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReMOVE;
    return 0 if grep { $argvs->{'command'} eq $_ } Sisimai::SMTP::Command->BeforeRCPT->@*;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::HasMoved - Bounce reason is C<HasMoved> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::HasMoved;
    print Sisimai::Reason::HasMoved->match('address neko@example.jp has been replaced by ...');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::HasMoved> checks the bounce reason is C<HasMoved> or not. This class is called
only C<Sisimai::Reason> class.

This is the error that the user's mailbox has moved (and is not forwarded automatically). Sisimai
will set C<HasMoved> to the reason of the email bounce if the value of the C<Status:> field in the
bounce email is C<5.1.6>.

    <kijitora@example.go.jp>: host mx1.example.go.jp[192.0.2.127] said: 550 5.1.6 recipient
        no longer on server: kijitora@example.go.jp (in reply to RCPT TO command)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<HasMoved>.

    print Sisimai::Reason::HasMoved->text;  # HasMoved

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::HasMoved->match('address cat@example.jp has been replaced by ');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<HasMoved>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016,2018,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

