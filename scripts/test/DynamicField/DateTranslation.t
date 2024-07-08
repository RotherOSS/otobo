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

# modules from CPAN
use HTTP::Request::Common qw(POST);
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::Web::Request ();

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

# define needed variable
my $RandomID = $Helper->GetRandomID();

# Ensure that default config values are used
$ConfigObject->Set(
    Key   => 'TimeInputFormat',
    Value => 'Option',
);

# create a ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
ok( $TicketID, "TicketCreate() successful for Ticket ID $TicketID" );

# create dynamic fields
my @DynamicFields = (
    {
        Name       => "DFDate$RandomID",
        Label      => 'a description',
        FieldOrder => 9991,
        FieldType  => 'Date',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue  => 0,
            YearsInFuture => 5,
            YearsInPast   => 5,
            YearsPeriod   => 0,
        },
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => "DFDateTime$RandomID",
        Label      => 'a description',
        FieldOrder => 9991,
        FieldType  => 'DateTime',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue  => 0,
            YearsInFuture => 5,
            YearsInPast   => 5,
            YearsPeriod   => 0,
        },
        ValidID => 1,
        UserID  => 1,
    },
);
my %DynamicFieldConfigsByType;
for my $DynamicField (@DynamicFields) {

    my $FieldID = $DynamicFieldObject->DynamicFieldAdd( %{$DynamicField} );

    # sanity check
    ok( $FieldID, "DynamicFieldAdd() successful for Field ID $FieldID" );

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    # add the DF config by type to the DynamicFieldConfigsByType hash
    $DynamicFieldConfigsByType{ $DynamicField->{FieldType} } = $DynamicFieldConfig;
}

