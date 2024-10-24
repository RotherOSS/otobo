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

# core modules

# CPAN modules
use Test2::V0;
use YAML::XS ();
use Try::Tiny;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my @Tests = (
    {
        Name          => 'Simple string',
        Data          => 'Teststring <tag> äß@ø " \\" \' \'\'',
        SuccessDecode => 1,
    },
    {
        Name => 'Complex data',
        Data => {
            Key   => 'Teststring <tag> äß@ø " \\" \' \'\'',
            Value => [
                {
                    Subkey  => 'Value',
                    Subkey2 => undef,
                },
                1234,
                0,
                undef,
                'Teststring <tag> äß@ø " \\" \' \'\'',
            ],
        },
        SuccessDecode => 1,
    },
    {
        Name          => 'Special YAML chars',
        Data          => ' a " a " a \'\' a \'\' a',
        SuccessDecode => 1,
    },
    {
        Name          => 'UTF8 string',
        Data          => 'kéy',
        SuccessDecode => 1,
    },
    {
        Name          => 'UTF8 string, loader',
        Data          => 'kéy',
        YAMLString    => '--- kéy' . "\n",
        SuccessDecode => 1,
    },
    {
        Name          => 'UTF8 string without UTF8-Flag',
        Data          => 'k\x{e9}y',
        SuccessDecode => 1,
    },
    {
        Name          => 'UTF8 string without UTF8-Flag, loader',
        Data          => 'k\x{e9}y',
        YAMLString    => '--- k\x{e9}y' . "\n",
        SuccessDecode => 1,
    },
    {
        Name          => 'Very long string',      # see https://bugzilla.redhat.com/show_bug.cgi?id=192400
        Data          => ' äø<>"\'' x 40_000,
        SuccessDecode => 1,
    },
    {
        Name => 'Wrong newline',
        Data => {
            DefaultValue   => '',
            PossibleValues => undef,
        },
        YAMLString    => "---\rDefaultValue: ''\rPossibleValues: ~\r",
        SuccessDecode => 1,
    },
    {
        Name => 'Windows newline',
        Data => {
            DefaultValue   => '',
            PossibleValues => undef,
        },
        YAMLString    => "---\r\nDefaultValue: ''\r\nPossibleValues: ~\r\n",
        SuccessDecode => 1,
    },
    {
        Name => 'Unix newline',
        Data => {
            DefaultValue   => '',
            PossibleValues => undef,
        },
        YAMLString    => "---\nDefaultValue: ''\nPossibleValues: ~\n",
        SuccessDecode => 1,
    },
    {
        Name          => 'Invalid YAML string',
        Data          => '1',
        YAMLString    => "-\nDefaultValue: ''\nPossibleValues: ~\n",
        SuccessDecode => 0,
    },

    # Test case to reproduce a bug with YAML that is generated by the pure-perl YAML module.
    # See also http://blogs.perl.org/users/brian_d_foy/2010/06/block-sequence-entries-are-not-allowed-in-this-context.html.
    # This case parsed successfully in OTOBO 10 because there Kernel::System::YAML::Load() was used
    # and there the buggy YAML.pm accepted that YAML. In OTOBO 11 there no longer
    # is a fallback and the parsing is not successful.
    # This is a good thing, as supporting buggy YAML is not a goal.
    {
        Name => 'Missing quotes',
        Data => {
            PossibleValues => '-',
        },
        YAMLString    => "---\nPossibleValues: -\n",
        SuccessDecode => 0,
    },

    # This is how the previous example should look like
    {
        Name => 'Missing quotes (fixed)',
        Data => {
            PossibleValues => '-',
        },
        YAMLString    => "---\nPossibleValues: '-'\n",
        SuccessDecode => 1,
    },

    {
        Name          => 'Simple String 0 - roundtrip',
        Data          => '0',
        SuccessDecode => 1,
    },
    {
        Name          => 'Simple String 0',
        YAMLString    => "---\n'0'\n",
        Data          => '0',
        SuccessDecode => 1,
    },
    {
        Name          => 'Number 0 - roundtrip',
        Data          => 0,
        SuccessDecode => 1,
    },
    {
        Name          => 'Number 0',
        YAMLString    => "---\n0\n",
        Data          => 0,
        SuccessDecode => 1,
    },
    {
        Name          => 'Simple String 1',
        Data          => '1',
        SuccessDecode => 1,
    },
    {
        Name          => 'Number 1',
        Data          => 1,
        SuccessDecode => 1,
    },
    {
        Name          => 'Simple String 01',
        Data          => '01',
        SuccessDecode => 1,
    },
    {
        Name          => 'Number 01',
        Data          => 01,            ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
        SuccessDecode => 1,
    },
    {
        Name          => 'Empty String - roundtrip',
        Data          => '',
        SuccessDecode => 1,
    },
    {
        Name          => 'Empty String',
        YAMLString    => "---\n''\n",
        Data          => '',
        SuccessDecode => 1,
    },
    {
        Name          => 'undef - roundtrip',
        Data          => undef,
        SuccessDecode => 1,
    },
    {
        Name          => 'null',
        YAMLString    => "---\nnull\n",
        Data          => undef,
        SuccessDecode => 1,
    },
    {
        Name          => 'tilde',
        YAMLString    => "---\n~\n",
        Data          => undef,
        SuccessDecode => 1,
    },
    {
        Name => 'Complex Structure with 0',
        Data => {
            Value1 => '0',
            Value2 => 0,
        },
        YAMLString    => "---\nValue1: 0\nValue2: 0\n",
        SuccessDecode => 1,
    },
);

for my $Test (@Tests) {

    # This block is basically replicating Kernel::System::YAML::Load.
    # But the tests are still useful as they exemplify what Kernel::System::YAML does.

    # When the test script contains the YAML string then the high
    # code points are already in the string as 'use utf8' is in effecdt
    my $YAMLString = $Test->{YAMLString};

    # Alternatively we are testing the roundtrip. The result from Dump()
    # is a string of octetts that encode in UTF8 the really wanted string.
    if ( !$YAMLString ) {
        $YAMLString = YAML::XS::Dump( Data => $Test->{Data} );
        utf8::decode($YAMLString);
    }

    my $YAMLData = try {

        # Load expects octetts that encodes UTF-8
        utf8::encode($YAMLString);
        YAML::XS::Load($YAMLString);
    }
    catch {
        'YAML::XS::Load() threw an exception';
    };

    if ( $Test->{SuccessDecode} ) {
        is(
            $YAMLData,
            $Test->{Data},
            "$Test->{Name} - got expected result",
        );
    }
    else {
        is(
            $YAMLData,
            'YAML::XS::Load() threw an exception',
            "$Test->{Name} - failure reported",
        );
    }
}

done_testing;
