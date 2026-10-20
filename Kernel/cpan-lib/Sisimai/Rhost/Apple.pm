package Sisimai::Rhost::Apple;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from Apple iCloud Mail
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason for Apple
    # @see
    # @since v5.1.0
    # - Postmaster information for iCloud Mail: https://support.apple.com/en-us/102322
    # - https://www.postmastery.com/icloud-postmastery-page/
    # - https://smtpfieldmanual.com/provider/apple
    my $class = shift;
    my $argvs = shift // return ""; return '' unless length $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReAUTH => [
            # - 554 5.7.1 Your message was rejected due to example.jp's DMARC policy.
            #   See https://support.apple.com/en-us/HT204137 for
            # - 554 5.7.1 [HME1] This message was blocked for failing both SPF and DKIM authentication
            #   checks. See https://support.apple.com/en-us/HT204137 for mailing best practices
            's dmarc policy',
            'blocked for failing both spf and dkim autentication checks',
        ],
        $Sisimai::Eb::ReBLOC => [
            # - 550 5.7.0 Blocked - see https://support.proofpoint.com/dnsbl-lookup.cgi?ip=192.0.1.2
            # - 550 5.7.1 Your email was rejected due to having a domain present in the Spamhaus
            #   DBL -- see https://www.spamhaus.org/dbl/
            # - 550 5.7.1 Mail from IP 192.0.2.1 was rejected due to listing in Spamhaus SBL.
            #   For details please see http://www.spamhaus.org/query/bl?ip=x.x.x.x
            # - 554 ****-smtpin001.me.com ESMTP not accepting connections
            'rejected due to having a domain present in the spamhaus',
            'rejected due to listing in spamhaus',
            'blocked - see https://support.proofpoint.com/dnsbl-lookup',
            'not accepting connections',
        ],
        $Sisimai::Eb::ReMOVE => [
            # - 550 5.1.6 recipient no longer on server: *****@icloud.com
            'recipient no longer on server',
        ],
        $Sisimai::Eb::ReFULL => [
            # - 552 5.2.2 <****@icloud.com>: user is over quota (in reply to RCPT TO command)
            'user is over quota',
        ],
        $Sisimai::Eb::RePASS => [
            # - 554 5.7.1 <*****@icloud.com>: Relay access denied
            'relay access denied',
        ],
        $Sisimai::Eb::Re00MX => ['host/domain does not accept mail'],
        $Sisimai::Eb::ReWONT => [
            # - 550 5.7.1 [CS01] Message rejected due to local policy.
            #   Please visit https://support.apple.com/en-us/HT204137
            'due to local policy',
        ],
        $Sisimai::Eb::ReRATE => [
            # - 421 4.7.1 Messages to ****@icloud.com deferred due to excessive volume.
            #   Try again later - https://support.apple.com/en-us/HT204137
            'due to excessive volume',
        ],
        $Sisimai::Eb::ReFROM => [
            # - 450 4.1.8 <kijitora@example.jp>: Sender address rejected: Domain not found
            'sender address rejected',
        ],
        $Sisimai::Eb::ReQUIT => [
            # - https://support.apple.com/guide/icloud/stop-using-or-reactivate-addresses-mm3adb030cbf/icloud
            # - 550 5.1.1 <****@icloud.com>: inactive email address (in reply to RCPT TO command)
            "inactive email address",
        ],
        $Sisimai::Eb::ReUSER => [
            # - 550 5.1.1 <****@icloud.com>: inactive email address (in reply to RCPT TO command)
            # - 550 5.1.1 unknown or illegal alias: ****@icloud.com
            'user does not exist',
            'unknown or illegal alias',
        ],
    };
    my $issuedcode = lc $argvs->{'diagnosticcode'};
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

Sisimai::Rhost::Apple - Detect the bounce reason returned from Apple iCloud Mail

=head1 SYNOPSIS

    use Sisimai::Rhost::Apple;

=head1 DESCRIPTION

C<Sisimai::Rhost::Apple> detects the bounce reason from the content of C<Sisimai::Fact> object as
an argument of C<find()> method when the value of C<rhost> of the object end with C<mail.icloud.com>
or C<apple.com>. This class is called only C<Sisimai::Fact> class.

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

