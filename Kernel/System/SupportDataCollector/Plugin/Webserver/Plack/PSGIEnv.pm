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

package Kernel::System::SupportDataCollector::Plugin::Webserver::Plack::PSGIEnv;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
);
our @SoftObjectDependencies = (
    'Kernel::System::Web::Request',
);

sub GetDisplayPath {
    return join '/', Translatable('Webserver'), Translatable('PSGI Environment');
}

sub Run {
    my $Self = shift;

    # No web request or no Plack based webserver skip this check.
    return $Self->GetResults() if !$ENV{GATEWAY_INTERFACE};
    return $Self->GetResults() if !$ENV{OTOBO_RUNS_UNDER_PSGI};

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    return $Self->GetResults() if !$ParamObject->{Query};
    return $Self->GetResults() if !$ParamObject->{Query}->can('env');

    # Accessing the Query attribute directly is a bit hackish
    my $PSGIEnv      = $ParamObject->{Query}->env();
    my %KeyIsIgnored = map { $_ => 1 } qw(
        HTTP_REFERER
        HTTP_CACHE_CONTROL
        HTTP_COOKIE
        HTTP_USER_AGENT
        HTTP_ACCEPT_LANGUAGE
        HTTP_ACCEPT_ENCODING
        HTTP_ACCEPT
        QUERY_STRING
        REQUEST_METHOD REQUEST_URI
        SCRIPT_NAME
        REMOTE_PORT
        ALLUSERSPROFILE      APPDATA        LOCALAPPDATA   COMMONPROGRAMFILES
        PROGRAMDATA          PROGRAMFILES   PSMODULEPATH   PUBLIC
        SYSTEMDRIVE          SYSTEMROOT     TEMP           WINDIR
        USERPROFILE
    );

    KEY:
    for my $Key ( sort { $a cmp $b } grep { !$KeyIsIgnored{$_} } keys $PSGIEnv->%* ) {

        # avoid confusing stringification
        next KEY if ref $PSGIEnv->{$Key};

        $Self->AddResultInformation(
            Identifier => $Key,
            Label      => $Key,
            Value      => $PSGIEnv->{$Key},
        );
    }

    return $Self->GetResults();
}

1;
