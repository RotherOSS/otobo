# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Environment;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use POSIX;
use ExtUtils::MakeMaker;

# CPAN modules
use Sys::Hostname::Long;    # imports hostname_long()

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::Environment - collect environment info

=head1 DESCRIPTION

Functions to collect environment info

=head1 PUBLIC INTERFACE

=head2 new()

create environment object. Do not use it directly, instead use:

    my $EnvironmentObject = $Kernel::OM->Get('Kernel::System::Environment');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 OSInfoGet()

collect operating system information

    my %OSInfo = $EnvironmentObject->OSInfoGet();

returns:

    %OSInfo = (
        Distribution => "debian",
        Hostname     => "servername.example.com",
        OS           => "Linux",
        OSName       => "debian 7.1",
        Path         => "/home/otobo/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games",
        POSIX        => [
                        "Linux",
                        "servername",
                        "3.2.0-4-686-pae",
                        "#1 SMP Debian 3.2.46-1",
                        "i686",
                      ],
        User         => "otobo",
    );

=cut

sub OSInfoGet {
    my ( $Self, %Param ) = @_;

    my @Data = POSIX::uname();

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my %OSMap = (
        linux   => 'Linux',
        freebsd => 'FreeBSD',
        openbsd => 'OpenBSD',
    );

    # If used OS is a linux system
    my $OSName;
    my $Distribution;
    if ( $^O =~ /(linux|unix|netbsd)/i ) {

        if ( $^O eq 'linux' ) {

            $MainObject->Require('Linux::Distribution');

            my $DistributionName = Linux::Distribution::distribution_name();

            $Distribution = $DistributionName || 'unknown';

            if ($DistributionName) {

                my $DistributionVersion = Linux::Distribution::distribution_version() || '';

                $OSName = $DistributionName . ' ' . $DistributionVersion;
            }
        }
        elsif ( -e "/etc/issue" ) {

            my $Content = $MainObject->FileRead(
                Location => '/etc/issue',
                Result   => 'ARRAY',
            );

            if ($Content) {
                $OSName = $Content->[0];
            }
        }
    }
    elsif ( $^O eq 'freebsd' || $^O eq 'openbsd' ) {

        my $BSDVersion = `uname -r` || '';
        chomp $BSDVersion;

        $OSName = "$OSMap{$^O} $BSDVersion";
    }

    my $User = getlogin || getpwuid($<) || $ENV{USER} || $ENV{USERNAME};

    # collect OS data
    my %EnvOS = (
        Hostname     => hostname_long(),
        OSName       => $OSName || 'Unknown version',
        Distribution => $Distribution,
        User         => $User,
        Path         => $ENV{PATH},
        HostType     => $ENV{HOSTTYPE},
        LcCtype      => $ENV{LC_CTYPE},
        Cpu          => $ENV{CPU},
        MachType     => $ENV{MACHTYPE},
        POSIX        => \@Data,
        OS           => $OSMap{$^O} || $^O,
    );

    return %EnvOS;
}

=head2 ModuleVersionGet()

Return the version of an installed perl module:

    my $Version = $EnvironmentObject->ModuleVersionGet(
        Module => 'MIME::Parser',
    );

returns

    $Version = '5.503';

or undef if the module is not installed.

=cut

sub ModuleVersionGet {
    my ( $Self, %Param ) = @_;

    my $File = "$Param{Module}.pm";
    $File =~ s{::}{/}g;

    # traverse @INC to see if the current module is installed in
    # one of these locations
    my $Path;
    PATH:
    for my $Dir (@INC) {

        my $PossibleLocation = File::Spec->catfile( $Dir, $File );

        next PATH if !-r $PossibleLocation;

        $Path = $PossibleLocation;

        last PATH;
    }

    # if we have no $Path the module is not installed
    return if !$Path;

    # determine version number by means of ExtUtils::MakeMaker
    return MM->parse_version($Path);
}

=head2 PerlInfoGet()

collect Perl information:

    my %PerlInfo = $EnvironmentObject->PerlInfoGet();

you can also specify options:

    my %PerlInfo = $EnvironmentObject->PerlInfoGet(
        BundledModules => 1,
    );

returns:

    %PerlInfo = (
        PerlVersion   => "5.14.2",

    # if you specified 'BundledModules => 1' you'll also get this:

        Modules => {
            "Algorithm::Diff"  => "1.30",
            ...
        },
    );

=cut

sub PerlInfoGet {
    my ( $Self, %Param ) = @_;

    # collect perl data
    my %EnvPerl = (
        PerlVersion => sprintf( '%vd', $^V ),
    );

    if ( $Param{BundledModules} ) {

        # Add bundled modules and their version.
        # Only the modules that correspond to their distribution are listed here.
        # E.g. Error::TypeTiny and Types::TypeTiny are not listed, as they belong to the distro Type::Tiny.
        # Devel::REPL::Plugin::OTOBO is supplied by OTOBO
        my @BundledModules = Kernel::System::Environment->BundleModulesDeclarationGet;
        my %ModuleToVersion =
            map { $_ => $Self->ModuleVersionGet( Module => $_ ) }
            map { $_->{Module} }
            @BundledModules;
        $EnvPerl{Modules} = \%ModuleToVersion;
    }

    return %EnvPerl;
}

