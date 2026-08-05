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

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name          => 'undef',
        ExpectSuccess => 0,
        Content       => \undef,
        Filename      => 'TEST/File0.txt',
        Mode          => 'utf8',
        Preferences   => {
            ContentType => 'text/plain',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindPreferences => {
            ContentType => 'text/plain',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindNotPreferences => {
            ContentType => 'text/xml',
            ContentID   => '<some_id_xls@example.net>',
        },
        FindFilenameAndPreferences => {
            Filename    => 'TEST/File0.txt',
            Preferences => {
                ContentType => 'text/plain',
            },
        },
    },
    {
        Name          => '.txt',
        ExpectSuccess => 1,
        Location      => 'scripts/test/sample/VirtualFS/VirtualFS-Test1.txt',
        Filename      => 'TEST/File.txt',
        Mode          => 'utf8',
        MD5           => '26ea4a608d77c62ed0e4b0f8952c9df2',
        Find          => '*txt',
        FindNot       => '*.txt_*',
        Preferences   => {
            ContentType => 'text/plain',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindPreferences => {
            ContentType => 'text/plain',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindNotPreferences => {
            ContentType => 'text/xml',
            ContentID   => '<some_id_xls@example.net>',
        },
        FindFilenameAndPreferences => {
            Filename    => 'TEST/File.txt',
            Preferences => {
                ContentType => 'text/plain',
            },
        },
    },
    {
        Name          => '.pdf',
        ExpectSuccess => 1,
        Location      => 'scripts/test/sample/VirtualFS/VirtualFS-Test2.pdf',
        Filename      => 'me_t o_alal.pdf',
        Mode          => 'binmode',
        MD5           => '5ee767f3b68f24a9213e0bef82dc53e5',
        Find          => '*.pdf',
        FindNot       => '*.pdf_*',
        Preferences   => {
            ContentType => 'text/plain',
            ContentID   => '<some_id@example.com>',
        },
        FindPreferences => {
            ContentType => 'text/plain',
            ContentID   => '<some_id@example.com>',
        },
        FindNotPreferences => {
            ContentType => 'text/rfc-822',
            ContentID   => '<some_id@example.net>',
        },
        FindFilenameAndPreferences => {
            Filename    => 'me_t o_alal.pdf',
            Preferences => {
                ContentType => 'text/plain',
                ContentID   => '<some_id@example.com>',
            },
        },
    },
    {
        Name          => '.xls',
        ExpectSuccess => 1,
        Location      => 'scripts/test/sample/VirtualFS/VirtualFS-Test3.xls',
        Filename      => 'me_t o_alal.xls',
        Mode          => 'binmode',
        MD5           => '39fae660239f62bb0e4a29fe14ff5663',
        Find          => '*xls',
        FindNot       => '*.xls_*',
        Preferences   => {
            ContentType => 'text/xls',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindPreferences => {
            ContentType => 'text/*',
        },
        FindNotPreferences => {
            ContentType => 'image/png',
            ContentID   => '<some_id_xls@example.com>',
        },
        FindFilenameAndPreferences => {
            Filename    => 'me_t o_alal.xls',
            Preferences => {
                ContentType => 'text/xls',
                ContentID   => '<some_id_xls@example.com>',
            },
        },
    },
);

for my $Backend (qw( FS DB )) {

    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::VirtualFS'] );

    $ConfigObject->Set(
        Key   => 'VirtualFS::Backend',
        Value => 'Kernel::System::VirtualFS::' . $Backend,
    );

    # get a new virtual fs object
    my $VirtualFSObject = $Kernel::OM->Get('Kernel::System::VirtualFS');

    for my $Test (@Tests) {

        subtest "Test: $Test->{Name}, Backend: $Backend, Mode: $Test->{Mode}" => sub {

            my $Content = exists $Test->{Content} ? $Test->{Content} : $MainObject->FileRead(
                Location => $ConfigObject->Get('Home') . '/' . $Test->{Location},
                Mode     => $Test->{Mode},
            );

            if ( exists $Test->{MD5} ) {
                my $MD5Sum = $MainObject->MD5sum( String => ${$Content} );
                is(
                    $MD5Sum || '',
                    $Test->{MD5},
                    "$Backend MD5sum() - pre - $Test->{Name}",
                );
            }

            # write
            my %Preferences = %{ $Test->{Preferences} };
            my $Success     = $VirtualFSObject->Write(
                Filename    => $Test->{Filename},
                Mode        => $Test->{Mode},
                Content     => $Content,
                Preferences => \%Preferences,
            );

            # expected failure
            if ( !$Test->{ExpectSuccess} ) {
                is(
                    $Success,
                    undef,
                    "$Backend Write undef - $Test->{Name}",
                );
            }

            # expected success
            else {
                is( $Success, "$Backend Write - $Test->{Name}" );

                # read
                my %File = $VirtualFSObject->Read(
                    Filename => $Test->{Filename},
                    Mode     => $Test->{Mode},
                );
                is(
                    $File{Content},
                    "$Backend Read() - $Test->{Name}",
                );
                my $MD5Sum = $MainObject->MD5sum( String => $File{Content} );
                is(
                    $MD5Sum || '',
                    $Test->{MD5},
                    "$Backend MD5sum() - post - $Test->{Name}",
                );

                # preferences
                for my $Key ( sort keys %{ $Test->{Preferences} } ) {
                    is(
                        $File{Preferences}->{$Key},
                        $Test->{Preferences}->{$Key},
                        "Read() - preferences - $Key",
                    );
                }

                # find
                my @List = $VirtualFSObject->Find( Filename => $Test->{Find} );
                @List = grep { $_ eq $Test->{Filename} } @List;
                is( $List[0], $Test->{Filename}, "Find() Filename - $Test->{Find}" );

                # find not
                @List = $VirtualFSObject->Find( Filename => $Test->{FindNot} );
                @List = grep { $_ eq $Test->{Filename} } @List;
                is( \@List, [], "Find() FindNot - $Test->{FindNot}" );

                # find preferences
                @List = $VirtualFSObject->Find( Preferences => $Test->{FindPreferences} );
                @List = grep { $_ eq $Test->{Filename} } @List;
                is( $List[0], $Test->{Filename}, "Find() - Preferences" );

                # find not preferences
                @List = $VirtualFSObject->Find( Preferences => $Test->{FindNotPreferences} );
                @List = grep { $_ eq $Test->{Filename} } @List;
                is( \@List, [], "Find() - Preferences Not" );

                # find filename AND preferences
                @List = $VirtualFSObject->Find( %{ $Test->{FindFilenameAndPreferences} } );
                @List = grep { $_ eq $Test->{Filename} } @List;
                is( $List[0], $Test->{Filename}, "Find() - Filename AND Preferences" );
            }
        };
    }

    # delete
    TEST:
    for my $Test (@Tests) {

        # no deletion needed for test which is expected to fail on writing
        next TEST unless $Test->{ExpectSuccess};

        my $DeleteSuccess = $VirtualFSObject->Delete( Filename => $Test->{Filename} );
        ok( $DeleteSuccess, "$Backend Delete()" );
    }
}

done_testing;
