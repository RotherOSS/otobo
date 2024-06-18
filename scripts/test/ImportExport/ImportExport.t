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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');
my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# create needed users
my @UserIDs;
{

    # disable email checks to create new user
    my $CheckEmailAddressesOrg =
        $ConfigObject->Get('CheckEmailAddresses') || 1;

    $ConfigObject->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    for my $Counter ( 1 .. 2 ) {

        # create new users for the tests
        my $UserID = $UserObject->UserAdd(
            UserFirstname => 'ImportExport' . $Counter,
            UserLastname  => 'UnitTest',
            UserLogin     => 'UnitTest-ImportExport-' . $Counter . $Helper->GetRandomID(),
            UserEmail     => 'UnitTest-ImportExport-' . $Counter . '@localhost',
            ValidID       => 1,
            ChangeUserID  => 1,
        );

        push @UserIDs, $UserID;
    }

    # restore original email check param

    $ConfigObject->Set(
        Key   => 'CheckEmailAddresses',
        Value => $CheckEmailAddressesOrg,
    );
}

# create needed random template names
my @TemplateName;

for my $Counter ( 1 .. 5 ) {

    push @TemplateName, 'UnitTest' . $Helper->GetRandomID();
}

# create needed random object names
my @ObjectName;
push @ObjectName, 'UnitTest' . $Helper->GetRandomID();

# create needed format names
my @FormatName = ('CSV');

# get original template list for later checks (all elements)
my $TemplateList1All = $ImportExportObject->TemplateList(
    UserID => 1,
);

# get original template list for later checks (all elements)
my $TemplateList1Object = $ImportExportObject->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# ------------------------------------------------------------ #
# define general tests
# ------------------------------------------------------------ #

