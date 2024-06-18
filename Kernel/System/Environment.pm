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

use strict;
use warnings;

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

collect perl information:

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
        PerlVersion => sprintf '%vd',
        $^V,
    );

    if ( $Param{BundledModules} ) {

        # Add bundled modules and their version.
        # Only the modules that correspond to their distribution are listed here.
        # E.g. Error::TypeTiny and Types::TypeTiny are not listed, as they belong to the distro Type::Tiny.
        # Fh is not listed as it belongs to the distro CGI.
        # TODO: list MailTools instead of Mail::Address and Mail::Internet
        # Devel::REPL::Plugin::OTOBO is supplied by OTOBO
        my %ModuleToVersion =
            map { $_ => $Self->ModuleVersionGet( Module => $_ ) }
            qw(
            Algorithm::Diff
            CGI
            Class::Accessor
            Class::Inspector
            Class::ReturnValue
            CPAN::Audit
            CPAN::DistnameInfo
            Data::ICal
            Date::ICal
            Crypt::PasswdMD5
            Crypt::Random::Source
            CSS::Minifier
            Devel::StackTrace
            Email::Valid
            Encode::Locale
            Excel::Writer::XLSX
            Exporter::Tiny
            File::Slurp
            File::Slurp::Tiny
            Font::TTF
            HTML::Scrubber
            HTTP::Message
            IO::Interactive
            IO::String
            JavaScript::Minifier
            JSON
            JSON::PP
            Lingua::Translit
            Linux::Distribution
            Locale::Codes
            LWP
            Mail::Address
            Mail::Internet
            Math::Random::ISAAC
            Math::Random::Secure
            MIME::Tools
            Module::CPANfile
            Module::Find
            Module::Refresh
            Mozilla::CA
            Net::IMAP::Simple
            Net::HTTP
            Net::SSLGlue
            PDF::API2
            Pod::Strip
            REST::Client
            Schedule::Cron::Events
            SOAP::Lite
            Sys::Hostname::Long
            Text::CSV
            Text::Diff
            Type::Tiny
            YAML
            URI
            );
        $EnvPerl{Modules} = \%ModuleToVersion;
    }

    return %EnvPerl;
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
