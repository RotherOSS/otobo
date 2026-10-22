package Sisimai::Lhost::IMailServer;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Progress iMail Server: https://community.progress.com/s/products/imailserver' }
sub inquire {
    # Detect an error from Progress iMail Server
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # X-Mailer: <SMTP32 v8.22>
    my $match = 0; $match ||= 1 if index($mhead->{'subject'}, 'Undeliverable Mail ') == 0;
                   $match ||= 1 if defined $mhead->{'x-mailer'} && index($mhead->{'x-mailer'}, '<SMTP32 v') == 0;
    return undef unless $match;

    require Sisimai::Eb;
    state $boundaries = ['Original message follows.'];
    state $startingof = {'error' => ['Body of message generated response:']};
    state $messagesof = {
        $Sisimai::Eb::ReUSER => ['Unknown user', 'Invalid final delivery userid'],
        $Sisimai::Eb::ReTIME => ['Delivery failed '],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.

        # Unknown user: kijitora@example.com
        #
        # Original message follows.
        $v = $dscontents->[-1];

        my $p0 = index($e, ': ');
        if( ($p0 > 8 && Sisimai::String->aligned(\$e, [': ', '@'])) || index($e, 'undeliverable ') == 0 ) {
            # Unknown user: kijitora@example.com
            # undeliverable to kijitora@example.com
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'diagnosis'} = $e;
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
            delete $e->{'alterrors'};
        }
        $e->{'command'} = Sisimai::SMTP::Command->find($e->{'diagnosis'});

        SESSION: for my $r ( keys %$messagesof ) {
            # Verify each regular expression of session errors
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
            $e->{'reason'} = $r;
            last;
        }
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::IMailServer - bounce mail decoder class for Progress iMail Server
L<https://community.progress.com/s/products/imailserver>.

=head1 SYNOPSIS

    use Sisimai::Lhost::IMailServer;

=head1 DESCRIPTION

C<Sisimai::Lhost::IMailServer> decodes a bounce email which created by Progress iMail Server
L<https://community.progress.com/s/products/imailserver>. Methods in the module are called from
only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::IMailServer->description;

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

