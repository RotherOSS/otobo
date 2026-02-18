# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use Test2::V0 qw(:DEFAULT), qw(etc);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
my $TemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
my $ValidObject    = $Kernel::OM->Get('Kernel::System::Valid');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# define needed variable
my $RandomID = $Helper->GetRandomID;

# create test user
my ( undef, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $ValidID = $ValidObject->ValidLookup(
    Valid => 'valid',
);
my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
    Group => 'users',
);

# create test queues and templates
my %QueueName2ID;
my %TemplateName2ID;
for my $Count ( 1 .. 5 ) {
    my %QueueData = (
        Name                => 'TestQueue' . $Count . $RandomID,
        GroupID             => $GroupID,
        Calendar            => '',
        FirstResponseTime   => '',
        FirstResponseNotify => '',
        UpdateTime          => '',
        UpdateNotify        => '',
        SolutionTime        => '',
        SolutionNotify      => '',
        UnlockTimeout       => '',
        FollowUpID          => 1,
        FollowUpLock        => 0,
        DefaultSignKey      => '',
        SystemAddressID     => 1,
        SalutationID        => 1,
        SignatureID         => 1,
        Comment             => 'TestComment' . $Count . $RandomID,
        ValidID             => $ValidID,
    );
    my $QueueAddSuccess = $QueueObject->QueueAdd(
        %QueueData,
        UserID => $TestUserID,
    );
    ok( $QueueAddSuccess, 'queue created successfully' );
    my $QueueID = $QueueObject->QueueLookup(
        Queue => 'TestQueue' . $Count . $RandomID,
    );
    $QueueName2ID{ 'TestQueue' . $Count . $RandomID } = $QueueID;

    # create test template
    my %TemplateData = (
        Name         => 'TestTemplate' . $Count . $RandomID,
        Comment      => 'TestComment' . $Count . $RandomID,
        Template     => 'TestTemplateContent' . $Count . $RandomID,
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',
        ValidID      => $ValidID,
    );
    my $TemplateAddSuccess = $TemplateObject->StandardTemplateAdd(
        %TemplateData,
        UserID => $TestUserID,
    );
    ok( $TemplateAddSuccess, 'template created successfully' );
    my $TemplateID = $TemplateObject->StandardTemplateLookup(
        StandardTemplate => 'TestTemplate' . $Count . $RandomID,
    );
    $TemplateName2ID{ 'TestTemplate' . $Count . $RandomID } = $TemplateID;
}

# set queue template relation
my $RelationAddSuccess = $QueueObject->QueueStandardTemplateMemberAdd(
    QueueID            => $QueueName2ID{ 'TestQueue1' . $RandomID },
    StandardTemplateID => $TemplateName2ID{ 'TestTemplate1' . $RandomID },
    Active             => 1,
    UserID             => $TestUserID,
);
ok( $RelationAddSuccess, 'relation added successfully' );

# testing export
my $ExportData = $QueueObject->ExportQueueTemplates();
is(
    $ExportData,
    hash {
        field 'TestQueue1' . $RandomID => [ 'TestTemplate1' . $RandomID ];

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    'TestQueue2' . $RandomID => [],
    'TestQueue3' . $RandomID => [ 'TestTemplate1' . $RandomID ],
    'TestQueue4' . $RandomID => [
        'TestTemplate1' . $RandomID,
        'TestTemplate2' . $RandomID
    ],
    'TestQueue5' . $RandomID => [
        'TestTemplate1' . $RandomID,
        'TestTemplate2' . $RandomID,
        'TestTemplate3' . $RandomID,
        'TestTemplate4' . $RandomID,
        'TestTemplate5' . $RandomID
    ],
);

my $ImportSuccess = $QueueObject->ImportQueueTemplates(
    QueueTemplates => \%ImportData,
    UserID         => $TestUserID,
);
ok( $ImportSuccess, 'imported relations successfully' );

my %Relations;
for my $QueueName ( keys %QueueName2ID ) {
    my %QueueTemplates = $QueueObject->QueueStandardTemplateMemberList(
        QueueID => $QueueName2ID{$QueueName},
    );
    $Relations{$QueueName} = \%QueueTemplates;
}

is(
    \%Relations,
    hash {
        field 'TestQueue1' . $RandomID => {
            $TemplateName2ID{ 'TestTemplate1' . $RandomID } => 'TestTemplate1' . $RandomID,
        };
        field 'TestQueue2' . $RandomID => {};
        field 'TestQueue3' . $RandomID => {
            $TemplateName2ID{ 'TestTemplate1' . $RandomID } => 'TestTemplate1' . $RandomID,
        };
        field 'TestQueue4' . $RandomID => {
            $TemplateName2ID{ 'TestTemplate1' . $RandomID } => 'TestTemplate1' . $RandomID,
            $TemplateName2ID{ 'TestTemplate2' . $RandomID } => 'TestTemplate2' . $RandomID,
        };
        field 'TestQueue5' . $RandomID => {
            $TemplateName2ID{ 'TestTemplate1' . $RandomID } => 'TestTemplate1' . $RandomID,
            $TemplateName2ID{ 'TestTemplate2' . $RandomID } => 'TestTemplate2' . $RandomID,
            $TemplateName2ID{ 'TestTemplate3' . $RandomID } => 'TestTemplate3' . $RandomID,
            $TemplateName2ID{ 'TestTemplate4' . $RandomID } => 'TestTemplate4' . $RandomID,
            $TemplateName2ID{ 'TestTemplate5' . $RandomID } => 'TestTemplate5' . $RandomID,
        };

        etc();
    },
    'imported data looks as expected'
);

done_testing;
