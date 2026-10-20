package Sisimai::MDA;
use feature ':5.10';
use strict;
use warnings;

sub inquire {
    # Parse message body and return reason and text
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless defined $mhead;
    return undef unless length $$mbody;

    my $mfrom = lc $mhead->{'from'};
    my $match = 0;

    while(1) {
        $match ||= 1 if index($mfrom, 'mail delivery subsystem') == 0;
        $match ||= 1 if index($mfrom, 'mailer-daemon') == 0;
        $match ||= 1 if index($mfrom, 'postmaster') == 0;
        last;
    }
    return undef unless $match > 0;

    state $agentnames = {
        # dovecot/src/deliver/deliver.c
        # 11: #define DEFAULT_MAIL_REJECTION_HUMAN_REASON \
        # 12: "Your message to <%t> was automatically rejected:%n%r"
        'dovecot'    => ['Your message to ', ' was automatically rejected:'],
        'mail.local' => ['mail.local: '],
        'procmail'   => ['procmail: '],
        'maildrop'   => ['maildrop: '],
        'vpopmail'   => ['vdelivermail: '],
        'vmailmgr'   => ['vdeliver: '],
    };

    # dovecot/src/deliver/mail-send.c:94
    state $messagesof = {
        'dovecot' => {
            'userunknown' => ["mailbox doesn't exist: "],
            'mailboxfull' => [
                'quota exceeded',   # Dovecot 1.2 dovecot/src/plugins/quota/quota.c
                'quota exceeded (mailbox for user is full)',    # dovecot/src/plugins/quota/quota.c
                'not enough disk space',
            ],
        },
        'mail.local' => {
            'userunknown' => [
                ': unknown user:',
                ': user unknown',
                ': invalid mailbox path',
                ': user missing home directory',
            ],
            'mailboxfull' => [
                'disc quota exceeded',
                'mailbox full or quota exceeded',
            ],
            'systemerror' => ['temporary file write error'],
        },
        'procmail' => {
            'mailboxfull' => ['quota exceeded while writing'],
            'systemfull'  => ['no space left to finish writing'],
        },
        'maildrop' => {
            'userunknown' => [
                'invalid user specified.',
                'cannot find system user',
            ],
            'mailboxfull' => ['maildir over quota.'],
        },
        'vpopmail' => {
            'userunknown' => ['sorry, no mailbox here by that name.'],
            'filtered'    => [
                'account is locked email bounced',
                'user does not exist, but will deliver to '
            ],
            'mailboxfull' => [
                'domain is over quota',
                'user is over quota',
            ],
        },
        'vmailmgr' => {
            'userunknown' => [
                'invalid or unknown base user or domain',
                'invalid or unknown virtual user',
                'user name does not refer to a virtual user'
            ],
            'mailboxfull' => ['delivery failed due to system quota violation'],
        },
    };

    my $deliversby = '';    # [String] Mail Delivery Agent name
    my $reasonname = '';    # [String] Error reason
    my $bouncemesg = '';    # [String] Error message
    my @linebuffer = split(/\n/, $$mbody);

    for my $e ( keys %$agentnames ) {
        # Find a mail delivery agent name from the entire message body
        my $p = index($$mbody, $agentnames->{ $e }->[0]); next if $p == -1;

        if( scalar $agentnames->{ $e }->@* > 1 ) {
            # Try to find the 2nd element
            my $q = index($$mbody, $agentnames->{ $e }->[1]);
            next if $q == -1;
            next if $p > $q;
        }

        $deliversby = $e;
        last;
    }
    return undef unless $deliversby;

    for my $e ( keys $messagesof->{ $deliversby }->%* ) {
        # Detect an error reason from message patterns of the MDA.
        for my $f ( @linebuffer ) {
            # Whether the error message include each message defined in $messagesof
            next unless grep { index(lc($f), $_) > -1 } $messagesof->{ $deliversby }->{ $e }->@*;
            $reasonname = $e;
            $bouncemesg = $f;
            last;
        }
        last if $bouncemesg && $reasonname;
    }

    return {
        'mda'     => $deliversby,
        'reason'  => $reasonname // '',
        'message' => $bouncemesg // '',
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::MDA - Error message parser for MDA

=head1 SYNOPSIS

    use Sisimai::MDA;
    my $header = { 'from' => 'mailer-daemon@example.jp' };
    my $string = 'mail.local: Disc quota exceeded';
    my $return = Sisimai::MDA->inquire($header, \$string);

=head1 DESCRIPTION

Sisimai::MDA parse bounced email which created by some MDA, such as C<dovecot>, C<mail.local>,
C<procmail>, and so on. This class is called from Sisimai::Message only.

=head1 CLASS METHODS

=head2 C<B<inquire(I<Header>, I<Reference to message body>)>>

C<inquire()> is a parser for detecting an error from mail delivery agent.

    my $header = { 'from' => 'mailer-daemon@example.jp' };
    my $string = 'mail.local: Disc quota exceeded';
    my $return = Sisimai::MDA->inquire($header, \$string);
    warn Dumper $return;
    $VAR1 = {
        'mda' => 'mail.local',
        'reason' => 'mailboxfull',
        'message' => 'mail.local: Disc quota exceeded'
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018-2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
