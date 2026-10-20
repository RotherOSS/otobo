package Sisimai::Reason::FailedSTARTTLS;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReTTLS }
sub description { "Email delivery failed due to STARTTLS related problem" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.2.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "starttls is required to send mail",
        "tls required but not supported",   # SendGrid:the recipient mailserver does not support TLS or have a valid certificate
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is "FailedSTARTTLS" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is FailedSTARTTLS
    #                                   0: is not FailedSTARTTLS
    # @see http://www.ietf.org/rfc/rfc2822.txt
    # @since v5.2.0
    my $class = shift;
    my $argvs = shift // return 0;
    my $reply = $argvs->{'replycode'} || 0;

    return 1 if $argvs->{"reason"} eq $Sisimai::Eb::ReTTLS || $argvs->{"command"} eq "STARTTLS";
    return 1 if $reply == 523 || $reply == 524 || $reply == 538;
    return __PACKAGE__->match(lc $argvs->{"diagnosticcode"});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::FailedSTARTTLS - Bounce reason is C<FailedSTARTTLS> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::FailedSTARTTLS;
    print Sisimai::Reason::FailedSTARTTLS->match('5.7.10 STARTTLS is required to send mail');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::FailedSTARTTLS> checks the bounce reason is C<FailedSTARTTLS> or not. This class
is called only C<Sisimai::Reason> class. This is the error related to STARTTLS, DANE, MTA-STS, and
so on.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<FailedSTARTTLS>.

    print Sisimai::Reason::FailedSTARTTLS->text;  # FailedSTARTTLS

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::FailedSTARTTLS->match('5.7.10 STARTTLS is required to send mail');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<FailedSTARTTLS>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