my @Tests = (

    #
    # Tests for field type Date
    #
    {
        Config => {
            Type          => 'Date',
            OTOBOTimeZone => 'UTC',
            UserTimeZone  => 'Europe/Berlin',
            Common        => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{Date},
            },
            EditFieldRender => {

                # in OTOBO time zone
                Value => {
                    Value       => '2013-10-01 23:30:00',
                    ParamObject => $ParamObject,
                },

                # in OTOBO time zone
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                        'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                        'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                        'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                    'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                    'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                    'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 00:00:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {

            # for field type Date, time zones will be ignored, the date is taken as is
            EditFieldRender => {
                Value => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
                WebRequest => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
            },
            EditFieldValueGet => '2013-10-01 00:00:00',
            ValueSetGet       => '2013-10-01 00:00:00',
        },
    },
    {
        Config => {
            Type          => 'Date',
            OTOBOTimeZone => 'Europe/Berlin',
            UserTimeZone  => 'America/New_York',
            Common        => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{Date},
            },
            EditFieldRender => {

                # in OTOBO time zone
                Value => {
                    Value       => '2013-10-01 23:30:00',
                    ParamObject => $ParamObject,
                },

                # in OTOBO time zone
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                        'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                        'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                        'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                    },
                },
            },
            EditFieldValueGet => {
                CGIParam => {
                    'DynamicField_DFDate' . $RandomID . 'Used'  => 1,
                    'DynamicField_DFDate' . $RandomID . 'Day'   => '01',
                    'DynamicField_DFDate' . $RandomID . 'Month' => '10',
                    'DynamicField_DFDate' . $RandomID . 'Year'  => '2013',
                },
            },
            ValueSetGet => {
                Value    => '2013-10-01 00:00:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {

            # for field type Date, time zones will be ignored, the date is taken as is
            EditFieldRender => {
                Value => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
                WebRequest => {
                    Day   => '01',
                    Month => '10',
                    Year  => '2013',
                },
            },
            EditFieldValueGet => '2013-10-01 00:00:00',
            ValueSetGet       => '2013-10-01 00:00:00',
        },
    },

    #
    # Tests for field type DateTime
    #
    {
        Config => {
            Type          => 'DateTime',
            OTOBOTimeZone => 'UTC',
            UserTimeZone  => 'Europe/Berlin',
            Common        => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{DateTime},
            },
            EditFieldRender => {

                # in OTOBO time zone
                Value => {
                    Value       => '2013-09-30 23:01:00',
                    ParamObject => $ParamObject,
                },

                # in user time zone
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                        'DynamicField_DFDateTime' . $RandomID . 'Day'    => '30',
                        'DynamicField_DFDateTime' . $RandomID . 'Month'  => '09',
                        'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                        'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '23',
                        'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                    },
                },
            },
            EditFieldValueGet => {

                # in user time zone
                CGIParam => {
                    'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                    'DynamicField_DFDateTime' . $RandomID . 'Day'    => '30',
                    'DynamicField_DFDateTime' . $RandomID . 'Month'  => '09',
                    'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                    'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '23',
                    'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                },
            },
            ValueSetGet => {

                # in OTOBO time zone
                Value    => '2013-09-30 23:01:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {

                # in user time zone
                Value => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '01',
                    Minute => '01',
                },

                # in user time zone
                WebRequest => {
                    Day    => '30',
                    Month  => '09',
                    Year   => '2013',
                    Hour   => '23',
                    Minute => '01',
                },
            },

            # in OTOBO time zone
            EditFieldValueGet => '2013-09-30 21:01:00',

            # in OTOBO time zone
            ValueSetGet => '2013-09-30 23:01:00',
        },
    },
    {
        Config => {
            Type          => 'DateTime',
            OTOBOTimeZone => 'Europe/Berlin',
            UserTimeZone  => 'America/New_York',
            Common        => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{DateTime},
            },
            EditFieldRender => {

                # in OTOBO time zone
                Value => {
                    Value       => '2013-10-01 03:01:00',
                    ParamObject => $ParamObject,
                },

                # in user time zone
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                        'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                        'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                        'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '03',
                        'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                    },
                },
            },
            EditFieldValueGet => {

                # in user time zone
                CGIParam => {
                    'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                    'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                    'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                    'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '03',
                    'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                },
            },
            ValueSetGet => {

                # in OTOBO time zone
                Value    => '2013-10-01 03:01:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {

                # in user time zone
                Value => {
                    Day    => '30',
                    Month  => '09',
                    Year   => '2013',
                    Hour   => '21',
                    Minute => '01',
                },

                # in user time zone
                WebRequest => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '03',
                    Minute => '01',
                },
            },

            # in OTOBO time zone
            EditFieldValueGet => '2013-10-01 09:01:00',

            # in OTOBO time zone
            ValueSetGet => '2013-10-01 03:01:00',
        },
    },
    {
        Config => {
            Type          => 'DateTime',
            OTOBOTimeZone => 'Europe/Berlin',
            UserTimeZone  => 'Europe/Berlin',
            Common        => {
                DynamicFieldConfig => $DynamicFieldConfigsByType{DateTime},
            },
            EditFieldRender => {

                # in OTOBO time zone
                Value => {
                    Value       => '2013-10-01 03:01:00',
                    ParamObject => $ParamObject,
                },

                # in user time zone
                WebRequest => {
                    CGIParam => {
                        'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                        'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                        'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                        'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                        'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '03',
                        'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                    },
                },
            },
            EditFieldValueGet => {

                # in user time zone
                CGIParam => {
                    'DynamicField_DFDateTime' . $RandomID . 'Used'   => 1,
                    'DynamicField_DFDateTime' . $RandomID . 'Day'    => '01',
                    'DynamicField_DFDateTime' . $RandomID . 'Month'  => '10',
                    'DynamicField_DFDateTime' . $RandomID . 'Year'   => '2013',
                    'DynamicField_DFDateTime' . $RandomID . 'Hour'   => '03',
                    'DynamicField_DFDateTime' . $RandomID . 'Minute' => '01',
                },
            },
            ValueSetGet => {

                # in OTOBO time zone
                Value    => '2013-10-01 03:01:00',
                ObjectID => $TicketID,
                UserID   => 1,
            },
        },
        ExpectedResults => {
            EditFieldRender => {

                # in user time zone
                Value => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '03',
                    Minute => '01',
                },

                # in user time zone
                WebRequest => {
                    Day    => '01',
                    Month  => '10',
                    Year   => '2013',
                    Hour   => '03',
                    Minute => '01',
                },
            },

            # in OTOBO time zone
            EditFieldValueGet => '2013-10-01 03:01:00',

            # in OTOBO time zone
            ValueSetGet => '2013-10-01 03:01:00',
        },
    },
);

