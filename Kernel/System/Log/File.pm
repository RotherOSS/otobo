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

## nofilter(TidyAll::Plugin::OTOBO::Perl::Time)

package Kernel::System::Log::File;

use strict;
use warnings;

use File::Basename qw(basename dirname);
use File::Copy     qw(move);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get logfile location
    $Self->{LogFile} = $ConfigObject->Get('LogModule::LogFile')
        || die 'Need LogModule::LogFile param in Config.pm';

    # get log file suffix
    if ( $ConfigObject->Get('LogModule::LogFile::Date') ) {
        my ( $s, $m, $h, $D, $M, $Y, $WD, $YD, $DST ) = localtime( time() );
        $Y = $Y + 1900;
        $M = sprintf '%02d', ++$M;
        $Self->{LogFile} .= ".$Y-$M";
    }

    $Self->{AlreadyRotated} = 0;

    return $Self;
}

sub _RotateOtoboLog {

    my ( $Self, %Param ) = @_;

    # only rotate once per request
    return if $Self->{AlreadyRotated};

    $Self->{AlreadyRotated} = 1;

    # nothing to rotate if it does not exist yet
    return unless -e $Self->{LogFile};

    # only rotate if MaxSize sysconfig is set
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $MaxSize = $ConfigObject->Get('LogModule::LogFile::MaxSize');

    return unless $MaxSize;

    # rotate the logfile if size exceeds MaxSize setting
    my $LogFileSize = -s $Self->{LogFile};

    if ( $LogFileSize > $MaxSize ) {

        # rotate the otobo.log
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $DateTimeString = $DateTimeObject->Format( Format => '%Y-%m-%dT%H:%M:%S' );

        my $ArchivedLogFile = $Self->{LogFile} . "-$DateTimeString.rotated";

        move( $Self->{LogFile}, $ArchivedLogFile );

        # unlink rotated log files if number of rotated log files exceeds max

        my $LogDir   = dirname $Self->{LogFile};
        my @LogFiles = glob "$LogDir/*.rotated";

        # sort ascending, oldest rotated files are first
        @LogFiles = sort @LogFiles;

        my $MaxKeepRotated = $ConfigObject->Get('LogModule::LogFile::MaxKeepRotated');
        if ($MaxKeepRotated) {

            my $LogFilesCount = @LogFiles;

            if ( $LogFilesCount > $MaxKeepRotated ) {

                my $NumberOfLogFiles2Remove = $LogFilesCount - $MaxKeepRotated;

                # slice the array so we keep only the files to be rotated
                @LogFiles = @LogFiles[ 0 .. ( $NumberOfLogFiles2Remove - 1 ) ];

            }
            else {
                # do not unlink any rotated files
                @LogFiles = ();
            }
        }

        for my $LogFile (@LogFiles) {

            unlink $LogFile;
        }
    }

    return;
}

sub Log {
    my ( $Self, %Param ) = @_;

    $Self->_RotateOtoboLog();

    my $FH;

    # open logfile
    if ( !open $FH, '>>', $Self->{LogFile} ) {    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
                                                  # print error screen
        print STDERR "\n";
        print STDERR " >> Can't write $Self->{LogFile}: $! <<\n";
        print STDERR "\n";

        return;
    }

    # write log file
    $Kernel::OM->Get('Kernel::System::Encode')->ConfigureOutputFileHandle( FileHandle => $FH );

    print $FH '[' . localtime() . ']';

    if ( lc $Param{Priority} eq 'debug' ) {
        print $FH "[Debug][$Param{Module}][$Param{Line}] $Param{Message}\n";
    }
    elsif ( lc $Param{Priority} eq 'info' ) {
        print $FH "[Info][$Param{Module}] $Param{Message}\n";
    }
    elsif ( lc $Param{Priority} eq 'notice' ) {
        print $FH "[Notice][$Param{Module}] $Param{Message}\n";
    }
    elsif ( lc $Param{Priority} eq 'error' ) {
        print $FH "[Error][$Param{Module}][$Param{Line}] $Param{Message}\n";
    }
    else {

        # print error messages to STDERR
        print STDERR
            "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";

        # and of course to logfile
        print $FH
            "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";
    }

    # close file handle
    close $FH;

    return 1;
}

1;
