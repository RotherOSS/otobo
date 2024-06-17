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

package Kernel::System::Console::Command::Dev::Tools::Shell;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('An interactive REPL shell for the OTOBO API.');

    $Self->AddOption(
        Name        => 'eval',
        Description => 'Perl code that should be evaluated in the OTOBO context.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my @Dependencies = ( 'Devel::REPL', 'Data::Printer' );

    DEPENDENCY:
    for my $Dependency (@Dependencies) {
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Dependency, Silent => 1 ) ) {
            die
                "Required Perl module '$Dependency' not found. Please make sure the following dependencies are installed: "
                . join( ' ', @Dependencies );
        }
    }

    return 1;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Repl = Devel::REPL->new();

    for my $Plugin (qw(History LexEnv MultiLine::PPI FancyPrompt OTOBO)) {
        $Repl->load_plugin($Plugin);
    }

    # fancy things are made with love <3
    $Repl->fancy_prompt(
        sub {
            my $Self = shift;
            return sprintf 'OTOBO: %03d%s> ',
                $Self->lines_read(),
                $Self->can('line_depth') ? ':' . $Self->line_depth() : '';
        }
    );

    $Repl->ColoredOutput( $Self->{ANSI} );

    my $Code = $Self->GetOption('eval');
    if ($Code) {
        my @Result = $Repl->formatted_eval($Code);
        $Self->Print("@Result") if !$Repl->exit_repl();
    }
    else {
        $Repl->run();
    }

    return $Self->ExitCodeOk();
}

1;
