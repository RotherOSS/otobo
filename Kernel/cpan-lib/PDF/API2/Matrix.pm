package PDF::API2::Matrix;

use strict;

use Carp;

our $VERSION = '2.045'; # VERSION

sub new {
    my $type = shift();
    my $self = [];
    my $col_count = scalar(@{$_[0]});
    foreach my $row (@_) {
        unless (scalar(@$row) == $col_count) {
            carp 'Inconsistent column count in matrix';
            return;
        }
        push @$self, [@$row];
    }

    return bless($self, $type);
}

sub transpose {
    my $self = shift();
    my @result;
    my $m;

    for my $col (@{$self->[0]}) {
        push @result, [];
    }
    for my $row (@$self) {
        $m = 0;
        for my $col (@$row) {
            push @{$result[$m++]}, $col;
        }
    }

    return PDF::API2::Matrix->new(@result);
}

sub vector_product {
    my ($a, $b) = @_;
    my $result = 0;

    for my $i (0 .. $#{$a}) {
        $result += $a->[$i] * $b->[$i];
    }

    return $result;
}

sub multiply {
    my $self  = shift();
    my $other = shift->transpose();
    my @result;

    unless ($#{$self->[0]} == $#{$other->[0]}) {
        carp 'Mismatched dimensions in matrix multiplication';
        return;
    }
    for my $row (@$self) {
        my $result_col = [];
        for my $col (@$other) {
            push @$result_col, vector_product($row, $col);
        }
        push @result, $result_col;
    }

    return PDF::API2::Matrix->new(@result);
}

1;
