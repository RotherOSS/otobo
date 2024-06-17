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
use v5.24;
use utf8;

use Test2::V0;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $Home         = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $ChecksumFile = "$Home/ARCHIVE";

# Checksum file content as an array ref.
# It is OK when ARCHIVE does not exist.
# But when ARCHIVE exists then it should be valid.
my $ChecksumFileArrayRef;
if ( -e $ChecksumFile ) {
    $ChecksumFileArrayRef = $MainObject->FileRead(
        Location        => $ChecksumFile,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'ARRAY',
        DisableWarnings => 1,
    );
}

# This should be a SKIP-block

if ( !$ChecksumFileArrayRef || !@{$ChecksumFileArrayRef} ) {
    $Self->False(
        1,
        'Archive unit test requires the checksum file (ARCHIVE) to be present and valid. Please first call the following command to create it: bin/otobo.CheckSum.pl -a create'
    );
}
else {

    my $ChecksumFileSize = -s $ChecksumFile;
    $Self->True(
        $ChecksumFileSize && $ChecksumFileSize > 2**10 && $ChecksumFileSize < 2**20,
        'Checksum file size in expected range (> 1KB && < 1MB)'
    );

    my $ErrorsFound;

    # Verify MD5 digests in the checksum file.
    LINE:
    while ( my $Line = shift @{$ChecksumFileArrayRef} ) {
        chomp $Line;

        my ( $MD5Sum, $Filename ) = split /::/, $Line, 2;

        next LINE if !$MD5Sum;
        next LINE if !$Filename;

        $Filename = "$Home/$Filename";

        if ( !-f $Filename ) {
            $Self->False( 1, "$Filename found" );

            next LINE;
        }

        # Skip files with expected changes.
        next LINE if $Filename =~ m/Cron|CHANGES|apache2-perl-startup/;

        # ignore output files of unittest runs
        next LINE if $Filename =~ m/unittest_.*\.out/;
        next LINE if $Filename =~ m/prove_.*\.out/;

        # Skip logfiles
        next LINE if $Filename =~ m/var\/log/;

        # Ignore files overwritten by packages.
        next LINE if -e "$Filename.save";

        my $ComputedMD5Sum = $MainObject->MD5sum(
            Filename => $Filename,
        );

        # To save data, we only record errors of files, no positive results.
        if ( $ComputedMD5Sum ne $MD5Sum ) {
            $Self->Is( $ComputedMD5Sum, $MD5Sum, "$Filename digest" );
            $ErrorsFound++;
        }
    }

    $Self->False(
        $ErrorsFound,
        "Mismatches in file list",
    );
}

done_testing();
