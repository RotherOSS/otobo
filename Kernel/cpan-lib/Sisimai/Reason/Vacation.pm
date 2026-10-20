package Sisimai::Reason::Vacation;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::ReAWAY }
sub description { 'Email replied automatically due to a recipient is out of office' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.22.3
    my $class = shift;
    my $argv1 = shift // return 0;

    state $index = [
        'i am away on vacation',
        'i am away until',
        'i am out of the office',
        'i will be traveling for work on',
    ];
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}
sub true  { return 0 }
1;

__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Vacation - the recipient is out of the office

=head1 SYNOPSIS

    use Sisimai::Reason::Vacation;
    print Sisimai::Reason::Vacation->text; # Vacation

=head1 DESCRIPTION

C<Sisimai::Reason::Vacation> is for only returning the text and the description.
This class is called only from C<Sisimai->reason()> method.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<Vacation>.

    print Sisimai::Reason::Vacation->text;  # Vacation

=head2 C<B<match(I<string>)>>

C<match()> method always return C<0>

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method always return C<0>

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

