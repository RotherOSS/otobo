package Sisimai::Lhost::Exim;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Exim' }
sub inquire {
    # Detect an error from Exim Internet Mailer
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    return undef if grep { index($$mbody, $_) > 0 } __PACKAGE__->BannerDTAG->@*;

    # Message-Id: <E1P1YNN-0003AD-Ga@example.org>
    # X-Failed-Recipients: kijitora@example.ed.jp
    my $messageidv = $mhead->{"message-id"} || "";
    my $emailtitle = [
        "Delivery Status Notification",
        "Mail delivery failed",
        "Mail failure",
        "Message frozen",
        "Warning: message ",
        "error(s) in forwarding or filtering",
    ];
    my $proceedsto = 0; $proceedsto++ if index($mhead->{"from"}, "Mail Delivery System") > -1;

    while( $messageidv ne "" ) {
        # Message-Id: <E1P1YNN-0003AD-Ga@example.org>
        last if index($messageidv, '<') != 0 || index($messageidv, '-') !=  8 || index($messageidv, '@') != 18;
        $proceedsto++; last;
    }
    for my $e ( @$emailtitle ) {
        # Subject: Mail delivery failed: returning message to sender
        # Subject: Mail delivery failed
        # Subject: Message frozen
        next if index($mhead->{"subject"}, $e) < 0;
        $proceedsto++; last;
    }

    # Exim clones of the third Parties
    # 1. McAfee Saas (Formerly MXLogic)
    my $thirdparty = 0; $thirdparty ||= 1 if exists $mhead->{"x-mx-bounce"};
                        $thirdparty ||= 1 if exists $mhead->{"x-mxl-hash"};
                        $thirdparty ||= 1 if exists $mhead->{"x-mxl-notehash"};
                        $thirdparty ||= 1 if index($messageidv, "<mxl~") > -1;
    return undef if $proceedsto < 2 && $thirdparty == 0;

    require Sisimai::Eb;
    require Sisimai::Reason;
    require Sisimai::Address;
    require Sisimai::SMTP::Command;
    require Sisimai::SMTP::Failure;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = [
        # deliver.c:6423|          if (bounce_return_body) fprintf(f,
        # deliver.c:6424|"------ This is a copy of the message, including all the headers. ------\n");
        # deliver.c:6425|          else fprintf(f,
        # deliver.c:6426|"------ This is a copy of the message's headers. ------\n");
        '------ This is a copy of the message, including all the headers. ------',
        'Content-Type: message/rfc822',
        "Included is a copy of the message header:\n-----------------------------------------", # MXLogic
    ];
    state $startingof = {
        # Error text strings which defined in exim/src/deliver.c
        #
        # deliver.c:6292| fprintf(f,
        # deliver.c:6293|"This message was created automatically by mail delivery software.\n");
        # deliver.c:6294|        if (to_sender)
        # deliver.c:6295|          {
        # deliver.c:6296|          fprintf(f,
        # deliver.c:6297|"\nA message that you sent could not be delivered to one or more of its\n"
        # deliver.c:6298|"recipients. This is a permanent error. The following address(es) failed:\n");
        # deliver.c:6299|          }
        # deliver.c:6300|        else
        # deliver.c:6301|          {
        # deliver.c:6302|          fprintf(f,
        # deliver.c:6303|"\nA message sent by\n\n  <%s>\n\n"
        # deliver.c:6304|"could not be delivered to one or more of its recipients. The following\n"
        # deliver.c:6305|"address(es) failed:\n", sender_address);
        # deliver.c:6306|          }
        "alias"          => [" an undisclosed address"],
        "command"        => ["SMTP error from remote ", "LMTP error after "],
        'deliverystatus' => ["Content-Type: message/delivery-status"],
        'frozen'         => [" has been frozen", " was frozen on arrival"],
        'message'        => [
            "This message was created automatically by mail delivery software.",
            "A message that you sent was rejected by the local scannning code",
            "A message that you sent contained one or more recipient addresses ",
            "A message that you sent could not be delivered to all of its recipients",
            " has been frozen",
            " was frozen on arrival",
            " router encountered the following error(s):",
        ],
    };
    state $messagesof = {
        # find exim/ -type f -exec grep 'message = US' {} /dev/null \;
        # route.c:1158|  DEBUG(D_uid) debug_printf("getpwnam() returned NULL (user not found)\n");
        $Sisimai::Eb::ReUSER => ["user not found"],
        # parser.c:666| *errorptr = string_sprintf("%s (expected word or \"<\")", *errorptr);
        # parser.c:701| if(bracket_count++ > 5) FAILED(US"angle-brackets nested too deep");
        # parser.c:738| FAILED(US"domain missing in source-routed address");
        # parser.c:747| : string_sprintf("malformed address: %.32s may not follow %.*s",
        $Sisimai::Eb::ReCOMM => [
            "angle-brackets nested too deep",
            'expected word or "<"',
            "domain missing in source-routed address",
            "malformed address:",
        ],
    };
    state $delayedfor = [
        # deliver.c:7475| "No action is required on your part. Delivery attempts will continue for\n"
        # smtp.c:3508|    US"retry time not reached for any host after a long failure period" :
        # deliver.c:7459| print_address_error(addr, f, US"Delay reason: ");
        "No action is required on your part",
        "retry time not reached for any host after a long failure period",
        "Delay reason: ",
    ];

    if( index($$mbody, "\n----- This is a copy ") > -1 ) {
        # There are extremely rare cases where there are only five hyphens.
        # https://github.com/sisimai/set-of-emails/blob/master/maildir/bsd/lhost-exim-05.eml
        # ----- This is a copy of the message, including all the headers. ------
        my $p0 = index($$mbody, "\n----- This is a copy ");
        substr($$mbody, $p0 + 1, 1, "--");
    }

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # Points the current cursor position
    my $nextcursor = 0;
    my $recipients = 0;     # The number of 'Final-Recipient' header
    my $boundary00 = '';    # Boundary string

    # Get the boundary string and set regular expression for matching with the boundary string.
    $boundary00 = Sisimai::RFC2045->boundary($mhead->{'content-type'}) if $mhead->{'content-type'};

    my $p1 = -1; my $p2 = -1;
    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            if( grep { index($e, $_) > -1 } $startingof->{'message'}->@* ) {
                # Check the message defined in $startingof->{"message"}, {"frozen"}
                $readcursor |= $indicators->{'deliverystatus'};
                next unless grep { index($e, $_) > -1 } $startingof->{'frozen'}->@*;
            }
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # This message was created automatically by mail delivery software.
        #
        # A message that you sent could not be delivered to one or more of its
        # recipients. This is a permanent error. The following address(es) failed:
        #
        #  kijitora@example.jp
        #    SMTP error from remote mail server after RCPT TO:<kijitora@example.jp>:
        #    host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
        $v = $dscontents->[-1];

        my $cv = "";
        my $ce = 0;
        while(1) {
            # Check if the line matche the following patterns:
            last if index($e, '  ')        !=  0;   # The line should start with "  " (2 spaces)
            last if index($e, '@' )         <  2;   # "@" should be included (email)
            last if index($e, '.' )         <  2;   # "." should be included (domain part)
            last if index($e, 'pipe to |')  > -1;   # Exclude "pipe to /path/to/prog" line

            my $cx = substr($e, 2, 1);
            last if $cx eq " ";                     # The 3rd character is " "
            last if $thirdparty == 0 && $cx eq "<"; # MXLogic returns "  <neko@example.jp>:..."

            $ce = 1; last;
        }

        if( $ce == 1 || grep { index($e, $_) > 0 } $startingof->{"alias"}->@* ) {
            # The line is including an email address
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }

            if( grep { index($e, $_) > 0 } $startingof->{"alias"}->@* ) {
                # The line does not include an email address
                # deliver.c:4549|  printed = US"an undisclosed address";
                #   an undisclosed address
                #     (generated from kijitora@example.jp)
                $cv = substr($e, 2,);

            } else {
                #   kijitora@example.jp
                #   sabineko@example.jp: forced freeze
                #   mikeneko@example.jp <nekochan@example.org>: ...
                $p1 = index($e, "<");
                $p2 = index($e, ">:");

                if( $p1 > 1 && $p2 > 1 ) {
                    # There are an email address and an error message in the line
                    # parser.c:743| while (bracket_count-- > 0) if (*s++ != '>')
                    # parser.c:744|   {
                    # parser.c:745|   *errorptr = s[-1] == 0
                    # parser.c:746|     ? US"'>' missing at end of address"
                    # parser.c:747|     : string_sprintf("malformed address: %.32s may not follow %.*s",
                    # parser.c:748|     s-1, (int)(s - US mailbox - 1), mailbox);
                    # parser.c:749|   goto PARSE_FAILED;
                    # parser.c:750|   }
                    $cv = Sisimai::Address->s3s4(substr($e, $p1, $p2 - $p1 - 1));
                    $v->{'diagnosis'} = substr($e, $p2 + 1,);

                } else {
                    # There is an email address only in the line
                    #   kijitora@example.jp
                    $cv = Sisimai::Address->s3s4(substr($e, 2,));
                }
                next unless Sisimai::Address->is_emailaddress($cv);
            }
            $v->{'recipient'} = $cv;
            $recipients++;

        } elsif( index($e, " (generated from ") > 0 || index($e, " generated by ") > 0 ) {
            #     (generated from kijitora@example.jp)
            #  pipe to |/bin/echo "Some pipe output"
            #    generated by userx@myhost.test.ex
            for my $f ( split(" ", $e) ) {
                # Find the alias address
                next if index($f, '@') < 0; 
                $v->{'alias'} = Sisimai::Address->s3s4($f);
            }
        } else {
            if( grep { index($e, $_) > -1 } $startingof->{'frozen'}->@* ) {
                # Message *** has been frozen by the system filter.
                # Message *** was frozen on arrival by ACL.
                $v->{'alterrors'} .= $e.' ';

            } elsif( $boundary00 ) {
                # --NNNNNNNNNN-eximdsn-MMMMMMMMMM
                # Content-type: message/delivery-status
                # ...
                if( Sisimai::RFC1894->match($e) ) {
                    # $e matched with any field defined in RFC3464
                    next unless my $o = Sisimai::RFC1894->field($e);

                    if( $o->[3] eq 'addr' ) {
                        # Final-Recipient: rfc822;|/bin/echo "Some pipe output"
                        next unless $o->[0] eq 'final-recipient';
                        $v->{'spec'} ||= rindex($o->[2], '@') > -1 ? 'SMTP' : 'X-UNIX';

                    } elsif( $o->[3] eq 'code' ) {
                        # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                        $v->{'spec'} = uc $o->[1];
                        $v->{'diagnosis'} = $o->[2];

                    } else {
                        # Other DSN fields defined in RFC3464
                        next unless exists $fieldtable->{ $o->[0] };
                        $v->{ $fieldtable->{ $o->[0] } } = $o->[2];
                    }
                } else {
                    # Error message ?
                    next if $nextcursor;

                    # Content-type: message/delivery-status
                    $nextcursor = 1 if index($e, $startingof->{'deliverystatus'}->[0]) == 0;
                    $v->{'alterrors'} .= $e.' ' if index($e, ' ') == 0;
                }
            } else {
                # There is no boundary string in $boundary00
                if( scalar @$dscontents == $recipients ) {
                    # Error message
                    $v->{'diagnosis'} .= $e.' ';

                } else {
                    # Error message when email address above does not include '@' and domain part.
                    #   pipe to |/path/to/prog ...
                    #     generated by kijitora@example.com
                    next unless index($e, "  ") == 0;
                    $v->{"diagnosis"} .= $e." ";
                }
            }
        }
    }

    if( $recipients ) {
        # Check "an undisclosed address", "unroutable address"
        for my $q ( @$dscontents ) {
            # Replace the recipient address with the value of "alias"
            next unless $q->{'alias'};
            if( ! $q->{'recipient'} || rindex($q->{'recipient'}, '@') == -1 ) {
                # The value of "recipient" is empty or does not include "@"
                $q->{'recipient'} = $q->{'alias'};
            }
        }
    } else {
        # Fallback for getting recipient addresses
        if( defined $mhead->{'x-failed-recipients'} ) {
            # X-Failed-Recipients: kijitora@example.jp
            my @rcptinhead = split(',', $mhead->{'x-failed-recipients'});
            for my $e ( @rcptinhead ) { s/\A[ ]+//, s/[ ]+\z// for $e }
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

    for my $e ( @$dscontents ) {
        # Check the error message, the rhost, the lhost, and the smtp command.
        $e->{"alterrors"} ||= "";
        if( ! $e->{'diagnosis'} && length($boundary00) > 0 ) {
            # Empty Diagnostic-Code: or error message
            # --NNNNNNNNNN-eximdsn-MMMMMMMMMM
            # Content-type: message/delivery-status
            #
            # Reporting-MTA: dns; the.local.host.name
            #
            # Action: failed
            # Final-Recipient: rfc822;/a/b/c
            # Status: 5.0.0
            #
            # Action: failed
            # Final-Recipient: rfc822;|/p/q/r
            # Status: 5.0.0
            $e->{'diagnosis'} = $dscontents->[0]->{'diagnosis'} || '';
            $e->{'spec'}    ||= $dscontents->[0]->{'spec'};
            $e->{'alterrors'} = $dscontents->[0]->{'alterrors'} if $dscontents->[0]->{'alterrors'};
        }

        if( $e->{'alterrors'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} ||= $e->{'alterrors'};

            if( index($e->{'diagnosis'}, '-') == 0 || substr($e->{'diagnosis'}, -2, 2) eq '__' ) {
                # Override the value of diagnostic code message
                $e->{'diagnosis'} = $e->{'alterrors'};

            } elsif( length($e->{'diagnosis'}) < length($e->{'alterrors'}) ) {
                # Override the value of diagnostic code message with the value of alterrors because
                # the latter includes the former.
                $e->{'alterrors'} =~ y/ //s;
                $e->{'diagnosis'} = $e->{'alterrors'} if index(lc $e->{'alterrors'}, lc $e->{'diagnosis'}) > -1;
            }
            delete $e->{'alterrors'};
        }
        $p1 = index($e->{'diagnosis'}, '__');
        $e->{'diagnosis'} = substr($e->{'diagnosis'}, 0, $p1) if $p1 > 1;

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
            SMTP: for my $r ( $startingof->{"command"}->@* ) {
                # Verify each regular expression of SMTP commands
                next if index($e->{'diagnosis'}, $r) < 0;
                $e->{'command'} = Sisimai::SMTP::Command->find($e->{'diagnosis'}) || next;
                last;
            }

            # Detect the reason of bounce
            if( $e->{'command'} eq $Sisimai::Eb::CeHELO || $e->{'command'} eq $Sisimai::Eb::CeEHLO ) {
                # HELO | Connected to 192.0.2.135 but my name was rejected.
                $e->{'reason'} = $Sisimai::Eb::ReBLOC;

            } elsif( $e->{'command'} eq $Sisimai::Eb::CeMAIL ) {
                # MAIL | Connected to 192.0.2.135 but sender was rejected.
                $e->{'reason'} = $Sisimai::Eb::Re___1;

            } else {
                # Try to match the error message with each message pattern
                SESSION: for my $r ( keys %$messagesof ) {
                    # Check each message pattern
                    next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
                    $e->{'reason'} = $r;
                    last;
                }
                $e->{'reason'} ||= $Sisimai::Eb::ReTIME if grep { index($e->{'diagnosis'}, $_) > -1 } @$delayedfor;
            }
        }

        # Prefer the value of smtp reply code in Diagnostic-Code: field
        # See set-of-emails/maildir/bsd/exim-20.eml
        #
        #   Action: failed
        #   Final-Recipient: rfc822;userx@test.ex
        #   Status: 5.0.0
        #   Remote-MTA: dns; 127.0.0.1
        #   Diagnostic-Code: smtp; 450 TEMPERROR: retry timeout exceeded
        #
        # The value of "Status:" indicates permanent error but the value of SMTP reply code in
        # Diagnostic-Code: field is "TEMPERROR"!!!!
        my $cr = Sisimai::SMTP::Reply->find($e->{'diagnosis'},  $e->{'status'})  || '';
        my $cs = Sisimai::SMTP::Status->find($e->{'diagnosis'}, $cr)             || '';
        my $re = $e->{'reason'} || '';
        my $cv = "";

        if( Sisimai::SMTP::Failure->is_temporary($cr) || $re eq $Sisimai::Eb::ReTIME ) {
            # Set the pseudo status code as a temporary error
            $cv = Sisimai::SMTP::Status->code($re, 1) if Sisimai::Reason->is_explicit($re);
        }
        $e->{'replycode'} ||= $cr;
        $e->{'status'}    ||= Sisimai::SMTP::Status->prefer($cv, $cs, $cr);
        $e->{'command'}   ||= '';
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Exim - bounce mail decoder class for Exim Internet Mailer L<https://www.exim.org/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Exim;

=head1 DESCRIPTION

C<Sisimai::Lhost::Exim> decodes a bounce email which created by Exim Internet Mailer L<https://www.exim.org/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Exim->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

