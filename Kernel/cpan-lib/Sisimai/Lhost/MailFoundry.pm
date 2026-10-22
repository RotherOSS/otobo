package Sisimai::Lhost::MailFoundry;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'MailFoundry: https://www.barracuda.com/' }
sub inquire {
    # Detect an error from MailFoundry
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'subject'} eq 'Message delivery has failed';
    return undef unless grep { rindex($_, '(MAILFOUNDRY) id') > -1 } $mhead->{'received'}->@*;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = {
        'message' => ['Unable to deliver message to:'],
        'error'   => ['Delivery failed for the following reason:'],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # Unable to deliver message to: <kijitora@example.org>
        # Delivery failed for the following reason:
        # Server mx22.example.org[192.0.2.222] failed with: 550 <kijitora@example.org> No such user here
        #
        # This has been a permanent failure.  No further delivery attempts will be made.
        $v = $dscontents->[-1];

        if( index($e, 'Unable to deliver message to: <') == 0 && index($e, '@') > 1 ) {
            # Unable to deliver message to: <kijitora@example.org>
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, index($e, '<'), ));
            $recipients++;

        } else {
            # Delivery failed for the following reason:
            if( $e eq $startingof->{'error'}->[0] ) { $v->{'diagnosis'} = $e; next }

            next unless $v->{'diagnosis'};
            next if index($e, '-') == 0;
            $v->{'diagnosis'} .= ' '.$e;
        }
    }
    return undef unless $recipients;
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::MailFoundry - bounce mail decoder class for MailFoundry L<https://www.barracuda.com/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::MailFoundry;

=head1 DESCRIPTION

C<Sisimai::Lhost::MailFoundry> decodes a bounce email which created by MailFoundry L<https://www.barracuda.com/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::MailFoundry->description;

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

