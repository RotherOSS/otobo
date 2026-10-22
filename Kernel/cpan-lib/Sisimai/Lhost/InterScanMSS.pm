package Sisimai::Lhost::InterScanMSS;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Trend Micro InterScan Messaging Security Suite' }
sub inquire {
    # Detect an error from InterScanMSS
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $tryto = [
        'Mail could not be delivered',
        'メッセージを配信できません。',
        'メール配信に失敗しました',
    ];

    # 'received' => qr/[ ][(]InterScanMSS[)][ ]with[ ]/,
    $match ||= 1 if index($mhead->{'from'}, '"InterScan MSS"') == 0;
    $match ||= 1 if index($mhead->{'from'}, '"InterScan Notification"') == 0;
    $match ||= 1 if grep { $mhead->{'subject'} eq $_ } @$tryto;
    return undef unless $match;

    require Sisimai::SMTP::Command;
    state $boundaries = ['Content-type: message/rfc822'];

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        next unless length $e;

        $v = $dscontents->[-1];
        my $p1 = index($e, ' <<< ');    # Sent <<< ...
        my $p2 = index($e, ' >>> ');    # Received >>> ...
        if( index($e, '@') > 1 && index($e, ' <') > 1 && ($p1 > 1 || $p2 > 1 || index($e, 'Unable to deliver ') > -1) ) {
            # Sent <<< RCPT TO:<kijitora@example.co.jp>
            # Received >>> 550 5.1.1 <kijitora@example.co.jp>... user unknown
            # Received >>> 550 5.1.1 unknown user.
            # Unable to deliver message to <kijitora@neko.example.jp>
            # Unable to deliver message to <neko@example.jp> (and other recipients in the same domain).
            my $cr = substr($e, rindex($e, '<') + 1, rindex($e, '>') - rindex($e, '<') - 1);
            if( $v->{'recipient'} && $cr ne $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = $cr;
            $v->{'diagnosis'} = $e if index($e, 'Unable to deliver ') > -1;
            $recipients = scalar @$dscontents;
        }

        if( index($e, 'Sent <<< ') == 0 ) {
            # Sent <<< RCPT TO:<kijitora@example.co.jp>
            $v->{'command'} = Sisimai::SMTP::Command->find($e);

        } elsif( index($e, 'Received >>> ') == 0 ) {
            # Received >>> 550 5.1.1 <kijitora@example.co.jp>... user unknown
            $v->{'diagnosis'} = substr($e, index($e, ' >>> ') + 4, );

        } elsif( $p1 > 0 || $p2 > 0 ) {
            # Error message in non-English
            $v->{'command'} = Sisimai::SMTP::Command->find($e) if index($e, ' >>> ') > -1;
            my $p3 = index($e, ' <<< '); next if $p3 == -1;
            $v->{'diagnosis'} = substr($e, $p3 + 4,);
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'reason'} = 'userunknown' if index($e->{'diagnosis'}, 'Unable to deliver') > -1;
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::InterScanMSS - bounce mail parser class for C<Trend Micro InterScan Messaging Security Suite>.

=head1 SYNOPSIS

    use Sisimai::Lhost::InterScanMSS;

=head1 DESCRIPTION

Sisimai::Lhost::InterScanMSS parses a bounce email which created by C<Trend Micro InterScan Messaging Security Suite>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::InterScanMSS->description;

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

