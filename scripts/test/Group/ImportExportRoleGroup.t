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

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

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

# create test user
my ( undef, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $ValidID = $ValidObject->ValidLookup(
    Valid => 'valid',
);

# create test groups and roles
my %GroupName2ID;
my %RoleName2ID;
for my $Count ( 1 .. 5 ) {
    my %GroupData = (
        Name    => 'TestGroup' . $Count . $RandomID,
        Comment => 'TestComment' . $Count . $RandomID,
        ValidID => $ValidID,
    );
    my $GroupAddSuccess = $GroupObject->GroupAdd(
        %GroupData,
        UserID => $TestUserID,
    );
    ok( $GroupAddSuccess, 'group created successfully' );
    my $GroupID = $GroupObject->GroupLookup(
        Group => 'TestGroup' . $Count . $RandomID,
    );
    $GroupName2ID{ 'TestGroup' . $Count . $RandomID } = $GroupID;

    my %RoleData = (
        Name    => 'TestRole' . $Count . $RandomID,
        Comment => 'TestComment' . $Count . $RandomID,
        ValidID => $ValidID,
    );
    my $RoleAddSuccess = $GroupObject->RoleAdd(
        %RoleData,
        UserID => $TestUserID,
    );
    ok( $RoleAddSuccess, 'role created successfully' );
    my $RoleID = $GroupObject->RoleLookup(
        Role => 'TestRole' . $Count . $RandomID,
    );
    $RoleName2ID{ 'TestRole' . $Count . $RandomID } = $RoleID;
}

# set role group relation
my $RelationAddSuccess = $GroupObject->PermissionGroupRoleAdd(
    GID        => $GroupName2ID{ 'TestGroup1' . $RandomID },
    RID        => $RoleName2ID{ 'TestRole1' . $RandomID },
    Permission => {
        'ro'        => 0,
        'move_into' => 0,
        'create'    => 0,
        'note'      => 0,
        'owner'     => 0,
        'priority'  => 0,
        'rw'        => 1,
    },
    UserID => $TestUserID,
);
ok( $RelationAddSuccess, 'relation added successfully' );

# testing export
my $ExportData = $GroupObject->ExportRoleGroups();
is(
    $ExportData,
    hash {

        # rw gives all other permissions as well
        field 'TestRole1' . $RandomID => {
            'ro'        => [ 'TestGroup1' . $RandomID ],
            'move_into' => [ 'TestGroup1' . $RandomID ],
            'create'    => [ 'TestGroup1' . $RandomID ],
            'note'      => [ 'TestGroup1' . $RandomID ],
            'owner'     => [ 'TestGroup1' . $RandomID ],
            'priority'  => [ 'TestGroup1' . $RandomID ],
            'rw'        => [ 'TestGroup1' . $RandomID ],
        };

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    'TestRole2' . $RandomID => {
        'ro'        => [ 'TestGroup1' . $RandomID ],
        'move_into' => [],
        'create'    => [],
        'note'      => [],
        'owner'     => [],
        'priority'  => [],
        'rw'        => [],
    },
    'TestRole3' . $RandomID => {
        'ro'        => [ 'TestGroup1' . $RandomID ],
        'move_into' => [ 'TestGroup2' . $RandomID, 'TestGroup3' . $RandomID ],
        'create'    => [ 'TestGroup4' . $RandomID ],
        'note'      => [],
        'owner'     => [ 'TestGroup5' . $RandomID ],
        'priority'  => [],
        'rw'        => [],
    },
    'TestRole4' . $RandomID => {
        'ro'        => [],
        'move_into' => [ 'TestGroup5' . $RandomID ],
        'create'    => [ 'TestGroup4' . $RandomID, 'TestGroup3' . $RandomID, 'TestGroup2' . $RandomID ],
        'note'      => [],
        'owner'     => [],
        'priority'  => [],
        'rw'        => [],
    },
    'TestRole5' . $RandomID => {
        'ro'        => [],
        'move_into' => [],
        'create'    => [],
        'note'      => [],
        'owner'     => [],
        'priority'  => [],
        'rw'        => [ 'TestGroup1' . $RandomID, 'TestGroup2' . $RandomID, 'TestGroup3' . $RandomID, 'TestGroup4' . $RandomID, 'TestGroup5' . $RandomID ],
    },
);

my $ImportSuccess = $GroupObject->ImportRoleGroups(
    RoleGroups => \%ImportData,
    UserID     => $TestUserID,
);
ok( $ImportSuccess, 'imported relations successfully' );

my %Relations;
for my $RoleName ( keys %RoleName2ID ) {
    for my $Type (qw(ro move_into create note owner priority)) {
        my %Data = $GroupObject->PermissionRoleGroupGet(
            RoleID => $RoleName2ID{$RoleName},
            Type   => $Type,
        );
        $Relations{$RoleName}{$Type} = [ values %Data ];
    }
}

is(
    \%Relations,
    hash {
        field 'TestRole1' . $RandomID => {
            'ro' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
            'move_into' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
            'create' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
            'note' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
            'owner' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
            'priority' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
        };
        field 'TestRole2' . $RandomID => {
            'ro' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
            'move_into' => bag {
                end();
            },
            'create' => bag {
                end();
            },
            'note' => bag {
                end();
            },
            'owner' => bag {
                end();
            },
            'priority' => bag {
                end();
            },
        };
        field 'TestRole3' . $RandomID => {
            'ro' => bag {
                item 'TestGroup1' . $RandomID;

                end();
            },
            'move_into' => bag {
                item 'TestGroup2' . $RandomID;
                item 'TestGroup3' . $RandomID;

                end();
            },
            'create' => bag {
                item 'TestGroup4' . $RandomID;

                end();
            },
            'note' => bag {
                end();
            },
            'owner' => bag {
                item 'TestGroup5' . $RandomID;
            },
            'priority' => bag {
                end();
            },
        };
        field 'TestRole4' . $RandomID => {
            'ro' => bag {
                end();
            },
            'move_into' => bag {
                item 'TestGroup5' . $RandomID;

                end();
            },
            'create' => bag {
                item 'TestGroup4' . $RandomID;
                item 'TestGroup3' . $RandomID;
                item 'TestGroup2' . $RandomID;

                end();
            },
            'note' => bag {
                end();
            },
            'owner' => bag {
                end();
            },
            'priority' => bag {
                end();
            },
        };
        field 'TestRole5' . $RandomID => {
            'ro' => bag {
                item 'TestGroup1' . $RandomID;
                item 'TestGroup2' . $RandomID;
                item 'TestGroup3' . $RandomID;
                item 'TestGroup4' . $RandomID;
                item 'TestGroup5' . $RandomID;

                end();
            },
            'move_into' => bag {
                item 'TestGroup1' . $RandomID;
                item 'TestGroup2' . $RandomID;
                item 'TestGroup3' . $RandomID;
                item 'TestGroup4' . $RandomID;
                item 'TestGroup5' . $RandomID;

                end();
            },
            'create' => bag {
                item 'TestGroup1' . $RandomID;
                item 'TestGroup2' . $RandomID;
                item 'TestGroup3' . $RandomID;
                item 'TestGroup4' . $RandomID;
                item 'TestGroup5' . $RandomID;

                end();
            },
            'note' => bag {
                item 'TestGroup1' . $RandomID;
                item 'TestGroup2' . $RandomID;
                item 'TestGroup3' . $RandomID;
                item 'TestGroup4' . $RandomID;
                item 'TestGroup5' . $RandomID;

                end();
            },
            'owner' => bag {
                item 'TestGroup1' . $RandomID;
                item 'TestGroup2' . $RandomID;
                item 'TestGroup3' . $RandomID;
                item 'TestGroup4' . $RandomID;
                item 'TestGroup5' . $RandomID;

                end();
            },
            'priority' => bag {
                item 'TestGroup1' . $RandomID;
                item 'TestGroup2' . $RandomID;
                item 'TestGroup3' . $RandomID;
                item 'TestGroup4' . $RandomID;
                item 'TestGroup5' . $RandomID;

                end();
            },
        };

        etc();
    },
    'imported data looks as expected'
);

done_testing;
