#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

=head1 NAME

bin/otobo.CheckModules.pl - a helper for checking CPAN dependencies

=head1 SYNOPSIS

    # print usage information
    bin/otobo.CheckModules.pl
    bin/otobo.CheckModules.pl --help
    bin/otobo.CheckModules.pl -h

    # Print the console command to install all missing packages for the standard configuration via the system package manager.
    # No version check is done.
    bin/otobo.CheckModules.pl --inst

    # Print a list of those required and most commonly used optional packages for OTOBO.
    # The version of the found modules is also checked.
    bin/otobo.CheckModules.pl --list

    # Print all required, optional and bundled packages of OTOBO.
    bin/otobo.CheckModules.pl --all

    # Print a list of all available features.
    bin/otobo.CheckModules.pl --features

    # Print a list of all packages belonging to at least one of the listed features.
    bin/otobo.CheckModules.pl --flist <features>

    # Print the console command to install all missing packages belonging to at least one of the listed features via the system package manager.
    bin/otobo.CheckModules.pl --finst <features>

    # Install packages that are needed for running the test suite
    bin/otobo.CheckModules.pl --flist devel:test
    bin/otobo.CheckModules.pl --finst devel:test

    # Print a cpanfile with the required modules regardless whether they are already available.
    bin/otobo.CheckModules.pl --cpanfile > cpanfile

    # Print a cpanfile with the required modules for a Docker-based installation.
    # This file is used in otobo.web.dockerfile.
    bin/otobo.CheckModules.pl --docker-cpanfile > cpanfile.docker

    # Print a cpanfile with the required modules for Kernel/cpan-lib
    # This file is only used for sporadic updates
    bin/otobo.CheckModules.pl --bundled-cpanfile > Kernel/cpan-lib/cpanfile

=head1 DESCRIPTION

This scripts can be used for checking whether required Perl modules are installed.
Another usage is the generation of cpanfiles.

=cut

use v5.24;
use strict;
use warnings;
use utf8;

use File::Basename qw(dirname);
use FindBin        qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

# core modules
use Getopt::Long                   qw(GetOptions);
use Term::ANSIColor                qw(color);
use Pod::Usage                     qw(pod2usage);
use Module::Metadata 1.000031      ();
use CPAN::Meta::Requirements 2.140 ();

# CPAN modules

# OTOBO modules
use Kernel::System::Environment   ();
use Kernel::System::VariableCheck qw(IsHashRefWithData IsArrayRefWithData);

my %InstTypeToCMD = (

    # [InstType] => {
    #    CMD       => '[cmd to install module]',
    #    UseModule => 1/0,
    # }
    # Set UseModule to 1 if you want to use the
    # CPAN module name of the package as replace string.
    # e.g. yum install "perl(Date::Format)"
    # If you set it 0 it will use the name
    # for the InstType of the module
    # e.g. apt-get install -y libtimedate-perl
    # and as fallback the default CPAN install command
    # e.g. cpanm DBD::Oracle
    aptget => {
        CMD       => 'apt-get install -y %s',
        UseModule => 0,
    },
    emerge => {
        CMD       => 'emerge %s',
        UseModule => 0,
    },
    ppm => {
        CMD       => 'ppm install %s',
        UseModule => 0,
    },
    yum => {
        CMD       => 'yum install "%s"',
        SubCMD    => 'perl(%s)',
        UseModule => 1,
    },

    # for a Perl package list see https://packagehub.suse.com/package-categories/perl/
    zypper => {
        CMD       => 'zypper install %s',
        UseModule => 0,
    },
    ports => {
        CMD       => 'cd /usr/ports %s',
        SubCMD    => ' && make -C %s install clean',
        UseModule => 0,
    },
    default => {
        CMD => 'cpanm %s',
    },
);

my %DistToInstType = (

    # apt-get
    debian    => 'aptget',
    ubuntu    => 'aptget',
    linuxmint => 'aptget',

    # emerge
    # for reasons unknown, some environments return "gentoo" (incl. the quotes)
    '"gentoo"' => 'emerge',
    gentoo     => 'emerge',

    # yum
    centos => 'yum',
    fedora => 'yum',
    rhel   => 'yum',
    redhat => 'yum',

    # zypper
    suse => 'zypper',

    # FreeBSD
    freebsd => 'ports',
);

# defines a set of features considered standard for non docker environments
my %IsStandardFeature = (
    'apache:mod_perl' => 1,
    'db:mysql'        => 1,
    'div:bcrypt'      => 1,
    'div:hanextra'    => 1,
    'div:ldap'        => 1,
    'div:xmlparser'   => 1,
    'div:xslt'        => 1,
    'mail'            => 1,
    'mail:imap'       => 1,
    'mail:ntlm'       => 1,
    'mail:sasl'       => 1,
    'mail:ssl'        => 1,
);

# defines a set of features considered standard for docker environments
my %IsDockerFeature = (
    'db:mysql'           => 1,
    'db:odbc'            => 1,
    'db:postgresql'      => 1,
    'db:sqlite'          => 1,
    'devel:debugging'    => 1,
    'devel:encoding'     => 1,
    'devel:test'         => 1,
    'devel:i18n'         => 1,
    'div:bcrypt'         => 1,
    'div:cldr'           => 1,
    'div:qrcode'         => 1,
    'div:ldap'           => 1,
    'div:xslt'           => 1,
    'gazelle'            => 1,
    'graph:graphviz'     => 1,
    'mail:imap'          => 1,
    'mail:ntlm'          => 1,
    'mail:sasl'          => 1,
    'performance:redis'  => 1,
    'storage:s3'         => 1,
    'auth:openidconnect' => 1,
);

# Used for the generation of a cpanfile.
my %FeatureDescription = (
    'aaacore'         => 'Required packages',
    'apache'          => 'Recommended features for setups using apache',
    'db'              => 'Database support (installing one is required)',
    'db:mysql'        => 'Support for database MySQL',
    'db:odbc'         => 'Support for database access via ODBC',
    'db:oracle'       => 'Support for database Oracle',
    'db:postgresql'   => 'Support for database PostgreSQL',
    'db:sqlite'       => 'Support for database SQLLite',
    'devel:debugging' => 'Features which can be useful in development environments',
    'devel:encoding'  => 'Modules for debugging encoding issues',
    'devel:test'      => 'Modules for running the test suite',
    'devel:i18n'      => 'Modules for dealing with translation and internationalisation',
    'div'             => 'Various features for additional functionality',
    'gazelle'         => 'Required packages if you want to use Gazelle webserver',
    'mail'            => 'Features enabling communication with a mail-server',
    'performance'     => 'required and optional features which can increase performance',
    'storage:s3'      => 'AWS S3 compatible storage',
    'zzznone'         => 'Uncategorized',
);

