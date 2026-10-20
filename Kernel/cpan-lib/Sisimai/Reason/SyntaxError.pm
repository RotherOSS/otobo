package Sisimai::Reason::SyntaxError;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReCOMM }
sub description { 'Email rejected due to syntax error at sent commands in SMTP session' }
sub match { return 0 }
sub true  { return 0 }

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SyntaxError - Bounce reason is C<SyntaxError> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SyntaxError;
    print Sisimai::Reason::SyntaxError->text;   # SyntaxError

=head1 DESCRIPTION

C<Sisimai::Reason::SyntaxError> checks the bounce reason is C<SyntaxError> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the destination mail server could not recognize the SMTP command which is sent
from the sender's MTA. Sisimai will set C<SyntaxError> to the reason if the value of C<replycode>
begins with C<50> such as C<502>, or C<503>.

    Action: failed
    Status: 5.5.0
    Diagnostic-Code: SMTP; 503 Improper sequence of commands

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<SyntaxError>.

    print Sisimai::Reason::SyntaxError->text;  # SyntaxError

=head2 C<B<match(I<string>)>>

C<match()> method always return C<0>

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<SyntaxError>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016,2018,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

