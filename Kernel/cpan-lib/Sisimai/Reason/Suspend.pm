package Sisimai::Reason::Suspend;
use v5.26;
use strict;
use warnings;

require Sisimai::Eb;
sub text  { $Sisimai::Eb::ReQUIT }
sub description { 'Email rejected due to a recipient account is being suspended' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        " currently suspended",
        " temporary locked",
        "address no longer accepts mail",
        "archived recipient",
        "boite du destinataire archivee",
        "email account that you tried to reach is inactive",
        "inactive account",
        "inactivity new mail is not currently being accepted for this mailbox",
        "invalid/inactive user",
        "is a deactivated mailbox", # http://service.mail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000742
        "is unavailable: user is terminated",
        "mailbox is frozen",
        "mailbox is inactive",
        "mailbox unavailable or access denied",
        "recipient rejected: temporarily inactive",
        "recipient suspend the service",
        "temporarily unavailable user",
        "user is no longer with ",
        "user or domain is disabled",
        "user suspended", # http://mail.163.com/help/help_spam_16.htm
        "vdelivermail: account is locked email bounced",
    ];
    state $pairs = [
        ["account ", "disabled"],
        ["account ", "limited"],
        ["has been ", "suspended"],
        ["mailaddress ", "disabled"],
        ["mailbox ", "disabled"],
        ["not ", "active"],
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # The envelope recipient's mailbox is Suspended or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is mailbox suspended
    #                                   0: is not suspended
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReQUIT;
    return 1 if length $argvs->{'replycode'} && $argvs->{'replycode'} == 525;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Suspend - Bounce reason is C<Suspend> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::Suspend;
    print Sisimai::Reason::Suspend->match('recipient suspend the service'); # 1

=head1 DESCRIPTION

C<Sisimai::Reason::Suspend> checks the bounce reason is C<Suspend> or not. This class is called only
C<Sisimai::Reason> class. This is the error that the recipient account is being suspended due to
unpaid, or being inactive, or other reasons.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<Suspend>.

    print Sisimai::Reason::Suspend->text;  # Suspend

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::Suspend->match('recipient suspend the service'); # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<Suspend>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

