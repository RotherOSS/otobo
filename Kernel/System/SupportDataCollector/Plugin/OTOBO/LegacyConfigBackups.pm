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

## nofilter(TidyAll::Plugin::OTOBO::Perl::LayoutObject)
package Kernel::System::SupportDataCollector::Plugin::OTOBO::LegacyConfigBackups;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Package',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $BackupsFolder = "$Home/Kernel/Config/Backups";

    my @BackupFiles;

    if ( -d $BackupsFolder ) {
        @BackupFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $BackupsFolder,
            Filter    => '*',
        );
    }

    if ( !@BackupFiles ) {
        $Self->AddResultOk(
            Label   => Translatable('Legacy Configuration Backups'),
            Value   => 0,
            Message => Translatable('No legacy configuration backup files found.'),
        );
        return $Self->GetResults();
    }

    # get package object
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my @InvalidPackages;
    my @WrongFrameworkVersion;
    for my $Package ( $PackageObject->RepositoryList() ) {

        my $DeployCheck = $PackageObject->DeployCheck(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
        );
        if ( !$DeployCheck ) {
            push @InvalidPackages, "$Package->{Name}->{Content} $Package->{Version}->{Content}";
        }

        # get package
        my $PackageContent = $PackageObject->RepositoryGet(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
            Result  => 'SCALAR',
        );

        my %PackageStructure = $PackageObject->PackageParse(
            String => $PackageContent,
        );

        my %CheckFramework = $PackageObject->AnalyzePackageFrameworkRequirements(
            Framework => $PackageStructure{Framework},
            NoLog     => 1,
        );

        if ( !$CheckFramework{Success} ) {
            push @WrongFrameworkVersion, "$Package->{Name}->{Content} $Package->{Version}->{Content}";
        }
    }

    if ( @InvalidPackages || @WrongFrameworkVersion ) {
        $Self->AddResultOk(
            Label   => Translatable('Legacy Configuration Backups'),
            Value   => scalar @BackupFiles,
            Message => Translatable(
                'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.'
            ),
        );
        return $Self->GetResults();
    }

    $Self->AddResultWarning(
        Label   => Translatable('Legacy Configuration Backups'),
        Value   => scalar @BackupFiles,
        Message => Translatable(
            'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.'
        ),
    );
    return $Self->GetResults();
}

1;
