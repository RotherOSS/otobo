package Sisimai::Rhost::Facebook;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason for Facebook
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                Detected bounce reason
    # @see https://www.facebook.com/postmaster/response_codes
    # @since v5.2.0
    my $class = shift;
    my $argvs = shift // return "";
    return "" unless $argvs->{'diagnosticcode'};
    return "" unless index($argvs->{'diagnosticcode'}, '-');

    require Sisimai::Eb;
    state $errorcodes = {
        # http://postmaster.facebook.com/response_codes
        # NOT TESTD EXCEPT RCP-P2
        $Sisimai::Eb::ReAUTH => [
            "POL-P7",   # The message does not comply with Facebook's Domain Authentication requirements.
        ],
        $Sisimai::Eb::ReBLOC => [
            "POL-P1",   # Your mail server's IP Address is listed on the Spamhaus PBL.
            "POL-P2",   # Facebook will no longer accept mail from your mail server's IP Address.
            "POL-P3",   # Facebook is not accepting messages from your mail server. This will persist for 4 to 8 hours.
            "POL-P4",   # ". This will persist for 24 to 48 hours.
            "POL-T1",   # ", but they may be retried later. This will persist for 1 to 2 hours.
            "POL-T2",   # ", but they may be retried later. This will persist for 4 to 8 hours.
            "POL-T3",   # ", but they may be retried later. This will persist for 24 to 48 hours.
        ],
        $Sisimai::Eb::ReBODY => [
            "MSG-P2",   # The message contains an attachment type that Facebook does not accept.
        ],
        $Sisimai::Eb::ReSIZE => [
            "MSG-P1",   # The message exceeds Facebook's maximum allowed size.
            "INT-P2",   # The message exceeds Facebook's maximum allowed size.
        ],
        $Sisimai::Eb::ReFILT => [
            "RCP-P2",   # The attempted recipient's preferences prevent messages from being delivered.
            "RCP-P3",   # The attempted recipient's privacy settings blocked the delivery.
        ],
        $Sisimai::Eb::ReFULL => [
            "INT-P7",   # The attempted recipient has exceeded their storage quota.
        ],
        $Sisimai::Eb::ReWONT => [
            "POL-P8",   # The message does not comply with Facebook's abuse policies and will not be accepted.
        ],
        $Sisimai::Eb::ReNRFC => [
            "MSG-P3",   # The message contains multiple instances of a header field that can only be present once.
        ],
        $Sisimai::Eb::ReRATE => [
            "CON-T1",   # Facebook's mail server currently has too many connections open to allow another one.
            "CON-T2",   # Your mail server currently has too many connections open to Facebook's mail servers.
            "CON-T3",   # Your mail server has opened too many new connections to Facebook's mail servers in a short period of time.
            "CON-T4",   # Your mail server has exceeded the maximum number of recipients for its current connection.
            "MSG-T1",   # The number of recipients on the message exceeds Facebook's allowed maximum.
        ],
        $Sisimai::Eb::ReFROM => [
            "DNS-P1",   # Your SMTP MAIL FROM domain does not exist.
            "DNS-P2",   # Your SMTP MAIL FROM domain does not have an MX record.
            "DNS-T1",   # Your SMTP MAIL FROM domain exists but does not currently resolve.
        ],
        $Sisimai::Eb::ReQPTR => [
            "DNS-P3",   # Your mail server does not have a reverse DNS record.
            "DNS-T2",   # You mail server's reverse DNS record does not currently resolve.
        ],
        $Sisimai::Eb::ReSPAM => [
            "POL-P6",   # The message contains a url that has been blocked by Facebook.
        ],
        $Sisimai::Eb::ReQUIT => [
            "RCP-T4",   # The attempted recipient address is currently deactivated. The user may or may not reactivate it.
        ],
        $Sisimai::Eb::RePROC => [
            "RCP-T1",   # The attempted recipient address is not currently available due to an internal system issue. 
            "INT-Tx",   # These codes indicate a temporary issue internal to Facebook's system.
        ],
        $Sisimai::Eb::ReUSER => [
            "RCP-P1",   # The attempted recipient address does not exist.
            "INT-P1",   # The attempted recipient address does not exist.
            "INT-P3",   # The attempted recipient group address does not exist.
            "INT-P4",   # The attempted recipient address does not exist.
        ],
        $Sisimai::Eb::ReEXEC => [
            "POL-P5",   # The message contains a virus.
        ],
    };
    my $errorindex = index($argvs->{'diagnosticcode'}, "-");
    my $errorlabel = substr($argvs->{'diagnosticcode'}, $errorindex - 3, 6);
    my $reasontext = "";

    for my $e ( keys %$errorcodes ) {
        # The key is a bounce reason name
        next unless grep { $errorlabel eq $_ } $errorcodes->{ $e }->@*;
        $reasontext = $e; last
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::Facebook - Detect the bounce reason returned from Facebook

=head1 SYNOPSIS

    use Sisimai::Rhost::Facebook;

=head1 DESCRIPTION

C<Sisimai::Rhost::Facebook> detects the bounce reason from the content of C<Sisimai::Fact> object
as an argument of C<find()> method when the value of C<rhost> of the object includes C<facebook.com>.
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

