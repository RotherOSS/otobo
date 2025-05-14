# Code in the PDF::API2::Basic::PDF namespace was originally copied from the
# Text::PDF distribution.
#
# Copyright Martin Hosken <Martin_Hosken@sil.org>
#
# Martin Hosken's code may be used under the terms of the MIT license.
# Subsequent versions of the code have the same license as PDF::API2.

package PDF::API2::Basic::PDF::Array;

use base 'PDF::API2::Basic::PDF::Objind';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Array - Low-level PDF array object

=head1 METHODS

=head2 PDF::Array->new($parent, @values)

Creates an array with the given storage parent and an optional list of values to
initialise the array with.

=cut

sub new {
    my ($class, @values) = @_;
    my $self = {};

    $self->{' val'} = [@values];
    $self->{' realised'} = 1;

    bless $self, $class;
    return $self;
}

=head2 $a->outobjdeep($fh, $pdf)

Outputs an array as a PDF array to the given filehandle.

=cut

sub outobjdeep {
    my ($self, $fh, $pdf) = @_;

    $fh->print('[ ');
    foreach my $obj (@{$self->{' val'}}) {
        $obj->outobj($fh, $pdf);
        $fh->print(' ');
    }
    $fh->print(']');
}

=head2 $a->elements()

Returns the contents of the array.

=cut

sub elementsof { return elements(@_) }

sub elements {
    my $self = shift();
    return @{$self->{' val'}};
}

=head2 $a->add_elements(@elements)

Appends the given elements to the array. An element is only added if it
is defined.

=cut

sub add_elements {
    my $self = shift();

    foreach my $element (@_) {
        next unless defined $element;
        push @{$self->{' val'}}, $element;
    }

    return $self;
}

=head2 $a->remove_element($element)

Removes all occurrences of an element from an array.

=cut

sub removeobj { return remove_element(@_) }

sub remove_element {
    my ($self, $element) = @_;

    $self->{' val'} = [ grep { $_ ne $element } @{$self->{' val'}} ];
}

=head2 $a->val()

Returns a reference to the contents of the array.

=cut

sub val {
    return $_[0]->{' val'};
}

=head2 $a->copy($pdf)

Copies the array with deep-copy on elements which are not full PDF objects
with respect to a particular $pdf output context

=cut

sub copy {
    my ($self, $pdf) = @_;
    my $res = $self->SUPER::copy($pdf);

    $res->{' val'} = [];
    foreach my $e (@{$self->{' val'}}) {
        if (ref($e) and $e->can('is_obj') and not $e->is_obj($pdf)) {
            push(@{$res->{' val'}}, $e->copy($pdf));
        }
        else {
            push(@{$res->{' val'}}, $e);
        }
    }
    return $res;
}

1;
