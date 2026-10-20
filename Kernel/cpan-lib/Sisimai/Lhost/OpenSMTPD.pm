package Sisimai::Lhost::OpenSMTPD;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'OpenSMTPD: https://www.opensmtpd.org/' }
sub inquire {
    # Detect an error from OpenSMTPD
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless index($mhead->{'subject'}, 'Delivery status notification') > -1;
    return undef unless index($mhead->{'from'}, 'Mailer Daemon <') > -1;
    return undef unless grep { rindex($_, ' (OpenSMTPD) with ') > -1 } $mhead->{'received'}->@*;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['    Below is a copy of the original message:'];
    state $startingof = {
        # http://www.openbsd.org/cgi-bin/man.cgi?query=smtpd&sektion=8
        # opensmtpd-5.4.2p1/smtpd/
        #   bounce.c/317:#define NOTICE_INTRO \
        #   bounce.c/318:    "    Hi!\n\n"    \
        #   bounce.c/319:    "    This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail.\n"
        #   bounce.c/320:
        #   bounce.c/321:const char *notice_error =
        #   bounce.c/322:    "    An error has occurred while attempting to deliver a message for\n"
        #   bounce.c/323:    "    the following list of recipients:\n\n";
        #   bounce.c/324:
        #   bounce.c/325:const char *notice_warning =
        #   bounce.c/326:    "    A message is delayed for more than %s for the following\n"
        #   bounce.c/327:    "    list of recipients:\n\n";
        #   bounce.c/328:
        #   bounce.c/329:const char *notice_warning2 =
        #   bounce.c/330:    "    Please note that this is only a temporary failure report.\n"
        #   bounce.c/331:    "    The message is kept in the queue for up to %s.\n"
        #   bounce.c/332:    "    You DO NOT NEED to re-send the message to these recipients.\n\n";
        #   bounce.c/333:
        #   bounce.c/334:const char *notice_success =
        #   bounce.c/335:    "    Your message was successfully delivered to these recipients.\n\n";
        #   bounce.c/336:
        #   bounce.c/337:const char *notice_relay =
        #   bounce.c/338:    "    Your message was relayed to these recipients.\n\n";
        #   bounce.c/339:
        'message' => ['    This is the MAILER-DAEMON, please DO NOT REPLY to this'],
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
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        #    Hi!
        #
        #    This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail.
        #
        #    An error has occurred while attempting to deliver a message for
        #    the following list of recipients:
        #
        # kijitora@example.jp: 550 5.2.2 <kijitora@example>... Mailbox Full
        #
        #    Below is a copy of the original message:
        $v = $dscontents->[-1];

        if( Sisimai::String->aligned(\$e, ['@', ' ']) ) {
            # kijitora@example.jp: 550 5.2.2 <kijitora@example.jp>... Mailbox Full
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = substr($e, 0, index($e, ':'));
            $v->{'diagnosis'} = substr($e, index($e, ':') + 1, );
            $recipients++;
        }
    }
    return undef unless $recipients;
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::OpenSMTPD - bounce mail decoder class for OpenSMTPD L<https://www.opensmtpd.org/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::OpenSMTPD;

=head1 DESCRIPTION

C<Sisimai::Lhost::OpenSMTPD> decodes a bounce email which created by OpenSMTPD L<https://www.opensmtpd.org/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::OpenSMTPD->description;

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

