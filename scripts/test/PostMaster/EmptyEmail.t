# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

for my $Backend (qw(DB FS)) {

    # Change the article storage backend.
    $Helper->ConfigSettingChange(
        Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
        Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorage' . $Backend,
    );

    # Re-create article backend object for every run, in order to reflect the article storage backend change.
    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    my $Location = $ConfigObject->Get('Home')
        . '/scripts/test/sample/EmailParser/EmptyEmail.eml';

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
        "$Backend - Ticket created"
    );

    my @ArticleIDs = map { $_->{ArticleID} } $ArticleObject->ArticleList( TicketID => $TicketID );
    $Self->True(
        $ArticleIDs[0],
        "$Backend - Article created"
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        ArticleID => $ArticleIDs[0],
        TicketID  => $TicketID,
    );

    $Self->Is(
        $Article{Body} // '',    # Oracle stores '' as undef.
        '',
        'Empty article body found'
    );

    my %Attachments = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleIDs[0],
    );

    $Self->IsDeeply(
        $Attachments{2},
        {
            'ContentAlternative' => '',
            'ContentID'          => '',
            'ContentType'        => 'application/x-download; name="=?UTF-8?Q?=C5=81atwa_sprawa.txt?="',
            'Disposition'        => 'attachment',
            'Filename'           => 'Łatwa_sprawa.txt',
            'FilesizeRaw'        => 0
        },
        "$Backend - Attachment filename"
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
