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

package scripts::DBUpdateTo6::MigrateArticleSearchIndex;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateArticleSearchIndex - Migrate article search index module.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $FilePath = "$Home/Kernel/Config/Backups/ZZZAutoOTOBO5.pm";
    my $Verbose  = $Param{CommandlineOptions}->{Verbose} || 0;

    if ( !-f $FilePath ) {
        print "    Could not find Kernel/Config/Backups/ZZZAutoOTOBO5.pm, skipping...\n" if $Verbose;
        return 1;
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %OTOBO5Config;
    $Kernel::OM->Get('Kernel::System::Main')->Require(
        'Kernel::Config::Backups::ZZZAutoOTOBO5'
    );
    Kernel::Config::Backups::ZZZAutoOTOBO5->Load( \%OTOBO5Config );

    if ( $OTOBO5Config{'Ticket::SearchIndexModule'} ) {
        my $Success = $Self->SettingUpdate(
            Name           => 'Ticket::SearchIndexModule',
            IsValid        => 1,
            EffectiveValue => 'Kernel::System::Ticket::ArticleSearchIndex::DB',
            Verbose        => $Verbose,
        );
        if ( !$Success ) {
            print "\n    Error:Unable to migrate Ticket::SearchIndexModule.\n\n";
            return;
        }

        # Turn off filtering of stop words if previous article search index module was set to RuntimeDB. Effectively,
        #   this will mimic old search behavior.
        if ( $OTOBO5Config{'Ticket::SearchIndexModule'} eq 'Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB' ) {
            $Success = $Self->SettingUpdate(
                Name           => 'Ticket::SearchIndex::ForceUnfilteredStorage',
                IsValid        => 1,
                EffectiveValue => 1,
                Verbose        => $Verbose,
            );
            if ( !$Success ) {
                print "\n    Error: Unable to migrate Ticket::SearchIndex::ForceUnfilteredStorage.\n\n";
                return;
            }
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
