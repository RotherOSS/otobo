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

use CGI;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $HelperObject->GetRandomID();

# Create new entities
my $PriorityID = $Kernel::OM->Get('Kernel::System::Priority')->PriorityAdd(
    Name    => $RandomID,
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $PriorityID,
    undef,
    "PriorityAdd() for Priority $RandomID",
);

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $RandomID,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
$Self->IsNot(
    $QueueID,
    undef,
    "QueueAdd() for Queue $RandomID",
);

my $StateID = $Kernel::OM->Get('Kernel::System::State')->StateAdd(
    Name    => $RandomID,
    Comment => 'some comment',
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);
$Self->IsNot(
    $StateID,
    undef,
    "StateAdd() for State $RandomID",
);

my $TypeID = $Kernel::OM->Get('Kernel::System::Type')->TypeAdd(
    Name    => $RandomID,
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $TypeID,
    undef,
    "TypeAdd() for Type $RandomID",
);

my @Tests = (
    {
        Name        => 'Missing EntityType',
        QueryString => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID",
        EntityType  => undef,
        Success     => 0,
    },
    {
        Name          => 'Missing QueueID',
        QueryString   => "Action=AdminQueue;Subaction=Change",
        EntityType    => 'Queue',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong EntityType',
        QueryString   => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID",
        EntityType    => 'Type',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong Queue EntityType',
        QueryString   => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID" . '1',
        EntityType    => 'Queue',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong Priority EntityType',
        QueryString   => "Action=AdminPriority;Subaction=Change;PriorityID=$PriorityID" . '1',
        EntityType    => 'Priority',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong State EntityType',
        QueryString   => "Action=AdminState;Subaction=Change;ID=$StateID" . '1',
        EntityType    => 'State',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Wrong Type EntityType',
        QueryString   => "Action=AdminType;Subaction=Change;ID=$TypeID" . '1',
        EntityType    => 'Type',
        Success       => 1,
        ExpectedValue => undef,
    },
    {
        Name          => 'Correct Queue EntityType',
        QueryString   => "Action=AdminQueue;Subaction=Change;QueueID=$QueueID",
        EntityType    => 'Queue',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
    {
        Name          => 'Correct Priority EntityType',
        QueryString   => "Action=AdminPriority;Subaction=Change;PriorityID=$PriorityID",
        EntityType    => 'Priority',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
    {
        Name          => 'Correct State EntityType',
        QueryString   => "Action=AdminState;Subaction=Change;ID=$StateID",
        EntityType    => 'State',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
    {
        Name          => 'Correct Type EntityType',
        QueryString   => "Action=AdminType;Subaction=Change;ID=$TypeID",
        EntityType    => 'Type',
        Success       => 1,
        ExpectedValue => $RandomID,
    },
);

TEST:
for my $Test (@Tests) {

    # used in Kernel::System::Web::Request::new()
    local %ENV = (
        REQUEST_METHOD => 'GET',
        QUERY_STRING   => $Test->{QueryString} // '',
    );

    # force the ParamObject to use the new request params
    CGI::initialize_globals();
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Web::Request' => {
            WebRequest => CGI->new(),
        }
    );

    # implicitly call Kernel::System::Web::Request->new();
    my $EntityName = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Entity')->EntityLookupFromWebRequest(
        EntityType => $Test->{EntityType} // '',
    );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $EntityName,
            undef,
            "$Test->{Name} EntityLookupFromWebRequest() - EntityName (No Success)",
        );
        next TEST;
    }

    $Self->Is(
        $EntityName,
        $Test->{ExpectedValue},
        "$Test->{Name} EntityLookupFromWebRequest() - EntityName",
    );
}
continue {
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Web::Request', ],
    );
}

$Self->DoneTesting();
