package Sisimai::Rhost::Spectrum;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from https://www.spectrum.com/
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason at Spectrum
    # @since v4.25.8
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $errorcodes = [
        # https://www.spectrumbusiness.net/support/internet/understanding-email-error-codes
        #   Error codes are placed in one of two categories: incoming or outgoing.
        #   1. If you're trying to send an email to a Charter email address from
        #      a non-Charter email address (such as Gmail, Yahoo, Hotmail, etc.),
        #      you may receive an error that begins with AUP#I, followed by four numbers.
        #
        #   2. If you are trying to send an email from a Charter email address
        #      to an outgoing recipient, you may get an error code beginning with
        #      AUP#O, also followed by four numbers.
        #
        # 1000 Your IP address has been blocked due to suspicious activity. If you're a Spectrum
        #      customer using a Spectrum-issued IP, contact us. If you're using an IP address other
        #      than one provided by Spectrum, blocks will remain in place until they expire.
        [1000, 0, $Sisimai::Eb::ReBLOC],

        # 1010 This email account has been blocked from sending emails due to suspicious activity.
        #      Blocks will expire based on the nature of the activity. If you're a Spectrum customer,
        #      change all of your Spectrum passwords to secure your account and then contact us.
        [1010, 0, $Sisimai::Eb::ReFROM],

        # 1020 This email account has limited access to send emails based on suspicious activity.
        # 1080 Blocks will expire based on the nature of the activity.
        #      If you're a Spectrum customer, contact us to remove the block.
        [1020, 1080, $Sisimai::Eb::ReFROM],

        # 1090 The email you're trying to send can't be processed. Try sending again at a later time.
        [1090, 0, $Sisimai::Eb::RePROC],

        # 1100 The IP address you're trying to connect from has an issue with the Domain Name System.
        # 1150 Spectrum requires a full circle DNS for emails to be allowed through. Verify the IP
        #      you're connecting from, and check the IP address to ensure a reverse DNS entry exists
        #      for the IP. If the IP address is a Spectrum-provided email address, contact us.
        [1100, 1150, $Sisimai::Eb::ReQPTR],

        # 1160 The email you tried to send goes against your domain's security policies. 
        # 1190 Please contact the email administrators of your domain.
        [1160, 1190, $Sisimai::Eb::ReWONT],

        # 1200 The IP address you're trying to send from has been flagged by Cloudmark CSI as
        # 1210 potential spam. Have your IP administrator request a reset. 
        #      Note: Cloudmark has sole discretion whether to remove the sending IP address from
        #            their lists.
        [1200, 1210, $Sisimai::Eb::ReBLOC],

        # 1220 Your IP address has been blacklisted by Spamhaus. The owner of the IP address must
        # 1250 contact Spamhaus to be removed from the list.
        #      Note: Spamhaus has sole discretion whether to remove the sending IP address from
        #            their lists.
        [1220, 1250, $Sisimai::Eb::ReBLOC],

        # 1260 Spectrum doesn't process IPV6 addresses. Connect with an IPv4 address and try again.
        [1260, 0, $Sisimai::Eb::ReINET],

        # 1300 Spectrum limits the number of concurrent connections from a sender, as well as the
        # 1340 total number of connections allowed. Limits vary based on the reputation of the IP
        #      address. Reduce your number of connections and try again later.
        [1300, 1340, $Sisimai::Eb::ReRATE],

        # 1350 Spectrum limits emails by the number of messages sent, amount of recipients,
        # 1490 potential for spam and invalid recipients.
        [1350, 1490, $Sisimai::Eb::ReRATE],

        # 1500 Your email was rejected for attempting to send as a different email address than you
        #      signed in under. Check that you're sending emails from the address you signed in with.
        [1500, 0, $Sisimai::Eb::ReFROM],

        # 1520 Your email was rejected for attempting to send as a different email address than a
        #      domain that we host. Check the outgoing email address and try again.
        [1520, 0, $Sisimai::Eb::ReFROM],

        # 1530 Your email was rejected because it's larger than the maximum size of 20MB.
        [1530, 0, $Sisimai::Eb::ReSIZE],

        # 1540 Your emails were deferred for attempting to send too many in a single session.
        #      Reconnect and try reducing the number of emails you send at one time.
        [1540, 0, $Sisimai::Eb::ReRATE],

        # 1550 Your email was rejected for having too many recipients in one message. Reduce the
        #      number of recipients and try again later.
        [1550, 0, $Sisimai::Eb::ReRATE],

        # 1560 Your email was rejected for having too many invalid recipients. Check your outgoing
        #      email addresses and try again later.
        [1560, 0, $Sisimai::Eb::ReRATE],

        # 1580 You've tried to send messages to too many recipients in a short period of time.
        #      Wait a little while and try again later.
        [1580, 0, $Sisimai::Eb::ReRATE],
    ];
    my $issuedcode = $argvs->{'diagnosticcode'};
    my $codenumber = $issuedcode =~ m/AUP#[-A-Za-z]*(\d{4})/ ? int $1 : 0;
    my $reasontext = '';

    for my $e ( @$errorcodes ) {
        # Try to find an error code matches with the code in the value of $diagnosticcode
        if( $codenumber == $e->[0] ) {
            # [1500, 0, 'reason'] or [1500, 1550, 'reason']
            $reasontext = $e->[2];
            last;

        } else {
            # Check the code number is inlcuded the range like [1500, 1550, 'reason']
            next if $e->[1] == 0;
            next if $codenumber < $e->[0];
            next if $codenumber > $e->[1];

            $reasontext = $e->[2];
            last;
        }
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::Spectrum - Detect the bounce reason returned from Spectrum.

=head1 SYNOPSIS

    use Sisimai::Rhost::Spectrum;

=head1 DESCRIPTION

C<Sisimai::Rhost::Spectrum> detects the bounce reason from the content of C<Sisimai::Fact> object
as an argument of C<find()> method when the value of C<rhost> or C<destination> of the object is
C<charter.net>. This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2020,2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

