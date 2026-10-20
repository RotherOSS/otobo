package Sisimai::Reason::RequirePTR;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::String;

sub text { 'requireptr' }
sub description { 'Email rejected due to missing PTR record or having invalid PTR record' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift // return undef;

    state $index = [
        'access denied. ip name lookup failed',
        'all mail servers must have a ptr record with a valid reverse dns entry',
        'bad dns ptr resource record',
        'cannot find your hostname',
        'client host rejected: cannot find your hostname',  # Yahoo!
        'fix reverse dns for ',
        'ips with missing ptr records',
        'no ptr record found.',
        'please get a custom reverse dns name from your isp for your host',
        'ptr record setup',
        'reverse dns failed',
        'reverse dns required',
        'sender ip reverse lookup rejected',
        'the ip address sending this message does not have a ptr record setup', # Google
        'the corresponding forward dns entry does not point to the sending ip', # Google
        'this system will not accept messages from servers/devices with no reverse dns',
        'unresolvable relay host name',
        'we do not accept mail from hosts with dynamic ip or generic dns ptr-records',
    ];
    state $pairs = [
        ['domain ',' mismatches client ip'],
        ['dns lookup failure: ', ' try again later'],
        ['reverse dns lookup for host ', ' failed permanently'],
        ['server access ', ' forbidden by invalid rdns record of your mail server'],
        ['service permits ', ' unverifyable sending ips'],
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # Rejected due to missing PTR record or having invalid PTR record
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is missing PTR or invalid PTR
    #           [Integer]               0: is not blocked due to missing PTR record
    # @see      http://www.ietf.org/rfc/rfc2822.txt
    # @since v4.0.0
    my $class = shift;
    my $argvs = shift // return undef;

    return 1 if $argvs->{'reason'} eq 'requireptr';
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq 'requireptr';
    return 1 if __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::RequirePTR - Bounce reason is "requireptr" or not.

=head1 SYNOPSIS

    use Sisimai::Reason::RequirePTR;
    print Sisimai::Reason::->match('The IP address sending this message does not have a PTR recor'); # 1

=head1 DESCRIPTION

Sisimai::Reason::RequirePTR checks the bounce reason is "requireptr" or not. This class is called
only from Sisimai::Reason class.

This is the error that SMTP connection was rejected due to missing PTR record or having invalid PTR
record at the source IP address used for the SMTP connection.

    host gmail-smtp-in.l.google.com[142.251.170.27] said:
    [192.0.2.25] The IP address sending this message does not have a PTR record setup, or the
    corresponding forward DNS entry does not point to the sending IP. As a policy, Gmail does
    not accept messages from IPs with missing PTR records. For more information, go to
    https://support.google.com/mail/answer/81126#ip-practices (in reply to end of DATA command)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: "requireptr".

    print Sisimai::Reason::RequirePTR->text;  # "requireptr"

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::RequirePTR->match('Reverse DNS failed');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> returns 1 if the bounce reason is "requireptr". The argument must be Sisimai::Fact object
and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

