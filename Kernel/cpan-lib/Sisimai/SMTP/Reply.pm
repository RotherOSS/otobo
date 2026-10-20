package Sisimai::SMTP::Reply;
use feature ':5.10';
use strict;
use warnings;
# http://www.ietf.org/rfc/rfc5321.txt
#   4.2.1.  Reply Code Severities and Theory
#
#   There are four values for the first digit of the reply code:
#
#   2yz  Positive Completion reply
#       The requested action has been successfully completed.  A new request may be initiated.
#
#   3yz  Positive Intermediate reply
#       The command has been accepted, but the requested action is being held in abeyance, pending
#       receipt of further information. The SMTP client should send another command specifying this
#       information. This reply is used in command sequence groups (i.e., in DATA).
#
#   4yz  Transient Negative Completion reply
#       The command was not accepted, and the requested action did not occur.  However, the error
#       condition is temporary, and the action may be requested again.  The sender should return to
#       the beginning of the command sequence (if any).  It is difficult to assign a meaning to
#       "transient" when two different sites (receiver- and sender-SMTP agents) must agree on the
#       interpretation. Each reply in this category might have a different time value, but the SMTP
#       client SHOULD try again.  A rule of thumb to determine whether a reply fits into the 4yz or
#       the 5yz category (see below) is that replies are 4yz if they can be successful if repeated
#       without any change in command form or in properties of the sender or receiver (that is, the
#       command is repeated identically and the receiver does not put up a new implementation).
#
#   5yz  Permanent Negative Completion reply
#       The command was not accepted and the requested action did not occur. The SMTP client SHOULD
#       NOT repeat the exact request (in the same sequence). Even some "permanent" error conditions
#       can be corrected, so the human user may want to direct the SMTP client to reinitiate the
#       command sequence by direct action at some point in the future (e.g., after the spelling has
#       been changed, or the user has altered the account status).
#
#   The second digit encodes responses in specific categories:
#
#       x0z  Syntax: These replies refer to syntax errors, syntactically correct commands that do
#            not fit any functional category, and unimplemented or superfluous commands.
#       x1z  Information: These are replies to requests for information, such as status or help.
#       x2z  Connections: These are replies referring to the transmission channel.
#       x3z  Unspecified.
#       x4z  Unspecified.
#       x5z  Mail system: These replies indicate the status of the receiver mail system vis-a-vis
#            the requested transfer or other mail system action.

state $ReplyCode2 = [
    # http://www.ietf.org/rfc/rfc5321.txt
    # 211   System status, or system help reply
    # 214   Help message (Information on how to use the receiver or the meaning of a particular
    #       non-standard command; this reply is useful only to the human user)
    # 220   <domain> Service ready
    # 221   <domain> Service closing transmission channel
    # 235   Authentication successful (See RFC2554)
    # 250   Requested mail action okay, completed
    # 251   User not local; will forward to <forward-path> (See Section 3.4)
    # 252   Cannot VRFY user, but will accept message and attempt delivery (See Section 3.5.3)
    # 253   OK, <n> pending messages for node <domain> started (See RFC1985)
    # 354   Start mail input; end with <CRLF>.<CRLF>
    211, 214, 220, 221, 235, 250, 251, 252, 253, 354
];
state $ReplyCode4 = [
    # 421   <domain> Service not available, closing transmission channel (This may be a reply to
    #       any command if the service knows it must shut down)
    # 422   (See RFC5248)
    # 430   (See RFC5248)
    # 432   A password transition is needed (See RFC4954)
    # 450   Requested mail action not taken: mailbox unavailable (e.g., mailbox busy or temporarily
    #       blocked for policy reasons)
    # 451   Requested action aborted: local error in processing
    # 452   Requested action not taken: insufficient system storage
    # 453   You have no mail (See RFC2645)
    # 454   Temporary authentication failure (See RFC4954)
    # 455   Server unable to accommodate parameters
    # 456   please retry immediately the message over IPv4 because it fails SPF and DKIM (See
    #       https://datatracker.ietf.org/doc/html/draft-martin-smtp-ipv6-to-ipv4-fallback-00
    # 458   Unable to queue messages for node <domain> (See RFC1985)
    # 459   Node <domain> not allowed: <reason> (See RFC51985)
    421, 450, 451, 452, 422, 430, 432, 453, 454, 455, 456, 458, 459
];
state $ReplyCode5 = [
    # 500   Syntax error, command unrecognized (This may include errors such as command line too long)
    # 501   Syntax error in parameters or arguments
    # 502   Command not implemented (see Section 4.2.4)
    # 503   Bad sequence of commands
    # 504   Command parameter not implemented
    # 520   Please use the correct QHLO ID (See https://datatracker.ietf.org/doc/id/draft-fanf-smtp-quickstart-01.txt)
    # 521   Host does not accept mail (See RFC7504)
    # 523   Encryption Needed (See RFC5248)
    # 524   (See RFC5248)
    # 525   User Account Disabled (See RFC5248)
    # 530   Authentication required (See RFC4954)
    # 533   (See RFC5248)
    # 534   Authentication mechanism is too weak (See RFC4954)
    # 535   Authentication credentials invalid (See RFC4954)
    # 538   Encryption required for requested authentication mechanism (See RFC4954)
    # 550   Requested action not taken: mailbox unavailable (e.g., mailbox not found, no access, or
    #       command rejected for policy reasons)
    # 551   User not local; please try <forward-path> (See Section 3.4)
    # 552   Requested mail action aborted: exceeded storage allocation
    # 553   Requested action not taken: mailbox name not allowed (e.g., mailbox syntax incorrect)
    # 554   Transaction failed (Or, in the case of a connection-opening response, "No SMTP service here")
    # 555   MAIL FROM/RCPT TO parameters not recognized or not implemented
    # 556   Domain does not accept mail (See RFC7504)
    550, 552, 553, 551, 521, 525, 502, 520, 523, 524, 530, 533, 534, 535, 538, 551, 555, 556, 554,
    500, 501, 502, 503, 504,
];
state $CodeOfSMTP = { '2' => $ReplyCode2, '4' => $ReplyCode4, '5' => $ReplyCode5 };

