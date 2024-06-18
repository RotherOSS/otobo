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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get signature object
my $SignatureObject = $Kernel::OM->Get('Kernel::System::Signature');

# add signature
my $SignatureName = $Helper->GetRandomID();
my $SignatureText = "Your OTOBO-Team

<OTOBO_CURRENT_UserFirstname> <OTOBO_CURRENT_UserLastname>

--
Super Support Company Inc. - Waterford Business Park
5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA
Email: hot\@florida.com - Web: http://hot.florida.com/
--";

my $SignatureID = $SignatureObject->SignatureAdd(
    Name        => $SignatureName,
    Text        => $SignatureText,
    ContentType => 'text/plain; charset=iso-8859-1',
    Comment     => 'some comment',
    ValidID     => 1,
    UserID      => 1,
);

$Self->True(
    $SignatureID,
    'SignatureAdd()',
);

my %Signature = $SignatureObject->SignatureGet( ID => $SignatureID );

$Self->Is(
    $Signature{Name} || '',
    $SignatureName,
    'SignatureGet() - Name',
);
$Self->True(
    $Signature{Text} eq $SignatureText,
    'SignatureGet() - Signature text',
);
$Self->Is(
    $Signature{ContentType} || '',
    'text/plain; charset=iso-8859-1',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{Comment} || '',
    'some comment',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{ValidID} || '',
    1,
    'SignatureGet() - ValidID',
);

my %SignatureList = $SignatureObject->SignatureList( Valid => 0 );
$Self->True(
    exists $SignatureList{$SignatureID} && $SignatureList{$SignatureID} eq $SignatureName,
    "SignatureList() contains the signature $SignatureName",
);

my $SignatureNameUpdate = $SignatureName . ' - Update';
my $SignatureTextUpdate = $SignatureText . ' - Update';
my $SignatureUpdate     = $SignatureObject->SignatureUpdate(
    ID          => $SignatureID,
    Name        => $SignatureNameUpdate,
    Text        => $SignatureTextUpdate,
    ContentType => 'text/plain; charset=utf-8',
    Comment     => 'some comment 1',
    ValidID     => 2,
    UserID      => 1,
);

$Self->True(
    $SignatureUpdate,
    'SignatureUpdate()',
);

%Signature = $SignatureObject->SignatureGet( ID => $SignatureID );

$Self->Is(
    $Signature{Name} || '',
    $SignatureNameUpdate,
    'SignatureGet() - Name',
);
$Self->True(
    $Signature{Text} eq $SignatureTextUpdate,
    'SignatureGet() - Signature',
);
$Self->Is(
    $Signature{ContentType} || '',
    'text/plain; charset=utf-8',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{Comment} || '',
    'some comment 1',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{ValidID} || '',
    2,
    'SignatureGet() - ValidID',
);

%SignatureList = $SignatureObject->SignatureList( Valid => 1 );
$Self->False(
    exists $SignatureList{$SignatureID},
    "SignatureList() does not contain invalid signature $SignatureNameUpdate",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
