package Sisimai::Rhost::GoDaddy;
use v5.26;
use strict;
use warnings;

# https://www.godaddy.com/help/what-does-my-email-bounceback-mean-3568
sub find {
    # Detect bounce reason from GoDaddy (smtp.secureserver.net)
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason for GoDaddy
    # @see      https://ca.godaddy.com/help/fix-rejected-email-with-a-bounce-error-40685
    # @since v4.22.2
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $errorcodes = {
        # Sender bounces
        # -----------------------------------------------------------------------------------------
        # - 535 Authentication not allowed on IBSMTP Servers. IB401
        # - Authentication is not allowed on inbound mail. This happens when you have incorrect
        #   outgoing SMTP server settings set up in your email client, like Outlook or Gmail.
        # - Set up your email client using the SMTP server setting smtpout.secureserver.net.
        'IB401' => $Sisimai::Eb::ReSAFE,

        # - 550 jane@coolexample.com Blank From: addresses are not allowed. Provide a valid From.
        #   IB501
        # - The email message "from" field is blank.
        # - Add a valid "from" address and try to send the email again.
        'IB501' => $Sisimai::Eb::ReNRFC,

        # - 550 jane@coolexample.com IP addresses are not allowed as a From: Address. Provide a
        #   valid From. IB502
        # - Email messages can't be sent "from" an IP address.
        # - Add a valid "from" address and try to send the email again.
        'IB502' => $Sisimai::Eb::ReNRFC,

        # - 550 coolexample.com From: Domain is invalid. Provide a valid From: IB506
        # - The domain doesn't have valid MX Records, an IP address, or there were issues during
        #   the DNS lookup when the email was sent.
        # - Verify that you're sending from a valid domain. Then verify that the domain has valid
        #   DNS records by checking your zone file. If the DNS isn't valid, it must be fixed before
        #   you resend the email.
        'IB506' => $Sisimai::Eb::ReFROM,

        # - 550 jane@coolexample.com Invalid SPF record. Inspect your SPF settings, and try again.
        #   IB508
        # - The sending email address's domain has an SPF record that does not authorize the sending
        #   email server to send email from the domain.
        # - Modify the SPF record to include the server you're trying to send from or remove the SPF
        #   record from the domain.
        'IB508' => $Sisimai::Eb::ReAUTH,

        # - 421 Temporarily rejected. Reverse DNS for this IP failed. IB108
        # - The IP address attempting to send mail does not have reverse DNS setup, or the DNS
        #   lookup failed.
        # - Verify the sending IP address has reverse DNS set up before resending the email.
        #   GoDaddy manages reverse DNS when using our email services. We do not support custom
        #   reverse DNS.
        'IB108' => $Sisimai::Eb::ReQPTR,

        # Content bounces
        # -----------------------------------------------------------------------------------------
        # - 552 This message has been rejected due to content judged to be spam by the internet
        #   community. IB212
        # - The email message contains a link, attachment or pattern caught by our filters as spam.	
        'IB212' => $Sisimai::Eb::ReSPAM,

        # - 552 Virus infected message rejected. IB705
        # - The email message containing a link, attachment or pattern caught by our filters as a
        #   possible virus.	
        'IB705' => $Sisimai::Eb::ReEXEC,

        # Rate limiting bounces
        # -----------------------------------------------------------------------------------------
        # - 452 This message contains too many recipients. Reduce the number of recipients and
        #   retry. IB605
        # - The message has attempted to mail too many recipients.
        # - Reduce the number of recipients and try again.
        'IB605' => $Sisimai::Eb::ReRATE,

        # - 421 Connection refused, too many sessions from This IP. Lower the number of concurrent
        #   sessions. IB007
        # - This IP address currently has too many sessions open.
        # - Check with your email provider to reduce the number of open sessions on your IP address
        #   and then try again.
        'IB007' => $Sisimai::Eb::ReRATE,

        # - 421 Server temporarily unavailable. Try again later. IB101
        # - The email queue is experiencing higher than normal email volume.
        # - Try again later.
        'IB101' => $Sisimai::Eb::ReRATE,

        # - 554 This IP has been temporarily blocked for attempting to send too many messages
        #   containing content judged to be spam by the Internet community. IB110
        # - This IP address has attempted to send too many messages containing content judged to be
        #   spam and has been blocked for an hour.
        # - If you're not sending spam, you'll need to contact your Internet Service Provider (ISP)
        #   to see why your IP address is sending so many emails. Something in your system is
        #   causing the issue, and you'll need to troubleshoot.
        'IB110' => $Sisimai::Eb::ReBLOC,

        # - 554 This IP has been blocked for the day, for attempting to send too many messages
        #   containing content judged to be spam by the Internet community. IB111
        # - This IP address has attempted to send too many messages containing content judged to be
        #   spam and has been blocked for the remainder of the day.
        'IB111' => $Sisimai::Eb::ReBLOC,

        # - 554 This IP has been temporarily blocked for attempting to mail too many invalid
        #   recipients. IB112
        # - This IP address has attempted to email too many invalid recipients and has been blocked
        #   for an hour.
        'IB112' => $Sisimai::Eb::ReBLOC,

        # - 554 This IP has been blocked for the day, for attempting to mail too many invalid
        #   recipients. IB113
        # - This IP address has attempted to email too many invalid recipients and has been blocked
        #   for the remainder of the day.
        'IB113' => $Sisimai::Eb::ReBLOC,

        # - 550 This IP has sent too many messages this hour. IB504
        # - This IP address has reached the maximum allowed messages for that hour.
        'IB504' => $Sisimai::Eb::ReRATE,

        # - 550 This message has exceeded the max number of messages per session. Open a new session
        #   and try again. IB510
        # - This IP address has reached the maximum allowed messages for that session.
        'IB510' => $Sisimai::Eb::ReRATE,

        # - 550 This IP has sent too many to too many recipients this hour. IB607
        # - This IP address has reached the maximum allowed recipients for that hour.
        'IB607' => $Sisimai::Eb::ReRATE,

        # Remote block list (RBL) bounces
        # -----------------------------------------------------------------------------------------
        # - 554 Connection refused. This IP has a poor reputation on Cloudmark Sender Intelligence
        #   (CSI). IB103
        # - This IP address has a poor reputation on Cloudmark Sender Intelligence (CSI).
        'IB103' => $Sisimai::Eb::ReFAMA,

        # - 554 Connection refused. This IP address is listed on the Spamhaus Block List (SBL). IB104
        # - This IP address is listed on the Spamhaus Block List.
        'IB104' => $Sisimai::Eb::ReBLOC,

        # - 554 Connection refused. This IP address is listed on the Exploits Block List (XBL). IB105
        # - This IP address is listed on the Spamhaus Exploits Block List.
        'IB105' => $Sisimai::Eb::ReBLOC,

        # - 554 Connection refused. This IP address is listed on the Policy Block List (PBL). IB106
        # - This IP address is listed on the Spamhaus Policy Block List.
        'IB106' => $Sisimai::Eb::ReBLOC,
    };
    state $messagesof = {
        $Sisimai::Eb::ReAUTH => [
            # - 550 SPF Sender Invalid - envelope rejected
            # - 550 5.7.9: This mail has been blocked because the sender is unauthenticated
            # - 550-5.7.26 DKIM = did not pass
            "spf sender invalid - envelope rejected",
            "this mail has been blocked because the sender is unauthenticated",
            "dkim = did not pass",
        ],
        $Sisimai::Eb::ReBLOC => [
            # - 554 RBL Reject.
            # - This IP address was blocked from our internal RBL.
            # - Use the link provided in the bounceback to submit a request to remove this IP address.
            'rbl reject',
            'www.spamhaus.org/query/bl?ip='
        ],
        $Sisimai::Eb::ReTIME => [
            # - 451 Sorry, I wasn't able to establish an SMTP connection. I'm not going to try again;
            #   this message has been in the queue too long.
            # - The recipient's email address has been misspelled or the recipient's email provider
            #   has blocked sending from your address.
            'has been in the queue too long',

            # - Delivery timeout
            # - This could happen for several reasons.
            'delivery timeout',
        ],
        $Sisimai::Eb::ReFULL => [
            # - Account storage limit
            # - The recipient's account has reached its storage limit and can't receive email right
            #   now.
            # - The recipient needs to delete messages from their inbox or the receiving folder to
            #   make space for more email.
            'account storage limit',
        ],
        $Sisimai::Eb::RePASS => [
            # - 550 5.7.1: Relay access denied
            "relay access denied",
        ],
        $Sisimai::Eb::ReRATE => [
            # - 550 5.7.232 Your message can't be sent because your trial tenant has exceeded
            #   its daily limit for sending email to external recipients (tenant external recipient rate limit)
            # - 550 5.7.233 - Your message can't be sent because your tenant exceeded its daily
            #   limit for sending email to external recipients (tenant external recipient rate limit)
            "exceeded its daily limit",
        ],
        $Sisimai::Eb::ReFROM => [
            # - 550 5.1.8 Access denied, bad outbound sender AS (42004)
            "bad outbound sender as (42004)",
        ],
        $Sisimai::Eb::ReSAFE => [
            # - 550 Please turn on SMTP Authentication in your mail client
            "turn on smtp authentication in your mail client",
        ],
        $Sisimai::Eb::ReSPAM => [
            # - 552 Message rejected for spam or virus content
            # - The email message contains a link, attachment, or pattern caught by our filters as spam.
            'message rejected for spam or virus content',
        ],
        $Sisimai::Eb::ReQUIT => [
            # - Account disabled
            # - The recipient account exists but its ability to receive mail was disabled.
            # - Typically, these accounts remain permanently disabled, but you can try sending the
            #   email again later.
            'account disabled',
        ],
        $Sisimai::Eb::RePROC => [
            # - This message is looping: it already has my Delivered-To line. (#5.4.6)
            # - The recipient account is forwarding the message in a loop.
            # - This is oftentimes because the receiver has two addresses that forward to each
            #   other. They need to correct their forwarding settings.
            'message is looping',
        ],
        $Sisimai::Eb::ReUSER => [
            # - 550 Recipient not found
            # - The recipient is not a valid email address.
            # - Remove the invalid recipient from your email.
            'recipient not found',

            # - Account does not exist
            # - The email address that you sent to does not exist.
            # - Verify that the recipient email address was entered correctly.
            'account does not exist'
        ],
    };

    my $issuedcode = $argvs->{'diagnosticcode'};
    my $positionib = index($issuedcode, ' IB');
    my $reasontext = '';

    # 192.0.2.22 has sent to too many recipients this hour. IB607 ...
    $reasontext = $errorcodes->{ substr($issuedcode, $positionib + 1, 5) } || '' if $positionib > 1;
    return $reasontext if length $reasontext;

    $issuedcode = lc $issuedcode;
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

Sisimai::Rhost::GoDaddy - Detect the bounce reason returned from GoDaddy.

=head1 SYNOPSIS

    use Sisimai::Rhost::GoDaddy;

=head1 DESCRIPTION

C<Sisimai::Rhost::GoDaddy> detects the bounce reason from the content of C<Sisimai::Fact> object as
an argument of C<find()> method when the value of C<rhost> of the object end with C<secureserver.net>.
This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018,2020-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