=head2 BundleModulesDeclarationGet()

This returns the declaration of the modules that should be installed in C<Kernel/cpan-lib>.
This list can be used as a reference for reporting and for generating a CPAN file.

    my @BundledModules = $EnvironmentObject->BundleModulesDeclarationGet();

returns list of hashrefs:

    my @BundledModules = (
        {
            'Module'       => 'Algorithm::Diff',
            'Required'     => 1,
            'VersionExact' => '1.1903',
        },
        ...
    );

=cut

sub BundleModulesDeclarationGet {
    my ($Self) = @_;

    return (
        {
            'Comment'      => 'Needed by Text::Diff',
            'Module'       => 'Algorithm::Diff',
            'Required'     => 1,
            'VersionExact' => '1.1903',
        },
        {
            'Comment'      => 'needed by e.g. Data::ICal, but not used by OTOBO itself',
            'Module'       => 'Class::Accessor',
            'Required'     => 1,
            'VersionExact' => '0.34',
        },
        {
            'Module'       => 'Class::Inspector',
            'Required'     => 1,
            'VersionExact' => '1.31'
        },
        {
            'Module'       => 'Class::ReturnValue',
            'Required'     => 1,
            'VersionExact' => '0.55',
        },
        {
            'Module'       => 'CPAN::Audit',
            'Required'     => 1,
            'VersionExact' => '20230826.001',
        },
        {
            'Module'       => 'CPAN::DistnameInfo',
            'Required'     => 1,
            'VersionExact' => '0.12',
        },
        {
            'Module'       => 'Data::ICal',
            'Required'     => 1,
            'VersionExact' => '0.22',
        },
        {
            'Module'       => 'Date::ICal',
            'Required'     => 1,
            'VersionExact' => '2.678',
        },
        {
            'Module'       => 'Crypt::PasswdMD5',
            'Required'     => 1,
            'VersionExact' => '1.40',
        },
        {
            'Module'       => 'Crypt::Random::Source',
            'Required'     => 1,
            'VersionExact' => '0.14',
        },
        {
            'Module'       => 'CSS::Minifier',
            'Required'     => 1,
            'VersionExact' => '0.01',
        },
        {
            'Module'       => 'Devel::StackTrace',
            'Required'     => 1,
            'VersionExact' => '2.02',
        },
        {
            'Module'       => 'Email::Valid',
            'Required'     => 1,
            'VersionExact' => '1.202',
        },
        {
            'Module'       => 'Encode::Locale',
            'Required'     => 1,
            'VersionExact' => '1.05',
        },
        {
            'VersionExact' => '0.95',
            'Module'       => 'Excel::Writer::XLSX',
            'Required'     => 1,
        },
        {
            'Required'     => 1,
            'Module'       => 'Exporter::Tiny',
            'VersionExact' => '1.002001',
        },
        {
            'Module'       => 'File::Slurp',
            'Required'     => 1,
            'VersionExact' => '9999.32',
        },
        {
            'VersionExact' => '1.06',
            'Module'       => 'Font::TTF',
            'Required'     => 1,
        },
        {
            'Required'     => 1,
            'Module'       => 'HTTP::Date',
            'VersionExact' => '6.02',
        },
        {
            'Required'     => 1,
            'Module'       => 'HTTP::Message',
            'VersionExact' => '6.13',
        },
        {
            'Required'     => 1,
            'Module'       => 'IO::Interactive',
            'VersionExact' => '1.022',
        },
        {
            'Module'       => 'IO::String',
            'Required'     => 1,
            'VersionExact' => '1.08',
        },
        {
            'VersionExact' => '1.16',
            'Required'     => 1,
            'Module'       => 'JavaScript::Minifier'
        },
        {
            'VersionExact' => '2.94',
            'Required'     => 1,
            'Module'       => 'JSON'
        },
        {
            'Required'     => 1,
            'Module'       => 'JSON::PP',
            'VersionExact' => '2.27203',
        },
        {
            'Required'     => 1,
            'Module'       => 'Lingua::Translit',
            'VersionExact' => '0.27',
        },
        {
            'VersionExact' => '0.23',
            'Module'       => 'Linux::Distribution',
            'Required'     => 1,
        },
        {
            'VersionExact' => '3.69',
            'Module'       => 'Locale::Codes',
            'Required'     => 1,
        },
        {
            'Module'       => 'LWP::Protocol::https',
            'Required'     => 1,
            'VersionExact' => '6.11',
        },
        {
            'Required'     => 1,
            'Module'       => 'Mail::Address',
            'VersionExact' => '2.18',
        },
        {
            'VersionExact' => '2.18',
            'Module'       => 'Mail::Internet',
            'Required'     => 1,
        },
        {
            'Module'       => 'Math::Random::ISAAC',
            'Required'     => 1,
            'VersionExact' => '1.004',
        },
        {
            'Module'       => 'Math::Random::Secure',
            'Required'     => 1,
            'VersionExact' => '0.080001',
        },
        {
            'Module'       => 'MIME::Tools',
            'Required'     => 1,
            'VersionExact' => '5.509',
        },
        {
            'Module'       => 'Module::CPANfile',
            'Required'     => 1,
            'VersionExact' => '1.1004',
        },
        {
            'Comment'      => 'needed by CPAN::Audit, could be useful in OTOBO as well',
            'Module'       => 'Module::Extract::VERSION',
            'Required'     => 1,
            'VersionExact' => '1.116',
        },
        {
            'Module'       => 'Module::Find',
            'Required'     => 1,
            'VersionExact' => '0.15',
        },
        {
            'VersionExact' => '0.17',
            'Module'       => 'Module::Refresh',
            'Required'     => 1,
        },
        {
            'VersionExact' => '20200520',
            'Required'     => 1,
            'Module'       => 'Mozilla::CA'
        },
        {
            'Required'     => 1,
            'Module'       => 'Net::IMAP::Simple',
            'VersionExact' => '1.2209',
        },
        {
            'VersionExact' => '6.17',
            'Required'     => 1,
            'Module'       => 'Net::HTTP',
        },
        {
            'Required'     => 1,
            'Module'       => 'Net::SSLGlue',
            'VersionExact' => '1.058',
        },
        {
            'Module'       => 'PDF::API2',
            'Required'     => 1,
            'VersionExact' => '2.033',
        },
        {
            'VersionExact' => '1.02',
            'Module'       => 'Pod::Strip',
            'Required'     => 1,
        },
        {
            'VersionExact' => '273',
            'Module'       => 'REST::Client',
            'Required'     => 1,
        },
        {
            'Required'     => 1,
            'Module'       => 'Schedule::Cron::Events',
            'VersionExact' => '1.95',
        },
        {
            'Module'       => 'Sisimai',
            'Required'     => 1,
            'VersionExact' => 'v4.24.1',
        },
        {
            'Module'       => 'Sisimai',
            'Required'     => 1,
            'VersionExact' => 'v4.24.1'
        },
        {
            'Module'       => 'SOAP::Lite',
            'Required'     => 1,
            'VersionExact' => '1.20',
        },
        {
            'VersionExact' => '1.5',
            'Required'     => 1,
            'Module'       => 'Sys::Hostname::Long'
        },
        {
            'VersionExact' => '1.95',
            'Required'     => 1,
            'Module'       => 'Text::CSV',
        },
        {
            'Module'       => 'Text::Diff',
            'Required'     => 1,
            'VersionExact' => '1.44',
        },
        {
            'Module'       => 'Text::Diff::FormattedHTML',
            'Required'     => 1,
            'VersionExact' => '0.08',
        },
        {
            'Required'     => 1,
            'Module'       => 'Type::Tiny',
            'VersionExact' => '1.010000',
        },
        {
            'Module'       => 'XML::FeedPP',
            'Required'     => 1,
            'VersionExact' => '0.43',
        },
        {
            'Module'       => 'XML::LibXML::Simple',
            'Required'     => 1,
            'VersionExact' => '1.01',
        },
        {
            'Module'       => 'XML::Simple',
            'Required'     => 1,
            'VersionExact' => '2.25',
        },
        {
            'Module'       => 'XML::TreePP',
            'Required'     => 1,
            'VersionExact' => '0.43',
        },
        {
            'VersionExact' => '1.30',
            'Module'       => 'YAML',
            'Required'     => 1,
        }
    );
}

