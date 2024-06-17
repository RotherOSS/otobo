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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Queue::List');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $QueueName = "queue" . $Helper->GetRandomID();

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueName,
    Group           => 'admin',
    ValidID         => 2,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "exit code without options",
);

$Self->True(
    scalar $Result !~ m{\s$QueueName\s},
    "queue not found without options",
);

$Result = '';

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute('--all');
}

$Self->Is(
    $ExitCode,
    0,
    "exit code with --all",
);

$Self->True(
    scalar $Result =~ m{\s$QueueName\s},
    "queue found with --all",
);

$Result = '';

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute( '--all', '--verbose' );
}

$Self->Is(
    $ExitCode,
    0,
    "exit code with --all --verbose",
);

$Self->True(
    scalar $Result =~ m{\s$QueueID.*$QueueName.*invalid},
    "queue found with --all --verbose",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
