package Sisimai::Rhost::Tencent;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from Tencent
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason at Tencent 
    # @see      https://service.mail.qq.com/detail/122
    # @since v4.25.0
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReAUTH => [
            'spf check failed',         # https://service.mail.qq.com/detail/122/72
            'dmarc check failed',
        ],
        $Sisimai::Eb::ReBLOC => [
            'suspected bounce attacks', # https://service.mail.qq.com/detail/122/57
            'suspected spam ip',        # https://service.mail.qq.com/detail/122/66
            'connection denied',        # https://service.mail.qq.com/detail/122/170
        ],
        $Sisimai::Eb::ReSIZE => [
            'message too large',        # https://service.mail.qq.com/detail/122/168
        ],
        $Sisimai::Eb::ReRATE => [
            'mailbox unavailable or access denined',        # https://service.mail.qq.com/detail/122/166
            'ip frequency limited',                         # https://service.mail.qq.com/detail/122/172
            'domain frequency limited',                     # https://service.mail.qq.com/detail/122/173
            'sender frequency limited',                     # https://service.mail.qq.com/detail/122/174
            'connection frequency limited',                 # https://service.mail.qq.com/detail/122/175
            "frequency of receiving messages is limited",   # https://service.mail.qq.com/detail/122/1011
        ],
        $Sisimai::Eb::ReFROM => [
            'suspected spam',                   # https://service.mail.qq.com/detail/122/71
            'mail is rejected by recipients',   # https://service.mail.qq.com/detail/122/92
        ],
        $Sisimai::Eb::ReSPAM => [
            'spam is embedded in the email',    # https://service.mail.qq.com/detail/122/59
            'mail content denied',              # https://service.mail.qq.com/detail/122/171
        ],
        $Sisimai::Eb::ReQUIT => [
            'is a deactivated mailbox', # http://service.mail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000742
        ],
        $Sisimai::Eb::ReCOMM => [
            'bad address syntax', # https://service.mail.qq.com/detail/122/167
        ],
        $Sisimai::Eb::ReUSER => [
            'mailbox not found',  # https://service.mail.qq.com/detail/122/169
        ],
    };
    my $issuedcode = lc $argvs->{'diagnosticcode'};
    my $reasontext = '';

    for my $e ( keys %$messagesof ) {
        # Try to find the error message matches with the given error message string
        next unless grep { index($issuedcode, $_) > -1 } $messagesof->{ $e }->@*;
        $reasontext = $e;
        last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::Tencent - Detect the bounce reason returned from Tencent.

=head1 SYNOPSIS

    use Sisimai::Rhost::Tencent;

=head1 DESCRIPTION

C<Sisimai::Rhost::Tencent> detects the bounce reason from the content of C<Sisimai::Fact> object as
an argument of C<find()> method when the value of C<rhost> of the object is C<*.qq.com>. This class
is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2019,2020,2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

