#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

use File::Basename qw(dirname);
use FindBin        qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

# core modules
use Getopt::Std qw(getopt);
use Digest::MD5 ();

# CPAN modules

# OTOBO modules

my $Start = $RealBin;
$Start =~ s{/bin}{/}smx;    # the top level dir, will be used in ProcessDirectory()
my $Archive = '';
my $Action  = 'compare';
my %Compare;

# get options
my %Opts;
getopt( 'abd', \%Opts );
if ( exists $Opts{h} || !keys %Opts ) {
    print <<'END_HELP';

Create or compare OTOBO file checksum information.

Usage:
 otobo.CheckSum.pl -a create|compare [-b /path/to/ARCHIVE] [-d /path/to/framework]

Options:
 -a                     - Specify the action (create|compare).
 [-b]                   - Specify the path to archive.
 [-d]                   - Specify the path to OTOBO framework.
 [-h]                   - Display help for this command.

END_HELP
    exit 1;
}

if ( $Opts{a} && $Opts{a} eq 'create' ) {
    $Action = $Opts{a};
}
if ( $Opts{d} ) {
    $Start = $Opts{d};
}
if ( $Opts{b} ) {
    $Archive = $Opts{b};
}
else {
    $Archive = $Start . 'ARCHIVE';
}

my $Output;

if ( $Action eq 'create' ) {
    print "Writing $Archive ...";
    open( $Output, '>', $Archive ) || die "ERROR: Can't write: $Archive";    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)
}
else {
    open( my $In, '<', $Archive ) || die "ERROR: Can't read: $Archive";      ## no critic qw(OTOBO::ProhibitOpen)
    while ( my $s = <$In> ) {
        my @Row = split /::/, $s;
        chomp $Row[1];
        $Compare{ $Row[1] } = $Row[0];
    }
    close $In;
}

# start recursing the top directory
ProcessDirectory($Start);
for my $File ( sort keys %Compare ) {

    #print "Notice: Removed $Compare{$File}\n";
    print "Notice: Removed $File\n";
}
if ( $Action eq 'create' ) {
    print " done.\n";
    close $Output;
}

sub ProcessDirectory {
    my $In = shift;

    my @List = glob "$In/*";

    FILE:
    for my $File (@List) {

        # clean up directory name
        $File =~ s{//}{/}smxg;

        # always stay in OTOBO directory
        next FILE if $File !~ m{^\Q$Start\E};

        # ignore source code directories, ARCHIVE file
        next FILE if $File =~ m{/.git|/ARCHIVE}smx;

        # ignore files used for docker version obgrades
        next FILE if $File =~ m{/docker_firsttime}smx;

        # recurse into subdirectories, without chdir
        if ( -d $File ) {
            ProcessDirectory($File);

            next FILE;
        }

        # ignore all non-regular files as links, pipes, sockets etc.
        next FILE unless -f $File;

        # only look at the relative paths from the original start dir
        my $OrigFile = $File;
        $File =~ s{$Start}{}smx;
        $File =~ s{^/(.*)$}{$1}smx;

        # ignore directories
        next FILE if $File =~ m{^doc/}smx;
        next FILE if $File =~ m{^var/tmp/}smx;
        next FILE if $File =~ m{^var/log/}smx;
        next FILE if $File =~ m{^var/article/}smx;
        next FILE if $File =~ m{/js-cache/}smx;
        next FILE if $File =~ m{/css-cache/}smx;

        # generated the MD5 checksum
        my $Digest;
        {
            open my $In, '<', $OrigFile or die "ERROR: $!";    ## no critic qw(OTOBO::ProhibitOpen OTOBO::ProhibitLowPrecedenceOps)
            my $DigestGenerator = Digest::MD5->new();
            $DigestGenerator->addfile($In);
            $Digest = $DigestGenerator->hexdigest;
            close $In;
        }

        if ( $Action eq 'create' ) {
            print $Output $Digest . '::' . $File . "\n";
        }
        else {
            if ( !$Compare{$File} ) {
                print "Notice: New $File\n";
            }
            elsif ( $Compare{$File} ne $Digest && !-e "$File.save" ) {    ## ignore files with .save
                print "Notice: Dif $File\n";
            }
            elsif ( -e "$File.save" )
            {                                                             ## report .save files as modified by the OTOBO Package Manager
                print "Notice: OPM Changed $File\n";
            }
            if ( defined $Compare{$File} ) {
                delete $Compare{$File};
            }
        }
    }

    return 1;
}
