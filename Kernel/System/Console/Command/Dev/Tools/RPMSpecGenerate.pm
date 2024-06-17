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

package Kernel::System::Console::Command::Dev::Tools::RPMSpecGenerate;
## nofilter(TidyAll::Plugin::OTOBO::Perl::LayoutObject)

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate RPM spec files.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Starting...</yellow>\n\n");

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Call Output() once so that the TT objects are created.
    $LayoutObject->Output( Template => '' );
    $LayoutObject->{TemplateProviderObject}->include_path(
        ["$Home/scripts/auto_build/spec/templates"]
    );

    my @SpecFileTemplates = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => "$Home/scripts/auto_build/spec/templates",
        Filter    => "*.spec.tt",
    );

    for my $SpecFileTemplate (@SpecFileTemplates) {
        my $SpecFileName = $SpecFileTemplate;
        $SpecFileName =~ s{^.*/spec/templates/}{};
        $SpecFileName = substr( $SpecFileName, 0, -3 );    # cut off .tt

        my $Output = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
            TemplateFile => $SpecFileName,
        );
        my $TargetPath = "$Home/scripts/auto_build/spec/$SpecFileName";
        my $Written    = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $TargetPath,
            Mode     => 'utf8',
            Content  => \$Output,
        );
        if ( !$Written ) {
            $Self->PrintError("Could not write $TargetPath.");
            return $Self->ExitCodeError();
        }
        $Self->Print("  <yellow>$SpecFileTemplate -> $TargetPath</yellow>\n");
    }

    $Self->Print("\n<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
