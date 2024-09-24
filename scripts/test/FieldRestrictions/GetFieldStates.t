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

# This test checks Visibility of Dynamic Fields and Dynamic Fields' possible
# values when restricted with ACLs

# core modules

# CPAN modules

use Test2::V0;

# OTOBO modules

use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::Config;

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

# Objects used

my $Helper                    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $FieldRestrictionsObject   = $Kernel::OM->Get('Kernel::System::Ticket::FieldRestrictions');
my $ACLObject                 = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

# Test plan
plan 10;

# Test User
my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

############################################
# Test globals
############################################

# Test DF
my %DynamicTestFields;

# Test ACL IDs
my @TestAclIDs;

# Protector
my $LoopProtection = 99;

# AutoSelect Mock to simulate enabled SysConfig TicketACL::Autoselect for
# the UnitTestDropDownField DF, can be used in TestCases

my $Autoselect = {
    'Dest'         => '0',
    'DynamicField' => {
        'UnitTestDropDownField' => '1'
    },
    'NextStateID' => '0',
    'SLAID'       => '0',
    'ServiceID'   => '0',
    'TypeID'      => '0',
};

############################################
# Prepare test environment
############################################

subtest '[Prepare] Create Dynamic Fields for Test' => sub {

    my $TextFieldID       = _CreateDynamicTextField();
    my $TextFieldDFConfig = $DynamicFieldObject->DynamicFieldGet( ID => $TextFieldID );
    ok( $TextFieldDFConfig, 'Got a TextField DF Config.' );

    my $DropDownFieldID       = _CreateDynamicDropDownField();
    my $DropdownFieldDFConfig = $DynamicFieldObject->DynamicFieldGet( ID => $DropDownFieldID );
    ok( $DropdownFieldDFConfig, 'Got a Dropdown DF Config.' );

    my $CheckboxFieldID       = _CreateDynamicCheckboxField();
    my $CheckboxFieldDFConfig = $DynamicFieldObject->DynamicFieldGet( ID => $CheckboxFieldID );
    ok( $CheckboxFieldDFConfig, 'Got a Checkbox DF Config.' );

    %DynamicTestFields = map { $_->{Name} => $_ } (
        $TextFieldDFConfig,
        $DropdownFieldDFConfig,
        $CheckboxFieldDFConfig
    );
};

subtest '[Prepare] Create and Deploy Test ACLs' => sub {

    _CreateACL(
        Name        => '001-UnitTestACL_PreventDisplayOfSimpleTextFieldIfTicketInQueueRaw',
        ConfigMatch => {
            Properties => {
                Ticket => {
                    Queue => ['Raw']
                }
            }
        },
        ConfigChange => {
            PossibleNot => {
                Form => ['UnitTestSimpleTextField']
            }
        }
    );

    _CreateACL(
        Name        => '002-UnitTestACL_TestrictSimpleDropdownFieldToOneOption',
        ConfigMatch => {
            Properties => {
                Ticket => {
                    Queue => ['Raw']
                }
            }
        },
        ConfigChange => {
            PossibleNot => {
                Ticket => {
                    'DynamicField_UnitTestDropDownField' => [ 'a', 'b' ]
                }
            }
        }
    );

    _CreateACL(
        Name        => '003-UnitTestACL_HideTextFieldIfChechboxSelectedAndDropDownSetToOptionA',
        ConfigMatch => {
            Properties => {
                Ticket => {
                    DynamicField_UnitTestCheckboxField => [1],
                    DynamicField_UnitTestDropDownField => ['a'],
                }
            }
        },
        ConfigChange => {
            PossibleNot => {
                Form => [
                    'UnitTestSimpleTextField'
                ]
            }
        }
    );

    _DeployACLs();
    _RebuildConfig();
};

############################################
# Main test routine for all test cases
############################################

