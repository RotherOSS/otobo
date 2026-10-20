package Sisimai::Lhost::Mimecast;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;

sub description { 'Mimecast' }
sub inquire {
    # Detect an error from Mimecast: https://www.mimecast.com/
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v5.5.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # Subject: [Postmaster] Email Delivery Failure
    my $match = 0; $match ||= 1 if index($mhead->{'subject'}, 'Email Delivery Failure') > -1;
    if( defined $mhead->{'message-id'} ) {
        # Message-Id: <0123456789-1102117314000@us-mta-25.us.mimecast.lan>
        $match ||= 1 if index($mhead->{'message-id'}, '.mimecast.lan>') > -1;
    }
    return undef unless $match;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: :message/rfc822']; # No such line in lhost-mimecast-*
    state $startingof = {'message' => ['-- ']};

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $permessage = {};    # (Hash) Store values of each Per-Message field
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) > -1;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

        $v = $dscontents->[-1];
        if( index($e, '-- ') == 0 ) {
            # An email that you attempted to send to the following address could not be delivered:
            # -- sabineko@neko.ef.example.org
            my $cv = substr($e, 3,); if( index($cv, " ") < 0 ) {
                # -- sotoneko@cat.example.com
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = Sisimai::Address->s3s4($cv);
                $recipients++;

            } else {
                # Deal each line begins with "-- " as an error message.
                #   The problem appears to be :
                #   -- Recipient email address is possibly incorrect
                #   Additional information follows :
                #   -- 5.4.1 Recipient address rejected: Access denied. 
                $v->{'diagnosis'} .= $cv.' ';
            }
        } else {
            # Lines after Content-Type: message/delivery-status
            if( my $f = Sisimai::RFC1894->match($e) ) {
                # $e matched with any field defined in RFC3464
                next unless my $o = Sisimai::RFC1894->field($e);

                if( $o->[3] eq 'code' ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'}      = $o->[1];
                    $v->{'diagnosis'} = $o->[2];

                } else {
                    # Other DSN fields defined in RFC3464
                    next unless exists $fieldtable->{ $o->[0] };
                    next if $o->[3] eq "host" && Sisimai::RFC1123->is_internethost($o->[2]) == 0;
                    $v->{ $fieldtable->{ $o->[0] } } = $o->[2];

                    next unless $f == 1;
                    $permessage->{ $fieldtable->{ $o->[0] } } = $o->[2];
                }
            }
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{ $_ } ||= $permessage->{ $_ } || '' for keys %$permessage;
    }
    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Mimecast - bounce mail decoder class for Mimecast L<https://www.mimecast.com/>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Mimecast;

=head1 DESCRIPTION

C<Sisimai::Lhost::Mimecast> decodes a bounce email which created by Mimecast L<https://www.mimecast.com/>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Mimecast->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2025-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

