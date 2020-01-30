# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package scripts::DBUpdateTo6::MigratePackageRepositoryConfiguration;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdateTo6::MigratePackageRepositoryConfiguration -  Migrate package repository configuration.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ConfigKey    = 'Package::RepositoryList';
    my %RepositoryList;
    if ( $ConfigObject->Get($ConfigKey) ) {
        %RepositoryList = %{ $ConfigObject->Get($ConfigKey) };
    }

    return 1 if !%RepositoryList;

    my @FrameworkVersionParts = split /\./, $ConfigObject->Get('Version');
    my $FrameworkVersion      = $FrameworkVersionParts[0];

    my $CurrentITSMRepository = "http://ftp.otobo.org/pub/otobo/itsm/packages$FrameworkVersion/";

    return 1 if $RepositoryList{$CurrentITSMRepository};

    # Make sure ITSM repository matches the current framework version.
    my @Matches = grep { $_ =~ m{http://ftp\.otobo\.org/pub/otobo/itsm/packages\d+/}msxi } sort keys %RepositoryList;

    return 1 if !@Matches;

    # Delete all old ITSM repositories, but leave the current if exists
    for my $Repository (@Matches) {
        if ( $Repository ne $CurrentITSMRepository ) {
            delete $RepositoryList{$Repository};
        }
    }

    # Make sure that current ITSM repository is in the list
    $RepositoryList{$CurrentITSMRepository} = "OTOBO::ITSM $FrameworkVersion Master";

    my $ContinueOnModified = $Param{ContinueOnModified} // 0;

    return $Self->SettingUpdate(
        Name               => $ConfigKey,
        IsValid            => 1,
        EffectiveValue     => \%RepositoryList,
        ContinueOnModified => $ContinueOnModified,
        Verbose            => $Verbose,
    );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
