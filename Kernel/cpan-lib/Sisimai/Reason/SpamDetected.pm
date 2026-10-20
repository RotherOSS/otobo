package Sisimai::Reason::SpamDetected;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::String;

sub text  { 'spamdetected' }
sub description { 'Email rejected by spam filter running on the remote host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.19
    my $class = shift;
    my $argv1 = shift // return undef;

    state $index = [
        ' - spam',
        '//www.spamhaus.org/help/help_spam_16.htm',
        '//dsbl.org/help/help_spam_16.htm',
        '//mail.163.com/help/help_spam_16.htm',
        '554 5.7.0 reject, id=',
        'appears to be unsolicited',
        'blacklisted url in message',
        'block for spam',
        'blocked by policy: no spam please',
        'blocked by spamassassin',                      # rejected by SpamAssassin
        'blocked for abuse. see http://att.net/blocks', # AT&T
        'cannot be forwarded because it was detected as spam',
        'considered unsolicited bulk e-mail (spam) by our mail filters',
        'content filter rejection',
        'cyberoam anti spam engine has identified this email as a bulk email',
        'denied due to spam list',
        'high probability of spam',
        'is classified as spam and is rejected',
        'listed in work.drbl.imedia.ru',
        'the mail server detected your message as spam and has prevented delivery.',   # CPanel/Exim with SA rejections on
        'mail appears to be unsolicited',   # rejected due to spam
        'mail content denied',              # http://service.mail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000726
        'may consider spam',
        'message considered as spam or virus',
        'message contains spam or virus',
        'message content rejected',
        'message detected as spam',
        'message filtered',
        'message filtered. please see the faqs section on spam',
        'message filtered. refer to the troubleshooting page at ',
        'message looks like spam',
        'message is being rejected as it seems to be a spam',
        'message refused by mailmarshal spamprofiler',
        'message refused by trustwave seg spamprofiler',
        'message rejected as spam',
        'message rejected because of unacceptable content',
        'message rejected due to suspected spam content',
        'message rejected for policy reasons',
        'message was rejected for possible spam/virus content',
        'our email server thinks this email is spam',
        'our system has detected that this message is ',
        'probable spam',
        'reject bulk.advertising',
        'rejected: spamassassin score ',
        'rejected - bulk email',
        'rejecting banned content',
        'rejecting mail content',
        'related to content with spam-like characteristics',
        'sender domain listed at ',
        'sending address not accepted due to spam filter',
        'spam blocked',
        'spam check',
        'spam content matched',
        'spam detected',
        'spam email',
        'spam email not accepted',
        'spam message rejected.',   # mail.ru
        'spam not accepted',
        'spam refused',
        'spam rejection',
        'spam score ',
        'spambouncer identified spam',  # SpamBouncer identified SPAM
        'spamming not allowed',
        'too many spam complaints',
        'too much spam.',               # Earthlink
        'the email message was detected as spam',
        'the message has been rejected by spam filtering engine',
        'the message was rejected due to classification as bulk mail',
        'the content of this message looked like spam', # SendGrid
        'this message appears to be spam',
        'this message has been identified as spam',
        'this message has been scored as spam with a probability',
        'this message was classified as spam',
        'this message was rejected by recurrent pattern detection system',
        'transaction failed spam message not queued',   # SendGrid
        'we dont accept spam',
        'your email appears similar to spam we have received before',
        'your email breaches local uribl policy',
        'your email had spam-like ',
        'your email is considered spam',
        'your email is probably spam',
        'your email was detected as spam',
        'your message as spam and has prevented delivery',
        'your message has been temporarily blocked by our filter',
        'your message has been rejected because it appears to be spam',
        'your message has triggered a spam block',
        'your message may contain the spam contents',
        'your message failed several antispam checks',
    ];
    state $pairs = [
        ['greylisted', ' please try again in'],
        ['mail rejete. mail rejected. ', '506'],
        ['our filters rate at and above ', ' percent probability of being spam'],
        ['rejected by ', ' (spam)'],
        ['rejected due to spam ', 'classification'],
        ['rejected due to spam ', 'content'],
        ['rule imposed as ', ' is blacklisted on'],
        ['spam ', ' exceeded'],
        ['this message scored ', ' spam points'],
    ];
    state $regex = qr/(?:\d[.]\d[.]\d|\d{3})[ ]spam\z/;

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 1 if $argv1 =~ $regex;
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
    my $argvs = shift // return undef;

    return undef unless $argvs->{'deliverystatus'};
    return 1 if $argvs->{'reason'} eq 'spamdetected';
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq 'spamdetected';

    # The value of "reason" isn't "spamdetected" when the value of "smtpcommand" is an SMTP command
    # to be sent before the SMTP DATA command because all the MTAs read the headers and the entire
    # message body after the DATA command.
    my $thecommand = $argvs->{'smtpcommand'} || '';
    return 0 if $thecommand eq 'CONN' || $thecommand eq 'EHLO' || $thecommand eq 'HELO'
             || $thecommand eq 'MAIL' || $thecommand eq 'RCPT';
    return 1 if __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SpamDetected - Bounce reason is C<spamdetected> due to Spam content in the message
or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SpamDetected;
    print Sisimai::Reason::SpamDetected->match('550 spam detected');   # 1

=head1 DESCRIPTION

Sisimai::Reason::SpamDetected checks the bounce reason is C<spamdetected> due to Spam content in the
message or not. This class is called only Sisimai::Reason class.

This is the error that the message you sent was rejected by C<spam> filter which is running on the
remote host. This reason has added in Sisimai 4.1.25.

    Action: failed
    Status: 5.7.1
    Diagnostic-Code: smtp; 550 5.7.1 Message content rejected, UBE, id=00000-00-000
    Last-Attempt-Date: Thu, 9 Apr 2008 23:34:45 +0900 (JST)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<spamdetected>.

    print Sisimai::Reason::SpamDetected->text;  # spamdetected

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::SpamDetected->match('550 Spam detected');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> returns 1 if the bounce reason is C<rejected> due to Spam content in the message. The
argument must be Sisimai::Fact object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018,2020-2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

