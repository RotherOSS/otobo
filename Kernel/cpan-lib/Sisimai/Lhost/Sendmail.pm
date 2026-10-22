package Sisimai::Lhost::Sendmail;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Sendmail Open Source: https://sendmail.org/' }
sub inquire {
    # Decode bounce messages from Sendmail Open Source
    # @param    [Hash] mhead    Message headers of the bounce email
    # @param    [String] mbody  Message body of the bounce email
    # @return   [Hash]          The list of decoded bounces and a message/rfc822 part block
    # @return   [undef]         failed to decode or the arguments are missing
    # @see      https://www.proofpoint.com/us/products/email-protection/open-source-email-solution
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef if $mhead->{'x-aol-ip'};   # X-AOL-IP is a header defined in AOL
    my $match = 0; $match ||= 1 if index($mhead->{'subject'}, 'see transcript for details') > -1;
                   $match ||= 1 if index($mhead->{'subject'}, 'Warning: ')                  == 0;
    return undef unless $match > 0;

    require Sisimai::RFC1123;
    require Sisimai::SMTP::Reply;
    require Sisimai::SMTP::Status;
    require Sisimai::SMTP::Command;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822', 'Content-Type: text/rfc822-headers'];
    state $startingof = {
        #   savemail.c:1040|if (printheader && !putline("   ----- Transcript of session follows -----\n",
        #   savemail.c:1041|          mci))
        #   savemail.c:1042|  goto writeerr;
        #   savemail.c:1360|if (!putline(
        #   savemail.c:1361|    sendbody
        #   savemail.c:1362|    ? "   ----- Original message follows -----\n"
        #   savemail.c:1363|    : "   ----- Message header follows -----\n",
        'message' => ['   ----- Transcript of session follows -----'],
        'error'   => ['... while talking to '],
    };

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $permessage = {};    # (Hash) Store values of each Per-Message field
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $thecommand = '';    # (String) SMTP Command name begin with the string '>>>'
    my $esmtpreply = [];    # (Array) Reply from remote server on SMTP session
    my $sessionerr = 0;     # (Integer) Flag, 1 if it is SMTP session error
    my $anotherset = {};    # (Hash) Another error information
    my $p = '';

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or the message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        if( my $f = Sisimai::RFC1894->match($e) ) {
            # $e matched with any field defined in RFC3464
            next unless my $o = Sisimai::RFC1894->field($e);
            $v = $dscontents->[-1];

            if( $o->[3] eq 'addr' ) {
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
            } elsif( $o->[3] eq 'code' ) {
                # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                $v->{'spec'} = $o->[1];
                $v->{'diagnosis'} = $o->[2];

            } else {
                # Other DSN fields defined in RFC3464
                next unless exists $fieldtable->{ $o->[0] };
                next if $o->[3] eq "host" && Sisimai::RFC1123->is_internethost($o->[2]) == 0;
                $v->{ $fieldtable->{ $o->[0] } } = $o->[2];

                next unless $f == 1;
                $permessage->{ $fieldtable->{ $o->[0] } } = $o->[2];
            }
        } else {
            # The line does not begin with a DSN field defined in RFC3464
            #
            # ----- Transcript of session follows -----
            # ... while talking to mta.example.org.:
            # >>> DATA
            # <<< 550 Unknown user recipient@example.jp
            # 554 5.0.0 Service unavailable
            if( substr($e, 0, 1) ne ' ') {
                # Other error messages
                if( index($e, '>>> ') == 0 ) {
                    # >>> DATA (Client Command)
                    $thecommand ||= Sisimai::SMTP::Command->find($e);

                } elsif( index($e, '<<< ') == 0 ) {
                    # <<< Response from the SMTP server
                    my $cv = substr($e, 4,);
                    push @$esmtpreply, $cv unless grep { $cv eq $_ } @$esmtpreply;

                } else {
                    # Detect an SMTP session error or a connection error
                    next if $sessionerr;
                    if( index($e, $startingof->{'error'}->[0]) == 0 ) {
                        # ----- Transcript of session follows -----
                        # ... while talking to mta.example.org.:
                        $sessionerr = 1;
                        next;
                    }

                    if( index($e, '<') == 0 && Sisimai::String->aligned(\$e, ['@', '>.', ' ']) ) {
                        # <kijitora@example.co.jp>... Deferred: Name server: example.co.jp.: host name lookup failure
                        $anotherset->{'recipient'} = Sisimai::Address->s3s4(substr($e, 0, index($e, '>')));
                        $anotherset->{'diagnosis'} = substr($e, index($e, ' ') + 1,);

                    } else {
                        # ----- Transcript of session follows -----
                        # Message could not be delivered for too long
                        # Message will be deleted from queue
                        my $cr = Sisimai::SMTP::Reply->find($e)  || '';
                        my $cs = Sisimai::SMTP::Status->find($e) || '';
                        if( length($cr.$cs) > 7 ) {
                            # 550 5.1.2 <kijitora@example.org>... Message
                            #
                            # DBI connect('dbname=...')
                            # 554 5.3.0 unknown mailer error 255
                            $anotherset->{'status'}     = $cs;
                            $anotherset->{'diagnosis'} .= ' '.$e;

                        } elsif( index($e, 'Message ') == 0 || index($e, 'Warning: ') == 0 ) {
                            # Message could not be delivered for too long
                            # Warning: message still undelivered after 4 hours
                            $anotherset->{'diagnosis'} .= ' '.$e;
                        }
                    }
                }
            } else {
                # Continued line of the value of Diagnostic-Code field
                next if index($p, 'Diagnostic-Code:') != 0 || index($e, ' ') != 0;
                $v->{'diagnosis'} .= ' '.$e;
            }
        }
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    require Sisimai::Eb;
    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{ $_ } ||= $permessage->{ $_ } || '' for keys %$permessage;

        if( exists $anotherset->{'diagnosis'} && $anotherset->{'diagnosis'} ) {
            # Copy alternative error message
            $e->{'diagnosis'}   = $anotherset->{'diagnosis'} if index($e->{'diagnosis'}, ' ') == 0;
            $e->{'diagnosis'}   = $anotherset->{'diagnosis'} if $e->{'diagnosis'} =~ /\A\d+\z/;
            $e->{'diagnosis'} ||= $anotherset->{'diagnosis'};
        }

        while(1) {
            # Replace or append the error message in "diagnosis" with the ESMTP Reply Code when the
            # following conditions have matched
            last if scalar @$esmtpreply == 0 || $recipients != 1;
            $e->{'diagnosis'} = sprintf("%s %s", join(' ', @$esmtpreply), $e->{'diagnosis'});
            last;
        }
        $e->{'command'} ||= $thecommand || Sisimai::SMTP::Command->find($e->{'diagnosis'}) || '';
        $e->{'command'} ||= $Sisimai::Eb::CeEHLO if scalar @$esmtpreply;

        while(1) {
            # Check alternative status code and override it
            last unless exists $anotherset->{'status'};
            last unless length $anotherset->{'status'};
            last if     Sisimai::SMTP::Status->test($e->{'status'});

            $e->{'status'} = $anotherset->{'status'};
            last;
        }
        # @example.jp, no local part
        # Get email address from the value of Diagnostic-Code field
        next unless index($e->{'recipient'}, '@') == 0;
        my $cv = Sisimai::Address->find($e->{'diagnosis'}, 1) || [];
        $e->{'recipient'} = $cv->[0]->{'address'} if scalar @$cv;
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Sendmail - bounce mail decoder class for Sendmail Open Source L<https://sendmail.org/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Sendmail;

=head1 DESCRIPTION

C<Sisimai::Lhost::Sendmail> decodes a bounce email which created by Sendmail Open Source L<https://sendmail.org/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Sendmail->description;

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

