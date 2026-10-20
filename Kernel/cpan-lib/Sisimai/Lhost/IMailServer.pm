package Sisimai::Lhost::IMailServer;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'IPSWITCH IMail Server' }
sub inquire {
    # Detect an error from IMailServer
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # X-Mailer: <SMTP32 v8.22>
    $match ||= 1 if index($mhead->{'subject'}, 'Undeliverable Mail ') == 0;
    $match ||= 1 if defined $mhead->{'x-mailer'} && index($mhead->{'x-mailer'}, '<SMTP32 v') == 0;
    return undef unless $match;

    state $boundaries = ['Original message follows.'];
    state $startingof = { 'error' => ['Body of message generated response:'] };
    state $refailures = {
        'hostunknown'   => ['Unknown host'],
        'userunknown'   => ['Unknown user', 'Invalid final delivery userid'],
        'mailboxfull'   => ['User mailbox exceeds allowed size'],
        'virusdetected' => ['Requested action not taken: virus detected'],
        'undefined'     => ['undeliverable to'],
        'expired'       => ['Delivery failed '],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.

        # Unknown user: kijitora@example.com
        #
        # Original message follows.
        $v = $dscontents->[-1];

        my $p0 = index($e, ': ');
        if( $p0 > 8 && Sisimai::String->aligned(\$e, [': ', '@']) ) {
            # Unknown user: kijitora@example.com
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'diagnosis'} = $e;
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, $p0 + 2));
            $recipients++;

        } elsif( index($e, 'undeliverable ') == 0 ) {
            # undeliverable to kijitora@example.com
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4($e);
            $recipients++;

        } else {
            # Other error message text
            $v->{'alterrors'} //= '';
            $v->{'alterrors'}  .= ' '.$e if $v->{'alterrors'};
            $v->{'alterrors'}   = $e if index($e, $startingof->{'error'}->[0]) > -1;
        }
    }
    return undef unless $recipients;

    require Sisimai::SMTP::Command;
    for my $e ( @$dscontents ) {
        if( exists $e->{'alterrors'} && $e->{'alterrors'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} = $e->{'alterrors'}.' '.$e->{'diagnosis'};
            $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
            delete $e->{'alterrors'};
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'command'}   = Sisimai::SMTP::Command->find($e->{'diagnosis'});

        SESSION: for my $r ( keys %$refailures ) {
            # Verify each regular expression of session errors
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } $refailures->{ $r }->@*;
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

Sisimai::Lhost::IMailServer - bounce mail parser class for C<IMail Server>.

=head1 SYNOPSIS

    use Sisimai::Lhost::IMailServer;

=head1 DESCRIPTION

Sisimai::Lhost::IMailServer parses a bounce email which created by C<Ipswitch IMail Server>. Methods
in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::IMailServer->description;

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

