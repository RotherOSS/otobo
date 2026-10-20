package Sisimai::Lhost::V5sendmail;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Sendmail version 5' }
sub inquire {
    # Detect an error from V5sendmail
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    return undef unless index($mhead->{'subject'}, 'Returned mail: ') == 0;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['   ----- Unsent message follows -----', '  ----- No message was collected -----'];
    state $startingof = {
        # Error text regular expressions which defined in src/savemail.c
        #   savemail.c:485| (void) fflush(stdout);
        #   savemail.c:486| p = queuename(e->e_parent, 'x');
        #   savemail.c:487| if ((xfile = fopen(p, "r")) == NULL)
        #   savemail.c:488| {
        #   savemail.c:489|   syserr("Cannot open %s", p);
        #   savemail.c:490|   fprintf(fp, "  ----- Transcript of session is unavailable -----\n");
        #   savemail.c:491| }
        #   savemail.c:492| else
        #   savemail.c:493| {
        #   savemail.c:494|   fprintf(fp, "   ----- Transcript of session follows -----\n");
        #   savemail.c:495|   if (e->e_xfp != NULL)
        #   savemail.c:496|       (void) fflush(e->e_xfp);
        #   savemail.c:497|   while (fgets(buf, sizeof buf, xfile) != NULL)
        #   savemail.c:498|       putline(buf, fp, m);
        #   savemail.c:499|   (void) fclose(xfile);
        'error'   => [' while talking to '],
        'message' => ['----- Transcript of session follows -----'],
    };

    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    return undef unless length $emailparts->[1] > 0;

    require Sisimai::SMTP::Command;
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $anotherset = {};    # (Ref->Hash) Another error information
    my @responding;         # (Array) Responses from remote server
    my @commandset;         # (Array) SMTP command which is sent to remote server
    my $errorindex = -1;
    my $v = undef;

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) > -1;
            next;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};
        next unless length $e;

        #    ----- Transcript of session follows -----
        # While talking to smtp.example.com:
        # >>> RCPT To:<kijitora@example.org>
        # <<< 550 <kijitora@example.org>, User Unknown
        # 550 <kijitora@example.org>... User unknown
        # 421 example.org (smtp)... Deferred: Connection timed out during user open with example.org
        $v = $dscontents->[-1];

        if( (index($e, '5') == 0 || index($e, '4') == 0) && Sisimai::String->aligned(\$e, [' <', '@', '>...']) ) {
            # 550 <kijitora@example.org>... User unknown
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            my $p1 = index($e, '<', 0);
            my $p2 = index($e, '>...');
            $v->{'recipient'} = substr($e, $p1 + 1, $p2 - $p1 - 1);
            $v->{'diagnosis'} = substr($e, $p2 + 5,);

            if( $responding[$recipients] ) {
                # Concatenate the response of the server and error message
                $v->{'diagnosis'} .= ': '.$responding[$recipients];
            }
            $recipients++;

        } elsif( index($e, '>>> ') == 0 ) {
            # >>> RCPT To:<kijitora@example.org>
            $commandset[$recipients] = Sisimai::SMTP::Command->find($e);

        } elsif( index($e, '<<< ') == 0 ) {
            # <<< Response
            # <<< 501 <shironeko@example.co.jp>... no access from mail server [192.0.2.55] which is an open relay.
            # <<< 550 Requested User Mailbox not found. No such user here.
            $responding[$recipients] = substr($e, 4,);

        } else {
            # Detect SMTP session error or connection error
            next if $v->{'sessionerr'};
            if( index($e, $startingof->{'error'}->[0]) > 0 ) {
                # ----- Transcript of session follows -----
                # ... while talking to mta.example.org.:
                $v->{'sessionerr'} = 1;
                next;
            }

            if( (index($e, '4') == 0 || index($e, '5') == 0) && index($e, '... ') > 1 ) {
                # 421 example.org (smtp)... Deferred: Connection timed out during user open with example.org
                $anotherset->{'replycode'} = substr($e, 0, 3);
                $anotherset->{'diagnosis'} = substr($e, index($e, '... ') + 4,);
            }
        }
    }

    my $p1 = index($emailparts->[1], "\nTo: ");
    my $p2 = index($emailparts->[1], "\n", $p1 + 6);
    if( $recipients == 0 && $p1 > 0 ) {
        # Get the recipient address from "To:" header at the original message
        $dscontents->[0]->{'recipient'} = Sisimai::Address->s3s4(substr($emailparts->[1], $p1, $p2 - $p1 - 5));
        $recipients = 1;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $errorindex++;
        delete $e->{'sessionerr'};

        if( exists $anotherset->{'diagnosis'} && $anotherset->{'diagnosis'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} ||= $anotherset->{'diagnosis'};

        } else {
            # Set server response as a error message
            $e->{'diagnosis'} ||= $responding[$errorindex];
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'replycode'} = Sisimai::SMTP::Reply->find($e->{'diagnosis'}) || $anotherset->{'replycode'};
        $e->{'command'} = $commandset[$errorindex] || Sisimai::SMTP::Command->find($e->{'diagnosis'}) || '';

        # @example.jp, no local part
        # Get email address from the value of Diagnostic-Code header
        next if index($e->{'recipient'}, '@') > 0;
        $p1 = index($e->{'diagnosis'}, '<'); next if $p1 == -1;
        $p2 = index($e->{'diagnosis'}, '>'); next if $p2 == -1;
        $e->{'recipient'} = Sisimai::Address->s3s4(substr($p1, $p2 - $p1));
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::V5sendmail - bounce mail parser class for C<V5 Sendmail>.

=head1 SYNOPSIS

    use Sisimai::Lhost::V5sendmail;

=head1 DESCRIPTION

Sisimai::Lhost::V5sendmail parses a bounce email which created by C<Sendmail version 5> or any email
appliances based on C<Sendmail version 5>. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::V5sendmail->description;

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
