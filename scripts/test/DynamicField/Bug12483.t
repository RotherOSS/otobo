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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get needed objects
my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');
my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomNumber();
my $UserID   = 1;

my @Tests = (
    {
        Name => 'Test1',
        Add  => {
            Config => {
                Name        => 'AnyName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'something for label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 1,
            UserID     => $UserID,
        },
        UpdateDBIncorrectYAML => "-\nDefaultValue: ''\nPossibleValues: ~\n",
        UpdateDBCorrectYAML   => "---\nDefaultValue: ''\nPossibleValues: ~\n",
        ReferenceUpdate       => {
            Config => {
                DefaultValue   => '',
                PossibleValues => undef,
            },
        }
    },
);

TEST:
for my $Test (@Tests) {

    my $FieldName = $Test->{Name} . $RandomID;

    # add config
    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name => $FieldName,
        %{ $Test->{Add} },
    );

    $Self->True(
        $DynamicFieldID,
        "$Test->{Name} - DynamicFieldAdd()",
    );

    # get config
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet() Name",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - DynamicFieldGet() - Config",
    );

    # Update the dynamic field directly in the database, because at the moment we have no idea, in
    #   which case the YAML strings which make problems can be insert with the normal backend functionality.
    my $DoSuccess = $DBObject->Do(
        SQL  => 'UPDATE dynamic_field SET config = ? WHERE id = ?',
        Bind => [
            \$Test->{UpdateDBIncorrectYAML},
            \$DynamicFieldID,
        ],
    );

    if ( !$DoSuccess ) {
        done_testing();

        exit 0;
    }

    $CacheObject->CleanUp(
        Type => 'DynamicField',
    );

    $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # Verify that config is empty.
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet()",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        {},
        "$Test->{Name} - DynamicFieldGet() - Config (after incorrect YAML)",
    );

    $DoSuccess = $DBObject->Do(
        SQL  => 'UPDATE dynamic_field SET config = ? WHERE id = ?',
        Bind => [
            \$Test->{UpdateDBCorrectYAML},
            \$DynamicFieldID,
        ],
    );
    if ( !$DoSuccess ) {
        done_testing();

        exit 0;
    }

    # After this update we need no cache cleanup, because the
    #   last DynamicFieldGet should not cache something.
    $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # Verify that config is empty.
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet()",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        $Test->{ReferenceUpdate}->{Config},
        "$Test->{Name} - DynamicFieldGet() - Config (after correct YAML, nothing cached)",
    );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