# execute tests
for my $Test (@Tests) {

    my $UserTimeZone  = $Test->{Config}->{UserTimeZone}  || 'no user time zone';
    my $OTOBOTimeZone = $Test->{Config}->{OTOBOTimeZone} || 'no OTOBO time zone';
    my $SubtestDesc   = "Field type $Test->{Config}->{Type}, User time zone: $UserTimeZone, OTOBO time zone $OTOBOTimeZone";

    subtest $SubtestDesc => sub {
        $ConfigObject->Set(
            Key   => 'OTOBOTimeZone',
            Value => $Test->{Config}->{OTOBOTimeZone},
        );

        # get Layout object with correct user time zone
        $Kernel::OM->ObjectsDiscard(
            Objects => [ 'Kernel::Output::HTML::Layout', 'Kernel::System::Web::Request', ],
        );
        $Kernel::OM->ObjectParamAdd(
            'Kernel::Output::HTML::Layout' => {
                Lang         => 'en',
                UserTimeZone => $Test->{Config}->{UserTimeZone},
            },
        );
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # for EditFieldRender test both cases, a values passed and value in a web request as they might
        # be different
        for my $Type ( sort keys $Test->{Config}->{EditFieldRender}->%* ) {

            # set the appropriate configuration
            my %Config;
            if ( $Type eq 'Value' ) {
                %Config = (
                    %{ $Test->{Config}->{Common} },
                    %{ $Test->{Config}->{EditFieldRender}->{$Type} },
                );
            }
            else {

                # create a new HTTP::Request object to simulate a web request
                my $HTTPRequest      = POST( '/', [ $Test->{Config}->{EditFieldRender}->{$Type}->{CGIParam}->%* ] );
                my $LocalParamObject = Kernel::System::Web::Request->new(
                    HTTPRequest => $HTTPRequest,
                );

                %Config = (
                    %{ $Test->{Config}->{Common} },
                    %{ $Test->{Config}->{EditFieldRender}->{$Type} },
                    ParamObject => $LocalParamObject,
                );
            }

            $Config{LayoutObject} = $LayoutObject;

            # get EditValueRender HTML
            my $FieldHTML = $BackendObject->EditFieldRender(%Config);

            # extract the date from rendered HTML
            my %HTMLResult;
            ( $HTMLResult{Day} )   = $FieldHTML->{Field} =~ m{title="Day"   [^s]+ selected>([^<]+)</option>}msx;
            ( $HTMLResult{Month} ) = $FieldHTML->{Field} =~ m{title="Month" [^s]+ selected>([^<]+)</option>}msx;
            ( $HTMLResult{Year} )  = $FieldHTML->{Field} =~ m{title="Year"  [^s]+ selected>([^<]+)</option>}msx;

            # also get Hour and Minute for DateTime fields
            if ( $Test->{Config}->{Type} eq 'DateTime' ) {
                ( $HTMLResult{Hour} )   = $FieldHTML->{Field} =~ m{title="Hours" [^s]+ selected>([^<]+)</option>}msx;
                ( $HTMLResult{Minute} ) = $FieldHTML->{Field} =~ m{title="Minutes" [^s]+ selected>([^<]+)</option>}msx;
            }

            is(
                \%HTMLResult,
                $Test->{ExpectedResults}->{EditFieldRender}->{$Type},
                "EditFieldRender for type $Type"
            );
        }

        # create a new HTTP::Request object to simulate a web request
        my $HTTPRequest      = POST( '/', [ $Test->{Config}->{EditFieldValueGet}->{CGIParam}->%* ] );
        my $LocalParamObject = Kernel::System::Web::Request->new(
            HTTPRequest => $HTTPRequest,
        );

        # get the value from the web request
        my $Value = $BackendObject->EditFieldValueGet(
            %{ $Test->{Config}->{Common} },
            %{ $Test->{Config}->{EditFieldValueGet} },
            ParamObject  => $LocalParamObject,
            LayoutObject => $LayoutObject,
        );

        is(
            $Value,
            $Test->{ExpectedResults}->{EditFieldValueGet},
            "EditFieldValueGet"
        );

        # set a value in the DB and get it
        my $Success = $BackendObject->ValueSet(
            %{ $Test->{Config}->{Common} },
            %{ $Test->{Config}->{ValueSetGet} },
        );
        $Value = $BackendObject->ValueGet(
            %{ $Test->{Config}->{Common} },
            %{ $Test->{Config}->{ValueSetGet} }
        );

        is(
            $Value,
            $Test->{ExpectedResults}->{ValueSetGet},
            "ValueGet",
        );
    };
}

done_testing;
