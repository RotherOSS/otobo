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
use IO::File;
use File::stat;

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM
use Kernel::System::MailAccount::POP3;
use Kernel::System::MailAccount::IMAP;
use Kernel::System::PostMaster;

## no critic qw(OTOBO::RequireCamelCase Subroutines::ProhibitBuiltinHomonyms)

# The tests presented here try to ensure that the communication-log entries
#   keep the correct status after some predefined situations.
#   Some 'magic' techniques are used so we could fake an IMAP/POP3 client/server connection environment:
#       - localizing variables
#       - local overwriting of package methods
#       - definition of inline packages
#       - autoload handler ( when the called method doesn't exist )

# This hash represents the fake environment for the IMAP/POP3, think about %ENV,
#   it'll work more or less the same way.
my %FakeClientEnv = (
    'connect'         => 1,
    'emails'          => {},
    'fail_fetch'      => {},
    'fail_postmaster' => 0,
);

# This inline package is the base for the IMAP/POP3 fake clients
#   and as you can see it uses the %FakeClientEnv.
#   This package uses autoload to handle undefined methods, and when
#   that happen, it'll check if the FakeClientEnv has an attribute with the same
#   name and returns it, otherwise always returns True to ensure that the code
#   that will use this object continues as everything is ok.
package FakeClient {

    sub new {
        my $Class = shift;

        return bless {}, $Class;
    }

    sub AUTOLOAD {
        my $Self = shift;

        our $AUTOLOAD;
        my ($Method) = ( $AUTOLOAD =~ m/::([^:]+)$/i );

        return unless $Method;
        return if $Method eq 'DESTROY';
        return 1 unless exists $FakeClientEnv{$Method};
        return $FakeClientEnv{$Method};
    }

    sub get {
        my ( $Self, $Idx ) = @_;

        if ( $FakeClientEnv{'fail_fetch'}->{Messages}->{$Idx} ) {
            my $FailType = $FakeClientEnv{'fail_fetch'}->{Type} || '';
            die 'dummy exception' if $FailType eq 'exception';
            return;
        }

        my $Filename = $FakeClientEnv{'emails'}->{$Idx};

        my $FH    = IO::File->new( $Filename, 'r', );
        my @Lines = <$FH>;

        return wantarray ? @Lines : \@Lines;
    }

    sub delete {
        my ( $Self, $Idx ) = @_;

        delete $FakeClientEnv{'emails'}->{$Idx};

        return 1;
    }
}

# This class extends the 'FakeClient' class.
# We aren't using 'use parent' because the 'FakeClient' is a
# package defined in this test file, there's no pm file.
# Another possible solution would be "use parent -norequire, 'FakeClient'".
package FakeIMAPClient {    ## no critic qw(Modules::ProhibitMultiplePackages)
    our @ISA = ('FakeClient');    ## no critic qw(ClassHierarchies::ProhibitExplicitISA);

    sub select {
        my $Self = shift;

        return scalar keys $FakeClientEnv{'emails'}->%*;
    }
}

# Overwrite the OTOBO MailAccount::IMAP connect method to use our fake imap client,
# but make this change local to the unit test scope.
# It also makes use of %FakeClientEnv.
my $MockIMAP = mock 'Kernel::System::MailAccount::IMAP' => (
    set => [
        'Connect' => sub {

            if ( !$FakeClientEnv{'connect'} ) {
                return (
                    Successful => 0,
                    Message    => "can't connect",
                );
            }

            return (
                Successful => 1,
                IMAPObject => FakeIMAPClient->new(),
                Type       => 'IMAP',
            );
        },
    ],
);

# This class extends the 'FakeClient' class.
# We aren't using 'use parent' because the 'FakeClient' is a
# package defined in this test file, there's no pm file.
# Another possible solution would be "use parent -norequire, 'FakeClient'".
package FakePOPClient {    ## no critic qw(Modules::ProhibitMultiplePackages)
    our @ISA = ('FakeClient');    ## no critic qw(ClassHierarchies::ProhibitExplicitISA);

    sub list {
        my $Self = shift;

        return {
            map { $_ => 1 } keys $FakeClientEnv{'emails'}->%*
        };
    }
}

