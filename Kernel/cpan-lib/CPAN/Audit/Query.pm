package CPAN::Audit::Query;
use strict;
use warnings;
use CPAN::Audit::Version;

our $VERSION = "1.001";

sub new {
	my($class, %params) = @_;
	$params{db} ||= {};
	my $self = bless {}, $class;
	$self->{db} = $params{db};
	return $self;
	}

=item * advisories_for( DISTNAME, VERSION_RANGE )


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
	my $rc = CPAN::Audit::Version->in_range( $version, $range );
	}

1;
