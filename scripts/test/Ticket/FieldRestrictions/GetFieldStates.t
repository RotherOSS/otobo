# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use utf8;

# This test checks Visibility of Dynamic Fields and Dynamic Fields' possible
# values when restricted with ACLs

# core modules

# CPAN modules
use Test2::V0;
use Test::Warnings;    # must be loaded after Test2::V0

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
plan 18;

# Test User
my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $RandomID = $Helper->GetRandomID();

############################################
# Test globals
############################################

# Test DF
my %DynamicTestFields;

# Test ACL IDs
my @TestAclIDs;

# Test Ticket IDs
my %TestTicketIDs;

# Protector
my $LoopProtection = 99;

# AutoSelect Mock to simulate enabled SysConfig TicketACL::Autoselect for
# the UnitTestDropDownField DF, can be used in TestCases

my $Autoselect = {
    'Dest'         => '0',
    'DynamicField' => {
        "UnitTestDropDownField$RandomID" => '1'
    },
    'NextStateID' => '0',
    'SLAID'       => '0',
    'ServiceID'   => '0',
    'TypeID'      => '0',
};

############################################
# Prepare test environment
############################################

subtest '[Prepare] Set all previous ACLs to invalid' => sub {

    my $ACLList = $ACLObject->ACLList(
        ValidIDs => ['1'],
        UserID   => 1,
    );

    for my $Item ( sort keys %{$ACLList} ) {

        $ACLObject->ACLUpdate(
            ID   => $Item,
            Name => $ACLList->{$Item},

            ValidID => 2,
            UserID  => 1,
        );
    }    
}

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

    # Create dynamic fields for testing HideShow dynamic field default value behavior
    my $DropDown1FieldID = _CreateDynamicField(
        "UnitTestDropDownField1$RandomID",
        4,
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
    my $DropDown1FieldDFConfig = $DynamicFieldObject->DynamicFieldGet( ID => $DropDown1FieldID );
    ok( $DropDown1FieldDFConfig, 'Got a DropDown DF Config for DropDown1.' );

    my $DropDown2FieldID = _CreateDynamicField(
        "UnitTestDropDownField2$RandomID",
        5,
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
    my $DropDown2FieldDFConfig = $DynamicFieldObject->DynamicFieldGet( ID => $DropDown2FieldID );
    ok( $DropDown2FieldDFConfig, 'Got a DropDown DF Config for DropDown2.' );

    %DynamicTestFields = map { $_->{Name} => $_ } (
        $TextFieldDFConfig,
        $DropdownFieldDFConfig,
        $CheckboxFieldDFConfig,
        $DropDown1FieldDFConfig,
        $DropDown2FieldDFConfig,
    );
};

subtest '[Prepare] Create and Deploy Test ACLs' => sub {

    _CreateACL(
        Name        => "001-UnitTestACL_PreventDisplayOfSimpleTextFieldIfTicketInQueueRaw$RandomID",
        ConfigMatch => {
            Properties => {
                Ticket => {
                    Queue => ['Raw']
                }
            }
        },
        ConfigChange => {
            PossibleNot => {
                Form => ["UnitTestSimpleTextField$RandomID"]
            }
        }
    );

    _CreateACL(
        Name        => "002-UnitTestACL_TestrictSimpleDropdownFieldToOneOption$RandomID",
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
                    "DynamicField_UnitTestDropDownField$RandomID" => [ 'a', 'b' ]
                }
            }
        }
    );

    _CreateACL(
        Name        => "003-UnitTestACL_HideTextFieldIfChechboxSelectedAndDropDownSetToOptionA$RandomID",
        ConfigMatch => {
            Properties => {
                Ticket => {
                    "DynamicField_UnitTestCheckboxField$RandomID" => [1],
                    "DynamicField_UnitTestDropDownField$RandomID" => ['a'],
                }
            }
        },
        ConfigChange => {
            PossibleNot => {
                Form => [
                    "UnitTestSimpleTextField$RandomID"
                ]
            }
        }
    );

    # ACLs for testing HideShow dynamic field value handling
    _CreateACL(
        Name => "004-UnitTestACL_HideDropdownField1$RandomID",

        # ConfigMatch => {},
        ConfigChange => {
            PossibleNot => {
                Form => [
                    "UnitTestDropDownField1$RandomID"
                ]
            }
        }
    );
    _CreateACL(
        Name        => "005-UnitTestACL_ShowDropdownField1IfQueueIsPostmaster$RandomID",
        ConfigMatch => {
            Properties => {
                Ticket => {
                    Queue => [
                        '[RegExp]Postmaster'
                    ],
                }
            }
        },
        ConfigChange => {
            PossibleAdd => {
                Form => [
                    "UnitTestDropDownField1$RandomID"
                ]
            }
        }
    );

    _DeployACLs();
    _RebuildConfig();
};

