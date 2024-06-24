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

package Kernel::System::Log;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Require)
## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;

# core modules
use Carp ();
use Try::Tiny;

# CPAN modules
use DateTime 1.08 ();
use DateTime::Locale ();

# OTOBO modules

# Inform the object manager about the hard dependencies.
# This module must be discarded when one of the hard dependencies has been discarded.
our @ObjectDependencies = (
    'Kernel::Config',
);

# Inform the CodePolicy about the soft dependencies that are intentionally not in @ObjectDependencies.
# Soft dependencies are modules that used by this object, but who don't affect the state of this object.
# There is no need to discard this module when one of the soft dependencies is discarded.
our @SoftObjectDependencies = (
    'Kernel::System::Encode',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::Log - global log interface

=head1 DESCRIPTION

All log functions.

=head1 PUBLIC INTERFACE

=head2 new()

create a log object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'InstallScriptX',  # not required, but highly recommend
        },
    );
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

=cut

my %LogLevel = (
    error  => 16,
    notice => 8,
    info   => 4,
    debug  => 2,
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless { IPC => 0 }, $Type;

    if ( !$Kernel::OM ) {
        Carp::confess('$Kernel::OM is not defined, please initialize your object manager');
    }

    # extract some values from the config
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Needed for determining the log time. Trust that the OTOBO time zone is set to a sensible value.
    # The default, both here and in Framework.xml, is UTC.
    $Self->{OTOBOTimeZone} = $ConfigObject->Get('OTOBOTimeZone') || 'UTC';

    # get system id
    my $SystemID = $ConfigObject->Get('SystemID');

    # check log prefix
    $Self->{LogPrefix} = $Param{LogPrefix} || '?LogPrefix?';
    $Self->{LogPrefix} .= '-' . $SystemID;

    # configured log level (debug by default)
    # Setting an unknown MinimumLogLevel effectively turns off logging altogether.
    my $MinLevel = lc( $ConfigObject->Get('MinimumLogLevel') || 'debug' );
    $Self->{MinimumLevelNum} = $LogLevel{$MinLevel};

    # load log backend, rethrow exception when there is an error
    my $GenericModule = $ConfigObject->Get('LogModule') || 'Kernel::System::Log::SysLog';
    try {
        my $FileName = "$GenericModule.pm" =~ s{::}{/}smxgr;

        require $FileName;
    }
    catch {
        die "Can't load log backend module $GenericModule! $_";
    };

    # create backend handle
    $Self->{Backend} = $GenericModule->new(
        %Param,
    );

    # The code has hardcoded values for the flags passed to shmget(). Therefore
    # there is no need to load IPC::SysV. Using the availablity of IPC::SysV as an indicator
    # whether shmget() works is not a good idea. IPC::SysV is a core module.
    # TODO: actually use the constants from IPC::SysV.
    #return $Self unless eval 'require IPC::SysV';

    # Setup IPC for shared access to the last log entries.
    my $IPCKey = '444423' . $SystemID;    # This name is used to identify the shared memory segment.
    $Self->{IPCSize} = $ConfigObject->Get('LogSystemCacheSize') || 32 * 1024;

    # Create/access shared memory segment.
    # In environments with strict security access to shmget() and shmctl() may be blocked. In those cases
    # the functions would return undef.
    #
    # The flags are bit based and oct 1777 indicates that the first nine bits set.
    # The bits 0-7, that is oct 777, indicate full access for everybody.
    # Bit 8, that is oct 1000, aka IPC_CREAT, and it indicates that a new segment
    # is allocated when there isn't one already.
    # Bit 9, that is oct 2000, aka IPC_EXCL is not set. It would mandate exclusive use.
    # Altogether this means that an existing segment is reused, even when the Kernel::System::Log
    # object is recreated.
    #
    # Note that 0 is a valid shared memory segment ID. In Docker containers it happens regularly that
    # the segment used here is the first allocated segment with the ID 0.
    my $Flags = oct 1777;
    $Self->{IPCSHMSegment} = shmget $IPCKey, $Self->{IPCSize}, $Flags;

    # Try somethin more gentle when the direct creation failesy. First allocate a small segment first and then reset/resize it.
    if ( !defined $Self->{IPCSHMSegment} ) {

        $Self->{IPCSHMSegment} = shmget $IPCKey, 1, $Flags;

        # But even the allocation of only a small segment might fail. In this case
        # let's proceed without IPC.
        return $Self unless defined $Self->{IPCSHMSegment};

        if ( !shmctl $Self->{IPCSHMSegment}, 0, 0 ) {

            # $Self is not completely constructed, but already in an usable state.
            # So we can already use it for logging.
            $Self->Log(
                Priority => 'error',
                Message  => "Can't remove shm for log: $!",
            );

            # Continue without IPC.
            return $Self;
        }

        # Try again to allocate the shared memory segment.
        $Self->{IPCSHMSegment} = shmget $IPCKey, $Self->{IPCSize}, $Flags;

        # The gently approach failed so, so we give up and continue without IPC.
        return $Self unless defined $Self->{IPCSHMSegment};
    }

    # Only flag IPC as active if everything worked well.
    $Self->{IPC} = 1;

    return $Self;
}

