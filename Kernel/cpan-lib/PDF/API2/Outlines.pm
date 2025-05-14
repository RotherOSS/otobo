package PDF::API2::Outlines;

use base 'PDF::API2::Outline';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Basic::PDF::Utils;

sub new {
    my ($class, $api) = @_;
    my $self = $class->SUPER::new($api);
    $self->{'Type'} = PDFName('Outlines');

    return $self;
}

sub count {
    my $self = shift();
    return abs($self->SUPER::count());
}

1;
