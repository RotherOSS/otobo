package Sisimai::Lhost::X6;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Unknown MTA #6' }
sub inquire {
    # Detect an error from Unknown MTA #6
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.25.6
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    return undef unless index($mhead->{'subject'}, 'There was an error sending your mail') == 0;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['The attachment contains the original mail headers'];
    state $startingof = { 'message' => ['We had trouble delivering your message. Full details follow:'] };

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

        # We had trouble delivering your message. Full details follow:
        #
        # Subject: 'Nyaan'
        # Date: 'Thu, 29 Apr 2012 23:34:45 +0000'
        #
        # 1 error(s):
        #
        # SMTP Server <mta2.example.jp> rejected recipient <kijitora@examplejp> 
        #   (Error following RCPT command). It responded as follows: [550 5.1.1 User unknown]
        $v = $dscontents->[-1];
        my $p1 = index($e, 'The following recipients returned permanent errors: ');
        my $p2 = index($e, 'SMTP Server <');
        if( $p1 == 0 || $p2 == 0 ) {
            # SMTP Server <mta2.example.jp> rejected recipient <kijitora@examplejp> 
            # The following recipients returned permanent errors: neko@example.jp.
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            if( $p1 == 0 ) {
                # The following recipients returned permanent errors: neko@example.jp.
                $p1 = index($e, 'errors: ');
                $p2 = index($e, ' ', $p1 + 8);
                $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, $p1 + 8, $p2 - $p1 - 8));

            } elsif( $p2 == 0 ) {
                # SMTP Server <mta2.example.jp> rejected recipient <kijitora@example.jp>
                $p1 = rindex($e, '<');
                $p2 = rindex($e, '>');
                $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, $p1, $p2 - $p1));

            } else {
                next;
            }
            $v->{'diagnosis'} = $e;
            $recipients++;
        }
    }
    return undef unless $recipients;

    require Sisimai::SMTP::Command;
    for my $e ( @$dscontents ) {
        # Get the last SMTP command from the error message
        if( my $cv = Sisimai::SMTP::Command->find($e->{'diagnosis'}) ) {
            # ...(Error following RCPT command).
            $e->{'command'} = $cv;
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::X6 - bounce mail parser class for C<X6>.

=head1 SYNOPSIS

    use Sisimai::Lhost::X6;

=head1 DESCRIPTION

Sisimai::Lhost::X6 parses a bounce email which created by Unknown MTA #6. Methods in the module are
called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::X6->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2020,2021,2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

