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

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        # RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Basic tests
my @Tests = (
    {
        Description => 'Missing Array',
        Config      => {
            'Tree' => {
                'Core' => {
                    'Subitems' => {
                        'Core::CustomerUser' => {
                            'Subitems' => {},
                        },
                    },
                },
            },
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Missing Tree',
        Config      => {
            'Array' => [
                'Core',
                'Core::CustomerUser',
            ],
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Pass #1',
        Config      => {
            'Array' => [
                'Core',
                'Core::CustomerUser',
            ],
            'Tree' => {
                'Core' => {
                    'Subitems' => {
                        'Core::CustomerUser' => {
                            'Subitems' => {},
                        },
                    },
                },
            },
        },
        ExpectedResult => {
            'Core' => {
                'Subitems' => {
                    'Core::CustomerUser' => {
                        'Subitems' => {},
                    },
                },
            },
        },
    },
    {
        Description => 'Pass #2',
        Config      => {
            'Array' => [
                'Core',
                'Core::CustomerUser',
                'Core::CustomerUser::CustomerUserßšđč',
            ],
            'Tree' => {
                'Core' => {
                    'Subitems' => {
                        'Core::CustomerUser' => {
                            'Subitems' => {},
                        },
                    },
                },
            },
        },
        ExpectedResult => {
            'Core' => {
                'Subitems' => {
                    'Core::CustomerUser' => {
                        'Subitems' => {
                            'Core::CustomerUser::CustomerUserßšđč' => {
                                'Subitems' => {},
                            },
                        },
                    },
                },
            },
        },
    },
    {
        Description => 'Pass #3',
        Config      => {
            'Array' => [
                'Core',
                'Core::CustomerUser',
                'Core::CustomerUser::CustomerUserßšđč',
            ],
            'Tree' => {},
        },
        ExpectedResult => {
            'Core' => {
                'Subitems' => {
                    'Core::CustomerUser' => {
                        'Subitems' => {
                            'Core::CustomerUser::CustomerUserßšđč' => {
                                'Subitems' => {},
                            },
                        },
                    },
                },
            },
        },
    },
    {
        Description => 'Pass #4',
        Config      => {
            'Array' => [],
            'Tree'  => {
                'Core' => {
                    'Subitems' => {
                        'Core::CustomerUser' => {
                            'Subitems' => {},
                        },
                    },
                },
            },
        },
        ExpectedResult => {
            'Core' => {
                'Subitems' => {
                    'Core::CustomerUser' => {
                        'Subitems' => {},
                    },
                },
            },
        },
    },
    {
        Description => 'Pass #5',
        Config      => {
            'Array' => [
                'Core',
                'Core::CustomerUser',
            ],
            'Tree' => {
                'Ticket' => {
                    'Subitems' => {
                        'Ticket::States' => {
                            'Subitems' => {},
                        },
                    },
                },
            },
        },
        ExpectedResult => {
            'Core' => {
                'Subitems' => {
                    'Core::CustomerUser' => {
                        'Subitems' => {},
                    },
                },
            },
            'Ticket' => {
                'Subitems' => {
                    'Ticket::States' => {
                        'Subitems' => {},
                    },
                },
            },
        },
    },
);

for my $Test (@Tests) {
    my %Result = $SysConfigObject->_NavigationTree( %{ $Test->{Config} } );

    if ( !$Test->{ExpectedResult} ) {
        $Self->True(
            !%Result,
            $Test->{Description} . ': _NavigationTree(): Result must be undef.',
        );
    }
    else {

        $Self->IsDeeply(
            \%Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': _NavigationTree(): Result must match expected one.',
        );
    }
}

$Self->DoneTesting();