=head2 Log()

log something. log priorities are 'debug', 'info', 'notice' and 'error'.

These are mapped to the SysLog priorities. Please use the appropriate priority level:

=over

=item debug

Debug-level messages; info useful for debugging the application, not useful during operations.

=item info

Informational messages; normal operational messages - may be used for reporting etc, no action required.

=item notice

Normal but significant condition; events that are unusual but not error conditions, no immediate action required.

=item error

Error conditions. Non-urgent failures, should be relayed to developers or administrators, each item must be resolved.

=back

See for more info L<http://en.wikipedia.org/wiki/Syslog#Severity_levels>

    $LogObject->Log(
        Priority => 'error',
        Message  => "Need something!",
    );

=cut

sub Log {
    my ( $Self, %Param ) = @_;

    my $Priority    = lc $Param{Priority}  || 'debug';
    my $PriorityNum = $LogLevel{$Priority} || $LogLevel{debug};

    return 1 if $PriorityNum < $Self->{MinimumLevelNum};

    my $Message = $Param{MSG}    || $Param{Message} || '???';
    my $Caller  = $Param{Caller} || 0;

    # returns the context of the current subroutine and sub-subroutine!
    my ( undef, undef, $Line1, undef ) = caller( $Caller + 0 );
    my ( undef, undef, undef, $Subroutine2 ) = caller( $Caller + 1 );

    $Subroutine2 ||= $0;

    # log backend
    $Self->{Backend}->Log(
        Priority  => $Priority,
        Message   => $Message,
        LogPrefix => $Self->{LogPrefix},
        Module    => $Subroutine2,
        Line      => $Line1,
    );

    # Get current timestamp while honoring the OTOBO time zone.
    # The reason why Kernel::System::DateTime is not used here, is that there were infinite loops
    # during global destruction.
    # See https://github.com/RotherOSS/otobo/issues/1099
    my $LogTime;
    if ( $Self->{OTOBOTimeZone} eq 'UTC' ) {

        # This is the regular case. The value is always in English and not locale dependent.
        # E.g. 'Sat Jul 17 09:25:15 2021'
        $LogTime = gmtime;
    }
    else {

        # honor the non-UTC OTOBO time zone

        # It is not obvious why we can't simply use something like:
        #{
        #    local $ENV{TZ} = $Self->{OTOBOTimeZone};
        #    # calling POSIX::tzset() only necessary up to Perl 5.8.9, https://perldoc.perl.org/5.8.9/perldelta
        #    $LogTime = localtime;
        #}

        # This code has been extracted from Kernel::System::DateTime::ToCTimeString().
        # Use English abbreviation for the day of the week and for the month.
        my $Locale = DateTime::Locale->load('en_US');

        # replicate the ctime format
        my $Format = '%a %b %{day} %H:%M:%S %Y';

        # Create object with current date/time and format it.
        $LogTime = try {
            DateTime->now(
                time_zone => $Self->{OTOBOTimeZone},
                locale    => $Locale,
            )->strftime($Format);
        }
        catch {

            # Ignore errors when DateTime has problems and fall back to UTC.
            # A string is given back as gmtime is evaluated in scalar context.
            gmtime;
        };
    }

    # if error, write it to STDERR
    if ( $Priority =~ m/^error/i ) {

        my $Error = sprintf "ERROR: $Self->{LogPrefix} Perl: %vd OS: $^O Time: "
            . $LogTime . "\n\n", $^V;
        $Error .= " Message: $Message\n\n";

        # More info when we are in a web context.
        # But don't try to get an object when we are already in global destruction.
        if ( $ENV{GATEWAY_INTERFACE} && ${^GLOBAL_PHASE} ne 'DESTRUCT' ) {

            my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
            my $RemoteAddr  = $ParamObject->RemoteAddr() || '-';
            my $RequestURI  = $ParamObject->RequestURI() || '-';

            $Error .= " RemoteAddress: $RemoteAddr\n";
            $Error .= " RequestURI: $RequestURI\n\n";
        }

        $Error .= " Traceback ($$): \n";

        COUNT:
        for ( my $Count = 0; $Count < 30; $Count++ ) {

            my ( $Package1, undef, $Line1, undef ) = caller( $Caller + $Count );

            last COUNT unless $Line1;

            my ( undef, undef, $Line2, $Subroutine2 ) = caller( $Caller + 1 + $Count );

            # if there is no caller module use the file name
            $Subroutine2 ||= $0;

            # print line if upper caller module exists
            my $VersionString = try {
                $Package1->VERSION || '';
            }
            catch {
                '';    # ignore exception, set version string to the empty string
            };

            # version is present
            if ($VersionString) {
                $VersionString = ' (v' . $VersionString . ')';
            }

            $Error .= "   Module: $Subroutine2$VersionString Line: $Line1\n";

            # shorten the traceback, exclude the Plack app and middleware before HTTPExceptions
            last COUNT if $Subroutine2 =~ m/^Plack::Middleware::HTTPExceptions::try/;

            last COUNT unless $Line2;
        }

        $Error .= "\n";

        # TODO: this should probably be the PSGI error filehandle
        print STDERR $Error;

        # store data (for the frontend)
        $Self->{error}->{Message}   = $Message;
        $Self->{error}->{Traceback} = $Error;
    }

    # remember to info and notice messages
    elsif ( lc $Priority eq 'info' || lc $Priority eq 'notice' ) {
        $Self->{ lc $Priority }->{Message} = $Message;
    }

    # Prepend the current log line to the shared memory segment.
    # The oldest log lines might fall out of the window.
    # shmwrite() might append "\0" bytes for padding.
    # Encode the string as UTF-8, as since Perl 5.34 shmwrite() implicitly calls utf8::downgrade().
    if ( lc $Priority ne 'debug' && $Self->{IPC} ) {

        $Priority = lc $Priority;

        my $LogLine   = join ';;', $LogTime, $Priority, $Self->{LogPrefix}, $Message;
        my $OldString = $Self->GetLog();
        my $NewString = join "\n", $LogLine, $OldString;
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$NewString );
        shmwrite( $Self->{IPCSHMSegment}, $NewString, 0, $Self->{IPCSize} ) || die $!;
    }

    return 1;
}

