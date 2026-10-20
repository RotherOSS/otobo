package Sisimai::Lhost::DeutscheTelekom;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Deutsche Telekom: https://www.telekom.com/' }
sub inquire {
    # Detect an error from T-Online, Deutsche Telekom.
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v5.7.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # - T-Online: https://www.t-online.de/, @t-online.de, @magenta.de
    # - DeutscheTelekom: https://www.telekom.com/
    #   - Based on the bounce format of Smail 3, the original design model for Exim
    #   - Tailored for Deutsche Telekom's internal Smail 3 fork with custom banners
    #   - Module name follows the infrastructure owner for cross-language compatibility
    # - Smail 3: http://www.weird.com/~woods/projects/smail.html

    # smail-3.2.0.108/src/
    #  notify.c:1052|(void) fprintf(f, "Subject: mail failed, %s\nReference: <%s@%s>\n\n",
    #  notify.c:1053|       subject_to, message_id, primary_name);
    # 
    # T-Online specific headers
    #   Received: from mailin42.aul.t-online.de (mailin42.aul.t-online.de [192.51.100.1])
    #     by mailout11.t-online.de (Postfix) with SMTP id 05E5A1CAC0
    #   From: Mail Delivery System <Mailer-Daemon@t-online.de>
    #   X-TOI-MSGID: c9412855-531f-497b-b007-5ffc033877a0
    state $bannerDTAG = __PACKAGE__->BannerDTAG; return undef unless grep { index($$mbody, $_) > -1 } $bannerDTAG->@*;
    state $indicators = __PACKAGE__->INDICATORS;
    state $startingof = { 'message' => [$bannerDTAG->[1]] };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, [$bannerDTAG->[3], $bannerDTAG->[2]]);
    my $messagelog = '';
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            if( index($e, $startingof->{'message'}->[0]) == 0 ) {
                # |------------------------- Failed addresses follow: ---------------------|
                $readcursor |= $indicators->{'deliverystatus'};

            } else {
                # |------------------------- Message log follows: -------------------------|
                # The line above may appears only in Smail 3.
                #
                # smail-3.2.0.108/src/
                #   models.c:787| if (deliver == NULL && defer == NULL) {
                #   models.c:788| write_log(WRITE_LOG_MLOG, "no valid recipients were found for this message");
                #   models.c:789| return_to_sender = TRUE;
                #   models.c:879| }
                $messagelog .= " ".$e if $e ne "" && index($e, $bannerDTAG->[0]) < 0;
            }
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # |------------------------- Failed addresses follow: ---------------------|
        #  <example@t-online.de>
        #    552 5.2.2 <example@t-online.de> Quota exceeded (mailbox for user is full)
        # 
        # |------------------------- Message header follows: ----------------------|
        # Received: from mail.fragdenstaat.de ([94.130.55.89]) by mailin41.mgt.mul.t-online.de.example.com
        #  with (TLSv1.3:TLS_AES_256_GCM_SHA384 encrypted)
        # ...
        $v = $dscontents->[-1];

        if( index($e, ' <') == 0 && substr($e, -1, 1) eq '>' && index($e, ' ', 1) < 0 ) {
            # Deutsche Telekom: The recipient address is enclosed in angle brackets.
            # |------------------------- Failed addresses follow: ---------------------|
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = substr($e, 2, index($e, '>'));
            $recipients++;

        } elsif( Sisimai::String->aligned(\$e, [' ', '@', '.', ' ... ']) ) {
            # Smail 3:
            #   - The recipient address is not enclosed in angle brackets.
            #   - Error message begins with " ... failed:"
            # smail-3.2.0.108/src/
            #   notify.c:845| if (cur->error) {
            #   notify.c:846| (void) fprintf(f, " %s ... failed: %s\n",
            #   notify.c:847|            cur->in_addr ? cur->in_addr : "(unknown)",
            #   notify.c:848|            cur->error->message);
            #   notify.c:849| }
            # |------------------------- Failed addresses follow: ---------------------|
            #  kijitora@neko.nyaan.example.com ... unknown host
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = substr($e, 1, index($e, ' ', 1) - 1);
            $v->{'diagnosis'} = $messagelog.' '.$e;
            $recipients++;

        } else {
            #    552 5.2.2 <example@t-online.de> Quota exceeded (mailbox for user is full)
            $v->{'diagnosis'} = $e;
        }
    }
    return undef unless $recipients;
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::DeutscheTelekom - bounce mail decoder class for Deutsche Telekom L<https://www.telekom.com/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::DeutscheTelekom;

=head1 DESCRIPTION

C<Sisimai::Lhost::DeutscheTelekom> decodes a bounce email which created by Deutsche Telekom L<https://www.telekom.com/>
or T-Online L<https://www.t-online.de/>. Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::DeutscheTelekom->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

