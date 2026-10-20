package Sisimai::Lhost::McAfee;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'McAfee Email Appliance' }
sub inquire {
    # Detect an error from McAfee
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # X-NAI-Header: Modified by McAfee Email and Web Security Virtual Appliance
    return undef unless defined $mhead->{'x-nai-header'};
    return undef unless index($mhead->{'x-nai-header'}, 'Modified by McAfee') > -1;
    return undef unless $mhead->{'subject'} eq 'Delivery Status';

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['--- The following addresses had delivery problems ---'] };
    state $messagesof = { 'userunknown' => [' User not exist', ' unknown.', '550 Unknown user ', 'No such user'] };

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $issuedcode = '';    # (String) Alternative diagnostic message
    my $v = undef;
    my $p = '';

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) > -1;
            next;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};
        next unless length $e;

        # Content-Type: text/plain; name="deliveryproblems.txt"
        #
        #    --- The following addresses had delivery problems ---
        #
        # <user@example.com>   (User unknown user@example.com)
        #
        # --------------Boundary-00=_00000000000000000000
        # Content-Type: message/delivery-status; name="deliverystatus.txt"
        #
        $v = $dscontents->[-1];

        if( Sisimai::String->aligned(\$e, ['<', '@', '>', '(', ')']) ) {
            # <kijitora@example.co.jp>   (Unknown user kijitora@example.co.jp)
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, index($e, '<'), index($e, '>')));
            $issuedcode = substr($e, index($e, '(') + 1,);
            $recipients++;

        } elsif( my $f = Sisimai::RFC1894->match($e) ) {
            # $e matched with any field defined in RFC3464
            my $o = Sisimai::RFC1894->field($e);
            unless( $o ) {
                # Fallback code for empty value or invalid formatted value
                if( index($e, 'Original-Recipient: ') == 0 ) {
                    # - Original-Recipient: <kijitora@example.co.jp>
                    $v->{'alias'} = Sisimai::Address->s3s4(substr($e, index($e, ':') + 1,));
                }
                next;
            }
            next unless exists $fieldtable->{ $o->[0] };
            $v->{ $fieldtable->{ $o->[0] } } = $o->[2];

        } else {
            # Continued line of the value of Diagnostic-Code field
            next unless index($p, 'Diagnostic-Code:') == 0;
            next unless index($e, ' ');
            $v->{'diagnosis'} .= ' '.Sisimai::String->sweep($e);
        }
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'} || $issuedcode );

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

Sisimai::Lhost::McAfee - bounce mail parser class for C<McAfee Email Appliance>.

=head1 SYNOPSIS

    use Sisimai::Lhost::McAfee;

=head1 DESCRIPTION

Sisimai::Lhost::McAfee parses a bounce email which created by C<McAfee Email Appliance>. Methods in
the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::McAfee->description;

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

