package Sisimai::Reason::RateLimited;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReRATE }
sub description { "Rejected due to exceeding a rate limit: sending too fast or too many concurrency connections" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.26
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "has exceeded the max emails per hour ",
        "please try again slower",
        "receiving mail at a rate that prevents additional messages from being delivered",
        "temporarily deferred due to unexpected volume or user complaints",
        "throttling failure: ",
        "too many errors from your ip",         # Free.fr
        "too many recipients",                  # ntt docomo
        "too many smtp sessions for this host", # Sendmail(daemon.c)
        "trop de connexions, ",
        "we have already made numerous attempts to deliver this message",
    ];
    state $pairs = [
        ["exceeded ", "allowable number of posts without solving a captcha"],
        ["connection ", "limit"],
        ["temporarily", "rate limited"],
        ["too many con", "s"],
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # Blocked due to that connection rate limit exceeded
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: Rate limited
    #                                   0: Not rate limited
    # @since v4.1.26
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReRATE;
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq $Sisimai::Eb::ReRATE;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::RateLimited - Bounced due to that too many connections.

=head1 SYNOPSIS

    use Sisimai::Reason::RateLimited;
    print Sisimai::Reason::RateLimited->match('Connection rate limit exceeded');    # 1

=head1 DESCRIPTION

C<Sisimai::Reason::RateLimited> checks the bounce reason is C<RateLimited> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the SMTP connection was rejected temporarily due to too fast or too many
concurrency connections to the remote server. This reason has added in Sisimai 4.1.26.

    <kijitora@example.ne.jp>: host mx02.example.ne.jp[192.0.1.20] said:
        452 4.3.2 Connection rate limit exceeded. (in reply to MAIL FROM command)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<RateLimited>.

    print Sisimai::Reason::RateLimited->text;  # RateLimited

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::RateLimited->match('Connection rate limit exceeded');  # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<RateLimited>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

