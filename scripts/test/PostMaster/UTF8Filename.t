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

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Backend (qw(DB FS)) {

    $ConfigObject->Set(
        Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
        Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
    );

    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/PostMaster/UTF8Filename.box";

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );

    my $TicketID;
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
            Email                  => $ContentRef,
        );

        my @Return = $PostMasterObject->Run();

        $TicketID = $Return[1];

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }

    $Self->True(
        $TicketID,
        "$Backend - Ticket created",
    );

    my @ArticleIDs = map { $_->{ArticleID} } $ArticleObject->ArticleList( TicketID => $TicketID );
    $Self->True(
        $ArticleIDs[0],
        "$Backend - Article created",
    );

    my %Attachments = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleIDs[0],
    );

    $Self->IsDeeply(
        $Attachments{1},
        {
            ContentAlternative => '',
            ContentID          => '',
            ContentType        => 'application/pdf; name="=?UTF-8?Q?Documentacio=CC=81n=2Epdf?="',
            Filename           => 'Documentación.pdf',
            FilesizeRaw        => '132',
            Disposition        => 'attachment'
        },
        "$Backend - Attachment filename",
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
