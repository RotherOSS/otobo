package Sisimai::Lhost::Activehunter;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'TransWARE Active!hunter' };
sub inquire {
    # Detect an error from TransWARE Active!hunter
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # 'from'    => qr/\A"MAILER-DAEMON"/,
    # 'subject' => qr/FAILURE NOTICE :/,
    return undef unless defined $mhead->{'x-ahmailid'};

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['  ----- The following addresses had permanent fatal errors -----'] };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
            next;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};
        next unless length $e;

        #  ----- The following addresses had permanent fatal errors -----
        #
        # >>> kijitora@example.org <kijitora@example.org>
        #
        #  ----- Transcript of session follows -----
        # 550 sorry, no mailbox here by that name (#5.1.1 - chkusr)
        $v = $dscontents->[-1];

        if( index($e, '>>> ') == 0 && index($e, '@') > 1 ) {
            # >>> kijitora@example.org <kijitora@example.org>
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, index($e, '<'),));
            $recipients++;

        } else {
            #  ----- Transcript of session follows -----
            # 550 sorry, no mailbox here by that name (#5.1.1 - chkusr)
            my $p = ord(substr($e, 0, 1));
            next if $p < 48 || $p > 122;
            next if length $v->{'diagnosis'};
            $v->{'diagnosis'} ||= $e;
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

Sisimai::Lhost::Activehunter - bounce mail parser class for Active!hunter.

=head1 SYNOPSIS

    use Sisimai::Lhost::Activehunter;

=head1 DESCRIPTION

Sisimai::Lhost::Activehunter parses a bounce email which created by C<TransWARE Active!hunter>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Activehunter->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference.  See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2021,2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

