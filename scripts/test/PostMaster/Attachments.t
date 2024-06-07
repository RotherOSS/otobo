# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
use Test2::V0;
use List::Util qw(any);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::PostMaster ();

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $MainObject         = $Kernel::OM->Get('Kernel::System::Main');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# ensure that the appropriate X-Headers are available in the config
{
    my %NeededXHeaders = (
        'X-OTOBO-AttachmentExists' => 1,
        'X-OTOBO-AttachmentCount'  => 1,
    );

    my $XHeaders          = $ConfigObject->Get('PostmasterX-Header');
    my @PostmasterXHeader = @{$XHeaders};

    HEADER:
    for my $Header ( sort keys %NeededXHeaders ) {

        # Verify header is already part of the config
        my $IsInConfig = any { $_ eq $Header } @PostmasterXHeader;

        ok( $IsInConfig, "Headermight be in config already: $Header." );
    }
}

my @DynamicfieldIDs;
my @DynamicFieldUpdate;

my %NeededDynamicfields = (
    TicketFreeText1 => 1,
    TicketFreeText2 => 1,
);

# list available dynamic fields
my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
    Valid      => 0,
    ResultType => 'HASH',
);
$DynamicFields = ( ref $DynamicFields eq 'HASH' ? $DynamicFields : {} );
$DynamicFields = { reverse %{$DynamicFields} };

for my $FieldName ( sort keys %NeededDynamicfields ) {
    if ( !$DynamicFields->{$FieldName} ) {

        # create a dynamic field
        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
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
        ok( $FieldID, "DynamicFieldAdd() successful for Field $FieldName" );

        push @DynamicfieldIDs, $FieldID;
    }
    else {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet( ID => $DynamicFields->{$FieldName} );

        if ( $DynamicField->{ValidID} > 1 ) {
            push @DynamicFieldUpdate, $DynamicField;
            $DynamicField->{ValidID} = 1;
            my $SuccessUpdate = $DynamicFieldObject->DynamicFieldUpdate(
                %{$DynamicField},
                Reorder => 0,
                UserID  => 1,
                ValidID => 1,
            );

            # verify dynamic field update
            ok( $SuccessUpdate, "DynamicFieldUpdate() successful for Field $DynamicField->{Name}" );
        }
    }
}

# disable not needed event module
$ConfigObject->Set(
    Key => 'Ticket::EventModulePost###9600-TicketDynamicFieldDefault',
);

# enable the Post master filter DetectAttachment. This filter is inactive per default,
# see  https://github.com/RotherOSS/otobo/issues/3419
$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule###000-DetectAttachment',
    Value => {
        Module => 'Kernel::System::PostMaster::Filter::DetectAttachment',
    },
);

# Read email content (from a file).
my $EmailAttachment = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/EmailParser/MultipartMixedPlain.eml',

    # Type            => 'Attachment',
    Result => 'ARRAY',
);

# Read email content that contains inline image.
my $EmailInlineImage = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/PostMaster/InlineImage.box',
    Result   => 'ARRAY',
);

# Workaround due used email have not a From value
unshift @{$EmailAttachment}, 'From: Sender <sender@example.com>';

# filter test
my @Tests = (
    {
        Name  => 'Mail without attachments',
        Match => [
            {
                Key   => 'X-OTOBO-AttachmentExists',
                Value => 'no',
            },
            {
                Key   => 'X-OTOBO-AttachmentCount',
                Value => 0,
            }
        ],
        Set => [
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText1',
                Value => 'No Attachments in mail',
            },
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText2',
                Value => 'CeroAttachments',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => 'No Attachments in mail',
            DynamicField_TicketFreeText2 => 'CeroAttachments',
        },
        Email => <<'END_EMAIL',
From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: Server: example.tld

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
END_EMAIL
    },
    {
        Name  => 'Mail with attachments',
        Match => [
            {
                Key   => 'X-OTOBO-AttachmentExists',
                Value => 'yes',
            },
            {
                Key   => 'X-OTOBO-AttachmentCount',
                Value => 1,
            }
        ],
        Set => [
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText1',
                Value => 'A normal SMIME email',
            },
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText2',
                Value => 'AtLeastOneAttachment',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => 'A normal SMIME email',
            DynamicField_TicketFreeText2 => 'AtLeastOneAttachment',
        },
        Email => $EmailAttachment,
    },
    {
        Name  => 'Mail with inline images',
        Match => [
            {
                Key   => 'X-OTOBO-AttachmentExists',
                Value => 'yes',
            },
            {
                Key   => 'X-OTOBO-AttachmentCount',
                Value => 1,
            }
        ],
        Set => [
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText1',
                Value => 'This should not be set',
            },
            {
                Key   => 'X-OTOBO-DynamicField-TicketFreeText2',
                Value => 'This should not be set',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => undef,
            DynamicField_TicketFreeText2 => undef,
        },
        Email => $EmailInlineImage,
    },
);

$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::PostMaster::Filter'] );
my $PostMasterFilterObject = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

for my $Test (@Tests) {
    subtest $Test->{Name} => sub {
        $PostMasterFilterObject->FilterAdd(
            Name           => $Test->{Name},
            StopAfterMatch => 0,
            $Test->%*,
        );

        my $Email = $Test->{Email};

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
                Email                  => $Email,
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
        is(
            $Return[0],
            1,
            "#Filter Run() - NewTicket",
        );
        ok( $Return[1] || 0, "#Filter Run() - NewTicket/TicketID" );

        # new/clear ticket object
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $Return[1],
            DynamicFields => 1,
        );

        for my $Key ( sort keys %{ $Test->{Check} } ) {
            is(
                $Ticket{$Key},
                $Test->{Check}->{$Key},
                "check the dymamic field $Key",
            );
        }

        # delete ticket
        my $Delete = $TicketObject->TicketDelete(
            TicketID => $Return[1],
            UserID   => 1,
        );
        ok( $Delete || 0, "#Filter TicketDelete()" );

        # remove filter
        $PostMasterFilterObject->FilterDelete( Name => $Test->{Name} );
    };
}

done_testing;
