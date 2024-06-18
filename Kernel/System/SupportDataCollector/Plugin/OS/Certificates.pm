# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::SupportDataCollector::Plugin::OS::Certificates;
use strict;
use warnings;
use parent qw(Kernel::System::SupportDataCollector::PluginBase);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::SMIME',
    'Kernel::System::Main',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self         = shift;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    if ( $ConfigObject->Get('SMIME') ) {
        my $Failure = $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->Check();
        die $Failure if $Failure;
        for my $Cert (
            $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $ConfigObject->Get('SMIME::CertPath'),
                Filter    => '*.pfx',
            )
            )
        {
            my $Bin = $ConfigObject->Get('SMIME::Bin');
            my $Out = qx"$Bin pkcs12 -in $Cert -info -clcerts";
            if ( $Out =~ 'Encrypted data: pbeWithSHA1And40BitRC2-CBC' ) {
                $Self->AddResultWarning(
                    Label => Translatable('Certificate check'),
                    Value => "$Cert: $Out",

                    # see article "Lifetimes of cryptographic hash functions"
                    Message => Translatable('Found obsolete cryptographic function.'),
                );
            }
        }
    }
    return $Self->GetResults();
}

1;
