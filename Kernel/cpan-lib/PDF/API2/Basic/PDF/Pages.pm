# Code in the PDF::API2::Basic::PDF namespace was originally copied from the
# Text::PDF distribution.
#
# Copyright Martin Hosken <Martin_Hosken@sil.org>
#
# Martin Hosken's code may be used under the terms of the MIT license.
# Subsequent versions of the code have the same license as PDF::API2.

package PDF::API2::Basic::PDF::Pages;

use strict;
use warnings;

use base 'PDF::API2::Basic::PDF::Dict';

our $VERSION = '2.045'; # VERSION

use PDF::API2::Basic::PDF::Array;
use PDF::API2::Basic::PDF::Dict;
use PDF::API2::Basic::PDF::Utils;

use Scalar::Util qw(weaken);

our %inst = map {$_ => 1} qw(Parent Type);

=head1 NAME

PDF::API2::Basic::PDF::Pages - Low-level page tree object

=head1 DESCRIPTION

A Pages object is the parent to other pages objects or to page objects
themselves.

=head1 METHODS

=head2 PDF::API2::Basic::PDF::Pages->new($pdf, $parent)

This creates a new Pages object in a PDF. Notice that $parent here is
not the file context for the object but the parent pages object for
this pages. If we are using this class to create a root node, then
$parent should point to the file context, which is identified by not
having a Type of Pages.  $pdf is the file object (or a reference to an
array of file objects) in which to create the new Pages object.

=cut

sub new {
    my ($class, $pdf, $parent) = @_;
    $pdf //= $class->get_top->{' parent'} if ref($class);

    # Prior to 2.034, $pdf could be an array of PDFs
    if (ref($pdf) eq 'ARRAY') {
        die 'Only one PDF is supported as of version 2.034' if scalar(@$pdf) > 1;
        ($pdf) = @$pdf;
    }

    $class = ref($class) if ref($class);
    my $self = $class->SUPER::new($pdf, $parent);

    $self->{'Type'} = PDFName('Pages');
    $self->{'Parent'} = $parent if defined $parent;
    $self->{'Count'} = PDFNum(0);
    $self->{'Kids'} = PDF::API2::Basic::PDF::Array->new();

    $pdf->new_obj($self);
    unless (defined $self->{'Parent'}) {
        $pdf->{'Root'}->{'Pages'} = $self;
        $pdf->out_obj($pdf->{'Root'});

        $self->{' parent'} = $pdf;
        weaken $self->{' parent'};
    }

    weaken $self->{'Parent'} if defined $parent;

    return $self;
}

sub _pdf {
    my $self = shift();
    return $self->get_top->{' parent'};
}

=head2 $p->find_page($page_number)

Returns the given page, using the page count values in the pages tree. Pages
start at 0.

=cut

sub find_page {
    my ($self, $page_number) = @_;
    my $top = $self->get_top();

    $top->find_page_recurse(\$page_number);
}


sub find_page_recurse {
    my ($self, $page_number_ref) = @_;

    if ($self->{'Count'}->realise->val() <= $$page_number_ref) {
        $$page_number_ref -= $self->{'Count'}->val();
        return;
    }

    my $result;
    foreach my $kid ($self->{'Kids'}->realise->elements()) {
        if ($kid->{'Type'}->realise->val() eq 'Page') {
            return $kid if $$page_number_ref == 0;
            $$page_number_ref--;
        }
        elsif ($result = $kid->realise->find_page_recurse($page_number_ref)) {
            return $result;
        }
    }

    return;
}

=head2 $p->add_page($page, $page_number)

Inserts the page before the given $page_number. $page_number can be negative to
count from the END of the document. -1 is after the last page. Likewise
$page_number can be greater than the number of pages currently in the document,
to append.

=cut

sub add_page {
    my ($self, $page, $page_number) = @_;
    my $top = $self->get_top();

    $page_number = -1 unless defined $page_number and $page_number <= $top->{'Count'}->val();

    my $previous_page;
    if ($page_number == -1) {
        $previous_page = $top->find_page($top->{'Count'}->val() - 1);
    }
    else {
        $page_number = $top->{'Count'}->val() + $page_number + 1 if $page_number < 0;
        $previous_page = $top->find_page($page_number);
    }

    my $parent;
    if (defined $previous_page->{'Parent'}) {
        $parent = $previous_page->{'Parent'}->realise();
    }
    else {
        $parent = $self;
    }

    my $parent_kid_count = scalar $parent->{'Kids'}->realise->elements();

    my $page_index;
    if ($page_number == -1) {
        $page_index = -1;
    }
    else {
        for ($page_index = 0; $page_index < $parent_kid_count; $page_index++) {
            last if $parent->{'Kids'}{' val'}[$page_index] eq $previous_page;
        }
        $page_index = -1 if $page_index == $parent_kid_count;
    }

    $parent->add_page_recurse($page->realise(), $page_index);
    for ($parent = $page->{'Parent'}; defined $parent->{'Parent'}; $parent = $parent->{'Parent'}->realise()) {
        $parent->set_modified();
        $parent->{'Count'}->realise->{'val'}++;
    }
    $parent->set_modified();
    $parent->{'Count'}->realise->{'val'}++;

    return $page;
}

