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

subtest 'load modules from lib_standard and lib_custom' => sub {

    $StandardRefreshDir->file('Sample1.pm')->spew(<<'END_PM');
package Refresh::Sample1;

sub Method1 {
    return "this is Method1() from Sample1";
}

1;
END_PM

    $CustomRefreshDir->file('Sample2.pm')->spew(<<'END_PM');
package Refresh::Sample2;

sub Method1 {
    return "this is Method1() from Sample2";
}

1;
END_PM

    require 'Refresh/Sample1.pm';    ## no critic qw(Modules::RequireBarewordIncludes)
    require 'Refresh/Sample2.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    is(
        scalar Refresh::Sample1->Method1,
        'this is Method1() from Sample1',
        'Method1 from Sample1 before refresh'
    );
    is(
        scalar Refresh::Sample2->Method1,
        'this is Method1() from Sample2',
        'Method1 from Sample1 before refresh'
    );

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample1.pm');
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample2.pm');

    is(
        scalar Refresh::Sample1->Method1,
        'this is Method1() from Sample1',
        'Method1 from Sample1 after refresh'
    );
    is(
        scalar Refresh::Sample2->Method1,
        'this is Method1() from Sample2',
        'Method1 from Sample1 after refresh'
    );
};

subtest 'lib_custom has precedence over lib_custom' => sub {

    $StandardRefreshDir->file('Sample3.pm')->spew(<<'END_PM');
package Refresh::Sample3;

sub Method1 {
    return "this is Method1() from Sample3, in lib_standard";
}

1;
END_PM

    $CustomRefreshDir->file('Sample3.pm')->spew(<<'END_PM');
package Refresh::Sample3;

sub Method1 {
    return "this is Method1() from Sample3, in lib_custom";
}

1;
END_PM

    require 'Refresh/Sample3.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    # this only add the new module to the cache
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample3.pm');

    is(
        scalar Refresh::Sample3->Method1,
        'this is Method1() from Sample3, in lib_custom',
        'Method1 from Sample3 loaded from lib_custom'
    );
};

subtest 'simple refresh of modified module' => sub {

    $StandardRefreshDir->file('Sample4.pm')->spew(<<'END_PM');
package Refresh::Sample4;

sub Method1 {
    return "this is Method1() from Sample4";
}

1;
END_PM

    require 'Refresh/Sample4.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    # add the new module to the cache
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample4.pm');

    is(
        scalar Refresh::Sample4->Method1,
        'this is Method1() from Sample4',
        'Method1 from Sample1 before refresh'
    );

    $StandardRefreshDir->file('Sample4.pm')->spew(<<'END_PM');
package Refresh::Sample4;

sub Method1 {
    return "this is Method1() from Sample4, modified";
}

1;
END_PM

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample4.pm');

    is(
        scalar Refresh::Sample4->Method1,
        'this is Method1() from Sample4, modified',
        'Method1 from Sample1 after refresh'
    );
};

subtest 'new implementation in lib_custom' => sub {

    $StandardRefreshDir->file('Sample5.pm')->spew(<<'END_PM');
package Refresh::Sample5;

sub Method1 {
    return "this is Method1() from Sample5";
}

1;
END_PM

    require 'Refresh/Sample5.pm';    ## no critic qw(Modules::RequireBarewordIncludes)

    # add the new module to the cache
    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample5.pm');

    is(
        scalar Refresh::Sample5->Method1,
        'this is Method1() from Sample5',
        'Method1 from Sample5 before refresh'
    );

    $CustomRefreshDir->file('Sample5.pm')->spew(<<'END_PM');
package Refresh::Sample5;

sub Method1 {
    return "this is Method1() from Sample5, in lib_custom";
}

1;
END_PM

    # make sure that we have a new timestamp
    sleep 1;

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample5.pm');

    is(
        scalar Refresh::Sample5->Method1,
        'this is Method1() from Sample5',
        'no refresh as the module in lib_standard has not changed'
    );

    # touch the module in lib_standard
    utime undef, undef, $StandardRefreshDir->file('Sample5.pm')->stringify;

    Kernel::System::ModuleRefresh->refresh_module_if_modified('Refresh/Sample5.pm');

    is(
        scalar Refresh::Sample5->Method1,
        'this is Method1() from Sample5, in lib_custom',
        'refresh as the module in lib_standard has been touched'
    );

};

done_testing;
