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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $main::Self
use Kernel::System::PostMaster ();

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $ConfigObject->Get('Home');

my @DynamicfieldIDs;
my @DynamicFieldUpdate;
my %NeededDynamicfields = (
    TicketFreeKey1  => 1,
    TicketFreeText1 => 1,
    TicketFreeKey2  => 1,
    TicketFreeText2 => 1,
    TicketFreeKey3  => 1,
    TicketFreeText3 => 1,
    TicketFreeKey4  => 1,
    TicketFreeText4 => 1,
    TicketFreeKey5  => 1,
    TicketFreeText5 => 1,
    TicketFreeKey5  => 1,
    TicketFreeText5 => 1,
    TicketFreeKey6  => 1,
    TicketFreeText6 => 1,
    TicketFreeTime1 => 1,
    TicketFreeTime2 => 1,
    TicketFreeTime3 => 1,
    TicketFreeTime4 => 1,
    TicketFreeTime5 => 1,
    TicketFreeTime6 => 1,
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
    'X-OTOBO-DynamicField-TicketFreeKey1'  => 1,
    'X-OTOBO-DynamicField-TicketFreeText1' => 1,
    'X-OTOBO-DynamicField-TicketFreeKey2'  => 1,
    'X-OTOBO-DynamicField-TicketFreeText2' => 1,
    'X-OTOBO-DynamicField-TicketFreeKey3'  => 1,
    'X-OTOBO-DynamicField-TicketFreeText3' => 1,
    'X-OTOBO-DynamicField-TicketFreeTime1' => 1,
    'X-OTOBO-DynamicField-TicketFreeTime2' => 1,
    'X-OTOBO-DynamicField-TicketFreeTime3' => 1,
    'X-OTOBO-DynamicField-TicketFreeTime4' => 1,
    'X-OTOBO-DynamicField-TicketFreeTime5' => 1,
    'X-OTOBO-DynamicField-TicketFreeTime6' => 1,
    'X-OTOBO-TicketKey1'                   => 1,
    'X-OTOBO-TicketValue1'                 => 1,
    'X-OTOBO-TicketKey2'                   => 1,
    'X-OTOBO-TicketValue2'                 => 1,
    'X-OTOBO-TicketKey3'                   => 1,
    'X-OTOBO-TicketValue3'                 => 1,
    'X-OTOBO-TicketTime1'                  => 1,
    'X-OTOBO-TicketTime2'                  => 1,
    'X-OTOBO-TicketTime3'                  => 1,
    'X-OTOBO-TicketTime4'                  => 1,
    'X-OTOBO-TicketTime5'                  => 1,
    'X-OTOBO-TicketTime6'                  => 1,
    'X-OTOBO-Owner'                        => 1,
    'X-OTOBO-OwnerID'                      => 1,
    'X-OTOBO-Responsible'                  => 1,
    'X-OTOBO-ResponsibleID'                => 1,
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

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

# use different subject format
for my $TicketSubjectConfig ( 'Right', 'Left' ) {
    $ConfigObject->Set(
        Key   => 'Ticket::SubjectFormat',
        Value => $TicketSubjectConfig,
    );

    # use different ticket number generators
    for my $NumberModule (qw(AutoIncrement DateChecksum Date)) {

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::PostMaster::Filter'] );
        my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

        $ConfigObject->Set(
            Key   => 'Ticket::NumberGenerator',
            Value => "Kernel::System::Ticket::Number::$NumberModule",
        );

        # use different storage back-ends
        for my $StorageModule (qw(ArticleStorageDB ArticleStorageFS)) {
            $ConfigObject->Set(
                Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
                Value => "Kernel::System::Ticket::Article::Backend::MIMEBase::$StorageModule",
            );

            # Recreate Ticket object for every loop.
            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
            $Kernel::OM->Get('Kernel::System::Ticket');

            # add and check rand postmaster filters
            my $FilterRandConfig = [
                {
                    Name  => 'filter' . $Helper->GetRandomID(),
                    Match => [
                        {
                            Key   => 'Subject',
                            Value => 'test',
                        },
                        {
                            Key   => 'To',
                            Value => 'EMAILADDRESS:darthvader@otobo.org',
                        },
                    ],
                    Not => [
                        {
                            Key   => 'Subject',
                            Value => undef,
                        },
                        {
                            Key   => 'To',
                            Value => undef,
                        },
                    ],
                    Set => [
                        {
                            Key   => 'X-OTOBO-Queue',
                            Value => 'Misc',
                        },
                        {
                            Key   => 'X-OTOBO-TicketKey1',
                            Value => 'Key1',
                        },
                        {
                            Key   => 'X-OTOBO-TicketValue1',
                            Value => 'Text1',
                        },
                    ],
                    StopAfterMatch => 0,
                },
                {
                    Name  => 'filter' . $Helper->GetRandomID(),
                    Match => [
                        {
                            Key   => 'Subject',
                            Value => 'test',
                        },
                        {
                            Key   => 'To',
                            Value => 'EMAILADDRESS:darthvader2@otobo.org',
                        },
                    ],
                    Not => [
                        {
                            Key   => 'Subject',
                            Value => undef,
                        },
                        {
                            Key   => 'To',
                            Value => undef,
                        },
                    ],
                    Set => [
                        {
                            Key   => 'X-OTOBO-TicketKey2',
                            Value => 'Key2',
                        },
                        {
                            Key   => 'X-OTOBO-TicketValue2',
                            Value => 'Text2',
                        },
                    ],
                    StopAfterMatch => 0,
                },
                {
                    Name  => 'filter' . $Helper->GetRandomID(),
                    Match => [
                        {
                            Key   => 'Subject',
                            Value => 'test 1',
                        },
                        {
                            Key   => 'To',
                            Value => 'otobo.org',
                        },
                    ],
                    Not => [
                        {
                            Key   => 'Subject',
                            Value => undef,
                        },
                        {
                            Key   => 'To',
                            Value => undef,
                        },
                    ],
                    Set => [
                        {
                            Key   => 'X-OTOBO-TicketKey3',
                            Value => 'Key3',
                        },
                        {
                            Key   => 'X-OTOBO-TicketValue3',
                            Value => 'Text3',
                        },
                    ],
                    StopAfterMatch => 0,
                },
                {
                    Name  => 'filter' . $Helper->GetRandomID(),
                    Match => [
                        {
                            Key   => 'Subject',
                            Value => 'NOT REGEX',
                        },
                        {
                            Key   => 'To',
                            Value => 'darthvader@otobo.org',
                        },
                    ],
                    Not => [
                        {
                            Key   => 'Subject',
                            Value => undef,
                        },
                        {
                            Key   => 'To',
                            Value => 1,
                        },
                    ],
                    Set => [
                        {
                            Key   => 'X-OTOBO-Ignore',
                            Value => 'yes',
                        },
                    ],
                    StopAfterMatch => 0,
                },
            ];
            for my $Filter ( @{$FilterRandConfig} ) {
                $PostMasterFilter->FilterAdd(
                    %{$Filter},
                );
                my %FilterData = $PostMasterFilter->FilterGet(
                    Name => $Filter->{Name},
                );
                $Self->IsDeeply(
                    \%FilterData,
                    $Filter,
                    "Added filter $Filter->{Name}",
                );
            }

            # get rand sender address
            my $UserRand1 = 'example-user' . $Helper->GetRandomID() . '@example.com';

            FILE:
            for my $File (qw(1 2 3 5 6 11 17 18 21 22 23)) {

                my $NamePrefix = "#$NumberModule $StorageModule $TicketSubjectConfig $File ";

                # new ticket check
                my $Location   = "$Home/scripts/test/sample/PostMaster/PostMaster-Test$File.box";
                my $ContentRef = $MainObject->FileRead(
                    Location => $Location,
                    Mode     => 'binmode',
                    Result   => 'ARRAY',
                );
                my @Content;
                for my $Line ( @{$ContentRef} ) {
                    if ( $Line =~ /^From:/ ) {
                        $Line = "From: \"Some Realname\" <$UserRand1>\n";
                    }
                    push @Content, $Line;
                }

                # follow up check
                my @ContentNew;
                for my $Line (@Content) {
                    push @ContentNew, $Line;
                }
                my @Return;

                $ConfigObject->Set(
                    Key   => 'PostmasterDefaultState',
                    Value => 'new'
                );
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        CommunicationLogObject => $CommunicationLogObject,
                        Email                  => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }

                if ( $File != 22 ) {
                    $Self->Is(
                        $Return[0] || 0,
                        1,
                        $NamePrefix . ' Run() - NewTicket',
                    );

                    $Self->True(
                        $Return[1] || 0,
                        $NamePrefix . ' Run() - NewTicket/TicketID',
                    );
                }
                else {
                    $Self->Is(
                        $Return[0] || 0,
                        5,
                        $NamePrefix . ' Run() - NewTicket',
                    );

                    $Self->False(
                        $Return[1],
                        $NamePrefix . ' Run() - NewTicket/TicketID',
                    );

                    next FILE;
                }

                # new/clear ticket and article objects
                $Kernel::OM->ObjectsDiscard(
                    Objects => [ 'Kernel::System::Ticket', 'Kernel::System::Ticket::Article' ]
                );
                my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
                my %Ticket       = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
                my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
                my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
                my @ArticleIDs           = map { $_->{ArticleID} } $ArticleObject->ArticleList(
                    TicketID => $Return[1],
                );

                if ( $File == 1 ) {
                    my @Tests = (
                        {
                            Key    => 'Queue',
                            Result => 'Misc',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeKey1',
                            Result => 'Key1',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText1',
                            Result => 'Text1',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeKey2',
                            Result => undef,
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText2',
                            Result => undef,
                        },
                        {
                            Key    => 'DynamicField_TicketFreeKey3',
                            Result => 'Key3',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText3',
                            Result => 'Text3',
                        },
                    );
                    for my $Test (@Tests) {
                        $Self->Is(
                            $Ticket{ $Test->{Key} },
                            $Test->{Result},
                            $NamePrefix . " $Test->{Key} check",
                        );
                    }
                }

                if ( $File == 3 ) {

                    # check body
                    my %Article = $ArticleBackendObject->ArticleGet(
                        TicketID      => $Ticket{TicketID},
                        ArticleID     => $ArticleIDs[0],
                        DynamicFields => 1,
                    );
                    my $MD5 = $MainObject->MD5sum( String => $Article{Body} ) || '';
                    $Self->Is(
                        $MD5,
                        '91346794644d70cd95553ab46d5f3334',
                        $NamePrefix . ' md5 body check',
                    );

                    # check attachments
                    my %Index = $ArticleBackendObject->ArticleAttachmentIndex(
                        ArticleID => $ArticleIDs[0],
                    );
                    my %Attachment = $ArticleBackendObject->ArticleAttachment(
                        ArticleID => $ArticleIDs[0],
                        FileID    => 2,
                    );
                    $MD5 = $MainObject->MD5sum( String => $Attachment{Content} ) || '';
                    $Self->Is(
                        $MD5,
                        '4e78ae6bffb120669f50bca56965f552',
                        $NamePrefix . ' md5 attachment check',
                    );

                }

                if ( $File == 5 ) {

                    my @Tests = (
                        {
                            Key    => 'DynamicField_TicketFreeKey1',
                            Result => 'Test',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText1',
                            Result => 'ABC',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeKey2',
                            Result => 'Test2',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeText2',
                            Result => 'ABC2',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime1',
                            Result => '2008-01-12 13:14:15',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime2',
                            Result => '2008-01-12 13:15:16',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime3',
                            Result => '2008-01-12 13:16:17',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime4',
                            Result => '2008-01-12 13:17:18',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime5',
                            Result => '2008-01-12 13:18:19',
                        },
                        {
                            Key    => 'DynamicField_TicketFreeTime6',
                            Result => '2008-01-12 13:19:20',
                        },
                    );
                    for my $Test (@Tests) {
                        $Self->Is(
                            $Ticket{ $Test->{Key} } || '',
                            $Test->{Result} || '-',
                            $NamePrefix . " $Test->{Key} check",
                        );
                    }
                }

                if ( $File == 6 ) {

                    # check body
                    my %Article = $ArticleBackendObject->ArticleGet(
                        TicketID      => $Ticket{TicketID},
                        ArticleID     => $ArticleIDs[0],
                        DynamicFields => 1,
                    );
                    my $MD5 = $MainObject->MD5sum( String => $Article{Body} ) || '';
                    $Self->Is(
                        $MD5,
                        '44da7f29cd0cca31532f6acd50b42da8',
                        $NamePrefix . ' md5 body check',
                    );

                    # check attachments
                    my %Index = $ArticleBackendObject->ArticleAttachmentIndex(
                        ArticleID => $ArticleIDs[0],
                    );
                    my %Attachment = $ArticleBackendObject->ArticleAttachment(
                        ArticleID => $ArticleIDs[0],
                        FileID    => 2,
                    );
                    $MD5 = $MainObject->MD5sum( String => $Attachment{Content} ) || '';
                    $Self->Is(
                        $MD5,
                        '0596f2939525c6bd50fc2b649e40fbb6',
                        $NamePrefix . ' md5 attachment check',
                    );

                }
                if ( $File == 11 ) {

                    # check body
                    my %Article = $ArticleBackendObject->ArticleGet(
                        TicketID      => $Ticket{TicketID},
                        ArticleID     => $ArticleIDs[0],
                        DynamicFields => 1,
                    );
                    my $MD5 = $MainObject->MD5sum( String => $Article{Body} ) || '';

                    $Self->Is(
                        $MD5,
                        '52f20c90a1f0d8cf3bd415e278992001',
                        $NamePrefix . ' md5 body check',
                    );
                }

                # send follow up #1
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: ' . $TicketObject->TicketSubjectBuild(
                            TicketNumber => $Ticket{TicketNumber},
                            Subject      => $Line,
                        );
                    }
                    push @Content, $Line;
                }
                $ConfigObject->Set(
                    Key   => 'PostmasterFollowUp',
                    Value => 'new'
                );
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        CommunicationLogObject => $CommunicationLogObject,
                        Email                  => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # new/clear ticket object
                $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
                $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
                $Self->Is(
                    $Ticket{State} || 0,
                    'new',
                    $NamePrefix . ' Run() - FollowUp/State check',
                );
                my $StateSet = $TicketObject->StateSet(
                    State    => 'pending reminder',
                    TicketID => $Return[1],
                    UserID   => 1,
                );
                $Self->True(
                    $StateSet || 0,
                    $NamePrefix . ' StateSet() - pending reminder',
                );

                # send follow up #2
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: ' . $TicketObject->TicketSubjectBuild(
                            TicketNumber => $Ticket{TicketNumber},
                            Subject      => $Line,
                        );
                    }
                    push @Content, $Line;
                }
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        CommunicationLogObject => $CommunicationLogObject,
                        Email                  => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # send follow up #3
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: '
                            . $ConfigObject->Get('Ticket::Hook')
                            . ": $Ticket{TicketNumber}";
                    }
                    push @Content, $Line;
                }
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        CommunicationLogObject => $CommunicationLogObject,
                        Email                  => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp (Ticket::Hook#: xxxxxxxxxx)',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # send follow up #4
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: '
                            . $ConfigObject->Get('Ticket::Hook')
                            . ":$Ticket{TicketNumber}";
                    }
                    push @Content, $Line;
                }
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        CommunicationLogObject => $CommunicationLogObject,
                        Email                  => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp (Ticket::Hook#:xxxxxxxxxx)',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # send follow up #5
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: '
                            . $ConfigObject->Get('Ticket::Hook')
                            . $Ticket{TicketNumber};
                    }
                    push @Content, $Line;
                }
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        CommunicationLogObject => $CommunicationLogObject,
                        Email                  => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }
                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp (Ticket::Hook#xxxxxxxxxx)',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # new/clear ticket object
                $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
                $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
                $Self->Is(
                    $Ticket{State} || 0,
                    'open',
                    $NamePrefix . ' Run() - FollowUp/PostmasterFollowUpState check',
                );
                $StateSet = $TicketObject->StateSet(
                    State    => 'closed successful',
                    TicketID => $Return[1],
                    UserID   => 1,
                );
                $Self->True(
                    $StateSet || 0,
                    $NamePrefix . ' StateSet() - closed successful',
                );

                # send follow up #3
                @Content = ();
                for my $Line (@ContentNew) {
                    if ( $Line =~ /^Subject:/ ) {
                        $Line = 'Subject: ' . $TicketObject->TicketSubjectBuild(
                            TicketNumber => $Ticket{TicketNumber},
                            Subject      => $Line,
                        );
                    }
                    push @Content, $Line;
                }
                $ConfigObject->Set(
                    Key   => 'PostmasterFollowUpStateClosed',
                    Value => 'new'
                );
                {
                    my $PostMasterObject = Kernel::System::PostMaster->new(
                        CommunicationLogObject => $CommunicationLogObject,
                        Email                  => \@Content,
                    );

                    @Return = $PostMasterObject->Run();
                }

                $Self->Is(
                    $Return[0] || 0,
                    2,
                    $NamePrefix . ' Run() - FollowUp',
                );
                $Self->True(
                    $Return[1] || 0,
                    $NamePrefix . ' Run() - FollowUp/TicketID',
                );

                # new/clear ticket object
                $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
                $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Return[1],
                    DynamicFields => 1,
                );
                $Self->Is(
                    $Ticket{State} || 0,
                    'new',
                    $NamePrefix . ' Run() - FollowUp/PostmasterFollowUpStateClosed check',
                );

                # delete ticket
                my $Delete = $TicketObject->TicketDelete(
                    TicketID => $Return[1],
                    UserID   => 1,
                );
                $Self->True(
                    $Delete || 0,
                    $NamePrefix . ' TicketDelete()',
                );
            }
            for my $Filter ( @{$FilterRandConfig} ) {
                $PostMasterFilter->FilterDelete(
                    Name => $Filter->{Name},
                );
            }
        }
    }
}

