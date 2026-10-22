package Sisimai::Lhost::X5;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Unknown MTA #5' }
sub inquire {
    # Detect an error from Unknown MTA #5
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.13.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $plain = '';

    $match++ if defined $mhead->{'to'} && rindex($mhead->{'to'}, 'NotificationRecipients') > -1;
    if( rindex($mhead->{'from'}, 'TWFpbCBEZWxpdmVyeSBTdWJzeXN0ZW0') > -1 ) {
        # From: "=?iso-2022-jp?B?TWFpbCBEZWxpdmVyeSBTdWJzeXN0ZW0=?=" <...>
        #       Mail Delivery Subsystem
        for my $f ( split(' ', $mhead->{'from'}) ) {
            # Check each element of From: header
            next unless Sisimai::RFC2045->is_encoded(\$f);
            $match++ if rindex(Sisimai::RFC2045->decodeH([$f]), 'Mail Delivery Subsystem') > -1;
            last;
        }
    }

    if( Sisimai::RFC2045->is_encoded(\$mhead->{'subject'}) ) {
        # Subject: =?iso-2022-jp?B?UmV0dXJuZWQgbWFpbDogVXNlciB1bmtub3du?=
        $plain = Sisimai::RFC2045->decodeH([$mhead->{'subject'}]);
        $match++ if rindex($plain, 'Mail Delivery Subsystem') > -1;
    }
    return undef if $match < 2;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['Content-Type: message/delivery-status'] };

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;
    my $p = '';

    # Pick the second message/rfc822 part because the format of email-x5-*.eml is nested structure
    my $cutsbefore      = [split($boundaries->[0], $$mbody, 2)];
       $cutsbefore->[1] = substr($cutsbefore->[1], index($cutsbefore->[1], "\n\n") + 2,);
    my $emailparts      = Sisimai::RFC5322->part(\$cutsbefore->[1], $boundaries);

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

        $v = $dscontents->[-1];
        if( Sisimai::RFC1894->match($e) ) {
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
                $v->{'diagnosis'} = $o->[2];

            } else {
                # Other DSN fields defined in RFC3464
                next unless exists $fieldtable->{ $o->[0] };
                $v->{ $fieldtable->{ $o->[0] } } = $o->[2];
            }
        } else {
            # Continued line of the value of Diagnostic-Code field
            next unless index($p, 'Diagnostic-Code:') == 0;
            next unless index($e, ' ') == 0;
            $v->{'diagnosis'} .= ' '.Sisimai::String->sweep($e);
        }
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    $_->{'diagnosis'} ||= Sisimai::String->sweep($_->{'diagnosis'}) for @$dscontents;
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::X5 - bounce mail parser class for unknown MTA #5.

=head1 SYNOPSIS

    use Sisimai::Lhost::X5;

=head1 DESCRIPTION

Sisimai::Lhost::X5 parses a bounce email which created by Unknown MTA #5. Methods in the module are
called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::X5->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2021,2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

