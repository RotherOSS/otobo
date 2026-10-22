package Sisimai::Lhost::mFILTER;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Digital Arts m-FILTER: https://www.daj.jp/bs/mf/' }
sub inquire {
    # Detect an error from Digital Arts m-FILTER
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['-------original message', '-------original mail info'];
    state $startingof = {
        'command'  => ['-------SMTP command'],
        'error'    => ['-------server message'],
    };

    # X-Mailer: m-FILTER
    my $proceedsto   = 0;
       $proceedsto   = 1 if defined $mhead->{'x-mailer'} && $mhead->{'x-mailer'} eq 'm-FILTER';
       $proceedsto ||= 1 if grep { index($$mbody, $_) > 1 } @$boundaries;
       $proceedsto ||= 1 if grep { index($$mbody, $_) > 1 } $startingof->{'command'}->@*;
       $proceedsto ||= 1 if grep { index($$mbody, $_) > 1 } $startingof->{'error'}->@*;
    return undef unless $proceedsto;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $markingset = {'diagnosis' => 0, 'command' => 0};

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            if( index($e, '@') > 1 && index($e, ' ') < 0 && Sisimai::Address->is_emailaddress($e) ) {
                $readcursor |= $indicators->{'deliverystatus'};
            }
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # このメールは「m-FILTER」が自動的に生成して送信しています。
        # メールサーバーとの通信中、下記の理由により
        # このメールは送信できませんでした。
        #
        # 以下のメールアドレスへの送信に失敗しました。
        # kijitora@example.jp
        #
        #
        # -------server message
        # 550 5.1.1 unknown user <kijitora@example.jp>
        #
        # -------SMTP command
        # DATA
        #
        # -------original message
        $v = $dscontents->[-1];

        if( index($e, '@') > 0 && index($e, ' ') < 0 ) {
            # 以下のメールアドレスへの送信に失敗しました。
            # kijitora@example.jp
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = $e;
            $recipients++;

        } elsif( length $e == 4 && index($e, ' ') < 0 ) {
            # -------SMTP command
            # DATA
            next if $v->{'command'};
            $v->{'command'} = $e if $markingset->{'command'};

        } else {
            # Get error message and SMTP command
            if( $e eq $startingof->{'error'}->[0] ) {
                # -------server message
                $markingset->{'diagnosis'} = 1;

            } elsif( $e eq $startingof->{'command'}->[0] ) {
                # -------SMTP command
                $markingset->{'command'} = 1;

            } else {
                # 550 5.1.1 unknown user <kijitora@example.jp>
                next if index($e, '-') == 0;
                next if $v->{'diagnosis'};
                $v->{'diagnosis'} = $e;
            }
        } # End of error message part
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Get localhost and remote host name from Received header.
        next unless scalar $mhead->{'received'}->@*;
        my $rheads = $mhead->{'received'};
        my $rhosts = Sisimai::RFC5322->received($rheads->[-1]);

        $e->{'lhost'} ||= shift Sisimai::RFC5322->received($rheads->[0])->@*;
        for my $ee ( $rhosts->[0], $rhosts->[1] ) {
            # Avoid "... by m-FILTER"
            next unless rindex($ee, '.') > -1;
            $e->{'rhost'} = $ee;
        }
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::mFILTER - bounce mail decoder class for Digital Arts m-FILTER L<https://www.daj.jp/bs/mf/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::mFILTER;

=head1 DESCRIPTION

C<Sisimai::Lhost::mFILTER> decodes a bounce email which created by Digital Arts m-FILTER L<https://www.daj.jp/bs/mf/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::mFILTER->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

