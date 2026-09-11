# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use File::Copy qw(copy);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use FindBin    qw($RealBin);

# CPAN modules
use Test2::V0;

my $Home = "$RealBin/../../..";

my $TempHome = tempdir( CLEANUP => 1 );
make_path("$TempHome/scripts");
make_path("$TempHome/Kernel/System");

copy(
    "$Home/scripts/DBUpdate-to-11.1.pl",
    "$TempHome/scripts/DBUpdate-to-11.1.pl",
) or die "Could not copy DB update launcher: $!";

my %Modules = (
    'Kernel/System/ObjectManager.pm' => <<'EOF',
package Kernel::System::ObjectManager;

sub new {
    my ($Type) = @_;
    return bless {}, $Type;
}

1;
EOF
    'scripts/DBUpdateTo11_1.pm' => <<'EOF',
package scripts::DBUpdateTo11_1;

sub Run {
    return $ENV{OTOBO_TEST_DBUPDATE_SUCCESS};
}

1;
EOF
);

for my $Module ( sort keys %Modules ) {
    open my $Filehandle, '>', "$TempHome/$Module"
        or die "Could not create $Module: $!";
    print {$Filehandle} $Modules{$Module};
    close $Filehandle or die "Could not close $Module: $!";
}

for my $Test (
    {
        Name         => 'successful migration',
        RunResult    => 1,
        ExpectedExit => 0,
    },
    {
        Name         => 'failed migration',
        RunResult    => 0,
        ExpectedExit => 1,
    },
    )
{
    local $ENV{OTOBO_TEST_DBUPDATE_SUCCESS} = $Test->{RunResult};

    system $^X, "$TempHome/scripts/DBUpdate-to-11.1.pl";

    is( $?, $Test->{ExpectedExit} << 8, "$Test->{Name} returns the expected process status" );
}

done_testing();
