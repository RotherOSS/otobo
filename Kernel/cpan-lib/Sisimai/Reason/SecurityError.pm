package Sisimai::Reason::SecurityError;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;

sub text  { $Sisimai::Eb::ReSAFE }
sub description { 'Email rejected due to security violation was detected on a destination host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "account not subscribed to ses",
        "authentication credentials invalid",
        "authentication failure",
        "authentication required",
        "authentication turned on in your email client",
        "could not retrieve credentials", # OpenSMTPD/smtpd/mta.c
        "unauthenticated senders not allowed",
        "verification failure",
        "you are not authorized to send mail, authentication is required",
        "you don't authenticate or the domain isn't in my list of allowed rcpthosts",
    ];
    state $pairs = [
        ["authentication failed; server ", " said: "], # Postfix
        ["authentification invalide", "305"],
        ["authentification requise", "402"],
        ["user ", " is not authorized to perform ses:sendrawemail on resource"],
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # The bounce reason is security error or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is security error
    #                                   0: is not security error
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SecurityError - Bounce reason is C<SecurityError> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SecurityError;
    print Sisimai::Reason::SecurityError->match('570 5.7.0 Authentication failure');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::SecurityError> checks the bounce reason is C<SecurityError> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the security violation was detected on the destination mail server. Depends
on the security policy on the server, the sender's email address is camouflaged address.
Sisimai will set C<SecurityError> to the reason of the email bounce if the value of C<Status:> field
in the bounce email is C<5.7.*>.

    Action: failed
    Status: 5.7.1
    Remote-MTA: DNS; gmail-smtp-in.l.google.com
    Diagnostic-Code: SMTP; 550-5.7.1 [2001:f22:222:1513:192:0:2:2...
    Last-Attempt-Date: Sun, 29 Nov 2015 14:12:25 +0900

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<SecurityError>.

    print Sisimai::Reason::SecurityError->text;  # SecurityError

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::SecurityError->match('570 5.7.0 Authentication failure');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<SecurityError>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018,2020,2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