sub test {
    # Check whether a reply code is a valid code or not
    # @param    [String] argv1  Reply Code(DSN)
    # @return   [Boolean]       0 = Invalid reply code, 1 = Valid reply code
    # @see      code
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift || return undef;
    my $reply = int $argv1;
    my $first = int($reply / 100);

    return 0 if $reply < 200;
    return 0 if $reply > 559;
    return 0 if $reply % 100 > 59;

    if( $first == 2 ) {
        # 2yz
        return 0 if $reply < 211;
        return 0 if $reply > 252;
        return 0 if $reply > 221 && $reply < 250;
        return 1;
    }

    if( $first == 3 ) {
        # 3yz
        return 0 unless $reply == 354;
        return 1;
    }
    return 1;
}

sub find {
    # Get an SMTP reply code from the given string
    # @param    [String] argv1  String including SMTP reply code like 550
    # @param    [String] argv2  Status code like 5.1.1 or 2 or 4 or 5
    # @return   [String]        SMTP reply code or empty if the first argument
    #                           did not include SMTP Reply Code value
    # @since v4.14.0
    my $class = shift;
    my $argv1 = shift || return undef;
    my $argv2 = shift || 0;
    return '' if length $argv1 < 3;
    return '' if index(uc($argv1), 'X-UNIX;') > -1;

    my $statuscode = substr($argv2, 0, 1) || '';
    my $replycodes = $statuscode eq '5' || $statuscode eq '4' || $statuscode eq '2'
                     ? $CodeOfSMTP->{ $statuscode }
                     : [$CodeOfSMTP->{'5'}->@*, $CodeOfSMTP->{'4'}->@*, $CodeOfSMTP->{'2'}->@*];
    my $esmtperror = ' '.$argv1.' ';
    my $esmtpreply = '';    # SMTP Reply Code
    my $replyindex = -1;    # A position of SMTP reply code found by the index()
    my $formerchar =  0;    # a character that is one character before the SMTP reply code
    my $latterchar =  0;    # a character that is one character after  the SMTP reply code

    for my $e ( @$replycodes ) {
        # Try to find an SMTP Reply Code from the given string
        $replyindex = index($esmtperror, $e); next if $replyindex == -1;
        $formerchar = ord(substr($esmtperror, $replyindex - 1, 1)) || 0;
        $latterchar = ord(substr($esmtperror, $replyindex + 3, 1)) || 0;

        next if $formerchar > 45 && $formerchar < 58;
        next if $latterchar > 45 && $latterchar < 58;
        $esmtpreply = $e;
        last;
    }
    return $esmtpreply;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::SMTP::Reply - SMTP reply code related class

=head1 SYNOPSIS

    use Sisimai::SMTP::Reply;
    print Sisimai::SMTP::Reply->find('550 5.1.1 Unknown user');  # 550

=head1 DESCRIPTION

Sisimai::SMTP::Reply is utilities for getting SMTP reply code value from given error message text.

=head1 CLASS METHODS

=head2 C<B<test(I<D.S.N.>)>>

C<test()> checks whether a reply code is a valid code or not.

    print Sisimai::SMTP::Reply->test('521');    # 1
    print Sisimai::SMTP::Reply->test('386');    # 0
    print Sisimai::SMTP::Reply->test('101');    # 0
    print Sisimai::SMTP::Reply->test('640');    # 0

=head2 C<B<find(I<String>)>>

C<find()> returns an SMTP reply code value.

    print Sisimai::SMTP::Reply->find('5.0.0');                  # ''
    print Sisimai::SMTP::Reply->find('550 5.1.1 User unknown'); # 550
    print Sisimai::SMTP::Reply->find('421 Delivery Expired');   # 421

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016,2018,2020,2021,2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

