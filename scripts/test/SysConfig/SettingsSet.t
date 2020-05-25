# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        RestoreDatabase => 1,
    },
);

my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Ticket::SubjectFwd
# Ticket::SubjectRe

my @Tests = (
    {
        Title  => 'SettingsSet() without UserID',
        Params => {
            Settings => [
                {
                    Name           => 'Ticket::SubjectFwd',
                    EffectiveValue => 'FORWARD###',
                },
                {
                    Name           => 'Ticket::SubjectRe',
                    EffectiveValue => 'RE###',
                },
            ],
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'SettingsSet() without Settings',
        Params => {
            UserID => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'SettingsSet() pass',
        Params => {
            UserID   => 1,
            Settings => [
                {
                    Name           => 'Ticket::SubjectFwd',
                    EffectiveValue => 'FORWARD###',
                },
                {
                    Name           => 'Ticket::SubjectRe',
                    EffectiveValue => 'RE###',
                },
            ],
        },
        ExpectedResult => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $SysConfigObject->SettingsSet(
        %{ $Test->{Params} },
    );

    $Self->Is(
        $Success,
        $Test->{ExpectedResult},
        $Test->{Title},
    );
}

# Check values
my %SettingForward = $SysConfigObject->SettingGet(
    Name     => 'Ticket::SubjectFwd',
    Deployed => 1,
);

$Self->Is(
    $SettingForward{EffectiveValue},
    'FORWARD###',
    'Check deployed EffectiveValue for Ticket::SubjectFwd.',
);
my %SettingRe = $SysConfigObject->SettingGet(
    Name     => 'Ticket::SubjectRe',
    Deployed => 1,
);

$Self->Is(
    $SettingRe{EffectiveValue},
    'RE###',
    'Check deployed EffectiveValue for Ticket::SubjectRe.',
);

1;
