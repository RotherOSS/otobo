# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::EmailParser ();

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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

    return ( \$LastItem->{Message}->{Header}, \$LastItem->{Message}->{Body}, );
};

# do not validate emails addresses
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# do not really send emails
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# test scenarios
my @Tests = (
    {
        Name => 'DefaultHeader',
        Data => {
            From    => 'john.smith@example.com',
            To      => 'john.smith2@example.com',
            Subject => 'some subject',
            Body    => 'Some Body',
            Type    => 'text/plain',
            Charset => 'utf8',
        },
        Check => {
            'Precedence:'     => 'bulk',
            'Auto-Submitted:' => 'auto-generated',
        },
    },
    {
        Name => 'X-Header',
        Data => {
            From    => 'john.smith@example.com',
            To      => 'john.smith2@example.com',
            Subject => 'some subject',
            Body    => 'Some Body',
            Type    => 'text/plain',
            Charset => 'utf8',
        },
        Check => {
            'X-OTOBO-Test' => 'DefaultHeader',
        },
    },
);

for my $Test (@Tests) {
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Email'] );
    my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

    # do not really send emails
    $ConfigObject->Set(
        Key   => 'Sendmail::DefaultHeaders',
        Value => $Test->{Check},
    );

    my ( $Header, $Body, ) = $SendEmail->(
        %{ $Test->{Data} },
    );

    # end MIME::Tools workaround
    my $Email = ${$Header} . "\n" . ${$Body};

    # parse email
    my $ParserObject = Kernel::System::EmailParser->new(
        Email => $Email,
    );

    # check header
    KEY:
    for my $Key ( sort keys %{ $Test->{Check} || {} } ) {
        next KEY unless $Test->{Check}->{$Key};

        is(
            $ParserObject->GetParam( WHAT => $Key ),
            $Test->{Check}->{$Key},
            "$Test->{Name}: GetParam(WHAT => '$Key')",
        );
    }
}

done_testing;
