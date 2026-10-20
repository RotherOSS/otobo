package Sisimai::RFC3464;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::Lhost;

# http://tools.ietf.org/html/rfc3464
sub description { 'Fallback Module for MTAs' };
sub inquire {
    # Detect an error for RFC3464
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    return undef unless keys %$mhead;
    return undef unless ref $mbody eq 'SCALAR';

    state $indicators = Sisimai::Lhost->INDICATORS;
    state $startingof = {
        'message' => [
            'content-type: message/delivery-status',
            'content-type: message/disposition-notification',
            'content-type: message/xdelivery-status',
            'content-type: text/plain; charset=',
            'the original message was received at ',
            'this report relates to your message',
            'your message could not be delivered',
            'your message was not delivered to ',
            'your message was not delivered to the following recipients',
        ],
        'rfc822'  => [
            'content-type: message/rfc822',
            'content-type: text/rfc822-headers',
            'return-path: <'
        ],
    };

    require Sisimai::Address;
    require Sisimai::RFC1894;
    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $permessage = {};    # (Hash) Store values of each Per-Message field

    my $dscontents = [Sisimai::Lhost->DELIVERYSTATUS];
    my $rfc822text = '';    # (String) message/rfc822 part text
    my $maybealias = '';    # (String) Original-Recipient field
    my $lowercased = '';    # (String) Lowercased each line of the loop
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $itisbounce = 0;     # (Integer) Flag for that an email is a bounce
    my $connheader = {
        'date'    => '',    # The value of Arrival-Date header
        'rhost'   => '',    # The value of Reporting-MTA header
        'lhost'   => '',    # The value of Received-From-MTA header
    };
    my $v = undef;
    my $p = '';

    for my $e ( split("\n", $$mbody) ) {
        # Read each line between the start of the message and the start of rfc822 part.
        $lowercased = lc $e;
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            if( grep { index($lowercased, $_) == 0 } $startingof->{'message'}->@* ) {
                $readcursor |= $indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $indicators->{'message-rfc822'} ) {
            # Beginning of the original message part(message/rfc822)
            if( grep { $lowercased eq $_ } $startingof->{'rfc822'}->@* ) {
                $readcursor |= $indicators->{'message-rfc822'};
                next;
            }
        }

        if( $readcursor & $indicators->{'message-rfc822'} ) {
            # message/rfc822 OR text/rfc822-headers part
            unless( length $e ) {
                last if ++$blanklines > 1;
                next;
            }
            $rfc822text .= sprintf("%s\n", $e);

        } else {
            # message/delivery-status part
            next unless $readcursor & $indicators->{'deliverystatus'};
            next unless length $e;

            $v = $dscontents->[-1];
            if( my $f = Sisimai::RFC1894->match($e) ) {
                # $e matched with any field defined in RFC3464
                next unless my $o = Sisimai::RFC1894->field($e);

                if( $o->[-1] eq 'addr' ) {
                    # Final-Recipient: rfc822; kijitora@example.jp
                    # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                    if( $o->[0] eq 'final-recipient' || $o->[0] eq 'original-recipient' ) {
                        # Final-Recipient: rfc822; kijitora@example.jp
                        if( $o->[0] eq 'original-recipient' ) {
                            # Original-Recipient: ...
                            $maybealias = $o->[2];

                        } else {
                            # Final-Recipient: ...
                            my $x = $v->{'recipient'} || '';
                            my $y = Sisimai::Address->s3s4($o->[2]);
                               $y = $maybealias unless Sisimai::Address->is_emailaddress($y);

                            if( $x && $x ne $y ) {
                                # There are multiple recipient addresses in the message body.
                                push @$dscontents, Sisimai::Lhost->DELIVERYSTATUS;
                                $v = $dscontents->[-1];
                            }
                            $v->{'recipient'} = $y;
                            $recipients++;
                            $itisbounce ||= 1;

                            $v->{'alias'} ||= $maybealias;
                            $maybealias = '';
                        }
                    } elsif( $o->[0] eq 'x-actual-recipient' ) {
                        # X-Actual-Recipient: RFC822; |IFS=' ' && exec procmail -f- || exit 75 ...
                        # X-Actual-Recipient: rfc822; kijitora@neko.example.jp
                        $v->{'alias'} = $o->[2] unless index($o->[2], ' ') > -1;
                    }
                } elsif( $o->[-1] eq 'code' ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'}      = $o->[1];
                    $v->{'diagnosis'} = $o->[2];

                } else {
                    # Other DSN fields defined in RFC3464
                    next unless exists $fieldtable->{ $o->[0] };
                    $v->{ $fieldtable->{ $o->[0] } } = $o->[2];

                    next unless $f == 1;
                    $permessage->{ $fieldtable->{ $o->[0] } } = $o->[2];
                }
            } else {
                # The line did not match with any fields defined in RFC3464
                if( index($e, 'Diagnostic-Code: ') == 0 && index($e, ';') < 0 ) {
                    # There is no value of "diagnostic-type" such as Diagnostic-Code: 554 ...
                    $v->{'diagnosis'} = substr($e, index($e, ' ') + 1,);

                } elsif( index($e, 'Status: ') == 0 && Sisimai::SMTP::Reply->find(substr($e, 8, 3)) ) {
                    # Status: 553 Exceeded maximum inbound message size
                    $v->{'alterrors'} = substr($e, 8,);

                } elsif( index($p, 'Diagnostic-Code:') == 0 && index($e, ' ') == 0 ) {
                    # Continued line of the value of Diagnostic-Code field
                    $v->{'diagnosis'} .= $e;
                    $e = 'Diagnostic-Code: '.$e;

                } else {
                    # Get error messages which is written in the message body directly
                    next if index($e, ' ') == 0;
                    next if index($e, '	') == 0;
                    next if index($e, 'X') == 0;

                    my $cr = Sisimai::SMTP::Reply->find($e);
                    my $ca = Sisimai::Address->find($e) || [];
                    my $co = Sisimai::String->aligned(\$e, ['<', '@', '>']);

                    $v->{'alterrors'} .= ' '.$e if length $cr || (scalar @$ca && $co);
                }
            }
        } # End of message/delivery-status
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }

    # ---------------------------------------------------------------------------------------------
    BODY_PARSER_FOR_FALLBACK: {
        # Fallback, parse entire message body
        last if $recipients;

        # Failed to get a recipient address at code above
        my $returnpath = lc($mhead->{'return-path'} // '');
        my $headerfrom = lc($mhead->{'from'}        // '');
        my $errortitle = lc($mhead->{'subject'}     // '');
        my $patternsof = {
            'from'        => ['postmaster@', 'mailer-daemon@', 'root@'],
            'return-path' => ['<>', 'mailer-daemon'],
            'subject'     => ['delivery fail', 'delivery report', 'failure notice', 'mail delivery',
                              'mail failed', 'mail error', 'non-delivery', 'returned mail',
                              'undeliverable mail', 'warning: '],
        };

        $match ||= 1 if grep { index($headerfrom, $_) > -1 } $patternsof->{'from'}->@*;
        $match ||= 1 if grep { index($errortitle, $_) > -1 } $patternsof->{'subject'}->@*;
        $match ||= 1 if grep { index($returnpath, $_) > -1 } $patternsof->{'return-path'}->@*;
        last unless $match;

        state $readuntil0 = [
            # Stop reading when the following string have appeared at the first of a line
            'a copy of the original message below this line:',
            'content-type: message/delivery-status',
            'for further assistance, please contact ',
            'here is a copy of the first part of the message',
            'received:',
            'received-from-mta:',
            'reporting-mta:',
            'reporting-ua:',
            'return-path:',
            'the non-delivered message is attached to this message',
        ];
        state $readuntil1 = [
            # Stop reading when the following string have appeared in a line
            'attachment is a copy of the message',
            'below is a copy of the original message:',
            'below this line is a copy of the message',
            'message contains ',
            'message text follows: ',
            'original message follows',
            'the attachment contains the original mail headers',
            'the first ',
            'unsent message below',
            'your message reads (in part):',
        ];
        state $readafter0 = [
            # Do not read before the following strings
            '	the postfix ',
            'a summary of the undelivered message you sent follows:',
            'the following is the error message',
            'the message that you sent was undeliverable to the following',
            'your message was not delivered to ',
        ];
        state $donotread0 = ['   -----', ' -----', '--', '|--', '*'];
        state $donotread1 = ['mail from:', 'message-id:', '  from: '];
        state $reademail0 = [' ', '"', '<',];
        state $reademail1 = [
            # There is an email address around the following strings
            'address:',
            'addressed to',
            'could not be delivered to:',
            'delivered to',
            'delivery failed:',
            'did not reach the following recipient:',
            'error-for:',
            'failed recipient:',
            'failed to deliver to',
            'intended recipient:',
            'mailbox is full:',
            'recipient:',
            'rcpt to:',
            'smtp server <',
            'the following recipients returned permanent errors:',
            'the following addresses had permanent errors',
            'the following message to',
            'to: ',
            'unknown user:',
            'unable to deliver mail to the following recipient',
            'undeliverable to',
            'undeliverable address:',
            'you sent mail to',
            'your message has encountered delivery problems to the following recipients:',
            'was automatically rejected',
            'was rejected due to',
        ];

        my $b = $dscontents->[-1];
        my $hasmatched = 0;     # There may be an email address around the line
        my $readslices = [];    # Previous line of this loop
           $lowercased = lc $$mbody;

        for my $e ( @$readafter0 ) {
            # Cut strings from the begining of $$mbody to the strings defined in $readafter0
            my $i = index($lowercased, $e); next if $i == -1;
            $$mbody = substr($$mbody, $i);
        }

        for my $e ( split("\n", $$mbody) ) {
            # Get the recipient's email address and error messages.
            next unless length $e;

            $hasmatched = 0;
            $lowercased = lc $e;
            push @$readslices, $lowercased;

            last if grep { index($lowercased, $_) == 0 } $startingof->{'rfc822'}->@*;
            last if grep { index($lowercased, $_) == 0 } @$readuntil0;
            last if grep { index($lowercased, $_) > -1 } @$readuntil1;
            next if grep { index($lowercased, $_) == 0 } @$donotread0;
            next if grep { index($lowercased, $_) > -1 } @$donotread1;

            while(1) {
                # There is an email address with an error message at this line(1)
                last unless grep { index($lowercased, $_) == 0 } @$reademail0;
                last unless index($lowercased, '@') > 1;

                $hasmatched = 1;
                last;
            }

            while(2) {
                # There is an email address with an error message at this line(2)
                last if $hasmatched > 0;
                last unless grep { index($lowercased, $_) > -1 } @$reademail1;
                last unless index($lowercased, '@') > 1;

                $hasmatched = 2;
                last;
            }

            while(3) {
                # There is an email address without an error message at this line
                last if $hasmatched > 0;
                last if scalar @$readslices < 2;
                last unless grep { index($readslices->[-2], $_) > -1 } @$reademail1;
                last unless index($lowercased, '@')  >  1;  # Must contain "@"
                last unless index($lowercased, '.')  >  1;  # Must contain "."
                last unless index($lowercased, '$') == -1;
                $hasmatched = 3;
                last;
            }

            if( $hasmatched > 0 && index($lowercased, '@') > 0 ) {
                # May be an email address
                my $w = [split(' ', $e)];
                my $x = $b->{'recipient'} || '';
                my $y = '';

                for my $ee ( @$w ) {
                    # Find an email address (including "@")
                    next unless index($ee, '@') > 1;
                    $y = Sisimai::Address->s3s4($ee);
                    next unless Sisimai::Address->is_emailaddress($y);
                    last;
                }

                if( $x && $x ne $y ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, Sisimai::Lhost->DELIVERYSTATUS;
                    $b = $dscontents->[-1];
                }
                $b->{'recipient'} = $y;
                $recipients++;
                $itisbounce ||= 1;

            } elsif( index($e, '(expanded from') > -1 || index($e, '(generated from') > -1 ) {
                # (expanded from: neko@example.jp)
                $b->{'alias'} = Sisimai::Address->s3s4(substr($e, rindex($e, ' ') + 1,));
            }
            $b->{'diagnosis'} .= ' '.$e;
        }
    } # END OF BODY_PARSER_FOR_FALLBACK
    return undef unless $itisbounce;

    my $p1 = index($rfc822text, "\nTo: ");
    my $p2 = index($rfc822text, "\n", $p1 + 6);
    if( $recipients == 0 && $p1 > 0 ) {
        # Try to get a recipient address from "To:" header of the original message
        if( my $r = Sisimai::Address->find(substr($rfc822text, $p1 + 5, $p2 - $p1 - 5), 1) ) {
            # Found a recipient address
            push @$dscontents, Sisimai::Lhost->DELIVERYSTATUS if scalar(@$dscontents) == $recipients;
            my $b = $dscontents->[-1];
            $b->{'recipient'} = $r->[0]->{'address'};
            $recipients++;
        }
    }
    return undef unless $recipients;

    require Sisimai::SMTP::Command;
    require Sisimai::MDA;
    my $mdabounced = Sisimai::MDA->inquire($mhead, $mbody);
    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{ $_ } ||= $connheader->{ $_ } || '' for keys %$connheader;

        if( exists $e->{'alterrors'} && $e->{'alterrors'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} ||= $e->{'alterrors'};
            if( index($e->{'diagnosis'}, '-') == 0 || substr($e->{'diagnosis'}, -2, 2) eq '__') {
                # Override the value of diagnostic code message
                $e->{'diagnosis'} = $e->{'alterrors'} if $e->{'alterrors'};
            }
            delete $e->{'alterrors'};
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( $mdabounced ) {
            # Make bounce data by the values returned from Sisimai::MDA->inquire()
            $e->{'agent'}     = $mdabounced->{'mda'} || 'RFC3464';
            $e->{'reason'}    = $mdabounced->{'reason'} || 'undefined';
            $e->{'diagnosis'} = $mdabounced->{'message'} if $mdabounced->{'message'};
            $e->{'command'}   = '';
        }
        $e->{'date'}    ||= $mhead->{'date'};
        $e->{'status'}  ||= Sisimai::SMTP::Status->find($e->{'diagnosis'}) || '';
        $e->{'command'} ||= Sisimai::SMTP::Command->find($e->{'diagnosis'});
    }
    return { 'ds' => $dscontents, 'rfc822' => $rfc822text };
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::RFC3464 - bounce mail parser class for Fallback.

=head1 SYNOPSIS

    use Sisimai::RFC3464;

=head1 DESCRIPTION

Sisimai::RFC3464 is a class which called from called from only Sisimai::Message when other 
Sisimai::Lhost::* modules did not detected a bounce reason.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::RFC3464->description;

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