# filter test
my @Tests = (
    {
        Name  => '#1 - From Test',
        Check => {
            Queue                        => 'Misc',
            DynamicField_TicketFreeKey3  => 'Key3',
            DynamicField_TicketFreeText3 => 'Text3',
        },
        Config => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'sender@example.com',
                }
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTOBO-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTOBO-TicketValue1',
                    Value => 'Text1',
                },
                {
                    Key   => 'X-OTOBO-TicketKey3',
                    Value => 'Key3',
                },
                {
                    Key   => 'X-OTOBO-TicketValue3',
                    Value => 'Text3',
                },
            ],
        },
        DB => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'sender@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTOBO-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTOBO-TicketValue1',
                    Value => 'Text1',
                },
                {
                    Key   => 'X-OTOBO-TicketKey3',
                    Value => 'Key3',
                },
                {
                    Key   => 'X-OTOBO-TicketValue3',
                    Value => 'Text3',
                },
            ],
        },
    },
    {
        Name  => '#2 - From Test',
        Check => {
            Queue                        => 'Misc',
            DynamicField_TicketFreeKey1  => 'Key1#2',
            DynamicField_TicketFreeText1 => 'Text1#2',
        },
        Config => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'EMAILADDRESS:sender@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTOBO-TicketKey1',
                    Value => 'Key1#2',
                },
                {
                    Key   => 'X-OTOBO-TicketValue1',
                    Value => 'Text1#2',
                },
                {
                    Key   => 'X-OTOBO-TicketKey4',
                    Value => 'Key4#2',
                },
                {
                    Key   => 'X-OTOBO-TicketValue4',
                    Value => 'Text4#2',
                },
            ],
        },
        DB => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'EMAILADDRESS:sender@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTOBO-TicketKey1',
                    Value => 'Key1#2',
                },
                {
                    Key   => 'X-OTOBO-TicketValue1',
                    Value => 'Text1#2',
                },
                {
                    Key   => 'X-OTOBO-TicketKey4',
                    Value => 'Key4#2',
                },
                {
                    Key   => 'X-OTOBO-TicketValue4',
                    Value => 'Text4#2',
                },
            ],
        },
    },
    {
        Name   => '#3 - From Test',
        Config => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'EMAILADDRESS:not_this_sender@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTOBO-TicketKey1',
                    Value => 'Key1#3',
                },
                {
                    Key   => 'X-OTOBO-TicketValue1',
                    Value => 'Text1#3',
                },
                {
                    Key   => 'X-OTOBO-TicketKey3',
                    Value => 'Key3#3',
                },
                {
                    Key   => 'X-OTOBO-TicketValue3',
                    Value => 'Text3#3',
                },
            ],
        },
        DB => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'EMAILADDRESS:not_this_sender@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTOBO-TicketKey1',
                    Value => 'Key1#3',
                },
                {
                    Key   => 'X-OTOBO-TicketValue1',
                    Value => 'Text1#3',
                },
                {
                    Key   => 'X-OTOBO-TicketKey3',
                    Value => 'Key3#3',
                },
                {
                    Key   => 'X-OTOBO-TicketValue3',
                    Value => 'Text3#3',
                },
            ],
        },
    },
    {
        Name  => '#4 - Regular Expressions - match',
        Check => {
            DynamicField_TicketFreeKey4 => 'sender',
        },
        Config => {
            Match => [
                {
                    Key   => 'From',
                    Value => '(\w+)@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-TicketKey4',
                    Value => '[***]',
                },
            ],
        },
        DB => {
            Match => [
                {
                    Key   => 'From',
                    Value => '(\w+)@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-TicketKey4',
                    Value => '[***]',
                },
            ],
        },
    },
    {
        Name  => '#5 - Regular Expressions - match but no optional match result',
        Check => {
            DynamicField_TicketFreeKey5 => undef,
        },
        Config => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'sender([f][o][o])?@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-TicketKey5',
                    Value => '[***]',
                },
            ],
        },
        DB => {
            Match => [
                {
                    Key   => 'From',
                    Value => 'sender([f][o][o])?@example.com',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTOBO-TicketKey5',
                    Value => '[***]',
                },
            ],
        },
    },
);

