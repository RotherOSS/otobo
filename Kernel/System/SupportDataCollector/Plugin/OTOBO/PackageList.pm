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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageList;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CSV',
    'Kernel::System::Package',
);

sub GetDisplayPath {
    return Translatable('OTOBO') . '/' . Translatable('Package List');
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # get needed objects
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $CSVObject     = $Kernel::OM->Get('Kernel::System::CSV');

    my @PackageList = $PackageObject->RepositoryList( Result => 'Short' );

    for my $Package (@PackageList) {

        my @PackageData = (
            [
                $Package->{Name},
                $Package->{Version},
                $Package->{MD5sum},
                $Package->{Vendor},
            ],
        );

        # use '-' (minus) as separator otherwise the line will not wrap and will not be totally
        #   visible
        my $Message = $CSVObject->Array2CSV(
            Data      => \@PackageData,
            Separator => '-',
            Quote     => "'",
        );

        # remove the new line character, otherwise it does not play good with output translations
        chomp $Message;

        $Self->AddResultInformation(
            Identifier => $Package->{Name},
            Label      => $Package->{Name},
            Value      => $Package->{Version},
            Message    => $Message,
        );
    }

    # if no packages where found we should not add any result, otherwise the table will be
    #   have that row instead of output just the label and a message of not packages found

    return $Self->GetResults();
}

1;
