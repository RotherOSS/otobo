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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport::HTTP::SOAP;

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'error',
        TestMode       => 1,
    },
    CommunicationType => 'requester',
    WebserviceID      => 1,             # not used
);
my $SOAPObject = Kernel::GenericInterface::Transport::HTTP::SOAP->new(
    DebuggerObject  => $DebuggerObject,
    TransportConfig => {
        Config => {
            MaxLength            => 100000000,
            NameSpace            => 'http://otobo.io/TicketConnector/',
            RequestNameFreeText  => '',
            RequestNameScheme    => 'Plain',
            ResponseNameFreeText => '',
            ResponseNameScheme   => 'Response;'
        },
        Type => 'HTTP::SOAP',
    },
);

my @Tests = (
    {
        Name        => 'UTF-8 Complex Content Type',
        Value       => 'c™',
        ContentType => 'application/soap+xml;charset=UTF-8;action="urn:MyService/MyAction"',
    },
    {
        Name        => 'UTF-8 Simple Content Type',
        Value       => 'c™',
        ContentType => 'text/xml;charset=UTF-8',
    },
    {
        Name        => 'UTF-8 Complex Content Type (Just ASCII)',
        Value       => 'cTM',
        ContentType => 'application/soap+xml;charset=UTF-8;action="urn:MyService/MyAction"',
    },
    {
        Name        => 'UTF-8 Simple Content Type (Just ASCII)',
        Value       => 'cTM',
        ContentType => 'text/xml;charset=UTF-8',
    },
    {
        Name        => 'ISO-8859-1 Complex Content Type',
        Value       => 'c™',
        ContentType => 'application/soap+xml;charset=iso-8859-1;action="urn:MyService/MyAction"',
    },
    {
        Name        => 'ISO-8859-1 Single Content Type',
        Value       => 'c™',
        ContentType => 'text/xml;charset=iso-8859-1;',
    },
    {
        Name        => 'ISO-8859-1 Complex Content Type (Just ASCII)',
        Value       => 'cTM',
        ContentType => 'application/soap+xml;charset=iso-8859-1;action="urn:MyService/MyAction"',
    },
    {
        Name        => 'ISO-8859-1 Simple Content Type (Just ASCII)',
        Value       => 'cTM',
        ContentType => 'text/xml;charset=iso-8859-1',
    },
);

for my $Test (@Tests) {

    my $Request = << "EOF";
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tic="http://otobo.io/TicketConnector/">
   <soapenv:Header/>
   <soapenv:Body>
      <tic:Test>
         <Test>$Test->{Value}</Test>
      </tic:Test>
   </soapenv:Body>
</soapenv:Envelope>
EOF

    # Fake STDIN and fill it with the request.
    open my $StandardInput, '<', \"$Request";    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)
    local *STDIN = $StandardInput;

    # Fake environment variables as it gets it from the request.
    local $ENV{'CONTENT_LENGTH'} = length $Request;
    local $ENV{'CONTENT_TYPE'}   = $Test->{ContentType};

    my $Result = $SOAPObject->ProviderProcessRequest();

    # Convert original value to UTF-8 (if needed).
    if ( $Test->{ContentType} =~ m{UTF-8}mxsi ) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Test->{Value} );
    }

    $Self->Is(
        $Result->{Data}->{Test},
        $Test->{Value},
        "$Test->{Name} Result value",
    );
}

$Self->DoneTesting();