sub TestFieldRestrictions {

    my %Param = @_;

    my $Expected = delete $Param{Expected};

    # these could be overriden by specifying in
    # the TestCase data table. Otherwise use
    # reasonable defaults:
    if ( !exists $Param{DynamicFields} ) {
        $Param{DynamicFields} = \%DynamicTestFields;
    }
    if ( !exists $Param{LoopProtection} ) {
        $Param{LoopProtection} = \$LoopProtection;
    }
    if ( !exists $Param{UserID} ) {
        $Param{UserID} = $TestUserID;
    }
    if ( !exists $Param{TicketObject} ) {
        $Param{TicketObject} = $TicketObject;
    }
    if ( !exists $Param{DynamicFieldBackendObject} ) {
        $Param{DynamicFieldBackendObject} = $DynamicFieldBackendObject;
    }

    # the actual thing under test - get Field Restrictions for this test case
    my %CurFieldStates = $FieldRestrictionsObject->GetFieldStates(%Param);

    # assert against expected values

    if ( exists $Expected->{Visibility} ) {
        my $VisibilityCount      = scalar keys $CurFieldStates{Visibility}->%*;
        my $ExpectedVisibleCount = scalar keys $Expected->{Visibility}->%*;
        is( $VisibilityCount, $ExpectedVisibleCount, "Count of visibility info for DFs is $ExpectedVisibleCount. " );

        # check expected visible DFs
        for my $DF ( keys $Expected->{Visibility}->%* ) {

            ok(
                exists $CurFieldStates{Visibility}{$DF},
                'Got visibility info for ' . $DF . '.'
            );

            my $ActualVisibility   = $CurFieldStates{Visibility}{$DF};
            my $ExpectedVisibility = $Expected->{Visibility}->{$DF};

            is(
                $ActualVisibility,
                $ExpectedVisibility,
                "Visibility for $DF is $ExpectedVisibility."
            );
        }
    }

    # check restricted possible values vs expected possible values
    if ( exists $Expected->{PossibleValues} ) {

        for my $DF ( keys $Expected->{PossibleValues}->%* ) {

            my $PossibleValues = $Expected->{PossibleValues}->{$DF}->{PossibleValues};

            my $ExpectedCount = scalar keys %$PossibleValues;
            my $Count         = scalar keys $CurFieldStates{Fields}->{$DF}->{PossibleValues}->%*;

            is( $Count, $ExpectedCount, "DF $DF has expected value option count of $Count." );

            for my $ExpectedKey ( keys %$PossibleValues ) {
                my $ExpectedValue = $PossibleValues->{$ExpectedKey};

                ok(
                    exists $CurFieldStates{Fields}->{$DF}->{PossibleValues}->{$ExpectedKey},
                    "PossibleValues includes key " . ( $ExpectedKey || '<empty>' ) . '.'
                );
                is(
                    $CurFieldStates{Fields}->{$DF}->{PossibleValues}->{$ExpectedKey},
                    $ExpectedValue,
                    "PossibleValues key " . ( $ExpectedKey || '<empty>' ) . " has value " . ( $ExpectedValue || '<empty>' ) . '.'
                );
            }
        }
    }

    # check for new values as well
    if ( exists $Expected->{NewValues} ) {

        my $ExpectedNewValueCount = scalar keys $Expected->{NewValues}->%*;
        my $NewValueCount         = scalar keys $CurFieldStates{NewValues}->%*;
        is( $NewValueCount, $ExpectedNewValueCount, 'Count of NewValues is ' . $ExpectedNewValueCount . '.' );

        for my $DF ( keys $Expected->{NewValues}->%* ) {

            my $ExpectedValue = $Expected->{NewValues}->{$DF};

            ok(
                exists $CurFieldStates{NewValues}{$DF},
                'Got NewValues info for ' . $DF . '.'
            );
            is(
                $CurFieldStates{NewValues}{$DF},
                $ExpectedValue,
                'New Value for ' . $DF . ' is ' . ( $ExpectedValue || '<empty>' ) . '.'
            );
        }
    }

    return;
}

