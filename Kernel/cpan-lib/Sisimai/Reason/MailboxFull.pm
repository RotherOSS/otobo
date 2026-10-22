package Sisimai::Reason::MailboxFull;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReFULL }
sub description { "Email rejected due to a recipient's mailbox is full" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "452 insufficient disk space",
        "account disabled temporarly for exceeding receiving limits",
        "boite du destinataire pleine",
        "exceeded storage allocation",
        "full mailbox",
        "mailbox exceeds allowed size",
        "mailbox size limit exceeded",
        "mailbox would exceed maximum allowed storage",
        "mailfolder is full",
        "no space left on device",
        "not sufficient disk space",
        "quota violation for",
        "too much mail data", # @docomo.ne.jp
        "user has exceeded quota, bouncing mail",
        "user has too many messages on the server",
        "user's space has been used up",
    ];
    state $pairs = [
        ["account is ", " quota"],
        ["disk", "quota"],
        ["enough ", " space"],
        ["mailbox ", "exceeded", " limit"],
        ["mailbox ", "full"],   # Exim/transports/appendfile.c:2567
        ["mailbox ", "quota"],
        ["maildir ", "quota"],
        ["over ", "quota"],
        ["quota ", "exceeded"], # Exim/transports/appendfile.c:3050
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # The envelope recipient's mailbox is full or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is mailbox full
    #                                   0: is not mailbox full
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0; return 0 unless $argvs->{'deliverystatus'};

    # Delivery status code points "MailboxFull".
    # Status: 4.2.2
    # Diagnostic-Code: SMTP; 450 4.2.2 <***@example.jp>... Mailbox Full
    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReFULL;
    return 1 if (Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '') eq $Sisimai::Eb::ReFULL;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::MailboxFull - Bounce reason is C<MailboxFull> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::MailboxFull;
    print Sisimai::Reason::MailboxFull->match('400 4.2.3 Mailbox full');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::MailboxFull> checks the bounce reason is C<MailboxFull> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the recipient's mailbox is full. Sisimai will set C<MailboxFull> to the reason
of the email bounce if the value of C<Status:> field in a bounce email is C<4.2.2> or C<5.2.2>.

    Action: failed
    Status: 5.2.2
    Diagnostic-Code: smtp;550 5.2.2 <kijitora@example.jp>... Mailbox Full

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<MailboxFull>.

    print Sisimai::Reason::MailboxFull->text;  # MailboxFull

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::MailboxFull->match('400 4.2.3 Mailbox full');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<MailboxFull>. The argument must be C<Sisimai::Fact>
object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

