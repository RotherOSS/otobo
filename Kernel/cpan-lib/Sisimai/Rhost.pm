package Sisimai::Rhost;
use feature ':5.10';
use strict;
use warnings;

state $RhostClass = {
    'Cox'       => ['cox.net'],
    'FrancePTT' => ['.laposte.net', '.orange.fr', '.wanadoo.fr'],
    'GoDaddy'   => ['smtp.secureserver.net', 'mailstore1.secureserver.net'],
    'Google'    => ['aspmx.l.google.com', 'gmail-smtp-in.l.google.com'],
    'IUA'       => ['.email.ua'],
    'KDDI'      => ['.ezweb.ne.jp', 'msmx.au.com'],
    'Microsoft' => ['.prod.outlook.com', '.protection.outlook.com'],
    'Mimecast'  => ['.mimecast.com'],
    'NTTDOCOMO' => ['mfsmax.docomo.ne.jp'],
    'Spectrum'  => ['charter.net'],
    'Tencent'   => ['.qq.com'],
};

sub match {
    # The value of "rhost" is listed in RhostClass or not
    # @param    [String] argv1  Remote host name
    # @return   [Integer]       0: did not match
    #                           1: match
    my $class = shift;
    my $rhost = shift // return undef;
    my $host0 = lc($rhost) || return 0;
    my $match = 0;

    for my $e ( keys %$RhostClass ) {
        # Try to match with each key of RhostClass
        next unless grep { index($host0, $_) > -1 } $RhostClass->{ $e }->@*;
        $match = 1;
        last;
    }
    return $match;
}

sub get {
    # Detect the bounce reason from certain remote hosts
    # @param    [Sisimai::Fact] argvs   Parsed email object
    # @param    [String]        proxy   The alternative of the "rhost"
    # @return   [String]                The value of bounce reason
    my $class = shift;
    my $argvs = shift || return undef;
    my $proxy = shift || undef;

    my $remotehost = $proxy || lc $argvs->{'rhost'};
    my $rhostclass = '';

    for my $e ( keys %$RhostClass ) {
        # Try to match with each key of RhostClass
        next unless grep { index($remotehost, $_) > -1 } $RhostClass->{ $e }->@*;
        $rhostclass = __PACKAGE__.'::'.$e;
        last;
    }
    return undef unless $rhostclass;

    (my $modulepath = $rhostclass) =~ s|::|/|g;
    require $modulepath.'.pm';
    return $rhostclass->get($argvs);
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost - Detect the bounce reason returned from certain remote hosts.

=head1 SYNOPSIS

    use Sisimai::Rhost;

=head1 DESCRIPTION

Sisimai::Rhost detects the bounce reason from the content of Sisimai::Fact object as an argument of
get() method when the value of C<rhost> of the object is listed in $RhostClass variable. This class
is called only Sisimai::Fact class.

=head1 CLASS METHODS

=head2 C<B<match(I<remote host>)>>

Returns 1 if the remote host is listed in $RhostClass variable.

=head2 C<B<get(I<Sisimai::Fact Object>)>>

C<get()> detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2020,2022,2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

