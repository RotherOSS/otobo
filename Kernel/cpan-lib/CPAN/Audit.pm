package CPAN::Audit;
use v5.10.1;
use strict;
use warnings;
use version;

use Carp qw(carp);
use Module::CoreList;

use CPAN::Audit::Installed;
use CPAN::Audit::Discover;
use CPAN::Audit::Filter;
use CPAN::Audit::Version;
use CPAN::Audit::Query;
use CPAN::Audit::DB;

our $VERSION = '20240503.001';

sub new {
	my( $class, %params ) = @_;

	my @allowed_keys = qw(ascii db exclude exclude_file include_perl interactive no_corelist quiet verbose version);

	my %args = map { $_, $params{$_} } @allowed_keys;
	my $self = bless \%args, $class;

	$self->_handle_exclude_file if $self->{exclude_file};

	$self->{db}     //= CPAN::Audit::DB->db;

	$self->{filter}   = CPAN::Audit::Filter->new( exclude => $args{exclude} );
	$self->{query}    = CPAN::Audit::Query->new( db => $self->{db} );
	$self->{discover} = CPAN::Audit::Discover->new( db => $self->{db} );

	return $self;
}

sub _handle_exclude_file {
	my( $self ) = @_;

	foreach my $file (@{$self->{exclude_file}}) {
		my $fh;
		unless( open $fh, "<", $file ) {
			carp "unable to open exclude_file [$file]: $!\n";
			return;
		}
		my @excludes =
			grep { !/^\s*$/ }               # no blank lines
			map  { s{^\s+|\s+$}{}g; $_ }    # strip leading/trailing whitespace
			map  { s{#.*}{}; $_ }           # strip comments
			<$fh>;
		push @{$self->{exclude}}, @excludes;
		}
}

sub command_module {
	my ( $self, $dists, $queried, $module, $version_range ) = @_;
	return "Usage: module <module> [version-range]" unless $module;

	my $distname = $self->{db}->{module2dist}->{$module};

	if ( !$distname ) {
		return "Module '$module' is not in database";
	}

	push @{ $queried->{$distname} }, $module;
	$dists->{$distname} = $version_range // '';

	return;
}

sub command_release {
	my ( $self, $dists, $queried, $distname, $version_range ) = @_;
	return "Usage: dist|release <module> [version-range]"
		unless $distname;

	if ( !$self->{db}->{dists}->{$distname} ) {
		return "Distribution '$distname' is not in database";
	}

	$dists->{$distname} = $version_range // '';

	return;
}

sub command_show {
	my ( $self, $dists, $queried, $advisory_id ) = @_;
	return "Usage: show <advisory-id>" unless $advisory_id;

	my ($release) = $advisory_id =~ m/^CPANSA-(.*?)-(\d+)-(\d+)$/;
	return "Invalid advisory id" unless $release;

	my $dist = $self->{db}->{dists}->{$release};
	return "Unknown advisory id" unless $dist;

	my ($advisory) =
	  grep { $_->{id} eq $advisory_id } @{ $dist->{advisories} };
	return "Unknown advisory id" unless $advisory;

	my $distname = $advisory->{distribution} // 'Unknown distribution name';
	$dists->{$distname}{advisories} = [ $advisory ];
	$dists->{$distname}{version} = 'Any';

	return;
}

sub command_modules {
	my ($self, $dists, $queried, @modules) = @_;
	return "Usage: modules '<module>[;version-range]' '<module>[;version-range]'" unless @modules;

	foreach my $module ( @modules ) {
		my ($name, $version) = split /;/, $module;

		my $failed = $self->command_module( $dists, $queried, $name, $version // '' );

		if ( $failed ) {
			$self->verbose( $failed );
			next;
		}
	}

	return;
}

sub command_deps {
	my ($self, $dists, $queried, $dir) = @_;
	$dir = '.' unless defined $dir;

	return "Usage: deps <dir>" unless -d $dir;

	my @deps = $self->{discover}->discover($dir);

	$self->verbose( sprintf 'Discovered %d dependencies', scalar(@deps) );

	foreach my $dep (@deps) {
		my $dist = $dep->{dist}
		  || $self->{db}->{module2dist}->{ $dep->{module} };
		next unless $dist;

		push @{ $queried->{$dist} }, $dep->{module} if !$dep->{dist};

		$dists->{$dist} = $dep->{version};
	}

	return;
}

sub command_installed {
	my ($self, $dists, $queried, @args) = @_;

	$self->verbose('Collecting all installed modules. This can take a while...');

	my $verbose_callback = sub {
		my ($info) = @_;
		$self->verbose( sprintf '%s: %s-%s', $info->{path}, $info->{distname}, $info->{version} );
	};

	my @deps = CPAN::Audit::Installed->new(
		db           => $self->{db},
		include_perl => $self->{include_perl},
		( $self->{verbose} ? ( cb => $verbose_callback ) : () ),
	)->find(@args);

	foreach my $dep (@deps) {
		my $dist = $dep->{dist}
		  || $self->{db}->{module2dist}->{ $dep->{module} };
		next unless $dist;

		$dists->{ $dep->{dist} } = $dep->{version};
	}

	return;
}

sub command {
	state $command_table = {
		dependencies => 'command_deps',
		deps         => 'command_deps',
		installed    => 'command_installed',
		module       => 'command_module',
		modules      => 'command_modules',
		release      => 'command_release',
		dist         => 'command_release',
		show         => 'command_show',
	};

	my( $self, $command, @args ) = @_;

	my %report = (
		meta => {
			command          => $command,
			args             => [ @args ],
			cpan_audit       => { version => $VERSION },
			total_advisories => 0,
		},
		errors => [],
		dists => {},
	);
	my $dists  = $report{dists};
	my $queried = {};

	if (!$self->{no_corelist}
		&& (   $command eq 'dependencies'
			|| $command eq 'deps'
			|| $command eq 'installed' )
		)
	{
		# Find core modules for this perl version first.
		# This way explictly installed versions will overwrite.
		if ( my $core = $Module::CoreList::version{$]} ) {
			while ( my ( $mod, $ver ) = each %$core ) {
				my $dist = $self->{db}{module2dist}{$mod} or next;
				$dists->{$dist} = $ver if( ! defined $dists->{$dist} or version->parse($ver) > $dists->{$dist} );
			}
		}
	}

	if ( exists $command_table->{$command} ) {
		my $method = $command_table->{$command};
		push @{ $report{errors} }, $self->$method( $dists, $queried, @args );
		return \%report if $command eq 'show';
	}
	else {
		push @{ $report{errors} }, "unknown command: $command. See -h";
	}

	if (%$dists) {
		my $query = $self->{query};

		foreach my $distname ( keys %$dists ) {
			my $version_range = $dists->{$distname};
			my @advisories =
				grep { ! $self->{filter}->excludes($_) }
				$query->advisories_for( $distname, $version_range );

			$version_range = 'Any'
			  if $version_range eq '' || $version_range eq '0';

			$report{meta}{total_advisories} += @advisories;

			if ( @advisories ) {
				$dists->{$distname} = {
					advisories      => \@advisories,
					version         => $version_range,
					queried_modules => $queried->{$distname} || [],
				};
			}
			else {
				delete $dists->{$distname}
			}
		}
	}

	return \%report;
	}

	sub verbose {
	my ( $self, $message ) = @_;
	return if $self->{quiet};
	$self->_print( *STDERR, $message );
	}


	sub _print {
	my ( $self, $fh, $message ) = @_;

	if ( $self->{no_color} ) {
		$message =~ s{__BOLD__}{}g;
		$message =~ s{__GREEN__}{}g;
		$message =~ s{__RED__}{}g;
		$message =~ s{__RESET__}{}g;
	}
	else {
		$message =~ s{__BOLD__}{\e[39;1m}g;
		$message =~ s{__GREEN__}{\e[32m}g;
		$message =~ s{__RED__}{\e[31m}g;
		$message =~ s{__RESET__}{\e[0m}g;

		$message .= "\e[0m" if length $message;
	}

	print $fh "$message\n";
}

1;
__END__

=encoding utf8

=head1 NAME

CPAN::Audit - Audit CPAN distributions for known vulnerabilities

=head1 SYNOPSIS

	use CPAN::Audit;

=head1 DESCRIPTION

CPAN::Audit is a module and a database at the same time. It is used by
L<cpan-audit> command line application to query for vulnerabilities.

=head1 LICENSE

Copyright (C) Viacheslav Tykhanovskyi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Viacheslav Tykhanovskyi E<lt>viacheslav.t@gmail.comE<gt>

=head1 CREDITS

Takumi Akiyama (github.com/akiym)

James Raspass (github.com/JRaspass)

MCRayRay (github.com/MCRayRay)

=cut
