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

use Kernel::System::PostMaster;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my @DynamicfieldIDs;
my @DynamicFieldUpdate;

my %NeededDynamicfields = (
    TicketFreeText1 => 1,
    TicketFreeText2 => 1,
);

# list available dynamic fields
my $DynamicFields = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
    Valid      => 0,
    ResultType => 'HASH',
);
$DynamicFields = ( ref $DynamicFields eq 'HASH' ? $DynamicFields : {} );
$DynamicFields = { reverse %{$DynamicFields} };

for my $FieldName ( sort keys %NeededDynamicfields ) {
    if ( !$DynamicFields->{$FieldName} ) {

        # create a dynamic field
        my $FieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
            Name       => $FieldName,
            Label      => $FieldName . "_test",
            FieldOrder => 9991,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => 'a value',
            },
            ValidID => 1,
            UserID  => 1,
        );

        # verify dynamic field creation
        $Self->True(
            $FieldID,
            "DynamicFieldAdd() successful for Field $FieldName",
        );

        push @DynamicfieldIDs, $FieldID;
    }
    else {
        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet( ID => $DynamicFields->{$FieldName} );

        if ( $DynamicField->{ValidID} > 1 ) {
            push @DynamicFieldUpdate, $DynamicField;
            $DynamicField->{ValidID} = 1;
            my $SuccessUpdate = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
                %{$DynamicField},
                Reorder => 0,
                UserID  => 1,
                ValidID => 1,
            );

            # verify dynamic field creation
            $Self->True(
                $SuccessUpdate,
                "DynamicFieldUpdate() successful update for Field $DynamicField->{Name}",
            );
        }
    }
}

my %NeededXHeaders = (
    'X-OTOBO-DynamicField-TicketFreeText1' => 1,
    'X-OTOBO-DynamicField-TicketFreeText2' => 1,
);

my $XHeaders          = $ConfigObject->Get('PostmasterX-Header');
my @PostmasterXHeader = @{$XHeaders};
HEADER:
for my $Header ( sort keys %NeededXHeaders ) {
    next HEADER if ( grep { $_ eq $Header } @PostmasterXHeader );
    push @PostmasterXHeader, $Header;
}
$ConfigObject->Set(
    Key   => 'PostmasterX-Header',
    Value => \@PostmasterXHeader
);

# disable not needed event module
$ConfigObject->Set(
    Key => 'Ticket::EventModulePost###9600-TicketDynamicFieldDefault',
);

# filter test
my @Tests = (
    {
        Name  => '#1 - Body Test',
        Match => [
            {
                Key   => 'Body',
                Value => '(?s:server:\s+(?<server>[a-z.]+).*?IP\s+address:\s+(?<ip>\d+\.\d+\.\d+\.\d+))',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText1',
                Value => '[**\server**]',
            },
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText2',
                Value => '[**\ip**]',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => 'example.tld',
            DynamicField_TicketFreeText2 => '192.168.0.1',
        },
    },
    {
        Name  => '#2 - Body+Subject Test',
        Match => [
            {
                Key   => 'Subject',
                Value => 'Server:\s+(?<server>[a-z.]+)',
            },
            {
                Key   => 'Body',
                Value => 'IP\s+address:\s+(?<ip>\d+\.\d+\.\d+\.\d+)',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText1',
                Value => '[**\server**]',
            },
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText2',
                Value => '[**\ip**]',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => 'example.tld',
            DynamicField_TicketFreeText2 => '192.168.0.1',
        },
    },
);

$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::PostMaster::Filter'] );
my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

for my $Test (@Tests) {
    $PostMasterFilter->FilterAdd(
        Name           => $Test->{Name},
        StopAfterMatch => 0,
        %{$Test},
    );

    my $Email = 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: Server: example.tld

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
';

    my @Return;
    {
        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => 'Email',
                Direction => 'Incoming',
            },
        );
        $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => \$Email,
        );

        @Return = $PostMasterObject->Run();

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }
    $Self->Is(
        $Return[0] || 0,
        1,
        "#Filter Run() - NewTicket",
    );
    $Self->True(
        $Return[1] || 0,
        "#Filter Run() - NewTicket/TicketID",
    );

    # new/clear ticket object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{Check} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{Check}->{$Key},
            "#Filter Run('$Test->{Name}') - $Key",
        );
    }

    # delete ticket
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $Return[1],
        UserID   => 1,
    );
    $Self->True(
        $Delete || 0,
        "#Filter TicketDelete()",
    );

    # remove filter
    $PostMasterFilter->FilterDelete( Name => $Test->{Name} );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
