package Sisimai::Lhost::X3;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Unknown MTA #3' }
sub inquire {
    # Detect an error from Unknown MTA #3
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.9
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless index($mhead->{'from'}, 'Mail Delivery System') == 0;
    return undef unless index($mhead->{'subject'}, 'Delivery status notification') == 0;

    require Sisimai::SMTP::Command;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['      This is an automatically generated Delivery Status Notification.'] };

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

        # ============================================================================
        #      This is an automatically generated Delivery Status Notification.
        #
        # Delivery to the following recipients failed permanently:
        #
        #   * kijitora@example.com
        #
        #
        # ============================================================================
        #                             Technical details:
        #
        # SMTP:RCPT host 192.0.2.8: 553 5.3.0 <kijitora@example.com>... No such user here
        #
        #
        # ============================================================================
        $v = $dscontents->[-1];

        if( index($e, '  * ') > -1 && index($e, '@') > 1 ) {
            #   * kijitora@example.com
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = substr($e, index($e, ' * ') + 3,);
            $recipients++;

        } else {
            # Detect error message
            if( index($e, 'SMTP:') == 0 ) {
                # SMTP:RCPT host 192.0.2.8: 553 5.3.0 <kijitora@example.com>... No such user here
                $v->{'command'} = Sisimai::SMTP::Command->find($e);
                $v->{'diagnosis'} = $e;

            } elsif( index($e, 'Routing: ') == 0 ) {
                # Routing: Could not find a gateway for kijitora@example.co.jp
                $v->{'diagnosis'} = substr($e, 9,);

            } elsif( index($e, 'Diagnostic-Code: smtp; ') == 0 ) {
                # Diagnostic-Code: smtp; 552 5.2.2 Over quota
                $v->{'diagnosis'} = substr($e, index($e, ';') + 2,);
            }
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'status'}    = Sisimai::SMTP::Status->find($e->{'diagnosis'}) || '';
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::X3 - bounce mail parser class for C<X3>.

=head1 SYNOPSIS

    use Sisimai::Lhost::X3;

=head1 DESCRIPTION

Sisimai::Lhost::X3 parses a bounce email which created by Unknown MTA #3. Methods in the module are
called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::X3->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2021,2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
