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

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0 qw(:DEFAULT), qw(etc);

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::UnitTest::RegisterOM;        # Set up $Kernel::OM

our $Self;

my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

my @Templates = (
    {
        Name         => 'text' . $RandomID,
        ValidID      => 1,
        Template     => 'Template text',
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',
        Comment      => 'some comment',
        UserID       => 1,
    },
    {
        Name         => 'text_second_' . $RandomID,
        ValidID      => 1,
        Template     => 'Template text',
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',
        Comment      => 'some comment',
        UserID       => 1,
    },
);

my @AddedTemplateIDs;

# get standard template object
my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

for my $Template (@Templates) {

    # add
    my $ID = $StandardTemplateObject->StandardTemplateAdd(
        %{$Template},
    );
    ok(
        $ID,
        "StandardTemplateAdd() - $ID",
    );

    push @AddedTemplateIDs, $ID;
}

my @Tests = (
    {
        Name    => 'Empty',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            Name                     => 'text' . $RandomID,
            ID                       => $AddedTemplateIDs[0],
            PreSelectedTicketStateID => 1,
            UserID                   => undef,
            ValidID                  => 1,
            TemplateType             => 'Answer',
            ContentType              => 'text/plain; charset=utf-8',
        },
        Success => 0,
    },
    {
        Name   => 'Missing ID',
        Config => {
            Name                     => 'text' . $RandomID,
            ID                       => undef,
            PreSelectedTicketStateID => 1,
            UserID                   => 1,
            ValidID                  => 1,
            TemplateType             => 'Answer',
            ContentType              => 'text/plain; charset=utf-8',
        },
        Success => 0,
    },
    {
        Name   => 'First Template Ticket StateID 1',
        Config => {
            Name                     => 'text' . $RandomID,
            ID                       => $AddedTemplateIDs[0],
            PreSelectedTicketStateID => 1,
            UserID                   => 1,
            ValidID                  => 1,
            TemplateType             => 'Answer',
            ContentType              => 'text/plain; charset=utf-8',
        },
        Success         => 1,
        ExpectedResults => hash {
            field 'ID'                       => $AddedTemplateIDs[0];
            field 'Name'                     => $Templates[0]->{Name};
            field 'PreSelectedTicketStateID' => 1;

            etc();
        },
    },
    {
        Name   => 'First Template Ticket StateID 2',
        Config => {
            Name                     => 'text' . $RandomID,
            ID                       => $AddedTemplateIDs[0],
            PreSelectedTicketStateID => 2,
            UserID                   => 1,
            ValidID                  => 1,
            TemplateType             => 'Answer',
            ContentType              => 'text/plain; charset=utf-8',
        },
        Success         => 1,
        ExpectedResults => hash {
            field 'ID'                       => $AddedTemplateIDs[0];
            field 'Name'                     => $Templates[0]->{Name};
            field 'PreSelectedTicketStateID' => 2;

            etc();
        },
    },
    {
        Name   => 'First Template Ticket StateID unset',
        Config => {
            Name         => 'text' . $RandomID,
            ID           => $AddedTemplateIDs[0],
            UserID       => 1,
            ValidID      => 1,
            TemplateType => 'Answer',
            ContentType  => 'text/plain; charset=utf-8',
        },
        Success         => 1,
        ExpectedResults => hash {
            field 'ID'                       => $AddedTemplateIDs[0];
            field 'Name'                     => $Templates[0]->{Name};
            field 'PreSelectedTicketStateID' => undef;

            etc();
        },
    },
    {
        Name   => 'Second Template Ticket StateID 1',
        Config => {
            Name                     => 'text_second_' . $RandomID,
            ID                       => $AddedTemplateIDs[1],
            PreSelectedTicketStateID => 1,
            UserID                   => 1,
            ValidID                  => 1,
            TemplateType             => 'Answer',
            ContentType              => 'text/plain; charset=utf-8',
        },
        Success         => 1,
        ExpectedResults => hash {
            field 'ID'                       => $AddedTemplateIDs[1];
            field 'Name'                     => $Templates[1]->{Name};
            field 'PreSelectedTicketStateID' => 1;

            etc();
        },
    },
);

TEST:
for my $Test (@Tests) {

    my $Success = $StandardTemplateObject->StandardTemplateUpdate( %{ $Test->{Config} } );

    # easy compare
    if ( !$Success ) {
        $Success = 0;
    }

    is(
        $Success,
        $Test->{Success},
        "$Test->{Name} StandardTemplateUpdate() - ",
    );

    next TEST if !$Test->{Success};

    my %Data = $StandardTemplateObject->StandardTemplateGet(
        ID => $Test->{Config}->{ID},
    );

    is(
        \%Data,
        $Test->{ExpectedResults},
        "$Test->{Name} StandardTemplateGet() - "
    );
}

# delete created standard template
for my $ID (@AddedTemplateIDs) {
    my $Delete = $StandardTemplateObject->StandardTemplateDelete(
        ID => $ID,
    );
    ok(
        $Delete,
        "StandardTemplateDelete() -  $ID ",
    );
}

done_testing();
