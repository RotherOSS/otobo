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
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# create template generator after the dynamic field are created as it gathers all DF in the
# constructor
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

my $TestUserLogin = $Helper->TestUserCreate(
    Language => 'en',
);

my %TestUser = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# add SystemAddress
my $SystemAddressEmail    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname = "OTOBO-Team";

my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,      # 'Name' indicates the address, e.g. q{123@example.com}
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 1,
    ValidID  => 1,
    UserID   => 1,
);
my %SystemAddressData = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

my $QueueRand = $Helper->GetRandomID();
my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name                => $QueueRand,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => $SystemAddressID,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

my @Tests = (
    {
        Line                  => __LINE__,
        Name                  => 'Simple replace',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'Test',
        Result                => {
            SystemAddressName          => qq|Test <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via Test" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },

    },
    {
        Line                  => __LINE__,
        Name                  => 'system address real name with four words',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'four words real name',
        Result                => {
            SystemAddressName          => qq|"four words real name" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via four words real name" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },

    },
    {
        # white space is not collapsed within the phrase
        Line                  => __LINE__,
        Name                  => 'system address real name with commas and extra spaces comma',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => ' real, name ,  with,commas',
        Result                => {
            SystemAddressName          => qq|" real, name ,  with,commas" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via  real, name ,  with,commas" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'Company with dot, requires escaping',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'company.com',
        Result                => {
            SystemAddressName          => qq|"company.com" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via company.com" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'Username with opening and closing parenthesis, requires escaping',
        AgentFirstname        => 'Jack (the)',
        AgentLastname         => 'Ripper',
        SystemAddressRealname => 'Test',
        Result                => {
            SystemAddressName          => qq|Test <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"Jack (the) Ripper via Test" <$SystemAddressEmail>|,
            AgentName                  => qq|"Jack (the) Ripper" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'Username with closing and opening parenthesis, requires escaping',
        AgentFirstname        => 'Jack )the(',
        AgentLastname         => 'Ripper',
        SystemAddressRealname => 'Test',
        Result                => {
            SystemAddressName          => qq|Test <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"Jack )the( Ripper via Test" <$SystemAddressEmail>|,
            AgentName                  => qq|"Jack )the( Ripper" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'Username with opening parenthesis, requires escaping',
        AgentFirstname        => 'Jack (the(',
        AgentLastname         => 'Ripper',
        SystemAddressRealname => 'Test',
        Result                => {
            SystemAddressName          => qq|Test <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"Jack (the( Ripper via Test" <$SystemAddressEmail>|,
            AgentName                  => qq|"Jack (the( Ripper" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'Username with closing parenthesis, requires escaping',
        AgentFirstname        => 'Jack )the)',
        AgentLastname         => 'Ripper',
        SystemAddressRealname => 'Test',
        Result                => {
            SystemAddressName          => qq|Test <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"Jack )the) Ripper via Test" <$SystemAddressEmail>|,
            AgentName                  => qq|"Jack )the) Ripper" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'System address real name with square brackets, requires escaping',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'Foo[Bar]',
        Result                => {
            SystemAddressName          => qq|"Foo[Bar]" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via Foo[Bar]" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'System address real name with a colon, requires escaping',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'Foo:Bar',
        Result                => {
            SystemAddressName          => qq|"Foo:Bar" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via Foo:Bar" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'system address real name with unescaped double quotes',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'Foo"Bar"',
        Result                => {
            SystemAddressName          => qq|"Foo\\"Bar\\"" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via Foo\\"Bar\\"" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        # This looks broken
        Line                  => __LINE__,
        Name                  => 'system address real name with comma and unescaped double quotes',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'F,oo"Bar"',
        Result                => {
            SystemAddressName          => qq|"F,oo\\"Bar\\"" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via F,oo\\"Bar\\"" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'system address real name with escaped double quotes',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'Foo\\"Bar\\"',
        Result                => {
            SystemAddressName          => qq|"Foo\\\\\\"Bar\\\\\\"" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via Foo\\\\\\"Bar\\\\\\"" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'system address real name with comma and escaped double quotes',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'F,oo\\"Bar\\"',
        Result                => {
            SystemAddressName          => qq|"F,oo\\\\\\"Bar\\\\\\"" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via F,oo\\\\\\"Bar\\\\\\"" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
    {
        Line                  => __LINE__,
        Name                  => 'system address real name with emoji',
        AgentFirstname        => 'John',
        AgentLastname         => 'Doe',
        SystemAddressRealname => 'Chocolate Bar 🍫',
        Result                => {
            SystemAddressName          => qq|"Chocolate Bar 🍫" <$SystemAddressEmail>|,
            AgentNameSystemAddressName => qq|"John Doe via Chocolate Bar 🍫" <$SystemAddressEmail>|,
            AgentName                  => qq|"John Doe" <$SystemAddressEmail>|,
        },
    },
);

for my $Test (@Tests) {
    subtest "$Test->{Name} (line $Test->{Line})" => sub {

        $SystemAddressObject->SystemAddressUpdate(
            %SystemAddressData,
            Realname => $Test->{SystemAddressRealname},
            UserID   => 1,
        );
        $UserObject->UserUpdate(
            %TestUser,
            UserFirstname => $Test->{AgentFirstname},
            UserLastname  => $Test->{AgentLastname},
            ChangeUserID  => 1,
        );

        for my $DefineEmailFrom (qw(SystemAddressName AgentNameSystemAddressName AgentName)) {

            $ConfigObject->Set(
                Key   => 'Ticket::DefineEmailFrom',
                Value => $DefineEmailFrom,
            );

            my $Result = $TemplateGeneratorObject->Sender(
                QueueID => $QueueID,
                UserID  => $TestUser{UserID}
            );

            is(
                $Result,
                $Test->{Result}->{$DefineEmailFrom},
                "DefineEmailFrom: $DefineEmailFrom",
            );
        }
    };
}

done_testing;
