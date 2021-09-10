# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::MigrateFromOTRS;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::MigrateFromOTRS::Base',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS - Perform system migration from OTRS 6 to OTOBO 10.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $MigrateFromOTRSObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    # TODO: eliminate TaskObjects
    return bless { TaskObjects => {} }, $Type;
}

=head2 Run()

run migration task

    my $Success = $MigrateFromOTRSObject->Run (
        Task          => 'All' # or only one Task
        UserID        => 123,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my %ResultFail = ( Successful => 0 );

    # check needed stuff
    for my $Needed (qw(Task UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return \%ResultFail;
        }
    }

    # don't attempt to run when the pre check failed
    return \%ResultFail unless $Self->_ExecutePreCheck(%Param);

    return $Self->_ExecuteRun(%Param);
}

sub _ExecutePreCheck {
    my ( $Self, %Param ) = @_;

    my $Task = $Param{Task};

    my $ModuleName = "Kernel::System::MigrateFromOTRS::$Task";

    return 0 unless $Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName);

    $Self->{TaskObjects}->{$Task} //= $Kernel::OM->Create($ModuleName);

    return 0 unless $Self->{TaskObjects}->{$Task};

    # successful per default
    return 1 unless $Self->{TaskObjects}->{$Task}->can('CheckPreviousRequirement');

    return $Self->{TaskObjects}->{$Task}->CheckPreviousRequirement(%Param);
}

sub _ExecuteRun {
    my ( $Self, %Param ) = @_;

    my $Task       = $Param{Task};
    my %ResultFail = ( Successful => 0 );

    my $ModuleName = "Kernel::System::MigrateFromOTRS::$Task";

    return \%ResultFail unless $Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName);

    $Self->{TaskObjects}->{$Task} //= $Kernel::OM->Create($ModuleName);

    return \%ResultFail unless $Self->{TaskObjects}->{$Task};

    # a migration step must have a Run-method
    return \%ResultFail unless $Self->{TaskObjects}->{$Task}->can('Run');

    # Execute Run-Component
    return $Self->{TaskObjects}->{$Task}->Run(%Param);
}

1;