subtest '[Prepare] Create Test Tickets' => sub {

    # first ticket with values for dynamic fields
    my $FirstTicketID = $TicketObject->TicketCreate(
        Title        => 'First ACL Test Ticket with dynamic field values',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerNo   => '123465',
        CustomerUser => 'unittest@otobo.org',
        OwnerID      => 1,
        UserID       => 1,
    );
    ok(
        $FirstTicketID,
        'TicketCreate()',
    );

    $TestTicketIDs{'TicketIDWithDFValues'} = $FirstTicketID;

    # add dynamic field values to ticket
    my $Success = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicTestFields{"UnitTestDropDownField1$RandomID"},
        Value              => 'a',
        ObjectID           => $FirstTicketID,
        UserID             => 1,
    );

    # second ticket without values for dynamic fields
    my $SecondTicketID = $TicketObject->TicketCreate(
        Title        => 'Second ACL Test Ticket without dynamic field values',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerNo   => '123465',
        CustomerUser => 'unittest@otobo.org',
        OwnerID      => 1,
        UserID       => 1,
    );
    ok(
        $SecondTicketID,
        'TicketCreate()',
    );

    $TestTicketIDs{'TicketIDWithoutDFValues'} = $SecondTicketID;
};

############################################
# Main test routine for all test cases
############################################

