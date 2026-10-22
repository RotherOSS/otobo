package Sisimai::Lhost::X2;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Unknown MTA #2' }
sub inquire {
    # Detect an error from Unknown MTA #2
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.7
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0; $match ||= 1 if index($mhead->{'from'},    'MAILER-DAEMON@')   > -1;
                   $match ||= 1 if index($mhead->{'subject'}, 'Delivery failure') == 0;
                   $match ||= 1 if index($mhead->{'subject'}, 'failure delivery') == 0;
                   $match ||= 1 if index($mhead->{'subject'}, 'failed delivery')  == 0;
    return undef unless $match > 0;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['--- Original message follows.'];
    state $startingof = {
        'message' => [
            'Unable to deliver message to the following address',
            'This Delivery Status Notification is sent from MTA',
        ]
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if grep { index($e, $_) == 0 } $startingof->{'message'}->@*;
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # Message from example.com.
        # Unable to deliver message to the following address(es).
        #
        # <kijitora@example.com>:
        # This user doesn't have a example.com account (kijitora@example.com) [0]
        # 
        # --- OR ---
        # 
        # This Delivery Status Notification is sent from MTA...
        # 
        # Your delivery to the following address has been failed.
        # Please refer to the below for details.
        # ------------------------------------------------------
        # 
        # Delivery failed: kijitora@example.co.jp
        # 192.0.2.25 does not like recipient.
        # Remote host said[Response Message]: 550 5.1.1 <kijitora@example.co.jp>:
        #   Recipient address rejected: User unknown in local recipient table
        # Giving up on 192.0.2.25.
        # STEP: RCPT TO
        $v = $dscontents->[-1];

        if( index($e, '<') == 0                 && Sisimai::String->aligned(\$e, ['<', '@', '>:']) ||
            index($e, 'Delivery failed: ') == 0 && Sisimai::String->aligned(\$e, ['failed: ', '@']) ) {
            # <kijitora@example.com>:
            # Delivery failed: kijitora@example.co.jp
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'}   = substr($e, 1, length($e) - 3 ) if index($e, '<') == 0;
            $v->{'recipient'} ||= substr($e, index($e, ': ') + 2,);
            $recipients++;

        } elsif( index($e, 'STTEP: ') == 0 ) {
            # STEP: RCPT TO
            # STEP: DATA SEND
            $v->{'command'} = Sisimai::SMTP::Command->find($e)

        } elsif( index($e, '-----') != 0 ) {
            # This user doesn't have a example.com account (kijitora@example.com) [0]
            $v->{'diagnosis'} .= ' '.$e;
        }
    }
    return undef unless $recipients;
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::X2 - bounce mail decoder class for X2.

=head1 SYNOPSIS

    use Sisimai::Lhost::X2;

=head1 DESCRIPTION

C<Sisimai::Lhost::X2> decodes a bounce email which created by Unknown MTA #2. Methods in the module
are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::X2->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

