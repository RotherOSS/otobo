# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Console::Command::Maint::CloudServices::ConnectionCheck;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::JSON',
    'Kernel::System::Main',
    'Kernel::System::WebUserAgent',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check OTOBO cloud services connectivity.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Checking OTOBO cloud service connectivity...</yellow>\n");

    # set trace level
    $Net::SSLeay::trace = 3;

    # print WebUserAgent settings if any
    my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
    my $Timeout                = $ConfigObject->Get('WebUserAgent::Timeout')                || '';
    my $Proxy                  = $ConfigObject->Get('WebUserAgent::Proxy')                  || '';
    my $DisableSSLVerification = $ConfigObject->Get('WebUserAgent::DisableSSLVerification') || '';

    # remove credentials if any
    if ($Proxy) {
        $Proxy =~ s{\A.+?(http)}{$1};
    }
    if ( $Timeout || $Proxy || $DisableSSLVerification ) {

        $Self->Print("<yellow>Sending request with the following options:</yellow>\n");

        if ( $Proxy =~ m{\A ( http(?: s)? :// (?: \d{1,3}\.){3}\d{1,3}) : (\d+) /\z}msx ) {
            $Self->Print("  Proxy Address: $1\n");
            $Self->Print("  Proxy Port: $2\n");
        }
        elsif ($Proxy) {
            $Self->Print("  Proxy String: $Proxy\n");
        }

        if ($Timeout) {
            $Self->Print("  Timeout: $Timeout second(s)\n");
        }

        if ($DisableSSLVerification) {
            $Self->Print("  Disable SSL Verification: Yes\n");
        }
        $Self->Print("\n");
    }
    else {
        $Self->Print("<yellow>Sending request...</yellow>\n\n");
    }

    # prepare request data
    my $RequestData = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => {
            Test => [
                {
                    Operation => 'Test',
                    Data      => {
                        Success => 1,
                    },
                },
            ],
        },
    );

    # remember the time when the request is sent
    my $TimeStartObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # send request
    my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
        Type => 'POST',
        URL  => 'https://portal.rother-oss.com/otobo/public.pl',
        Data => {
            Action      => 'PublicCloudService',
            RequestData => $RequestData,
        },
    );

    # calculate and print the time spent in the request
    my $TimeEndObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $TimeDelta     = $TimeEndObject->Delta( DateTimeObject => $TimeStartObject );
    my $TimeDiff      = $TimeDelta->{AbsoluteSeconds};

    $Self->Print(
        sprintf(
            "<yellow>Response time:</yellow> %s second(s)\n\n",
            $TimeDiff,
        )
    );

    # dump the request response
    my $Dump = $Kernel::OM->Get('Kernel::System::Main')->Dump(
        \%Response,
        'ascii',
    );

    # remove heading and tailing dump output
    $Dump =~ s{\A \$VAR1 [ ] = [ ] \{\n\s}{}msx;
    $Dump =~ s{\};\n\z}{}msx;

    # print response
    $Self->Print("<yellow>Response:</yellow>\n $Dump\n");

    # check for suggestions
    my %Suggestions;

    if ( $Proxy && $Proxy !~ m{/\z}msx ) {
        $Suggestions{WrongProxyEndLine} = 1;
    }
    if ( $Response{Status} =~ m{504}msx || $TimeDiff > $Timeout ) {
        $Suggestions{IncreseTimeout} = 1;
    }

    # print suggestions if any
    if (%Suggestions) {
        $Self->Print("<yellow>Suggestions:</yellow>\n");
        if ( $Suggestions{WrongProxyEndLine} ) {
            print
                "  The proxy string settings does not end with a '/', update your setting 'WebUserAgent::Proxy' as: $Proxy/\n";
        }
        if ( $Suggestions{IncreseTimeout} ) {
            $Self->Print("  Please increase the time out setting 'WebUserAgent::Timeout' and try again\n");
        }
    }
    return $Self->ExitCodeOk();
}

1;
