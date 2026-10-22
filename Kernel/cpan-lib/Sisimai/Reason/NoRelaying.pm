package Sisimai::Reason::NoRelaying;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::RePASS }
sub description { 'Email rejected with error message "Relaying Denied"' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "as a relay",
        "domain isn't in my list of allowed rcpthost",
        "email address is not verified.",
        "insecure mail relay",
        "no relaying",
        "not a gateway",
        "not local host",
        "open relay",
        "relay not permitted",
        "relay prohibition",
        "relaying denied", # Sendmail
        "relaying mail to ",
        "send to a non-local e-mail address", # MailEnable
        "specified domain is not allowed",
        "unable to relay ",
        "we don't handle mail for",
    ];
    state $pairs = [
        ["relay ", "denied"],
        ["n", "t ", "to relay"],
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # Whether the message is rejected by 'Relaying denied'
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: Rejected for "relaying denied"
    #                                   0: is not
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    return 0 if grep { $argvs->{'command'} eq $_ } Sisimai::SMTP::Command->BeforeRCPT->@*;
    return 0 if $argvs->{'reason'} eq $Sisimai::Eb::ReSAFE
             || $argvs->{'reason'} eq $Sisimai::Eb::RePROC
             || $argvs->{'reason'} eq $Sisimai::Eb::Re___0;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::NoRelaying - Bounce reason is C<NoRelaying> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::NoRelaying;
    print Sisimai::Reason::NoRelaying->match('Relaying denied');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::NoRelaying> checks the bounce reason is C<NoRelaying> or not. This class is called
only C<Sisimai::Reason> class. This is the error that the SMTP connection rejected with an error message
like C<Relaying Denied>.

    ... while talking to mailin-01.mx.example.com.:
    >>> RCPT To:<kijitora@example.org>
    <<< 554 5.7.1 <kijitora@example.org>: Relay access denied
    554 5.0.0 Service unavailable

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<NoRelaying>.

    print Sisimai::Reason::NoRelaying->text;  # NoRelaying

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::NoRelaying->match('Relaying denied');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<NoRelaying>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018,2020-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

