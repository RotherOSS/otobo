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
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# Work around a Perl bug that is triggered in Carp
#   (Bizarre copy of HASH in list assignment at /usr/share/perl5/vendor_perl/Carp.pm line 229).
#
#   https://rt.perl.org/Public/Bug/Display.html?id=52610 and
#   http://rt.perl.org/rt3/Public/Bug/Display.html?id=78186

no warnings 'redefine';    ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
use Carp;
local *Carp::caller_info = sub { };
use warnings 'redefine';

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TargetDirectory = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/tmp';

# Cleanup from previous tests.
my @SupportFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
    Directory => '/var/tmp',
    Filter    => 'SupportBundle_*.tar.gz',
);
foreach my $File (@SupportFiles) {
    unlink $File;
}

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::SupportBundle::Generate');

# Run the console command and get its exit code as a result.
my $ExitCode = $CommandObject->Execute( '--target-directory', $TargetDirectory );

$Self->Is(
    $ExitCode,
    0,
    'Maint::SupportBundle::Generate exit code'
);

@SupportFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
    Directory => $TargetDirectory,
    Filter    => 'SupportBundle_*.tar.gz',
);

$Self->Is(
    scalar @SupportFiles,
    1,
    'Support bundle generated'
);

# Remove generated support files.
foreach my $File (@SupportFiles) {
    unlink $File;
}

# Cleanup cache is done by RestoreDatabase.

$Self->DoneTesting();
