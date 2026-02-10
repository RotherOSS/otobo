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
use Test2::V0 qw(:DEFAULT), qw(bag item etc);
use List::AllUtils qw(max min true first);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# Sanity check whether ImportExport is available.
# This should succeed since ImportExport has been integrated into OTOBO core
{
    # get ImportExport module directory
    my $ImportExportModule = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/System/ImportExport.pm';
    ok( -f $ImportExportModule, 'ImportExport.pm exists' );
}

# get needed objects
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my $ImportExportObject    = $Kernel::OM->Get('Kernel::System::ImportExport');
my $ValidObject           = $Kernel::OM->Get('Kernel::System::Valid');
my %FormatBackendObject   = (
    CSV  => $Kernel::OM->Get('Kernel::System::ImportExport::FormatBackend::CSV'),
    JSON => $Kernel::OM->Get('Kernel::System::ImportExport::FormatBackend::JSON'),
);
my $ObjectBackendObject = $Kernel::OM->Get('Kernel::System::ImportExport::ObjectBackend::CustomerCompany');
my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# define needed variable
my $RandomID = $Helper->GetRandomID;
my $InvalidValidID;
my $ValidValidID;

# get invalid valid id
my %ValidList = $ValidObject->ValidList();
$ValidValidID = first {$_} keys %ValidList;
for ( 1 .. 20 ) {
    my $RandomNumber = $Helper->GetRandomNumber();
    if ( !exists $ValidList{$RandomNumber} ) {
        $InvalidValidID = $RandomNumber;
    }
}

