package Sisimai::Lhost::GoogleWorkspace;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { "Google Workspace: https://workspace.google.com/" }
sub inquire {
    # Detect an error from Google Workspace (Transfer from the Google Workspace to the destination host)
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.21.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef if index($$mbody, "\nDiagnostic-Code:") > -1 || index($$mbody, "\nFinal-Recipient:") > -1;
    return undef unless rindex($mhead->{'from'}, '<mailer-daemon@googlemail.com>') > -1;
    return undef unless index($mhead->{'subject'}, "Delivery Status Notification") > -1;

    require Sisimai::Eb;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ["Content-Type: message/rfc822", "Content-Type: text/rfc822-headers"];
    state $startingof = {
        'message' => ["** "],
        'error'   => ["The response was:", "The response from the remote server was:"],
    };
    state $messagesof = {
        $Sisimai::Eb::ReUSER => ["because the address couldn't be found. Check for typos or unnecessary spaces and try again."],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $entiremesg = "";
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            if( index($e, $startingof->{'message'}->[0]) == 0 ) {
                # ** Message not delivered **
                $readcursor |= $indicators->{'deliverystatus'};
                $entiremesg .= $e." ";
            }
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # ** Message not delivered **
        # You're sending this from a different address or alias using the 'Send mail as' feature.
        # The settings for your 'Send mail as' account are misconfigured or out of date. Check those settings and try resending.
        # Learn more here: https://support.google.com/mail/?p=CustomFromDenied
        # The response was:
        # Unspecified Error (SENT_SECOND_EHLO): Smtp server does not advertise AUTH capability
        next if index($e, "Content-Type: ") == 0;
        $entiremesg .= $e." ";
    }

    while( $recipients == 0 ) {
        # Pick the recipient address from the value of To: header of the original message after
        # Content-Type: message/rfc822 field
        my $p0 = index($emailparts->[1], "\nTo:"); last if $p0 < 0;
        my $p1 = index($emailparts->[1], "\n", $p0 + 2);
        my $cv = Sisimai::Address->s3s4(substr($emailparts->[1], $p0 + 4, $p1 - $p0));
        $dscontents->[0]->{'recipient'} = $cv;
        $recipients++;
    }
    return undef unless $recipients;

    $dscontents->[0]->{'diagnosis'} = $entiremesg;
    for my $e ( @$dscontents ) {
        for my $r ( keys %$messagesof ) {
            # Guess an reason of the bounce
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
            $e->{'reason'} = $r; last;
        }
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::GoogleWorkspace - bounce mail decoder class for Google Workspace L<https://workspace.google.com/>

=head1 SYNOPSIS

    use Sisimai::Lhost::GoogleWorkspace;

=head1 DESCRIPTION

C<Sisimai::Lhost::GoogleWorkspace> decodes a bounce email which created by Google Workspace L<https://workspace.google.com/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::GoogleWorkspace->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

