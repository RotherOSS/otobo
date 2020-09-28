# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::UnitTest::Run');

my @Tests = (
    {
        Name   => "UnitTest 'User.t' (blacklisted)",
        Test   => 'User',
        Config => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => ['User.t'],
        },
        TestExecuted => 0,
    },
    {
        Name   => "UnitTest 'User.t' (whitelisted)",
        Test   => 'User',
        Config => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => [],
        },
        TestExecuted => 1,
    },
);

for my $Test (@Tests) {

    $Helper->ConfigSettingChange(
        %{ $Test->{Config} },
    );

    my $Result;
    my $ExitCode;

    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;

        $ExitCode = $CommandObject->Execute( '--test', $Test->{Test} );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    chomp $Result;

    # Check for executed tests message.
    my $Success = $Result =~ m{ No \s+ tests \s+ executed\. }xms;

    if ( $Test->{TestExecuted} ) {

        $Self->False(
            $Success,
            $Test->{Name} . ' - executed successfully.',
        );
    }
    else {

        $Self->True(
            $Success,
            $Test->{Name} . ' - not executed.',
        );
    }
}