$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::PostMaster::Filter'] );
my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

for my $Type (qw(Config DB)) {
    for my $Test (@Tests) {
        if ( $Type eq 'DB' ) {
            $PostMasterFilter->FilterAdd(
                Name           => $Test->{Name},
                StopAfterMatch => 0,
                %{ $Test->{DB} },
            );
        }
        else {
            diag "Name: $Test->{Name}";
            $ConfigObject->Set(
                Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
                Value => {
                    %{ $Test->{Config} },
                    Module => 'Kernel::System::PostMaster::Filter::Match',
                },
            );
        }
    }

    my $Email = 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: some subject

Some Content in Body
';

    my @Return;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => \$Email,
        );

        @Return = $PostMasterObject->Run();
    }
    $Self->Is(
        $Return[0] || 0,
        1,
        "#Filter $Type Run() - NewTicket",
    );
    $Self->True(
        $Return[1] || 0,
        "#Filter $Type Run() - NewTicket/TicketID",
    );

    # new/clear ticket object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    TEST:
    for my $Test (@Tests) {
        next TEST if !$Test->{Check};
        for my $Key ( sort keys %{ $Test->{Check} } ) {
            $Self->Is(
                $Ticket{$Key},
                $Test->{Check}->{$Key},
                "#Filter $Type Run('$Test->{Name}') - $Key",
            );
        }
    }

    # delete ticket
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $Return[1],
        UserID   => 1,
    );
    $Self->True(
        $Delete || 0,
        "#Filter $Type TicketDelete()",
    );

    # remove filter
    for my $Test (@Tests) {
        if ( $Type eq 'DB' ) {
            $PostMasterFilter->FilterDelete( Name => $Test->{Name} );
        }
        else {
            $ConfigObject->Set(
                Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
                Value => undef,
            );
        }
    }
}

