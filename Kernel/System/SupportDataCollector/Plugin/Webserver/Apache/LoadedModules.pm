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

package Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::LoadedModules;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Webserver') . '/' . Translatable('Loaded Apache Modules');
}

sub Run {
    my $Self = shift;

    # No web request or no apache webserver with mod_perl, skip this check.
    # Using ENV is OK in this context
    if (
        !$ENV{GATEWAY_INTERFACE}
        || !$ENV{SERVER_SOFTWARE}
        || $ENV{SERVER_SOFTWARE} !~ m{apache}i
        || !$ENV{MOD_PERL}
        || !eval { require Apache2::Module; }
        )
    {
        return $Self->GetResults();
    }

    for ( my $Module = Apache2::Module::top_module(); $Module; $Module = $Module->next() ) {
        $Self->AddResultInformation(
            Identifier => $Module->name(),
            Label      => $Module->name(),
            Value      => $Module->ap_api_major_version() . '.' . $Module->ap_api_minor_version(),
        );
    }

    return $Self->GetResults();
}

1;