my $OSDist;
eval {
    require Linux::Distribution;    ## nofilter(TidyAll::Plugin::OTOBO::Perl::Require)
    import Linux::Distribution;

    $OSDist = Linux::Distribution::distribution_name() || '';
};
$OSDist //= $^O;

# extract command line parameters
my $DoPrintAllModules;
my $DoPrintInstCommand;
my $DoPrintPackageList;
my $DoPrintFeatures;
my $DoPrintCpanfile;
my $DoPrintDockerCpanfile;
my $DoPrintBundledCpanfile;
my $DoPrintHelp;
my @FeatureList;
my @FeatureInstList;
GetOptions(
    'help|h'           => \$DoPrintHelp,
    'inst'             => \$DoPrintInstCommand,
    'list'             => \$DoPrintPackageList,
    'all'              => \$DoPrintAllModules,
    'features'         => \$DoPrintFeatures,
    'finst=s{1,}'      => \@FeatureInstList,
    'flist=s{1,}'      => \@FeatureList,
    'cpanfile'         => \$DoPrintCpanfile,
    'docker-cpanfile'  => \$DoPrintDockerCpanfile,
    'bundled-cpanfile' => \$DoPrintBundledCpanfile,
) || pod2usage(2);

if (@FeatureList) {
    $DoPrintPackageList = 1;
}
elsif (@FeatureInstList) {
    $DoPrintInstCommand = 1;
}
elsif (
    !$DoPrintAllModules
    && !$DoPrintInstCommand
    && !$DoPrintPackageList
    && !$DoPrintFeatures
    && !$DoPrintCpanfile
    && !$DoPrintDockerCpanfile
    && !$DoPrintBundledCpanfile
    )
{
    $DoPrintHelp = 1;
}

# print help
if ($DoPrintHelp) {
    pod2usage(1);

    exit 1;
}

my $Options = shift || '';
my $NoColors;

if ( $DoPrintCpanfile || $DoPrintDockerCpanfile || $DoPrintBundledCpanfile || $ENV{nocolors} || $Options =~ m{\A nocolors}msxi ) {
    $NoColors = 1;
}

my $ExitCode = 0;    # success

