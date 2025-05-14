use v5.10;

package CPAN::Audit::Filter;
use strict;
use warnings;

our $VERSION = "1.001";

=encoding utf8

=head1 NAME

CPAN::Audit::Filter - manage the reports / CVEs to ignore

=head1 SYNOPSIS

	use CPAN::Audit::Filter;

	my $filter = CPAN::Audit::Filter->new( exclude => $array_ref );

	my $query = CPAN::Audit::Query->new(...);
	my $advisories = $query->advisories_for( $distname, $version_range );

	foreach my $advisory ( $advisories->@* ) {
		next if $filter->excludes($advisory);
		...
	}

=head1 DESCRIPTION

=head2 Class methods

=over 4

=item * new( exclude => ARRAYREF )

The values in the array ref for C<exclude> are uppercased before
they are stored.

=cut

sub new {
	my($class, %params) = @_;

	my $self = bless {}, $class;
	$params{exclude} //= [];

	my %excludes = map { uc($_) => 1 } @{ $params{exclude} };
	$self->{excludes} = \%excludes;

	$self->{ignored} = {};

	return $self;
}


=back

=head2 Instance methods

=over 4

=item * excludes( $advisory )

Returns true if this instance excludes either the ID or any of the
CVEs for ADVISORY, a hash as returned by L<CPAN::Audit::Query>. This
hash has these keys:

	id	 - a string, such as Some-Module-001
	cves - an array reference of CVE strings, such as CVE-2022-001

The values extracted from the hash are uppercased before use.

=cut

sub excludes {
	my($self, $advisory) = @_;

	return 0 unless keys %{$self->{excludes}};

	my @ids = map { uc } grep { defined } ($advisory->{id}, @{$advisory->{cves}});

	foreach my $id ( @ids ) {
		next unless $self->{excludes}{$id};
		$self->{ignored}{$id}++;
		return 1;
	}

	return 0;
}

=item * ignored_count

Return the count of the advisories that were ignored. Each ID or CVE
value only counts once.

=cut

sub ignored_count { scalar keys %{$_[0]->{ignored}} }

=back

=head1 LICENSE

Copyright (C) 2022 Graham TerMarsch

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
