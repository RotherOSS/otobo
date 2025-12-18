package CPAN::Audit::Installed;
use strict;
use warnings;
use File::Find ();
use Cwd        ();

our $VERSION = "1.001";

sub new {
	my( $class, %params ) = @_;
	bless \%params, $class;
}

sub find {
	my $self = shift;
	my (@inc) = @_;

	@inc = @INC unless @inc;
	@inc = grep { defined && -d $_ } map { Cwd::realpath($_) } @inc;

	my %seen;
	my @deps;
	push @deps, { dist => 'perl', version => $] } if $self->{include_perl};

	File::Find::find(
		{
			wanted => sub {
				my $path = $File::Find::name;
				if ( $path && -f $path && m/\.pm$/ ) {
					return unless my $module = module_from_file($path);

					return unless my $distname = $self->{db}->{module2dist}->{$module};

					my $dist = $self->{db}->{dists}->{$distname};
					if ( $dist->{main_module} eq $module ) {
						return if $seen{$module}++;

						return unless my $version = module_version($path);

						push @deps, { dist => $distname, version => $version };

						if ( $self->{cb} ) {
							$self->{cb}->(
								{
									path	 => $path,
									distname => $distname,
									version	 => $version
								}
							);
						}
					}
				}
			},
			follow		=> 1,
			follow_skip => 2,
		},
		@inc
	);

	return @deps;
}

sub module_version {
	require Module::Extract::VERSION;
	my( $file ) = @_;

	my $version = Module::Extract::VERSION->parse_version_safely( $file );

	if( eval { $version->can('numify') } ) {
		$version = $version->numify;
	}

	return "$version";
}

sub module_from_file {
	my ($path) = @_;
	my $module;

	open my $fh, '<', $path or return;
	while ( my $line = <$fh> ) {
		if ( $line =~ m/package\s+(.*?)\s*;/ms ) {
			$module = $1;
			last;
		}
	}
	close $fh;

	return unless $module;
}

1;
