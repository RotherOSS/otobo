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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Plack::Util           ();
use Plack::Test           ();
use HTTP::Request::Common qw(GET POST);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# RestoreDatabase => 1 can't be used here as Plack::Test seems to spawn a new process,
# with a new database connection.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        UseTmpArticleDir => 1,
    },
);
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get a random number
my $RandomID = $Helper->GetRandomNumber;

# create a new user for current test, password is the same as the login
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin,
);

my %SkipFields = (
    Age                       => 1,
    AgeTimeUnix               => 1,
    UntilTime                 => 1,
    SolutionTime              => 1,
    SolutionTimeWorkingTime   => 1,
    EscalationTime            => 1,
    EscalationDestinationIn   => 1,
    EscalationTimeWorkingTime => 1,
    UpdateTime                => 1,
    UpdateTimeWorkingTime     => 1,
    Created                   => 1,
    Changed                   => 1,
    UnlockTimeout             => 1,
);

# create ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create ticket
my @TicketIDs;
my $TicketID = $TicketObject->TicketCreate(
    Title    => 'Ticket for testing with MockHTTP',
    Queue    => 'Raw',
    Lock     => 'unlock',
    Priority => '3 normal',
    State    => 'new',
    OwnerID  => $UserID,
    UserID   => $UserID,
);
ok( $TicketID, "TicketCreate() successful for ID $TicketID" );
push @TicketIDs, $TicketID;

# get the Ticket entry
# without dynamic fields
my %TicketEntryOne = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 0,
    UserID        => $UserID,
);
$TicketEntryOne{TimeUnit} = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID );

ok(
    scalar keys %TicketEntryOne,
    "TicketGet() successful for Local TicketGet One ID $TicketID",
);

for my $Key ( sort keys %TicketEntryOne ) {
    if ( !defined $TicketEntryOne{$Key} ) {
        $TicketEntryOne{$Key} = '';
    }
    if ( $SkipFields{$Key} ) {
        delete $TicketEntryOne{$Key};
    }
}

# set web-service name
my $WebserviceName = '-Test-' . $RandomID;

# The WebServiceID is not needed here
my %WebserviceConfig = (

    Description => 'Test with MockHTTP',
    Debugger    => {
        DebugThreshold => 'debug',
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::REST',
            Config => {
                MaxLength             => 10000000,
                RouteOperationMapping => {
                    SessionCreate => {
                        RequestMethod => ['POST'],
                        Route         => '/Session',
                    },
                    TicketGet => {
                        RequestMethod => ['GET'],
                        Route         => '/Ticket/:TicketID',
                    }
                },
            },
        },
        Operation => {
            TicketGet => {
                Type => 'Ticket::TicketGet',
            },
            SessionCreate => {
                Type => 'Session::SessionCreate',
            },
        },
    },
);

# create web-service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
isa_ok(
    $WebserviceObject,
    ['Kernel::System::GenericInterface::Webservice'],
    "Create web service object",
);

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name    => $WebserviceName,
    Config  => \%WebserviceConfig,
    ValidID => 1,
    UserID  => $UserID,
);
ok( $WebserviceID, "Added Web Service" );

# load the PSGI app 'otobo.psgi' and intialize
my $PlackTest;
{
    my $Home = $ConfigObject->Get('Home');
    ok( -d $Home, 'OTOBO home dir found' );

    my $PSGIFile = "$Home/bin/psgi-bin/otobo.psgi";
    ok( -f $PSGIFile, 'otobo.psgi found' );
    my $App = Plack::Util::load_psgi($PSGIFile);
    ref_ok( $App, 'CODE', 'PSGI app was loaded' );

    # stick with the default MockHTTP object
    $PlackTest = Plack::Test->create($App);
    isa_ok( $PlackTest, ['Plack::Test::MockHTTP'], 'got the Plack::Test::MockHTTP object' );
}

