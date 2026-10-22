package Sisimai::Lhost::KDDI;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'au by KDDI: https://www.au.kddi.com' }
sub inquire {
    # Detect an error from au by KDDI
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0; $match ||= 1 if Sisimai::String->aligned(\$mhead->{'from'}, ['no-reply@.', '.dion.ne.jp']);
                   $match ||= 1 if $mhead->{'reply-to'} && $mhead->{'reply-to'} eq 'no-reply@app.auone-net.jp';
                   $match ||= 1 if grep { rindex($_, 'ezweb.ne.jp (') > -1 } $mhead->{'received'}->@*;
                   $match ||= 1 if grep { rindex($_, '.au.com (') > -1 } $mhead->{'received'}->@*;
    return undef unless $match;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = {'message' => ['Your mail sent on:', 'Your mail attempted to be delivered on:']};

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if grep { index($e, $_) == 0 } $startingof->{'message'}->@*;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        $v = $dscontents->[-1];
        if( index($e, ' Could not be delivered to: <') > -1 ) {
            # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900
            #     Could not be delivered to: <******@**.***.**>
            #     As their mailbox is full.
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }

            my $r = Sisimai::Address->s3s4(substr($e, index($e, '<') + 1, ));
            next unless Sisimai::Address->is_emailaddress($r);
            $v->{'recipient'} = $r;
            $recipients++;

        } elsif( index($e, 'Your mail sent on: ') > -1 ) {
            # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900
            $v->{'date'} = substr($e, 19, );

        } else {
            #     As their mailbox is full.
            $v->{'diagnosis'} .= $e.' ' if index($e, ' ') == 0;
        }
    }
    return undef unless $recipients;

    require Sisimai::Eb;
    require Sisimai::SMTP::Command;
    for my $e ( @$dscontents ) {
        $e->{'command'} = Sisimai::SMTP::Command->find($e->{'diagnosis'}) || '';

        if( defined $mhead->{'x-spasign'} && $mhead->{'x-spasign'} eq 'NG' ) {
            # Content-Type: text/plain; ..., X-SPASIGN: NG (spamghetti, au by KDDI)
            # Filtered recipient returns message that include 'X-SPASIGN' header
            $e->{'reason'} = $Sisimai::Eb::ReFILT;

        } else {
            # There is no X-SPASIGN: header in the bounce message
            # set "UserUnknown" when the remote server rejected after RCPT command.
            $e->{'reason'} = $Sisimai::Eb::ReUSER if $e->{'command'} eq $Sisimai::Eb::CeRCPT;
        }
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::Lhost::KDDI - bounce mail decoder class for au by KDDI L<https://www.au.com/>

=head1 SYNOPSIS

    use Sisimai::Lhost::KDDI;

=head1 DESCRIPTION

C<Sisimai::Lhost::KDDI> decodes a bounce email which created by au by KDDI L<https://www.au.com/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::KDDI->description;

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

