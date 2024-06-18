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
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name       => 'Simple test, no hooks',
        HookConfig => {},
        Blocks     => [qw(Block1 Block11 Block1 Block2)],
        Result     => <<'EOF',
Content1
Content11
Content1

Content2
EOF
    },
    {
        Name       => 'Simple test with hooks',
        HookConfig => {
            '100-test' => {
                BlockHooks => ['Block1'],
            },
            '200-test' => {
                BlockHooks => ['Block2'],
            },
        },
        Blocks => [qw(Block1 Block11 Block1 Block2)],
        Result => <<'EOF',
<!--HookStartBlock1-->
Content1
Content11
<!--HookEndBlock1-->
<!--HookStartBlock1-->
Content1
<!--HookEndBlock1-->

<!--HookStartBlock2-->
Content2
<!--HookEndBlock2-->
EOF
    },
    {
        Name       => 'Simple test with hooks in nested blocks',
        HookConfig => {
            '100-test' => {
                BlockHooks => [ 'Block1', 'Block11' ],
            },
            '200-test' => {
                BlockHooks => ['Block2'],
            },
        },
        Blocks => [qw(Block1 Block11 Block1 Block2)],
        Result => <<'EOF',
<!--HookStartBlock1-->
Content1
<!--HookStartBlock11-->
Content11
<!--HookEndBlock11-->
<!--HookEndBlock1-->
<!--HookStartBlock1-->
Content1
<!--HookEndBlock1-->

<!--HookStartBlock2-->
Content2
<!--HookEndBlock2-->
EOF
    },
);

for my $Test (@Tests) {

    $Kernel::OM->ObjectsDiscard();

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Frontend::Template::GenerateBlockHooks',
        Value => $Test->{HookConfig},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # call Output() once so that the TT objects are created.
    $LayoutObject->Output( Template => '' );

    # now add this directory as include path to be able to use the test templates
    my $IncludePaths = $LayoutObject->{TemplateProviderObject}->include_path();
    unshift @{$IncludePaths}, $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/test/Layout/Template';
    $LayoutObject->{TemplateProviderObject}->include_path($IncludePaths);

    for my $Block ( @{ $Test->{Blocks} } ) {
        $LayoutObject->Block(
            Name => $Block,
        );
    }

    my $Result = $LayoutObject->Output(
        TemplateFile => 'BlockHooks',
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
