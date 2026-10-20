package Sisimai::Lhost::X4;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Unknown MTA #4 qmail clones' }
sub inquire {
    # Detect an error from Unknown MTA #4, qmail clones
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.23
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $tryto = [['(qmail ', 'invoked for bounce)'], ['(qmail ', 'invoked from ', 'network)']];

    # Pre process email headers and the body part of the message which generated
    # by qmail, see https://cr.yp.to/qmail.html
    #   e.g.) Received: (qmail 12345 invoked for bounce); 29 Apr 2009 12:34:56 -0000
    #         Subject: failure notice
    $match ||= 1 if index($mhead->{'subject'}, 'failure notice') == 0;
    $match ||= 1 if index($mhead->{'subject'}, 'Permanent Delivery Failure') == 0;
    for my $e ( $mhead->{'received'}->@* ) {
        # Received: (qmail 2222 invoked for bounce);29 Apr 2017 23:34:45 +0900
        # Received: (qmail 2202 invoked from network); 29 Apr 2018 00:00:00 +0900
        $match ||= 1 if grep { Sisimai::String->aligned(\$e, $_) } $tryto->@*;
    }
    return undef unless $match;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['--- Below this line is a copy of the message.', 'Original message follows.'];
    state $startingof = {
        #  qmail-remote.c:248|    if (code >= 500) {
        #  qmail-remote.c:249|      out("h"); outhost(); out(" does not like recipient.\n");
        #  qmail-remote.c:265|  if (code >= 500) quit("D"," failed on DATA command");
        #  qmail-remote.c:271|  if (code >= 500) quit("D"," failed after I sent the message");
        #
        # Characters: K,Z,D in qmail-qmqpc.c, qmail-send.c, qmail-rspawn.c
        #  K = success, Z = temporary error, D = permanent error
        'error'   => ['Remote host said:'],
        'message' => [
            'He/Her is not ',
            'unable to deliver your message to the following addresses',
            'Su mensaje no pudo ser entregado',
            'This is the machine generated message from mail service',
            'This is the mail delivery agent at',
            'Unable to deliver message to the following address',
            'Unfortunately, your mail was not delivered to the following address:',
            'Your mail message to the following address',
            'Your message to the following addresses',
            "We're sorry.",
        ],
        'rhost'   => ['Giving up on ', 'Connected to ', 'remote host '],
    };
    state $commandset = {
        # Error text regular expressions which defined in qmail-remote.c
        # qmail-remote.c:225|  if (smtpcode() != 220) quit("ZConnected to "," but greeting failed");
        'conn' => [' but greeting failed.'],
        # qmail-remote.c:231|  if (smtpcode() != 250) quit("ZConnected to "," but my name was rejected");
        'ehlo' => [' but my name was rejected.'],
        # qmail-remote.c:238|  if (code >= 500) quit("DConnected to "," but sender was rejected");
        # reason = rejected
        'mail' => [' but sender was rejected.'],
        # qmail-remote.c:249|  out("h"); outhost(); out(" does not like recipient.\n");
        # qmail-remote.c:253|  out("s"); outhost(); out(" does not like recipient.\n");
        # reason = userunknown
        'rcpt' => [' does not like recipient.'],
        # qmail-remote.c:265|  if (code >= 500) quit("D"," failed on DATA command");
        # qmail-remote.c:266|  if (code >= 400) quit("Z"," failed on DATA command");
        # qmail-remote.c:271|  if (code >= 500) quit("D"," failed after I sent the message");
        # qmail-remote.c:272|  if (code >= 400) quit("Z"," failed after I sent the message");
        'data' => [' failed on DATA command', ' failed after I sent the message'],
    };
    state $resmtp = {
        # Error text regular expressions which defined in qmail-remote.c
        # qmail-remote.c:225|  if (smtpcode() != 220) quit("ZConnected to "," but greeting failed");
        'conn' => qr/(?:Error:)?Connected to [^ ]+ but greeting failed[.]/,
        # qmail-remote.c:231|  if (smtpcode() != 250) quit("ZConnected to "," but my name was rejected");
        'ehlo' => qr/(?:Error:)?Connected to [^ ]+ but my name was rejected[.]/,
        # qmail-remote.c:238|  if (code >= 500) quit("DConnected to "," but sender was rejected");
        # reason = rejected
        'mail' => qr/(?:Error:)?Connected to [^ ]+ but sender was rejected[.]/,
        # qmail-remote.c:249|  out("h"); outhost(); out(" does not like recipient.\n");
        # qmail-remote.c:253|  out("s"); outhost(); out(" does not like recipient.\n");
        # reason = userunknown
        'rcpt' => qr/(?:Error:)?[^ ]+ does not like recipient[.]/,
        # qmail-remote.c:265|  if (code >= 500) quit("D"," failed on DATA command");
        # qmail-remote.c:266|  if (code >= 400) quit("Z"," failed on DATA command");
        # qmail-remote.c:271|  if (code >= 500) quit("D"," failed after I sent the message");
        # qmail-remote.c:272|  if (code >= 400) quit("Z"," failed after I sent the message");
        'data' => qr{(?:
             (?:Error:)?[^ ]+[ ]failed[ ]on[ ]DATA[ ]command[.]
            |(?:Error:)?[^ ]+[ ]failed[ ]after[ ]I[ ]sent[ ]the[ ]message[.]
            )
        }x,
    };

    # qmail-send.c:922| ... (&dline[c],"I'm not going to try again; this message has been in the queue too long.\n")) nomem();
    state $hasexpired = 'this message has been in the queue too long.';
    # qmail-remote-fallback.patch
    state $onholdpair = [' does not like recipient.', 'this message has been in the queue too long.'];
    state $failonldap = {
        # qmail-ldap-1.03-20040101.patch:19817 - 19866
        'suspend'     => ['Mailaddress is administrative?le?y disabled'],   # 5.2.1
        'userunknown' => ['Sorry, no mailbox here by that name'],           # 5.1.1
        'exceedlimit' => ['The message exeeded the maximum size the user accepts'], # 5.2.3
        'systemerror' => [
            'Automatic homedir creator crashed',    # 4.3.0
            'Illegal value in LDAP attribute',      # 5.3.5
            'LDAP attribute is not given but mandatory',        # 5.3.5
            'Timeout while performing search on LDAP server',   # 4.4.3
            'Too many results returned but needs to be unique', # 5.3.5
            'Permanent error while executing qmail-forward',    # 5.4.4
            'Temporary error in automatic homedir creation',    # 4.3.0 or 5.3.0
            'Temporary error while executing qmail-forward',    # 4.4.4
            'Temporary failure in LDAP lookup',                 # 4.4.3
            'Unable to contact LDAP server',                    # 4.4.3
            'Unable to login into LDAP server, bad credentials',# 4.4.3
        ],
    };
    state $messagesof = {
        # qmail-local.c:589|  strerr_die1x(100,"Sorry, no mailbox here by that name. (#5.1.1)");
        # qmail-remote.c:253|  out("s"); outhost(); out(" does not like recipient.\n");
        'userunknown' => [
            'no mailbox here by that name',
            'does not like recipient.',
        ],
        # error_str.c:192|  X(EDQUOT,"disk quota exceeded")
        'mailboxfull' => ['disk quota exceeded'],
        # qmail-qmtpd.c:233| ... result = "Dsorry, that message size exceeds my databytes limit (#5.3.4)";
        # qmail-smtpd.c:391| ... out("552 sorry, that message size exceeds my databytes limit (#5.3.4)\r\n"); return;
        'mesgtoobig'  => ['Message size exceeds fixed maximum message size:'],
        # qmail-remote.c:68|  Sorry, I couldn't find any host by that name. (#4.1.2)\n"); zerodie();
        # qmail-remote.c:78|  Sorry, I couldn't find any host named ");
        'hostunknown' => ["Sorry, I couldn't find any host "],
        'systemfull'  => ['Requested action not taken: mailbox unavailable (not enough free space)'],
        'systemerror' => [
            'bad interpreter: No such file or directory',
            'system error',
            'Unable to',
        ],
        'networkerror'=> [
            "Sorry, I wasn't able to establish an SMTP connection",
            "Sorry, I couldn't find a mail exchanger or IP address",
            "Sorry. Although I'm listed as a best-preference MX or A for that host",
        ],
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
            $readcursor |= $indicators->{'deliverystatus'} if grep { index($e, $_) > -1 } $startingof->{'message'}->@*;
            next;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};
        next unless length $e;

        # <kijitora@example.jp>:
        # 192.0.2.153 does not like recipient.
        # Remote host said: 550 5.1.1 <kijitora@example.jp>... User Unknown
        # Giving up on 192.0.2.153.
        $v = $dscontents->[-1];

        if( index($e, '<') == 0 && Sisimai::String->aligned(\$e, ['<', '@', '>', ':']) ) {
            # <kijitora@example.jp>:
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, index($e, '<'),));
            $recipients++;

        } elsif( scalar @$dscontents == $recipients ) {
            # Append error message
            next unless length $e;
            $v->{'diagnosis'} .= $e.' ';
            $v->{'alterrors'}  = $e if index($e, $startingof->{'error'}->[0]) == 0;

            next if $v->{'rhost'};
            for my $r ( $startingof->{'rhost'}->@* ) {
                # Find a remote host name
                my $p1 = index($e, $r); next if $p1 == -1;
                my $cm = length $r;
                my $p2 = index($e, ' ', $p1 + $cm + 1); $p2 = rindex($e, '.') if $p2 == -1;

                $v->{'rhost'} = Sisimai::String->sweep(substr($e, $p1 + $cm, $p2 - $p1 - $cm));
                last;
            }
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        unless( $e->{'command'} ) {
            # Get the SMTP command name for the session
            SMTP: for my $r ( keys %$commandset ) {
                # Verify each regular expression of SMTP commands
                next unless grep { index($e->{'diagnosis'}, $_) > 0 } $commandset->{ $r }->@*;
                $e->{'command'} = uc $r;
                last;
            }

            if( index($e->{'diagnosis'}, 'Sorry, no SMTP connection got far enough; most progress was ') > -1 ) {
                # Get the last SMTP command:from the error message
                $e->{'command'} ||= Sisimai::SMTP::Command->find($e->{'diagnosis'});
            }
        }

        # Detect the reason of bounce
        if( $e->{'command'} eq 'MAIL' ) {
            # MAIL | Connected to 192.0.2.135 but sender was rejected.
            $e->{'reason'} = 'rejected';

        } elsif( $e->{'command'} eq 'HELO' || $e->{'command'} eq 'EHLO' ) {
            # HELO | Connected to 192.0.2.135 but my name was rejected.
            $e->{'reason'} = 'blocked';

        } else {
            # Try to match with each error message in the table
            if( Sisimai::String->aligned(\$e->{'diagnosis'}, $onholdpair) ) {
                # To decide the reason require pattern match with Sisimai::Reason::* modules
                $e->{'reason'} = 'onhold';

            } else {
                SESSION: for my $r ( keys %$messagesof ) {
                    # Verify each regular expression of session errors
                    if( $e->{'alterrors'} ) {
                        # Check the value of "alterrors"
                        next unless grep { index($e->{'alterrors'}, $_) > -1 } $messagesof->{ $r }->@*;
                        $e->{'reason'} = $r;
                    }
                    last if $e->{'reason'};

                    next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
                    $e->{'reason'} = $r;
                    last;
                }

                unless( $e->{'reason'} ) {
                    LDAP: for my $r ( keys %$failonldap ) {
                        # Verify each regular expression of LDAP errors
                        next unless grep { index($e->{'diagnosis'}, $_) > -1 } $failonldap->{ $r }->@*;
                        $e->{'reason'} = $r;
                        last;
                    }
                }

                unless( $e->{'reason'} ) {
                    $e->{'reason'} = 'expired' if index($e->{'diagnosis'}, $hasexpired) > -1;
                }
            }
        }
        $e->{'command'} ||= Sisimai::SMTP::Command->find($e->{'diagnosis'});
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::X4 - bounce mail parser class for Unknown MTA which is developed as a C<qmail> clone.

=head1 SYNOPSIS

    use Sisimai::Lhost::X4;

=head1 DESCRIPTION

Sisimai::Lhost::X4 parses a bounce email which created by some C<qmail> clone. Methods in the module
are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::X4->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

