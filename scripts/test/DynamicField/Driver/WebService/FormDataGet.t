# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use URI::Escape;

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Disable email address checks
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Use DoNotSendEmail email backend.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# Build a test Dynamic field Config.
my $DynamicFieldConfig = {
    ID         => 123,
    FieldType  => 'Text',
    ObjectType => 'WebService',
};

my @Tests = (
    {
        Name   => 'Simple TicketID',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;TicketID=123",
        Success       => 1,
        ExectedResult => {
            TicketID => '123',
        },
    },
    {
        Name   => 'Multiple Values',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;Test=a;Test=b;Test=c;TicketID=123",
        Success       => 1,
        ExectedResult => {
            TicketID => '123',
            Test     => [ 'a', 'b', 'c' ],
        },
    },
    {
        Name   => 'Multiple Values with dynamic fields',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request =>
            'Action=someaction;Subaction=somesubaction;Test=a;Test=b;Test=c;TicketID=123;DynamicField_Test1=1;DynamicField_Test1=2;DynamicField_Test2=x;DynamicField_Test2=y;DynamicField_Test2=z;DynamicField_Test3=%C3%B3',
        Success       => 1,
        ExectedResult => {
            TicketID     => '123',
            Test         => [ 'a', 'b', 'c' ],
            DynamicField => {
                Test1 => [ 1,   2 ],
                Test2 => [ 'x', 'y', 'z' ],
                Test3 => 'ó',
            }
        },
    },

);

my $DynamicFieldDriverObject = $Kernel::OM->Get('Kernel::System::DynamicField::Driver::WebService');

TEST:
for my $Test (@Tests) {

    local %ENV = (
        REQUEST_METHOD => 'GET',
        QUERY_STRING   => $Test->{Request} // '',
    );

    CGI->initialize_globals();
    my $Request = Kernel::System::Web::Request->new();

    my $FormData = $DynamicFieldDriverObject->_FormDataGet();

    $Self->IsDeeply(
        $FormData,
        $Test->{ExectedResult},
        "$Test->{Name} FormDataGet()",
    );
}
continue {
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Web::Request', ],
    );
}


$Self->DoneTesting();


