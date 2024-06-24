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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet FixedTimeUnset);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $HelperObject          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CommandObject         = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Log::CommunicationLog');
my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');

# Set Database to an initial clean state.
$CommunicationDBObject->CommunicationDelete();

my @Communications = (
    {
        Transport => 'Email',
        Direction => 'Incoming',
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Successful',
        Date      => '2017-02-07',
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Failed',
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Failed',
        Date      => '2011-02-07',
    },
);

my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

for my $TestCommunication (@Communications) {

    if ( $TestCommunication->{Date} ) {
        my $TestDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $TestCommunication->{Date}
            }
        );
        FixedTimeSet($TestDateTimeObject);
    }

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => $TestCommunication->{Transport},
            Direction => $TestCommunication->{Direction},
        }
    );

    if ( $TestCommunication->{Status} ) {
        $CommunicationLogObject->CommunicationStop( Status => $TestCommunication->{Status} );
    }

    $TestCommunication->{ID} = $CommunicationLogObject->CommunicationIDGet();

    FixedTimeUnset();
}

my $RunTest = sub {
    my $Test = shift;
    my ( $ExitCode, $Result );

    if ( $Test->{Output} && $Test->{Output} eq 'STDOUT' ) {
        local *STDOUT;                                 ## no critic qw(Variables::RequireInitializationForLocalVars)
        open STDOUT, '>:encoding(UTF-8)', \$Result;    ## no critic qw(OTOBO::ProhibitOpen)
        $ExitCode = $CommandObject->Execute( @{ $Test->{Params} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }
    else {
        local *STDERR;                                 ## no critic qw(Variables::RequireInitializationForLocalVars)
        open STDERR, '>:encoding(UTF-8)', \$Result;    ## no critic qw(OTOBO::ProhibitOpen)
        $ExitCode = $CommandObject->Execute( @{ $Test->{Params} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    $Self->Is(
        $ExitCode,
        $Test->{ExpectedExitCode},
        "$Test->{Name} Exit Code: $Test->{ExpectedExitCode}",
    );

    if ( $Test->{ExpectedResult} ) {
        if ( 'ARRAY' eq ref $Test->{ExpectedResult} ) {
            for my $ExpectedResult ( @{ $Test->{ExpectedResult} } ) {
                $Self->True(
                    index( $Result, $ExpectedResult ) > -1,
                    "$Test->{Name} expected result: '$ExpectedResult'",
                );
            }
        }
        else {
            $Self->True(
                index( $Result, $Test->{ExpectedResult} ) > -1,
                "$Test->{Name} expected result: '$Test->{ExpectedResult}'",
            );
        }
    }

    if ( $Test->{ExpectedDeleted} ) {
        my $ExpectedDeletedCommunications = $Test->{ExpectedDeleted};
        for my $CommunicationID ( @{$ExpectedDeletedCommunications} ) {
            my $CommunicationData = $CommunicationDBObject->CommunicationGet(
                CommunicationID => $CommunicationID,
            );

            $Self->False(
                scalar( %{$CommunicationData} ),
                "$Test->{Name} communication ${ CommunicationID } deleted!",
            );
        }
    }
};

my @Tests = (
    {
        Name             => 'No arguments given',
        ExpectedResult   => 'Either --purge, --delete-by-id',
        ExpectedExitCode => 1,
        Output           => 'STDERR',
        Params           => undef,
    },
    {
        Name             => 'Invalid combination 1',
        ExpectedResult   => 'Only one type of action allowed per execution',
        ExpectedExitCode => 1,
        Params           => [ '--delete-by-id', '123', '--delete-by-date', '2017-01-01' ],
    },
    {
        Name             => 'Can delete by id processing communication with force.',
        ExpectedDeleted  => [ $Communications[0]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => [ '--delete-by-id', $Communications[0]->{ID}, '--force-delete' ],
    },
    {
        Name             => 'Can delete by date finished communication without force.',
        ExpectedDeleted  => [ $Communications[1]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => [ '--delete-by-date', $Communications[1]->{Date} ],
    },
    {
        Name             => 'Purge.',
        ExpectedDeleted  => [ $Communications[3]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => ['--purge'],
    },
    {
        Name             => 'Delete NOT purged communication.',
        ExpectedDeleted  => [ $Communications[2]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => [ '--delete-by-id', $Communications[2]->{ID}, '--force-delete' ],
    },
);

for my $Test (@Tests) {
    $RunTest->($Test);
}

# test accurate purge hours

my $SuccessHours = $ConfigObject->Get('CommunicationLog::PurgeAfterHours::SuccessfulCommunications');
my $AllHours     = $ConfigObject->Get('CommunicationLog::PurgeAfterHours::AllCommunications');

my @CommunicationsToTestPurge = (
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Successful',
        Date      => {
            Hours => ( $SuccessHours + 1 ),
        },
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Successful',
        Date      => {
            Hours => ( $SuccessHours - 1 ),
        },
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Date      => {
            Hours => ( $AllHours + 1 ),
        },
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Date      => {
            Hours => ( $AllHours - 1 ),
        },
    },
);

for my $CommunicationToTestPurge (@CommunicationsToTestPurge) {
    my $TestDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $TestDateTimeObject->Subtract( Hours => $CommunicationToTestPurge->{Date}->{Hours} );

    FixedTimeSet($TestDateTimeObject);

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => $CommunicationToTestPurge->{Transport},
            Direction => $CommunicationToTestPurge->{Direction},
        },
    );

    if ( $CommunicationToTestPurge->{Status} ) {
        $CommunicationLogObject->CommunicationStop( Status => $CommunicationToTestPurge->{Status} );
    }
    $CommunicationToTestPurge->{ID} = $CommunicationLogObject->CommunicationIDGet();
    FixedTimeUnset();

}

$RunTest->(
    {
        Name            => 'Purge.',
        ExpectedDeleted => [
            $CommunicationsToTestPurge[0]->{ID},
            $CommunicationsToTestPurge[2]->{ID},
        ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => ['--purge'],
    }
);

my $CommunicationsList = $CommunicationDBObject->CommunicationList();

for my $CommunicationListItem (@$CommunicationsList) {
    my ($Found) = grep {
        $_->{ID} == $CommunicationListItem->{CommunicationID}
        }
        ( $CommunicationsToTestPurge[1], $CommunicationsToTestPurge[3] );

    $Self->True(
        $Found,
        "Not to be deleted $CommunicationListItem->{CommunicationID} found.",
    );

}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
