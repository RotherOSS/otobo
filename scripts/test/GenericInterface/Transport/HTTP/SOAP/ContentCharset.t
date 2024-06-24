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
use HTTP::Request ();

# OTOBO modules
use Kernel::System::ObjectManager                   ();
use Kernel::GenericInterface::Debugger              ();
use Kernel::GenericInterface::Transport::HTTP::SOAP ();

$Kernel::OM = Kernel::System::ObjectManager->new();

my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

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
            NameSpace            => 'http://www.otobo.org/TicketConnector/',
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
        # The charset is not declared as UTF-8. Thus ProviderProcessRequest()
        # has no reason to decode the content. Thus expect the encoded value as the result.
        UseEncoded  => 1,
        Name        => 'ISO-8859-1 Complex Content Type',
        Value       => 'c™',
        ContentType => 'application/soap+xml;charset=iso-8859-1;action="urn:MyService/MyAction"',
    },
    {
        # The charset is not declared as UTF-8. Thus ProviderProcessRequest()
        # has no reason to decode the content. Thus expect the encoded value as the result.
        UseEncoded  => 1,
        Name        => 'ISO-8859-1 Simple Content Type',
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

plan( scalar @Tests );

for my $Test (@Tests) {

    my $Request = << "END_XML";
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tic="http://www.otobo.org/TicketConnector/">
   <soapenv:Header/>
   <soapenv:Body>
      <tic:Test>
         <Test>$Test->{Value}</Test>
      </tic:Test>
   </soapenv:Body>
</soapenv:Envelope>
END_XML

    # prepare the test request
    $EncodeObject->EncodeOutput( \$Request );
    my $HTTPRequest = HTTP::Request->new(
        'POST',
        'http://www.example.com',
        [
            'Content-Type'   => $Test->{ContentType},
            'Content-Length' => length $Request,
        ],
        $Request,
    );

    # force the ParamObject to use the new request params
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Web::Request' => { HTTPRequest => $HTTPRequest }
    );

    my $Result = $SOAPObject->ProviderProcessRequest();

    # Convert original value to UTF-8 (if needed).
    if ( $Test->{UseEncoded} ) {
        $EncodeObject->EncodeOutput( \$Test->{Value} );
    }

    is(
        $Result->{Data}->{Test},
        $Test->{Value},
        "$Test->{Name} Result value",
    );
}