# filter test Envelope-To and X-Envelope-To
@Tests = (
    {
        Name  => '#1 - Envelope-To Test',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Envelope-To: Some EnvelopeTo Name <envelopeto@example.com>
Subject: some subject

Some Content in Body
',
        Match => [
            {
                Key   => 'Envelope-To',
                Value => 'envelopeto@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-Queue',
                Value => 'Junk',
            },
            {
                Key   => 'X-OTOBO-TicketKey5',
                Value => 'Key5#1',
            },
            {
                Key   => 'X-OTOBO-TicketValue5',
                Value => 'Text5#1',
            },
        ],
        Check => {
            Queue                        => 'Junk',
            DynamicField_TicketFreeKey5  => 'Key5#1',
            DynamicField_TicketFreeText5 => 'Text5#1',
        },
    },
    {
        Name  => '#2 - X-Envelope-To Test',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
X-Envelope-To: Some XEnvelopeTo Name <xenvelopeto@example.com>
Subject: some subject

Some Content in Body
',
        Match => [
            {
                Key   => 'X-Envelope-To',
                Value => 'xenvelopeto@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-Queue',
                Value => 'Misc',
            },
            {
                Key   => 'X-OTOBO-TicketKey6',
                Value => 'Key6#1',
            },
            {
                Key   => 'X-OTOBO-TicketValue6',
                Value => 'Text6#1',
            },
        ],
        Check => {
            Queue                        => 'Misc',
            DynamicField_TicketFreeKey6  => 'Key6#1',
            DynamicField_TicketFreeText6 => 'Text6#1',
        },
    },
    {
        Name  => '#3 - X-Envelope-To Test with old post master format',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
X-Envelope-To: Some XEnvelopeTo Name <xenvelopeto@example.com>
Subject: some subject

Some Content in Body
',
        Match => {
            'X-Envelope-To' => 'xenvelopeto@example.com'
        },
        Set => {
            'X-OTOBO-Queue'        => 'Misc',
            'X-OTOBO-TicketKey6'   => 'Key6#1',
            'X-OTOBO-TicketValue6' => 'Text6#1',
        },
        Check => {
            Queue                        => 'Misc',
            DynamicField_TicketFreeKey6  => 'Key6#1',
            DynamicField_TicketFreeText6 => 'Text6#1',
        },
        Type => 'Config',
    },
    {
        Name  => '#4 - X-Envelope-To Test with Kernel::System::PostMaster::Filter::NewTicketReject',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
X-Envelope-To: Some XEnvelopeTo Name <xenvelopeto@example.com>
Subject: some subject

Some Content in Body
',
        Module => 'Kernel::System::PostMaster::Filter::NewTicketReject',
        Match  => [
            {
                Key   => 'X-Envelope-To',
                Value => 'xenvelopeto@example.com',
            }
        ],
        Set => [
            {
                Key   => 'X-OTOBO-Ignore',
                Value => 'yes',
            }
        ],
        Check => {
            ReturnCode => 5,
        },
        Type => 'Config',
    },
    {
        Name  => '#4 - X-Envelope-To Test with old post format Kernel::System::PostMaster::Filter::NewTicketReject',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
X-Envelope-To: Some XEnvelopeTo Name <xenvelopeto@example.com>
Subject: some subject

Some Content in Body
',
        Module => 'Kernel::System::PostMaster::Filter::NewTicketReject',
        Match  => {
            'X-Envelope-To' => 'xenvelopeto@example.com'
        },
        Set => {
            'X-OTOBO-Ignore' => 'yes',
        },
        Check => {
            ReturnCode => 5,
        },
        Type => 'Config',
    },

    # Test cases are deactivated, because of problems with RHEL/CentOS7 with PostgreSQL
    #     {
    #         Name  => '#5 - X-Envelope-To Test with Kernel::System::PostMaster::Filter::CMD',
    #         Email => 'From: Sender <sender@example.com>
    # To: Some Name <recipient@example.com>
    # X-Envelope-To: Some XEnvelopeTo Name <xenvelopeto@example.com>
    # Subject: some subject

    # Some Content in Body
    # ',
    #         Module => 'Kernel::System::PostMaster::Filter::CMD',
    #         CMD => 'echo "SPAM"',
    #         Set => [
    #             {
    #                 Key   => 'X-OTOBO-Ignore',
    #                 Value => 'yes',
    #             }
    #         ],
    #         Check => {
    #             ReturnCode => 5,
    #         },
    #         Type => 'Config',
    #     },
    #     {
    #         Name  => '#5 - X-Envelope-To Test with old post format Kernel::System::PostMaster::Filter::CMD',
    #         Email => 'From: Sender <sender@example.com>
    # To: Some Name <recipient@example.com>
    # X-Envelope-To: Some XEnvelopeTo Name <xenvelopeto@example.com>
    # Subject: some subject

    # Some Content in Body
    # ',
    #         Module => 'Kernel::System::PostMaster::Filter::CMD',
    #         CMD => 'echo "SPAM"',
    #         Set => {
    #             'X-OTOBO-Ignore' => 'yes',
    #         },
    #         Check => {
    #             ReturnCode => 5,
    #         },
    #         Type => 'Config',
    #     },
);

