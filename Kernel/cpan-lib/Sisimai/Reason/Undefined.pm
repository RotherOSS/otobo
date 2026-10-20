package Sisimai::Reason::Undefined;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

sub text  { $Sisimai::Eb::Re___0 }
sub description { 'Sisimai could not detect an error reason' }
sub match { return 0 }
sub true  { return 0 }
1;

__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Undefined - Sisimai could not detect the error reason.

=head1 SYNOPSIS

    use Sisimai::Reason::Undefined;
    print Sisimai::Reason::Undefined->text; # Undefined

=head1 DESCRIPTION

C<Sisimai::Reason::Undefined> is for only returning the text and the description.
This class is called only from C<Sisimai->reason()> method.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> method returns the fixed string C<Undefined>.

    print Sisimai::Reason::Undefined->text;  # Undefined

=head2 C<B<match(I<string>)>>

C<match()> method always return C<0>

=head2 C<B<true(I<Sisimai::Fact>)>>

C<true()> method always return C<0>

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016,2020,2021,2024-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

