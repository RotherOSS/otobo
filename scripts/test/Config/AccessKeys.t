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

our $Self;

use Kernel::System::VariableCheck qw(:all);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Get all frontend modules with access key definitions.
my @Modules = $SysConfigObject->ConfigurationSearch(
    Search           => 'AccessKey',
    Category         => 'All',
    IncludeInvisible => 1,
);

# Check used access keys.
my %UsedAccessKeys;

my $Error;

MODULE:
for my $Module (@Modules) {
    my %SysConfig = $SysConfigObject->SettingGet(
        Name => $Module,
    );

    next MODULE if !IsHashRefWithData( $SysConfig{DefaultValue} );
    next MODULE if !defined $SysConfig{DefaultValue}->{AccessKey};
    next MODULE if !length $SysConfig{DefaultValue}->{AccessKey};

    my $AccessKey      = $SysConfig{DefaultValue}->{AccessKey};
    my $AccessKeyLower = lc $AccessKey;

    my $Name = $SysConfig{DefaultValue}->{Link} || $SysConfig{DefaultValue}->{Module} || '';
    my $Frontend;

    if ( $Module =~ /CustomerFrontend/i ) {
        $Frontend = 'CUSTOMER FRONTEND';
    }
    elsif ( $Module =~ /PublicFrontend/i ) {
        $Frontend = 'PUBLIC FRONTEND';
    }
    else {
        $Frontend = 'AGENT FRONTEND';
    }

    $Self->False(
        $UsedAccessKeys{$Frontend}->{$AccessKeyLower},
        "[$Frontend] Check if access key '$AccessKey' already exists ($Name)",
    );

    if ( !$Error && $UsedAccessKeys{$Frontend}->{$AccessKeyLower} ) {
        if ( !$Error ) {
            $Error = 1;
        }

        next MODULE;
    }

    $UsedAccessKeys{$Frontend}->{$AccessKeyLower} = $Name;
}

$Self->False(
    $Error,
    "List of all defined access keys: \n"
        . $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => \%UsedAccessKeys )
);

$Self->DoneTesting();