$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::PostMaster::Filter'] );
$PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

for my $Test (@Tests) {

    TYPE:
    for my $Type (qw(Config DB)) {
        next TYPE if $Test->{Type} && $Test->{Type} ne $Type;

        if ( $Type eq 'DB' ) {
            $PostMasterFilter->FilterAdd(
                Name           => $Test->{Name},
                StopAfterMatch => 0,
                %{$Test},
            );
        }
        else {
            $ConfigObject->Set(
                Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
                Value => {
                    Module => 'Kernel::System::PostMaster::Filter::Match',
                    %{$Test},
                },
            );
        }

        my @Return;
        {
            my $PostMasterObject = Kernel::System::PostMaster->new(
                CommunicationLogObject => $CommunicationLogObject,
                Email                  => \$Test->{Email},
            );

            @Return = $PostMasterObject->Run();
        }
        $Self->Is(
            $Return[0] || 0,
            $Test->{Check}->{ReturnCode} || 1,
            "#Filter $Type Run('$Test->{Name}') - NewTicket",
        );

        my %LookupRejectReturnCode = (
            4 => 1,    # follow up / close -> reject
            5 => 1,    # ignored (because of X-OTOBO-Ignore header)
        );

        if ( !$Test->{Check}->{ReturnCode} || !$LookupRejectReturnCode{ $Test->{Check}->{ReturnCode} } ) {

            $Self->True(
                $Return[1] || 0,
                "#Filter $Type Run('$Test->{Name}') - NewTicket/TicketID",
            );

            # new/clear ticket object
            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
            my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

            my %Ticket = $TicketObject->TicketGet(
                TicketID      => $Return[1],
                DynamicFields => 1,
            );

            TEST:
            for my $TestCheck ($Test) {
                next TEST if !$TestCheck->{Check};
                for my $Key ( sort keys %{ $TestCheck->{Check} } ) {
                    $Self->Is(
                        $Ticket{$Key},
                        $TestCheck->{Check}->{$Key},
                        "#Filter $Type Run('$TestCheck->{Name}') - $Key",
                    );
                }
            }

            # delete ticket
            my $Delete = $TicketObject->TicketDelete(
                TicketID => $Return[1],
                UserID   => 1,
            );
            $Self->True(
                $Delete || 0,
                "#Filter $Type TicketDelete()",
            );
        }

        # remove filter
        for my $Test (@Tests) {
            if ( $Type eq 'DB' ) {
                $PostMasterFilter->FilterDelete( Name => $Test->{Name} );
            }
            else {
                $ConfigObject->Set(
                    Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
                    Value => undef,
                );
            }
        }
    }
}

