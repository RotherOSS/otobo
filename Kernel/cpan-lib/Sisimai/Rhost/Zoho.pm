package Sisimai::Rhost::Zoho;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from Zoho Mail
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason for Zoho
    # @see
    # @since v5.5.0
    # - Zoho Mail: https://www.zoho.com/mail/
    # - Reasons an email is marked as Spam: https://www.zoho.com/mail/help/spam-reason.html
    # - https://github.com/zoho/zohodesk-oas/blob/main/v1.0/EmailFailureAlert.json
    # - Zoho SMTP Error Codes | SMTP Field Manual: https://smtpfieldmanual.com/provider/zoho
    my $class = shift;
    my $argvs = shift // return ""; return '' unless length $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReAUTH => [
            # - <*******@zoho.com>: host smtpin.zoho.com[204.141.33.23] said: 550 5.7.1 Email
            #   rejected per DMARC policy for zoho.com
            "Email rejected per DMARC policy",
        ],
        $Sisimai::Eb::ReBLOC => [
            # - mx.zoho.com[204.141.33.44]:25, delay=1202, delays=1200/0/0.91/0.30, dsn=4.7.1,
            #   status=deferred (host mx.zoho.com[204.141.33.44] said:
            #   451 4.7.1 Greylisted, try again after some time (in reply to RCPT TO command))
            "Greylisted, try again after some time",
        ],
        $Sisimai::Eb::ReFROM => [
            # - <*******@zoho.com>: host smtpin.zoho.com[204.141.33.23] said: 554 5.7.1 Email
            #   cannot be delivered. Reason: Email flagged as Spam. (in reply to RCPT TO command)
            # - <***@zoho.com>: host mx.zoho.com[136.143.183.44] said: 541 5.4.1 Mail rejected
            #   by destination domain (in reply to RCPT TO command)
            "Email cannot be delivered. Reason: Email flagged as Spam",
            "Mail rejected by destination domain",
        ],
        $Sisimai::Eb::ReWONT => [
            # - <*******@zoho.com>: host smtpin.zoho.com[204.141.33.23] said: 554 5.7.7 Email
            #   policy violation detected (in reply to end of DATA command)
            "Email policy violation detected",
            "Mailbox delivery restricted by policy error",
        ],
        $Sisimai::Eb::RePROC => [
            # - https://github.com/zoho/zohodesk-oas/blob/main/v1.0/EmailFailureAlert.json#L168
            #   452 4.3.1 Temporary System Error
            "Temporary System Error",
        ],
        $Sisimai::Eb::ReUSER => [
            # - <*******@zoho.com>: host smtpin.zoho.com[204.141.33.23] said:
            #   550 5.1.1 User does not exist - <***@zoho.com> (in reply to RCPT TO command)
            # - 552 5.1.1 <****@zoho.com> Mailbox delivery failure policy error
            "User does not exist",
        ],
        $Sisimai::Eb::ReEXEC => [
            # - 552 5.7.1 virus **** detected by Zoho Mail
            " detected by Zoho Mail",
        ],
    };

    for my $e ( keys %$messagesof ) {
        # Try to find the error message matches with the given error message string
        next unless grep { index($argvs->{'diagnosticcode'}, $_) > -1 } $messagesof->{ $e }->@*;
        return $e;
    }
    return "";
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::Zoho - Detect the bounce reason returned from Zoho Mail

=head1 SYNOPSIS

    use Sisimai::Rhost::Zoho;

=head1 DESCRIPTION

C<Sisimai::Rhost::Zoho> detects the bounce reason from the content of C<Sisimai::Fact> object as
an argument of C<find()> method when the value of C<rhost> of the object end with C<.zoho.com> or
C<zoho.eu>. This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2025-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