# Overwrite the OTOBO MailAccount::POP3 connect method to use our fake pop3 client,
# but make this change local to the unit test scope.
# It also makes use of %FakeClientEnv.
my $MockPOP3 = mock 'Kernel::System::MailAccount::POP3' => (

    set => [
        'Connect' => sub {

            if ( !$FakeClientEnv{'connect'} ) {
                return (
                    Successful => 0,
                    Message    => "can't connect",
                );
            }

            return (
                Successful => 1,
                PopObject  => FakePOPClient->new(),
                Type       => 'POP3',
                NOM        => scalar( keys %{ $FakeClientEnv{'emails'} } ),
            );
        },
    ]
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$HelperObject->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$HelperObject->ConfigSettingChange(
    Key   => 'PostMasterReconnectMessage',
    Value => 100,
);

sub GetMailAcountLastCommunicationLog {
    my %Param = @_;

    my $MailAccount = $Param{MailAccount};

    my $CommunicationLogDBObj = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog::DB',
    );
    my @MailAccountCommunicationLog = @{
        $CommunicationLogDBObj->CommunicationList(
            AccountType => $MailAccount->{Type},
            AccountID   => $MailAccount->{ID},
            )
            || []
    };

    @MailAccountCommunicationLog = sort { $b->{CommunicationID} <=> $a->{CommunicationID} } @MailAccountCommunicationLog;

    # Get all communication related objects.
    my $Objects = $CommunicationLogDBObj->ObjectLogList(
        CommunicationID => $MailAccountCommunicationLog[0]->{CommunicationID},
    );

    my $Connection = undef;
    my @Messages   = ();
    OBJECT:
    for my $Object ( @{$Objects} ) {

        if ( $Object->{ObjectLogType} eq 'Connection' ) {
            $Connection = $Object;

            next OBJECT;
        }

        push @Messages, $Object;
    }

    my %FailedMsgs = %{ $FakeClientEnv{'fail_fetch'}->{Messages} || {} };
    for my $Key ( sort keys %FailedMsgs ) {
        splice @Messages, $Key - 1, 0, undef;
    }

    return {
        Communication => $MailAccountCommunicationLog[0],
        Connection    => $Connection,
        Messages      => \@Messages,
    };

}

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Get postmaster sample emails in a hash.
# This hash will be used for the fake environments and for diagnostics.
my %EmailIdx2Filename;
{
    my @BoxFilenames = glob "$Home/scripts/test/sample/PostMaster/*.box";

    my $EmailIdx = 0;
    for my $Filename (@BoxFilenames) {
        $EmailIdx++;
        $EmailIdx2Filename{$EmailIdx} = $Filename;
    }
}

# Type of emails accounts to test.
my @MailAccounts = (
    {
        Type => 'IMAP',
    },

    {
        Type => 'POP3',
    },
);

# Mail account base data.
my %MailAccountBaseData = (
    Login         => 'mail',
    Password      => 'SomePassword',
    Host          => 'mail.example.com',
    ValidID       => 1,
    Trusted       => 0,
    DispatchingBy => 'Queue',
    QueueID       => 1,
    UserID        => 1,
);