my $WebserviceURL;
{
    my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
    $WebserviceURL = join '/', ( $ScriptAlias =~ s!/+\z!!r ), 'nph-genericinterface.pl', 'WebserviceID', $WebserviceID;
}
my $RequestURI = URI->new("$WebserviceURL/Session");

my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
my $Content    = $JSONObject->Encode(
    Data => {
        UserLogin => $UserLogin,
        Password  => $UserLogin
    }
);
my $Response = $PlackTest->request(
    POST $RequestURI, Content => $Content
);

# check result
isa_ok( $Response, ['HTTP::Response'], 'got a HTTP::Response' );
ok( $Response->is_success, 'request was successful' );

# e.g. 'wewB0FscgcXFLYDmoSgmAEcEP8n5wMAT'
my $ResponseData = $JSONObject->Decode( Data => $Response->content );
ref_ok( $ResponseData, 'HASH', 'got a hash from the webservice' );
my $NewSessionID = $ResponseData->{SessionID};
note "got the new session ID: $NewSessionID";
ok( $NewSessionID, 'received a new session id' );
like( $NewSessionID, qr{^\w{32}$}, 'new session id looks sane, is 32 characters long' );

my @Tests = (
    {
        Name           => 'Empty Request',
        SuccessRequest => 1,
        ExtraPathInfo  => '',
        Expected       => {
            Code    => 500,
            Content => qr{\QHTTP::REST Error while determine Operation for request URI\E},
        },
    },
    {
        Name           => 'Wrong TicketID',
        SuccessRequest => 1,
        ExtraPathInfo  => '/Ticket/NotTicketID',
        Expected       => {
            Code => 200,
            Data => {
                Error => {
                    ErrorMessage => "TicketGet: User does not have access to the ticket!",
                    ErrorCode    => "TicketGet.AccessDenied"
                }
            },
        },
    },
    {
        Name           => 'Test Ticket 1',
        SuccessRequest => '1',
        ExtraPathInfo  => "/Ticket/$TicketID",
        Expected       => {
            Code => 200,
            Data => {
                Ticket => [ \%TicketEntryOne ],
            },
        },
    },
);

for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        my $Auth = $Test->{Auth} // { SessionID => $NewSessionID };

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $RequestURI  = URI->new( $WebserviceURL . $Test->{ExtraPathInfo} );
        $RequestURI->query_form(
            $Auth->%*,
        );
        my $Response = $PlackTest->request( GET $RequestURI->as_string );

        # check result
        isa_ok( $Response, ['HTTP::Response'], "got a HTTP::Response" );
        is( $Response->code, $Test->{Expected}->{Code}, "got HTTP code $Test->{Expected}->{Code}" );

        if ( $Test->{Expected}->{Content} ) {
            like( $Response->content(), $Test->{Expected}->{Content}, 'got expected content' );
        }

        if ( $Test->{Expected}->{Data} ) {
            my $ResponseData = $JSONObject->Decode( Data => $Response->content );
            ref_ok( $ResponseData, ref $Test->{Expected}->{Data}, 'got expected reference type' );
            if ( ref $ResponseData eq 'HASH' ) {
                if ( ref $ResponseData->{Ticket} eq 'ARRAY' ) {
                    for my $Item ( $ResponseData->{Ticket}->@* ) {
                        for my $Key ( sort keys %{$Item} ) {
                            $Item->{$Key} //= '';
                            if ( $SkipFields{$Key} ) {
                                delete $Item->{$Key};
                            }
                        }
                    }
                }
            }
            is( $ResponseData, $Test->{Expected}->{Data}, 'got expected payload' );
        }
    };
}

# cleanup

# delete web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $UserID,
);
ok( $WebserviceDelete, "Deleted Web Service $WebserviceID" );

# delete tickets
for my $TicketID (@TicketIDs) {
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => $UserID,
    );
    ok( $TicketDelete, "TicketDelete() successful for Ticket ID $TicketID" );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

done_testing;
