package Sisimai::Reason::NotCompliantRFC;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReNRFC }
sub description { "Email rejected due to non-compliance with RFC" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "duplicate header",
        "duplicated message-id",
        "message is not rfc 5322 compliant",
        "multiple addresses in from: header are not accepted",
        "rfc 1035 violation",
        "https://support.google.com/mail/?p=rfcmessagenoncompliant",
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Whether the email is RFC compliant or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: RFC compliant
    #                                   0: Is not RFC compliant
    # @since v5.0.0
    # @see http://www.ietf.org/rfc/rfc5322.txt
    my $class = shift;
    my $argvs = shift // return 0;

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReNRFC;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::NotCompliantRFC - Bounce reason is C<NotCompliantRFC> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::NotCompliantRFC;
    print Sisimai::Reason::NotCompliantRFC->match('This message is not RFC 5322 compliant.');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::NotCompliantRFC> checks the bounce reason is C<NotCompliantRFC> or not.
This class is called only from C<Sisimai::Reason class>.

This is the error that the email is not compliant RFC 5322 or other email related RFCs. For example,
there are multiple C<Subject> headers in the email.

    host aspmx.l.google.com[142.251.170.26] said: This message is not RFC 5322 compliant. There are
    multiple Subject headers. To reduce the amount of spam sent to Gmail, this message has been
    blocked. Please visit https://support.google.com/mail/?p=RfcMessageNonCompliant and review RFC
    5322 specifications for more information. - gsmtp (in reply to end of DATA command)",

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<NotCompliantRFC>.

    print Sisimai::Reason::NotCompliantRFC->text;  # NotCompliantRFC

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::NotCompliantRFC->match('This message is not RFC 5322 compliant');    # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<NotCompliantRFC>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

