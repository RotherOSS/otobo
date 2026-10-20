package Sisimai::Time;
use parent 'Time::Piece';
use v5.26;
use strict;
use warnings;

sub TO_JSON {
    # Instance method for JSON::encode()
    # @return   [Integer] Machine time
    my $self = shift;
    return $self->epoch;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Time - Child class of C<Time::Piece> for C<Sisimai::Fact>

=head1 SYNOPSIS

    use Sisimai::Time;
    my $v = Sisimai::Time->new;

=head1 DESCRIPTION

C<Sisimai::Time> is a child class of C<Time::Piece> for C<Sisimai::Fact>.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015,2020 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