=head2 GetLogEntry()

to get the last log info back

    my $Message = $LogObject->GetLogEntry(
        Type => 'error', # error|info|notice
        What => 'Message', # Message|Traceback
    );

=cut

sub GetLogEntry {
    my ( $Self, %Param ) = @_;

    return $Self->{ lc $Param{Type} }->{ $Param{What} } || '';
}

=head2 GetLog()

to get the tmp log data (from shared memory - ipc) in csv form

    my $CSVLog = $LogObject->GetLog();

=cut

sub GetLog {
    my ( $Self, %Param ) = @_;

    my $String = '';
    if ( $Self->{IPC} ) {
        shmread( $Self->{IPCSHMSegment}, $String, 0, $Self->{IPCSize} ) || die "$!";
    }

    # Remove \0 bytes that shmwrite adds for padding.
    $String =~ s{\0}{}smxg;

    # the string is UTF-8 encoded, decode it (even though the method is called EncodeInput)
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$String );

    return $String;
}

=head2 CleanUp()

to clean up tmp log data from shared memory (ipc)

    $LogObject->CleanUp();

=cut

sub CleanUp {
    my ( $Self, %Param ) = @_;

    return 1 unless $Self->{IPC};

    shmwrite( $Self->{IPCSHMSegment}, '', 0, $Self->{IPCSize} ) || die $!;

    return 1;
}

=head2 Dumper()

dump a perl variable to log

    $LogObject->Dumper(@Array);

    or

    $LogObject->Dumper(%Hash);

=cut

sub Dumper {
    my ( $Self, @Data ) = @_;

    require Data::Dumper;    ## no critic qw(Modules::ProhibitEvilModules)

    # returns the context of the current subroutine and sub-subroutine!
    my ( undef, undef, $Line1, undef ) = caller(0);
    my ( undef, undef, undef, $Subroutine2 ) = caller(1);

    $Subroutine2 ||= $0;

    # log backend
    $Self->{Backend}->Log(
        Priority  => 'debug',
        Message   => substr( Data::Dumper::Dumper(@Data), 0, 600600600 ),
        LogPrefix => $Self->{LogPrefix},
        Module    => $Subroutine2,
        Line      => $Line1,
    );

    return 1;
}

1;
