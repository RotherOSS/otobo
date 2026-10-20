package Sisimai::Lhost::AmazonWorkMail;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

# https://aws.amazon.com/workmail/
sub description { 'Amazon WorkMail: https://aws.amazon.com/workmail/' }
sub inquire {
    # Detect an error from Amazon WorkMail
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.29
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $xmail = $mhead->{'x-original-mailer'} || $mhead->{'x-mailer'} || '';

    # X-Mailer: Amazon WorkMail
    # X-Original-Mailer: Amazon WorkMail
    # X-Ses-Outgoing: 2016.01.14-54.240.27.159
    $match++ if $mhead->{'x-ses-outgoing'};
    if( $xmail ) {
        # X-Mailer: Amazon WorkMail
        # X-Original-Mailer: Amazon WorkMail
        $match++ if $xmail eq 'Amazon WorkMail';
    }
    return undef if $match < 2;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['Technical report:'] };

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $permessage = {};    # (Hash) Store values of each Per-Message field
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
        }

        # <!DOCTYPE HTML><html>
        # <head>
        # <meta name="Generator" content="Amazon WorkMail v3.0-2023.77">
        # <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        last if index($e, '<!DOCTYPE HTML><html>') == 0;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{ $_ } ||= $permessage->{ $_ } || '' for keys %$permessage;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( index($e->{'status'}, '.0.0') > 0 || index($e->{'status'}, '.1.0') > 0 ) {
            # Get other D.S.N. value from the error message
            # 5.1.0 - Unknown address error 550-'5.7.1 ...
            $e->{'status'}   = Sisimai::SMTP::Status->find($e->{'diagnosis'}) || $e->{'status'};
        }

        # 554 4.4.7 Message expired: unable to deliver in 840 minutes.
        # <421 4.4.2 Connection timed out>
        $e->{'replycode'} = Sisimai::SMTP::Reply->find($e->{'diagnosis'}) || '';
        $e->{'reason'}  ||= Sisimai::SMTP::Status->name($e->{'status'})   || '';
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::AmazonWorkMail - bounce mail parser class for C<Amazon WorkMail>.

=head1 SYNOPSIS

    use Sisimai::Lhost::AmazonWorkMail;

=head1 DESCRIPTION

Sisimai::Lhost::AmazonWorkMail parses a bounce email which created by C<Amazon WorkMail>. Methods in
the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::AmazonWorkMail->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2021,2023,2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