sub add_page_recurse {
    my ($self, $page, $page_index) = @_;

    my $parent = $self;
    my $max_kids_per_parent = 8; # Why?
    if (scalar $parent->{'Kids'}->elements() >= $max_kids_per_parent and $parent->{'Parent'} and $page_index < 1) {
        my $grandparent = $parent->{'Parent'}->realise();
        $parent = $parent->new($parent->_pdf(), $grandparent);

        my $grandparent_kid_count = scalar $grandparent->{'Kids'}->realise->elements();
        my $new_parent_index;
        for ($new_parent_index = 0; $new_parent_index < $grandparent_kid_count; $new_parent_index++) {
            last if $grandparent->{'Kids'}{' val'}[$new_parent_index] eq $self;
        }
        $new_parent_index++;
        $new_parent_index = -1 if $new_parent_index > $grandparent_kid_count;
        $grandparent->add_page_recurse($parent, $new_parent_index);
    }
    else {
        $parent->set_modified();
    }

    if ($page_index < 0) {
        push @{$parent->{'Kids'}->realise->{' val'}}, $page;
    }
    else {
        splice @{$parent->{'Kids'}{' val'}}, $page_index, 0, $page;
    }
    $page->{'Parent'} = $parent;
    weaken $page->{'Parent'};
}

sub set_modified {
    my $self = shift();
    $self->_pdf->out_obj($self);
}

# Previously documented but not implemented
sub rebuild_tree { return; }

=head2 @objects = $p->get_pages()

Returns a list of page objects in the document in page order

=cut

sub get_pages {
    my $self = shift();
    return $self->get_top->get_pages_recurse();
}

# Renamed for clarity
sub get_kids { return get_pages_recurse(@_) }

sub get_pages_recurse {
    my $self = shift();
    my @pages;

    foreach my $kid ($self->{'Kids'}->elements()) {
        $kid->realise();
        if ($kid->{'Type'}->val() eq 'Pages') {
            push @pages, $kid->get_pages_recurse();
        }
        else {
            push @pages, $kid;
        }
    }

    return @pages;
}

=head2 $p->find_prop($key)

Searches up through the inheritance tree to find a property.

=cut

sub find_prop {
    my ($self, $prop) = @_;

    if (defined $self->{$prop}) {
        if (ref($self->{$prop}) and $self->{$prop}->isa('PDF::API2::Basic::PDF::Objind')) {
            return $self->{$prop}->realise();
        }
        else {
            return $self->{$prop};
        }
    }
    elsif (defined $self->{'Parent'}) {
        return $self->{'Parent'}->find_prop($prop);
    }

    return;
}


=head2 $p->add_font($pdf, $font)

Creates or edits the resource dictionary at this level in the hierarchy. If
the font is already supported even through the hierarchy, then it is not added.

=cut

sub add_font {
    # Maintainer's note: arguments are in a different order than what is shown in the POD
    my ($self, $font, $pdf) = @_;
    my $name = $font->{'Name'}->val();
    my $dict = $self->find_prop('Resources');

    return $self if $dict and defined $dict->{'Font'} and defined $dict->{'Font'}{$name};

    unless (defined $self->{'Resources'}) {
        $dict = $dict ? $dict->copy($pdf) : PDFDict();
        $self->{'Resources'} = $dict;
    }
    else {
        $dict = $self->{'Resources'};
    }
    $dict->{'Font'} //= PDFDict();

    my $resource = $dict->{'Font'}->val();
    $resource->{$name} //= $font;
    if (ref($dict) ne 'HASH' and $dict->is_obj($pdf)) {
        $pdf->out_obj($dict);
    }
    if (ref($resource) ne 'HASH' and $resource->is_obj($pdf)) {
        $pdf->out_obj($resource);
    }

    return $self;
}


=head2 $p->bbox($xmin, $ymin, $xmax, $ymax, [$param])

Specifies the bounding box for this and all child pages. If the values are
identical to those inherited then no change is made. $param specifies the attribute
name so that other 'bounding box'es can be set with this method.

=cut

sub bbox {
    my ($self, @bbox) = @_;
    my $key = $bbox[4] || 'MediaBox';
    my $inherited = $self->find_prop($key);

    if ($inherited) {
        my $is_changed;
        my $i = 0;
        foreach my $element ($inherited->elements()) {
            $is_changed = 1 unless $element->val() == $bbox[$i++];
        }
        return $self if $i == 4 and not $is_changed;
    }

    my $array = PDF::API2::Basic::PDF::Array->new();
    foreach my $element (@bbox[0..3]) {
        $array->add_elements(PDFNum($element));
    }
    $self->{$key} = $array;

    return $self;
}

=head2 $p->proc_set(@entries)

Ensures that the current resource contains all the entries in the proc_sets
listed. If necessary it creates a local resource dictionary to achieve this.

=cut

sub proc_set {
    my ($self, @entries) = @_;

    my $dict = $self->find_prop('Resources');
    if ($dict and defined $dict->{'ProcSet'}) {
        my @missing = @entries;
        foreach my $element ($dict->{'ProcSet'}->elements()) {
            @missing = grep { $_ ne $element } @missing;
        }
        return $self if scalar @missing == 0;
        @entries = @missing if defined $self->{'Resources'};
    }

    unless (defined $self->{'Resources'}) {
        $self->{'Resources'} = $dict ? $dict->copy($self->_pdf()) : PDFDict();
    }

    $self->{'Resources'}{'ProcSet'} = PDFArray() unless defined $self->{'ProcSet'};

    foreach my $e (@entries) {
        $self->{'Resources'}{'ProcSet'}->add_elements(PDFName($e));
    }

    return $self;
}

sub empty {
    my $self = shift();
    my $parent = $self->{'Parent'};

    $self->SUPER::empty();
    if (defined $parent) {
        $self->{'Parent'} = $parent;
        weaken $self->{'Parent'};
    }

    return $self;
}

=head2 $p->get_top

Returns the top of the pages tree

=cut

sub get_top {
    my $self = shift();

    my $top = $self;
    $top = $top->{'Parent'} while defined $top->{'Parent'};

    return $top->realise();
}

1;
