package CPAN::Audit::Version;
use strict;
use warnings;
use version;

our $VERSION = "1.002";

=encoding utf8

=head1 NAME

CPAN::Audit::Version - the infrastructure to compare versions and version ranges

=head1 SYNOPSIS

	use CPAN::Audit::Version;

	my $cav = CPAN::Audit::Version->new;

	$cav->in_range( $version, $range );

=head1 DESCRIPTION

=head2 Class methods

=over 4

=item * new

Create a new object. This ignores all arguments.

=cut

sub new {
	my $class = shift;

	my $self = {};
	bless $self, $class;

	return $self;
}

=back

=head2 Instance methods

=over 4

=item * affected_versions( ARRAY_REF, RANGE )

Given an array reference of versions, return a list of all of the
versions in ARRAY_REF that are in RANGE. This is really a filter
on ARRAY_REF using the values for which C<in_range> returns true.

	my @matching = $cav->affected_versions( \@versions, $range );

=cut

BEGIN {
use version;
my $ops = {
	'<'	 => sub { $_[0] <  0 },
	'<=' => sub { $_[0] <= 0 },
	'==' => sub { $_[0] == 0 },
	'>'	 => sub { $_[0] >  0 },
	'>=' => sub { $_[0] >= 0 },
	'!=' => sub { $_[0] != 0 },
	};

sub affected_versions {
	my( $self, $available_versions, $range ) = @_;

	my @affected_versions;
	foreach my $version (@$available_versions) {
		if ( $self->in_range( $version, $range ) ) {
			push @affected_versions, $version;
		}
	}

	return @affected_versions;
}

=item * in_range( VERSION, RANGE )

Returns true if VERSION is contained in RANGE, and false otherwise.
VERSION is any sort of Perl, such as C<1.23> or C<1.2.3>. The RANGE
is a comma-separated list of range specifications using the comparators
C<< < >>, C<< <= >>, C<< == >>, C<< > >>, C<< >= >>, or C<< != >>. For
example, C<< >=1.23,<1.45 >>, C<< ==1.23 >>, or C<< >1.23 >>.

	my $version = 5.67;
	my $range = '>=5,<6'; # so, all the versions in 5.x

	if( $cav->in_range( $version, $range ) ) {
		say "$version is within $range";
		}
	else {
		say "$version is not within $range";
	}

=cut

sub in_range {
	my( $self, $version, $range ) = @_;
	my( @original ) = ($version, $range);
	return unless defined $version && defined $range;
	return unless defined( $version = eval { version->parse($version) } );

	my @ands = split /\s*,\s*/, $range;
	my $result = 1;

	foreach my $and (@ands) {
		my( $op, $range_version ) = $and =~ m/^(<=|<|>=|>|==|!=)?\s*([^\s]+)$/;

		return
		  unless defined( $range_version = eval { version->parse($range_version) } );

		$op = '>=' unless defined $op;
		unless( exists $ops->{$op} ) { $result = 0; last; }

		no warnings qw(numeric);
		$result = $ops->{$op}->( version::vcmp($version, $range_version) );
		last if $result == 0;
		}

	return $result;
	}
}

=back

=head1 LICENSE

Copyright (C) Viacheslav Tykhanovskyi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Viacheslav Tykhanovskyi E<lt>viacheslav.t@gmail.comE<gt>

=cut


1;
