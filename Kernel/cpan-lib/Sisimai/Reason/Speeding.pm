package Sisimai::Reason::Speeding;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'speeding' }
sub description { 'Rejected due to exceeding a rate limit or sending too fast' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift // return undef;

    state $index = [
        'mail sent from your IP address has been temporarily rate limited',
        'please try again slower',
        'receiving mail at a rate that prevents additional messages from being delivered',
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Rejected due to exceeding a rate limit or sending too fast
    # @param    [Sisimai::Fact] argvs   Object to be detected the reason
    # @return   [Integer]               1: is speeding
    #                                   0: is not speeding
    # @see      http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;

    # Action: failed
    # Status: 4.7.1
    # Remote-MTA: dns; smtp.example.jp
    # Diagnostic-Code: smtp; 451 4.7.1 <mx.example.org[192.0.2.2]>: Client host rejected: Please try again slower
    return undef unless $argvs->{'deliverystatus'};
    return 1 if $argvs->{'reason'} eq 'speeding';
    return 1 if __PACKAGE__->match(lc $argvs->{'diagnosticcode'});
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Speeding - Bounce reason is C<speeding> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::Speeding;
    my $v = '451 4.7.1 <mx.example.jp[192.0.2.2]>: Client host rejected: Please try again slower';
    print Sisimai::Reason::Speeding->match($v); # 1

=head1 DESCRIPTION

Sisimai::Reason::Speeding checks the bounce reason is C<speeding> or not. This class is called only
Sisimai::Reason class. This is the error that a connection rejected due to exceeding a rate limit
or sending too fast.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<speeding>.

    print Sisimai::Reason::Speeding->text;  # speeding

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    my $v = '451 4.7.1 <mx.example.jp[192.0.2.2]>: Client host rejected: Please try again slower';
    print Sisimai::Reason::Speeding->match($v); # 1

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> returns 1 if the bounce reason is C<speeding>. The argument must be Sisimai::Fact object
and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2022 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