# revert changes to dynamic fields
for my $DynamicField (@DynamicFieldUpdate) {
    my $SuccessUpdate = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
        Reorder => 0,
        UserID  => 1,
        %{$DynamicField},
    );
    $Self->True(
        $SuccessUpdate,
        "Reverted changes on ValidID for $DynamicField->{Name} field.",
    );
}

for my $DynamicFieldID (@DynamicfieldIDs) {

    # delete the dynamic field
    my $FieldDelete = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
    $Self->True(
        $FieldDelete,
        "Deleted dynamic field with id $DynamicFieldID.",
    );
}

# test X-OTOBO-(Owner|Responsible)
my ( $Login, $UserID ) = $Helper->TestUserCreate();

my %OwnerResponsibleTests = (
    Owner => {
        File  => 'Owner',
        Check => {
            Owner => $Login,
        },
    },
    OwnerID => {
        File  => 'OwnerID',
        Check => {
            OwnerID => $UserID,
        },
    },
    Responsible => {
        File  => 'Responsible',
        Check => {
            Responsible => $Login,
        },
    },
    ResponsibleID => {
        File  => 'ResponsibleID',
        Check => {
            ResponsibleID => $UserID,
        },
    },
);

for my $Test ( sort keys %OwnerResponsibleTests ) {

    my $FileSuffix = $OwnerResponsibleTests{$Test}->{File};
    my $Location   = "$Home/scripts/test/sample/PostMaster/PostMaster-Test-$FileSuffix.box";

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );

    for my $Line ( @{$ContentRef} ) {
        $Line =~ s{ ^ (X-OTOBO-(?:Owner|Responsible):) .*? $ }{$1$Login}x;
        $Line =~ s{ ^ (X-OTOBO-(?:Owner|Responsible)ID:) .*? $ }{$1$UserID}x;
    }

    my $PostMasterObject = Kernel::System::PostMaster->new(
        CommunicationLogObject => $CommunicationLogObject,
        Email                  => $ContentRef,
    );

    my @Return = $PostMasterObject->Run();

    $Self->Is(
        $Return[0] || 0,
        1,
        $Test . ' Run() - NewTicket',
    );

    $Self->True(
        $Return[1],
        $Test . ' Run() - NewTicket/TicketID',
    );

    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 0,
    );

    for my $Field ( sort keys %{ $OwnerResponsibleTests{$Test}->{Check} } ) {
        $Self->Is(
            $Ticket{$Field},
            $OwnerResponsibleTests{$Test}->{Check}->{$Field},
            $Test . ' Check Field - ' . $Field,
        );
    }
}

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

