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

package Kernel::System::Console::Command::Internal::BashCompletion;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand Kernel::System::Console::Command::List);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::Console::InterfaceConsole;    ## no perlimports

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Handles bash autocompletion.');

    $Self->AddArgument(
        Name        => 'command',
        Description => ".",
        Required    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'current-word',
        Description => ".",
        Required    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'previous-word',
        Description => ".",
        Required    => 0,
        ValueRegex  => qr/.*/smx,
    );
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $CurrentWord  = $Self->GetArgument('current-word');
    my $PreviousWord = $Self->GetArgument('previous-word');

    # We are looking for the command name
    if ( $PreviousWord =~ m/otobo\.Console\.pl/xms ) {

        # Get all matching commands
        my @CommandList = map {s/^Kernel::System::Console::Command:://xmsr} $Self->ListAllCommands();
        if ($CurrentWord) {
            @CommandList = grep { $_ =~ m/\Q$CurrentWord\E/xms } @CommandList;
        }
        print join "\n", @CommandList;
    }

    # We are looking for an option/argument
    else {
        # We need to extract the command name from the command line if present.
        my $CompLine = $ENV{COMP_LINE};
        if ( !$CompLine || $CompLine !~ m/otobo\.Console\.pl/ ) {
            $Self->ExitCodeError();
        }
        $CompLine =~ s/.*otobo\.Console\.pl\s*//xms;

        # Try to create the command object to get its options
        my ($CommandName) = split /\s+/, $CompLine;
        my $CommandPath   = 'Kernel::System::Console::Command::' . $CommandName;
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $CommandPath, Silent => 1 ) ) {
            return $Self->ExitCodeOk();
        }
        my $Command = $Kernel::OM->Get($CommandPath);
        my @Options = @{ $Command->{_Options} // [] };

        # Select matching options
        @Options = map { '--' . $_->{Name} } @Options;
        if ($CurrentWord) {
            @Options = grep { $_ =~ m/\Q$CurrentWord\E/xms } @Options;
        }

        # Hide options that are already on the commandline
        @Options = grep { $CompLine !~ m/(^|\s)\Q$_\E(\s|=|$)/xms } @Options;

        # when in doubt expand to a filename
        # Note that this does not consider whether the last options takes an argument.
        # Also note that this does not consider whether the command takes positional arguments.
        if ( !@Options && $CurrentWord && $CurrentWord !~ m/^-/ ) {
            @Options = glob "$CurrentWord*";
        }

        print join "\n", @Options;
    }

    return $Self->ExitCodeOk();
}

1;
