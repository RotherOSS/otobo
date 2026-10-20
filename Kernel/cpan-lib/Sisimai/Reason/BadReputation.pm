package Sisimai::Reason::BadReputation;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReFAMA }
sub description { 'Email rejected due to an IP address reputation' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "has been temporarily rate limited due to ip reputation",
        "ip/domain reputation problems",
        "likely suspicious due to the very low reputation",
        "none/bad reputation", # t-online.de
        "poor email reputation score",
        "sending mta's poor reputation",
        "temporarily deferred due to unexpected volume or user complaints", # Yahoo Inc.
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is "BadReputation" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is BadReputation
    #                                   0: is not BadReputation
    # @see http://www.ietf.org/rfc/rfc2822.txt
    # @since v5.0.0
    my $class = shift;
    my $argvs = shift // return 0;

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReFAMA;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::BadReputation - Bounce reason is C<BadReputation> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::BadReputation;
    print Sisimai::Reason::BadReputation->match('rate limited due to IP reputation.');  # 1

=head1 DESCRIPTION

C<Sisimai::Reason::BadReputation> checks the bounce reason is C<BadReputation> or not. This class
is called only C<Sisimai::Reason> class.

This is the error that an email rejected due to a reputation score of the sender IP address.

    Action: failed
    Status: 5.7.1
    Remote-MTA: dns; gmail-smtp-in.l.google.com
    Diagnostic-Code: smtp; 550-5.7.1 [192.0.2.22] Our system has detected that this message is
                           likely suspicious due to the very low reputation of the sending IP
                           address. To best protect our users from spam, the message has been
                           blocked. Please visit https://support.google.com/mail/answer/188131
                           for more information.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<BadReputation>.

    print Sisimai::Reason::BadReputation->text;  # BadReputation

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::BadReputation->match('low reputation of the sending IP');    # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<BadReputation>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2022,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

