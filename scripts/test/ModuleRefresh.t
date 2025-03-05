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

## nofilter(TidyAll::Plugin::OTOBO::Perl::Require)
use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use File::Temp qw(tempdir);

# CPAN modules
use Test2::V0;
use Path::Class qw(dir);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM
use Kernel::System::ModuleRefresh;           # based on Module::Refresh
use scripts::test::ModuleRefresh::Sample;    # just a sample

ok( exists $INC{'scripts/test/ModuleRefresh/Sample.pm'}, 'ModuleRefresh::Sample is loaded' );

# set up dirs
# 'lib_custom' has precedence over 'lib_standard'
my ( $StandardRefreshDir, $CustomRefreshDir );
{
    my $TmpDir = dir( tempdir( CLEANUP => 1 ) );

    my $StandardDir = $TmpDir->subdir('lib_standard');
    $StandardRefreshDir = $StandardDir->subdir('Refresh');
    $StandardRefreshDir->mkpath;
    ok( -d "$StandardRefreshDir", 'lib_standard/Refresh dir exists' );

    my $CustomDir = $TmpDir->subdir('lib_custom');
    $CustomRefreshDir = $CustomDir->subdir('Refresh');
    $CustomRefreshDir->mkpath;
    ok( -d "$CustomRefreshDir", 'lib_custom/Refresh dir exists' );

    unshift @INC, "$CustomDir", "$StandardDir";
}

subtest 'load modules from either lib_standard or lib_custom' => sub {

    $StandardRefreshDir->file('Sample10.pm')->spew(<<'END_PM');
package Refresh::Sample10;

sub Method1 {
    return "this is Method1() from Sample10";
}

1;
END_PM

    $CustomRefreshDir->file('Sample20.pm')->spew(<<'END_PM');
package Refresh::Sample20;

sub Method1 {
    return "this is Method1() from Sample20";
}

1;
END_PM

    require 'Refresh/Sample10.pm';    ## no critic qw(Modules::RequireBarewordIncludes)
    require 'Refresh/Sample20.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    is(
        scalar Refresh::Sample10->Method1,
        'this is Method1() from Sample10',
        'Method1 from Sample10 before refresh'
    );
    is(
        scalar Refresh::Sample20->Method1,
        'this is Method1() from Sample20',
        'Method1 from Sample10 before refresh'
    );

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample10.pm');
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample20.pm');

    is(
        scalar Refresh::Sample10->Method1,
        'this is Method1() from Sample10',
        'Method1 from Sample10 after refresh'
    );
    is(
        scalar Refresh::Sample20->Method1,
        'this is Method1() from Sample20',
        'Method1 from Sample10 after refresh'
    );
};

subtest 'lib_custom has precedence over lib_custom' => sub {

    $StandardRefreshDir->file('Sample30.pm')->spew(<<'END_PM');
package Refresh::Sample30;

sub Method1 {
    return "this is Method1() from Sample30, in lib_standard";
}

1;
END_PM

    $CustomRefreshDir->file('Sample30.pm')->spew(<<'END_PM');
package Refresh::Sample30;

sub Method1 {
    return "this is Method1() from Sample30, in lib_custom";
}

1;
END_PM

    require 'Refresh/Sample30.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    # this only add the new module to the cache
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample30.pm');

    is(
        scalar Refresh::Sample30->Method1,
        'this is Method1() from Sample30, in lib_custom',
        'Method1 from Sample30 loaded from lib_custom'
    );
};

subtest 'simple refresh of modified module' => sub {

    $StandardRefreshDir->file('Sample40.pm')->spew(<<'END_PM');
package Refresh::Sample40;

sub Method1 {
    return "this is Method1() from Sample40";
}

1;
END_PM

    require 'Refresh/Sample40.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    # add the new module to the cache
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample40.pm');

    is(
        scalar Refresh::Sample40->Method1,
        'this is Method1() from Sample40',
        'Method1 from Sample40 before refresh'
    );

    $StandardRefreshDir->file('Sample40.pm')->spew(<<'END_PM');
package Refresh::Sample40;

sub Method1 {
    return "this is Method1() from Sample40, modified";
}

1;
END_PM

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample40.pm');

    is(
        scalar Refresh::Sample40->Method1,
        'this is Method1() from Sample40, modified',
        'Method1 from Sample40 after refresh'
    );
};

subtest 'new implementation in lib_custom' => sub {

    $StandardRefreshDir->file('Sample50.pm')->spew(<<'END_PM');
package Refresh::Sample50;

sub Method1 {
    return "this is Method1() from Sample50";
}

1;
END_PM

    require 'Refresh/Sample50.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    # add the new module to the cache
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample50.pm');

    is(
        scalar Refresh::Sample50->Method1,
        'this is Method1() from Sample50',
        'Method1 from Sample50 before refresh'
    );

    $CustomRefreshDir->file('Sample50.pm')->spew(<<'END_PM');
package Refresh::Sample50;

sub Method1 {
    return "this is Method1() from Sample50, in lib_custom";
}

1;
END_PM

    # make sure that we have a new timestamp
    sleep 1;

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample50.pm');

    is(
        scalar Refresh::Sample50->Method1,
        'this is Method1() from Sample50',
        'no refresh as the module in lib_standard has not changed'
    );

    # touch the module in lib_standard
    $StandardRefreshDir->file('Sample50.pm')->touch;

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample50.pm');

    is(
        scalar Refresh::Sample50->Method1,
        'this is Method1() from Sample50, in lib_custom',
        'refresh as the module in lib_standard has been touched'
    );

};

subtest 'implementation in lib_custom is deleted' => sub {

    $StandardRefreshDir->file('Sample60.pm')->spew(<<'END_PM');
package Refresh::Sample60;

sub Method1 {
    return "this is Method1() from Sample60, in lib_standard";
}

1;
END_PM

    $CustomRefreshDir->file('Sample60.pm')->spew(<<'END_PM');
package Refresh::Sample60;

sub Method1 {
    return "this is Method1() from Sample60, in lib_custom";
}

1;
END_PM

    require 'Refresh/Sample60.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    # add the new module to the cache
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample60.pm');

    is(
        scalar Refresh::Sample60->Method1,
        'this is Method1() from Sample60, in lib_custom',
        'Method1 from Sample60 before refresh'
    );

    unlink $CustomRefreshDir->file('Sample60.pm');

    ok( !-f $CustomRefreshDir->file('Sample60.pm'), 'lib_standard/Refresh dir exists' );

    is(
        scalar Refresh::Sample60->Method1,
        'this is Method1() from Sample60, in lib_custom',
        'Method1 from Sample60 after unlink before refresh'
    );

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample60.pm');

    is(
        scalar Refresh::Sample60->Method1,
        'this is Method1() from Sample60, in lib_standard',
        'back to lib_standard, after implementation in lib_custom was removed and refreshed'
    );
};

done_testing;