############################################
# Test scenario table
#  Param QueueID: 1 - Postmaster, 2 - Raw
############################################

my @TestCases = (
    {
        Name     => 'Text DF is shown for queue Postmaster.',
        Action   => 'AgentTicketPhone',
        GetParam => { QueueID => '1' },
        Expected => {
            Visibility => {
                DynamicField_UnitTestSimpleTextField => 1,
                DynamicField_UnitTestCheckboxField   => 1,
                DynamicField_UnitTestDropDownField   => 1,
            },
        }
    },
    {
        Name     => 'Text DF is not shown for queue Raw (ACL 001).',
        Action   => 'AgentTicketPhone',
        GetParam => {
            QueueID      => '2',
            DynamicField => {

                # pass in old entered value to see it getting cleared
                DynamicField_UnitTestSimpleTextField => 'ClearMe!',
            }
        },
        Expected => {
            Visibility => {
                DynamicField_UnitTestCheckboxField   => 1,
                DynamicField_UnitTestDropDownField   => 1,
                DynamicField_UnitTestSimpleTextField => 0,
            },
            NewValues => {
                DynamicField_UnitTestSimpleTextField => ''
            },
        }
    },
    {
        Name     => 'Dropdown DF has options [a,b,c and null] for queue Postmaster.',
        Action   => 'AgentTicketPhone',
        GetParam => { QueueID => '1' },
        Expected => {
            PossibleValues => {
                UnitTestDropDownField => {
                    PossibleValues => {
                        ''  => '-',
                        'a' => 'a',
                        'b' => 'b',
                        'c' => 'c',
                    }
                }
            }
        }
    },
    {
        Name     => 'Dropdown DF has option [c] for queue Raw and options \'a\' and \'b\' removed. (ACL 002)',
        Action   => 'AgentTicketPhone',
        GetParam => {
            QueueID      => '2',
            DynamicField => {

                # pass in selected old value to see it changed
                DynamicField_UnitTestDropDownField => 'a',
            },
        },
        Expected => {
            Visibility => {
                DynamicField_UnitTestCheckboxField   => 1,
                DynamicField_UnitTestDropDownField   => 1,
                DynamicField_UnitTestSimpleTextField => 0,
            },
            PossibleValues => {
                UnitTestDropDownField => {
                    PossibleValues => {
                        ''  => '-',
                        'c' => 'c',
                    }
                }
            },
            NewValues => {
                DynamicField_UnitTestDropDownField => ''
            },
        }
    },
    {
        Name   => 'Dropdown DF in queue RAw has single remaining option [c] auto-selected with TicketACL::Autoselect enabled. (ACL 002)',
        Action => 'AgentTicketPhone',

        # enable TicketACL::Autoselect for Dropdown
        Autoselect => $Autoselect,

        GetParam => {
            QueueID => '2',
        },
        Expected => {
            Visibility => {
                DynamicField_UnitTestCheckboxField   => 1,
                DynamicField_UnitTestDropDownField   => 1,
                DynamicField_UnitTestSimpleTextField => 0,
            },
            PossibleValues => {
                UnitTestDropDownField => {
                    PossibleValues => {
                        ''  => '-',
                        'c' => 'c',
                    }
                }
            },
            NewValues => {
                DynamicField_UnitTestDropDownField => 'c'
            },
        }
    },
    {
        Name     => 'Text DF is removed and cleared when both Checkbox is selected and DropDown is set to value a. (ACL 003)',
        Action   => 'AgentTicketPhone',
        GetParam => {
            QueueID      => '1',
            DynamicField => {

                # pass in selected values to trigger ACL
                DynamicField_UnitTestDropDownField => 'a',
                DynamicField_UnitTestCheckboxField => 1,

                # pass in old value for Text field to see it getting cleared
                DynamicField_UnitTestSimpleTextField => "ClearMe!",
            },
        },
        Expected => {
            Visibility => {
                DynamicField_UnitTestCheckboxField   => 1,
                DynamicField_UnitTestDropDownField   => 1,
                DynamicField_UnitTestSimpleTextField => 0,
            },
            NewValues => {
                DynamicField_UnitTestSimpleTextField => '',
            },
        }
    },
);

