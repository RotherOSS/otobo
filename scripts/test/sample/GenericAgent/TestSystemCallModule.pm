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

package scripts::test::sample::GenericAgent::TestSystemCallModule;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Console::Command::Maint::PostMaster::SpoolMailsReprocess',
);

=head1 NAME

scripts::test::sample::GenericAgent::TestSystemCallModule - Generic Agent test module

=head1 SYNOPSIS

This test modules calls the console command Maint::PostMaster::SpoolMailsReproces that internally do a
system call to Maint::PostMaster::Read.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $GenericAgentModuleObject = $Kernel::OM-Get('scripts::test::sample::GenericAgent::TestSystemCallModule');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

Performs a call to Maint::PostMaster::SpoolMailsReproces.

    my $Success = $GenericAgentModuleObject->Run()

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    $Kernel::OM = $Kernel::OM;    # avoid 'once' warning
    $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::SpoolMailsReprocess')->Execute();

    return 1;
}

=back

=cut

1;