# create test user
my ( undef, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

# add some CustomerCompany test templates for later checks
# mostly with dummy formats, but use 5 and 6 for CSV and JSON tests.
my @TemplateIDs;
{
    my %Format = (
        5 => 'CSV',
        6 => 'JSON',
    );

    for my $i ( 0 .. 29 ) {
        my $TemplateID = $ImportExportObject->TemplateAdd(
            Object  => 'CustomerCompany',
            Format  => ( $Format{$i} || 'UnitTest' . $i . $RandomID ),
            Name    => 'UnitTest' . $i . $RandomID,
            ValidID => 1,
            UserID  => $TestUserID,
        );

        push @TemplateIDs, $TemplateID;
    }
}

# ObjectList test 1 (check CSV item)
{
    my $ObjectList = $ImportExportObject->ObjectList;
    ok(
        $ObjectList && ref $ObjectList eq 'HASH' && $ObjectList->{CustomerCompany},
        "ObjectList() - CustomerCompany exists",
    );
}

# ObjectAttributesGet test 1 (check attribute hash)
{
    my $ObjectAttributesGet1 = $ImportExportObject->ObjectAttributesGet(
        TemplateID => $TemplateIDs[0],
        UserID     => $TestUserID,
    );

    # check object attribute reference
    ok(
        $ObjectAttributesGet1 && ref $ObjectAttributesGet1 eq 'ARRAY',
        "ObjectAttributesGet() - check array reference",
    );

    # define the reference hash
    my $ObjectAttributesGet1Reference = [
        {
            'Input' => {
                'Data' => {
                    1 => 'valid',
                    2 => 'invalid',
                    3 => 'invalid-temporarily'
                },
                'PossibleNone' => 0,
                'Required'     => 1,
                'Translation'  => 1,
                'Type'         => 'Selection',
                'ValueDefault' => 1
            },
            'Name' => 'Default Validity',
            'Key'  => 'DefaultValid',
        }
    ];

    is(
        $ObjectAttributesGet1,
        $ObjectAttributesGet1Reference,
        "ObjectAttributesGet() - attributes of the row are identical",
    );
}

# ObjectAttributesGet test 2 (check with non existing template)
{
    my $ObjectAttributesGet2 = $ImportExportObject->ObjectAttributesGet(
        TemplateID => $TemplateIDs[-1] + 1,
        UserID     => $TestUserID,
    );
    is(
        $ObjectAttributesGet2,
        undef,
        "ObjectAttributesGet() - expected to fail",
    );
}

# MappingObjectAttributesGet test 1 (check attribute hash)
{
    my $MappingObjectAttributesGet1 = $ImportExportObject->MappingObjectAttributesGet(
        TemplateID => $TemplateIDs[0],
        UserID     => $TestUserID,
    );

    # check mapping object attribute reference
    ok(
        $MappingObjectAttributesGet1 && ref $MappingObjectAttributesGet1 eq 'ARRAY',
        "MappingObjectAttributesGet() - check array reference",
    );
}

# MappingObjectAttributesGet test 2 (check with non existing template)
{
    my $MappingObjectAttributesGet2 = $ImportExportObject->MappingObjectAttributesGet(
        TemplateID => $TemplateIDs[-1] + 1,
        UserID     => $TestUserID,
    );

    is(
        $MappingObjectAttributesGet2,
        undef,
        "MappingObjectAttributesGet() - expected to fail",
    );
}

# don't care about valid emails
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# define the test config items
my @CustomerCompanySetups;

# two config items for TwoCustomerUsers
push @CustomerCompanySetups,
    {
        Description        => 'first simple customer company',
        CustomerCompanyAdd => {
            CustomerID             => 'testcompany1' . $RandomID,
            CustomerCompanyName    => 'TestCompany 1 ' . $RandomID,
            CustomerCompanyStreet  => 'TestStreet1' . $RandomID,
            CustomerCompanyZIP     => $RandomID,
            CustomerCompanyCity    => 'TestCity1' . $RandomID,
            CustomerCompanyCountry => 'TestCountry1' . $RandomID,
            CustomerCompanyURL     => 'https://testurl1' . $RandomID . '.test',
            CustomerCompanyComment => 'Test Comment 1 ' . $RandomID,
            ValidID                => 1,
            UserID                 => $TestUserID,
        },
    },
    {
        Description        => 'second simple customer company',
        CustomerCompanyAdd => {
            CustomerID             => 'testcompany2' . $RandomID,
            CustomerCompanyName    => 'TestCompany 2 ' . $RandomID,
            CustomerCompanyStreet  => 'TestStreet2' . $RandomID,
            CustomerCompanyZIP     => $RandomID,
            CustomerCompanyCity    => 'TestCity2' . $RandomID,
            CustomerCompanyCountry => 'TestCountry2' . $RandomID,
            CustomerCompanyURL     => 'https://testurl2' . $RandomID . '.test',
            CustomerCompanyComment => 'Test Comment 2 ' . $RandomID,
            ValidID                => 1,
            UserID                 => $TestUserID,
        },
    };

# add the test config items
my @CustomerCompanyIDs;
for my $Setup (@CustomerCompanySetups) {

    # add a config item
    diag "add customer company: $Setup->{Description}";
    my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
        $Setup->{CustomerCompanyAdd}->%*,
    );
    ok( $CustomerCompanyID, 'customer company added' );

    push @CustomerCompanyIDs, $CustomerCompanyID;
}

