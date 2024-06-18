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
use HTTP::Request::Common qw(GET);
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# Get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Disable email address checks
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Use DoNotSendEmail email backend
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# Create a customer user
my $UserLogin = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Huber',
    UserLastname   => 'Manfred',
    UserCustomerID => 'A124',
    UserLogin      => 'mhuber',
    UserPassword   => 'some-pass',
    UserEmail      => 'email@example.com',
    ValidID        => 1,
    UserID         => 1,
);

ok( $UserLogin, "CustomerUserAdd()" );

my %UserData = $CustomerUserObject->CustomerUserDataGet(
    User => $UserLogin,
);

my $ObjectID = $Kernel::OM->Get('Kernel::System::DynamicField')->ObjectMappingCreate(
    ObjectName => $UserLogin,
    ObjectType => 'CustomerUser',
);
my $WrongObjectID = $Kernel::OM->Get('Kernel::System::DynamicField')->ObjectMappingCreate(
    ObjectName => 'OTOBOwrongid',
    ObjectType => 'CustomerUser',
);

# Build a test Dynamic field Config.
my $DynamicFieldConfig = {
    ID         => 123,
    FieldType  => 'Text',
    ObjectType => 'CustomerUser',
};

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Request => "Action=someaction;Subaction=somesubaction;ID=$UserLogin",
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
        },
        Request => "Action=someaction;Subaction=somesubaction;ID=$UserLogin",
        Success => 0,
    },
    {
        Name   => 'Missing DynamicFieldConfig',
        Config => {
            UserID => 1,
        },
        Request => "Action=someaction;Subaction=somesubaction;ID=$UserLogin",
        Success => 0,
    },
    {
        Name   => 'Missing ID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request => "Action=someaction;Subaction=somesubaction;",
        Success => 0,
    },
    {
        Name   => 'Wrong ID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;ID=OTOBOwrongid",
        Success       => 1,
        ExectedResult => {
            ObjectID => $WrongObjectID,
            Data     => {},
        },
    },
    {
        Name   => 'Correct ID',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;ID=$UserLogin",
        Success       => 1,
        ExectedResult => {
            ObjectID => $ObjectID,
            Data     => \%UserData,
        },
    },

);

my $ObjectHandlerObject = $Kernel::OM->Get('Kernel::System::DynamicField::ObjectType::CustomerUser');

TEST:
for my $Test (@Tests) {

    # force the ParamObject to use the new request params
    my $QueryString = $Test->{Request} // '';
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Web::Request' => {
            HTTPRequest => GET( 'http://example.com/example?' . $QueryString ),
        }
    );

    # implicitly call Kernel::System::Web::Request->new();
    my %ObjectData = $ObjectHandlerObject->ObjectDataGet( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        is(
            \%ObjectData,
            {},
            "$Test->{Name} - ObjectDataGet() unsuccessful",
        );

        next TEST;
    }

    is(
        \%ObjectData,
        $Test->{ExectedResult},
        "$Test->{Name} ObjectDataGet()",
    );
}
continue {
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Web::Request', ],
    );
}

done_testing;
