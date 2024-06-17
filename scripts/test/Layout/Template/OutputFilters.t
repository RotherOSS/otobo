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

use vars (qw($Self));

use Kernel::Output::HTML::Layout;

use Kernel::System::VariableCheck qw(:all);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name   => 'Output filter post, all templates (ignored)',
        Config => {
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPostPrefix1:\n",
                },
            },
        },
        Data => {
            Title => 'B&B 1'
        },
        Output => 'OutputFilters',
        Result => 'Test: B&B 1
',
    },
    {
        Name   => 'Output filter post, all templates, cache test (cacheable)',
        Config => {
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPostPrefix2:\n",
                },
            },
        },
        Data => {
            Title => 'B&B 2'
        },
        Output => 'OutputFilters',
        Result => 'Test: B&B 2
',
    },
    {
        Name   => 'Output filter post, OutputFilters template',
        Config => {
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        OutputFilters => 1,
                    },
                    Prefix => "OutputFilterPostPrefix3:\n",
                },
            },
        },
        Data => {
            Title => 'B&B 3'
        },
        Output => 'OutputFilters',
        Result => 'OutputFilterPostPrefix3:
Test: B&B 3
',
    },
    {
        Name   => 'Output filter post, OutputFilters template, cache test (cacheable)',
        Config => {
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        OutputFilters => 1,
                    },
                    Prefix => "OutputFilterPostPrefix4:\n",
                },
            },
        },
        Data => {
            Title => 'B&B 4'
        },
        Output => 'OutputFilters',
        Result => 'OutputFilterPostPrefix4:
Test: B&B 4
',
    },
);

for my $Test (@Tests) {

    # cleanup the cache and run every test twice to also test the disk caching
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'TemplateProvider',
    );

    for ( 0 .. 1 ) {

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        for my $Key ( sort keys %{ $Test->{Config} || {} } ) {
            $ConfigObject->Set(
                Key   => $Key,
                Value => $Test->{Config}->{$Key}
            );
        }

        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            UserID => 1,
            Lang   => 'de',
        );

        # call Output() once so that the TT objects are created.
        $LayoutObject->Output( Template => '' );

        # now add this directory as include path to be able to use the test templates
        my $IncludePaths = $LayoutObject->{TemplateProviderObject}->include_path();
        unshift @{$IncludePaths}, $ConfigObject->Get('Home') . '/scripts/test/Layout/Template';
        $LayoutObject->{TemplateProviderObject}->include_path($IncludePaths);

        for my $Block ( @{ $Test->{BlockData} || [] } ) {
            $LayoutObject->Block( %{$Block} );
        }

        my $Result = $LayoutObject->Output(
            TemplateFile => $Test->{Output},
            Data         => $Test->{Data} // {},
        );

        $Self->Is(
            $Result,
            $Test->{Result},
            $Test->{Name},
        );

        my $FileName = $ConfigObject->Get('Home') . '/scripts/test/Layout/Template/' . $Test->{Output} . '.tt';

        # remove duplicated //
        $FileName =~ s{/{2,}}{/}g;
        $Self->True(
            $LayoutObject->{TemplateProviderObject}->{_TemplateCache}->{$FileName},
            'Template added to cache',
        );
    }

}

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
