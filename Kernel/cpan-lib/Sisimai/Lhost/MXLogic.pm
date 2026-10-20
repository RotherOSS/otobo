package Sisimai::Lhost::MXLogic;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

# Based on Sisimai::Lhost::Exim
sub description { 'McAfee SaaS' }
sub inquire {
    # Detect an error from MXLogic
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # X-MX-Bounce: mta/src/queue/bounce
    # X-MXL-NoteHash: ffffffffffffffff-0000000000000000000000000000000000000000
    # X-MXL-Hash: 4c9d4d411993da17-bbd4212b6c887f6c23bab7db4bd87ef5edc00758
    $match ||= 1 if defined $mhead->{'x-mx-bounce'};
    $match ||= 1 if defined $mhead->{'x-mxl-hash'};
    $match ||= 1 if defined $mhead->{'x-mxl-notehash'};
    $match ||= 1 if index($mhead->{'from'}, 'Mail Delivery System') == 0;
    $match ||= 1 if grep { index($mhead->{'subject'}, $_) > -1 } ( 'Delivery Status Notification',
                                                                   'Mail delivery failed',
                                                                   'Warning: message ');
    return undef unless $match;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Included is a copy of the message header:'];
    state $startingof = { 'message' => ['This message was created automatically by mail delivery software.'] };
    state $recommands = [
        qr/SMTP error from remote (?:mail server|mailer) after ([A-Za-z]{4})/,
        qr/SMTP error from remote (?:mail server|mailer) after end of ([A-Za-z]{4})/,
    ];
    state $messagesof = {
        'userunknown' => ['user not found'],
        'hostunknown' => [
            'all host address lookups failed permanently',
            'all relevant MX records point to non-existent hosts',
            'Unrouteable address',
        ],
        'mailboxfull' => [
            'mailbox is full',
            'error: quota exceed',
        ],
        'notaccept' => [
            'an MX or SRV record indicated no SMTP service',
            'no host found for existing SMTP connection',
        ],
        'syntaxerror' => [
            'angle-brackets nested too deep',
            'expected word or "<"',
            'domain missing in source-routed address',
            'malformed address:',
        ],
        'systemerror' => [
            'delivery to file forbidden',
            'delivery to pipe forbidden',
            'local delivery failed',
            'LMTP error after ',
        ],
        'contenterror' => ['Too many "Received" headers'],
    };
    state $delayedfor = [
        'retry timeout exceeded',
        'No action is required on your part',
        'retry time not reached for any host after a long failure period',
        'all hosts have been failing for a long time and were last tried',
        'Delay reason: ',
        'has been frozen',
        'was frozen on arrival by ',
    ];

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
            next;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};
        next unless length $e;

        # This message was created automatically by mail delivery software.
        #
        # A message that you sent could not be delivered to one or more of its
        # recipients. This is a permanent error. The following address(es) failed:
        #
        #  kijitora@example.jp
        #    SMTP error from remote mail server after RCPT TO:<kijitora@example.jp>:
        #    host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
        $v = $dscontents->[-1];

        if( index($e, '  <') == 0 && index($e, '@') > 1 && index($e, '>:') > 1 ) {
            # A message that you have sent could not be delivered to one or more
            # recipients.  This is a permanent error.  The following address failed:
            #
            #  <kijitora@example.co.jp>: 550 5.1.1 ...
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = substr($e, 3, index($e, '>:') - 3);
            $v->{'diagnosis'} = substr($e, index($e, '>:') + 3,);
            $recipients++;

        } elsif( scalar @$dscontents == $recipients ) {
            # Error message
            next unless length $e;
            $v->{'diagnosis'} .= $e.' ';
        }
    }
    return undef unless $recipients;

    # Get the name of the local MTA
    # Received: from marutamachi.example.org (c192128.example.net [192.0.2.128])
    my $receivedby = $mhead->{'received'} || [];
    my $recvdtoken = Sisimai::RFC5322->received($receivedby->[-1]);

    for my $e ( @$dscontents ) {
        # Check the error message, the rhost, the lhost, and the smtp command.
        $e->{'diagnosis'} =~ s/[-]{2}.*\z//g;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});

        unless( length $e->{'rhost'} ) {
            # Get the remote host name
            my $p1 = index($e->{'diagnosis'}, 'host ');
            my $p2 = index($e->{'diagnosis'}, ' ', $p1 + 5);

            # host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
            # Get the remote host name from the error message or the Received header.
            $e->{'rhost'}   = substr($e->{'diagnosis'}, $p1 + 5, $p2 - $p1 - 5) if $p1 > -1;
            $e->{'rhost'} ||= $recvdtoken->[1];
        }
        $e->{'lhost'}   ||=  $recvdtoken->[0];

        unless( $e->{'command'} ) {
            # Get the SMTP command name for the session
            SMTP: for my $r ( @$recommands ) {
                # Verify each regular expression of SMTP commands
                next unless $e->{'diagnosis'} =~ $r;
                $e->{'command'} = uc $1;
                last;
            }

            # Detect the reason of bounce
            if( $e->{'command'} eq 'MAIL' ) {
                # MAIL | Connected to 192.0.2.135 but sender was rejected.
                $e->{'reason'} = 'rejected';

            } elsif( $e->{'command'} eq 'HELO' || $e->{'command'} eq 'EHLO' ) {
                # HELO | Connected to 192.0.2.135 but my name was rejected.
                $e->{'reason'} = 'blocked';

            } else {
                # Verify each regular expression of session errors
                SESSION: for my $r ( keys %$messagesof ) {
                    # Check each regular expression
                    next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
                    $e->{'reason'} = $r;
                    last;
                }

                unless( $e->{'reason'} ) {
                    # The reason "expired"
                    $e->{'reason'} = 'expired' if grep { index($e->{'diagnosis'}, $_) > -1 } @$delayedfor;
                }
            }
        }
        $e->{'command'} ||= '';
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::MXLogic - bounce mail parser class for C<MX Logic>.

=head1 SYNOPSIS

    use Sisimai::Lhost::MXLogic;

=head1 DESCRIPTION

Sisimai::Lhost::MXLogic parses a bounce email which created by C<McAfee SaaS (formerly MX Logic)>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::MXLogic->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
