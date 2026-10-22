package Sisimai::RFC3464;
use v5.26;
use strict;
use warnings;
use Sisimai::Lhost;
use Sisimai::RFC1123;
use Sisimai::RFC3464::ThirdParty;

# http://tools.ietf.org/html/rfc3464
sub description { 'RFC3464' };
sub inquire {
    # Decode a bounce mail which have fields defined in RFC3464
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    my $class = shift;
    my $mhead = shift // return undef; return undef unless keys %$mhead;
    my $mbody = shift // return undef; return undef unless ref $mbody eq 'SCALAR';

    require Sisimai::RFC1894;
    require Sisimai::RFC2045;
    require Sisimai::RFC5322;
    require Sisimai::Address;
    require Sisimai::String;

    state $indicators = Sisimai::Lhost->INDICATORS;
    state $boundaries = [
        # When the new value added, the part of the value should be listed in $delimiters variable
        # defined at Sisimai::RFC2045->makeFlat() method
        "Content-Type: message/rfc822",
        "Content-Type: text/rfc822-headers",
        "Content-Type: message/partial",
        "Content-Disposition: inline", # See lhost-amavis-*.eml, lhost-facebook-*.eml
    ];
    state $startingof = {"message" => ["Content-Type: message/delivery-status"]};
    state $fieldtable = Sisimai::RFC1894->FIELDTABLE;

    unless( grep { index($$mbody, $_) > 0 } @$boundaries ) {
        # There is no "Content-Type: message/rfc822" line in the message body
        # Insert "Content-Type: message/rfc822" before "Return-Path:" of the original message
        my $p0 = index($$mbody, "\n\nReturn-Path:");
        $$mbody = sprintf("%s%s%s", substr($$mbody, 0, $p0), $boundaries->[0], substr($$mbody, $p0 + 1,)) if $p0 > 0;
    }

    my $permessage = {};
    my $dscontents = [Sisimai::Lhost->DELIVERYSTATUS]; my $v = undef;
    my $alternates = Sisimai::Lhost->DELIVERYSTATUS;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $beforemesg = "";    # (String) String before $startingof->{"message"}
    my $goestonext = 0;     # (Bool) Flag: do not append the line into $beforemesg
    my $isboundary = [Sisimai::RFC2045->boundary($mhead->{"content-type"}, 0)]; $isboundary->[0] ||= "";
    my $p = "";

    while( index($emailparts->[0], '@') < 0 ) {
        # There is no email address in the first element of emailparts
        # There is a bounce message inside of message/rfc822 part at lhost-x5-*
        my $p0 = -1;    # The index of the boundary string found first
        my $p1 =  0;    # Offset position of the message body after the boundary string
        my $ct = "";    # Boundary string found first such as "Content-Type: message/rfc822"

        for my $e ( @$boundaries ) {
            # Look for a boundary string from the message body
            $p0 = index($$mbody, $e."\n"); next if $p0 < 0;
            $p1 = $p0 + length($e) + 2;
            $ct = $e; last;
        }
        last if $p0 < 0;

        my $cx = substr($$mbody, $p1,);
        my $p2 = index($cx,, "\n\n");
        my $cv = substr($cx, $p2 + 2,);
        $emailparts = Sisimai::RFC5322->part(\$cv, [$ct], 0);
        last;
    }

    if( index($emailparts->[0], $startingof->{"message"}->[0]) < 0 ) {
        # There is no "Content-Type: message/delivery-status" line in the message body
        # Insert "Content-Type: message/delivery-status" before "Reporting-MTA:" field
        my $cv = "\n\nReporting-MTA:";
        my $e0 = $emailparts->[0];
        my $p0 = index($e0, $cv);
        $emailparts->[0] = sprintf("%s\n\n%s%s", substr($e0, 0, $p0), $startingof->{"message"}->[0], substr($e0, $p0,)) if $p0 > 0;
    }

    for my $e ("Final-Recipient", "Original-Recipient") {
        # Fix the malformed field "Final-Recipient: <kijitora@example.jp>"
        my $cv = "\n".$e.": ";
        my $cx = $cv."<";
        my $p0 = index($emailparts->[0], $cx); next if $p0 < 0;

        substr($emailparts->[0], $p0, length($cv) + 1, $cv."rfc822; ");
        my $p1 = index($emailparts->[0], ">\n", $p0 + 2); substr($emailparts->[0], $p1, 1, "");
    }

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        if( $readcursor == 0 ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;

            while(1) {
                # Append each string before startingof["message"][0] except the following patterns
                # for the later reference
                last if $e eq "" || $goestonext; # Blank line or the part is text/html, image/icon, in multipart/*

                # This line is a boundary kept in "multiparts" as a string, when the end of the boundary
                # appeared, the condition above also returns true.
                if( grep { index($e, $_) == 0 } @$isboundary ) { $goestonext = 0; last }
                if( index($e, "Content-Type:") == 0 ) {
                    # Content-Type: field in multipart/*
                    if( index($e, "multipart/") > 0 ) {
                        # Content-Type: multipart/alternative; boundary=aa00220022222222ffeebb
                        # Pick the boundary string and store it into "isboucdary"
                        push @$isboundary, Sisimai::RFC2045->boundary($e, 0);

                    } elsif( index($e, "text/plain") ) {
                        # Content-Type: "text/plain"
                        $goestonext = 0;

                    } else {
                        # Other types: for example, text/html, image/jpg, and so on
                        $goestonext = 1;
                    }
                    last;
                }

                last if index($e, "Content-") == 0;            # Content-Disposition, ...
                last if index($e, "This is a MIME") == 0;      # This is a MIME-formatted message.
                last if index($e, "This is a multi") == 0;     # This is a multipart message in MIME format
                last if index($e, "This is an auto") == 0;     # This is an automatically generated ...
                last if index($e, "This multi-part") == 0;     # This multi-part MIME message contains...
                last if index($e, "###") == 0;                 # A frame like #####
                last if index($e, "***") == 0;                 # A frame like *****
                last if index($e, "--")  == 0;                 # Boundary string
                last if index($e, "--- The follow") > -1;      # ----- The following addresses had delivery problems -----
                last if index($e, "--- Transcript") > -1;      # ----- Transcript of session follows -----
                $beforemesg .= $e." "; last;
            }
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        if( my $f = Sisimai::RFC1894->match($e) ) {
            # $e matched with any field defined in RFC3464
            next unless my $o = Sisimai::RFC1894->field($e);
            $v = $dscontents->[-1];

            if( $o->[3] eq "addr" ) {
                # Final-Recipient: rfc822; kijitora@example.jp
                # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                if( $o->[0] eq "final-recipient" ) {
                    # Final-Recipient: rfc822; kijitora@example.jp
                    # Final-Recipient: x400; /PN=...
                    my $cv = Sisimai::Address->s3s4($o->[2]); next unless Sisimai::Address->is_emailaddress($cv);
                    my $cw = scalar @$dscontents; next if $cw > 0 && $cv eq $dscontents->[$cw - 1]->{'recipient'};

                    if( $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, Sisimai::Lhost->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = $cv;
                    $recipients++;

                } else {
                    # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                    $v->{'alias'} = $o->[2];
                }
            } elsif( $o->[3] eq "code" ) {
                # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                $v->{'spec'}       = $o->[1];
                $v->{'diagnosis'} .= $o->[2]." ";

            } else {
                # Other DSN fields defined in RFC3464
                if( $o->[4] ne "" ) {
                    # There are other error messages as a comment such as the following:
                    # Status: 5.0.0 (permanent failure)
                    # Status: 4.0.0 (cat.example.net: host name lookup failure)
                    $v->{'diagnosis'} .= " ".$o->[4]." ";
                }
                next unless exists $fieldtable->{ $o->[0] };
                next if $o->[3] eq "host" && Sisimai::RFC1123->is_internethost($o->[2]) == 0;

                $v->{ $fieldtable->{ $o->[0] } } = $o->[2];
                next unless $f == 1;
                $permessage->{ $fieldtable->{ $o->[0] } } = $o->[2];
            }
        } else {
            # Check that the line is a continued line of the value of Diagnostic-Code: field or not
            if( index($e, "X-") == 0 && index($e, ": ") > 1 ) {
                # This line is a MTA-Specific fields begins with "X-"
                next unless Sisimai::RFC3464::ThirdParty->is3rdparty($e);

                my $cv = Sisimai::RFC3464::ThirdParty->xfield($e);
                if( scalar(@$cv) > 0 && not exists $fieldtable->{ lc $cv->[0] } ) {
                    # Check the first element is a field defined in RFC1894 or not
                    $v->{'reason'} = substr($cv->[4], index($cv->[4], ":") + 1,) if index($cv->[4], "reason:") == 0;

                } else {
                    # Set the value picked from "X-*" field to $dscontents when the current value is empty
                    my $z = $fieldtable->{ lc $cv->[0] }; next unless $z;
                    $v->{ $z } ||= $cv->[2];
                }
            } else {
                # The line may be a continued line of the value of the Diagnostic-Code: field
                if( index($p, 'Diagnostic-Code:') < 0 ) {
                    # In the case of multiple "message/delivery-status" line
                    next if index($e, "Content-") == 0; # Content-Disposition:, ...
                    next if index($e, "--")       == 0; # Boundary string
                    $beforemesg .= $e." "; next
                }

                # Diagnostic-Code: SMTP; 550-5.7.26 The MAIL FROM domain [email.example.jp]
                #    has an SPF record with a hard fail
                next unless index($e, " ") == 0;
                $v->{'diagnosis'} .= " ".$e;
            }
        }
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }

    while( $recipients == 0 ) {
        # There is no valid recipient address, Try to use the alias addaress as a final recipient
        last unless length $dscontents->[0]->{'alias'} > 0;
        last unless Sisimai::Address->is_emailaddress($dscontents->[0]->{'alias'});
        $dscontents->[0]->{'recipient'} = $dscontents->[0]->{'alias'};
        $recipients++;
    }
    return undef unless $recipients;

    require Sisimai::SMTP::Reply;
    require Sisimai::SMTP::Status;
    require Sisimai::SMTP::Command;

    if( $beforemesg ne "" ) {
        # Pick some values of $dscontents from the string before $startingof->{'message'}
        $beforemesg = Sisimai::String->sweep($beforemesg);
        $alternates->{'command'}   = Sisimai::SMTP::Command->find($beforemesg);
        $alternates->{'replycode'} = Sisimai::SMTP::Reply->find($beforemesg, $dscontents->[0]->{'status'});
        $alternates->{'status'}    = Sisimai::SMTP::Status->find($beforemesg, $alternates->{'replycode'});
    }
    my $issuedcode = lc $beforemesg;

    for my $e ( @$dscontents ) {
        # Set default values stored in "permessage" if each value in "dscontents" is empty.
        $e->{ $_ } ||= $permessage->{ $_ } || '' for keys %$permessage;
        my $lowercased = lc $e->{'diagnosis'};

        if( $recipients == 1 ) {
            # Do not mix the error message of each recipient with "beforemesg" when there is
            # multiple recipient addresses in the bounce message
            if( index($issuedcode, $lowercased) > -1 ) {
                # $beforemesg contains the entire strings of $e->{'diagnosis'}
                $e->{'diagnosis'} = $beforemesg;

            } else {
                # The value of $e->{'diagnosis'} is not contained in $beforemesg
                # There may be an important error message in $beforemesg
                $e->{'diagnosis'} = sprintf("%s %s", $beforemesg, $e->{'diagnosis'});
            }
        }
        $e->{'command'}   = Sisimai::SMTP::Command->find($e->{'diagnosis'})                   || $alternates->{'command'};
        $e->{'replycode'} = Sisimai::SMTP::Reply->find($e->{'diagnosis'}, $e->{'status'})     || $alternates->{'replycode'};
        $e->{'status'}  ||= Sisimai::SMTP::Status->find($e->{'diagnosis'}, $e->{'replycode'}) || $alternates->{'status'};
    }

    # Set the recipient address as To: header in the original message part
    $emailparts->[1] = sprintf("To: <%s>\n", $dscontents->[0]->{'recipient'}) unless $emailparts->[1];
    
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;

__END__
=encoding utf-8

=head1 NAME

Sisimai::RFC3464 - bounce mail decoder class for a bounce mail which have fields defined in RFC3464

=head1 SYNOPSIS

    use Sisimai::RFC3464;

=head1 DESCRIPTION

C<Sisimai::RFC3464> is a class which called from called from only C<Sisimai::Message> when other 
C<Sisimai::Lhost::*> modules did not detected a bounce reason.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> method returns the description string of this module.

    print Sisimai::RFC3464->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method method decodes a bounced email and return results as an array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

