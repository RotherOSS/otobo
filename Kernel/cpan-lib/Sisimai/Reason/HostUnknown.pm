package Sisimai::Reason::HostUnknown;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;

sub text  { $Sisimai::Eb::ReHOST }
sub description { "Delivery failed due to a domain part of a recipient's email address does not exist" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "all host address lookups failed", # Exim/transports/smtp.c:3524
        "couldn't find any host ",         # qmail-remote.c:78
        "dns server returned answer with no data",
        "domain is not reachable",
        "domain mentioned in email address is unknown",
        "domain must exist",
        "domain name not found",
        "host or domain name not found",
        "host unknown",
        "host unreachable",
        "illegal host/domain name found",
        "invalid domain name",                    # OpenSMTPD/smtpd/mta.c:976
        "mx records point to non-existent hosts", # Exim/routers/dnslookup.c:331
        "name or service not known",
        "no such domain",
        "recipient address rejected: unknown domain name",
        "responded with code nxdomain",
        "unknown host",
    ];
    state $pairs = [
        ["domain ", "not exist"],
        ["host ", " not found"],
        ["unrout", "able ", "address"],
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # Whether the host is unknown or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is unknown host
    #           [Integer]               0: is not unknown host.
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    require Sisimai::SMTP::Command;
    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReHOST;
    return 0 if grep { $argvs->{'command'} eq $_ } Sisimai::SMTP::Command->BeforeRCPT->@*;

    my $statuscode = $argvs->{'deliverystatus'}    // '';
    my $issuedcode = lc $argvs->{'diagnosticcode'} // '';

    if( (Sisimai::SMTP::Status->name($statuscode) || '') eq $Sisimai::Eb::ReHOST ) {
        # To prevent classifying DNS errors as "HostUnknown"
        require Sisimai::Reason::NetworkError;
        return 1 unless Sisimai::Reason::NetworkError->match($issuedcode);

    } else {
        # Status: 5.1.2
        # Diagnostic-Code: SMTP; 550 Host unknown
        return __PACKAGE__->match($issuedcode);
    }
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::HostUnknown - Bounce reason is C<HostUnknown> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::HostUnknown;
    print Sisimai::Reason::HostUnknown->match('550 5.2.1 Host Unknown');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::HostUnknown> checks the bounce reason is C<HostUnknown> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the domain part (Right hand side of C<@> sign) of the recipient's email address
does not exist. In many case, the domain part is misspelled, or the domain name has been expired.
Sisimai will set C<HostUnknown> to the reason of the email bounce if the value of C<Status:> field
in a bounce mail is C<5.1.2>.

    Your message to the following recipients cannot be delivered:

    <kijitora@example.cat>:
    <<< No such domain.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<HostUnknown>.

    print Sisimai::Reason::HostUnknown->text;  # HostUnknown

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::HostUnknown->match('550 5.2.1 Host Unknown');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<HostUnknown>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018,2020,2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

