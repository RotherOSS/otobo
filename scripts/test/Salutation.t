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

our $Self;

# get needed objects
my $SalutationObject = $Kernel::OM->Get('Kernel::System::Salutation');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# add salutation
my $SalutationName = 'salutation' . $Helper->GetRandomID();
my $Salutation     = "Dear <OTOBO_CUSTOMER_REALNAME>,

Thank you for your request. Your email address in our database
is \"<OTOBO_CUSTOMER_DATA_UserEmail>\".
";

my $SalutationID = $SalutationObject->SalutationAdd(
    Name        => $SalutationName,
    Text        => $Salutation,
    ContentType => 'text/plain; charset=iso-8859-1',
    Comment     => 'some comment',
    ValidID     => 1,
    UserID      => 1,
);

$Self->True(
    $SalutationID,
    'SalutationAdd()',
);

my %Salutation = $SalutationObject->SalutationGet( ID => $SalutationID );

$Self->Is(
    $Salutation{Name} || '',
    $SalutationName,
    'SalutationGet() - Name',
);
$Self->True(
    $Salutation{Text} eq $Salutation,
    'SalutationGet() - Salutation',
);
$Self->Is(
    $Salutation{ContentType} || '',
    'text/plain; charset=iso-8859-1',
    'SalutationGet() - Comment',
);
$Self->Is(
    $Salutation{Comment} || '',
    'some comment',
    'SalutationGet() - Comment',
);
$Self->Is(
    $Salutation{ValidID} || '',
    1,
    'SalutationGet() - ValidID',
);

my %SalutationList = $SalutationObject->SalutationList( Valid => 0 );
$Self->True(
    exists $SalutationList{$SalutationID} && $SalutationList{$SalutationID} eq $SalutationName,
    'SalutationList() contains the salutation ' . $SalutationName . ' with ID ' . $SalutationID,
);

%SalutationList = $SalutationObject->SalutationList( Valid => 1 );
$Self->True(
    exists $SalutationList{$SalutationID} && $SalutationList{$SalutationID} eq $SalutationName,
    'SalutationList() contains the salutation ' . $SalutationName . ' with ID ' . $SalutationID,
);

my $SalutationNameUpdate = $SalutationName . '1';
my $SalutationUpdate     = $SalutationObject->SalutationUpdate(
    ID          => $SalutationID,
    Name        => $SalutationNameUpdate,
    Text        => $Salutation . '1',
    ContentType => 'text/plain; charset=utf-8',
    Comment     => 'some comment 1',
    ValidID     => 2,
    UserID      => 1,
);

$Self->True(
    $SalutationUpdate,
    'SalutationUpdate()',
);

%Salutation = $SalutationObject->SalutationGet( ID => $SalutationID );

$Self->Is(
    $Salutation{Name} || '',
    $SalutationNameUpdate,
    'SalutationGet() - Name',
);
$Self->True(
    $Salutation{Text} eq $Salutation . '1',
    'SalutationGet() - Salutation',
);
$Self->Is(
    $Salutation{ContentType} || '',
    'text/plain; charset=utf-8',
    'SalutationGet() - Comment',
);
$Self->Is(
    $Salutation{Comment} || '',
    'some comment 1',
    'SalutationGet() - Comment',
);
$Self->Is(
    $Salutation{ValidID} || '',
    2,
    'SalutationGet() - ValidID',
);

%SalutationList = $SalutationObject->SalutationList( Valid => 0 );
$Self->True(
    exists $SalutationList{$SalutationID} && $SalutationList{$SalutationID} eq $SalutationNameUpdate,
    'SalutationList() contains the salutation ' . $SalutationNameUpdate . ' with ID ' . $SalutationID,
);

%SalutationList = $SalutationObject->SalutationList( Valid => 1 );
$Self->False(
    exists $SalutationList{$SalutationID},
    'SalutationList() does not contain the salutation ' . $SalutationNameUpdate . ' with ID ' . $SalutationID,
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
