package Sisimai::Lhost::V5sendmail;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Sendmail version 5' }
sub inquire {
    # Detect an error from V5sendmail
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'subject'};
    return undef if index($mhead->{'subject'}, 'Returned mail: ') != 0;

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
        'error'   => ['While talking to '],
        'message' => ['----- Transcript of session follows -----'],
    };

    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    return undef unless length $emailparts->[1] > 0;

    require Sisimai::RFC1123;
    require Sisimai::SMTP::Command;
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $anotherone = {};    # (Ref->Hash) Another error information
    my $remotehost = "";    # (String) The last remote hostname
    my $curcommand = "";    # (String) The last SMTP command

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) > -1;
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        #    ----- Transcript of session follows -----
        # While talking to smtp.example.com:
        # >>> RCPT To:<kijitora@example.org>
        # <<< 550 <kijitora@example.org>, User Unknown
        # 550 <kijitora@example.org>... User unknown
        # 421 example.org (smtp)... Deferred: Connection timed out during user open with example.org
        $v = $dscontents->[-1];
        $curcommand = Sisimai::SMTP::Command->find(substr($e, 4,)) if index($e, ">>> ") == 0;

        if( Sisimai::String->aligned(\$e, [' <', '@', '>...']) || index(uc $e, ">>> RCPT TO:") > -1 ) {
            # 550 <kijitora@example.org>... User unknown
            # >>> RCPT To:<kijitora@example.org>
            my $p0 = index($e, " ");
            my $p1 = index($e, "<", $p0);
            my $p2 = index($e, ">", $p1);
            my $cv = Sisimai::Address->s3s4(substr($e, $p1, $p2 - $p1 + 1));

            if( $remotehost eq "" ) {
                # Keep error messages before "While talking to ..." line
                $anotherone->{ $recipients } .= " ".$e;
                next;
            }

            if( $cv eq $v->{"recipient"} || ($curcommand eq "MAIL" && index($e, "<<< ") == 0) ) {
                # The recipient address is the same address with the last appeared address
                # like "550 <mikeneko@example.co.jp>... User unknown"
                # Append this line to the string which is keeping error messages
                $v->{"diagnosis"} .= " ".$e;
                $v->{"replycode"}  = Sisimai::SMTP::Reply->find($e);
                $curcommand        = "";

            } else {
                # The recipient address in this line differs from the last appeared address
                # or is the first recipient address in this bounce message
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{"recipient"}  = $cv;
                $v->{"rhost"}      = $remotehost;
                $v->{"replycode"}  = Sisimai::SMTP::Reply->find($e);
                $v->{"diagnosis"} .= " ".$e;
                $v->{"command"}  ||= $curcommand;
                $recipients++
            }
        } else {
            # This line does not include a recipient address
            if( index($e, $startingof->{"error"}->[0]) > -1 ) {
                # ... while talking to mta.example.org.:
                my $cv = Sisimai::RFC1123->find($e);
                $remotehost = $cv if Sisimai::RFC1123->is_internethost($cv);

            } else {
                # Append this line into the error message string
                if( index($e, ">>> ") == 0 || index($e, "<<< ") == 0 ) {
                    # >>> DATA
                    # <<< 550 Your E-Mail is redundant.  You cannot send E-Mail to yourself (shironeko@example.jp).
                    # >>> QUIT
                    # <<< 421 dns.example.org Sorry, unable to contact destination SMTP daemon.
                    # <<< 550 Requested User Mailbox not found. No such user here.
                    $v->{"diagnosis"} .= " ".$e

                } else {
                    # 421 Other error message
                    $anotherone->{ $recipients } .= " ".$e;
                }
            }
        }
    }

    if( $recipients == 0 ) {
        # There is no recipient address in the error message
        for my $e ( keys %$anotherone ) {
            # Try to pick an recipient address, a reply code, and error messages
            my $cv = Sisimai::Address->s3s4($anotherone->{ $e }); next unless Sisimai::Address->is_emailaddress($cv);
            my $cr = Sisimai::SMTP::Reply->find($anotherone->{ $e }) || "";

            $dscontents->[ $e ]->{"recipient"} = $cv;
            $dscontents->[ $e ]->{"replycode"} = $cr;
            $dscontents->[ $e ]->{"diagnosis"} = $anotherone->{ $e };
            $recipients++;
        }

        if( $recipients == 0 ) {
            # Try to pick an recipient address from the original message
            my $p1 = index($emailparts->[1], "\nTo: ");
            my $p2 = index($emailparts->[1], "\n", $p1 + 6);

            if( $p1 > 0 ) {
                # Get the recipient address from "To:" header at the original message
                my $cv = Sisimai::Address->s3s4(substr($emailparts->[1], $p1, $p2 - $p1 - 5));
                return undef unless Sisimai::Address->is_emailaddress($cv);
                $dscontents->[0]->{'recipient'} = $cv;
                $recipients++;
            }
        }
    }
    return undef unless $recipients;

    my $j = 0; for my $e ( @$dscontents ) {
        # Tidy up the error message in e.Diagnosis
        $e->{"diagnosis"} ||= $anotherone->{ $j };
        $e->{"command"}   ||= Sisimai::SMTP::Command->find($e->{"diagnosis"});
        $e->{'replycode'}   = Sisimai::SMTP::Reply->find($e->{'diagnosis'}) || $anotherone->{'replycode'};

        # @example.jp, no local part
        # Get email address from the value of Diagnostic-Code header
        next if index($e->{'recipient'}, '@') > 0;
        my $p1 = index($e->{'diagnosis'}, '<'); next if $p1 == -1;
        my $p2 = index($e->{'diagnosis'}, '>'); next if $p2 == -1;
        $e->{'recipient'} = Sisimai::Address->s3s4(substr($e->{'diagnosis'}, $p1, $p2 - $p1));
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::V5sendmail - bounce mail decoder class for V5 Sendmail.

=head1 SYNOPSIS

    use Sisimai::Lhost::V5sendmail;

=head1 DESCRIPTION

C<Sisimai::Lhost::V5sendmail> decodes a bounce email which created by Sendmail version 5 or any email
appliances based on Sendmail version 5. Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::V5sendmail->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

