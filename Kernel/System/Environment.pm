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

package Kernel::System::Environment;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use POSIX qw(uname);
use ExtUtils::MakeMaker;    # makes MM->parse_version available ## no perlimports
use File::Spec ();

# CPAN modules
use Sys::Hostname::Long qw(hostname_long);

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

    my @Data = uname();

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my %OSMap = (
        linux   => 'Linux',
        freebsd => 'FreeBSD',
        openbsd => 'OpenBSD',
    );

    # If used OS is a unixoid system
    my $OSName;
    my $Distribution;
    if ( $^O =~ /linux|unix|netbsd/i ) {

        if ( $^O eq 'linux' ) {

            $MainObject->Require('Linux::Distribution');

            my $DistributionName = Linux::Distribution::distribution_name();

            $Distribution = $DistributionName || 'unknown';

            if ($DistributionName) {

                my $DistributionVersion = Linux::Distribution::distribution_version() || '';

                $OSName = $DistributionName . ' ' . $DistributionVersion;
            }
        }
        elsif ( -e '/etc/issue' ) {

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
            'Comment'         => 'Needed by Text::Diff',
            'Module'          => 'Algorithm::Diff',
            'Required'        => 1,
            'VersionRequired' => '== 1.1903',
        },
        ...
    );

=cut

