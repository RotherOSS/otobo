# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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
use if __PACKAGE__ ne 'Kernel::System::UnitTest::Driver', 'Kernel::System::UnitTest::RegisterDriver';

use vars (qw($Self));

my $ChecksumFileNotPresent = sub {
    $Self->False(
        1,
        'Archive unit test requires the checksum file (ARCHIVE) to be present and valid. Please first call the following command to create it: bin/otobo.CheckSum.pl -a create'
    );
    return 1;
};

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $ChecksumFile = "$Home/ARCHIVE";

# Checksum file content as an array ref.
my $ChecksumFileArrayRef = $MainObject->FileRead(
    Location        => $ChecksumFile,
    Mode            => 'utf8',
    Type            => 'Local',
    Result          => 'ARRAY',
    DisableWarnings => 1,
);

# This should be a SKIP-block

if ( !$ChecksumFileArrayRef || !@{$ChecksumFileArrayRef} ) {
    $ChecksumFileNotPresent->(); 
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
        my @Entry = split '::', $Line;
        next LINE if @Entry < 2;
    
        chomp $Entry[1];
        my $Filename = "$Home/$Entry[1]";
    
        if ( !-f $Filename ) {
            $Self->False(
                1,
                "$Filename not found"
            );
            next LINE;
        }
    
        if ( $Filename =~ /Cron|CHANGES|apache2-perl-startup/ ) {
    
            # Skip files with expected changes.
            next LINE;
        }
    
        if ( -e "$Filename.save" ) {
    
            # Ignore files overwritten by packages.
            next LINE;
        }
    
        my $Digest = $MainObject->MD5sum(
            Filename => $Filename,
        );
    
        # To save data, we only record errors of files, no positive results.
        if ( $Digest ne $Entry[0] ) {
            $Self->Is(
                $Digest,
                $Entry[0],
                "$Filename digest"
            );
            $ErrorsFound++;
        }
    }
    
    $Self->False(
        $ErrorsFound,
        "Mismatches in file list",
    );
}

1;
