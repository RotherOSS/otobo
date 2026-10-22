package Sisimai::Lhost::EinsUndEins;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

# X-UI-Out-Filterresults: unknown:0;
sub description { '1&1: https://www.1und1.de/' }
sub inquire {
    # Detect an error from 1&1
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decodes or the arguments are missing
    # @since v4.1.9
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless index($mhead->{'from'}, '"Mail Delivery System"') == 0;
    return undef unless $mhead->{'subject'} eq 'Mail delivery failed: returning message to sender';

    require Sisimai::Eb;
    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['--- The header of the original message is following. ---'];
    state $startingof = {
        'message' => ['This message was created automatically by mail delivery software'],
        'error'   => ['For the following reason:'],
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        # The following address failed:
        #
        # general@example.eu
        #
        # For the following reason:
        #
        # Mail size limit exceeded. For explanation visit
        # http://postmaster.1and1.com/en/error-messages?ip=%1s
        $v = $dscontents->[-1];

        if( $e =~ /\A\s*([^ ]+[@][^ ]+?)[:]?\z/ ) {
            # general@example.eu OR
            # the line begin with 4 space characters, end with ":" like "    neko@example.eu:"
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4($e);
            $recipients++;

        } elsif( index($e, $startingof->{'error'}->[0]) == 0 ) {
            # For the following reason:
            $v->{'diagnosis'} = $e;

        } else {
            if( length $v->{'diagnosis'} ) {
                # Get error message and append the error message strings
                $v->{'diagnosis'} .= ' '.$e;

            } else {
                # OR the following format:
                #   neko@example.fr:
                #   SMTP error from remote server for TEXT command, host: ...
                $v->{'alterrors'} .= ' '.$e;
            }
        }
    }
    return undef unless $recipients;

    require Sisimai::SMTP::Command;
    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} ||= $e->{'alterrors'} || '';
        $e->{'command'}     = Sisimai::SMTP::Command->find($e->{'diagnosis'});

        if( Sisimai::String->aligned(\$e->{'diagnosis'}, ['host: ', ' reason:']) ) {
            # SMTP error from remote server for TEXT command,
            #   host: smtp-in.orange.fr (193.252.22.65)
            #   reason: 550 5.2.0 Mail rejete. Mail rejected. ofr_506 [506]
            my $p1 = index($e->{'diagnosis'}, 'host: ');
            my $p2 = index($e->{'diagnosis'}, ' reason:');

            $e->{'rhost'}   = substr($e->{'diagnosis'}, $p1 + 6, $p2 - $p1 - 6);
            $e->{'command'} = $Sisimai::Eb::CeDATA if index($e->{'diagnosis'}, 'for TEXT command') > -1;
            $e->{'spec'}    = 'SMTP' if index($e->{'diagnosis'}, 'SMTP error')       > -1;
            $e->{'status'}  = Sisimai::SMTP::Status->find($e->{'diagnosis'});
        } else {
            # For the following reason:
            substr($e->{'diagnosis'}, 0, length $startingof->{'error'}->[0], '');
        }
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::EinsUndEins - bounce mail decoder class for 1&1 L<https://www.1und1.de/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::EinsUndEins;

=head1 DESCRIPTION

C<Sisimai::Lhost::EinsUndEins> decodes a bounce email which created by 1&1 L<https://www.1und1.de/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::EinsUndEins->description;

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

