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

package scripts::DBUpdateTo11_1::RebuildConfig;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Console::Command::Maint::Config::Rebuild',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_1::RebuildConfig - rebuild the config without the cleanup option

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # deploy new sysconfig settings
    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
    my ( $Result, $ExitCode );
    {
        local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
        open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
        $ExitCode = $CommandObject->Execute();
    }

    # exit code 0 means all went well
    if ($ExitCode) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not deploy system configuration!",
        );

        return;
    }

    # no problem
    return 1;
}

1;
