# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

$Self->True(
    $Kernel::OM->Get('scripts::test::ObjectManager::Dummy'),
    "Can load custom object as a singleton",
);

$Self->True(
    $Kernel::OM->Create('scripts::test::ObjectManager::Dummy'),
    "Can load custom object as an instance",
);

my $Object = eval { $Kernel::OM->Get('scripts::test::ObjectManager::Disabled') };
$Self->True(
    $@,
    "Fetching an object that cannot be loaded via OM causes an exception",
);
$Self->False(
    $Object,
    "Cannot construct an object that cannot be loaded via OM",
);

$Object = $Kernel::OM->Get('scripts::test::ObjectManager::Singleton');
$Self->True(
    $Object,
    "Created singleton object."
);

my $Object2 = $Kernel::OM->Get('scripts::test::ObjectManager::Singleton');
$Self->True(
    $Object,
    "Created singleton object."
);

$Self->Is(
    $Object,
    $Object2,
    "Get() returns only one object instance"
);

$Object = eval { $Kernel::OM->Get('scripts::test::ObjectManager::NonSingleton') };
$Self->True(
    $@,
    "Fetching non-singletons via Get() causes an exception",
);
$Self->False(
    $Object,
    "Non-singletons cannot be fetched via Get()",
);

$Object = $Kernel::OM->Create(
    'scripts::test::ObjectManager::NonSingleton',
    ObjectParams => {
        Param1 => 'Value1'
    },
);
$Self->True(
    $Object,
    "Created non-singleton object."
);
$Self->Is(
    $Object->{Param1},
    'Value1',
    "Create() passed in constructor parameters",
);

$Object2 = $Kernel::OM->Create('scripts::test::ObjectManager::NonSingleton');
$Self->True(
    $Object,
    "Created non-singleton object."
);
$Self->False(
    $Object2->{Param1},
    "Create() did not pass in constructor parameters",
);

$Self->IsNot(
    $Object,
    $Object2,
    "Create() returns new instances"
);

# Test exceptions in Create()
$Object = eval { $Kernel::OM->Create('scripts::test::ObjectManager::WrongPackageName') };
$Self->True(
    $@,
    "Creating a nonexisting object via OM causes an exception",
);
$Self->False(
    $Object,
    "Cannot create a nonexisting object",
);

$Object = eval {
    $Kernel::OM->Create(
        'scripts::test::ObjectManager::WrongPackageName',
        Silent => 1,
    );
};
$Self->False(
    $@,
    "Creating a nonexisting object via OM causes no exception with Silent => 1",
);
$Self->False(
    $Object,
    "Cannot create a nonexisting object with Silent => 1",
);

$Object = eval { $Kernel::OM->Create('scripts::test::ObjectManager::ConstructorFailure') };
$Self->True(
    $@,
    "Creating an object with failing constructor via OM causes an exception",
);
$Self->False(
    $Object,
    "Cannot create an object with failing constructor",
);

$Object = eval {
    $Kernel::OM->Create(
        'scripts::test::ObjectManager::ConstructorFailure',
        Silent => 1,
    );
};
$Self->False(
    $@,
    "Creating an object with failing constructor via OM causes no exception with Silent => 1",
);
$Self->False(
    $Object,
    "Cannot create an object with failing constructor",
);

$Object = eval {
    $Kernel::OM->Create(
        'scripts::test::ObjectManager::AllowConstructorFailure',
    );
};
$Self->False(
    $@,
    "Creating an object with failing constructor via OM causes no exception with AllowConstructorFailure => 1",
);
$Self->False(
    $Object,
    "Cannot create an object with failing constructor",
);

#
# Live example of a Singleton
#

$Object = $Kernel::OM->Get('Kernel::System::Encode');
$Self->True(
    $Object,
    "Created singleton EncodeObject."
);

$Object = eval { $Kernel::OM->Create('Kernel::System::Encode') };
$Self->True(
    $@,
    "Fetching singleton EncodeObject via Create() causes an exception",
);
$Self->False(
    $Object,
    "Singleton EncodeObject cannot be fetched via Create()",
);

$Self->DoneTesting();
