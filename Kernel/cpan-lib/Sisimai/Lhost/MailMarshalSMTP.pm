package Sisimai::Lhost::MailMarshalSMTP;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Trustwave Secure Email Gateway' }
sub inquire {
    # Detect an error from MailMarshalSMTP
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.9
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    return undef unless index($mhead->{'subject'}, 'Undeliverable Mail: "') == 0;

    state $indicators = __PACKAGE__->INDICATORS;
    state $startingof = {
        'message'  => ['Your message:'],
        'error'    => ['Could not be delivered because of'],
        'rcpts'    => ['The following recipients were affected:'],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $endoferror = 0;     # (Integer) Flag for the end of error message
    my $v = undef;

    my $boundaries = ['+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'];
    my $q = Sisimai::RFC2045->boundary($mhead->{'content-type'}, 1); push @$boundaries, $q if $q;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};

        # Your message:
        #    From:    originalsender@example.com
        #    Subject: ...
        #
        # Could not be delivered because of
        #
        # 550 5.1.1 User unknown
        #
        # The following recipients were affected:
        #    dummyuser@blabla.xxxxxxxxxxxx.com
        $v = $dscontents->[-1];

        if( index($e, '    ') == 0 && index($e, '@') > 1 ) {
            # The following recipients were affected:
            #    dummyuser@blabla.xxxxxxxxxxxx.com
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = substr($e, 4,);
            $recipients++;

        } else {
            # Get error message lines
            if( $e eq $startingof->{'error'}->[0] ) {
                # Could not be delivered because of
                #
                # 550 5.1.1 User unknown
                $v->{'diagnosis'} = $e;

            } elsif( $v->{'diagnosis'} && ! $endoferror ) {
                # Append error messages
                $endoferror = 1 if index($e, $startingof->{'rcpts'}->[0]) == 0;
                next if $endoferror;

                $v->{'diagnosis'} .= ' '.$e;

            } else {
                # Additional Information
                # ======================
                # Original Sender:    <originalsender@example.com>
                # Sender-MTA:         <10.11.12.13>
                # Remote-MTA:         <10.0.0.1>
                # Reporting-MTA:      <relay.xxxxxxxxxxxx.com>
                # MessageName:        <B549996730000.000000000001.0003.mml>
                # Last-Attempt-Date:  <16:21:07 seg, 22 Dezembro 2014>
                my $p1 = index($e, '<');
                my $p2 = index($e, '>');
                if( index($e, 'Original Sender: ') == 0 ) {
                    # Original Sender:    <originalsender@example.com>
                    # Use this line instead of "From" header of the original message.
                    $emailparts->[1] .= sprintf("From: %s\n", substr($e, $p1 + 1, $p2 - $p1 - 1));

                } elsif( index($e, 'Sender-MTA: ') == 0 ) {;
                    # Sender-MTA:         <10.11.12.13>
                    $v->{'lhost'} = substr($e, $p1 + 1, $p2 - $p1 - 1);

                } elsif( index($e , 'Reporting-MTA: ') == 0 ) {
                    # Reporting-MTA:      <relay.xxxxxxxxxxxx.com>
                    $v->{'rhost'} = substr($e, $p1 + 1, $p2 - $p1 - 1);

                } elsif( index($e, ' From:') > 0 || index($e, ' Subject:') > 0 ) {
                    #    From:    originalsender@example.com
                    #    Subject: ...
                    $p1 = index($e, ' From:'); $p1 = index($e, ' Subject:') if $p1 < 0;
                    $p2 = index($e, ':');

                    my $cf = substr($e, $p1 + 1, $p2 - $p1 - 1);
                    my $cv = Sisimai::String->sweep(substr($e, $p2 + 1,));
                    $emailparts->[1] .= sprintf("%s: %s\n", $cf, $cv);
                }
            }
        }
    }
    return undef unless $recipients;

    $_->{'diagnosis'} = Sisimai::String->sweep($_->{'diagnosis'}) for @$dscontents;
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::MailMarshalSMTP - bounce mail parser class for C<Trustwave Secure Email Gateway>.

=head1 SYNOPSIS

    use Sisimai::Lhost::MailMarshalSMTP;

=head1 DESCRIPTION

Sisimai::Lhost::MailMarshalSMTP parses a bounce email which created by C<Trustwave Secure Email Gateway>:
formerly MailMarshal SMTP. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::MailMarshalSMTP->description;

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


