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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Package',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    # get package object
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my @InvalidPackages;
    my @NotVerifiedPackages;
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

        my $Verified = $PackageObject->PackageVerify(
            Package => $PackageContent,
            Name    => $Package->{Name}->{Content},
        ) || 'unknown';

        if ( $Verified ne 'verified' ) {
            push @NotVerifiedPackages, "$Package->{Name}->{Content} $Package->{Version}->{Content}";
        }

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

    if (@InvalidPackages) {
        if ( $Kernel::OM->Get('Kernel::Config')->Get('Package::AllowLocalModifications') ) {
            $Self->AddResultInformation(
                Label   => Translatable('Package Installation Status'),
                Value   => join( ', ', @InvalidPackages ),
                Message => Translatable('Some packages have locally modified files.'),
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => Translatable('Package Installation Status'),
                Value   => join( ', ', @InvalidPackages ),
                Message => Translatable('Some packages are not correctly installed.'),
            );
        }
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Package Installation Status'),
            Value => '',
        );
    }

    if (@NotVerifiedPackages) {
        if ( $Kernel::OM->Get('Kernel::Config')->Get('Package::AllowLocalModifications') ) {
            $Self->AddResultInformation(
                Identifier => 'Verification',
                Label      => Translatable('Package Verification Status'),
                Value      => join( ', ', @NotVerifiedPackages ),
                Message    => Translatable(
                    'Some packages are not verified by the OTOBO Team.'
                ),
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'Verification',
                Label      => Translatable('Package Verification Status'),
                Value      => join( ', ', @NotVerifiedPackages ),
                Message    => Translatable(
                    'Some packages are not verified by the OTOBO Team.'
                ),
            );
        }
    }
    else {
        $Self->AddResultOk(
            Identifier => 'Verification',
            Label      => Translatable('Package Verification Status'),
            Value      => '',
        );
    }

    if (@WrongFrameworkVersion) {
        if ( $Kernel::OM->Get('Kernel::Config')->Get('Package::AllowLocalModifications') ) {
            $Self->AddResultInformation(
                Identifier => 'FrameworkVersion',
                Label      => Translatable('Package Framework Version Status'),
                Value      => join( ', ', @WrongFrameworkVersion ),
                Message    => Translatable('Some packages are not allowed for the current framework version.'),
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'FrameworkVersion',
                Label      => Translatable('Package Framework Version Status'),
                Value      => join( ', ', @WrongFrameworkVersion ),
                Message    => Translatable('Some packages are not allowed for the current framework version.'),
            );
        }
    }
    else {
        $Self->AddResultOk(
            Identifier => 'FrameworkVersion',
            Label      => Translatable('Package Framework Version Status'),
            Value      => '',
        );
    }

    return $Self->GetResults();
}

1;
