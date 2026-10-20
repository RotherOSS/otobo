package Sisimai::Reason::UserUnknown;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::String;

sub text  { 'userunknown' }
sub description { "Email rejected due to a local part of a recipient's email address does not exist" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;

    state $index = [
        '#5.1.1 bad address',
        '550 address invalid',
        '5.1.0 address rejected.',
        'address does not exist',
        'address not present in directory',
        'address unknown',
        "can't accept user",
        'does not exist.',
        'destination addresses were unknown',
        'destination server rejected recipients',
        'email address does not exist',
        'email address could not be found',
        'invalid address',
        'invalid mailbox',
        'invalid mailbox path',
        'invalid recipient',
        'is not a known user',
        'is not a valid mailbox',
        'is not an active address at this host',
        'mailbox does not exist',
        'mailbox invalid',
        'mailbox is inactive',
        'mailbox is unavailable',
        'mailbox not present',
        'mailbox not found',
        'mailbox unavaiable',
        'nessun utente simile in questo indirizzo',
        'no account by that name here',
        'no existe dicha persona',
        'no existe ese usuario ',
        'no mail box available for this user',
        'no mailbox by that name is currently available',
        'no mailbox found',
        'no such address here',
        'no such mailbox',
        'no such person at this address',
        'no such recipient',
        'no such user',
        'no thank you rejected: account unavailable',
        'no valid recipients, bye',
        'not a valid recipient',
        'not a valid user here',
        'not a local address',
        'not email addresses',
        'recipient address rejected. (in reply to rcpt to command)',
        'recipient address rejected: access denied',
        'recipient address rejected: invalid user',
        'recipient address rejected: invalid-recipient',
        'recipient address rejected: unknown user',
        'recipient does not exist',
        'recipient is not local',
        'recipient not exist',
        'recipient not found',
        'recipient not ok',
        'recipient refuses to accept your mail',
        'recipient unknown',
        'requested action not taken: mailbox unavailable',
        'resolver.adr.recipient notfound',
        'sorry, user unknown',
        'sorry, badrcptto',
        'sorry, no mailbox here by that name',
        'sorry, your envelope recipient has been denied',
        "that domain or user isn't in my list of allowed rcpthosts",
        'the email account that you tried to reach does not exist',
        'the following recipients was undeliverable',
        "the user's email name is not found",
        'there is no one at this address',
        'this address no longer accepts mail',
        'this email address is wrong or no longer valid',
        'this recipient is in my badrecipientto list',
        'this recipient is not in my validrcptto list',
        'this spectator does not exist',
        'unknown mailbox',
        'unknown recipient',
        'unknown user',
        'user does not exist',
        'user missing home directory',
        'user not active',
        'user not exist',
        'user not found',
        'user not known',
        'user unknown',
        'utilisateur inconnu !',
        'vdeliver: invalid or unknown virtual user',
        'your envelope recipient is in my badrcptto list',
    ];
    state $pairs = [
        ['<', '> not found'],
        ['<', '>... blocked by '],
        ['account ', ' does not exist at the organization'],
        ['adresse d au moins un destinataire invalide. invalid recipient.', '416'],
        ['adresse d au moins un destinataire invalide. invalid recipient.', '418'],
        ['bad', 'recipient'],
        ['mailbox ', 'does not exist'],
        ['mailbox ', 'unavailable or access denied'],
        ['no ', ' in name directory'],
        ['non', 'existent user'],
        ['rcpt <', ' does not exist'],
        ['recipient ', ' was not found in'],
        ['recipient address rejected: user ', '  does not exist'],
        ['recipient address rejected: user unknown in ', '  table'],
        ['said: 550-5.1.1 ', ' user unknown '],
        ['said: 550 5.1.1 ', ' user unknown '],
        ["this user doesn't have a ", " account"],
        ['unknown e', 'mail address'],
        ['unknown local', 'part'],
        ['user ', ' was not found'],
        ['user ', ' does not exist'],
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # Whether the address is "userunknown" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is unknown user
    #                                   0: is not unknown user.
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;
    return 1 if $argvs->{'reason'} eq 'userunknown';

    my $tempreason = Sisimai::SMTP::Status->name($argvs->{'deliverystatus'}) || '';
    return 0 if $tempreason eq 'suspend';

    my $issuedcode = lc $argvs->{'diagnosticcode'};
    if( $tempreason eq 'userunknown' ) {
        # *.1.1 = 'Bad destination mailbox address'
        #   Status: 5.1.1
        #   Diagnostic-Code: SMTP; 550 5.1.1 <***@example.jp>:
        #     Recipient address rejected: User unknown in local recipient table
        state $prematches = [qw|NoRelaying Blocked MailboxFull HasMoved Rejected NotAccept|];
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

    } elsif( $argvs->{'smtpcommand'} eq 'RCPT' ) {
        # When the SMTP command is not "RCPT", the session rejected by other reason, maybe.
        return 1 if __PACKAGE__->match($issuedcode);
    }
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::UserUnknown - Bounce reason is C<userunknown> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::UserUnknown;
    print Sisimai::Reason::UserUnknown->match('550 5.1.1 Unknown User');   # 1

=head1 DESCRIPTION

Sisimai::Reason::UserUnknown checks the bounce reason is C<userunknown> or not. This class is called
only Sisimai::Reason class.

This is the error that a local part (Left hand side of @ sign) of a recipient's email address does
not exist. In many case, a user has changed internet service provider, or has quit company, or the
local part is misspelled. Sisimai will set C<userunknown> to the reason of email bounce if the value
of Status: field in a bounce email is C<5.1.1>, or connection was refused at SMTP RCPT command, or
the contents of Diagnostic-Code: field represents that it is unknown user.

    <kijitora@example.co.jp>: host mx01.example.co.jp[192.0.2.8] said:
      550 5.1.1 Address rejected kijitora@example.co.jp (in reply to
      RCPT TO command)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<userunknown>.

    print Sisimai::Reason::UserUnknown->text;  # userunknown

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::UserUnknown->match('550 5.1.1 Unknown User');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> returns 1 if the bounce reason is C<userunknown>. The argument must be Sisimai::Fact
object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