sub BundleModulesDeclarationGet {
    my ($Self) = @_;

    return (
        {
            'Comment'         => 'Needed by Text::Diff',
            'Module'          => 'Algorithm::Diff',
            'Required'        => 1,
            'VersionRequired' => '== 1.1903',
        },
        {
            'Comment'         => 'needed by e.g. Data::ICal, but not used by OTOBO itself',
            'Module'          => 'Class::Accessor',
            'Required'        => 1,
            'VersionRequired' => '== 0.34',
        },
        {
            'Comment'         => 'needed by SOAP::Lite',
            'Module'          => 'Class::Inspector',
            'Required'        => 1,
            'VersionRequired' => '== 1.31'
        },
        {
            'Comment'         => 'needed by Data::ICal',
            'Module'          => 'Class::ReturnValue',
            'Required'        => 1,
            'VersionRequired' => '== 0.55',
        },
        {
            'Module'          => 'CPAN::Audit',
            'Required'        => 1,
            'VersionRequired' => '== 20240718.001',
        },
        {
            'Comment'         => 'needed by CPAN::Audit',
            'Module'          => 'CPAN::DistnameInfo',
            'Required'        => 1,
            'VersionRequired' => '== 0.12',
        },
        {
            'Module'          => 'Crypt::PasswdMD5',
            'Required'        => 1,
            'VersionRequired' => '== 1.40',
        },
        {
            'Comment'         => 'needed by Math::Random::Secure, needed in Kernel::System::Main',
            'Module'          => 'Crypt::Random::Source',
            'Required'        => 1,
            'VersionRequired' => '== 0.14',
        },
        {
            'Module'          => 'Data::ICal',
            'Required'        => 1,
            'VersionRequired' => '== 0.22',
        },
        {
            'Module'          => 'Date::ICal',
            'Required'        => 1,
            'VersionRequired' => '== 2.678',
        },
        {
            'Comment'         => 'needed by Kernel::System::CheckItem',
            'Module'          => 'Email::Valid',
            'Required'        => 1,
            'VersionRequired' => '== 1.202',
        },
        {
            'Comment'         => 'needed by Kernel::System::CSV',
            'Module'          => 'Excel::Writer::XLSX',
            'Required'        => 1,
            'VersionRequired' => '== 0.95',
        },
        {
            'Comment'         => 'needed by Type::Tiny',
            'Module'          => 'Exporter::Tiny',
            'Required'        => 1,
            'VersionRequired' => '== 1.002001',
        },
        {
            'Comment'         => 'needed by Text::Diff::FormattedHTML ',
            'Module'          => 'File::Slurp',
            'Required'        => 1,
            'VersionRequired' => '== 9999.32',
        },
        {
            'Comment'         => 'needed by PDF::API2',
            'Module'          => 'Font::TTF',
            'Required'        => 1,
            'VersionRequired' => '== 1.06',
        },
        {
            'Comment'         => 'needed by HTMLUtils, contains adaption by OTOBO',
            'Module'          => 'HTML::Scrubber',
            'Required'        => 1,
            'VersionRequired' => '== 0.20',
        },
        {
            'Comment'         => 'needed by console commands',
            'Module'          => 'IO::Interactive',
            'Required'        => 1,
            'VersionRequired' => '== 1.022',
        },
        {
            'Comment'         => 'needed by Font::TTF',
            'Module'          => 'IO::String',
            'Required'        => 1,
            'VersionRequired' => '== 1.08',
        },
        {
            'Comment'         => 'needed by Sisimai',
            'Module'          => 'JSON',
            'Required'        => 1,
            'VersionRequired' => '== 2.94',
        },
        {
            'Comment'         => 'needed by JSON, but there also in backportPP included in JSON',
            'Module'          => 'JSON::PP',
            'Required'        => 1,
            'VersionRequired' => '== 2.27203',
        },
        {
            'Comment'         => 'needed by the console command Dev::Tools::TranslationsUpdate',
            'Module'          => 'Lingua::Translit',
            'Required'        => 1,
            'VersionRequired' => '== 0.27',
        },
        {
            'Comment'         => 'needed by otobo.CheckModules.pl',
            'Module'          => 'Linux::Distribution',
            'Required'        => 1,
            'VersionRequired' => '== 0.23',
        },
        {
            'Comment'         => 'needed by Kernel::System::ReferenceData, Locale::Country',
            'Module'          => 'Locale::Codes',
            'Required'        => 1,
            'VersionRequired' => '== 3.76',
        },
        {
            'Comment'         => 'needed by webservices',
            'Module'          => 'LWP::Protocol::https',
            'Required'        => 1,
            'VersionRequired' => '== 6.11',
        },
        {
            'Comment'         => 'needed in frontend and system OTOBO modules',
            'Module'          => 'Mail::Address',
            'Required'        => 1,
            'VersionRequired' => '== 2.18',
        },
        {
            'Comment'         => 'needed by Kernel::System::Mail',
            'Module'          => 'Mail::Internet',
            'Required'        => 1,
            'VersionRequired' => '== 2.18',
        },
        {
            'Comment'         => 'needed by Math::Random::Secure, needed in Kernel::System::Main',
            'Module'          => 'Math::Random::ISAAC',
            'Required'        => 1,
            'VersionRequired' => '== 1.004',
        },
        {
            'Comment'         => 'needed by Kernel::System::Main for GenerateRandomString()',
            'Module'          => 'Math::Random::Secure',
            'Required'        => 1,
            'VersionRequired' => '== 0.080001',
        },
        {
            'Comment'         => 'needed by Kernel::System::Mail',
            'Module'          => 'MIME::Tools',
            'Required'        => 1,
            'VersionRequired' => '== 5.514',
        },
        {
            'Comment'         => 'needed by CPAN::Audit',
            'Module'          => 'Module::CPANfile',
            'Required'        => 1,
            'VersionRequired' => '== 1.1004',
        },
        {
            'Comment'         => 'needed by CPAN::Audit, could be useful in OTOBO as well',
            'Module'          => 'Module::Extract::VERSION',
            'Required'        => 1,
            'VersionRequired' => '== 1.117',
        },
        {
            'Comment'         => 'needed by Crypt::Random::Source',
            'Module'          => 'Module::Find',
            'Required'        => 1,
            'VersionRequired' => '== 0.15',
        },
        {
            'Comment'         => 'needed by otobo.psgi',
            'Module'          => 'Module::Refresh',
            'Required'        => 1,
            'VersionRequired' => '== 0.17',
        },
        {
            'Comment'         => 'needed by LWP::Protocol::https',
            'Module'          => 'Mozilla::CA',
            'Required'        => 1,
            'VersionRequired' => '== 20200520',
        },
        {
            'Comment'         => 'needed by LWP::Protocol::https',
            'Module'          => 'Net::HTTP',
            'Required'        => 1,
            'VersionRequired' => '== 6.17',
        },
        {
            'Comment'         => 'needed by Kernel::System::MailAccount::IMAP',
            'Module'          => 'Net::IMAP::Simple',
            'Required'        => 1,
            'VersionRequired' => '== 1.2209',
        },
        {
            'Comment'         => 'needed by OTOBO email modules',
            'Module'          => 'Net::SSLGlue',
            'Required'        => 1,
            'VersionRequired' => '== 1.058',
        },
        {
            'Comment'         => 'needed by Kernel::System::PDF',
            'Module'          => 'PDF::API2',
            'Required'        => 1,
            'VersionRequired' => '== 2.045',
        },
        {
            'Comment'         => 'needed by console command Dev::Tools::TranslationsUpdate',
            'Module'          => 'Pod::Strip',
            'Required'        => 1,
            'VersionRequired' => '== 1.02',
        },
        {
            'Comment'         => 'needed by OTOBO generic interface',
            'Module'          => 'REST::Client',
            'Required'        => 1,
            'VersionRequired' => '== 273',
        },
        {
            'Comment'         => 'needed by Kernel::System::CronEvent',
            'Module'          => 'Schedule::Cron::Events',
            'Required'        => 1,
            'VersionRequired' => '== 1.95',
        },
        {
            'Module'          => 'needed for detecting bounced mails',
            'Module'          => 'Sisimai',
            'Required'        => 1,
            'VersionRequired' => '== v4.24.1'
        },
        {
            'Comment'         => 'needed by OTOBO generic interface',
            'Module'          => 'SOAP::Lite',
            'Required'        => 1,
            'VersionRequired' => '== 1.20',
        },
        {
            'Comment'         => 'needed by Kernel::System::Environment',
            'Module'          => 'Sys::Hostname::Long',
            'Required'        => 1,
            'VersionRequired' => '== 1.5',
        },
        {
            'Comment'         => 'needed by Kernel::System::Diff',
            'Module'          => 'Text::Diff',
            'Required'        => 1,
            'VersionRequired' => '== 1.44',
        },
        {
            'Comment'         => 'needed by Kernel::System::Diff',
            'Module'          => 'Text::Diff::FormattedHTML',
            'Required'        => 1,
            'VersionRequired' => '== 0.08',
        },
        {
            'Comment'         => 'needed by Crypt::Random::Source',
            'Module'          => 'Type::Tiny',
            'Required'        => 1,
            'VersionRequired' => '== 1.010000',
        },
        {
            'Comment'         => 'needed by Kernel::Output::HTML::Dashboard::RSS',
            'Module'          => 'XML::FeedPP',
            'Required'        => 1,
            'VersionRequired' => '== 0.43',
        },
        {
            'Comment'         => 'needed by Kernel::System::XML::Simple',
            'Module'          => 'XML::LibXML::Simple',
            'Required'        => 1,
            'VersionRequired' => '== 1.01',
        },
        {
            'Comment'         => 'needed by Kernel::GenericInterface::Mapping::XSLT',
            'Module'          => 'XML::Simple',
            'Required'        => 1,
            'VersionRequired' => '== 2.25',
        },
        {
            'Comment'         => 'needed by XML::FeedPP',
            'Module'          => 'XML::TreePP',
            'Required'        => 1,
            'VersionRequired' => '== 0.43',
        },
        {
            'Comment'         => 'needed by Sisimai, OTOBO itself uses YAML::XS',
            'Module'          => 'YAML',
            'Required'        => 1,
            'VersionRequired' => '== 1.30',
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
