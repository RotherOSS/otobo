package Sisimai::SMTP::Failure;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::SMTP::Reply;
use Sisimai::SMTP::Status;

sub is_permanent {
    # Returns true if the given string indicates a permanent error
    # @param    [String] argv1  String including SMTP Status code
    # @return   [Integer]       1:     Is a permanet error
    #                           0:     Is not a permanent error
    # @since v4.17.3
    my $class = shift;
    my $argv1 = shift || return 0;

    my $statuscode   = Sisimai::SMTP::Status->find($argv1);
       $statuscode ||= Sisimai::SMTP::Reply->find($argv1) || '';

    return 1 if substr($statuscode, 0, 1) eq "5";
    return 1 if index(lc $argv1, " permanent ") > -1;
    return 0;
}

sub is_temporary {
    # Returns true if the given string indicates a temporary error
    # @param    [String] argv1  String including SMTP Status code
    # @return   [Integer]       1:     Is a temporary error
    #                           0:     Is not a temporary error
    # @since v5.2.0
    my $class = shift;
    my $argv1 = shift || return 0;

    my $statuscode   = Sisimai::SMTP::Status->find($argv1);
       $statuscode ||= Sisimai::SMTP::Reply->find($argv1) || '';
    my $issuedcode   = lc $argv1;

    return 1 if substr($statuscode, 0, 1) eq "4";
    return 1 if index($issuedcode, " temporar")   > -1;
    return 1 if index($issuedcode, " persistent") > -1;
    return 0;
}

sub is_hardbounce {
    # Checks the reason sisimai detected is a hard bounce or not
    # @param   [String] argv1  The bounce reason sisimai detected
    # @param   [String] argv2  String including SMTP Status code
    # @return  [Bool]          1: is a hard bounce
    # @since v5.2.0
    my $class = shift;
    my $argv1 = shift || return 0;
    my $argv2 = shift // '';

    return 0 if $argv1 eq $Sisimai::Eb::Re___0 || $argv1 eq $Sisimai::Eb::Re___1;
    return 0 if $argv1 eq $Sisimai::Eb::ReSENT || $argv1 eq $Sisimai::Eb::ReFEED || $argv1 eq $Sisimai::Eb::ReAWAY;
    return 1 if $argv1 eq $Sisimai::Eb::ReMOVE || $argv1 eq $Sisimai::Eb::ReUSER || $argv1 eq $Sisimai::Eb::ReHOST;
    return 0 if $argv1 ne $Sisimai::Eb::Re00MX;

    # NotAccept: 5xx => hard bounce, 4xx => soft bounce
    my $hardbounce = 0;
    if( length $argv2 > 0 ) {
        # Check the 2nd argument(a status code or a reply code)
        my $cv = Sisimai::SMTP::Status->find($argv2, "") || Sisimai::SMTP::Reply->find($argv2, "") || '';
        if( substr($cv, 0, 1) eq "5" ) {
            # The SMTP status code or the SMTP reply code starts with "5"
            $hardbounce = 1 

        } else {
            # Deal as a hard bounce when the error message does not indicate a temporary error
            $hardbounce = 1 unless __PACKAGE__->is_temporary($argv2);
        }
    } else {
        # Deal "NotAccept" as a hard bounce when the 2nd argument is empty
        $hardbounce = 1;
    }
    return $hardbounce;
}

sub is_softbounce {
    # Checks the reason sisimai detected is a soft bounce or not
    # @param   [String] argv1  The bounce reason sisimai detected
    # @param   [String] argv2  String including SMTP Status code
    # @return  [Bool]          1: is a soft bounce
    # @since v5.2.0
    my $class = shift;
    my $argv1 = shift || return 0;
    my $argv2 = shift // '';

    return 0 if $argv1 eq $Sisimai::Eb::ReSENT || $argv1 eq $Sisimai::Eb::ReFEED || $argv1 eq $Sisimai::Eb::ReAWAY;
    return 0 if $argv1 eq $Sisimai::Eb::ReMOVE || $argv1 eq $Sisimai::Eb::ReUSER || $argv1 eq $Sisimai::Eb::ReHOST;
    return 1 if $argv1 eq $Sisimai::Eb::Re___0 || $argv1 eq $Sisimai::Eb::Re___1;
    return 1 if $argv1 ne $Sisimai::Eb::Re00MX;

    # NotAccept: 5xx => hard bounce, 4xx => soft bounce
    my $softbounce = 0;
    if( length $argv2 > 0 ) {
        # Check the 2nd argument(a status code or a reply code)
        my $cv = Sisimai::SMTP::Status->find($argv2, "") || Sisimai::SMTP::Reply->find($argv2, "") || '';
        $softbounce = 1 if substr($cv, 0, 1) eq "4";
    }
    return $softbounce;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::SMTP::Failure - SMTP Errors related utilities

=head1 SYNOPSIS

    use Sisimai::SMTP::Failure;
    print Sisimai::SMTP::Failure->is_temporary('421 SMTP error message');
    print Sisimai::SMTP::Failure->is_permanent('550 SMTP error message');
    print Sisimai::SMTP::Failure->is_softbounce('MailboxFull', 4.2.2 mailbox full');
    print Sisimai::SMTP::Failure->is_hardbounce('UserUnknown', 5.1.1 user not found');

=head1 DESCRIPTION

C<Sisimai::SMTP::Failure> provide methods to check an SMTP errors.

=head1 CLASS METHODS

=head2 C<B<is_permanent(I<String>)>>

C<is_permanent()> method checks the given string points an permanent error or not.

    print Sisimai::SMTP::Failure->is_permanent('5.1.1 User unknown'); # 1
    print Sisimai::SMTP::Failure->is_permanent('4.2.2 Mailbox Full'); # 0
    print Sisimai::SMTP::Failure->is_permanent('2.1.5 Message Sent'); # 0

=head2 C<B<is_temporary(I<String>)>>

C<is_temporary()> method checks the given string points an temporary error or not.

    print Sisimai::SMTP::Failure->is_permanent('5.1.1 User unknown'); # 0
    print Sisimai::SMTP::Failure->is_permanent('4.2.2 Mailbox Full'); # 1
    print Sisimai::SMTP::Failure->is_permanent('2.1.5 Message Sent'); # 0

=head2 C<B<is_hardbounce(I<String>, I<String>)>>

C<is_hardbounce()> method checks the given reason is a hard bounce or not

    print Sisimai::SMTP::Failure->is_hardbounce('5.1.1 User unknown'); # 1
    print Sisimai::SMTP::Failure->is_hardbounce('4.2.2 Mailbox Full'); # 0
    print Sisimai::SMTP::Failure->is_hardbounce('5.7.27 DKIM failed'); # 0

C<is_softbounce()> method checks the given reason is a soft bounce or not

    print Sisimai::SMTP::Failure->is_softbounce('5.1.1 User unknown'); # 0
    print Sisimai::SMTP::Failure->is_softbounce('4.2.2 Mailbox Full'); # 1
    print Sisimai::SMTP::Failure->is_softbounce('5.7.27 DKIM failed'); # 1

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018,2020-2022,2024,2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

