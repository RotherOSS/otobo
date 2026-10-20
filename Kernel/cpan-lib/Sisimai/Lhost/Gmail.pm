package Sisimai::Lhost::Gmail;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Gmail: https://mail.google.com' }
sub inquire {
    # Detect an error from Gmail
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # Google Mail
    # From: Mail Delivery Subsystem <mailer-daemon@googlemail.com>
    # Received: from vw-in-f109.1e100.net [74.125.113.109] by ...
    #
    # * Check the body part
    #   This is an automatically generated Delivery Status Notification
    #   Delivery to the following recipient failed permanently:
    #
    #        recipient-address-here@example.jp
    #
    #   Technical details of permanent failure:
    #   Google tried to deliver your message, but it was rejected by the
    #   recipient domain. We recommend contacting the other email provider
    #   for further information about the cause of this error. The error
    #   that the other server returned was:
    #   550 550 <recipient-address-heare@example.jp>: User unknown (state 14).
    #
    #   -- OR --
    #   THIS IS A WARNING MESSAGE ONLY.
    #
    #   YOU DO NOT NEED TO RESEND YOUR MESSAGE.
    #
    #   Delivery to the following recipient has been delayed:
    #
    #        mailboxfull@example.jp
    #
    #   Message will be retried for 2 more day(s)
    #
    #   Technical details of temporary failure:
    #   Google tried to deliver your message, but it was rejected by the recipient
    #   domain. We recommend contacting the other email provider for further infor-
    #   mation about the cause of this error. The error that the other server re-
    #   turned was: 450 450 4.2.2 <mailboxfull@example.jp>... Mailbox Full (state 14).
    #
    #   -- OR --
    #
    #   Delivery to the following recipient failed permanently:
    #
    #        userunknown@example.jp
    #
    #   Technical details of permanent failure:=20
    #   Google tried to deliver your message, but it was rejected by the server for=
    #    the recipient domain example.jp by mx.example.jp. [192.0.2.59].
    #
    #   The error that the other server returned was:
    #   550 5.1.1 <userunknown@example.jp>... User Unknown
    #
    return undef unless rindex($mhead->{'from'}, '<mailer-daemon@googlemail.com>') > -1;
    return undef unless index($mhead->{'subject'}, 'Delivery Status Notification') > -1;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['----- Original message -----', '----- Message header follows -----'];
    state $startingof = {
        'message' => ['Delivery to the following recipient'],
        'error'   => ['The error that the other server returned was:'],
    };
    state $messagesof = {
        'expired' => [
            'DNS Error: Could not contact DNS servers',
            'Delivery to the following recipient has been delayed',
            'The recipient server did not accept our requests to connect',
        ],
        'hostunknown' => [
            'DNS Error: Domain name not found',
            'DNS Error: DNS server returned answer with no data',
        ],
    };
    state $statetable = {
        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 500 Remote server does not support TLS (state 6).
        '6'  => { 'command' => 'MAIL', 'reason' => 'systemerror' },

        # https://www.google.td/support/forum/p/gmail/thread?tid=08a60ebf5db24f7b&hl=en
        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 535 SMTP AUTH failed with the remote server. (state 8).
        '8'  => { 'command' => 'AUTH', 'reason' => 'systemerror' },

        # https://www.google.co.nz/support/forum/p/gmail/thread?tid=45208164dbca9d24&hl=en
        # Technical details of temporary failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 454 454 TLS missing certificate: error:0200100D:system library:fopen:Permission denied (#4.3.0) (state 9).
        '9'  => { 'command' => 'AUTH', 'reason' => 'systemerror' },

        # https://www.google.com/support/forum/p/gmail/thread?tid=5cfab8c76ec88638&hl=en
        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 500 Remote server does not support SMTP Authenticated Relay (state 12).
        '12' => { 'command' => 'AUTH', 'reason' => 'relayingdenied' },

        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 550 550 5.7.1 <****@gmail.com>... Access denied (state 13).
        '13' => { 'command' => 'EHLO', 'reason' => 'blocked' },

        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 550 550 5.1.1 <******@*********.**>... User Unknown (state 14).
        # 550 550 5.2.2 <*****@****.**>... Mailbox Full (state 14).
        #
        '14' => { 'command' => 'RCPT', 'reason' => 'userunknown' },

        # https://www.google.cz/support/forum/p/gmail/thread?tid=7090cbfd111a24f9&hl=en
        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 550 550 5.7.1 SPF unauthorized mail is prohibited. (state 15).
        # 554 554 Error: no valid recipients (state 15).
        '15' => { 'command' => 'DATA', 'reason' => 'filtered' },

        # https://www.google.com/support/forum/p/Google%20Apps/thread?tid=0aac163bc9c65d8e&hl=en
        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 550 550 <****@***.**> No such user here (state 17).
        # 550 550 #5.1.0 Address rejected ***@***.*** (state 17).
        '17' => { 'command' => 'DATA', 'reason' => 'filtered' },

        # Technical details of permanent failure:
        # Google tried to deliver your message, but it was rejected by the recipient domain.
        # We recommend contacting the other email provider for further information about the
        # cause of this error. The error that the other server returned was:
        # 550 550 Unknown user *****@***.**.*** (state 18).
        '18' => { 'command' => 'DATA', 'reason' => 'filtered' },
    };

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
        }
        next unless $readcursor & $indicators->{'deliverystatus'};
        next unless length $e;

        # Technical details of permanent failure:=20
        # Google tried to deliver your message, but it was rejected by the recipient =
        # domain. We recommend contacting the other email provider for further inform=
        # ation about the cause of this error. The error that the other server return=
        # ed was: 554 554 5.7.0 Header error (state 18).
        #
        # -- OR --
        #
        # Technical details of permanent failure:=20
        # Google tried to deliver your message, but it was rejected by the server for=
        # the recipient domain example.jp by mx.example.jp. [192.0.2.49].
        #
        # The error that the other server returned was:
        # 550 5.1.1 <userunknown@example.jp>... User Unknown
        #
        $v = $dscontents->[-1];

        if( index($e, ' ') == 0 && index($e, '@') > 0 ) {
            # kijitora@example.jp: 550 5.2.2 <kijitora@example>... Mailbox Full
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }

            my $r = Sisimai::Address->s3s4(substr($e, rindex($e, ' ') + 1,));
            next unless Sisimai::Address->is_emailaddress($r);
            $v->{'recipient'} = $r;
            $recipients++;

        } else {
            $v->{'diagnosis'} .= $e.' ';
        }
    }
    return undef unless $recipients;

    my $p1 = -1; my $p2 = -1;
    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        unless( $e->{'rhost'} ) {
            # Get the value of remote host
            if( Sisimai::String->aligned(\$e->{'diagnosis'}, [' by ', '. [', ']. ']) ) {
                # Google tried to deliver your message, but it was rejected by # the server
                # for the recipient domain example.jp by mx.example.jp. [192.0.2.153].
                $p1 = rindex($e->{'diagnosis'}, ' by ');
                $p2 = rindex($e->{'diagnosis'}, '. [' );
                my $hostname = substr($e->{'diagnosis'}, $p1 + 4, $p2 - $p1 - 4);
                my $ipv4addr = substr($e->{'diagnosis'}, $p2 + 3, rindex($e->{'diagnosis'}, ']. ') - $p2 - 3);
                my $lastchar = ord(uc substr($hostname, -1, 1));

                $e->{'rhost'}   = $hostname if $lastchar > 64 && $lastchar < 91;
                $e->{'rhost'} ||= $ipv4addr;
            }
        }

        $p1 = rindex($e->{'diagnosis'}, ' ');
        $p2 = rindex($e->{'diagnosis'}, ')');
        my $statecode0 = substr($e->{'diagnosis'}, $p1 + 1, $p2 - $p1 - 1) || 0;
        if( exists $statetable->{ $statecode0 } ) {
            # (state *)
            $e->{'reason'}  = $statetable->{ $statecode0 }->{'reason'};
            $e->{'command'} = $statetable->{ $statecode0 }->{'command'};
        } else {
            # No state code
            SESSION: for my $r ( keys %$messagesof ) {
                # Verify each regular expression of session errors
                next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
                $e->{'reason'} = $r;
                last;
            }
        }
        next unless $e->{'reason'};

        # Set pseudo status code and override bounce reason
        $e->{'status'} = Sisimai::SMTP::Status->find($e->{'diagnosis'}) || '';
        next if length($e->{'status'}) == 0 || index($e->{'status'}, '.0') > 0;
        $e->{'reason'} = Sisimai::SMTP::Status->name($e->{'status'}) || '';
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Gmail - bounce mail parser class for C<Gmail>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Gmail;

=head1 DESCRIPTION

Sisimai::Lhost::Gmail parses a bounce email which created by C<Gmail>. Methods in the module are
called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Gmail->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
