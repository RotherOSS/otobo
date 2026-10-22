package Sisimai::Lhost::Notes;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;
use Encode;

sub description { 'HCL Notes' }
sub inquire {
    # Detect an error from HCL Notes (Formerly IBM Notes(Formerly Lotus Notes))
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'subject'};
    return undef unless index($mhead->{'subject'}, 'Undeliverable message') == 0;

    require Sisimai::Eb;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['------- Returned Message --------'];
    state $startingof = {'message' => ['------- Failure Reasons ']};
    state $messagesof = {
        $Sisimai::Eb::ReUSER => [
            'User not listed in public Name & Address Book',
            'ディレクトリのリストにありません',
        ],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $removedmsg = 'MULTIBYTE CHARACTERS HAVE BEEN REMOVED';
    my $encodedmsg = '';

    my $characters = '';
    if( index($mhead->{'content-type'}, 'charset=') > 0 ) {
        # Get character set name, Content-Type: text/plain; charset=ISO-2022-JP
        $characters = lc substr($mhead->{'content-type'}, index($mhead->{'content-type'}, 'charset=') + 8,);
    }

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0;

        # ------- Failure Reasons  --------
        #
        # User not listed in public Name & Address Book
        # kijitora@notes.example.jp
        #
        # ------- Returned Message --------
        $v = $dscontents->[-1];
        if( index($e, '@') > 1 && index($e, ' ') < 0 ) {
            # kijitora@notes.example.jp
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} ||= $e;
            $recipients++;

        } else {
            next if $e eq '' || index($e, '-') == 0;

            if( $e =~ /[^\x20-\x7e]/ ) {
                # Error message is not ISO-8859-1
                $encodedmsg = $e;
                if( $characters ) {
                    # Try to convert string
                    eval { Encode::from_to($encodedmsg, $characters, 'utf8'); };
                    $encodedmsg = $removedmsg if $@;    # Failed to convert

                } else {
                    # No character set in Content-Type header
                    $encodedmsg = $removedmsg;
                }
                $v->{'diagnosis'} .= $encodedmsg;

            } else {
                # Error message does not include multi-byte character
                $v->{'diagnosis'} .= $e;
            }
        }
    }

    unless( $recipients ) {
        # Fallback: Get the recpient address from RFC822 part
        my $p1 = index($emailparts->[1], "\nTo: ");
        my $p2 = index($emailparts->[1], "\n", $p1 + 6);
        if( $p1 > 0 ) {
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($emailparts->[1], $p1 + 5, $p2 - $p1 - 5));
            $recipients++ if $v->{'recipient'};
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'recipient'} = Sisimai::Address->s3s4($e->{'recipient'});

        for my $r ( keys %$messagesof ) {
            # Check each regular expression of Notes error messages
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
            $e->{'reason'} = $r;
            $e->{'status'} = Sisimai::SMTP::Status->code($r) || '';
            last;
        }
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Notes - bounce mail decoder class for HCL Notes (formerly Lotus Notes Server).

=head1 SYNOPSIS

    use Sisimai::Lhost::Notes;

=head1 DESCRIPTION

C<Sisimai::Lhost::Notes> decodes a bounce email which created by HCL Notes (formerly IBM Notes
(formerly Lotus Notes Server)). Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Notes->description;

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

