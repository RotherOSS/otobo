package Sisimai::Rhost::Outlook;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from Microsoft Outlook.com: https://www.outlook.com/
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason for Outlook
    # @since v5.2.0
    my $class = shift;
    my $argvs = shift // return ""; return '' unless length $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReHOST => ['The mail could not be delivered to the recipient because the domain is not reachable'],
        $Sisimai::Eb::ReUSER => ['Requested action not taken: mailbox unavailable'],
    };
    my $issuedcode = $argvs->{'diagnosticcode'};
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

Sisimai::Rhost::Outlook - Detect the bounce reason returned from Microsoft Outlook.com

=head1 SYNOPSIS

    use Sisimai::Rhost::Outlook;

=head1 DESCRIPTION

C<Sisimai::Rhost::Outlook> detects the bounce reason from the content of C<Sisimai::Fact> object as
an argument of C<find()> method when the value of C<rhost> of the object end with C<hotmail.com>.
This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

