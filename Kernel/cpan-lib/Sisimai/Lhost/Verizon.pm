package Sisimai::Lhost::Verizon;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Verizon Wireless: https://www.verizonwireless.com' }
sub inquire {
    # Detect an error from Verizon
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = -1;

    while(1) {
        # Check the value of "From" header
        # 'subject' => qr/Undeliverable Message/,
        last unless grep { rindex($_, '.vtext.com (') > -1 } $mhead->{'received'}->@*;
        $match = 1 if $mhead->{'from'} eq 'post_master@vtext.com';
        $match = 0 if Sisimai::String->aligned(\$mhead->{'from'}, ['sysadmin@', '.vzwpix.com']);
        last;
    }
    return undef if $match < 0;

    state $indicators = __PACKAGE__->INDICATORS;
    my $boundaries = [];
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = [];
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $senderaddr = '';    # (String) Sender address in the message body
    my $subjecttxt = '';    # (String) Subject of the original message

    my $startingof = {};    # (Ref->Hash) Delimiter strings
    my $markingsof = {};    # (Ref->Hash) Delimiter patterns
    my $messagesof = {};    # (Ref->Hash) Error message patterns
    my $v = undef;

    if( $match == 1 ) {
        # vtext.com
        $markingsof = { 'message' => ['Error: '] };
        $messagesof = {
            # The attempted recipient address does not exist.
            'userunknown' => ['550 - Requested action not taken: no such user here'],
        };
        $boundaries = [Sisimai::RFC2045->boundary($mhead->{'content-type'}, 1)];
        $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);

        for my $e ( split("\n", $emailparts->[0]) ) {
            # Read error messages and delivery status lines from the head of the email to the previous
            # line of the beginning of the original message.
            unless( $readcursor ) {
                # Beginning of the bounce message or delivery status part
                $readcursor |= $indicators->{'deliverystatus'} if index($e, $markingsof->{'message'}->[0]) == 0;
                next;
            }
            next unless $readcursor & $indicators->{'deliverystatus'};
            next unless length $e;

            # Message details:
            #   Subject: Test message
            #   Sent date: Wed Jun 12 02:21:53 GMT 2013
            #   MAIL FROM: *******@hg.example.com
            #   RCPT TO: *****@vtext.com
            $v = $dscontents->[-1];

            if( index($e, '  RCPT TO: ') == 0 ) {
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = substr($e, 11,);
                $recipients++;
                next;

            } elsif( index($e, '  MAIL FROM: ') == 0 ) {
                #   MAIL FROM: *******@hg.example.com
                $senderaddr ||= substr($e, 13,);

            } elsif( index($e, '  Subject: ') == 0 ) {
                #   Subject:
                $subjecttxt ||= substr($e, 11,);

            } else {
                # 550 - Requested action not taken: no such user here
                $v->{'diagnosis'} = $e if index($e, ' - ') > 2;
            }
        }
    } else {
        # vzwpix.com
        $startingof = { 'message' => ['Message could not be delivered to mobile'] };
        $messagesof = { 'userunknown' => ['No valid recipients for this MM'] };
        $boundaries = [Sisimai::RFC2045->boundary($mhead->{'content-type'})];
        $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
        for my $e ( split("\n", $emailparts->[0]) ) {
            # Read error messages and delivery status lines from the head of the email to the previous
            # line of the beginning of the original message.
            unless( $readcursor ) {
                # Beginning of the bounce message or delivery status part
                $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
                next;
            }
            next unless $readcursor & $indicators->{'deliverystatus'};
            next unless length $e;

            # Original Message:
            # From: kijitora <kijitora@example.jp>
            # To: 0000000000@vzwpix.com
            # Subject: test for bounce
            # Date:  Wed, 20 Jun 2013 10:29:52 +0000
            $v = $dscontents->[-1];

            if( index($e, 'To: ') == 0 ) {
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, 4,));
                $recipients++;
                next;

            } elsif( index($e, 'From: ') == 0 ) {
                # From: kijitora <kijitora@example.jp>
                $senderaddr ||= Sisimai::Address->s3s4(substr($e, 6,));

            } elsif( index($e, 'Subject: ') == 0 ) {
                #   Subject:
                $subjecttxt ||= substr($e, 9,);

            } else {
                # Message could not be delivered to mobile.
                # Error: No valid recipients for this MM
                $v->{'diagnosis'} = Sisimai::String->sweep(substr($e, 7,)) if index($e, 'Error: ') == 0;
            }
        }
    }
    return undef unless $recipients;

    # Set the value of "MAIL FROM:" and "From:"
    $emailparts->[1] .= sprintf("From: %s\n",    $senderaddr) if index($emailparts->[1], "\nFrom: ")    < 0;
    $emailparts->[1] .= sprintf("Subject: %s\n", $subjecttxt) if index($emailparts->[1], "\nSubject: ") < 0;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        SESSION: for my $r ( keys %$messagesof ) {
            # Verify each regular expression of session errors
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
            $e->{'reason'} = $r;
            last;
        }
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Verizon - bounce mail parser class for C<Verizon Wireless>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Verizon;

=head1 DESCRIPTION

Sisimai::Lhost::Verizon parses a bounce email which created by C<Verizon Wireless>. Methods in the
module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Verizon->description;

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

