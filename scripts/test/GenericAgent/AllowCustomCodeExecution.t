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

# This test should verify that a module gets the configured parameters
#   passed directly in the param hash

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create a Ticket to test JobRun and JobRunTicket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Testticket for Untittest of the Generic Agent',
    Queue        => 'Raw',
    Lock         => 'unlock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerNo   => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "Ticket is created - $TicketID",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->True(
    $Ticket{TicketNumber},
    "Found ticket number - $Ticket{TicketNumber}",
);

my $Home = $ConfigObject->Get('Home');

my @Tests = (

);

my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

for my $AllowCustomScriptExecution ( 0, 1 ) {

    for my $AllowCustomModuleExecution ( 0, 1 ) {

        $ConfigObject->Set(
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => $AllowCustomScriptExecution,
        );
        $ConfigObject->Set(
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => $AllowCustomModuleExecution,
        );

        MODE:
        for my $Mode (qw(Module CMD)) {

            my ( $FileHandle, $FileName ) = $FileTempObject->TempFile();

            $Self->True(
                -e $FileName ? 1 : 0,
                "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode: $Mode TmpFile $FileName created"
            );

            my $Name = 'job' . $Helper->GetRandomID();

            my %NewJob = (
                Name => $Name,
                Data => {
                    TicketNumber => $Ticket{TicketNumber},
                },
            );
            if ( $Mode eq 'Module' ) {
                $NewJob{Data}->{NewModule}      = 'scripts::test::sample::GenericAgent::CustomCode::DeleteTmp';
                $NewJob{Data}->{NewParamKey1}   = 'FileName';
                $NewJob{Data}->{NewParamValue1} = $FileName;
            }
            else {
                $NewJob{Data}->{NewCMD} = "$Home/scripts/test/sample/GenericAgent/CustomCode/DeleteTmp.pl $FileName";
            }

            my $JobAdd = $GenericAgentObject->JobAdd(
                %NewJob,
                UserID => 1,
            );
            $Self->True(
                $JobAdd || '',
                "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode $Mode JobAdd() - $Name",
            );

            $Self->True(
                $GenericAgentObject->JobRun(
                    Job    => $Name,
                    UserID => 1,
                ),
                "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode $Mode JobRun() - $Name",
            );

            my $JobDelete = $GenericAgentObject->JobDelete(
                Name   => $Name,
                UserID => 1,
            );
            $Self->True(
                $JobDelete || '',
                "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode $Mode JobDelete() - $Name",
            );

            if ( $Mode eq 'Module' ) {
                if ($AllowCustomModuleExecution) {
                    $Self->False(
                        -e $FileName ? 1 : 0,
                        "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode $Mode TmpFile $FileName exists with false"
                    );
                    next MODE;
                }
                $Self->True(
                    -e $FileName ? 1 : 0,
                    "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode $Mode TmpFile $FileName exists (no custom module executed)"
                );
            }
            else {
                if ($AllowCustomScriptExecution) {
                    $Self->False(
                        -e $FileName ? 1 : 0,
                        "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode $Mode TmpFile $FileName exists with false"
                    );
                    next MODE;
                }
                $Self->True(
                    -e $FileName ? 1 : 0,
                    "GenericAgent ScriptExecution: $AllowCustomScriptExecution ModuleExecution: $AllowCustomModuleExecution Mode $Mode TmpFile $FileName exists (no custom script executed)"
                );
            }
        }
    }
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
