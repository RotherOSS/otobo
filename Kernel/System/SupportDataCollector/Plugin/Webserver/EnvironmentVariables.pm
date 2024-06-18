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

package Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return join '/', Translatable('Webserver'), Translatable('Environment Variables');
}

sub Run {
    my $Self = shift;

    # Skip the plugin, if the support data collection isn't running in a web request.
    return $Self->GetResults() unless $ENV{GATEWAY_INTERFACE};

    my %Environment = %ENV;

    for my $NotNeededString (
        qw(
            HTTP_REFERER HTTP_CACHE_CONTROL HTTP_COOKIE HTTP_USER_AGENT
            HTTP_ACCEPT_LANGUAGE HTTP_ACCEPT_ENCODING HTTP_ACCEPT
            QUERY_STRING REQUEST_METHOD REQUEST_URI SCRIPT_NAME
            ALLUSERSPROFILE      APPDATA              LOCALAPPDATA   COMMONPROGRAMFILES
            PROGRAMDATA          PROGRAMFILES         PSMODULEPATH   PUBLIC
            SYSTEMDRIVE          SYSTEMROOT           TEMP           WINDIR
            USERPROFILE          REMOTE_PORT
        )
        )
    {
        delete $Environment{$NotNeededString};
    }

    for my $Variable ( sort { $a cmp $b } keys %Environment ) {
        $Self->AddResultInformation(
            Identifier => $Variable,
            Label      => $Variable,
            Value      => $Environment{$Variable},
        );
    }

    return $Self->GetResults();
}

1;
