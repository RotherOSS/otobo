package Sisimai::Reason::SpamDetected;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;
use Sisimai::SMTP::Command;

sub text  { $Sisimai::Eb::ReSPAM }
sub description { 'Email rejected by spam filter running on the remote host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.19
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "blacklisted url in message",
        "block for spam",
        "blocked by policy: no spam please",
        "blocked by spamassassin", # rejected by SpamAssassin
        "classified as spam and is rejected",
        "content filter rejection",
        "denied due to spam list",
        "identified spam", # 554 SpamBouncer identified SPAM, message permanently rejected (#5.3.0)
        "may consider spam",
        "message content rejected",
        "message has been temporarily blocked by our filter",
        "message is being rejected as it seems to be a spam",
        "message was rejected by recurrent pattern detection system",
        "our email server thinks this email is spam",
        "reject bulk.advertising",
        "spam check",
        "spam content ",
        "spam detected",
        "spam email",
        "spam-like header",
        "spam message",
        "spam not accepted",
        "spam refused",
        "spamming not allowed",
        "unsolicited ",
        "your email breaches local uribl policy",
    ];
    state $pairs = [
        ["accept", " spam"],
        ["appears", " to ", "spam"],
        ["bulk", "mail"],
        ["considered", " spam"],
        ["contain", " spam"],
        ["detected", " spam"],
        ["greylisted", " please try again in"],
        ["mail score (", " over "],
        ["mail rejete. mail rejected. ", "506"],
        ["message ", "as spam"],
        ["message ", "like spam"],
        ["message ", "spamprofiler"],
        ["probab", " spam"],
        ["refused by", " spamprofiler"],
        ["reject", " content"],
        ["reject, id=", "spam"],
        ["rejected by ", " (spam)"],
        ["rejected due to spam ", "classification"],
        ["rule imposed as ", " is blacklisted on"],
        ["score", "spam"],
        ["spam ", "block"],
        ["spam ", "filter"],
        ["spam ", " exceeded"],
        ["spam ", "score"],
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # Rejected due to spam content in the message
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: rejected due to spam
    #                                   0: is not rejected due to spam
    # @since v4.1.19
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0; return 0 unless $argvs->{'deliverystatus'};

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReSPAM;
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq $Sisimai::Eb::ReSPAM;

    # The value of "reason" isn't "SpamDetected" when the value of "command" is an SMTP command to
    # be sent before the SMTP DATA command because all the MTAs read the headers and the entire
    # message body after the DATA command.
    return 0 if grep { $argvs->{'command'} eq $_ } Sisimai::SMTP::Command->ExceptDATA->@*;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SpamDetected - Bounce reason is C<SpamDetected> due to Spam content in the message
or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SpamDetected;
    print Sisimai::Reason::SpamDetected->match('550 spam detected');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::SpamDetected> checks the bounce reason is C<SpamDetected> due to the spam content
in the message or not. This class is called only C<Sisimai::Reason> class.

This is the error that the message you sent was rejected by the spam filter which is running on the
remote host. This reason has added in Sisimai 4.1.25.

    Action: failed
    Status: 5.7.1
    Diagnostic-Code: smtp; 550 5.7.1 Message content rejected, UBE, id=00000-00-000
    Last-Attempt-Date: Thu, 9 Apr 2008 23:34:45 +0900 (JST)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<SpamDetected>.

    print Sisimai::Reason::SpamDetected->text;  # SpamDetected

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::SpamDetected->match('550 Spam detected');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<rejected> due to the spam content in the message.
The argument must be C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018,2020-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

