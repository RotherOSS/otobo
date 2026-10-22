package Sisimai::Reason::ContentError;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text { $Sisimai::Eb::ReBODY }
sub description { 'Email rejected due to a header format of the email' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "charset not supported",
        "executable files are not allowed in compressed files",
        "header error",
        "header size exceeds maximum permitted",
        "illegal attachment on your message",
        "improper use of 8-bit data in message header",
        "it has a potentially executable attachment",
        "message contain invalid mime headers",
        "message contain improperly-formatted binary content",
        "message contain text that uses unnecessary base64 encoding",
        "message header size, or recipient list, exceeds policy limit",
        "message mime complexity exceeds the policy maximum",
        "message was blocked because its content presents a potential", # https://support.google.com/mail/answer/6590
        "routing loop detected -- too many received: headers",
        'too many "received" headers', # Exim/deliver.c:5425
        "we do not accept messages containing images or other attachments",
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Rejected email due to header format of the email
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: rejected due to content error
    #                                   0: is not content error
    # @see      http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    require Sisimai::Reason::SpamDetected;
    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReBODY;
    return 0 if Sisimai::Reason::SpamDetected->true($argvs);
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq $Sisimai::Eb::ReBODY;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::ContentError - Bounce reason is C<ContentError> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::ContentError;
    print Sisimai::Reason::ContentError->match('550 Message Filterd'); # 1

=head1 DESCRIPTION

C<Sisimai::Reason::ContentError> checks the bounce reason is C<ContentError> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the destination mail server has rejected email due to the header format of
the email like the following. Sisimai will set C<ContentError> to the reason of the email bounce if
the value of C<Status:> field in a bounce email is C<5.6.*>.

=over

=item - 8 bit data in message header

=item - Too many C<Received:> headers

=item - Invalid MIME headers

=back

    ... while talking to g5.example.net.:
    >>> DATA
    <<< 550 5.6.9 improper use of 8-bit data in message header
    554 5.0.0 Service unavailable

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<ContentError>.

    print Sisimai::Reason::ContentError->text;  # ContentError

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::ContentError->match('550 Message Filterd'); # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<ContentError>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2021,2022,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

