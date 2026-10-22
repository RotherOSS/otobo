package Sisimai::Reason::EmailTooLarge;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReSIZE }
sub description { 'Email rejected due to an email size is too big for a destination mail server' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        "exceeds the maximum size ",
        "line limit exceeded",
        "message too large",
        "size limit",
        "taille limite du message atteinte",
    ];
    state $pairs = [
        ["exceeded", "message size"],
        ["message ", "exceeds ", "limit"],
        ["message ", "size", "exceed"],
        ["message ", "too", "big"],
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # The message size is too big for the remote host
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is too big message size
    #                                   0: is not big
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0; return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReSIZE;

    my $statuscode = $argvs->{'deliverystatus'} // '';
    my $tempreason = Sisimai::SMTP::Status->name($statuscode) || '';

    # Delivery status code points "EmailTooLarge".
    # Status: 5.3.4
    # Diagnostic-Code: SMTP; 552 5.3.4 Error: message file too big
    #
    # Status: 5.2.3
    # Diagnostic-Code: Message length exceeds administrative limit
    return 1 if $tempreason eq $Sisimai::Eb::ReSIZE;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::EmailTooLarge - Bounce reason is C<EmailTooLarge> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::EmailTooLarge;
    print Sisimai::Reason::EmailTooLarge->match('400 Message too big');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::EmailTooLarge> checks the bounce reason is C<EmailTooLarge> or not. This class is
called only C<Sisimai::Reason> class.

This is the error that the sent email size is too big for the destination mail server. In many case,
There are many attachment files with the email, or the file size is too large. Sisimai will set
C<EmailTooLarge> to the reason of the email bounce if the value of C<Status:> field in the bounce
email is C<5.2.3> or C<5.3.4>.

    Action: failed
    Status: 553 Exceeded maximum inbound message size

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<EmailTooLarge>.

    print Sisimai::Reason::EmailTooLarge->text;  # EmailTooLarge

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    print Sisimai::Reason::EmailTooLarge->match('400 Message too big');   # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<EmailTooLarge>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

