package Sisimai::Reason::UserUnknown;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;

sub text  { $Sisimai::Eb::ReUSER }
sub description { "Email rejected due to a local part of a recipient's email address does not exist" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "#5.1.1 bad address",
        "550 address invalid",
        "5.1.0 address rejected.",
        "address not present in directory",
        "address unknown",
        "badrcptto",
        "can't accept user",
        "destination addresses were unknown",
        "destination server rejected recipients",
        "domain or user isn't in my list of allowed rcpthosts",
        "email account that you tried to reach does not exist",
        "email address could not be found",
        "invalid address",
        "invalid mailbox",
        "is not a known user",
        "is not a valid mailbox",
        "mailbox does not exist",
        "mailbox invalid",
        "mailbox not present",
        "mailbox not found",
        "nessun utente simile in questo indirizzo",
        "no account by that name here",
        "no existe dicha persona",
        "no existe ese usuario ",
        "no such recipient",
        "no such user",
        "no thank you rejected: account unavailable",
        "no valid recipients, bye",
        "not a valid recipient",
        "not a valid user here",
        "not a local address",
        "not email addresses",
        "recipient address rejected. (in reply to rcpt to command)",
        "recipient address rejected: access denied",
        "recipient address rejected: userunknown",
        "recipient is in my badrecipientto list",
        "recipient is not accepted",
        "recipient is not in my validrcptto list",
        "recipient is not local",
        "recipient not ok",
        "recipient refuses to accept your mail",
        "recipient unknown",
        "recipients was undeliverable",
        "spectator does not exist",
        "there is no one at this address",
        "unknown mailbox",
        "unknown recipient",
        "unknown user",
        "user missing home directory",
        "user not known",
        "user unknown",
        "utilisateur inconnu !",
        "weil die adresse nicht gefunden wurde oder keine e-mails empfangen kann",
        "your envelope recipient has been denied",
    ];
    state $pairs = [
        ["<", "> not found"],
        ["<", ">... blocked by "],
        ["account ", " does not exist at the organization"],
        ["address", " no longer"],
        ["address", " not exist"],
        ["bad", "recipient"],
        ["invalid", "recipient"],
        ["invalid", "user"],
        ["mailbox ", "does not exist"],
        ["mailbox ", "unavailable"],
        ["no ", " in name directory"],
        ["no ", "mail", "box "],
        ["no ", "such", "address"],
        ["non", "existent user"],
        ["rcpt <", " does not exist"],
        ["rcpt (", "t exist "],
        ["recipient no", "found"],
        ["recipient ", " not exist"],
        ["recipient ", " was not found in"],
        ["this user doesn't have a ", " account"],
        ["unknown e", "mail address"],
        ["unknown local", "part"],
        ["user ", " not exist"],
        ["user ", "doesn't exist"],
        ["user ", "not found"],
        ["user (", ") unknown"],
        ["user <", "> unknown"],
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # Whether the address is "UserUnknown" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is unknown user
    #                                   0: is not unknown user.
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    require Sisimai::SMTP::Command;
    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReUSER;
    return 0 if grep { $argvs->{'command'} eq $_ } Sisimai::SMTP::Command->BeforeRCPT->@*;

    my $tempreason = Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '';
    return 0 if $tempreason eq $Sisimai::Eb::ReQUIT;

    my $issuedcode = lc $argvs->{'diagnosticcode'};
    if( $tempreason eq $Sisimai::Eb::ReUSER ) {
        # *.1.1 = 'Bad destination mailbox address'
        #   Status: 5.1.1
        #   Diagnostic-Code: SMTP; 550 5.1.1 <***@example.jp>:
        #     Recipient address rejected: User unknown in local recipient table
        state $prematches = [
            $Sisimai::Eb::RePASS, $Sisimai::Eb::ReBLOC, $Sisimai::Eb::ReFULL,
            $Sisimai::Eb::ReMOVE, $Sisimai::Eb::ReFROM, $Sisimai::Eb::Re00MX,
        ];
        state $ModulePath = {
            'Sisimai::Reason::NoRelaying'  => 'Sisimai/Reason/NoRelaying.pm',
            'Sisimai::Reason::Blocked'     => 'Sisimai/Reason/Blocked.pm',
            'Sisimai::Reason::MailboxFull' => 'Sisimai/Reason/MailboxFull.pm',
            'Sisimai::Reason::HasMoved'    => 'Sisimai/Reason/HasMoved.pm',
            'Sisimai::Reason::Rejected'    => 'Sisimai/Reason/Rejected.pm',
            'Sisimai::Reason::NotAccept'   => 'Sisimai/Reason/NotAccept.pm',
        };
        my $matchother = 0;

        for my $e ( @$prematches ) {
            # Check the value of "Diagnostic-Code" with other error patterns.
            my $p = 'Sisimai::Reason::'.$e;
            require $ModulePath->{ $p };

            next unless $p->match($issuedcode);
            # Match with reason defined in Sisimai::Reason::* except UserUnknown.
            $matchother = 1;
            last;
        }
        return 1 unless $matchother;    # Did not match with other message patterns

    } elsif( $argvs->{'command'} eq $Sisimai::Eb::CeRCPT ) {
        # When the SMTP command is not "RCPT", the session rejected by other reason, maybe.
        return 1 if __PACKAGE__->match($issuedcode);
    }
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::UserUnknown - Bounce reason is C<UserUnknown> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::UserUnknown;
    print Sisimai::Reason::UserUnknown->match('550 5.1.1 Unknown User');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::UserUnknown> checks the bounce reason is C<UserUnknown> or not.
This class is called only C<Sisimai::Reason> class.

This is the error that the local part (left hand side of C<@> sign) of the recipient's email address
does not exist. In many case, the user has changed the internet service provider, or has quit company,
or the local part is misspelled. Sisimai will set C<UserUnknown> to the reason of the email bounce
if the value of C<Status:> field in the bounce email is C<5.1.1>, or the connection was refused at
SMTP C<RCPT> command, or the contents of C<Diagnostic-Code:> field represents that it is unknown user.

    <kijitora@example.co.jp>: host mx01.example.co.jp[192.0.2.8] said:
      550 5.1.1 Address rejected kijitora@example.co.jp (in reply to
      RCPT TO command)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<UserUnknown>.

    print Sisimai::Reason::UserUnknown->text;  # UserUnknown

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::UserUnknown->match('550 5.1.1 Unknown User');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<UserUnknown>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

