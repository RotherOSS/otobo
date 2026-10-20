package Sisimai::Reason::SyntaxError;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'syntaxerror' }
sub description { 'Email rejected due to syntax error at sent commands in SMTP session' }
sub match { return undef }
sub true {
    # Connection rejected due to syntax error or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: Rejected due to syntax error
    #                                   0: is not syntax error
    # @since v4.1.25
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;
    my $reply = int($argvs->{'replycode'} || 0);

    return 1 if $argvs->{'reason'} eq 'syntaxerror';
    return 1 if $reply > 400 && $reply < 408;
    return 1 if $reply > 500 && $reply < 508;
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SyntaxError - Bounce reason is C<syntaxerror> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SyntaxError;
    print Sisimai::Reason::SyntaxError->text;   # syntaxerror

=head1 DESCRIPTION

Sisimai::Reason::SyntaxError checks the bounce reason is C<syntaxerror> or not. This class is called
only Sisimai::Reason class.

This is the error that a destination mail server could not recognize SMTP command which is sent from
a sender's MTA. Sisimai will set C<syntaxerror> to the reason if the value of C<replycode> begins
with "50" such as 502, or 503.

    Action: failed
    Status: 5.5.0
    Diagnostic-Code: SMTP; 503 Improper sequence of commands

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<syntaxerror>.

    print Sisimai::Reason::SyntaxError->text;  # syntaxerror

=head2 C<B<match(I<string>)>>

C<match()> always return undef

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> returns 1 if the bounce reason is C<syntaxerror>. The argument must be Sisimai::Fact object
and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016,2018,2020,2021 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
