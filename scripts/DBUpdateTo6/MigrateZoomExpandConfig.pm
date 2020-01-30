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

package scripts::DBUpdateTo6::MigrateZoomExpandConfig;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
    'Kernel::System::SysConfig::DB',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateZoomExpandConfig - Migrate modified ZoomExpand config value to AgentZoomExpand and
CustomerZoomExpand configs.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $FilePath = "$Home/Kernel/Config/Backups/ZZZAutoOTOBO5.pm";
    my $Verbose  = $Param{CommandlineOptions}->{Verbose} || 0;

    # Check for modified ZoomExpand value for migration from OTOBO 5 to OTOBO 6
    my %OTOBO5Config;
    if ( -f $FilePath ) {
        $Kernel::OM->Get('Kernel::System::Main')->Require(
            'Kernel::Config::Backups::ZZZAutoOTOBO5'
        );
        Kernel::Config::Backups::ZZZAutoOTOBO5->Load( \%OTOBO5Config );
    }

    # Check for modified ZoomExpand value for patch level update from less then OTOBO 6.0.5.
    my $SysConfigDBObject  = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
    my %ZoomExpandModified = $SysConfigDBObject->ModifiedSettingGet(
        Name => 'Ticket::Frontend::ZoomExpand',
    );

    my $ZoomExpandValue = $ZoomExpandModified{EffectiveValue} || $OTOBO5Config{'Ticket::Frontend::ZoomExpand'};

    # If original ZoomExpand config is not modified there is nothing to migrate.
    if ( !$ZoomExpandValue ) {
        print "\n    There is no modified ZoomExpand config value, skipping migration... \n" if $Verbose;
        return 1;
    }

    # Migrate modified ZoomExpand config value to AgentZoomExpand and CustomerZoomExpand configs.
    for my $Config ( 'AgentZoomExpand', 'CustomerTicketZoom###CustomerZoomExpand' ) {

        my $Result = $Self->SettingUpdate(
            Name               => 'Ticket::Frontend::' . $Config,
            EffectiveValue     => $ZoomExpandValue,
            ContinueOnModified => 1,
            IsValid            => 1,
            UserID             => 1,
        );

        if ( !$Result ) {
            print
                "\n    Could not migrate config 'Ticket::Frontend::ZoomExpand' value to 'Ticket::Frontend::$Config'.. \n"
                if $Verbose;
        }
    }

    # Delete old ZoomExpand config modification from the DB.
    if ( $ZoomExpandModified{ModifiedID} ) {
        my $Success = $SysConfigDBObject->ModifiedSettingDelete(
            ModifiedID => $ZoomExpandModified{ModifiedID},
        );

        if ($Success) {
            print "\n    Deleted obsolete modified config 'Ticket::Frontend::ZoomExpand' from the DB. \n" if $Verbose;
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