# run all the test cases
foreach my $TestCase (@TestCases) {

    my $Name = delete $TestCase->{Name};

    subtest "[Main] $Name" => sub {

        TestFieldRestrictions(%$TestCase);
    };
}

# cleanup
subtest '[Cleanup] TestConfig' => sub {

    _DeleteACLs();
    _DeployACLs();
};

done_testing;

########################################################
# Setup test fixture helpers
########################################################

sub _CreateACL {

    my %Param = @_;

    my $ID = $ACLObject->ACLAdd(
        Name           => $Param{Name},
        StopAfterMatch => 0,
        Comment        => '',
        Description    => '',
        ConfigMatch    => $Param{ConfigMatch},
        ConfigChange   => $Param{ConfigChange},
        ValidID        => 1,
        UserID         => 1,                      # admin
    );

    ok( $ID, "Got ACL id $ID for " . $Param{Name} . '.' );

    push @TestAclIDs, $ID;
    return $ID;
}

sub _DeployACLs {

    my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZACL.pm';

    my $ACLDumpSuccess = $ACLObject->ACLDump(
        ResultType => 'FILE',
        Location   => $Location,
        UserID     => 1,           # admin
    );

    ok( $ACLDumpSuccess, 'ACL Deploy success.' );

    if ($ACLDumpSuccess) {

        my $Success = $ACLObject->ACLsNeedSyncReset();

        ok( $Success, 'ACL need sync reset success.' );

        # remove preselection cache. probably not necessary here?
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        $CacheObject->Delete(
            Type => 'TicketACL',      # only [a-zA-Z0-9_] chars usable
            Key  => 'Preselection',
        );
    }

    return;
}

sub _DeleteACLs {

    my $Id = shift;

    for my $TestAclID (@TestAclIDs) {

        $ACLObject->ACLDelete(
            ID     => $TestAclID,
            UserID => 1,            # admin
        );
    }
    return;
}

sub _CreateDynamicTextField {

    return _CreateDynamicField(
        'UnitTestSimpleTextField',
        1,
        'Text',

        {
            DefaultValue => '',
            Link         => '',
            LinkPreview  => '',
            MultiValue   => 0,
            RegExList    => [],
            Tooltip      => ''
        }
    );
}

sub _CreateDynamicDropDownField {

    return _CreateDynamicField(
        'UnitTestDropDownField',
        2,
        'Dropdown',

        {
            DefaultValue   => '',
            Link           => '',
            LinkPreview    => '',
            MultiValue     => 0,
            PossibleNone   => 1,
            PossibleValues => {
                a => 'a',
                b => 'b',
                c => 'c',
            },
            Tooltip            => '',
            TranslatableValues => '0',
            TreeView           => '0',
        }
    );
}

sub _CreateDynamicCheckboxField {

    return _CreateDynamicField(
        'UnitTestCheckboxField',
        3,
        'Checkbox',

        {
            DefaultValue => '0',
            MultiValue   => undef,
            Tooltip      => '',
        }
    );
}

sub _CreateDynamicField {

    my ( $Name, $Order, $Type, $Config ) = @_;

    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $Name,
        Label      => $Name,
        FieldOrder => $Order,
        FieldType  => $Type,
        ObjectType => 'Ticket',
        Config     => $Config,
        ValidID    => 1,
        UserID     => $TestUserID
    );

    ok( $FieldID, "Field ID $FieldID : $Name created." );

    return $FieldID;
}

sub _RebuildConfig {

    delete $INC{'Kernel/Config/Files/ZZZAAuto.pm'};

    delete $Kernel::OM->{Objects}->{'Kernel::Config'};
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return 1;
}
