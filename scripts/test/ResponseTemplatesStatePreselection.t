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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

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
    $Self->True(
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
            ID                       => $AddedTemplateIDs[0],
            PreSelectedTicketStateID => 1,
            UserID                   => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Missing ID',
        Config => {
            ID                       => undef,
            PreSelectedTicketStateID => 1,
            UserID                   => 1,
        },
        Success => 0,
    },
    {
        Name   => 'First Template Ticket StateID 1',
        Config => {
            ID                       => $AddedTemplateIDs[0],
            PreSelectedTicketStateID => 1,
            UserID                   => 1,
        },
        Success         => 1,
        ExpectedResults => {
            ID                       => $AddedTemplateIDs[0],
            Name                     => $Templates[0]->{Name},
            PreSelectedTicketStateID => 1,
        },
    },
    {
        Name   => 'First Template Ticket StateID 2',
        Config => {
            ID                       => $AddedTemplateIDs[0],
            PreSelectedTicketStateID => 2,
            UserID                   => 1,
        },
        Success         => 1,
        ExpectedResults => {
            ID                       => $AddedTemplateIDs[0],
            Name                     => $Templates[0]->{Name},
            PreSelectedTicketStateID => 2,
        },
    },
    {
        Name   => 'First Template Ticket StateID unset',
        Config => {
            ID     => $AddedTemplateIDs[0],
            UserID => 1,
        },
        Success         => 1,
        ExpectedResults => {
            ID                       => $AddedTemplateIDs[0],
            Name                     => $Templates[0]->{Name},
            PreSelectedTicketStateID => undef,
        },
    },
    {
        Name   => 'Second Template Ticket StateID 1',
        Config => {
            ID                       => $AddedTemplateIDs[1],
            PreSelectedTicketStateID => 1,
            UserID                   => 1,
        },
        Success         => 1,
        ExpectedResults => {
            ID                       => $AddedTemplateIDs[1],
            Name                     => $Templates[1]->{Name},
            PreSelectedTicketStateID => 1,
        },
    },
);

my $ResponseTicketStatePreSelectionObject = $Kernel::OM->Get('Kernel::System::ResponseTemplatesStatePreselection');

TEST:
for my $Test (@Tests) {

    my $Success = $ResponseTicketStatePreSelectionObject->StandardTemplateUpdate( %{ $Test->{Config} } );

    # easy compare
    if ( !$Success ) {
        $Success = 0;
    }

    $Self->Is(
        $Success,
        $Test->{Success},
        "$Test->{Name} StandardTemplateUpdate() - ",
    );

    next TEST if !$Test->{Success};

    my %Data = $ResponseTicketStatePreSelectionObject->StandardTemplateGet(
        ID => $Test->{Config}->{ID},
    );

    $Self->IsDeeply(
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
    $Self->True(
        $Delete,
        "StandardTemplateDelete() -  $ID ",
    );
}

done_testing();
