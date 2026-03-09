# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use List::AllUtils qw(max pairs);
use Test2::V0 qw(:DEFAULT), qw(hash etc);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper                    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ACLObject                 = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $CustomerUserObject        = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');

        # disable CheckEmailAddresses
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        # create necessary dynamic fields
        my $RandomID         = $Helper->GetRandomID;
        my @BaseFieldConfigs = (
            {
                Config => {
                    DisplayType                => '',
                    EditFieldMode              => 'AutoComplete',
                    ImportSearchAttribute      => '',
                    LinkDirection              => 'ReferencingIsSource',
                    LinkObjectForReferenceType => '',
                    Multiselect                => 0,
                    MultiValue                 => 1,
                    PossibleNone               => 1,
                    Queue                      => [],
                    ReferencedObjectType       => 'Ticket',
                    ReferenceFilterList        => [],
                    SearchAttribute            => '',
                    Tooltip                    => '',
                },
                FieldType  => 'Ticket',
                Label      => "ReferenceTarget$RandomID",
                Name       => "ReferenceTarget$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
            {
                Config => {
                    DefaultValue   => '',
                    Link           => '',
                    LinkPreview    => '',
                    MultiValue     => 0,
                    PossibleNone   => 1,
                    PossibleValues => {
                        abcd => 'ABCD',
                        bcde => 'BCDE',
                        cdef => 'CDEF'
                    },
                    Tooltip            => '',
                    TranslatableValues => 0,
                    TreeView           => 0,
                },
                FieldType  => 'Dropdown',
                Label      => "SetInnerDropdown$RandomID",
                Name       => "SetInnerDropdown$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
            {
                Config => {
                    DefaultValue => '',
                    Link         => '',
                    LinkPreview  => '',
                    MultiValue   => 0,
                    RegExList    => [],
                    Tooltip      => '',
                },
                FieldType  => 'Text',
                Label      => "SetInnerText$RandomID",
                Name       => "SetInnerText$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
            {
                Config => {
                    DefaultValue   => '',
                    Link           => '',
                    LinkPreview    => '',
                    MultiValue     => 1,
                    PossibleNone   => 1,
                    PossibleValues => {
                        abcd => 'ABCD',
                        bcde => 'BCDE',
                        cdef => 'CDEF'
                    },
                    Tooltip            => '',
                    TranslatableValues => 0,
                    TreeView           => 0,
                },
                FieldType  => 'Dropdown',
                Label      => "MultiValueDropdown$RandomID",
                Name       => "MultiValueDropdown$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
            {
                Config => {
                    DisplayType                => '',
                    EditFieldMode              => 'AutoComplete',
                    ImportSearchAttribute      => '',
                    LinkDirection              => 'ReferencingIsSource',
                    LinkObjectForReferenceType => '',
                    Multiselect                => 0,
                    MultiValue                 => 0,
                    PossibleNone               => 1,
                    Queue                      => [],
                    ReferencedObjectType       => 'Ticket',
                    ReferenceFilterList        => [],
                    SearchAttribute            => '',
                    Tooltip                    => '',
                },
                FieldType  => 'Ticket',
                Label      => "ReferenceSource$RandomID",
                Name       => "ReferenceSource$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
        );
        my %MultiValueSet = (
            Config => {
                Include    => [ { DF => "SetInnerDropdown$RandomID" }, { DF => "SetInnerText$RandomID" } ],
                MultiValue => 1,
                Tooltip    => undef,
            },
            FieldType  => 'Set',
            Label      => "MultiValueSet$RandomID",
            Name       => "MultiValueSet$RandomID",
            ObjectType => 'Ticket',
            ValidID    => 1,
        );

        # create test user and login
        my $TestUserLogin =
            $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            )
            || die "Did not get test user";

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create base fields
        my %FieldIDToName;
        for my $FieldConfig (@BaseFieldConfigs) {

            my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
                $FieldConfig->%*,
                FieldOrder => _GetFieldOrder(),
                UserID     => $TestUserID,
            );
            ok( $FieldID, "Field $FieldConfig->{Name} created successfully" );

            $FieldIDToName{ $FieldConfig->{Name} } = $FieldID;
        }

        # create set field
        {
            my $SetFieldID = $DynamicFieldObject->DynamicFieldAdd(
                %MultiValueSet,
                FieldOrder => _GetFieldOrder(),
                UserID     => $TestUserID,
            );
            ok( $SetFieldID, "Field $MultiValueSet{Name} created successfully" );

            $FieldIDToName{ $MultiValueSet{Name} } = $SetFieldID;
        }

        # create lens fields based on previously created fields
        my @LensFieldConfigs = (
            {
                Config => {
                    AttributeDF     => $FieldIDToName{"ReferenceTarget$RandomID"},
                    MultiValue      => 1,
                    ReferenceDF     => $FieldIDToName{"ReferenceSource$RandomID"},
                    ReferenceDFName => "DynamicField_ReferenceSource$RandomID",
                    Tooltip         => '',
                },
                FieldType  => 'Lens',
                Label      => "LensOnReference$RandomID",
                Name       => "LensOnReference$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
            {
                Config => {
                    AttributeDF     => $FieldIDToName{"MultiValueSet$RandomID"},
                    MultiValue      => 1,
                    ReferenceDF     => $FieldIDToName{"ReferenceSource$RandomID"},
                    ReferenceDFName => "DynamicField_ReferenceSource$RandomID",
                    Tooltip         => '',
                },
                FieldType  => 'Lens',
                Label      => "LensOnMultiValueSet$RandomID",
                Name       => "LensOnMultiValueSet$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
            {
                Config => {
                    AttributeDF     => $FieldIDToName{"MultiValueDropdown$RandomID"},
                    MultiValue      => 1,
                    ReferenceDF     => $FieldIDToName{"ReferenceSource$RandomID"},
                    ReferenceDFName => "DynamicField_ReferenceSource$RandomID",
                    Tooltip         => '',
                },
                FieldType  => 'Lens',
                Label      => "LensOnMultiValueDropdown$RandomID",
                Name       => "LensOnMultiValueDropdown$RandomID",
                ObjectType => 'Ticket',
                ValidID    => 1,
            },
        );
        for my $FieldConfig (@LensFieldConfigs) {

            my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
                $FieldConfig->%*,
                FieldOrder => _GetFieldOrder(),
                UserID     => $TestUserID,
            );
            ok( $FieldID, "Field $FieldConfig->{Name} created successfully" );

            $FieldIDToName{ $FieldConfig->{Name} } = $FieldID;
        }

        # add the fields to the relevant screen
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketFreeText###DynamicField',
            Value => {
                "ReferenceSource$RandomID"          => 1,
                "LensOnReference$RandomID"          => 1,
                "LensOnMultiValueSet$RandomID"      => 1,
                "LensOnMultiValueDropdown$RandomID" => 1,
            }
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # set previous ACLs on invalid.
        my $ACLList = $ACLObject->ACLList(
            ValidIDs => ['1'],
            UserID   => 1,
        );

        for my $Item ( sort keys %{$ACLList} ) {
            my $ACL = $ACLObject->ACLGet(
                ID     => $Item,
                UserID => 1,
            );
            my $UpdateSuccess = $ACLObject->ACLUpdate(
                $ACL->%*,
                ValidID => 2,
                UserID  => 1,
            );
            ok( $UpdateSuccess, "ACL $Item set to invalid-temporarily successfully" );

            my $UpdatedACL = $ACLObject->ACLGet(
                ID     => $Item,
                UserID => 1,
            );
            is( $UpdatedACL->{ValidID}, 2, "Verified that ACL $Item actually is invalid" );
        }

        # create customer user for testing screens which require an existing ticket
        my $TestCustomerUser   = $Helper->TestCustomerUserCreate || die "Did not get test customer user";
        my %TestCustomerUserID = $CustomerUserObject->CustomerUserDataGet( User => $TestCustomerUser );

        # create tickets as targets for the multivalue autocomplete reference field
        my %TicketIDForTitle;
        {
            for my $Count ( 1 .. 3 ) {
                my $Title        = 'Reference target ticket ' . $RandomID . ' ' . $Count;
                my $TicketNumber = $TicketObject->TicketCreateNumber;
                my $TicketID     = $TicketObject->TicketCreate(
                    TN           => $TicketNumber,
                    Title        => $Title,
                    Queue        => 'Raw',
                    Lock         => 'unlock',
                    Priority     => '3 normal',
                    State        => 'new',
                    CustomerID   => $TestCustomerUserID{UserCustomerID},
                    CustomerUser => $TestCustomerUser,
                    OwnerID      => 1,
                    UserID       => 1,
                );
                ok( $TicketID, "Ticket is created - $TicketID" );
                $TicketIDForTitle{$Title} = $TicketID;
            }
        }

        # create tickets which do have dynamic field values for changing references
        my %TicketDFValues = (

            # first ticket does have no values
            1 => {},

            # second holds one value for each field
            2 => {
                "MultiValueDropdown$RandomID" => ['bcde'],
                "MultiValueSet$RandomID"      => [
                    {
                        "SetInnerDropdown$RandomID" => 'cdef',
                        "SetInnerText$RandomID"     => 'Test Text Value',
                    },
                ],
                "ReferenceTarget$RandomID" => [
                    $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 3' }
                ],
            },

            # third holds three values for each field
            3 => {
                "MultiValueDropdown$RandomID" => [
                    'abcd',
                    'bcde',
                    'cdef'
                ],
                "MultiValueSet$RandomID" => [
                    {
                        "SetInnerDropdown$RandomID" => 'abcd',
                        "SetInnerText$RandomID"     => 'Test Text Value 1',
                    },
                    {
                        "SetInnerDropdown$RandomID" => 'bcde',
                        "SetInnerText$RandomID"     => 'Test Text Value 2',
                    },
                    {
                        "SetInnerDropdown$RandomID" => 'cdef',
                        "SetInnerText$RandomID"     => 'Test Text Value 3',
                    },
                ],
                "ReferenceTarget$RandomID" => [
                    $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 1' },
                    $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 2' },
                    $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 3' },
                ],
            },
        );
        {
            for my $Count ( 1 .. 3 ) {
                my $Title        = 'DynamicField values ticket ' . $RandomID . ' ' . $Count;
                my $TicketNumber = $TicketObject->TicketCreateNumber;
                my $TicketID     = $TicketObject->TicketCreate(
                    TN           => $TicketNumber,
                    Title        => $Title,
                    Queue        => 'Raw',
                    Lock         => 'unlock',
                    Priority     => '3 normal',
                    State        => 'new',
                    CustomerID   => $TestCustomerUserID{UserCustomerID},
                    CustomerUser => $TestCustomerUser,
                    OwnerID      => 1,
                    UserID       => 1,
                );
                ok( $TicketID, "Ticket is created - $TicketID" );
                $TicketIDForTitle{$Title} = $TicketID;

                # set dynamic field values
                my %DFValuesForCurrentTicket = $TicketDFValues{$Count}->%*;
                for my $DFName ( keys %DFValuesForCurrentTicket ) {
                    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                        Name => $DFName,
                    );
                    is( $DynamicFieldConfig, hash { field 'Name' => $DFName; etc(); }, "Field config for field $DFName is existent" );

                    my $ValueSetSuccess = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectID           => $TicketID,
                        Value              => $DFValuesForCurrentTicket{$DFName},
                        UserID             => $TestUserID,
                    );
                    ok( $ValueSetSuccess, "Setting value of field $DFName for ticket '$Title' successful" );
                }
            }
        }

        # Create ticket for screens which require one
        my $TicketNumber = $TicketObject->TicketCreateNumber;
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $TestCustomerUserID{UserCustomerID},
            CustomerUser => $TestCustomerUser,
            OwnerID      => 1,
            UserID       => 1,
        );
        ok( $TicketID, "Ticket is created - $TicketID" );
        $TicketIDForTitle{'Some Ticket Title'} = $TicketID;

        # navigate to screen
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketFreeText;TicketID=$TicketID");

        # check if reference fields exist
        my $ReferenceSourceElement = $Selenium->find_element( "#Autocomplete_DynamicField_ReferenceSource$RandomID", 'css' );
        $ReferenceSourceElement->is_enabled;
        $ReferenceSourceElement->is_displayed;
        is( $ReferenceSourceElement->get_value, '', "ReferenceSource field is empty" );

        my $LensOnReferenceElement = $Selenium->find_element( "#Autocomplete_DynamicField_LensOnReference${RandomID}_0", 'css' );
        $LensOnReferenceElement->is_enabled;
        $LensOnReferenceElement->is_displayed;
        is( $LensOnReferenceElement->get_value, '', "LensOnReference field is empty" );

        # check if other fields exist
        my $LensOnMultiValueDropdownElement = $Selenium->find_element( "#DynamicField_LensOnMultiValueDropdown${RandomID}_0", 'css' );
        $LensOnMultiValueDropdownElement->is_enabled;
        $LensOnReferenceElement->is_displayed;
        is( $LensOnMultiValueDropdownElement->get_value, '', "LensOnMultiValueDropDown field is empty" );

        my $Element = $Selenium->find_element( "#DynamicField_SetInnerDropdown${RandomID}_0", 'css' );
        $Element->is_enabled;
        $Element->is_displayed;
        is( $Element->get_value, '', "SetInnerDropdown field is empty" );

        $Element = $Selenium->find_element( "#DynamicField_SetInnerText${RandomID}_0", 'css' );
        $Element->is_enabled;
        $Element->is_displayed;
        is( $Element->get_value, '', "SetInnerText field is empty" );

        # set reference source to ticket id with one value for each field
        my $TicketTitle = 'DynamicField values ticket ' . $RandomID . ' 2';
        $ReferenceSourceElement->send_keys($TicketTitle);
        $Selenium->WaitFor( JavaScript => "return \$('ul.ui-autocomplete li a:visible').length" );
        $Selenium->find_element( 'ul.ui-autocomplete li a', 'css' )->click;
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # verify that values are correct
        is(
            $Selenium->find_element( "#DynamicField_LensOnReference${RandomID}_0", 'css' )->get_value,
            $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 3' },
            'Lens on Reference: First item contains correct value'
        );
        is(
            $Selenium->find_element( "#DynamicField_LensOnMultiValueDropdown${RandomID}_0", 'css' )->get_value,
            'bcde',
            'Lens on MultiValueDropdown: First item contains correct value'
        );
        is(
            $Selenium->find_element( "#DynamicField_SetInnerDropdown${RandomID}_0", 'css' )->get_value,
            'cdef',
            "Lens on Set: Set-inner dropdown first element contains correct value"
        );
        is(
            $Selenium->find_element( "#DynamicField_SetInnerText${RandomID}_0", 'css' )->get_value,
            'Test Text Value',
            "Lens on Set: Set-inner text first element contains correct value"
        );

        # clear autocomplete first
        $Selenium->execute_script("\$('#Autocomplete_DynamicField_ReferenceSource$RandomID').val('')");
        $Selenium->WaitFor( JavaScript => "return \$('#Autocomplete_DynamicField_ReferenceSource$RandomID').val() == ''" );

        # set reference source to ticket id with three values for each field
        $TicketTitle = 'DynamicField values ticket ' . $RandomID . ' 3';
        $ReferenceSourceElement->send_keys($TicketTitle);
        $Selenium->WaitFor( JavaScript => "return \$('ul.ui-autocomplete li a:visible').length" );
        $Selenium->find_element( 'ul.ui-autocomplete li a', 'css' )->click;
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # verify that values are correct
        my %ExpectedValues = (
            "MultiValueDropdown" => [
                'abcd',
                'bcde',
                'cdef'
            ],
            "SetInnerDropdown" => [
                'abcd',
                'bcde',
                'cdef'
            ],
            "SetInnerText" => [
                'Test Text Value 1',
                'Test Text Value 2',
                'Test Text Value 3',
            ],
            "ReferenceTarget" => [
                $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 1' },
                $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 2' },
                $TicketIDForTitle{ 'Reference target ticket ' . $RandomID . ' 3' },
            ],
        );
        for my $Count ( 0 .. 2 ) {
            is(
                $Selenium->find_element( "#DynamicField_LensOnReference${RandomID}_$Count", 'css' )->get_value,
                $ExpectedValues{ReferenceTarget}[$Count],
                "Lens on Reference: Item $Count contains correct value"
            );
            is(
                $Selenium->find_element( "#DynamicField_LensOnMultiValueDropdown${RandomID}_$Count", 'css' )->get_value,
                $ExpectedValues{MultiValueDropdown}[$Count],
                "Lens on MultiValueDropdown: Item $Count contains correct value"
            );
            is(
                $Selenium->find_element( "#DynamicField_SetInnerDropdown${RandomID}_$Count", 'css' )->get_value,
                $ExpectedValues{SetInnerDropdown}[$Count],
                "Lens on Set: Set-inner dropdown element $Count contains correct value"
            );
            is(
                $Selenium->find_element( "#DynamicField_SetInnerText${RandomID}_$Count", 'css' )->get_value,
                $ExpectedValues{SetInnerText}[$Count],
                "Lens on Set: Set-inner text element $Count contains correct value"
            );
        }

        # clear autocomplete first
        $Selenium->execute_script("\$('#Autocomplete_DynamicField_ReferenceSource$RandomID').val('')");
        $Selenium->WaitFor( JavaScript => "return \$('#Autocomplete_DynamicField_ReferenceSource$RandomID').val() == ''" );

        # set reference source to ticket without values
        $TicketTitle = 'DynamicField values ticket ' . $RandomID . ' 1';
        $ReferenceSourceElement->send_keys($TicketTitle);
        $Selenium->WaitFor( JavaScript => "return \$('ul.ui-autocomplete li a:visible').length" );
        $Selenium->find_element( 'ul.ui-autocomplete li a', 'css' )->click;
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # verify that lens fields are empty
        $LensOnReferenceElement = $Selenium->find_element( "#Autocomplete_DynamicField_LensOnReference${RandomID}_0", 'css' );
        $LensOnReferenceElement->is_enabled;
        $LensOnReferenceElement->is_displayed;
        is( $LensOnReferenceElement->get_value, '', "LensOnReference field is empty" );

        $LensOnMultiValueDropdownElement = $Selenium->find_element( "#DynamicField_LensOnMultiValueDropdown${RandomID}_0", 'css' );
        $LensOnMultiValueDropdownElement->is_enabled;
        $LensOnReferenceElement->is_displayed;
        is( $LensOnMultiValueDropdownElement->get_value, '', "LensOnMultiValueDropDown field is empty" );

        $Element = $Selenium->find_element( "#DynamicField_SetInnerDropdown${RandomID}_0", 'css' );
        $Element->is_enabled;
        $Element->is_displayed;
        is( $Element->get_value, '', "SetInnerDropdown field is empty" );

        $Element = $Selenium->find_element( "#DynamicField_SetInnerText${RandomID}_0", 'css' );
        $Element->is_enabled;
        $Element->is_displayed;
        is( $Element->get_value, '', "SetInnerText field is empty" );

        # delete created test dynamic fields
        #   delete in reversed order to delete the set before its inner fields are deleted
        my $Success;
        my %FieldNameToID = reverse %FieldIDToName;
        for my $FieldID ( sort { $b <=> $a } keys %FieldNameToID ) {
            my $FieldName          = $FieldNameToID{$FieldID};
            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $FieldName,
            );
            is( $DynamicFieldConfig, hash { field 'Name' => $FieldName; etc(); }, "Field config for field $FieldName is existent" );

            # delete values first
            my $ValuesDeleteSuccess = $DynamicFieldBackendObject->AllValuesDelete(
                DynamicFieldConfig => $DynamicFieldConfig,
                UserID             => $TestUserID,
            );
            ok( $ValuesDeleteSuccess, "Values of field $FieldName deleted successfully" );

            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $FieldID,
                UserID => $TestUserID,
            );
            ok( $Success, "DynamicField $FieldName deleted successfully" );
        }

        # delete test tickets
        for my $TicketID ( values %TicketIDForTitle ) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
            }
            ok( $Success, "TicketID $TicketID is deleted" );
        }
    }
);

sub _GetFieldOrder {

    # determine field order
    my $DFConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid => 0,
    );
    my $MaxFieldOrder = 1;
    if ( IsArrayRefWithData($DFConfigs) ) {
        $MaxFieldOrder = max( map { $_->{FieldOrder} } $DFConfigs->@* );
    }

    # increase by one to get an unused field order
    $MaxFieldOrder++;

    return $MaxFieldOrder;
}

done_testing;
