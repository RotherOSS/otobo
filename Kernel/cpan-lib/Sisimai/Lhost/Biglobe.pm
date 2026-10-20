package Sisimai::Lhost::Biglobe;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'BIGLOBE: https://www.biglobe.ne.jp' }
sub inquire {
    # Detect an error from Biglobe
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless index($mhead->{'from'}, 'postmaster@') > -1;
    return undef unless grep { index($mhead->{'from'}, '@'.$_.'.ne.jp') > -1 } (qw|biglobe inacatv tmtv ttv|);
    return undef unless index($mhead->{'subject'}, 'Returned mail:') == 0;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = {
        'message' => ['   ----- The following addresses had delivery problems -----'],
        'error'   => ['   ----- Non-delivered information -----'],
    };
    state $messagesof = {
        'filtered'    => ['Mail Delivery Failed... User unknown'],
        'mailboxfull' => ["The number of messages in recipient's mailbox exceeded the local limit."],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

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

        # This is a MIME-encapsulated message.
        #
        # ----_Biglobe000000/00000.biglobe.ne.jp
        # Content-Type: text/plain; charset="iso-2022-jp"
        #
        #    ----- The following addresses had delivery problems -----
        # ********@***.biglobe.ne.jp
        #
        #    ----- Non-delivered information -----
        # The number of messages in recipient's mailbox exceeded the local limit.
        #
        # ----_Biglobe000000/00000.biglobe.ne.jp
        # Content-Type: message/rfc822
        #
        $v = $dscontents->[-1];

        if( index($e, '@') > 1 && index($e, ' ') == -1 ) {
            #    ----- The following addresses had delivery problems -----
            # ********@***.biglobe.ne.jp
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            next unless Sisimai::Address->is_emailaddress($e);
            $v->{'recipient'} = $e;
            $recipients++;

        } else {
            next if index($e, '--') > -1;
            $v->{'diagnosis'} .= $e.' ';
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        SESSION: for my $r ( keys %$messagesof ) {
            # Verify each regular expression of session errors
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
            $e->{'reason'} = $r;
            last;
        }
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Biglobe - bounce mail parser class for C<BIGLOBE>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Biglobe;

=head1 DESCRIPTION

Sisimai::Lhost::Biglobe parses a bounce email which created by C<BIGLOBE>. Methods in the module are
called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Biglobe->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

