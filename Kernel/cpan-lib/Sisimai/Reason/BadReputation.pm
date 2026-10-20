package Sisimai::Reason::BadReputation;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'badreputation' }
sub description { 'Email rejected due to an IP address reputation' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift // return undef;

    state $index = [
        'a poor email reputation score',
        'has been temporarily rate limited due to ip reputation',
        'ip/domain reputation problems',
        'likely suspicious due to the very low reputation',
        "the sending mta's poor reputation",
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is "badreputation" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is badreputation
    #                                   0: is not badreputation
    # @see http://www.ietf.org/rfc/rfc2822.txt
    # @since v5.0.0
    my $class = shift;
    my $argvs = shift // return undef;

    return 1 if $argvs->{'reason'} eq 'badreputation';
    return 1 if __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::BadReputation - Bounce reason is C<badreputation> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::BadReputation;
    print Sisimai::Reason::BadReputation->match('rate limited due to IP reputation.');  # 1

=head1 DESCRIPTION

Sisimai::Reason::BadReputation checks the bounce reason is C<badreputation> or not. This class is
called only Sisimai::Reason class.

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

C<text()> returns string: C<badreputation>.

    print Sisimai::Reason::BadReputation->text;  # badreputation

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::BadReputation->match('low reputation of the sending IP');    # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> returns 1 if the bounce reason is C<badreputation>. The argument must be Sisimai::Fact
object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2022 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

