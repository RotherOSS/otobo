package Sisimai::Lhost::SurfControl;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'WebSense SurfControl' }
sub inquire {
    # Detect an error from SurfControl
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # X-SEF-ZeroHour-RefID: fgs=000000000
    # X-SEF-Processed: 0_0_0_000__2010_04_29_23_34_45
    # X-Mailer: SurfControl E-mail Filter
    return undef unless $mhead->{'x-sef-processed'};
    return undef unless $mhead->{'x-mailer'};
    return undef unless $mhead->{'x-mailer'} eq 'SurfControl E-mail Filter';

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['Your message could not be sent.'] };

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
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

        # Your message could not be sent.
        # A transcript of the attempts to send the message follows.
        # The number of attempts made: 1
        # Addressed To: kijitora@example.com
        #
        # Thu 29 Apr 2010 23:34:45 +0900
        # Failed to send to identified host,
        # kijitora@example.com: [192.0.2.5], 550 kijitora@example.com... No such user
        # --- Message non-deliverable.
        $v = $dscontents->[-1];

        if( index($e, 'Addressed To:') == 0 && index($e, '@') > 1 ) {
            # Addressed To: kijitora@example.com
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, index($e, ':') + 2,));
            $recipients++;

        } elsif( grep { index($e, $_) == 0 } (qw|Sun Mon Tue Wed Thu Fri Sat|) ) {
            # Thu 29 Apr 2010 23:34:45 +0900
            $v->{'date'} = $e;

        } elsif( Sisimai::String->aligned(\$e, ['@', ':', ' ', '[', '],', '...']) ) {
            # kijitora@example.com: [192.0.2.5], 550 kijitora@example.com... No such user
            my $p1 = index($e, '[');
            my $p2 = index($e, '],', $p1 + 1);
            $v->{'rhost'} = substr($e, $p1 + 1, $p2 - $p1 - 1);
            $v->{'diagnosis'} = Sisimai::String->sweep(substr($e, $p2 + 2,));

        } else {
            # Fallback, parse RFC3464 headers.
            if( my $f = Sisimai::RFC1894->match($e) ) {
                # $e matched with any field defined in RFC3464
                next unless my $o = Sisimai::RFC1894->field($e);
                next if $o->[0] eq 'final-recipient';
                next unless exists $fieldtable->{ $o->[0] };
                $v->{ $fieldtable->{ $o->[0] } } = $o->[2];

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

    $_->{'diagnosis'} = Sisimai::String->sweep($_->{'diagnosis'}) for @$dscontents;
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::SurfControl - bounce mail parser class for C<SurfControl>.

=head1 SYNOPSIS

    use Sisimai::Lhost::SurfControl;

=head1 DESCRIPTION

Sisimai::Lhost::SurfControl parses a bounce email which created by C<WebSense SurfControl>. Methods
in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::SurfControl->description;

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

