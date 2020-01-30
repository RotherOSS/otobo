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

package scripts::DBUpdateTo6::MigratePossibleNextActions;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdateTo6::MigratePossibleNextActions - Migrate possible next actions.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my $SettingName         = 'PossibleNextActions';
    my $PossibleNextActions = $Kernel::OM->Get('Kernel::Config')->Get($SettingName) || {};

    # create a lookup array to no not modify the looping variable
    my @Actions = sort keys %{ $PossibleNextActions // {} };

    my $Updated;
    ACTION:
    for my $Action (@Actions) {

        # skip all keys that looks like an URL (e.g. TT Env('CGIHandle')
        #   or staring with http(s), ftp(s), matilto:, ot www.)
        next ACTION if $Action =~ m{\A \[% [\s]+ Env\( }msxi;
        next ACTION if $Action =~ m{\A http [s]? :// }msxi;
        next ACTION if $Action =~ m{\A ftp [s]? :// }msxi;
        next ACTION if $Action =~ m{\A mailto : }msxi;
        next ACTION if $Action =~ m{\A www \. }msxi;

        # remember the value for the current key
        my $ActionValue = $PossibleNextActions->{$Action};

        # remove current key and add the inverted key value pair
        delete $PossibleNextActions->{$Action};
        $PossibleNextActions->{$ActionValue} = $Action;

        $Updated = 1;
    }

    return 1 if !$Updated;

    return $Self->SettingUpdate(
        Name           => $SettingName,
        IsValid        => 1,
        EffectiveValue => $PossibleNextActions,
        Verbose        => $Verbose,
    );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
