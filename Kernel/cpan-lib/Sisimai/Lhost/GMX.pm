package Sisimai::Lhost::GMX;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'GMX: https://gmx.net/' }
sub inquire {
    # Detect an error from GMX and mail.com
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.4
    my $class = shift;
    my $mhead = shift // return undef; return undef unless defined $mhead->{'x-gmx-antispam'};
    my $mbody = shift // return undef;

    # Envelope-To: <kijitora@mail.example.com>
    # X-GMX-Antispam: 0 (Mail was not recognized as spam); Detail=V3;
    # X-GMX-Antivirus: 0 (no virus found)
    # X-UI-Out-Filterresults: unknown:0;
    require Sisimai::SMTP::Command;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['--- The header of the original message is following. ---'];
    state $startingof = {'message' => ['This message was created automatically by mail delivery software']};

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
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # This message was created automatically by mail delivery software.
        #
        # A message that you sent could not be delivered to one or more of
        # its recipients. This is a permanent error. The following address
        # failed:
        #
        # "shironeko@example.jp":
        # SMTP error from remote server after RCPT command:
        # host: mx.example.jp
        # 5.1.1 <shironeko@example.jp>... User Unknown
        $v = $dscontents->[-1];

        if( index($e, '@') > 1 && (index($e, '"') == 0 || index($e, '<') == 0) ) {
            # "shironeko@example.jp":
            # ---- OR ----
            # <kijitora@6jo.example.co.jp>
            #
            # Reason:
            # delivery retry timeout exceeded
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4($e);
            $recipients++;

        } elsif( index($e, 'SMTP error ') == 0 ) {
            # SMTP error from remote server after RCPT command:
            $v->{'command'} = Sisimai::SMTP::Command->find($e);

        } elsif( index($e, 'host: ') == 0 ) {
            # host: mx.example.jp
            $v->{'rhost'} = substr($e, 6, );

        } else {
            # Get error messages
            next unless $e;
            $v->{'diagnosis'} .= $e." ";
        }
    }
    return undef unless $recipients;
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::GMX - bounce mail decoder class for GMX L<https://gmx.net/> and mail.com.

=head1 SYNOPSIS

    use Sisimai::Lhost::GMX;

=head1 DESCRIPTION

C<Sisimai::Lhost::GMX> decodes a bounce email which created by GMX L<https://gmx.net>. Methods in
the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::GMX->description;

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

