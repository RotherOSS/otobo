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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::StandardTemplate::QueueLink');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TemplateName = 'template' . $Helper->GetRandomID();

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide only one option
$ExitCode = $CommandObject->Execute( '--template-name', $TemplateName );
$Self->Is(
    $ExitCode,
    1,
    "Only one options",
);

# provide invalid template name
$ExitCode = $CommandObject->Execute( '--template-name', $TemplateName, '--queue-name', 'Junk' );
$Self->Is(
    $ExitCode,
    1,
    "Invalid template name",
);

# provide invalid queue name
my $QueueName = 'queue' . $Helper->GetRandomID();
$ExitCode = $CommandObject->Execute( '--template-name', 'test answer', '--queue-name', $QueueName );
$Self->Is(
    $ExitCode,
    1,
    "Invalid queue name",
);

my $StandardTemplateID = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateAdd(
    Name         => $TemplateName,
    Template     => 'Thank you for your email.',
    ContentType  => 'text/plain; charset=utf-8',
    TemplateType => 'Answer',
    ValidID      => 1,
    UserID       => 1,
);

$Self->True(
    $StandardTemplateID,
    "Test standard template is created - $StandardTemplateID",
);

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

$Self->True(
    $QueueID,
    "Test queue is created - $QueueID",
);

# provide valid options
$ExitCode = $CommandObject->Execute( '--template-name', $StandardTemplateID, '--queue-name', $QueueName );
$Self->Is(
    $ExitCode,
    0,
    "Valid options",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
