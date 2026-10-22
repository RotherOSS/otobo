package Sisimai::Reason::PolicyViolation;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReWONT }
sub description { 'Email rejected due to policy violation on a destination host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.22.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "because the recipient is not accepting mail with ",    # AOL Phoenix
        "closed mailing list",
        "delivery not authorized, message refused",
        "denied by policy",
        # http://kb.mimecast.com/Mimecast_Knowledge_Base/Administration_Console/Monitoring/Mimecast_SMTP_Error_Codes#554
        "email rejected due to security policies",
        "for policy reasons",
        "local policy violation",
        "message bounced due to organizational settings",
        "message given low priority",
        "message was rejected by organization policy",
        "protocol violation",
        "support.google.com/a/answer/172179",
        "you're using a mass mailer",
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is "PolicyViolation" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is PolicyViolation
    #                                   0: is not PolicyViolation
    # @since v4.22.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReWONT;
    return 0 if $argvs->{'command'} ne '' && $argvs->{'command'} ne $Sisimai::Eb::CeDATA;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::PolicyViolation - Bounce reason is C<PolicyViolation> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::PolicyViolation;
    print Sisimai::Reason::PolicyViolation->match('5.7.9 Header error');    # 1

=head1 DESCRIPTION

C<Sisimai::Reason::PolicyViolation> checks the bounce reason is C<PolicyViolation> or not.
This class is called only C<Sisimai::Reason> class.

This is the error that a policy violation was detected on the destination mail host. When the header
content or the format of the original message violates their security policies, or multiple addresses
exist in the C<From:> header, Sisimai will set C<PolicyViolation>.

    Action: failed
    Status: 5.7.0
    Remote-MTA: DNS; gmail-smtp-in.l.google.com
    Diagnostic-Code: SMTP; 552-5.7.0 Our system detected an illegal attachment on your message. Please
    Last-Attempt-Date: Tue, 28 Apr 2009 11:02:45 +0900 (JST)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<PolicyViolation>.

    print Sisimai::Reason::PolicyViolation->text;  # PolicyViolation

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::PolicyViolation->match('5.7.9 Header error');    # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<PolicyViolation>. The argument must be
<CSisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

