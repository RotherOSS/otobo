# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get environment object
my $EnvironmentObject = $Kernel::OM->Get('Kernel::System::Environment');

# OSInfo
my %OSInfo = $EnvironmentObject->OSInfoGet();
for my $Key (qw(Hostname OS OSName User)) {
    diag "OSInfo: got '$OSInfo{$Key}' for $Key";
    ok( $OSInfo{$Key}, "OSInfoGet - returned $Key" );
}
ok( $OSInfo{OSName} !~ m{\A Unknown version }xms, "OSInfoGet - OSName is not unknown but '$OSInfo{OSName}'" );

# PerlInfo
my %PerlInfo = $EnvironmentObject->PerlInfoGet();
diag "PerlInfo: got '$PerlInfo{PerlVersion}' for PerlVersion";
ok( $PerlInfo{PerlVersion} =~ m/^\d.\d\d.\d/, "PerlInfoGet - retrieved Perl version." );
ok( !$PerlInfo{Modules},                      "PerlInfoGet - no module versions if not specified." );

# PerlInfo with bundled modules
%PerlInfo = $EnvironmentObject->PerlInfoGet(
    BundledModules => 1,
);
diag "PerlInfo: got '$PerlInfo{PerlVersion}' for PerlVersion, even with BundledModules => 1";
ok( $PerlInfo{PerlVersion} =~ m/^\d.\d\d.\d/, "PerlInfoGet w/ BundledModules - retrieved Perl version." );

# check version of an abritrary module
ok(
    $PerlInfo{Modules}->{'JSON::PP'} =~ m/^\d.\d\d/,
    "PerlInfoGet w/ BundledModules - found version for JSON::PP $PerlInfo{Modules}->{'JSON::PP'}",
);

my $Version = $EnvironmentObject->ModuleVersionGet(
    Module => 'MIME::Parser',
);

ok(
    $Version =~ m/^\d\.\d\d\d$/,
    "ModuleVersionGet - Version for MIME::Parser is $Version.",
);

$Version = $EnvironmentObject->ModuleVersionGet(
    Module => 'SCHMIME::Parser',
);

ok(
    !$Version,
    "ModuleVersionGet - Version for SCMIME::Parser does not exist.",
);

my %DBInfo = $EnvironmentObject->DBInfoGet();

for my $Key (qw(Database Host Type User Version)) {
    diag "DBInfo: got '$DBInfo{$Key}' for $Key";
    ok( $DBInfo{$Key} =~ m/\w\w/, "DBInfoGet - returned value for $Key" );
}

my %OTOBOInfo = $EnvironmentObject->OTOBOInfoGet();
for my $Key (qw(Version Home Host Product SystemID DefaultLanguage)) {
    diag "OTOBOInfo: got '$OTOBOInfo{$Key}' for $Key";
    ok( $OTOBOInfo{$Key}, "OTOBOInfoGet - returned value for $Key" );
}

done_testing;