# declare ExportData tests
my @ExportDataTests = (
    {
        Name             => q{ImportDataGet doesn't contains all data (check required attributes)},
        SourceExportData => {
            ExportDataGet => {
                UserID => $TestUserID,
            },
        },
    },

    {
        Name             => q{ImportDataGet doesn't contains all data (check required attributes)},
        SourceExportData => {
            ExportDataGet => {
                TemplateID => $TemplateIDs[1],
            },
        },
    },

    # {
    #     Name             => q{no existing template id is given (should fail)},
    #     SourceExportData => {
    #         ExportDataGet => {
    #             TemplateID => $TemplateIDs[-1] + 1,
    #             UserID     => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{no class id is given (should fail)},
    #     SourceExportData => {
    #         ExportDataGet => {
    #             TemplateID => $TemplateIDs[2],
    #             UserID     => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{invalid valid id is given (should fail)},
    #     SourceExportData => {
    #         ObjectData => {
    #             ValidID => $InvalidValidID,
    #         },
    #         ExportDataGet => {
    #             TemplateID => $TemplateIDs[2],
    #             UserID     => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{mapping list is empty (should fail)},
    #     SourceExportData => {
    #         ObjectData => {
    #             ValidID => $ValidValidID,
    #         },
    #         ExportDataGet => {
    #             TemplateID => $TemplateIDs[3],
    #             UserID     => $TestUserID,
    #         },
    #     },
    # },

    {
        Name             => q{all required values are given (number search check)},
        SourceExportData => {
            ObjectData => {
                ValidID => $ValidValidID,
            },
            MappingObjectData => [
                {
                    Key => 'CustomerID',
                },
            ],
            SearchData => {
                CustomerID => $CustomerCompanyIDs[0],
            },
            ExportDataGet => {
                TemplateID => $TemplateIDs[5],
                UserID     => $TestUserID,
            },
        },

        # bag is like array but doesn't care about the order of items
        #   relevant because the template doesn't allow to specify a sorting
        ReferenceExportData => bag {
            item [ $CustomerCompanyIDs[0] ];
            item [ $CustomerCompanyIDs[1] ];

            # we don't care about additional items
            etc();
        },
    },

    # CSV exports

    {
        Name             => q{Export Name and Number as CSV},
        SourceExportData => {
            ObjectData => {
                ValidID => $ValidValidID,
            },
            MappingObjectData => [
                {
                    Key => 'CustomerCompanyName',
                },
                {
                    Key => 'CustomerID',
                },
            ],
            SearchData => {

                # Empty hash must be specified, as otherwise the previously set up SearchData prevails
            },
            ExportDataGet => {
                TemplateID => $TemplateIDs[5],
                UserID     => $TestUserID,
            },
            ExportDataSave => {
                TemplateID => $TemplateIDs[5],    # usually same as for ExportDataGet
                Format     => 'CSV',
                FormatData => {
                    ColumnSeparator => 'Semicolon',
                    Charset         => 'UTF-8',
                },
            },
        },

        # There is no way to specify the sort order in ExportDataGet().
        # bag is like array but doesn't care about the order of items
        #   relevant because the template doesn't allow to specify a sorting
        ReferenceExportData => bag {
            item [
                'TestCompany 1 ' . $RandomID,
                $CustomerCompanyIDs[0],
            ];
            item [
                'TestCompany 2 ' . $RandomID,
                $CustomerCompanyIDs[1],
            ];

            # we don't care about additional items
            etc();
        },

        # bag is like array but doesn't care about the order of items
        #   relevant because the template doesn't allow to specify a sorting
        ReferenceExportContent => bag {
            item join(
                ';',
                qq{"TestCompany 2 $RandomID"},
                qq{"$CustomerCompanyIDs[1]"}
            );
            item join(
                ';',
                qq{"TestCompany 1 $RandomID"},
                qq{"$CustomerCompanyIDs[0]"}
            );

            # we don't care about additional items
            etc();
        },
    },
);

# run general ExportDataGet tests
for my $Test (@ExportDataTests) {

    subtest "ExportData: $Test->{Name}" => sub {

        # check SourceExportData attribute
        if ( !$Test->{SourceExportData} || ref $Test->{SourceExportData} ne 'HASH' ) {

            fail("SourceExportData not found for this test.");

            return;
        }

        # set the object data
        if (
            $Test->{SourceExportData}->{ObjectData}
            && ref $Test->{SourceExportData}->{ObjectData} eq 'HASH'
            && $Test->{SourceExportData}->{ExportDataGet}->{TemplateID}
            )
        {

            # save object data
            $ImportExportObject->ObjectDataSave(
                TemplateID => $Test->{SourceExportData}->{ExportDataGet}->{TemplateID},
                ObjectData => $Test->{SourceExportData}->{ObjectData},
                UserID     => $TestUserID,
            );
        }

        # set the mapping object data
        if (
            $Test->{SourceExportData}->{MappingObjectData}
            && ref $Test->{SourceExportData}->{MappingObjectData} eq 'ARRAY'
            && $Test->{SourceExportData}->{ExportDataGet}->{TemplateID}
            )
        {

            # delete all existing mapping data
            $ImportExportObject->MappingDelete(
                TemplateID => $Test->{SourceExportData}->{ExportDataGet}->{TemplateID},
                UserID     => $TestUserID,
            );

            # add the mapping object rows
            MAPPINGOBJECTDATA:
            for my $MappingObjectData ( @{ $Test->{SourceExportData}->{MappingObjectData} } ) {

                # add a new mapping row
                my $MappingID = $ImportExportObject->MappingAdd(
                    TemplateID => $Test->{SourceExportData}->{ExportDataGet}->{TemplateID},
                    UserID     => $TestUserID,
                );

                # add the mapping object data
                $ImportExportObject->MappingObjectDataSave(
                    MappingID         => $MappingID,
                    MappingObjectData => $MappingObjectData,
                    UserID            => $TestUserID,
                );
            }
        }

        # add the search data
        if (
            $Test->{SourceExportData}->{SearchData}
            && ref $Test->{SourceExportData}->{SearchData} eq 'HASH'
            && $Test->{SourceExportData}->{ExportDataGet}->{TemplateID}
            )
        {

            # save search data
            $ImportExportObject->SearchDataSave(
                TemplateID => $Test->{SourceExportData}->{ExportDataGet}->{TemplateID},
                SearchData => $Test->{SourceExportData}->{SearchData},
                UserID     => $TestUserID,
            );
        }

        # get export data as an arrayref
        my $ExportData = $ObjectBackendObject->ExportDataGet(
            %{ $Test->{SourceExportData}->{ExportDataGet} },
        );

        if ( !$Test->{ReferenceExportData} ) {
            ok( !$ExportData, "ExportDataGet() returned not data as was expected" );

            return;
        }

        if ( ref $ExportData ne 'ARRAY' ) {

            # check array reference
            fail("ExportDataGet() - return value is not an array reference");

            return;
        }

        # ReferenceExportData should be a check of type bag
        is(
            $ExportData,
            $Test->{ReferenceExportData},
            'ExportDataGet(): expected content is present'
        );

        # optionally test the formatted export
        if ( $Test->{SourceExportData}->{ExportDataSave} ) {
            if ( !$Test->{ReferenceExportContent} ) {
                fail("ReferenceExportContent is set up");

                return;
            }

            my $TemplateID = $Test->{SourceExportData}->{ExportDataSave}->{TemplateID};

            # specify the format
            $ImportExportObject->FormatDataSave(
                TemplateID => $TemplateID,
                FormatData => $Test->{SourceExportData}->{ExportDataSave}->{FormatData},
                UserID     => $TestUserID,
            );

            # get export data rows
            my $Format = $Test->{SourceExportData}->{ExportDataSave}->{Format};
            diag "Format of content is: $Format";
            my $FormatBackend = $FormatBackendObject{$Format};
            my @Content;
            for my $Row ( $ExportData->@* ) {
                push @Content, $FormatBackend->ExportDataSave(
                    TemplateID    => $TemplateID,
                    ExportDataRow => $Row,
                    UserID        => $TestUserID,
                );
            }

            is(
                \@Content,

                # ReferenceExportContent should be a check of type bag
                $Test->{ReferenceExportContent},
                'ExportDataSave() produced expected content'
            );
        }
    };
}

# ------------------------------------------------------------ #
# define general ImportDataSave tests
# ------------------------------------------------------------ #

my @ImportDataTests = (

    # {
    #     Name             => q{ImportDataSave doesn't contains all data (check required attributes) 1},
    #     SourceImportData => {
    #         ImportDataSave => {
    #             ImportDataRow => [],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{ImportDataSave doesn't contains all data (check required attributes) 2},
    #     SourceImportData => {
    #         ImportDataSave => {
    #             TemplateID => $TemplateIDs[20],
    #             UserID     => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{ImportDataSave doesn't contains all data (check required attributes) 3},
    #     SourceImportData => {
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[20],
    #             ImportDataRow => [],
    #         },
    #     },
    # },

    # {
    #     Name             => q{import data row must be an array reference (should fail)},
    #     SourceImportData => {
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[20],
    #             ImportDataRow => '',
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{import data row must be an array reference (should fail)},
    #     SourceImportData => {
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[20],
    #             ImportDataRow => {},
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{no existing template id is given (should fail)},
    #     SourceImportData => {
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[-1] + 1,
    #             ImportDataRow => ['Dummy'],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{no class id is given (should fail)},
    #     SourceImportData => {
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[21],
    #             ImportDataRow => ['Dummy'],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{invalid class id is given (should fail)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ValidID => $InvalidValidID,
    #         },
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[22],
    #             ImportDataRow => ['Dummy'],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{mapping list is empty (should fail)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ValidID => $ValidValidID,
    #         },
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[23],
    #             ImportDataRow => ['Dummy'],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{more than one identifier with the same name (should fail)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ValidID => $ValidValidID,
    #         },
    #         MappingObjectData => [
    #             {
    #                 Key        => 'CustomerID',
    #                 Identifier => 1,
    #             },
    #             {
    #                 Key        => 'CustomerID',
    #                 Identifier => 1,
    #             },
    #         ],
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[23],
    #             ImportDataRow => [ '123', '321' ],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{identifier is empty (should fail)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ValidID => $ValidValidID,
    #         },
    #         MappingObjectData => [
    #             {
    #                 Key        => 'CustomerID',
    #                 Identifier => 1,
    #             },
    #         ],
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[23],
    #             ImportDataRow => [''],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{identifier is undef (should fail)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ValidID => $ValidValidID,
    #         },
    #         MappingObjectData => [
    #             {
    #                 Key        => 'CustomerID',
    #                 Identifier => 1,
    #             },
    #         ],
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[23],
    #             ImportDataRow => [undef],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{empty name is given (should fail)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ValidID => $ValidValidID,
    #         },
    #         MappingObjectData => [
    #             {
    #                 Key => 'CustomerID',
    #             },
    #             {
    #                 Key => 'CustomerCompanyName',
    #             },
    #             {
    #                 Key => 'CustomerCompanyStreet',
    #             },
    #         ],
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[24],
    #             ImportDataRow => [ '', 'Production', 'Operational' ],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # {
    #     Name             => q{invalid deployment state is given (should fail)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ClassID => $ValidConfigItemClassID,
    #         },
    #         MappingObjectData => [
    #             {
    #                 Key => 'Name',
    #             },
    #             {
    #                 Key => 'DeplState',
    #             },
    #             {
    #                 Key => 'InciState',
    #             },
    #         ],
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[24],
    #             ImportDataRow => [ 'UnitTest - Importtest 1', 'Dummy', 'Operational' ],
    #             UserID        => $TestUserID,
    #         },
    #     },
    # },

    # # test without any dynamic fields
    # {
    #     Name             => qq{no dynamic fields (should succeed)},
    #     SourceImportData => {
    #         ObjectData => {
    #             ClassID => $ValidConfigItemClassID,
    #         },
    #         MappingObjectData => [
    #             {
    #                 Key => 'Name',
    #             },
    #             {
    #                 Key => 'DeplState',
    #             },
    #             {
    #                 Key => 'InciState',
    #             },
    #         ],
    #         ImportDataSave => {
    #             TemplateID    => $TemplateIDs[25],
    #             ImportDataRow => [
    #                 'UnitTest - Importtest 3',
    #                 'Production',
    #                 'Operational',
    #             ],
    #             UserID => $TestUserID,
    #         },
    #     },
    #     ReferenceImportData => {
    #         VersionCount => 1,
    #         LastVersion  => {
    #             Name                                          => 'UnitTest - Importtest 3',
    #             DeplState                                     => 'Production',
    #             InciState                                     => 'Operational',
    #             "DynamicField_CustomerCIO$TestIDSuffix"       => undef,
    #             "DynamicField_CustomerSalesTeam$TestIDSuffix" => undef,
    #         },
    #     },
    # },
);

# run general ImportDataTests tests
my $ImportTestCount = 1;
for my $Test (@ImportDataTests) {

    subtest "ImportData: $Test->{Name}" => sub {

        # check SourceImportData attribute
        if ( !$Test->{SourceImportData} || ref $Test->{SourceImportData} ne 'HASH' ) {

            fail("SourceImportData not found for this test.");

            return;
        }

        # set the object data
        if (
            $Test->{SourceImportData}->{ObjectData}
            && ref $Test->{SourceImportData}->{ObjectData} eq 'HASH'
            && $Test->{SourceImportData}->{ImportDataSave}->{TemplateID}
            )
        {
            $ImportExportObject->ObjectDataSave(
                TemplateID => $Test->{SourceImportData}->{ImportDataSave}->{TemplateID},
                ObjectData => $Test->{SourceImportData}->{ObjectData},
                UserID     => $TestUserID,
            );
        }

        # set the mapping object data
        if (
            $Test->{SourceImportData}->{MappingObjectData}
            && ref $Test->{SourceImportData}->{MappingObjectData} eq 'ARRAY'
            && $Test->{SourceImportData}->{ImportDataSave}->{TemplateID}
            )
        {

            # delete all existing mapping data
            $ImportExportObject->MappingDelete(
                TemplateID => $Test->{SourceImportData}->{ImportDataSave}->{TemplateID},
                UserID     => $TestUserID,
            );

            # add the mapping object rows
            MAPPINGOBJECTDATA:
            for my $MappingObjectData ( @{ $Test->{SourceImportData}->{MappingObjectData} } ) {

                # add a new mapping row
                my $MappingID = $ImportExportObject->MappingAdd(
                    TemplateID => $Test->{SourceImportData}->{ImportDataSave}->{TemplateID},
                    UserID     => $TestUserID,
                );

                # add the mapping object data
                $ImportExportObject->MappingObjectDataSave(
                    MappingID         => $MappingID,
                    MappingObjectData => $MappingObjectData,
                    UserID            => $TestUserID,
                );
            }
        }

        # import data save
        my ( $CustomerCompanyID, $RetCode ) = $ObjectBackendObject->ImportDataSave(
            %{ $Test->{SourceImportData}->{ImportDataSave} },
            Counter => $ImportTestCount,
        );

        if ( !$Test->{ReferenceImportData} ) {

            ok( !$CustomerCompanyID, "ImportDataSave() - return no CustomerCompanyID" );
            ok( !$RetCode,           "ImportDataSave() - return no RetCode" );

            return;
        }

        ok( $CustomerCompanyID, "ImportDataSave() - return CustomerCompanyID: $CustomerCompanyID" );
        ok( $RetCode,           "ImportDataSave() - return RetCode: $RetCode" );

        # get the latest version
        my %CustomerCompanyData = $CustomerCompanyObject->CustomerCompanyGet(
            CustomerID => $CustomerCompanyID,
        );

        # check general elements
        ELEMENT:
        for my $Element (
            qw(CustomerID CustomerCompanyName CustomerCompanyStreet CustomerCompanyZIP CustomerCompanyCity CustomerCompanyCountry CustomerCompanyURL CustomerCompanyComment ValidID)
            )
        {

            next ELEMENT unless exists $Test->{ReferenceImportData}->{LastVersion}->{$Element};

            is(
                $CustomerCompanyData{$Element},
                $Test->{ReferenceImportData}->{LastVersion}->{$Element},
                "ImportDataSave() $Element is identical",
            );
        }
    };
}
continue {
    $ImportTestCount++;
}

done_testing;
