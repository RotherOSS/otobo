package Sisimai::Reason::VirusDetected;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::SMTP::Command;

sub text  { $Sisimai::Eb::ReEXEC }
sub description { 'Email rejected due to a virus scanner on a destination host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.22.0
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = ["it has a potentially executable attachment"];
    state $pairs = [
        ["message was ", "ected", " virus"],
        ["virus", " detected"],
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 1 if grep { Sisimai::String->aligned(\$argv1, $_) } @$pairs;
    return 0;
}

sub true {
    # The bounce reason is "VirusDetected" or not
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: virus detected
    #                                   0: virus was not detected
    # @since v4.22.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return 0;

    # The value of "reason" isn't "VirusDetected" when the value of "command" is an SMTP command to
    # be sent before the SMTP DATA command because all the MTAs read the headers and the entire
    # message body after the DATA command.
    return 1 if $argvs->{'reason'} eq $Sisimai::Eb::ReEXEC;
    return 0 if grep { $argvs->{'command'} eq $_ } Sisimai::SMTP::Command->ExceptDATA->@*;
    return __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::VirusDetected - Bounce reason is C<VirusdEtected> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::VirusDetected;
    print Sisimai::Reason::VirusDetected->match('5.7.1 Email not accept');   # 1

=head1 DESCRIPTION

C<Sisimai::Reason::VirusDetected> checks the bounce reason is C<VirusDetected> or not.
This class is called only C<Sisimai::Reason> class.

This is an error that any virus or trojan horse detected in the message by the virus scanner program
at the destination mail server. This reason has been divided from C<securityerror> at Sisimai 4.22.0.

    Your message was infected with a virus. You should download a virus
    scanner and check your computer for viruses.

    Sender:    <sironeko@libsisimai.org>
    Recipient: <kijitora@example.jp>

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<VirusDetected>.

    print Sisimai::Reason::VirusDetected->text;  # VirusDetected

=head2 C<B<match(I<string>)>>

C<match()> method returns C<1> if the argument matched with patterns defined in this class.

    my $v = 'Your message was infected with a virus. ...';
    print Sisimai::Reason::VirusDetected->match($v);    # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method returns C<1> if the bounce reason is C<VirusDetected>. The argument must be
C<Sisimai::Fact> object and this method is called only from C<Sisimai::Reason> class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