# This is the reference for Perl modules that are required by OTOBO or are optional.
# Modules that are required are marked by setting 'Required' to 1.
# Dependent packages can be declared by setting 'Depends' to a ref to an array of hash refs.
# The key 'Features' is only used for supporting features when creating a cpanfile.
# Each module must either have exactly one of the attributes 'Required' or 'Features'.
#
# The allowed versions can be specified with the attribute 'VersionRequired'.
# That attributes accepts a version range like they are known from cpanfiles.
#
# There are cases when a different or more strict version is desired in a Docker build. This version can be
# specified with the attribute 'DockerVersionRequired'.
#
# ATTENTION: when making changes here then make sure that you also regenerate the cpanfiles:
#            bin/otobo.CheckModules.pl --cpanfile        > cpanfile
#            bin/otobo.CheckModules.pl --docker-cpanfile > cpanfile.docker
my @NeededModules = (

    # Core
    {
        Module    => 'Archive::Tar',
        Required  => 1,
        Comment   => 'Required for compressed file generation (in perlcore).',
        InstTypes => {
            aptget => 'perl',
            emerge => 'perl-core/Archive-Tar',
            zypper => 'perl-Archive-Tar',
            ports  => 'archivers/p5-Archive-Tar',
        },
    },
    {
        Module    => 'Archive::Zip',
        Required  => 1,
        Comment   => 'Required for compressed file generation.',
        InstTypes => {
            aptget => 'libarchive-zip-perl',
            emerge => 'dev-perl/Archive-Zip',
            zypper => 'perl-Archive-Zip',
            ports  => 'archivers/p5-Archive-Zip',
        },
    },
    {
        Module    => 'Const::Fast',
        Required  => 1,
        Comment   => 'Support for readonly Perl variables',
        InstTypes => {
            aptget => 'libconst-fast-perl',
            emerge => 'dev-perl/Const-Fast',
            zypper => 'perl-Const-Fast',
            ports  => 'devel/p5-Const-Fast',
        },
    },
    {
        Module    => 'Capture::Tiny',
        Required  => 1,
        Comment   => 'Neater interface for capturing STDOUT and STDERR.',
        InstTypes => {
            aptget => 'libcapture-tiny-perl',
            emerge => 'dev-perl/Capture-Tiny',
            zypper => 'perl-Capture-Tiny',
            ports  => 'devel/p5-Capture-Tiny',
        },
    },
    {
        Module    => 'Date::Format',
        Required  => 1,
        InstTypes => {
            aptget => 'libtimedate-perl',
            emerge => 'dev-perl/TimeDate',
            zypper => 'perl-TimeDate',
            ports  => 'devel/p5-TimeDate',
        },
    },
    {
        Module          => 'DateTime',
        Required        => 1,
        VersionRequired => '>= 1.08',
        InstTypes       => {
            aptget => 'libdatetime-perl',
            emerge => 'dev-perl/DateTime',
            zypper => 'perl-DateTime',
            ports  => 'devel/p5-TimeDate',
        },
        Depends => [
            {
                Module              => 'DateTime::TimeZone',
                Comment             => 'Olson time zone database, required for correct time calculations.',
                VersionsRecommended => [
                    {
                        Version => '2.20',
                        Comment => 'This version includes recent time zone changes for Chile.',
                    },
                ],
                InstTypes => {
                    aptget => 'libdatetime-timezone-perl',
                    emerge => undef,
                    zypper => 'perl-DateTime-TimeZone',
                    ports  => undef,
                },
            },
        ],
    },
    {
        Module          => 'CSS::Minifier::XS',
        Required        => 1,
        VersionRequired => '>= 0.09',                        # released in 2013
        Comment         => 'A CSS minifier written in XS',
        InstTypes       => {
            aptget => 'libcss-minifier-xs-perl',
            emerge => 'dev-perl/CSS-Minifier-XS',
            zypper => 'perl-CSS-Minifier-XS',
            ports  => 'textproc/p5-CSS-Minifier-XS',
        },
    },
    {
        Module    => 'Convert::BinHex',
        Required  => 1,
        InstTypes => {
            aptget => 'libconvert-binhex-perl',
            emerge => 'dev-perl/Convert-BinHex',
            zypper => 'perl-Convert-BinHex',
            ports  => 'converters/p5-Convert-BinHex'
        },
    },
    {
        Module    => 'DBI',
        Required  => 1,
        InstTypes => {
            aptget => 'libdbi-perl',
            emerge => 'dev-perl/DBI',
            zypper => 'perl-DBI',
            ports  => 'databases/p5-DBI',
        },
    },
    {
        Module    => 'DBIx::Connector',
        Required  => 1,
        Comment   => 'Sane persistent database connection',
        InstTypes => {
            aptget => 'libdbix-connector-perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Digest::SHA',
        Required  => 1,
        InstTypes => {
            aptget => 'perl',
            emerge => 'dev-perl/Digest-SHA',
            zypper => 'perl-Digest-SHA',
            ports  => 'security/p5-Digest-SHA'
        },
    },
    {
        Module    => 'File::chmod',
        Required  => 1,
        InstTypes => {
            aptget => 'libfile-chmod-perl',
            emerge => 'dev-perl/File-chmod',
            zypper => 'perl-File-chmod',
            ports  => 'devel/p5-File-chmod',
        },
    },
    {
        Module          => 'HTTP::Message',
        Required        => 1,
        VersionRequired => '>= 6.18',
        Comment         => 'HTTP style message',
        InstTypes       => {
            aptget => 'libhttp-message-perl',
            emerge => 'dev-perl/HTTP-Message',
            zypper => 'perl-HTTP-Message',
            yum    => 'perl-HTTP-Message',
            ports  => undef,
        },
    },
    {
        Module    => 'JavaScript::Minifier::XS',
        Required  => 1,
        Comment   => 'A JavaScript minifier written in XS',
        InstTypes => {
            aptget => 'libjavascript-minifier-xs-perl',
            emerge => 'dev-perl/JavaScript-Minifier-XS',
            zypper => 'perl-JavaScript-Minifier-XS',
            ports  => 'textproc/p5-JavaScript-Minifier-XS',
        },
    },
    {
        Module    => 'JSON::XS',
        Required  => 1,
        Comment   => 'JSON parsing and generation',
        InstTypes => {
            aptget => 'libjson-xs-perl',
            emerge => 'dev-perl/JSON-XS',
            yum    => 'perl-JSON-XS',
            zypper => 'perl-JSON-XS',
            ports  => 'converters/p5-JSON-XS',
        },
    },
    {

        # List::Util is a core module and has a double life
        # in the Scalar::List::Utils distribution.
        Module          => 'List::Util',
        Required        => 1,
        VersionRequired => '>= 1.45',
        InstTypes       => {
            aptget => 'libscalar-list-utils-perl',
            emerge => 'perl-core/Scalar-List-Utils',
            zypper => 'perl-Scalar-List-Utils',
            ports  => 'devel/p5-Scalar-List-Utils',
        },
    },
    {
        Module          => 'List::AllUtils',
        Required        => 1,
        VersionRequired => '>= 0.11',
        InstTypes       => {
            aptget => 'liblist-allutils-perl',
            emerge => 'dev-perl/Scalar-List-Utils',
            zypper => 'perl-List-AllUtils',
            ports  => 'devel/p5-List-AllUtils',
        },
    },
    {
        Module    => 'LWP::UserAgent',
        Required  => 1,
        InstTypes => {
            aptget => 'libwww-perl',
            emerge => 'dev-perl/libwww-perl',
            zypper => 'perl-libwww-perl',
            ports  => 'www/p5-libwww',
        },
    },
    {
        Module    => 'Moo',
        Required  => 1,
        Comment   => 'Required for random number generator.',
        InstTypes => {
            aptget => 'libmoo-perl',
            emerge => 'dev-perl/Moo',
            zypper => 'perl-Moo',
            ports  => 'devel/p5-Moo',
        },
    },
    {
        Module    => 'namespace::autoclean',
        Required  => 1,
        Comment   => 'clean up imported methodes',
        InstTypes => {
            aptget => 'libnamespace-autoclean-perl',
            emerge => 'dev-perl/namespace-autoclean',
            zypper => 'perl-namespace-autoclean',
            ports  => 'devel/p5-namespace-autoclean',
        },
    },
    {
        Module          => 'Net::DNS',
        Required        => 1,
        VersionRequired => '>= 1.05',
        InstTypes       => {
            aptget => 'libnet-dns-perl',
            emerge => 'dev-perl/Net-DNS',
            zypper => 'perl-Net-DNS',
            ports  => 'dns/p5-Net-DNS',
        },
    },
    {
        Module    => 'Net::SMTP::SSL',
        Required  => 1,
        Comment   => 'Required by Kernel/cpan-lib/Mail/Mailer/smtps.pm',
        InstTypes => {
            aptget => 'libnet-smtp-ssl-perl',
            emerge => 'dev-perl/Net-SMTP-SSL',
            zypper => 'perl-Net-SMTP-SSL',
            ports  => 'devel/p5-Net-SMTP-SSL',
        },
    },
    {
        Module    => 'Path::Class',
        Comment   => 'Neater path manipulation and some utils',
        Required  => 1,
        InstTypes => {
            aptget => 'libpath-class-perl',
            emerge => 'dev-perl/Path-Class',
            zypper => 'perl-Path-Class',
            ports  => 'devel/p5-Path-Class',
        },
    },
    {
        Module    => 'Plack',
        Required  => 1,
        Comment   => 'Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)',
        InstTypes => {
            aptget => 'libplack-perl',
            emerge => 'dev-perl/Plack',
            zypper => 'perl-Plack',
            yum    => 'perl-Plack',
            ports  => undef,
        },
    },
    {
        Module    => 'Sub::Exporter',
        Required  => 1,
        Comment   => 'needed by Kernel/cpan-lib/Crypt/Random/Source.pm',
        InstTypes => {
            aptget => 'libsub-exporter-perl',
            emerge => 'dev-perl/Sub-Exporter',
            zypper => 'perl-Sub-Exporter',
            ports  => 'devel/p5-Sub-Exporter',
        },
    },
    {
        Module    => 'Template::Toolkit',
        Required  => 1,
        Comment   => 'Template::Toolkit, the rendering engine of OTOBO.',
        InstTypes => {
            aptget => 'libtemplate-perl',
            emerge => 'dev-perl/Template-Toolkit',
            zypper => 'perl-Template-Toolkit',
            ports  => 'www/p5-Template-Toolkit',
        },
    },
    {
        # Actually Template::Stash::XS is part of the Perl distribution Template::Toolkit.
        # Note that no version is declared for this module.
        Module    => 'Template::Stash::XS',
        Required  => 1,
        Comment   => 'The fast data stash for Template::Toolkit.',
        InstTypes => {
            aptget => 'libtemplate-perl',
            emerge => 'dev-perl/Template-Toolkit',
            zypper => 'perl-Template-Toolkit',
            ports  => 'www/p5-Template-Toolkit',
        },
    },
    {
        Module          => 'Text::CSV',
        Required        => 1,
        VersionRequired => '>= 1.95',     # released 2017-04-27
        InstTypes       => {
            aptget => 'libtext-csv-perl',
            emerge => 'dev-perl/Text-CSV',
            zypper => 'perl-Text-CSV',
            ports  => 'textproc/p5-Text-CSV',
        },
    },
    {
        Module          => 'Text::CSV_XS',
        Required        => 1,
        VersionRequired => '>= 1.34',                                    # released 2017-11-05
        Comment         => 'A fast backend that is used by Text::CSV',
        InstTypes       => {
            aptget => 'libtext-csv-xs-perl',
            emerge => 'dev-perl/Text-CSV_XS',
            zypper => 'perl-Text-CSV_XS',
            ports  => 'textproc/p5-Text-CSV_XS',
        },
    },
    {
        Module    => 'Text::Trim',
        Required  => 1,
        InstTypes => {
            aptget => 'libtext-trim-perl',
            emerge => 'dev-perl/Text-Trim',
            zypper => 'perl-Text-Trim',
            ports  => 'devel/p5-Text-Trim',
        },
    },
    {
        Module    => 'Time::HiRes',
        Required  => 1,
        Comment   => 'Required for high resolution timestamps.',
        InstTypes => {
            aptget => 'perl',
            emerge => 'perl-core/Time-HiRes',
            zypper => 'perl-Time-HiRes',
            ports  => 'devel/p5-Time-HiRes',
        },
    },
    {
        Module    => 'Try::Tiny',
        Required  => 1,
        InstTypes => {
            aptget => 'libtry-tiny-perl',
            emerge => 'dev-perl/Try-Tiny',
            zypper => 'perl-Try-Tiny',
            ports  => 'devel/p5-Try-Tiny',
        },
    },
    {
        # This module is a requirement for JSON::XS. It is listed
        # here explicitly because it is also unded independently
        # from JSON::XS
        Module    => 'Types::Serialiser',
        Required  => 1,
        InstTypes => {
            aptget => 'libtypes-serialiser-perl',
            emerge => 'dev-perl/Types-Serialiser',
            zypper => 'perl-Types-Serialiser',
            ports  => 'devel/p5-Types-Serialiser',
        },
    },
    {
        Module    => 'URI',
        Required  => 1,
        Comment   => 'for generating properly escaped URLs',
        InstTypes => {
            aptget => 'liburi-perl',
            emerge => 'dev-perl/URI',
            zypper => 'perl-URI',
            ports  => 'devel/p5-URI',
        },
    },
    {
        Module    => 'XML::LibXML',
        Required  => 1,
        Comment   => 'Required for XML processing.',
        InstTypes => {
            aptget => 'libxml-libxml-perl',
            zypper => 'perl-XML-LibXML',
            ports  => 'textproc/p5-XML-LibXML',
        },
    },
    {
        Module          => 'YAML::XS',
        Required        => 1,
        VersionRequired => '>= 0.62',
        Comment         => 'Required for fast and correct YAML processing.',
        InstTypes       => {
            aptget => 'libyaml-libyaml-perl',
            emerge => 'dev-perl/YAML-LibYAML',
            zypper => 'perl-YAML-LibYAML',
            ports  => 'textproc/p5-YAML-LibYAML',
        },
    },
    {
        Module    => 'Unicode::Collate',
        Required  => 1,
        Comment   => 'For internationalised sorting',
        InstTypes => {
            aptget => 'perl',

            # This is a core Perl module which should be available on most distributions.
            # Redhat seems to be an exception. See https://github.com/RotherOSS/otobo/issues/219
            yum => 'perl-Unicode-Collate',
        },
    },

    # Feature storage:s3
    {
        Module          => 'Mojolicious',
        VersionRequired => '>= 9.22',
        Features        => ['storage:s3'],
        Comment         => 'support for the REST requests to the S3 storage',
        InstTypes       => {
            aptget => undef,
            emerge => undef,
            yum    => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Cpanel::JSON::XS',
        Features  => ['storage:s3'],
        Comment   => 'correct and fast JSON support, used by Mojo::JSON',
        InstTypes => {
            aptget => undef,
            emerge => undef,
            yum    => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Mojolicious::Plugin::AWS',
        Features  => ['storage:s3'],
        Comment   => 'support for S3 using Mojo::UserAgent',
        InstTypes => {
            aptget => undef,
            emerge => undef,
            yum    => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature db
    {
        Module          => 'DBD::mysql',
        VersionRequired => '>= 4.00, != 4.042, < 5.001',
        VersionComments => [
            qq{>= 4.00: just to have some minimum version, please use a more recent version},
            qq{!= 4.042: This version had encoding related issues. Version 4.043 was a rollback to 4.0.41},
            qq{< 5.001: This version can't be installed with the MariaDB client library},
        ],
        Features  => ['db:mysql'],
        Comment   => 'Required to connect to a MariaDB or MySQL database.',
        InstTypes => {
            aptget => 'libdbd-mysql-perl',
            emerge => 'dev-perl/DBD-mysql',
            zypper => 'perl-DBD-mysql',
            ports  => 'databases/p5-DBD-mysql',
        },
    },
    {
        Module          => 'DBD::ODBC',
        Features        => ['db:odbc'],
        VersionRequired => '!= 1.23',
        Comment         => 'Required to connect to a MS-SQL database.',
        VersionComments => [
            qq{Version 1.23 not supported: This version is broken and not useable! Please upgrade to a higher version.},
        ],
        Comment   => 'Required to connect to a MS-SQL database.',
        InstTypes => {
            aptget => 'libdbd-odbc-perl',
            emerge => undef,
            yum    => undef,
            zypper => undef,
            ports  => 'databases/p5-DBD-ODBC',
        },
    },
    {
        Module    => 'DBD::Oracle',
        Features  => ['db:oracle'],
        Comment   => 'Required to connect to a Oracle database.',
        InstTypes => {
            aptget => undef,    # not in any Debian package
            emerge => undef,
            yum    => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'DBD::Pg',
        Features  => ['db:postgresql'],
        Comment   => 'Required to connect to a PostgreSQL database.',
        InstTypes => {
            aptget => 'libdbd-pg-perl',
            emerge => 'dev-perl/DBD-Pg',
            zypper => 'perl-DBD-Pg',
            ports  => 'databases/p5-DBD-Pg',
        },
    },
    {
        Module    => 'DBD::SQLite',
        Features  => ['db:sqlite'],
        Comment   => 'Required to connect to a SQLite database.',
        InstTypes => {
            aptget => 'libdbd-sqlite3-perl',
        },
    },

    # Feature apache
    {
        Module    => 'ModPerl::Util',
        Features  => ['apache:mod_perl'],
        Comment   => 'Improves Performance on Apache webservers dramatically.',
        InstTypes => {
            aptget => 'libapache2-mod-perl2',
            emerge => 'www-apache/mod_perl',
            zypper => 'apache2-mod_perl',
            ports  => 'www/mod_perl2',
        },
    },

    # Feature mail
    {
        Module              => 'Net::SMTP',
        Features            => ['mail'],
        Comment             => 'Simple Mail Transfer Protocol Client.',
        VersionsRecommended => [
            {
                Version => '3.11',
                Comment => 'This version fixes email sending (bug#14357).',
            },
        ],
        InstTypes => {
            aptget => 'perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module          => 'Mail::IMAPClient',
        VersionRequired => '>= 3.22',
        Features        => ['mail:imap'],
        Comment         => 'Required for IMAP TLS connections.',
        InstTypes       => {
            aptget => 'libmail-imapclient-perl',
            emerge => 'dev-perl/Mail-IMAPClient',
            zypper => 'perl-Mail-IMAPClient',
            ports  => 'mail/p5-Mail-IMAPClient',
        },
    },
    {
        Module    => 'Authen::SASL',
        Features  => ['mail:sasl'],
        Comment   => 'Required for MD5 authentication mechanisms in IMAP connections.',
        InstTypes => {
            aptget => 'libauthen-sasl-perl',
            emerge => 'dev-perl/Authen-SASL',
            zypper => 'perl-Authen-SASL',
        },
    },
    {
        Module    => 'Authen::NTLM',
        Features  => ['mail:ntlm'],
        Comment   => 'Required for NTLM authentication mechanism in IMAP connections.',
        InstTypes => {
            aptget => 'libauthen-ntlm-perl',
            emerge => 'dev-perl/Authen-NTLM',
            zypper => 'perl-Authen-NTLM',
        },
    },

    # Feature performance
    {
        Module    => 'Redis',
        Comment   => 'For usage with Redis Cache Server.',
        Features  => ['performance:redis'],
        InstTypes => {
            aptget => 'libredis-perl',
            emerge => 'dev-perl/Redis',
            yum    => 'perl-Redis',
            zypper => 'perl-Redis',
            ports  => 'databases/p5-Redis',
        },
    },
    {
        Module    => 'Redis::Fast',
        Features  => ['performance:redis'],
        Comment   => 'Recommended for usage with Redis Cache Server. (it`s compatible with `Redis`, but **~2x faster**)',
        InstTypes => {
            aptget => 'libredis-fast-perl',
            emerge => undef,
            yum    => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature gazelle
    {
        Module    => 'Gazelle',
        Features  => ['gazelle'],
        Comment   => 'High-performance preforking PSGI/Plack web server',
        InstTypes => {
            aptget => undef,    # not in any Debian package
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Linux::Inotify2',
        Features  => ['gazelle'],
        Comment   => 'Used when plackup is run with the -R option. This option restarts the server when files have changed.',
        InstTypes => {
            aptget => 'liblinux-inotify2-perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Deflater not used yet, see https://github.com/RotherOSS/otobo/issues/1053
    #{
    #    Module    => 'Plack::Middleware::Deflater',
    #    Required  => 1,
    #    Features  => ['plack'],
    #    Comment   => 'Compress generated and static content',
    #    InstTypes => {
    #        aptget => undef,
    #        emerge => undef,
    #        zypper => undef,
    #        ports  => undef,
    #    },
    #},
    {
        Module    => 'Plack::Middleware::Header',
        Required  => 1,
        Comment   => 'Set HTTP headers',
        InstTypes => {
            aptget => 'libplack-middleware-header-perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Plack::Middleware::ReverseProxy',
        Required  => 1,
        Comment   => 'Twist some HTTP variables so that the reverse proxy is transparent',
        InstTypes => {
            aptget => 'libplack-middleware-reverseproxy-perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature graph
    {
        Module          => 'GraphViz2',
        Features        => ['graph:graphviz'],
        VersionRequired => '>= 2.67',                          # released 2022-07-21
        Comment         => q{A wrapper for AT&T's Graphviz},
        InstTypes       => {
            aptget => undef,                                   # available only in Debian testing
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature auth
    {
        Module    => 'Crypt::JWT',
        Features  => ['auth:openidconnect'],
        Comment   => 'Required for authentication via OpenIDConnect.',
        InstTypes => {
            aptget => undef,
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature div
    {
        Module          => 'Encode::HanExtra',
        VersionRequired => '>= 0.23',
        Features        => ['div:hanextra'],
        Comment         => 'Required to handle mails with several Chinese character sets.',
        InstTypes       => {
            aptget => 'libencode-hanextra-perl',
            emerge => 'dev-perl/Encode-HanExtra',
            zypper => 'perl-Encode-HanExtra',
            ports  => 'chinese/p5-Encode-HanExtra',
        },
    },
    {
        Module              => 'IO::Socket::SSL',
        Features            => [ 'div:ssl', 'mail:ssl' ],
        Comment             => 'Required for SSL connections to web and mail servers.',
        VersionsRecommended => [
            {
                Version => '2.066',
                Comment => 'This version fixes email sending (bug#14357).',
            },
        ],
        InstTypes => {
            aptget => 'libio-socket-ssl-perl',
            emerge => 'dev-perl/IO-Socket-SSL',
            zypper => 'perl-IO-Socket-SSL',
            ports  => 'security/p5-IO-Socket-SSL',
        },
    },
    {
        Module    => 'Net::LDAP',
        Comment   => 'Required for directory authentication.',
        Features  => ['div:ldap'],
        InstTypes => {
            aptget => 'libnet-ldap-perl',
            emerge => 'dev-perl/perl-ldap',
            zypper => 'perl-ldap',
            ports  => 'net/p5-perl-ldap',
        },
    },
    {
        Module    => 'Crypt::Eksblowfish::Bcrypt',
        Features  => ['div:bcrypt'],
        Comment   => 'For strong password hashing.',
        InstTypes => {
            aptget => 'libcrypt-eksblowfish-perl',
            emerge => 'dev-perl/Crypt-Eksblowfish',
            zypper => 'perl-Crypt-Eksblowfish',
            ports  => 'security/p5-Crypt-Eksblowfish',
        },
    },
    {
        Module          => 'Locale::CLDR',
        Features        => ['div:cldr'],
        VersionRequired => '== 0.44.1',
        Comment         => 'localisation from the CLDR project',
        InstTypes       => {
            aptget => undef,    # not in any Debian package
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'XML::LibXSLT',
        Features  => ['div:xslt'],
        Comment   => 'Required for Generic Interface XSLT mapping module.',
        InstTypes => {
            aptget => 'libxml-libxslt-perl',
            zypper => 'perl-XML-LibXSLT',
            ports  => 'textproc/p5-XML-LibXSLT',
        },
    },
    {
        Module    => 'Text::QRCode',
        Features  => ['div:qrcode'],
        Comment   => 'Support for QR code in PDF files',
        InstTypes => {
            aptget => 'libtext-qrcode-perl',
        },
    },

    # Feature devel:debugging
    {
        Module          => 'Data::Dump',
        VersionRequired => '>= 1.25',
        Features        => ['devel:debugging'],
        Comment         => 'nicer formatting when dumping data structures',
        InstTypes       => {
            aptget => undef,
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module          => 'Data::Dx',
        VersionRequired => '>= 0.000010',
        Features        => ['devel:debugging'],
        Comment         => 'convenient and informative dumping data structures',
        InstTypes       => {
            aptget => undef,
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature devel:encoding
    {
        Module    => 'Data::Peek',
        Features  => [ 'devel:encoding', 'devel:test' ],
        Comment   => 'for deeply inspecting scalars, especially strings',
        InstTypes => {
            aptget => 'libdata-peek-perl',
            emerge => undef,
            yum    => 'perl-Data-Peek',
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'String::Dump',
        Features  => ['devel:encoding'],
        Comment   => 'for deeply inspecting strings',
        InstTypes => {
            aptget => undef,    # not in any Debian package
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature devel:test
    {
        Module          => 'Selenium::Remote::Driver',
        VersionRequired => '>= 1.49',
        Features        => ['devel:test'],
        Comment         => 'used by Kernel::System::UnitTest::Selenium',
        InstTypes       => {
            aptget => undef,    # not in any Debian package
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Test::Compile',
        Features  => ['devel:test'],
        Comment   => 'a quick compile check',
        InstTypes => {
            aptget => 'libtest-compile-perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Test2::Suite',
        Features  => ['devel:test'],
        Comment   => 'basic test functions',
        InstTypes => {
            aptget => 'libtest2-suite-perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Test::Simple',
        Features  => ['devel:test'],
        Comment   => 'contains Test2::API which is used in Kernel::System::UnitTest::Driver',
        InstTypes => {
            aptget => 'perl',
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Test2::Tools::HTTP',
        Features  => ['devel:test'],
        Comment   => 'testing PSGI apps and URLs',
        InstTypes => {
            aptget => undef,    # not in any Debian package
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
    {
        Module    => 'Unicode::GCString',
        Features  => ['devel:test'],
        Comment   => 'support for formatting test results',
        InstTypes => {
            aptget => undef,
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },

    # Feature devel:i18n
    {
        Module    => 'Locale::PO',
        Features  => ['devel:i18n'],
        Comment   => 'module for manipulating .po entries',
        InstTypes => {
            aptget => undef,
            emerge => undef,
            zypper => undef,
            ports  => undef,
        },
    },
);

# Add CLDR language packs. It is not decided yet whether all 50 languages are added.
# So let's first go for the languages that have a translation quote of more than 80%.
# See https://translate.otobo.org/projects/otobo10/otobo/.
for my $Code (qw(Ar De Es Fr Hu Ko Nb Pt Ru Sr Zh)) {
    push @NeededModules,
        {
            Module          => "Locale::CLDR::Locales::$Code",
            Features        => ['div:cldr'],
            VersionRequired => '== 0.44.1',
            Comment         => 'language packs from the CLDR project',
            InstTypes       => {
                aptget => undef,    # not in any Debian package
                emerge => undef,
                zypper => undef,
                ports  => undef,
            },
        };
}

# Sanity check.
for my $Module (@NeededModules) {
    die 'Module must be set!' unless defined $Module->{Module};

    if ( defined $Module->{Required} && defined $Module->{Features} ) {
        die "Only one of 'Required' and 'Features' may be set for $Module->{Module}!";
    }

    if ( !defined $Module->{Required} && !defined $Module->{Features} ) {
        die "One of 'Required' or 'Features' must be set for $Module->{Module}!";
    }
}

# This is a quick hack for looking up the Debian package names that contain the Perl modules.
# Not removed because it might be useful in the future.
if (0) {
    for my $Module (@NeededModules) {
        my $InstType = $DistToInstType{$OSDist};

        say 'Module ', $Module->{Module};
        say $Module->{InstTypes}->{$InstType} // 'UNDEFINED';
        print `dh-make-perl locate $Module->{Module}`;
        say "";
    }

    exit;
}

if ($DoPrintCpanfile) {
    say <<'END_HEADER';
# Do not change this file manually.
# Instead adapt bin/otobo.CheckModules.pl and call
#    ./bin/otobo.CheckModules.pl --cpanfile > cpanfile
END_HEADER

    PrintCpanfile( \@NeededModules, 1, 1, 0 );
}
elsif ($DoPrintDockerCpanfile) {
    say <<'END_HEADER';
# Do not change this file manually except if you want to invalidate the cache just in the GitHub CI workflow.
# Instead adapt bin/otobo.CheckModules.pl and call
#    ./bin/otobo.CheckModules.pl --docker-cpanfile > cpanfile.docker
END_HEADER

    PrintCpanfile( \@NeededModules, 1, 1, 1 );
}
elsif ($DoPrintBundledCpanfile) {
    say <<'END_HEADER';
# This cpanfile can be used for updating Kernel/cpan-lib. See Kernel/cpan-lib/README.md for details.
#
# Do not change this file manually.
# Instead adapt the module list in the method Kernel::System::Environment::BundleModulesDeclarationGet()
# and call:
#    mkdir tmp-cpan-lib
#    ./bin/otobo.CheckModules.pl --bundled-cpanfile > tmp-cpan-lib/cpanfile
#
END_HEADER

    my @BundledModules = Kernel::System::Environment->BundleModulesDeclarationGet;
    PrintCpanfile( \@BundledModules, 1, 0, 0 );
}
elsif ($DoPrintInstCommand) {

    my @SelectedModules;
    my %FeatureIsUsed = @FeatureInstList ? map { $_ => 1 } @FeatureInstList : %IsStandardFeature;

    for my $Module (@NeededModules) {
        if ( $Module->{Required} ) {
            push @SelectedModules, $Module;
        }
        elsif ( $Module->{Features} ) {
            for my $Feature ( @{ $Module->{Features} } ) {
                if ( $FeatureIsUsed{$Feature} || $FeatureIsUsed{ ( split( /:/, $Feature ) )[0] } ) {
                    push @SelectedModules, $Module;
                }
            }
        }
    }

    my %PackageList = CollectPackageInfo( \@SelectedModules );

    # the distro packages that supply one or more of the required Perl modules
    if ( IsArrayRefWithData( $PackageList{Packages} ) ) {

        my $CMD = $PackageList{CMD};

        for my $Package ( @{ $PackageList{Packages} } ) {
            if ( $PackageList{SubCMD} ) {
                $Package = sprintf $PackageList{SubCMD}, $Package;
            }
        }
        say sprintf $CMD, join( ' ', @{ $PackageList{Packages} } );
    }

    # for some modules there is no module avaialable
    for my $Module ( $PackageList{CPANOnlyModules}->@* ) {
        say <<"END_MSG";

No $OSDist package found that contains the Perl module $Module->{Module}.
For installing you can search in your package manager for $Module->{Module}.
Or install with your favourite CPAN installer, e.g. 'sudo cpanm install $Module->{Module}'.
END_MSG
    }
}
elsif ($DoPrintFeatures) {

    # print a list of the available features
    my %Features;
    MODULE:
    for my $Module (@NeededModules) {

        next MODULE unless $Module->{Features};

        for my $Feature ( @{ $Module->{Features} } ) {
            $Features{$Feature}++;
        }
    }

    print "\nAvailable Features:\n";
    for my $Feature ( sort keys %Features ) {
        print "\t$Feature\n";
    }
    print "\n";
}
else {

    my %Features;
    if ($DoPrintAllModules) {
        MODULE:
        for my $Module (@NeededModules) {
            next MODULE if !$Module->{Features};
            for my $Feature ( @{ $Module->{Features} } ) {
                $Features{$Feature}++;
            }
        }
        $Features{aaacore} = 1;
        $Features{zzznone} = 1;
    }
    else {
        $IsStandardFeature{aaacore} = 1;
        $IsStandardFeature{zzznone} = 1;
        %Features                   = @FeatureList ? map { $_ => 1 } @FeatureList : %IsStandardFeature;
    }

    my %PrintFeatures;
    for my $Module (@NeededModules) {
        if ( $Module->{Required} && $Features{aaacore} ) {
            push @{ $PrintFeatures{aaacore} }, $Module;
        }
        elsif ( $Module->{Features} ) {

            # user defined features
            if ( !$Features{aaacore} ) {
                for my $Feature ( @{ $Module->{Features} } ) {
                    if ( $Features{$Feature} ) {
                        push @{ $PrintFeatures{$Feature} }, $Module;
                    }
                    elsif ( $Features{ ( split( /:/, $Feature ) )[0] } ) {
                        push @{ $PrintFeatures{ ( split( /:/, $Feature ) )[0] } }, $Module;
                    }
                }
            }

            # else just take main categories
            else {
                for my $Feature ( @{ $Module->{Features} } ) {
                    if ( $Features{$Feature} ) {
                        push @{ $PrintFeatures{ ( split( /:/, $Feature ) )[0] } }, $Module;
                    }
                }
            }
        }
        elsif ( $Features{zzznone} ) {
            push @{ $PrintFeatures{zzznone} }, $Module;
        }
    }

    # try to determine module version number
    my $Depends = 0;

    for my $Category ( sort keys %PrintFeatures ) {
        print $FeatureDescription{$Category} ? "\n$FeatureDescription{$Category}:\n" : "\nPackages needed for the feature '$Category':\n";
        for my $Module ( @{ $PrintFeatures{$Category} } ) {
            Check( $Module, $Depends, $NoColors );
        }
    }

    if ($DoPrintAllModules) {
        print "\n\nBundled modules:\n\n";

        my %PerlInfo = Kernel::System::Environment->PerlInfoGet(
            BundledModules => 1,
        );

        for my $Module ( sort keys %{ $PerlInfo{Modules} } ) {
            Check(
                {
                    Module   => $Module,
                    Required => 1,
                },
                $Depends,
                $NoColors
            );
        }
    }
    print "\n";
}

sub Check {
    my ( $Module, $Depends, $NoColors ) = @_;

    print "  " x ( $Depends + 1 );
    print "o $Module->{Module}";
    my $Length = 33 - ( length( $Module->{Module} ) + ( $Depends * 2 ) );
    print '.' x $Length;

    # $Metadata is undefined when the module is not found in @INC
    my $Metadata = Module::Metadata->new_from_module( $Module->{Module} );

    if ( defined $Metadata ) {

        my $ErrorMessage = '';
        if ( !eval "require $Module->{Module}" ) {    ## no critic qw(BuiltinFunctions::ProhibitStringyEval)
            $ErrorMessage .= 'Not all prerequisites for this module correctly installed. ';
        }

        my $Version = $Metadata->version;

        my $AdditionalText = '';

        if ( $Module->{VersionsRecommended} ) {

            ITEM:
            for my $Item ( @{ $Module->{VersionsRecommended} } ) {

                # Check the required version range.
                # The version range is given in META.json, or cpanfile, style.
                # E.g. '4.0, != 4.043, < 5.000'
                my $Requirements = CPAN::Meta::Requirements->new;
                $Requirements->add_string_requirement( $Module->{Module} => $Item->{Version} );
                my $IsAccepted = $Requirements->accepts_module( $Module->{Module} => $Version );

                if ( !$IsAccepted ) {
                    $AdditionalText .= "    Please consider updating to version $Item->{Version} : $Item->{Comment}\n";
                }
            }
        }

        if ( $Module->{VersionRequired} ) {

            # Check the required version range.
            # The version range is given in META.json, or cpanfile, style.
            # E.g. '4.0, != 4.043, < 5.000'
            my $Requirements = CPAN::Meta::Requirements->new;
            $Requirements->add_string_requirement( $Module->{Module} => $Module->{VersionRequired} );
            my $IsAccepted = $Requirements->accepts_module( $Module->{Module} => $Version );

            if ( !$IsAccepted ) {
                $ErrorMessage .= "Version $Version installed but $Module->{VersionRequired} is required! ";
                if ( $Module->{VersionComments} ) {
                    $ErrorMessage .= join "\n", '', $Module->{VersionComments}->@*;
                }
            }
        }

        if ($ErrorMessage) {
            if ($NoColors) {
                print "FAILED! $ErrorMessage\n";
            }
            else {
                print color('red') . 'FAILED!' . color('reset') . " $ErrorMessage\n";
            }
            $ExitCode = 1;    # error
        }
        else {
            my $OutputVersion = $Version // '(not defined)';

            # not sure why 'v' is prepended
            if ( $OutputVersion =~ m{ [0-9.] }xms ) {
                $OutputVersion = 'v' . $OutputVersion;
            }

            if ($NoColors) {
                print "ok ($OutputVersion)\n$AdditionalText";
            }
            else {
                print color('green') . 'ok'
                    . color('reset')
                    . " ($OutputVersion)\n"
                    . color('yellow')
                    . "$AdditionalText"
                    . color('reset');
            }
        }
    }
    else {
        my $Comment  = $Module->{Comment} ? ' - ' . $Module->{Comment} : '';
        my $Required = $Module->{Required};
        my $Color    = 'yellow';

        # OS Install Command
        my %InstallCommand = GetInstallCommand($Module);

        # create example installation string for module
        my $InstallText = '';
        if ( IsHashRefWithData( \%InstallCommand ) ) {
            my $CMD = $InstallCommand{CMD};
            if ( $InstallCommand{SubCMD} ) {
                $CMD = sprintf $InstallCommand{CMD}, $InstallCommand{SubCMD};
            }

            $InstallText = " To install, you can use: '" . sprintf( $CMD, $InstallCommand{Package} ) . "'.";
        }

        if ($Required) {
            $Required = 'required';
            $Color    = 'red';
            $ExitCode = 1;            # error
        }
        else {
            $Required = 'optional';
        }
        if ($NoColors) {
            print "Not installed! ($Required $Comment)\n";
        }
        else {
            print color($Color)
                . 'Not installed!'
                . color('reset')
                . "$InstallText ($Required$Comment)\n";
        }
    }

    if ( $Module->{Depends} ) {
        for my $ModuleSub ( @{ $Module->{Depends} } ) {
            Check( $ModuleSub, $Depends + 1, $NoColors );
        }
    }

    return 1;
}

sub CollectPackageInfo {
    my ($PackageList) = @_;

    my $CMD;
    my $SubCMD;
    my @Packages;
    my @CPANOnlyModules;

    # if we're on Windows we don't need to see Apache + mod_perl modules
    MODULE:
    for my $Module ( @{$PackageList} ) {

        # $Metadata is undefined when the module is not found in @INC
        my $ModulePath = Module::Metadata->find_module_by_name( $Module->{Module} );

        next MODULE if defined $ModulePath;

        my %InstallCommand = GetInstallCommand($Module);

        if ( IsHashRefWithData( \%InstallCommand ) ) {
            $CMD    = $InstallCommand{CMD};
            $SubCMD = $InstallCommand{SubCMD};
            push @Packages, $InstallCommand{Package};
        }
        else {
            push @CPANOnlyModules, $Module;
        }
    }

    return (
        CMD             => $CMD,
        SubCMD          => $SubCMD,
        Packages        => \@Packages,
        CPANOnlyModules => \@CPANOnlyModules,
    );
}

sub GetInstallCommand {
    my ($Module) = @_;
    my $CMD;
    my $SubCMD;
    my $Package;

    # returns the installation type e.g. ppm
    my $InstType     = $DistToInstType{$OSDist};
    my $OuputInstall = 1;

    if ($InstType) {

        # gets the install command for installation type
        # e.g. ppm install %s
        # default is the CPAN install command
        # e.g. cpanm %s
        $CMD    = $InstTypeToCMD{$InstType}->{CMD};
        $SubCMD = $InstTypeToCMD{$InstType}->{SubCMD};

        # gets the target package
        if (
            exists $Module->{InstTypes}->{$InstType}
            && !defined $Module->{InstTypes}->{$InstType}
            )
        {
            # if we a hash key for the installation type but a undefined value
            # then we prevent the output for the installation command
            $OuputInstall = 0;
        }
        elsif ( $InstTypeToCMD{$InstType}->{UseModule} ) {

            # default is the CPAN module name
            $Package = $Module->{Module};
        }
        else {
            # if the package name is defined for the installation type
            # e.g. ppm then we use this as package name
            $Package = $Module->{InstTypes}->{$InstType};
        }
    }

    return if !$OuputInstall;

    if ( !$CMD || !$Package ) {
        $CMD     = $InstTypeToCMD{default}->{CMD};
        $SubCMD  = $InstTypeToCMD{default}->{SubCMD};
        $Package = $Module->{Module};
    }

    return (
        CMD     => $CMD,
        SubCMD  => $SubCMD,
        Package => $Package,
    );
}

sub PrintCpanfile {
    my ( $NeededModules, $FilterRequired, $HandleFeatures, $ForDocker ) = @_;

    # Indent the statements in the feature sections
    my $Indent = $FilterRequired ? '' : '    ';

    # print the required modules
    # collect the modules per feature
    my %ModulesForFeature;
    MODULE:
    for my $Module ( $NeededModules->@* ) {

        # put all not required modules into 'optional'
        if ( $FilterRequired && !$Module->{Required} ) {
            my $Feature = 'optional';
            $ModulesForFeature{$Feature} //= [];
            push $ModulesForFeature{$Feature}->@*, $Module;
        }

        # print out the requirements, either because it is required, or because it is a feature
        if ( !$FilterRequired || $Module->{Required} ) {
            my $Comment = $Module->{Comment};
            if ($Comment) {
                $Comment =~ s/\n/\n$Indent\# /g;
                say $Indent, "# $Comment";
            }

            # The comments about versions are always added to the cpanfile.
            for my $VersionComment ( ( $Module->{VersionComments} // [] )->@* ) {
                say $Indent, '# ', $VersionComment;
            }

            if ( $Module->{VersionsRecommended} ) {
                for my $Item ( $Module->{VersionsRecommended}->@* ) {
                    say $Indent, "# Please consider updating to version $Item->{Version} or higher: $Item->{Comment}";
                }
            }

            # there may be additional restrictions on the versions
            # exact version for Docker builds has higher priority
            my $VersionRequirement = '';
            if ( $ForDocker && $Module->{DockerVersionRequired} ) {
                $VersionRequirement = qq{, '$Module->{DockerVersionRequired}'};
            }
            elsif ( $Module->{VersionRequired} ) {
                $VersionRequirement = qq{, '$Module->{VersionRequired}'};
            }

            say $Indent, "requires '$Module->{Module}'$VersionRequirement;";
            say '';

            next MODULE;
        }

        next MODULE unless $HandleFeatures;
        next MODULE unless $Module->{Features};
        next MODULE unless $Module->{Features};
        next MODULE unless ref $Module->{Features} eq 'ARRAY';

        for my $Feature ( $Module->{Features}->@* ) {
            $ModulesForFeature{$Feature} //= [];
            push $ModulesForFeature{$Feature}->@*, $Module;
        }
    }

    # now print out the features
    FEATURE:
    for my $Feature ( sort keys %ModulesForFeature ) {

        # print empty line for neater output
        say '';

        # When a cpanfile for Docker is generated then filter out the not-needed features
        if ( $ForDocker && !$IsDockerFeature{$Feature} ) {
            say "# Feature '$Feature' is not needed for Docker\n";

            next FEATURE;
        }

        # Don't declare the features in the Docker case
        my $PoundOrEmpty = $ForDocker ? '# ' : '';
        my $Desc         = $FeatureDescription{$Feature} // "Support for feature $Feature";
        say "${PoundOrEmpty}feature '$Feature', '$Desc' => sub {";
        PrintCpanfile( $ModulesForFeature{$Feature}, 0, 0, $ForDocker );
        say "${PoundOrEmpty}};";
    }

    return;
}

exit $ExitCode;
