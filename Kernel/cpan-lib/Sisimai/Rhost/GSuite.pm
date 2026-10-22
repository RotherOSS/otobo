package Sisimai::Rhost::GSuite;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from Google Workspace (formerly G Suite) https://workspace.google.com/
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason for GSuite
    # @since v5.2.0
    my $class = shift;
    my $argvs = shift // return ""; return '' unless length $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $messagesof = {
        $Sisimai::Eb::ReHOST => [" responded with code NXDOMAIN", "Domain name not found"],
        $Sisimai::Eb::ReINET => [" had no relevant answers.", "responded with code NXDOMAIN", "Domain name not found"],
        $Sisimai::Eb::Re00MX => ["Null MX"],
        $Sisimai::Eb::ReUSER => ["because the address couldn't be found. Check for typos or unnecessary spaces and try again."],
    };
    my $statuscode = ""; $statuscode = substr($argvs->{'deliverystatus'}, 0, 1) if $argvs->{'deliverystatus'};
    my $esmtpreply = ""; $esmtpreply = substr($argvs->{'replycode'},      0, 1) if $argvs->{'replycode'};
    my $reasontext = "";

    for my $e ( keys %$messagesof ) {
        # The key is a bounce reason name
        next unless grep { index($argvs->{'diagnosticcode'}, $_) > -1 } $messagesof->{ $e }->@*;
        next if $e eq $Sisimai::Eb::ReINET && ($statuscode eq "5" || $esmtpreply eq "5");
        next if $e eq $Sisimai::Eb::ReHOST && ($statuscode eq "4" || $statuscode eq "");
        next if $e eq $Sisimai::Eb::ReHOST && ($esmtpreply eq "4" || $esmtpreply eq "");
        $reasontext = $e; last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::GSuite - Detect the bounce reason returned from Google Workspace (formerly G Suite)

=head1 SYNOPSIS

    use Sisimai::Rhost::GSuite;

=head1 DESCRIPTION

C<Sisimai::Rhost::GSuite> detects the bounce reason from the content of C<Sisimai::Fact> object as
an argument of C<find()> method when the value of C<rhost> of the object end with C<googlemail.com>
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

