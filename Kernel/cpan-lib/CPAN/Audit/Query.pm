package CPAN::Audit::Query;
use strict;
use warnings;
use CPAN::Audit::Version;

our $VERSION = "1.001";

=encoding utf8

=head1 NAME

CPAN::Audit::Query - filter the database for advisories that interest you

=head1 SYNOPSIS

	use CPAN::Audit::Query;

	my $query = CPAN::Audit::Query->new( db => ... );
	my @advisories = $query->advisories_for( $dist_name, $version_range );

=head1 DESCRIPTION

=head2 Class methods

=over 4

=item * new(HASH)

The only parameter is the hash reference from L<CPAN::Audit::DB> or
L<CPANSA::DB>. With no C<db> parameter, it uses the empty hash, which
means that you'll find no advisories.

=cut

sub new {
	my($class, %params) = @_;
	$params{db} ||= {};
	my $self = bless {}, $class;
	$self->{db} = $params{db};
	return $self;
	}

=back

=head2 Instance methods

=over 4

=item * advisories_for( DISTNAME, VERSION_RANGE )

Returns a list of advisories for DISTNAME in VERSION_RANGE.

	my @advisories = $query->advisories_for( 'Business::ISBN', '1.23' );

	my @advisories = $query->advisories_for( 'Business::ISBN', '>1.23,<2.45' );

	my @advisories = $query->advisories_for( 'Business::ISBN', '<1.23' );

=cut

sub advisories_for {
	my( $self, $distname, $dist_version_range ) = @_;

	$dist_version_range = '>0' unless
		defined $dist_version_range && 0 < length $dist_version_range;

	my $dist = $self->{db}->{dists}->{$distname};
	return unless $dist;

	# select only the known distribution versions from the database,
	# ignoring all others. For example, if $dist_version_range is
	# ">5.1", we don't care about any versions less than or equal to 5.1.
	# If $dist_version_range is "5.1", that really means ">=5.1"
	my %advisories =
		map { $_->{id}, $_ }
		map	 {
			my $dist_version = $_;
			grep {
				my $affected = _includes( $_->{affected_versions}, $dist_version );
				my $f = $_->{fixed_versions};
				if( exists $_->{fixed_versions} and defined $f and length $f ) {
					my $fixed = _includes( $f, $dist_version );
					$fixed ? 0 : $affected
					}
				else { $affected }
				} @{ $dist->{advisories} };
		}
		grep { CPAN::Audit::Version->in_range( $_, $dist_version_range ) }
		map	 { $_->{version}}
		@{ $dist->{versions} };

	values %advisories;
}

sub _includes {
	my( $range, $version ) = @_;
	$range = [$range] unless ref $range;
	my $rc = 0;
	foreach my $r ( @$range ) {
		no warnings 'uninitialized';
	    $rc += CPAN::Audit::Version->in_range( $version, $r );
		}
	return $rc;
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
