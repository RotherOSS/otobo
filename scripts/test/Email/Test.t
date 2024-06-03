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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# do not really send emails
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

my $SendEmail = sub {
    my %Param = @_;

    my $EmailObject     = $Kernel::OM->Get('Kernel::System::Email');
    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

    # Delete mail queue
    $MailQueueObject->Delete();

    # Generate the mail and queue it
    $EmailObject->Send( %Param, );

    # Get last item in the queue.
    my $Items = $MailQueueObject->List();
    $Items = [ sort { $b->{ID} <=> $a->{ID} } @{$Items} ];
    my $LastItem = $Items->[0];

    my $Result = $MailQueueObject->Send( %{$LastItem} );

    return (
        \$LastItem->{Message}->{Header},
        \$LastItem->{Message}->{Body},
    );
};

# get test email backed object
my $TestBackendObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Success = $TestBackendObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestBackendObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

# get email object
my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

for ( 1 .. 2 ) {

    # call Send and get results
    my ( $Header, $Body ) = $SendEmail->(
        From     => 'john.smith@example.com',
        To       => 'john.smith2@example.com',
        Subject  => 'some subject',
        Body     => 'Some Body',
        MimeType => 'text/html',
        Charset  => 'utf8',
    );

    $Self->True(
        $Body,
        "Email delivered to backend",
    );
}

my $Emails = $TestBackendObject->EmailsGet();

$Self->Is(
    scalar @{$Emails},
    2,
    "Emails fetched from backend",
);

for my $Index ( 0 .. 1 ) {
    $Self->Is(
        $Emails->[$Index]->{From},
        'john.smith@example.com',
        "From header",
    );
    $Self->IsDeeply(
        $Emails->[$Index]->{ToArray},
        ['john.smith2@example.com'],
        "To header",
    );
    $Self->True(
        $Emails->[$Index]->{Header},
        "Header field",
    );
    $Self->True(
        $Emails->[$Index]->{Body},
        "Body field",
    );
}

$Success = $TestBackendObject->CleanUp();
$Self->True(
    $Success,
    'Final cleanup',
);

$Self->IsDeeply(
    $TestBackendObject->EmailsGet(),
    [],
    'Test backend empty after final cleanup',
);

$Self->DoneTesting();
