package Sisimai::Rhost::MessageLabs;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from Email Security (formerly MessageLabs.com)
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason for MessageLabs
    # @since v5.2.0
    # @see
    # - https://www.broadcom.com/products/cybersecurity/email
    # - https://knowledge.broadcom.com/external/article/169652/email-error-and-bounce-codes-for-email-s.html
    my $class = shift;
    my $argvs = shift // return ""; return '' unless length $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReAUTH => [
            # - 553 DMARC domain authentication fail
            # - https://knowledge.broadcom.com/external/article/175407
            #   An email has failed delivery and the reason provided in Track and Trace is due
            #   to SPF Record. 553-SPF (Sender Policy Framework) domain authentication fail.
            "domain authentication fail",
        ],
        $Sisimai::Eb::ReFAMA => [
            # - https://knowledge.broadcom.com/external/article/164955
            #   "501 Connection rejected by policy [7.7]" 20805, please visit www.messagelabs.com/support
            #   for more details about this error message.
            #   My IP has a negative reputation with Symantec. To check the reputation of a
            #   specific IP address, go to https://ipremoval.sms.symantec.com/.
            # - https://knowledge.broadcom.com/external/article/384503
            #   Users are receiving a non-delivery receipt (NDR) when sending an email to a
            #   Symantec Email Security.cloud customer:
            "Connection rejected by policy",
        ],
        $Sisimai::Eb::ReBLOC => [
            # - https://knowledge.broadcom.com/external/article/165165
            #   You are sending an email to a domain protected by the Symantec Email Security.Cloud
            #   service and are receiving a non delivery receipt (NDR) stating the email delivery failed.
            #   553-mail rejected because your IP is in the PBL. See http://www.spamhaus.org/pbl
            # - Sorry, your IP address has been blocked
            #   * This error message indicates that your public IP address has been put on a
            #     block list by the Spamhaus PBL block list. To resolve this issue, request to
            #     have your IP removed at http://www.spamhaus.org/pbl/.
            #   * The delisting process is normally quicker than an hour. Once an hour has passed
            #     try to resend your email.
            #   * If the problem persists, contact the recipient by other means (e.g. phone)
            #     and request that your email address is added to their Email Security.cloud
            #     approved sender's list.
            # - Sorry, your email address (addr) has been blocked
            #   * Check with your administrator or ISP that your mail server is not in open relay.
            #     Search “Open Relay Test” for an independent testing tool. If your mail server
            #     is an open relay, please fix the open relay, wait 24 hours, and then try to
            #     resend your email.
            #   * Check with your administrator or ISP that your IP address is not on any spam
            #     block lists. Search “email blacklist check” to check using an independent tool.
            #     If your IP address is on any block lists, please request for removal, wait 24
            #     hours, and then try to resend your email.
            #     If the problem persists, contact the recipient by other means (e.g. phone) for
            #     further assistance.
            # - Sorry, your IP address (ip-addr) has been blocked
            "mail rejected because your IP is in the PBL",
            "your IP address has been ",
            "your IP address (ip-addr) has been blocked",
            "your email address (addr) has been blocked",
        ],
        $Sisimai::Eb::ReBODY => [
            # - 553 Stray linefeeds in message (#5.6.2)
            #   This error message happens because we strictly enforce the Internet Message Format
            #   standard RFC 5322 (and its predecessor RFC 2822) which state, "CR and LF MUST
            #   only occur together as CRLF; they MUST NOT appear independently in the body.
            "Stray linefeeds in message",
        ],
        $Sisimai::Eb::ReTTLS => [
            # - https://knowledge.broadcom.com/external/article/162152
            #   You are sending to a domain protected by the Symantec Email Security.cloud
            #   service, or you are a customer subscribed to Symantec Email Security.cloud
            #   sending outbound through the service. The Email Security.cloud server responds
            #   to the SMTP RCPT TO: command with "451 TLS/SSLv3 Connection required. (#4.7.1)".
            #   - 451 TLS/SSLv3 Connection required. (#4.7.1)
            #   - Within the ClientNet portal, the Email Track and Trace tool shows "Not Delivered"
            #     in the Delivered column and "Boundary Encryption" in the "Service" column.
            "TLS/SSLv3 Connection required",
        ],
        $Sisimai::Eb::RePASS => [
            # - https://knowledge.broadcom.com/external/article/162137
            #   You received a Non-Delivery Report (NDR) for email sent through the Symantec
            #   Email Security.cloud infrastructure, with the message "You are trying to use
            #   me [server-X.tower-x.messagelabs.com] as a relay, but I have not been configured
            #   to let you [IP, address] do this."
            " as a relay, ",
        ],
        $Sisimai::Eb::ReNRFC => [
            # - The format of your message did not comply with RFC 2822.
            # - Contact your IT administrator or ISP.
            # - If the problem persists, contact the recipient by other means (e.g. phone).
            #
            # - 550 [XX.XX.XX.XX] has detected that this message is not RFC 5322
            #   * Ensure that the message complied to RFC 5322.
            "550 Requested action aborted [4]",
            "has detected that this message is not RFC 5322",
        ],
        $Sisimai::Eb::ReRATE => [
            #  - https://knowledge.broadcom.com/external/article/385809
            #    Email Security Cloud is attempting to deliver the email and recipient MTA is
            #    responding "452 Too many recipients received this hour".
            #  - https://knowledge.broadcom.com/external/article/164767
            #    This error can occur when sending outbound or inbound emails through Email
            #    Security.Cloud. A non-delivery receipt (NDR) stating delivery contains a message
            #    that the intended recipient has failed with error:
            #    "460 too many messages (#4.3.0)"
            "Too many recipients received this hour",
            "too many messages",
        ],
        $Sisimai::Eb::ReFROM => [
            #  - 550 sender envelope domain not allowed for sender IP address (#5.1.8)
            #    This error occurs when a sender attempts to send an email and any one of the
            #    following are true:
            #    * The sending domain has not been registered under My Domains or Third-Party Domains.
            #    * The sending domain is inactive.
            #    * The sending IP is not in Outbound Routes.
            #  - 553 Sorry, your domain has been blocked
            #    The error message indicates that your IP address is on the recipient’s private
            #    block list. Contact the recipient and request that your email address is added
            #    to their Email Security.cloud approved sender's list.
            #  - 553 Sorry, your email address has been blocked
            #    The error message indicates that your domain is on the recipient’s private block
            #    list. Contact the recipient by other means (e.g. phone) and request that your
            #    email address is added to their Email Security.cloud approved senders list.
            #  - https://knowledge.broadcom.com/external/article/162232
            #    You have received an email notification from Symantec Email Security.cloud:
            #    * An individual end user account is either sending spam through Symantec Email
            #      Security.cloud or is receiving a bounceback error message indicating they are
            #      on the "badmailfrom" list.
            #    * The error message received is: "553 sorry, your envelope sender is in my
            #      badmailfrom list. Please visit www.symanteccloud.com/troubleshooting for more
            #      details about this error message and instructions to resolve this issue. (#5.7.1)."
            #  - https://knowledge.broadcom.com/external/article/173082
            #    Emails from a sender are blocked by the Anti-Spam service stating that they are
            #    in your company's blacklist.
            #    * 553-Sorry, your email address has been blacklisted
            #    * 553-Sorry, your domain has been blacklisted
            #    * 553-Sorry, your IP address has been blacklisted
            "sender envelope domain not allowed for sender IP address",
            "your domain has been blocked",
            "your email address has been blocked",
            "your envelope sender is in my badmailfrom list",
            "your email address has been blacklisted",
            "your domain has been blacklisted",
        ],
        $Sisimai::Eb::ReSAFE => ["Please turn on SMTP Authentication in your mail client"],
        $Sisimai::Eb::ReSPAM => [
            #  - https://knowledge.broadcom.com/external/article/173867
            #    Legitimate email, either outbound or inbound, is incorrectly flagged as spam
            #    (false positive) by Email Security.cloud. This email may have the following errors:
            #    * 553 - Message Filtered
            #    * filtered by Outbound scanning.
            "Message Filtered",
            "filtered by Outbound scanning",
        ],
        $Sisimai::Eb::ReUSER => [
            #  - https://knowledge.broadcom.com/external/article/165163
            #    When sending email to a user on the Symantec Email Security.cloud service, the
            #    message is rejected. The sender receives a non-delivery email with a 500 series
            #    error code indicating that the recipient is invalid.
            #    <username@example.com>: 550-Invalid recipient <username@example.com> 550 (#5.1.1)
            #  - 553 Recipient mailbox is not allowed
            #    The error message indicates that you have sent an email to an invalid address
            #    in the recipient’s domain. Double-check the email address for any spelling errors.
            #  - https://knowledge.broadcom.com/external/article/175710
            #    This error indicates that you have sent an email to an invalid address to the
            #    recipient’s domain. "Recipient mailbox is not allowed"
            "No such user",
            "Invalid recipient",
            "mailbox is not allowed",
            "Recipient mailbox is not allowed",
        ],
    };
    my $issuedcode = $argvs->{'diagnosticcode'};
    my $reasontext = '';

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

Sisimai::Rhost::MessageLabs - Detect the bounce reason returned from MessageLabs

=head1 SYNOPSIS

    use Sisimai::Rhost::MessageLabs;

=head1 DESCRIPTION

C<Sisimai::Rhost::MessageLabs> detects the bounce reason from the content of C<Sisimai::Fact> object as
an argument of C<find()> method when the value of C<rhost> of the object end with C<messagelabs.com>.
This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