# Tests definition.
my @Tests = (

    {
        Name          => "Couldn't connect to server",
        FakeClientEnv => {
            'connect' => 0,
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Failed',
        },
    },

    {
        Name          => 'Some messages failed fetching',
        FakeClientEnv => {
            'connect'    => 1,
            'fail_fetch' => {
                Messages => {
                    10 => 1,
                    20 => 1,
                },
            },
            'emails' => {%EmailIdx2Filename},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Failed',
            Message       => {
                Default => 'Successful',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Some messages failed fetching with exception',
        FakeClientEnv => {
            'connect'    => 1,
            'fail_fetch' => {
                Type     => 'exception',
                Messages => {
                    5  => 1,
                    17 => 1,
                },
            },
            'emails' => {%EmailIdx2Filename},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Failed',
            Message       => {
                Default => 'Successful',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Messages failed processing',
        FakeClientEnv => {
            'connect'         => 1,
            'fail_postmaster' => 'error',
            'emails'          => {%EmailIdx2Filename},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Successful',
            Message       => {
                Default => 'Failed',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Messages process throw exception',
        FakeClientEnv => {
            'connect'         => 1,
            'fail_postmaster' => 'exception',
            'emails'          => {%EmailIdx2Filename},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Successful',
            Message       => {
                Default => 'Failed',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Everything successfull',
        FakeClientEnv => {
            'connect' => 1,
            'emails'  => {%EmailIdx2Filename},
        },
        CommunicationLogStatus => {
            Communication => 'Successful',
            Connection    => 'Successful',
            Message       => {
                Default => 'Successful',    # expected status for all messages
            },
        },
    },
);

my $TestsStartedAt = $Kernel::OM->Create('Kernel::System::DateTime');
my $MaxChilds      = 1;
my $Childs         = 0;
for my $MailAccount (@MailAccounts) {

    # Set full mail-account data and create it in the database.
    for my $Key ( sort keys %MailAccountBaseData ) {
        $MailAccount->{$Key} = $MailAccountBaseData{$Key};
    }

    $MailAccount->{ID} = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountAdd(
        %{$MailAccount},
    );

    # Run the tests.
    for my $Test (@Tests) {

        subtest "$MailAccount->{Type}: $Test->{Name}" => sub {

            # Set fake email type environment.
            my %TestFakeClientEnv = (
                %FakeClientEnv,
                %{ $Test->{FakeClientEnv} || {} },
            );

            # Because the test is run per email account type, and the email stack is changed during
            #   the run, we want to use a copy and not the original.
            my %TestEmails = %{ $TestFakeClientEnv{'emails'} };

            # Change the client environment according to the test,
            #   these changes are local to the current scope (the for).
            local $FakeClientEnv{'connect'}         = $TestFakeClientEnv{'connect'};
            local $FakeClientEnv{'emails'}          = \%TestEmails;
            local $FakeClientEnv{'fail_fetch'}      = $TestFakeClientEnv{'fail_fetch'};
            local $FakeClientEnv{'fail_postmaster'} = $TestFakeClientEnv{'fail_postmaster'};

            no strict 'refs';    ## no critic (TestingAndDebugging::ProhibitNoStrict)

            # Postfix if is required in next line to ensure right scope of function override.
            local *{'Kernel::System::PostMaster::Run'} = sub {
                if ( $TestFakeClientEnv{'fail_postmaster'} eq 'exception' ) {
                    die "dummy exception";
                }

                return;
            }
                if $TestFakeClientEnv{'fail_postmaster'};

            use strict 'refs';

            # Run mail-account-fetch.
            my $Result = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountFetch( %{$MailAccount} );

            # Get last communication log for the mail-account.
            my $CommunicationLogData = GetMailAcountLastCommunicationLog(
                MailAccount => $MailAccount,
            );

            my %CommunicationLogStatus = $Test->{CommunicationLogStatus}->%*;

            is(
                $CommunicationLogData->{Communication}->{Status},
                $CommunicationLogStatus{Communication},
                sprintf( 'communication %s', $CommunicationLogStatus{Communication} ),
            );
            is(
                $CommunicationLogData->{Connection}->{ObjectLogStatus},
                $CommunicationLogStatus{Connection},
                sprintf( 'connection %s', $CommunicationLogStatus{Connection} ),
            );

            return unless $CommunicationLogStatus{Message};

            # Check the messages status.

            my $MessageIdx = 0;
            MESSAGE:
            for my $Message ( $CommunicationLogData->{Messages}->@* ) {
                $MessageIdx++;

                if ( !$Message ) {
                    pass("no message for message-$MessageIdx but that is accepted");

                    next MESSAGE;
                }

                my $ExpectedStatus = $CommunicationLogStatus{Message}->{$MessageIdx} || $CommunicationLogStatus{Message}->{Default};
                is(
                    $Message->{ObjectLogStatus},
                    $ExpectedStatus,
                    sprintf( q{message-%s %s}, $MessageIdx, $ExpectedStatus ),
                );
            }
        };
    }
}

my $TestsStoppedAt = $Kernel::OM->Create('Kernel::System::DateTime');

# Delete spool files generated during the tests run.
my @SpoolFilesFailedUnlink;
my @SpoolFiles = glob "$Home/var/spool/problem-email-*";
for my $SpoolFile (@SpoolFiles) {
    my $FileStat       = stat $SpoolFile;
    my $FileModifiedAt = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => $FileStat->mtime(),
        },
    );

    if ( $FileModifiedAt >= $TestsStartedAt && $FileModifiedAt <= $TestsStoppedAt ) {
        if ( !( unlink $SpoolFile ) ) {
            push @SpoolFilesFailedUnlink, $SpoolFile;
        }
    }
}

if (@SpoolFilesFailedUnlink) {
    fail( 'Failed to clean some spool files: ' . ( join "\n", @SpoolFilesFailedUnlink ) );
}
else {
    pass('Cleaned spool files');
}

done_testing();
