package Sisimai::Reason::NetworkError;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReINET }
sub description { 'SMTP connection failed due to DNS look up failure or other network problems' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.12
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "address family mismatch on destination mxs", # OpenSMTPD/smtpd/mta.c
        "all routes to destination blocked",          # OpenSMTPD/smtpd/mta.c
        "bad dns lookup error code",                  # OpenSMTPD/smtpd/mta.c
        "could not connect and send the mail to",
        "could not contact dns servers",
        "could not retrieve source address",          # OpenSMTPD/smtpd/mta.c
        "dns records for the destination computer could not be found",
        "establish an smtp connection",
        "exceeded maximum hop count",                 # Courier
        "host is unreachable",
        "host name lookup failure",
        "host not found, try again",
        "listed as a best-preference mx",
        "loop detected",                              # OpenSMTPD/smtpd/mta.c
        "maximum forwarding loop count exceeded",
        "network error on destination mxs",           # OpenSMTPD/smtpd/mta.c
        "no relevant answers",
        "temporary failure in mx lookup",             # OpenSMTPD/smtpd/mta.c
        "too many hops",
        "unable to resolve route ",
        "unrouteable mail domain",
    ];
    state $pairs = [
        ["malformed", "name server reply"],
        ["mail ", "loop"],
        ["message ", "loop"],
        ["no ", "route to"],
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # The bounce reason is network error or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is network error
    #                                   0: is not network error
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::NetworkError - Bounce reason is C<NetworkError> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::NetworkError;
    print Sisimai::Reason::NetworkError->match('554 5.4.6 Too many hops'); # 1

=head1 DESCRIPTION

C<Sisimai::Reason::NetworkError> checks the bounce reason is C<NetworkError> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the SMTP connection failed due to DNS look up failure or other network problems.
This reason has added in Sisimai 4.1.12.

    A message is delayed for more than 10 minutes for the following
    list of recipients:

    kijitora@neko.example.jp: Network error on destination MXs

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<NetworkError>.

    print Sisimai::Reason::NetworkError->text;  # NetworkError

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::NetworkError->match('5.3.5 System config error'); # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<NetworkError>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018,2020-2022,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

