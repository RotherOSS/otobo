package Sisimai::Reason::AuthFailure;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;

sub text  { $Sisimai::Eb::ReAUTH }
sub description { 'Email rejected due to SPF, DKIM, DMARC failure' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "//spf.pobox.com",
        "5322.From address doesn't meet the authentication requirements",
        "bad spf records for",
        "dmarc policy",
        "doesn't meet the required authentication level",
        "please inspect your spf settings",
        "sender policy framework",
        "spf check: fail",
    ];
    state $pairs = [
        ["spf: ", " is not allowed to send "],
        ["is not allowed to send ", " spf "],
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # The bounce reason is "AuthFailure" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is AuthFailure
    #                                   0: is not AuthFailure
    # @see http://www.ietf.org/rfc/rfc2822.txt
    # @since v5.0.0
    my $class = shift;
    my $argvs = shift // return 0;

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReAUTH;
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq $Sisimai::Eb::ReAUTH;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::AuthFailure - Bounce reason is C<AuthFailure> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::AuthFailure;
    print Sisimai::Reason::AuthFailure->match('5.7.9 Header error');    # 1

=head1 DESCRIPTION

C<Sisimai::Reason::AuthFailure> checks the bounce reason is C<AuthFailure> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that an authenticaion failure related to SPF, DKIM, or DMARC was detected on a
destination mail host. 

    Action: failed
    Status: 5.7.1
    Remote-MTA: dns; smtp.example.com
    Diagnostic-Code: smtp; 550 5.7.1 Email rejected per DMARC policy for example.org

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<AuthFailure>.

    print Sisimai::Reason::AuthFailure->text;  # AuthFailure

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::AuthFailure->match('5.7.0 SPF Check: fail');    # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<AuthFailure>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2022-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

