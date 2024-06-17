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

$Self->True(
    $UserLogin,
    "CustomerUserAdd()",
);

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

    local %ENV = (
        REQUEST_METHOD => 'GET',
        QUERY_STRING   => $Test->{Request} // '',
    );

    CGI->initialize_globals();
    my $Request = Kernel::System::Web::Request->new();

    my %ObjectData = $ObjectHandlerObject->ObjectDataGet( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            \%ObjectData,
            {},
            "$Test->{Name} - ObjectDataGet() unsuccessful",
        );
        next TEST;
    }

    $Self->IsDeeply(
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

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
