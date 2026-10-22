package Sisimai::SMTP::Command;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use constant ExceptDATA => [$Sisimai::Eb::CeCONN, $Sisimai::Eb::CeEHLO, $Sisimai::Eb::CeHELO,
                            $Sisimai::Eb::CeMAIL, $Sisimai::Eb::CeRCPT];
use constant BeforeRCPT => [$Sisimai::Eb::CeCONN, $Sisimai::Eb::CeEHLO, $Sisimai::Eb::CeHELO,
                            $Sisimai::Eb::CeMAIL, $Sisimai::Eb::CeAUTH, $Sisimai::Eb::CeTTLS];
state $Availables = [
    $Sisimai::Eb::CeHELO, $Sisimai::Eb::CeEHLO, $Sisimai::Eb::CeMAIL, $Sisimai::Eb::CeRCPT,
    $Sisimai::Eb::CeDATA, $Sisimai::Eb::CeQUIT, $Sisimai::Eb::CeRSET, $Sisimai::Eb::CeNOOP,
    $Sisimai::Eb::CeVRFY, $Sisimai::Eb::CeETRN, $Sisimai::Eb::CeEXPN, $Sisimai::Eb::CeHELP,
    $Sisimai::Eb::CeAUTH, $Sisimai::Eb::CeTTLS, $Sisimai::Eb::CeXFWD,
    $Sisimai::Eb::CeCONN, # CONN is a pseudo SMTP command used only in Sisimai
];
state $Detectable = [
    $Sisimai::Eb::CeHELO, $Sisimai::Eb::CeEHLO, $Sisimai::Eb::CeTTLS, "AUTH PLAIN", "AUTH LOGIN",
    "AUTH CRAM-", "AUTH DIGEST-", "MAIL F", $Sisimai::Eb::CeRCPT, "RCPT T", $Sisimai::Eb::CeDATA,
    $Sisimai::Eb::CeQUIT, $Sisimai::Eb::CeXFWD,
];

sub test {
    # Check that an SMTP command in the argument is valid or not
    # @param    [String] argv0  An SMTP command
    # @return   [Boolean]       0: Is not a valid SMTP command, 1: Is a valid SMTP command
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift // return 0; return 0 unless length $argv0 > 3;
    return 1 if grep { index($argv0, $_) > -1 } @$Availables;
    return 0;
}

sub find {
    # Pick an SMTP command from the given string
    # @param    [String] argv0  A transcript text MTA returned
    # @return   [String]        An SMTP command
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift // return ""; return "" unless __PACKAGE__->test($argv0);

    my $issuedcode = ' '.lc($argv0).' ';
    my $commandmap = {'STAR' => $Sisimai::Eb::CeTTLS, 'XFOR' => $Sisimai::Eb::CeXFWD};
    my $commandset = [];

    for my $e ( @$Detectable ) {
        # Find an SMTP command from the given string
        my $p0 = index($argv0, $e); next if $p0 < 0;
        if( index($e, " ") < 0 ) {
            # For example, "RCPT T" does not appear in an email address or a domain name
            my $cx = 1; while(1) {
                # Exclude an SMTP command in the part of an email address, a domain name, such as
                # DATABASE@EXAMPLE.JP, EMAIL.EXAMPLE.COM, and so on.
                my $ca = ord(substr($issuedcode, $p0, 1));
                my $cz = ord(substr($issuedcode, $p0 + length($e) + 1, 1));

                last if $ca > 47 && $ca <  58 || $cz > 47 && $cz <  58; # 0-9
                last if $ca > 63 && $ca <  91 || $cz > 63 && $cz <  91; # @-Z
                last if $ca > 96 && $ca < 123 || $cz > 96 && $cz < 123; # `-z
                $cx = 0; last;
            }
            next if $cx == 1;
        }

        # There is the same command in the "commanset" or nor
        my $cv = substr($e, 0, 4); next if grep { index($cv, $_) == 0 } @$commandset;
           $cv = $commandmap->{ $cv } if exists $commandmap->{ $cv };
        push @$commandset, $cv;
    }
    return "" unless scalar @$commandset;
    return pop @$commandset;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::SMTP::Command - SMTP Command related utilities

=head1 SYNOPSIS

    use Sisimai::SMTP::Command;
    Sisimai::SMTP::Command->find('in reply to RCPT TO command');  # RCPT

=head1 DESCRIPTION

C<Sisimai::SMTP::Command> is a class for finding the last SMTP command from given error message.

=head1 CLASS METHODS

=head2 C<B<test(I<String>)>>

C<test()> method checks whether the SMTP command is a valid command or not

    print Sisimai::SMTP::Command->test('STARTTLS'); # 1
    print Sisimai::SMTP::Command->test('NEKO');     # 0

=head2 C<B<find(I<String>)>>

C<find()> method returns the last SMTP command like the following:

    print Sisimai::SMTP::Command->find('MAIL FROM: <> 250 OK RCPT TO: <...> 550');  # "RCPT"

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2022-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

