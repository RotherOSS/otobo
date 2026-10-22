package Sisimai::Lhost::MailRu;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

# Based on Sisimai::Lhost::Exim
sub description { '@mail.ru: https://mail.ru' }
sub inquire {
    # Detect an error from @mail.ru
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.4
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $msgid = $mhead->{'message-id'} || return undef;
    my $mfrom = lc $mhead->{'from'};
    my $match = 0;

    # Message-Id: <E1P1YNN-0003AD-Ga@*.mail.ru>
    $match++ if index($mfrom, 'mailer-daemon@') > -1 && index($mfrom, 'mail.ru') > -1;
    $match++ if index($msgid, '.mail.ru>')      >  0 || index($msgid, 'smailru.net>') >  0;
    $match++ if grep { index($mhead->{'subject'}, $_) > -1 } ( 'Delivery Status Notification',
                                                               'Mail delivery failed',
                                                               'Mail failure',
                                                               'Message frozen',
                                                               'Warning: message ',
                                                               'error(s) in forwarding or filtering');
    return undef unless $match > 2;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['------ This is a copy of the message, including all the headers. ------'];
    state $startingof = { 'message' => ['This message was created automatically by mail delivery software.'] };
    state $recommands = [
        qr/SMTP error from remote (?:mail server|mailer) after ([A-Za-z]{4})/,
        qr/SMTP error from remote (?:mail server|mailer) after end of ([A-Za-z]{4})/,
    ];
    state $messagesof = {
        'expired'     => [
            'retry timeout exceeded',
            'No action is required on your part',
        ],
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
        'notaccept'   => [
            'an MX or SRV record indicated no SMTP service',
            'no host found for existing SMTP connection',
        ],
        'systemerror' => [
            'delivery to file forbidden',
            'delivery to pipe forbidden',
            'local delivery failed',
        ],
        'contenterror'=> ['Too many "Received" headers '],
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

        # Это письмо создано автоматически
        # сервером Mail.Ru, # отвечать на него не
        # нужно.
        #
        # К сожалению, Ваше письмо не может
        # быть# доставлено одному или нескольким
        # получателям:
        #
        # **********************
        #
        # This message was created automatically by mail delivery software.
        #
        # A message that you sent could not be delivered to one or more of its
        # recipients. This is a permanent error. The following address(es) failed:
        #
        #  kijitora@example.jp
        #    SMTP error from remote mail server after RCPT TO:<kijitora@example.jp>:
        #    host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
        $v = $dscontents->[-1];

        if( index($e, '  ') == 0 && index($e, '    ') < 0 && index($e, '@') > 1 ) {
            #   kijitora@example.jp
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = substr($e, 2,);
            $recipients++;

        } elsif( scalar @$dscontents == $recipients ) {
            # Error message
            next unless length $e;
            $v->{'diagnosis'} .= $e.' ';

        } else {
            # Error message when email address above does not include '@' and domain part.
            next unless index($e, '    ') == 0;
            $v->{'alterrors'} .= $e.' ';
        }
    }

    unless( $recipients ) {
        # Fallback for getting recipient addresses
        if( defined $mhead->{'x-failed-recipients'} ) {
            # X-Failed-Recipients: kijitora@example.jp
            my @rcptinhead = split(',', $mhead->{'x-failed-recipients'});
            $_ =~ y/ //d for @rcptinhead;
            $recipients = scalar @rcptinhead;

            for my $e ( @rcptinhead ) {
                # Insert each recipient address into @$dscontents
                $dscontents->[-1]->{'recipient'} = $e;
                next if scalar @$dscontents == $recipients;
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
            }
        }
    }
    return undef unless $recipients;

    # Get the name of the local MTA
    # Received: from marutamachi.example.org (c192128.example.net [192.0.2.128])
    my $receivedby = $mhead->{'received'} || [];
    my $recvdtoken = Sisimai::RFC5322->received($receivedby->[-1]);
    my $p1 = -1; my $p2 = -1;

    for my $e ( @$dscontents ) {
        # Check the error message, the rhost, the lhost, and the smtp command.
        if( exists $e->{'alterrors'} && $e->{'alterrors'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} ||= $e->{'alterrors'};
            if( index($e->{'diagnosis'}, '-') == 0 || substr($e->{'diagnosis'}, -2, 2) eq '__' ) {
                # Override the value of diagnostic code message
                $e->{'diagnosis'} = $e->{'alterrors'} if $e->{'alterrors'};
            }
            delete $e->{'alterrors'};
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $p1 = rindex($e->{'diagnosis'}, '__');
        $e->{'diagnosis'} = substr($e->{'diagnosis'}, 0, $p1 - 1) if $p1 > 2;

        unless( $e->{'rhost'} ) {
            # Get the remote host name
            # host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
            $p1 = index($e->{'diagnosis'}, 'host ');
            $p2 = index($e->{'diagnosis'}, ' ', $p1 + 5);
            $e->{'rhost'}   = substr($e->{'diagnosis'}, $p1 + 5, $p2 - $p1 - 5) if $p1 > -1;
            $e->{'rhost'} ||= $recvdtoken->[1];
        }
        $e->{'lhost'} ||= $recvdtoken->[0];

        unless( $e->{'command'} ) {
            # Get the SMTP command name for the session
            SMTP: for my $r ( @$recommands ) {
                # Verify each regular expression of SMTP commands
                next unless $e->{'diagnosis'} =~ $r;
                $e->{'command'} = uc $1;
                last;
            }

            REASON: while(1) {
                # Detect the reason of bounce
                if( $e->{'command'} eq 'MAIL' ) {
                    # MAIL | Connected to 192.0.2.135 but sender was rejected.
                    $e->{'reason'} = 'rejected';

                } elsif( $e->{'command'} eq 'HELO' || $e->{'command'} eq 'EHLO' ) {
                    # HELO | Connected to 192.0.2.135 but my name was rejected.
                    $e->{'reason'} = 'blocked';

                } else {
                    SESSION: for my $r ( keys %$messagesof ) {
                        # Verify each regular expression of session errors
                        next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
                        $e->{'reason'} = $r;
                        last;
                    }
                }
                last;
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

Sisimai::Lhost::MailRu - bounce mail parser class for C<@mail.ru>.

=head1 SYNOPSIS

    use Sisimai::Lhost::MailRu;

=head1 DESCRIPTION

Sisimai::Lhost::MailRu parses a bounce email which created by C<@mail.ru>. Methods in the module are
called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::MailRu->description;

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
