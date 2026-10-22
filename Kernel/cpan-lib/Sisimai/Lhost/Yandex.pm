package Sisimai::Lhost::Yandex;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Yandex.Mail: https://www.yandex.ru' }
sub inquire {
    # Detect an error from Yandex.Mail
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.6
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # X-Yandex-Front: mxback1h.mail.yandex.net
    # X-Yandex-TimeMark: 1417885948
    # X-Yandex-Uniq: 92309766-f1c8-4bd4-92bc-657c75766587
    # X-Yandex-Spam: 1
    # X-Yandex-Forward: 10104c00ad0726da5f37374723b1e0c8
    # X-Yandex-Queue-ID: 367D79E130D
    # X-Yandex-Sender: rfc822; shironeko@yandex.example.com
    return undef unless $mhead->{'x-yandex-uniq'};
    return undef unless $mhead->{'from'} eq 'mailer-daemon@yandex.ru';

    require Sisimai::SMTP::Command;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['This is the mail system at host yandex.ru.'] };

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $permessage = {};    # (Hash) Store values of each Per-Message field
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my @commandset;         # (Array) ``in reply to * command'' list
    my $v = undef;
    my $p = '';

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

        if( my $f = Sisimai::RFC1894->match($e) ) {
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

                next unless $f == 1;
                $permessage->{ $fieldtable->{ $o->[0] } } = $o->[2];
            }
        } else {
            # The line does not begin with a DSN field defined in RFC3464
            # <kijitora@example.jp>: host mx.example.jp[192.0.2.153] said: 550
            #    5.1.1 <kijitora@example.jp>... User Unknown (in reply to RCPT TO
            #    command)
            if( index($e, ' (in reply to ') > -1 || index($e, 'command)') > -1 ) {
                # 5.1.1 <userunknown@example.co.jp>... User Unknown (in reply to RCPT TO
                my $cv = Sisimai::SMTP::Command->find($e);
                push @commandset, $cv if $cv;

            } else {
                # Continued line of the value of Diagnostic-Code field
                next unless index($p, 'Diagnostic-Code:') == 0;
                next unless index($e, ' ') == 0;
                $v->{'diagnosis'} .= ' '.Sisimai::String->sweep($e);
            }
        }
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{ $_ }    ||= $permessage->{ $_ } || '' for keys %$permessage;
        $e->{'diagnosis'} =~ y/\n/ /;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'command'} ||=  shift @commandset || Sisimai::SMTP::Command->find($e->{'diagnosis'}) || '';
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Yandex - bounce mail parser class for C<Yandex.Mail>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Yandex;

=head1 DESCRIPTION

Sisimai::Lhost::Yandex parses a bounce email which created by C<Yandex.Mail>. Methods in the module
are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Yandex->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2021,2023,2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut


