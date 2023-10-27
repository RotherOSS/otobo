package CPAN::Audit::Version;
use strict;
use warnings;
use version;

our $VERSION = "1.001";

sub new {
	my $class = shift;

	my $self = {};
	bless $self, $class;

	return $self;
}

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

sub in_range {
	my( $self, $version, $range ) = @_;
	my( @original ) = ($version, $range);
	return unless defined $version && defined $range;
	my @ands = split /\s*,\s*/, $range;

	return unless defined( $version = eval { version->parse($version) } );

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

1;
