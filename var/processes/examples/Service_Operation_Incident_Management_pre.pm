# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package var::processes::examples::Service_Operation_Incident_Management_pre;
## nofilter(TidyAll::Plugin::OTOBO::Perl::PerlCritic)

use strict;
use warnings;

use parent qw(var::processes::examples::Base);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::Package',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return (
        Success => 1,
    );
}

sub DependencyCheck {
    my ( $Self, %Param ) = @_;

    my $PackageObject  = $Kernel::OM->Get('Kernel::System::Package');
    my @RepositoryList = $PackageObject->RepositoryList(
        Result => 'short',
    );

    if (
        grep {
            $_->{Name} eq 'ITSMIncidentProblemManagement'
                && $_->{Status} eq 'installed'
        } @RepositoryList
        )
    {

        return (
            Success => 1,
        );
    }

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $Message        = $LanguageObject->Translate(
        'This Ready2Adopt process requires the additional module %s to be installed.',
        '<strong>ITSMIncidentProblemManagement</strong>',
    );

    return (
        Success      => 0,
        ErrorMessage => $Message,
    );
}

1;
