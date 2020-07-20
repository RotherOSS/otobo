# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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

# This test script does not work with Kernel::System::UnitTest::Driver.
# __SKIP_BY_KERNEL_SYSTEM_UNITTEST_DRIVER__

use v5.24.0;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Test::Compile::Internal;

my $Internal = Test::Compile::Internal->new;
my @Dirs = qw(Kernel Custom scripts bin);

diag( 'look at the Perl modules' );

my %PmFileFails = (
    'Kernel/System/Auth/Radius.pm'               => 'Authen::Radius is not required',
    'Kernel/System/CustomerAuth/Radius.pm'       => 'Authen::Radius is not required',
    'Kernel/System/SysConfig/Migration.pm'       => 'scripts/MigrateFromOTRS/Base.pm does not exist',
    'Kernel/cpan-lib/Devel/REPL/Plugin/OTOBO.pm' => 'Devel::REPL::Plugin is not required',
    'Kernel/cpan-lib/Font/TTF/Win32.pm'          => 'Win32 is not supported',
    'Kernel/cpan-lib/LWP/Authen/Ntlm.pm'         => 'Authen::NLTM is not required',
    'Kernel/cpan-lib/LWP/Protocol/GHTTP.pm'      => 'HTTP::GHTTP is not required',
    'Kernel/cpan-lib/PDF/API2/Win32.pm'          => 'Win32 is not supported',
    'Kernel/cpan-lib/SOAP/Lite.pm'               => 'some strangeness concerning SOAP::Constants',
    'Kernel/cpan-lib/URI/urn/isbn.pm'            => 'Business::ISBN is not required',
);

foreach my $PmFile ( $Internal->all_pm_files(@Dirs) ) {
    if ( $PmFileFails{$PmFile} ) {
        my $todo = todo "$PmFile: $PmFileFails{$PmFile}";
        ok( $Internal->pm_file_compiles($PmFile), "$PmFile compiles" );
    }
    else {
        ok( $Internal->pm_file_compiles($PmFile), "$PmFile compiles" );
    }
}

diag( 'look at the Perl scripts' );

my %PlFileFails = (
);

foreach my $PlFile ( $Internal->all_pl_files(@Dirs) ) {
    if ( $PlFileFails{$PlFile} ) {
        my $todo = todo "$PlFile: $PlFileFails{$PlFile}";
        ok( $Internal->pl_file_compiles($PlFile), "$PlFile compiles" );
    }
    else {
        ok( $Internal->pl_file_compiles($PlFile), "$PlFile compiles" );
    }
}

done_testing();
