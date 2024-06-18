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

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CommandObject     = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::FixInvalid');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my ( $Result, $ExitCode );

{
    local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute();
}

# There are no invalid settings.
is( $ExitCode, 0, 'Exit code' );

# Check output text.
like( $Result, qr{All settings are valid\.}, 'Check default result' );

# Get Setting.
my %Setting = $SysConfigObject->SettingGet(
    Name => 'Ticket::Frontend::AgentTicketPhone###Priority',
);

# Lock setting.
my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
    Name   => $Setting{Name},
    Force  => 1,
    UserID => 1,
);

# Set to invalid value.
my $Success;

if ( $Setting{ModifiedID} ) {

    $Success = $SysConfigDBObject->ModifiedSettingUpdate(
        ModifiedID        => $Setting{ModifiedID},
        DefaultID         => $Setting{DefaultID},
        Name              => $Setting{Name},
        IsValid           => 1,
        EffectiveValue    => '-123 Invalid priority value',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
}
else {
    $Success = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID         => $Setting{DefaultID},
        Name              => $Setting{Name},
        IsValid           => 1,
        EffectiveValue    => '-123 Invalid priority value',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
}

ok( $Success, 'Setting updated' );

{
    local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute('--non-interactive');
}

is( $ExitCode, 0, 'Exit code' );

ok(
    (
        $Result
            =~ m{Auto-corrected setting:.*Ticket::Frontend::AgentTicketPhone###Priority.*Deployment successful\.}s
    ) // 0,
    'Check invalid result'
);

# cleanup cache is done by RestoreDatabase

done_testing();
