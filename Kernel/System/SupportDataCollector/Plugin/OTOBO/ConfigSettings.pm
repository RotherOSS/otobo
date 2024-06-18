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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::ConfigSettings;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTOBO') . '/' . Translatable('Config Settings');
}

sub Run {
    my $Self = shift;

    my @Settings = (
        'Home',
        'FQDN',
        'HttpType',
        'DefaultLanguage',
        'SystemID',
        'Version',
        'ProductName',
        'Organization',
        'OTOBOTimeZone',
        'Ticket::IndexModule',
        'Ticket::SearchIndexModule',
        'Ticket::Article::Backend::MIMEBase::ArticleStorage',
        'SendmailModule',
        'Frontend::RichText',
        'Frontend::AvatarEngine',
        'Loader::Agent::DefaultSelectedSkin',
        'Loader::Customer::SelectedSkin',
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    for my $Setting (@Settings) {

        my $ConfigValue = $ConfigObject->Get($Setting);

        if ( $Setting =~ m{###} ) {
            my ( $Name, $SubKey ) = $Setting =~ m{(.*)###(.*)};
            $ConfigValue = $ConfigObject->Get($Name);
            $ConfigValue = $ConfigValue->{$SubKey} if ref $ConfigValue eq 'HASH';
        }

        if ( defined $ConfigValue ) {
            $Self->AddResultInformation(
                Identifier => $Setting,
                Label      => $Setting,
                Value      => $ConfigValue,
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => $Setting,
                Label      => $Setting,
                Value      => $ConfigValue,
                Message    => Translatable('Could not determine value.'),
            );
        }
    }

    return $Self->GetResults();
}

1;
