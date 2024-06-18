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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::GenericInterface::Debugger              ();
use Kernel::GenericInterface::Transport::HTTP::SOAP ();

our $Self;

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
        Name   => "Basic Chars '<' '&'",
        Config => {
            Data => 'a <string> & more',
        },
        ExpectedResult => 'a &lt;string&gt; &amp; more',
    },
    {
        Name   => "String With CDATA",
        Config => {
            Data => '<![CDATA[Test]]>',
        },
        ExpectedResult => '&lt;![CDATA[Test]]&gt;',
    },
    {
        Name   => "String With ']]>'",
        Config => {
            Data =>
                '<[[https://info.microsoft.com/WE-Azure-WBNR-FY17-09Sep-08-Barracuda-ISV-Webinar-244253_Registration.html?ls=Email]]>',
        },
        ExpectedResult =>
            '&lt;[[https://info.microsoft.com/WE-Azure-WBNR-FY17-09Sep-08-Barracuda-ISV-Webinar-244253_Registration.html?ls=Email]]&gt;',
    },
    {
        Name   => "String Control characters'",
        Config => {
            Data => "Test1\x{03} Test2\x{08} Test3\x{0C}",
        },
        ExpectedResult => "Test1 Test2 Test3",
    },

);

for my $Test (@Tests) {

    my $Result = $SOAPObject->_SOAPOutputProcessString( %{ $Test->{Config} } );

    $Self->Is(
        $Result,
        $Test->{ExpectedResult},
        "$Test->{Name} Result value",
    );
}

$Self->DoneTesting();
