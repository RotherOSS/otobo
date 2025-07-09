# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package scripts::DBUpdateTo11_1::DBUpdateOIDC;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use List::Util qw(any);

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_1::DBUpdateOIDC - And OIDC tables for OAuth2

=cut

use parent qw(scripts::DBUpdateTo11_1::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    # check if this needs to be executed
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    $DBObject->Prepare(
        SQL   => "SELECT * FROM oidc_profiles",
        Limit => 10
    );

    my @Names = $DBObject->GetColumnNames();
    if ( any { $_ eq 'valid_id' } @Names ) {
        return 1;
    }

    # one statement per column, so that an already existing column does not abort the update
    my @XMLStrings;

    # new column
    push @XMLStrings, <<'END_XML';
        <TableCreate Name="oidc_profiles">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
            <Column Name="name" Required="true" Size="256" Type="VARCHAR" />
            <Column Name="client_id" Required="true" Size="1024" Type="VARCHAR" />
            <Column Name="client_secret" Required="true" Size="2048" Type="VARCHAR" />
            <Column Name="redirect_uri" Required="true" Size="4096" Type="VARCHAR" />
            <Column Name="openid_config" Required="true" Size="4096" Type="VARCHAR" />
            <Column Name="ssl_options" Required="true" Size="2048" Type="VARCHAR" />
            <Column Name="misc" Required="true" Size="4096" Type="VARCHAR" />
            <Column Name="ttl" Required="true" Type="INTEGER" />
            <Column Name="create_time" Required="true" Type="DATE" />
            <Column Name="create_by" Required="true" Type="INTEGER" />
            <Column Name="change_time" Required="true" Type="DATE" />
            <Column Name="change_by" Required="true" Type="INTEGER" />
            <Column Name="valid_id" Required="true" Type="SMALLINT" />
            <Unique Name="oidc_profiles_name">
                <UniqueColumn Name="name" />
            </Unique>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id" />
            </ForeignKey>
            <ForeignKey ForeignTable="users">
                <Reference Local="change_by" Foreign="id" />
            </ForeignKey>
            <ForeignKey ForeignTable="valid">
                <Reference Local="valid_id" Foreign="id" />
            </ForeignKey>
        </TableCreate>
END_XML
    push @XMLStrings, <<'END_XML';
        <TableCreate Name="oidc_functional_accounts">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
            <Column Name="name" Required="true" Size="256" Type="VARCHAR" />
            <Column Name="oidc_profile_id" Required="true" Type="INTEGER" />
            <Column Name="grant_type" Required="true" Size="128" Type="VARCHAR" />
            <Column Name="scopes" Required="true" Size="4096" Type="VARCHAR" />
            <Column Name="resources" Required="true" Size="4096" Type="VARCHAR" />
            <Column Name="resource_param_name" Required="true" Size="128" Type="VARCHAR" />
            <Column Name="username" Required="false" Size="256" Type="VARCHAR" />
            <Column Name="passwd" Required="false" Size="256" Type="VARCHAR" />
            <Column Name="token_type" Required="true" Size="64" Type="VARCHAR" />
            <Column Name="create_time" Required="true" Type="DATE" />
            <Column Name="create_by" Required="true" Type="INTEGER" />
            <Column Name="change_time" Required="true" Type="DATE" />
            <Column Name="change_by" Required="true" Type="INTEGER" />
            <Column Name="valid_id" Required="true" Type="SMALLINT" />

            <Unique Name="oidc_functional_accounts_name">
                <UniqueColumn Name="name" />
            </Unique>
            <ForeignKey ForeignTable="oidc_profiles">
                <Reference Local="oidc_profile_id" Foreign="id" />
            </ForeignKey>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id" />
            </ForeignKey>
            <ForeignKey ForeignTable="users">
                <Reference Local="change_by" Foreign="id" />
            </ForeignKey>
            <ForeignKey ForeignTable="valid">
                <Reference Local="valid_id" Foreign="id" />
            </ForeignKey>

        </TableCreate>
END_XML
    push @XMLStrings, <<'END_XML';
        <TableCreate Name="oauth2_token_storage">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
            <Column Name="oidc_functional_account_id" Required="true" Type="INTEGER" />
            <Column Name="token_type" Required="true" Size="20" Type="VARCHAR" />
            <Column Name="token" Required="true" Size="4096" Type="VARCHAR" />
            <Column Name="expires_at" Required="false" Type="INTEGER" />
            <ForeignKey ForeignTable="oidc_functional_accounts">
                <Reference Local="oidc_functional_account_id" Foreign="id" />
            </ForeignKey>
        </TableCreate>
END_XML

    return unless $Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;
