package Sisimai::Lhost::Postfix;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Postfix' }
sub inquire {
    # Parse bounce messages from Postfix
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $sessx = 0;

    if( index($mhead->{'subject'}, 'SMTP server: errors from ') > 0 ) {
        # src/smtpd/smtpd_chat.c:|337: post_mail_fprintf(notice, "Subject: %s SMTP server: errors from %s",
        # src/smtpd/smtpd_chat.c:|338:   var_mail_name, state->namaddr);
        $match++;
        $sessx++;
    } else {
        # Subject: Undelivered Mail Returned to Sender
        $match++ if $mhead->{'subject'} eq 'Undelivered Mail Returned to Sender';
    }
    return undef if $match == 0;
    return undef if $mhead->{'x-aol-ip'};

    require Sisimai::SMTP::Command;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822', 'Content-Type: text/rfc822-headers'];
    state $startingof = {
        # Postfix manual - bounce(5) - http://www.postfix.org/bounce.5.html
        'message' => [
            ['The ', 'Postfix '],           # The Postfix program, The Postfix on <os> program
            ['The ', 'mail system'],        # The mail system
            ['The ', 'program'],            # The <name> pogram
            ['This is the', 'Postfix'],     # This is the Postfix program
            ['This is the', 'mail system'], # This is the mail system at host <hostname>
        ],
    };

    my $permessage = {};    # (Hash) Store values of each Per-Message field
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $anotherset = {};    # (Hash) Another error information
    my $nomessages = 0;     # (Integer) Delivery report unavailable
    my @commandset;         # (Array) ``in reply to * command'' list
    my $v = undef;
    my $p = '';

    if( $sessx ) {
        # The message body starts with 'Transcript of session follows.'
        require Sisimai::SMTP::Transcript;
        my $transcript = Sisimai::SMTP::Transcript->rise(\$emailparts->[0], 'In:', 'Out:');

        return undef unless $transcript;
        return undef unless scalar @$transcript;

        for my $e ( @$transcript ) {
            # Pick email addresses, error messages, and the last SMTP command.
            $v ||= $dscontents->[-1];
            $p   = $e->{'response'};

            if( $e->{'command'} eq 'EHLO' || $e->{'command'} eq 'HELO' ) {
                # Use the argument of EHLO/HELO command as a value of "lhost"
                $v->{'lhost'} = $e->{'argument'};

            } elsif( $e->{'command'} eq 'MAIL' ) {
                # Set the argument of "MAIL" command to pseudo To: header of the original message
                $emailparts->[1] .= sprintf("To: %s\n", $e->{'argument'}) unless length $emailparts->[1];

            } elsif( $e->{'command'} eq 'RCPT' ) {
                # RCPT TO: <...>
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the transcript of session
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $e->{'argument'};
                $recipients++;
            }
            next if int($p->{'reply'}) < 400;

            push @commandset, $e->{'command'};
            $v->{'diagnosis'} ||= join ' ', $p->{'text'}->@*;
            $v->{'replycode'} ||= $p->{'reply'};
            $v->{'status'}    ||= $p->{'status'};
        }
    } else {
        my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
        my $readcursor = 0;     # (Integer) Points the current cursor position

        # The message body is a general bounce mail message of Postfix
        for my $e ( split("\n", $emailparts->[0]) ) {
            # Read error messages and delivery status lines from the head of the email to the previous
            # line of the beginning of the original message.
            unless( $readcursor ) {
                # Beginning of the bounce message or message/delivery-status part
                $readcursor |= $indicators->{'deliverystatus'} if grep { Sisimai::String->aligned(\$e, $_) } $startingof->{'message'}->@*;
                next;
            }
            next unless $readcursor & $indicators->{'deliverystatus'};
            next unless length $e;

            if( my $f = Sisimai::RFC1894->match($e) ) {
                # $e matched with any field defined in RFC3464
                next unless my $o = Sisimai::RFC1894->field($e);
                $v = $dscontents->[-1];

                if( $o->[-1] eq 'addr' ) {
                    # Final-Recipient: rfc822; kijitora@example.jp
                    # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                    if( $o->[0] eq 'final-recipient' ) {
                        # Final-Recipient: rfc822; kijitora@example.jp
                        if( $v->{'recipient'} ) {
                            # There are multiple recipient addresses in the message body.
                            push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                            $v = $dscontents->[-1];
                        }
                        $v->{'recipient'} = $o->[2];
                        $recipients++;

                    } else {
                        # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                        $v->{'alias'} = $o->[2];
                    }
                } elsif( $o->[-1] eq 'code' ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'} = $o->[1];
                    $v->{'spec'} = 'SMTP' if $v->{'spec'} eq 'X-POSTFIX';
                    $v->{'diagnosis'} = $o->[2];

                } else {
                    # Other DSN fields defined in RFC3464
                    next unless exists $fieldtable->{ $o->[0] };
                    $v->{ $fieldtable->{ $o->[0] } } = $o->[2];

                    next unless $f == 1;
                    $permessage->{ $fieldtable->{ $o->[0] } } = $o->[2];
                }
            } else {
                # If you do so, please include this problem report. You can
                # delete your own text from the attached returned message.
                #
                #           The mail system
                #
                # <userunknown@example.co.jp>: host mx.example.co.jp[192.0.2.153] said: 550
                # 5.1.1 <userunknown@example.co.jp>... User Unknown (in reply to RCPT TO command)
                if( index($p, 'Diagnostic-Code:') == 0 && index($e, ' ') > -1 ) {
                    # Continued line of the value of Diagnostic-Code header
                    $v->{'diagnosis'} .= ' '.Sisimai::String->sweep($e);
                    $e = 'Diagnostic-Code: '.$e;

                } elsif( Sisimai::String->aligned(\$e, ['X-Postfix-Sender:', 'rfc822;', '@']) ) {
                    # X-Postfix-Sender: rfc822; shironeko@example.org
                    $emailparts->[1] .= sprintf("X-Postfix-Sender: %s\n", substr($e, index($e, ';') + 1,));

                } else {
                    # Alternative error message and recipient
                    if( index($e, ' (in reply to ') > -1 || index($e, 'command)') > -1 ) {
                        # 5.1.1 <userunknown@example.co.jp>... User Unknown (in reply to RCPT TO
                        my $q = Sisimai::SMTP::Command->find($e);
                        push @commandset, $q if $q;
                        $anotherset->{'diagnosis'} .= ' '.$e if $anotherset->{'diagnosis'};

                    } elsif( Sisimai::String->aligned(\$e, ['<', '@', '>', '(expanded from <', '):']) ) {
                        # <r@example.ne.jp> (expanded from <kijitora@example.org>): user ...
                        my $p1 = index($e, '> ');
                        my $p2 = index($e, '(expanded from ', $p1);
                        my $p3 = index($e, '>): ', $p2 + 14);
                        $anotherset->{'recipient'} = Sisimai::Address->s3s4(substr($e, 0, $p1));
                        $anotherset->{'alias'}     = Sisimai::Address->s3s4(substr($e, $p2 + 15, $p3 - $p2 - 15));
                        $anotherset->{'diagnosis'} = substr($e, $p3 + 3,);

                    } elsif( index($e, '<') == 0 && Sisimai::String->aligned(\$e, ['<', '@', '>:']) ) {
                        # <kijitora@exmaple.jp>: ...
                        $anotherset->{'recipient'} = Sisimai::Address->s3s4(substr($e, 0, index($e, '>')));
                        $anotherset->{'diagnosis'} = substr($e, index($e, '>:') + 2,);

                    } elsif( index($e, '--- Delivery report unavailable ---') > -1 ) {
                        # postfix-3.1.4/src/bounce/bounce_notify_util.c
                        # bounce_notify_util.c:602|if (bounce_info->log_handle == 0
                        # bounce_notify_util.c:602||| bounce_log_rewind(bounce_info->log_handle)) {
                        # bounce_notify_util.c:602|if (IS_FAILURE_TEMPLATE(bounce_info->template)) {
                        # bounce_notify_util.c:602|    post_mail_fputs(bounce, "");
                        # bounce_notify_util.c:602|    post_mail_fputs(bounce, "\t--- delivery report unavailable ---");
                        # bounce_notify_util.c:602|    count = 1;              /* xxx don't abort */
                        # bounce_notify_util.c:602|}
                        # bounce_notify_util.c:602|} else {
                        $nomessages = 1;

                    } else {
                        # Get an error message continued from the previous line
                        next unless $anotherset->{'diagnosis'};
                        $anotherset->{'diagnosis'} .= ' '.substr($e, 4,) if index($e, '    ') == 0;
                    }
                }
            } # End of message/delivery-status
        } continue {
            # Save the current line for the next loop
            $p = $e;
        }
    } # End of for()

    unless( $recipients ) {
        # Fallback: get a recipient address from error messages
        if( defined $anotherset->{'recipient'} && $anotherset->{'recipient'} ) {
            # Set a recipient address
            $dscontents->[-1]->{'recipient'} = $anotherset->{'recipient'};
            $recipients++;

        } else {
            # Get a recipient address from message/rfc822 part if the delivery report was unavailable:
            # '--- Delivery report unavailable ---'
            my $p1 = index($emailparts->[1], "\nTo: ");
            my $p2 = index($emailparts->[1], "\n", $p1 + 6);
            if( $nomessages && $p1 > 0 ) {
                # Try to get a recipient address from To: field in the original
                # message at message/rfc822 part
                $dscontents->[-1]->{'recipient'} = Sisimai::Address->s3s4(substr($emailparts->[1], $p1 + 5, $p2 - $p1 - 5));
                $recipients++;
            }
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{ $_ } ||= $permessage->{ $_ } || '' for keys %$permessage;

        if( $anotherset->{'diagnosis'} ) {
            # Copy alternative error message
            $anotherset->{'diagnosis'} = Sisimai::String->sweep($anotherset->{'diagnosis'});
            $e->{'diagnosis'}        ||= $anotherset->{'diagnosis'};

            if( $e->{'diagnosis'} =~ /\A\d+\z/ ) {
                # Override the value of diagnostic code message
                $e->{'diagnosis'} = $anotherset->{'diagnosis'};

            } else {
                # More detailed error message is in "$anotherset"
                my $as = ''; # status
                my $ar = ''; # replycode

                if( $e->{'status'} eq '' || substr($e->{'status'}, -4, 4) eq '.0.0' ) {
                    # Check the value of D.S.N. in $anotherset
                    $as = Sisimai::SMTP::Status->find($anotherset->{'diagnosis'}) || '';
                    if( length($as) > 0 && substr($as, -4, 4) ne '.0.0' ) {
                        # The D.S.N. is neither an empty nor *.0.0
                        $e->{'status'} = $as;
                    }
                }

                if( $e->{'replycode'} eq '' || substr($e->{'replycode'}, -2, 2) eq '00' ) {
                    # Check the value of SMTP reply code in $anotherset
                    $ar = Sisimai::SMTP::Reply->find($anotherset->{'diagnosis'}) || '';
                    if( length($ar) > 0 && substr($ar, -2, 2) ne '00' ) {
                        # The SMTP reply code is neither an empty nor *00
                        $e->{'replycode'} = $ar;
                    }
                }

                while(1) {
                    # Replace $e->{'diagnosis'} with the value of $anotherset->{'diagnosis'} when
                    # all the following conditions have not matched.
                    last if length($as.$ar) == 0;
                    last if length($anotherset->{'diagnosis'}) < length($e->{'diagnosis'});
                    last if index($anotherset->{'diagnosis'}, $e->{'diagnosis'}) == -1;

                    $e->{'diagnosis'} = $anotherset->{'diagnosis'};
                    last;
                }
            }
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'command'}   = shift @commandset || Sisimai::SMTP::Command->find($e->{'diagnosis'}) || '';
        $e->{'command'} ||= 'HELO' if index($e->{'diagnosis'}, 'refused to talk to me:') > -1;
        $e->{'spec'}    ||= 'SMTP' if Sisimai::String->aligned(\$e->{'diagnosis'}, ['host ', ' said:']);
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Postfix - bounce mail parser class for C<Postfix>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Postfix;

=head1 DESCRIPTION

Sisimai::Lhost::Postfix parses a bounce email which created by C<Postfix>. Methods in the module are
called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Postfix->description;

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