my $ItemData = [

    # this template is NOT complete and must not be added
    {
        Add => {
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object => $ObjectName[0],
            Format => $FormatName[0],
            Name   => $TemplateName[0],
            UserID => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
        },
    },

    # this template must be inserted successfully
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            Object   => $ObjectName[0],
            Format   => $FormatName[0],
            Name     => $TemplateName[0],
            ValidID  => 1,
            Comment  => '',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template have the same name as one test before and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template must be inserted successfully
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[1],
            ValidID => 1,
            Comment => 'TestComment',
            UserID  => 1,
        },
        AddGet => {
            Object   => $ObjectName[0],
            Format   => $FormatName[0],
            Name     => $TemplateName[1],
            ValidID  => 1,
            Comment  => 'TestComment',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            ValidID => 2,
            UserID  => $UserIDs[0],
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            Name   => $TemplateName[1] . 'UPDATE1',
            UserID => $UserIDs[0],
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            Name    => $TemplateName[1] . 'UPDATE2',
            ValidID => 2,
        },
    },

    # the template one add-test before must be updated (template update arguments are complete)
    {
        Update => {
            Name    => $TemplateName[1] . 'UPDATE3',
            Comment => 'TestComment UPDATE3',
            ValidID => 2,
            UserID  => $UserIDs[0],
        },
        UpdateGet => {
            Name     => $TemplateName[1] . 'UPDATE3',
            ValidID  => 2,
            Comment  => 'TestComment UPDATE3',
            CreateBy => 1,
            ChangeBy => $UserIDs[0],
        },
    },

    # the template one add-test before must be updated (template update arguments are complete)
    {
        Update => {
            Name    => $TemplateName[1] . 'UPDATE4',
            ValidID => 1,
            Comment => '',
            UserID  => 1,
        },
        UpdateGet => {
            Name     => $TemplateName[1] . 'UPDATE4',
            ValidID  => 1,
            Comment  => '',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template must be inserted successfully (check string cleaner function)
    {
        Add => {
            Object  => " \t \n \r " . $ObjectName[0] . " \t \n \r ",
            Format  => " \t \n \r " . $FormatName[0] . " \t \n \r ",
            Name    => " \t \n \r " . $TemplateName[2] . " \t \n \r ",
            ValidID => 1,
            Comment => " \t \n \r Test Comment \t \n \r ",
            UserID  => 1,
        },
        AddGet => {
            Object   => $ObjectName[0],
            Format   => $FormatName[0],
            Name     => $TemplateName[2],
            ValidID  => 1,
            Comment  => 'Test Comment',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # the template one add-test before must be updated (check string cleaner function)
    {
        Update => {
            Name    => " \t \n \r " . $TemplateName[2] . "UPDATE1 \t \n \r ",
            ValidID => 1,
            Comment => " \t \n \r Test Comment UPDATE1 \t \n \r ",
            UserID  => 1,
        },
        UpdateGet => {
            Name     => $TemplateName[2] . 'UPDATE1',
            ValidID  => 1,
            Comment  => 'Test Comment UPDATE1',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template must be inserted successfully (Unicode checks)
    {
        Add => {
            Object  => ' ƕ Ƙ ' . $ObjectName[0] . ' Ƶ ƻ ',
            Format  => ' Ǔ ǣ ' . $FormatName[0] . ' ǥ Ǯ ',
            Name    => ' Ƿ Ȝ ' . $TemplateName[3] . ' Ȟ Ƞ ',
            ValidID => 2,
            Comment => ' Ѡ Ѥ TestComment5 Ϡ Ω ',
            UserID  => 1,
        },
        AddGet => {
            Object   => 'ƕƘ' . $ObjectName[0] . 'Ƶƻ',
            Format   => 'Ǔǣ' . $FormatName[0] . 'ǥǮ',
            Name     => 'Ƿ Ȝ ' . $TemplateName[3] . ' Ȟ Ƞ',
            ValidID  => 2,
            Comment  => 'Ѡ Ѥ TestComment5 Ϡ Ω',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },
];

# ------------------------------------------------------------ #
# run general tests
# ------------------------------------------------------------ #

my $TestCount = 1;
my @AddedTemplateIDs;

TEMPLATE:
for my $Item ( @{$ItemData} ) {

    if ( $Item->{Add} ) {

        # add new template
        my $TemplateID = $ImportExportObject->TemplateAdd( %{ $Item->{Add} } );

        if ($TemplateID) {
            push @AddedTemplateIDs, $TemplateID;
        }

        # check if template was added successfully or not
        if ( $Item->{AddGet} ) {
            ok(
                $TemplateID,
                "Test $TestCount: TemplateAdd() - TemplateKey: $TemplateID"
            );
        }
        else {
            ok( !$TemplateID, "Test $TestCount: TemplateAdd()" );
        }
    }

    if ( $Item->{AddGet} ) {

        # get template data to check the values after template was added
        my $TemplateGet = $ImportExportObject->TemplateGet(
            TemplateID => $AddedTemplateIDs[-1],
            UserID     => $Item->{Add}->{UserID} || 1,
        );

        # check template data after creation of template
        for my $TemplateAttribute ( sort keys %{ $Item->{AddGet} } ) {
            is(
                $TemplateGet->{$TemplateAttribute} || '',
                $Item->{AddGet}->{$TemplateAttribute} || '',
                "Test $TestCount: TemplateGet() - $TemplateAttribute",
            );
        }
    }

    if ( $Item->{Update} ) {

        # check last template id variable
        if ( !$AddedTemplateIDs[-1] ) {
            fail("Test $TestCount: NO LAST ITEM ID GIVEN. Please add a template first.");

            last TEMPLATE;
        }

        # update the template
        my $UpdateSucess = $ImportExportObject->TemplateUpdate(
            %{ $Item->{Update} },
            TemplateID => $AddedTemplateIDs[-1],
        );

        # check if template was updated successfully or not
        if ( $Item->{UpdateGet} ) {
            ok(
                $UpdateSucess,
                "Test $TestCount: TemplateUpdate() - TemplateKey: $AddedTemplateIDs[-1]",
            );
        }
        else {
            ok(
                !$UpdateSucess,
                "Test $TestCount: TemplateUpdate()",
            );
        }
    }

    if ( $Item->{UpdateGet} ) {

        # get template data to check the values after the update
        my $TemplateGet = $ImportExportObject->TemplateGet(
            TemplateID => $AddedTemplateIDs[-1],
            UserID     => $Item->{Update}->{UserID} || 1,
        );

        # check template data after update
        for my $TemplateAttribute ( sort keys %{ $Item->{UpdateGet} } ) {
            is(
                $TemplateGet->{$TemplateAttribute} || '',
                $Item->{UpdateGet}->{$TemplateAttribute} || '',
                "Test $TestCount: TemplateGet() - $TemplateAttribute",
            );
        }
    }
}
continue {

    # increment the counter
    $TestCount++;
}

# ------------------------------------------------------------ #
# TemplateList test 1 (check array references)
# ------------------------------------------------------------ #

# list must be an empty array reference
ok(
    ref $TemplateList1All eq 'ARRAY' && ref $TemplateList1Object eq 'ARRAY',
    "Test $TestCount: TemplateList() - array references",
);

$TestCount++;

# ------------------------------------------------------------ #
# TemplateList test 2 (list must be empty)
# ------------------------------------------------------------ #

# list must be an empty list
ok(
    scalar @{$TemplateList1Object} eq 0,
    "Test $TestCount: TemplateList() - empty list",
);

$TestCount++;

# ------------------------------------------------------------ #
# TemplateList test 2 (check correct number of new items)
# ------------------------------------------------------------ #

# get template list with all elements
my $TemplateList2 = $ImportExportObject->TemplateList(
    UserID => 1,
);

# list must be an array reference
ok(
    ref $TemplateList2 eq 'ARRAY',
    "Test $TestCount: TemplateList() - array reference",
);

my $TemplateListCount = scalar @{$TemplateList2} - scalar @{$TemplateList1All};

# check correct number of new items
ok(
    $TemplateListCount eq scalar @AddedTemplateIDs,
    "Test $TestCount: TemplateList() - correct number of new items",
);

$TestCount++;

# ------------------------------------------------------------ #
# TemplateDelete test 1 (add one template and delete it)
# ------------------------------------------------------------ #

# get template list with all elements
my $TemplateDelete1List1 = $ImportExportObject->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# add a test template
my $TemplateDeleteID = $ImportExportObject->TemplateAdd(
    Object  => $ObjectName[0],
    Format  => $FormatName[0],
    Name    => $TemplateName[4],
    ValidID => 1,
    UserID  => 1,
);

# get template list with all elements
my $TemplateDelete1List2 = $ImportExportObject->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# list must have one element more
ok(
    scalar @{$TemplateDelete1List1} eq ( scalar @{$TemplateDelete1List2} ) - 1,
    "Test $TestCount: TemplateDelete() - number of listed elements",
);

# delete the new template
my $TemplateDelete1 = $ImportExportObject->TemplateDelete(
    TemplateID => $TemplateDeleteID,
    UserID     => 1,
);

# list must be successful
ok(
    $TemplateDelete1,
    "Test $TestCount: TemplateDelete()",
);

# get template list with all elements
my $TemplateDelete1List3 = $ImportExportObject->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# list must have the original number of elements
ok(
    scalar @{$TemplateDelete1List1} eq scalar @{$TemplateDelete1List3},
    "Test $TestCount: TemplateDelete() - number of listed elements",
);

$TestCount++;

# ------------------------------------------------------------ #
# TemplateDelete test 2 (delete all unit test templates)
# ------------------------------------------------------------ #

for my $TemplateID (@AddedTemplateIDs) {

    # delete the template
    my $Success = $ImportExportObject->TemplateDelete(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    # check success
    ok(
        $Success,
        "Test $TestCount: TemplateDelete() TemplateID $TemplateID",
    );

    $TestCount++;
}

# ------------------------------------------------------------ #
# ObjectList test 1 (check general functionality)
# ------------------------------------------------------------ #

# define test list
my $ObjectList1TestList = {
    UnitTest1 => {
        Module => 'Kernel::System::ImportExport::ObjectBackend::UnitTest1',
        Name   => 'Unit Test 1',
    },
    UnitTest2 => {
        Module => 'Kernel::System::ImportExport::ObjectBackend::UnitTest2',
        Name   => 'Unit Test 2',
    },
};

# get original object list
my $ObjectListOrg =
    $ConfigObject->Get('ImportExport::ObjectBackendRegistration');

# set test list
$ConfigObject->Set(
    Key   => 'ImportExport::ObjectBackendRegistration',
    Value => $ObjectList1TestList,
);

# get object list
my $ObjectList1 = $ImportExportObject->ObjectList();

# list must be a hash reference
ok(
    ref $ObjectList1 eq 'HASH',
    "Test $TestCount: ObjectList() - hash reference",
);

# check the list
KEY:
for my $Key ( sort keys %{$ObjectList1} ) {

    if ( !$ObjectList1TestList->{$Key} ) {
        $ObjectList1TestList->{Dummy} = 1;
    }

    next KEY if $ObjectList1->{$Key} ne $ObjectList1TestList->{$Key}->{Name};

    delete $ObjectList1TestList->{$Key};
}

ok(
    !%{$ObjectList1TestList},
    "Test $TestCount: ObjectList() - content is valid",
);

# restore original object list
$ConfigObject->Set(
    Key   => 'ImportExport::ObjectBackendRegistration',
    Value => $ObjectListOrg,
);

$TestCount++;

# ------------------------------------------------------------ #
# FormatList test 1 (check general functionality)
# ------------------------------------------------------------ #

# define test list
my $FormatList1TestList = {
    UnitTest1 => {
        Module => 'Kernel::System::ImportExport::FormatBackend::UnitTest1',
        Name   => 'Unit Test 1',
    },
    UnitTest2 => {
        Module => 'Kernel::System::ImportExport::FormatBackend::UnitTest2',
        Name   => 'Unit Test 2',
    },
};

# get original format list
my $FormatListOrg =
    $ConfigObject->Get('ImportExport::FormatBackendRegistration');

# set test list
$ConfigObject->Set(
    Key   => 'ImportExport::FormatBackendRegistration',
    Value => $FormatList1TestList,
);

# get format list
my $FormatList1 = $ImportExportObject->FormatList();

# list must be a hash reference
ok(
    ref $FormatList1 eq 'HASH',
    "Test $TestCount: FormatList() - hash reference",
);

# check the list
KEY:
for my $Key ( sort keys %{$FormatList1} ) {

    if ( !$FormatList1TestList->{$Key} ) {
        $FormatList1TestList->{Dummy} = 1;
    }

    next KEY if $FormatList1->{$Key} ne $FormatList1TestList->{$Key}->{Name};

    delete $FormatList1TestList->{$Key};
}

ok(
    !%{$FormatList1TestList},
    "Test $TestCount: FormatList() - content is valid",
);

# restore original format list
$ConfigObject->Set(
    Key   => 'ImportExport::FormatBackendRegistration',
    Value => $FormatListOrg,
);

done_testing;
