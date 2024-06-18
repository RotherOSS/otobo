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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# disable check email address
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0
);

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Get default from database.
my $DoSuccess = $DBObject->Prepare(
    SQL => "
        SELECT COUNT(sd.id)
        FROM sysconfig_default sd
        WHERE
            sd.xml_filename IN (
                'Calendar.xml' ,'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                'ProcessManagement.xml', 'Ticket.xml'
            )
            AND is_invisible != '1'
        ",
);

skip_all('cannot get defaults') unless $DoSuccess;

my $OTOBOSettings;
while ( my @Data = $DBObject->FetchrowArray() ) {
    $OTOBOSettings = $Data[0];
}

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my @Tests = (
    {
        Name   => 'Correct Search',
        Params => {
            Search => 'LogModule::SysLog',
        },
        ExpectedResult => [
            'LogModule::SysLog::Charset',
            'LogModule::SysLog::Facility',
        ],
        Success => 1,
    },
    {
        Name   => 'Multiple Term Search',
        Params => {
            Search => 'look-up DNS',
        },
        ExpectedResult => [
            'CheckMXRecord::Nameserver',
        ],
        Success => 1,
    },
    {
        Name   => 'Multiple Term Search 2',
        Params => {
            Search => 'look-up      DNS',
        },
        ExpectedResult => [
            'CheckMXRecord::Nameserver',
        ],
        Success => 1,
    },
    {
        Name   => 'Empty Result',
        Params => {
            Search => 'WatcherType',
        },
        ExpectedResult => [],
        Success        => 1,
    },
    {
        Name   => 'Size Result',
        Params => {
            Category => 'OTOBO',
        },
        ExpectedResult => $OTOBOSettings,
        Success        => 1,
    },
    {
        Name   => 'Invisible Search',
        Params => {
            Search           => 'SystemConfiguration::MaximumDeployments',
            IncludeInvisible => 1,
        },
        ExpectedResult => [
            'SystemConfiguration::MaximumDeployments',
        ],
        Success => 1,
    },
    {
        Name   => '!Invisible Search',
        Params => {
            Search           => 'SystemConfiguration::MaximumDeployments',
            IncludeInvisible => 0,
        },
        ExpectedResult => [],
        Success        => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my @Result = $SysConfigObject->ConfigurationSearch( %{ $Test->{Params} } );

    if ( $Test->{Name} =~ m{Size} ) {
        $Self->Is(
            scalar @Result,
            $Test->{ExpectedResult},
            "$Test->{Name} correct",
        );
        next TEST;
    }

    my %LookupResult = map { $_ => 1 } @Result;

    for my $ExpectedItem ( @{ $Test->{ExpectedResult} } ) {

        $Self->True(
            $LookupResult{$ExpectedItem},
            "$Test->{Name} correct - Found '$ExpectedItem'",
        );
    }
}

$Self->DoneTesting();