sub TestFieldRestrictions {

    my %Param = @_;

    my $Expected = delete $Param{Expected};

    # these could be overridden by specifying in
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

    # handle cached visibility
    if ( IsHashRefWithData( $Param{CachedVisibility} ) ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => 'HiddenFields',
            Key   => $Param{FormID},
            Value => $Param{CachedVisibility},
            TTL   => 60 * 20,                    # 20 min
        );
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
        is( $NewValueCount, $ExpectedNewValueCount, 'Count of NewValues is ' . $ExpectedNewValueCount . ' (was ' . $NewValueCount . ').' );

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

    # cleanup used cache
    if ( IsHashRefWithData( $Param{CachedVisibility} ) ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'HiddenFields',
            Key  => $Param{FormID},
        );
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
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
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
                "DynamicField_UnitTestSimpleTextField$RandomID" => 'ClearMe!',
            }
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 0,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
            NewValues => {
                "DynamicField_UnitTestSimpleTextField$RandomID" => ''
            },
        }
    },
    {
        Name     => 'Dropdown DF has options [a,b,c and null] for queue Postmaster.',
        Action   => 'AgentTicketPhone',
        GetParam => { QueueID => '1' },
        Expected => {
            PossibleValues => {
                "UnitTestDropDownField$RandomID" => {
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
                "DynamicField_UnitTestDropDownField$RandomID" => 'a',
            },
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 0,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
            PossibleValues => {
                "UnitTestDropDownField$RandomID" => {
                    PossibleValues => {
                        ''  => '-',
                        'c' => 'c',
                    }
                }
            },
            NewValues => {
                "DynamicField_UnitTestDropDownField$RandomID" => ''
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
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 0,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
            PossibleValues => {
                "UnitTestDropDownField$RandomID" => {
                    PossibleValues => {
                        ''  => '-',
                        'c' => 'c',
                    }
                }
            },
            NewValues => {
                "DynamicField_UnitTestDropDownField$RandomID" => 'c'
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
                "DynamicField_UnitTestDropDownField$RandomID" => 'a',
                "DynamicField_UnitTestCheckboxField$RandomID" => 1,

                # pass in old value for Text field to see it getting cleared
                "DynamicField_UnitTestSimpleTextField$RandomID" => "ClearMe!",
            },
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 0,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
            NewValues => {
                "DynamicField_UnitTestSimpleTextField$RandomID" => '',
            },
        }
    },

    # Test Cases for Dynamic Field Value Handling in HideShow
    {
        Name            => 'DropDown1 DF is removed and cleared when Queue is not Postmaster. (ACL 004)',
        Action          => 'AgentTicketFreeText',
        ACLPreselection => {
            Fields => {
                Dest                                            => 1,
                "DynamicField_ProcessManagementActivityID"      => 1,
                "DynamicField_ProcessManagementProcessID"       => 1,
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
                NewResponsibleID                                => 1,
                NewUserID                                       => 1,
                NextStateID                                     => 1,
                PriorityID                                      => 1,
                ServiceID                                       => 1,
                SLAID                                           => 1,
                StandardTemplateID                              => 1,
                TypeID                                          => 1,
            },
            Rules => {
                Form => {
                    Dest => 1,
                },
            },
        },
        ChangedElements => {
            'Dest' => 1,
        },
        FormID   => '1',
        GetParam => {
            Dest         => '4',
            NewQueueID   => '4',
            DynamicField => {},
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
        }
    },
    {
        Name            => 'DropDown1 DF is removed and filled with ticket value when Queue is not Postmaster and ticket has value for dynamic field. (ACL 004)',
        Action          => 'AgentTicketFreeText',
        ACLPreselection => {
            Fields => {
                Dest                                            => 1,
                "DynamicField_ProcessManagementActivityID"      => 1,
                "DynamicField_ProcessManagementProcessID"       => 1,
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
                NewResponsibleID                                => 1,
                NewUserID                                       => 1,
                NextStateID                                     => 1,
                PriorityID                                      => 1,
                ServiceID                                       => 1,
                SLAID                                           => 1,
                StandardTemplateID                              => 1,
                TypeID                                          => 1,
            },
            Rules => {
                Form => {
                    Dest => 1,
                },
            },
        },
        ChangedElements => {
            'Dest' => 1,
        },
        FormID   => '2',
        TicketID => $TestTicketIDs{TicketIDWithDFValues},
        GetParam => {
            QueueID      => '4',
            DynamicField => {},
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
            NewValues => { "DynamicField_UnitTestDropDownField1$RandomID" => "a" },
        }
    },
    {
        Name            => 'DropDown1 DF is removed and cleared when Queue is not Postmaster and Ticket does not have a dynamic field value. (ACL 004)',
        Action          => 'AgentTicketFreeText',
        ACLPreselection => {
            Fields => {
                Dest                                            => 1,
                DynamicField_ProcessManagementActivityID        => 1,
                DynamicField_ProcessManagementProcessID         => 1,
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
                NewResponsibleID                                => 1,
                NewUserID                                       => 1,
                NextStateID                                     => 1,
                PriorityID                                      => 1,
                ServiceID                                       => 1,
                SLAID                                           => 1,
                StandardTemplateID                              => 1,
                TypeID                                          => 1,
            },
            Rules => {
                Form => {
                    Dest => 1,
                },
            },
        },
        ChangedElements => {
            'Dest' => 1,
        },
        FormID   => '3',
        TicketID => $TestTicketIDs{TicketIDWithoutDFValues},
        GetParam => {
            QueueID      => '4',
            DynamicField => {},
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
        }
    },

    {
        Name            => 'DropDown1 DF is removed and cleared when Queue is not Postmaster. (ACL 004)',
        Action          => 'AgentTicketFreeText',
        ACLPreselection => {
            Fields => {
                Dest                                            => 1,
                DynamicField_ProcessManagementActivityID        => 1,
                DynamicField_ProcessManagementProcessID         => 1,
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
                NewResponsibleID                                => 1,
                NewUserID                                       => 1,
                NextStateID                                     => 1,
                PriorityID                                      => 1,
                ServiceID                                       => 1,
                SLAID                                           => 1,
                StandardTemplateID                              => 1,
                TypeID                                          => 1,
            },
            Rules => {
                Form => {
                    Dest => 1,
                },
            },
        },
        ChangedElements => {
            'Dest' => 1,
        },
        FormID   => '4',
        GetParam => {
            QueueID      => '4',
            DynamicField => {},
        },
        CachedVisibility => {
            "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
            "DynamicField_UnitTestDropDownField$RandomID"   => 1,
            "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
            "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
            "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
        }
    },
    {
        Name            => 'DropDown1 DF is removed and filled with ticket value when Queue is not Postmaster and ticket has value for dynamic field. (ACL 004)',
        Action          => 'AgentTicketFreeText',
        ACLPreselection => {
            Fields => {
                Dest                                            => 1,
                DynamicField_ProcessManagementActivityID        => 1,
                DynamicField_ProcessManagementProcessID         => 1,
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
                NewResponsibleID                                => 1,
                NewUserID                                       => 1,
                NextStateID                                     => 1,
                PriorityID                                      => 1,
                ServiceID                                       => 1,
                SLAID                                           => 1,
                StandardTemplateID                              => 1,
                TypeID                                          => 1,
            },
            Rules => {
                Form => {
                    Dest => 1,
                },
            },
        },
        ChangedElements => {
            'Dest' => 1,
        },
        FormID   => '5',
        TicketID => $TestTicketIDs{TicketIDWithDFValues},
        GetParam => {
            QueueID      => '4',
            DynamicField => {},
        },
        CachedVisibility => {
            "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
            "DynamicField_UnitTestDropDownField$RandomID"   => 1,
            "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
            "DynamicField_UnitTestDropDownField1$RandomID"  => 1,
            "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
            },
            NewValues => { "DynamicField_UnitTestDropDownField1$RandomID" => "a" },
        }
    },
    {
        Name     => 'DropDown1 DF is removed and cleared when Queue is not Postmaster and Ticket does not have a dynamic field value. (ACL 004)',
        Action   => 'AgentTicketFreeText',
        TicketID => $TestTicketIDs{TicketIDWithoutDFValues},
        FormID   => '6',
        GetParam => {
            QueueID      => '4',
            DynamicField => {},
        },
        CachedVisibility => {
            "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
            "DynamicField_UnitTestDropDownField$RandomID"   => 1,
            "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
            "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
            "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
        },
        Expected => {
            Visibility => {
                "DynamicField_UnitTestCheckboxField$RandomID"   => 1,
                "DynamicField_UnitTestDropDownField$RandomID"   => 1,
                "DynamicField_UnitTestSimpleTextField$RandomID" => 1,
                "DynamicField_UnitTestDropDownField1$RandomID"  => 0,
                "DynamicField_UnitTestDropDownField2$RandomID"  => 1,
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
        "UnitTestSimpleTextField$RandomID",
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
        "UnitTestDropDownField$RandomID",
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
        "UnitTestCheckboxField$RandomID",
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
