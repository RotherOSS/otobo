package Sisimai::Rhost::IUA;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from https://www.i.ua/
    # @param    [Sisimai::Fact] argvs   Decoded email object
    # @return   [String]                The bounce reason at https://www.i.ua/
    # @since v4.25.0
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $errorcodes = {
        # https://mail.i.ua/err/$(CODE)
        '1'  => $Sisimai::Eb::RePASS, # The use of SMTP as mail gate is forbidden.
        '2'  => $Sisimai::Eb::ReUSER, # User is not found.
        '3'  => $Sisimai::Eb::ReQUIT, # Mailbox was not used for more than 3 months
        '4'  => $Sisimai::Eb::ReFULL, # Mailbox is full.
        '5'  => $Sisimai::Eb::ReRATE, # Letter sending limit is exceeded.
        '6'  => $Sisimai::Eb::RePASS, # Use SMTP of your provider to send mail.
        '7'  => $Sisimai::Eb::ReBLOC, # Wrong value if command HELO/EHLO parameter.
        '8'  => $Sisimai::Eb::ReFROM, # Couldn't check sender address.
        '9'  => $Sisimai::Eb::ReBLOC, # IP-address of the sender is blacklisted.
        '10' => $Sisimai::Eb::ReFILT, # Not in the list Mail address management.
    };
    my $issuedcode = lc $argvs->{'diagnosticcode'};
    my $codenumber = index($issuedcode, '.i.ua/err/') > 0 ? substr($issuedcode, index($issuedcode, '/err/') + 5, 2) : 0;
       $codenumber = substr($codenumber, 0, 1) if index($codenumber, '/') == 1;
    return $errorcodes->{ $codenumber } || '';
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::IUA - Detect the bounce reason returned from https://www.i.ua/.

=head1 SYNOPSIS

    use Sisimai::Rhost::IUA;

=head1 DESCRIPTION

C<Sisimai::Rhost::IUA> detects the bounce reason from the content of C<Sisimai::Fact> object as an
argument of C<find()> method when the value of C<rhost> of the object is C<*.email.ua>.
This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2019-2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

