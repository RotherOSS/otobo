# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Connection;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

=for stopwords TLS

=head1 Run()

This plugin reports information about the database connection. Currently is it only
reported whether the connection is encrypted with TLS.

=cut

sub Run {
    my $Self = shift;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # this plugin is only for 'mysql'
    return $Self->GetResults() unless $DBObject->GetDatabaseFunction('Type') eq 'mysql';

    # find the info in the session status
    my ( undef, $SSLVersion ) = $DBObject->SelectRowArray(
        SQL => q{SHOW SESSION STATUS LIKE 'Ssl_version'},
    );

    # only report as information
    $Self->AddResultInformation(
        Label => Translatable('SSL Version'),
        Value => ( $SSLVersion || 'connection not secured with TLS' ),
    );

    return $Self->GetResults();
}

1;