# Test ticket creation from application/xml content type email (bug#13644).
my $Location   = "$Home/scripts/test/sample/PostMaster/PostMaster-Test27.box";
my $ContentRef = $MainObject->FileRead(
    Location => $Location,
    Mode     => 'binmode',
    Result   => 'ARRAY',
);

my $PostMasterObject = Kernel::System::PostMaster->new(
    CommunicationLogObject => $CommunicationLogObject,
    Email                  => $ContentRef,
);
my @PostMasterReturn = $PostMasterObject->Run();

my $TicketID = $PostMasterReturn[1];

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
my @ArticleIDs           = map { $_->{ArticleID} } $ArticleObject->ArticleList(
    TicketID => $TicketID,
);

my $ArticleID = $ArticleIDs[0];

# Check attachment.
my %Index = $ArticleBackendObject->ArticleAttachmentIndex(
    ArticleID => $ArticleID,
);

$Self->Is(
    $Index{1}->{Filename},
    'Test-123-456-789',
    "ArticleID $ArticleID has attachment with name '$Index{1}->{Filename}'",
);
$Self->Is(
    $Index{1}->{ContentType},
    'application/xml; charset=utf-8',
    "ArticleID $ArticleID has attachment with content-type '$Index{1}->{ContentType}'",
);

# cleanup is done by RestoreDatabase

done_testing;