=head2 DBInfoGet()

collect database information

    my %DBInfo = $EnvironmentObject->DBInfoGet();

returns

    %DBInfo = (
        Database => "otoboproduction",
        Host     => "dbserver.example.com",
        User     => "otobouser",
        Type     => "mysql",
        Version  => "MySQL 5.5.31-0+wheezy1",
    )

=cut

sub DBInfoGet {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');

    # collect DB data
    my %EnvDB = (
        Host     => $ConfigObject->Get('DatabaseHost'),
        Database => $ConfigObject->Get('Database'),
        User     => $ConfigObject->Get('DatabaseUser'),
        Type     => $ConfigObject->Get('Database::Type') || $DBObject->{'DB::Type'},
        Version  => $DBObject->Version(),
    );

    return %EnvDB;
}

=head2 OTOBOInfoGet()

collect OTOBO information

    my %OTOBOInfo = $EnvironmentObject->OTOBOInfoGet();

returns:

    %OTOBOInfo = (
        Product         => "OTOBO",
        Version         => "3.3.1",
        DefaultLanguage => "en",
        Home            => "/opt/otobo",
        Host            => "otobo.example.org",
        SystemID        => 70,
    );

=cut

sub OTOBOInfoGet {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # collect OTOBO data
    my %EnvOTOBO = (
        Version         => $ConfigObject->Get('Version'),
        Home            => $ConfigObject->Get('Home'),
        Host            => $ConfigObject->Get('FQDN'),
        Product         => $ConfigObject->Get('Product'),
        SystemID        => $ConfigObject->Get('SystemID'),
        DefaultLanguage => $ConfigObject->Get('DefaultLanguage'),
    );

    return %EnvOTOBO;
}

1;
