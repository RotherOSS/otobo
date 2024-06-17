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

=for comment

    This test logs into agent and customer interface, and then calls up all registered
    frontend modules to check for any internal server errors.

=cut

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use LWP::UserAgent;

use Kernel::System::UnitTest::Helper;

my $Debug        = 0;
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify     => 1,
        DisableAsyncCalls => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable cloud service calls to avoid test failures due to connection problems etc.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CloudServices::Disabled',
    Value => 1,
);

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
);
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

my $BaseURL = $ConfigObject->Get('HttpType') . '://';

$BaseURL .= $Helper->GetTestHTTPHostname() . '/';
$BaseURL .= $ConfigObject->Get('ScriptAlias');

my $AgentBaseURL    = $BaseURL . 'index.pl?';
my $CustomerBaseURL = $BaseURL . 'customer.pl?';
my $PublicBaseURL   = $BaseURL . 'public.pl?';

my $UserAgent = LWP::UserAgent->new(
    Timeout => 60,
);
$UserAgent->cookie_jar( {} );    # keep cookies

my $Response = $UserAgent->get(
    $AgentBaseURL . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
);

my $BailOut = 0;
if ( !$Response->is_success() ) {
    $Self->True(
        0,
        "Could not login to agent interface, aborting! URL: "
            . $AgentBaseURL
            . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
    );
    $BailOut = 1;
}

if ( !$BailOut ) {

    $Response = $UserAgent->get(
        $CustomerBaseURL . "Action=Login;User=$TestCustomerUserLogin;Password=$TestCustomerUserLogin;"
    );

    if ( !$Response->is_success() ) {
        $Self->True(
            0,
            "Could not login to customer interface, aborting! URL: "
                . $CustomerBaseURL
                . "Action=Login;User=$TestCustomerUserLogin;Password=$TestCustomerUserLogin;"
        );
        $BailOut = 1;
    }
}

my ( $AgentSessionValid, $CustomerSessionValid );

if ( !$BailOut ) {

    # Get session info from cookie
    $UserAgent->cookie_jar()->scan(
        sub {
            if ( $_[1] eq $ConfigObject->Get('SessionName') && $_[2] ) {
                $AgentSessionValid = 1;
            }
            if ( $_[1] eq $ConfigObject->Get('CustomerPanelSessionName') && $_[2] ) {
                $CustomerSessionValid = 1;
            }
        }
    );

    if ( !$AgentSessionValid ) {
        $Self->True( 0, "Could not login to agent interface, aborting" );
        $BailOut = 1;
    }
    if ( !$CustomerSessionValid ) {
        $Self->True( 0, "Could not login to customer interface, aborting" );
        $BailOut = 1;
    }
}

if ( !$BailOut ) {

    my %Frontends = (
        $AgentBaseURL    => $ConfigObject->Get('Frontend::Module'),
        $CustomerBaseURL => $ConfigObject->Get('CustomerFrontend::Module'),
        $PublicBaseURL   => $ConfigObject->Get('PublicFrontend::Module'),
    );

    for my $BaseURL ( sort keys %Frontends ) {

        FRONTEND:
        for my $Frontend ( sort keys %{ $Frontends{$BaseURL} } ) {

            next FRONTEND if $Frontend =~ m/Login|Logout/;

            #next FRONTEND if $Frontend !~ m/AgentAppointmentEdit/;

            my $URL = $BaseURL . "Action=$Frontend";

            my $Status;
            TRY:
            for my $Try ( 1 .. 2 ) {

                $Response = $UserAgent->get($URL);

                $Status = scalar $Response->code();
                my $StatusGroup = substr $Status, 0, 1;

                last TRY if $StatusGroup ne 5;
            }

            $Self->Is(
                $Status,
                200,
                "Module $Frontend status code ($URL)",
            );

            $Self->True(
                scalar $Response->header('Content-type'),
                "Module $Frontend content type ($URL)",
            );

            $Self->False(
                scalar $Response->header('X-OTOBO-Login'),
                "Module $Frontend is no OTOBO login screen ($URL)",
            );

            # check response contents
            my $ContentType = $Response->header('Content-type') // '';
            $Self->Note( Note => "Response:\n" . $Response->as_string() ) if $Debug;
            if ( $ContentType =~ m/html/ ) {
                $Self->True(
                    scalar $Response->content() =~ m{<body|<div|<script}xms,
                    "Module $Frontend returned HTML ($URL)",
                );

                # Inspect all full HTML responses for robots information.
                if ( $Response->content() =~ m{<head>} ) {

                    # Check robots information.
                    if ( $BaseURL !~ m{public\.pl} ) {
                        $Self->True(
                            index( $Response->content(), '<meta name="robots" content="noindex,nofollow" />' ) > 0,
                            "Module $Frontend sends 'noindex' robots information.",
                        );
                    }
                    else {

                        next FRONTEND if $Frontend =~ m/PublicDownloads|PublicURLRedirect/;

                        $Self->True(
                            index( $Response->content(), '<meta name="robots" content="index,follow" />' ) > 0,
                            "Module $Frontend sends 'index' robots information.",
                        );
                    }
                }
            }
            elsif ( $ContentType =~ m/json/ ) {

                my $Data = $JSONObject->Decode(
                    Data => $Response->content()
                );

                $Self->True(
                    scalar $Data,
                    "Module $Frontend returned valid JSON data ($URL)",
                );
            }
            elsif ( $ContentType =~ m/plain/ ) {

                $Self->True(
                    1,
                    "everything can be plain text",
                );
            }
            else {
                # emit a test result also when a status of 500 is returned
                # This makes results more comparable.
                $Self->True(
                    0,
                    "Unexpected content type '$ContentType'",
                );
            }
        }
    }

    # cleanup cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
}

$Self->DoneTesting();
