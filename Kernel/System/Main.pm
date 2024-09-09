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

package Kernel::System::Main;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Require)

# use v5.24; # ATTENTION, beware of https://metacpan.org/dist/perl/view/pod/perlunicode.pod#The-%22Unicode-Bug%22
use strict;
use warnings;
use namespace::autoclean;    # hide md5_hex, LOCK_SH, LOCK_EX, LOCK_NB, LOCK_UN, irand, IsStringWithData

# core modules
use Digest::MD5  qw(md5_hex);
use Data::Dumper qw(Dumper);    ## no critic qw(Modules::ProhibitEvilModules)
use File::stat   qw(stat);
use List::Util   qw(first);
use Fcntl        qw(:flock);    ## no perlimports
use Encode       qw(encode);

# CPAN modules
use Math::Random::Secure qw(irand);

# OTOBO modules
use Kernel::System::VariableCheck qw(IsStringWithData);

our @ObjectDependencies = (
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storable',
);

=encoding utf8

=head1 NAME

Kernel::System::Main - main object

=head1 DESCRIPTION

A collection of utility functions to:

=over 4

=item load modules

=item die

=item generate random strings

=item handle files

=back

=head1 PUBLIC INTERFACE

=head2 new()

create a new object. Do not use it directly, instead use:

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

=cut

sub new {
    my ( $Class, %Param ) = @_;

    # allocate a new empty hash for object
    return bless {}, $Class;
}

=head2 Require()

require/load a module

    my $Loaded = $MainObject->Require(
        'Kernel::System::Example',
        Silent => 1,                # optional, no log entry if module was not found
    );

=cut

sub Require {
    my ( $Self, $Module, %Param ) = @_;

    # check required params
    if ( !$Module ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need module!',
        );

        return;
    }

    eval {
        my $FileName = "$Module.pm" =~ s{::}{/}smxgr;
        require $FileName;
    };

    # Handle errors.
    if ($@) {

        if ( !$Param{Silent} ) {
            my $Message = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => $Message,
            );
        }

        return;
    }

    # indicate that the module could be loaded
    return 1;
}

=head2 RequireBaseClass()

Load a module and check whether the calling package is already a base class of the loaded package.
If not, add the calling package as a base class of the loaded package.
The check is necessary for persistent environments.

    my $Loaded = $MainObject->RequireBaseClass(
        'Kernel::System::Example',
    );

=cut

sub RequireBaseClass {
    my ( $Self, $Module ) = @_;

    # Load the module, if not already loaded.
    # Give up when the module can't be loaded.
    return unless $Self->Require($Module);

    my $CallingClass = caller(0);

    {
        no strict 'refs';    ## no critic (TestingAndDebugging::ProhibitNoStrict)

        # Check if the base class was already loaded.
        # This can happen in persistent environments as mod_perl (see bug#9686).
        return 1 if first { $_ eq $Module } @{"${CallingClass}::ISA"};

        push @{"${CallingClass}::ISA"}, $Module;
    }

    return 1;
}

=head2 Die()

to die

    $MainObject->Die('some message to die');

=cut

sub Die {
    my ( $Self, $Message ) = @_;

    $Message = $Message || 'Died!';

    # log message
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Caller   => 1,
        Priority => 'error',
        Message  => $Message,
    );

    exit;
}

=head2 FilenameCleanUp()

sanitizes file names for various use cases. The file name, which should be sanitized, is passed in the
argument C<Filename>.

The parameter C<NoFilenameClean> implements the no-op case and returns the unchanged parameter C<Filename>.

    # returns 'some_file_name & shutdown'
    my $Filename = $MainObject->FilenameCleanUp(
        Filename        => 'some_file_name & shutdown'
        Type            => 'Local',
        NoFilenameClean => 1,
    );

The different types of clean up are passed as the parameter C<Type>. Possible types are
'Local', 'Attachment', 'MD5', and 'S3'.  The case of the C<Type> parameter is not significant.
'Local' is assumed when the type is something else.

    # return 32 chars in the range 0..9 and a..f
    my $Filename = $MainObject->FilenameCleanUp(
        Filename => 'some:file.xml',
        Type     => 'MD5',
    );

=head3 MD5

For the type 'MD5' the MD5 sum of the file name is returned.

=head3 Attachment

For the type 'Attachment' the file name is made HTML safe.

=over 4

=item white space is trimmed

=item leading dots are eliminated

=item characters not in C<[\w\-+.#_]> are replaced by an underscore

=item enclosed alphanumerics are replaced by an underscore

=item Umlauts are replaced following the German convention

=item consecutive '-' are collapsed into a single '-'

=item characters are chopped until total length of 220 characters is reached

=back

=head3 Local and S3

When the type is 'Local' then the additional parameter C<NoReplace> is considered as well. When the
parameter is either not passed or not set to a true value, then all characters
not matching C< qr/[^\w\-+.#]/ > are replaced by an underscore. Not that C<\w> matches beyond the ASCII range,
see the character class XPosixWord for details,
L<https://perldoc.perl.org/perluniprops#Properties-accessible-through-%5Cp%7B%7D-and-%5CP%7B%7D>.

    my $Filename = $MainObject->FilenameCleanUp(
        Filename => 'me_to/alal.xml',
        Type     => 'Local',
    );

The Type 'S3' is like 'Local' with two differences. First, the option 'NoReplace' is always ignored. Secondly, the
characters B<+> and B<#> are also replaced by an underscore.

=cut

sub FilenameCleanUp {
    my ( $Self, %Param ) = @_;

    if ( !IsStringWithData( $Param{Filename} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename!',
        );

        return;
    }

    # Escape if cleaning up is not wanted.
    # This is used in FileWrite() when the exact filenname should be used.
    return $Param{Filename} if $Param{NoFilenameClean};

    my $Type = lc( $Param{Type} || 'local' );

    if ( $Type eq 'md5' ) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Filename} );

        return md5_hex( $Param{Filename} );
    }

    # replace invalid token for attachment file names
    if ( $Type eq 'attachment' ) {

        # trim whitespace
        $Param{Filename} =~ s/^\s+|\r|\n|\s+$//g;

        # strip leading dots
        $Param{Filename} =~ s/^\.+//;

        # only whitelisted characters allowed in filename for security
        $Param{Filename} =~ s/[^\w\-+.#_]/_/g;

        # Enclosed alphanumerics are kept on older Perl versions, make sure to replace them too.
        # ① - U+02460 - CIRCLED DIGIT ONE
        # ⓿ - U+024FF - NEGATIVE CIRCLED DIGIT ZERO
        $Param{Filename} =~ s/[\x{2460}-\x{24FF}]/_/g;

        # replace utf8 and iso
        $Param{Filename} =~ s/(\x{00C3}\x{00A4}|\x{00A4})/ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00B6}|\x{00B6})/oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{00BC}|\x{00FC})/ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00C4})/Ae/g;
        $Param{Filename} =~ s/(\x{00C3}\x{0096}|\x{0096})/Oe/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009C}|\x{009C})/Ue/g;
        $Param{Filename} =~ s/(\x{00C3}\x{009F}|\x{00DF})/ss/g;
        $Param{Filename} =~ s/-+/-/g;

        # separate filename and extension
        my $FileName = $Param{Filename};
        my $FileExt  = '';
        if ( $Param{Filename} =~ /(.*)\.+([^.]+)$/ ) {
            $FileName = $1;
            $FileExt  = '.' . $2;
        }

        if ( length $FileName ) {
            my $ModifiedName = $FileName . $FileExt;

            while ( length encode( 'UTF-8', $ModifiedName ) > 220 ) {

                # Remove character by character starting from the end of the filename string
                #   until we get acceptable 220 byte long filename size including extension.
                if ( length $FileName > 1 ) {
                    chop $FileName;
                }

                # If we reached minimum filename length, remove characters from the end of the extension string.
                else {
                    chop $FileExt;
                }

                $ModifiedName = $FileName . $FileExt;
            }
            $Param{Filename} = $ModifiedName;
        }

        return $Param{Filename};
    }

    # 'Local' or 'S3' or fallback for missing or unknown types

    # trim whitespace
    $Param{Filename} =~ s/^\s+|\r|\n|\s+$//g;

    # strip leading dots
    $Param{Filename} =~ s/^\.+//;

    # only whitelisted characters allowed in filename for security
    if ( $Type eq 's3' ) {

        # not that '+' and '#' are also replaced by '_'
        # no need to have '_' explicitly in the character class, as that case is covered by \w
        $Param{Filename} =~ s/[^\w\-.]/_/g;
    }
    elsif ( !$Param{NoReplace} ) {

        # 'Local' or fallback for missing or unknown types
        $Param{Filename} =~ s/[^\w\-+.#_]/_/g;

        # Enclosed alphanumerics are kept on older Perl versions, make sure to replace them too.
        # TODO: find out when the behavior has changed
        $Param{Filename} =~ s/[\x{2460}-\x{24FF}]/_/g;
    }

    # separate filename and extension
    my $FileName = $Param{Filename};
    my $FileExt  = '';
    if ( $Param{Filename} =~ /(.*)\.+([^.]+)$/ ) {
        $FileName = $1;
        $FileExt  = '.' . $2;
    }

    if ( length $FileName ) {
        my $ModifiedName = $FileName . $FileExt;

        while ( length encode( 'UTF-8', $ModifiedName ) > 220 ) {

            # Remove character by character starting from the end of the filename string
            #   until we get acceptable 220 byte long filename size including extension.
            if ( length $FileName > 1 ) {
                chop $FileName;
            }

            # If we reached minimum filename length, remove characters from the end of the extension string.
            else {
                chop $FileExt;
            }

            $ModifiedName = $FileName . $FileExt;
        }

        $Param{Filename} = $ModifiedName;
    }

    return $Param{Filename};
}

=head2 FileRead()

to read files from file system

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename  => 'file2read.txt',
        # or Location
        Location  => 'c:\some\location\file2read.txt',
    );

    my $ContentARRAYRef = $MainObject->FileRead(
        Directory => 'c:\some\location',
        Filename  => 'file2read.txt',
        # or Location
        Location  => 'c:\some\location\file2read.txt',

        Result    => 'ARRAY', # optional - SCALAR|ARRAY
    );

    my $ContentSCALARRef = $MainObject->FileRead(
        Directory       => 'c:\some\location',
        Filename        => 'file2read.txt',
        # or Location
        Location        => 'c:\some\location\file2read.txt',

        Mode            => 'binmode', # optional - binmode|utf8
        Type            => 'Local',   # optional - Local|Attachment|MD5
        Result          => 'SCALAR',  # optional - SCALAR|ARRAY
        DisableWarnings => 1,         # optional
    );

=cut

sub FileRead {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s{//}{/}xmsg;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );

    }

    # set open mode
    my $Mode = '<';
    if ( $Param{Mode} && $Param{Mode} =~ m{ \A utf-?8 \z }xmsi ) {
        $Mode = '<:utf8';
    }

    # return if file can not open
    my $FH;
    if ( !open $FH, $Mode, $Param{Location} ) {    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
        my $Error = $!;

        if ( !$Param{DisableWarnings} ) {

            # Check if file exists only if system was not able to open it (to get better error message).
            if ( !-e $Param{Location} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Location}' doesn't exist!",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't open '$Param{Location}': $Error",
                );
            }
        }
        return;
    }

    # lock file (Shared Lock)
    if ( !flock $FH, LOCK_SH ) {
        if ( !$Param{DisableWarnings} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't lock '$Param{Location}': $!",
            );
        }
    }

    # enable binmode
    if ( !$Param{Mode} || $Param{Mode} =~ m{ \A binmode }xmsi ) {
        binmode $FH;
    }

    # read file as array
    if ( $Param{Result} && $Param{Result} eq 'ARRAY' ) {

        # read file content at once
        my @Array = <$FH>;
        close $FH;

        return \@Array;
    }

    # read file as string
    my $String = do { local $/; <$FH> };    ## no critic qw(Variables::RequireInitializationForLocalVars)
    close $FH;

    return \$String;
}

=head2 FileWrite()

to write data to file system

    my $FileLocation = $MainObject->FileWrite(
        Directory => 'c:\some\location',
        Filename  => 'file2write.txt',
        # or Location
        Location  => 'c:\some\location\file2write.txt',

        Content   => \$Content,
    );

    my $FileLocation = $MainObject->FileWrite(
        Directory  => 'c:\some\location',
        Filename   => 'file2write.txt',
        # or Location
        Location   => 'c:\some\location\file2write.txt',

        Content    => \$Content,
        Mode       => 'binmode', # binmode|utf8
        Type       => 'Local',   # optional - Local|Attachment|MD5
        Permission => '644',     # optional - unix file permissions
        Parents    => (1|0),     # optional - create parent directories if neccessary, default 0
                                 #      does only take effect if Directory and Filename are provided
    );

Platform note: MacOS (HFS+) stores filenames as Unicode C<NFD> internally,
and DirectoryRead() will also report them as C<NFD>.

=cut

sub FileWrite {
    my ( $Self, %Param ) = @_;

    $Param{Parents} = $Param{Parents} ? 1 : 0;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename        => $Param{Filename},
            Type            => $Param{Type} || 'Local',    # Local|Attachment|MD5
            NoFilenameClean => $Param{NoFilenameClean},
            NoReplace       => $Param{NoReplace},
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";

        # create directory structure if neccessary and allowed
        if ( $Param{Parents} && !-d $Param{Directory} ) {

            # create directory
            File::Path::mkpath( $Param{Directory}, 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

            if ( !-d $Param{Directory} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't create directory '$Param{Directory}': $!",
                );
                return;
            }
        }
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );
    }

    # set open mode (if file exists, lock it on open, done by '+<')
    my $Exists = -f $Param{Location} ? 1    : 0;
    my $Mode   = $Exists             ? '+<' : '>';
    if ( $Param{Mode} && $Param{Mode} =~ m/^(utf8|utf\-8)/i ) {
        $Mode = $Exists ? '+<:utf8' : '>:utf8';
    }

    # return if file can not open
    my $FH;
    if ( !open $FH, $Mode, $Param{Location} ) {    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't write '$Param{Location}': $!",
        );

        return;
    }

    # lock file (Exclusive Lock)
    if ( !flock $FH, LOCK_EX ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't lock '$Param{Location}': $!",
        );
    }

    # empty file first (needed if file is open by '+<')
    truncate $FH, 0;

    # enable binmode
    if ( !$Param{Mode} || lc $Param{Mode} eq 'binmode' ) {

        # make sure, that no utf8 stamp exists (otherway perl will do auto convert to iso)
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( $Param{Content} );

        # set file handle to binmode
        binmode $FH;
    }

    # write file if content is not undef
    if ( defined $Param{Content}->$* ) {
        print $FH $Param{Content}->$*;
    }

    # write empty file if content is undef
    else {
        print $FH '';
    }

    # close the filehandle
    close $FH;

    # set permission
    if ( $Param{Permission} ) {
        if ( length $Param{Permission} == 3 ) {
            $Param{Permission} = "0$Param{Permission}";
        }
        chmod oct( $Param{Permission} ), $Param{Location};
    }

    return $Param{Filename} if $Param{Filename};
    return $Param{Location};
}

=head2 FileDelete()

to delete a file from file system

    my $Success = $MainObject->FileDelete(
        Directory       => 'c:\some\location',
        Filename        => 'me_to/alal.xml',
        # or Location
        Location        => 'c:\some\location\me_to\alal.xml'

        Type            => 'Local',   # optional - Local|Attachment|MD5
        DisableWarnings => 1, # optional
    );

=cut

sub FileDelete {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename  => $Param{Filename},
            Type      => $Param{Type} || 'Local',    # Local|Attachment|MD5
            NoReplace => $Param{NoReplace},
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s/\/\//\//g;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );
    }

    # try to delete file
    if ( !unlink( $Param{Location} ) ) {
        my $Error = $!;

        if ( !$Param{DisableWarnings} ) {

            # Check if file exists only in case that delete failed.
            if ( !-e $Param{Location} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Location}' doesn't exist!",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't delete '$Param{Location}': $Error",
                );
            }
        }

        return;
    }

    return 1;
}

=head2 FileGetMTime()

get epoch of file change time

    # specify either Directory and Filename
    my $FileMTime = $MainObject->FileGetMTime(
        Directory => '/some/location',
        Filename  => 'me_to/alal.xml',
    );

    # or Location
    my $FileMTime = $MainObject->FileGetMTime(
        Location  => '/some/location/me_to/alal.xml'
    );

=cut

sub FileGetMTime {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s{//}{/}xmsg;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );
    }

    # get file metadata
    my $Stat = stat $Param{Location};

    if ( !$Stat ) {
        my $Error = $!;

        if ( !$Param{DisableWarnings} ) {

            # Check if file exists only if system was not able to open it (to get better error message).
            if ( !-e $Param{Location} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Location}' doesn't exist!"
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Cannot stat file '$Param{Location}': $Error",
                );
            }
        }

        return;
    }

    return $Stat->mtime;
}

=head2 GetReleaseInfo()

extract the Product and Version from a RELEASE file

    # specify either Directory and Filename
    my $ReleaseInfo = $MainObject->GetReleaseInfo(
        Directory => '/opt/otobo',
        Filename  => 'RELEASE',
    );

    # or Location
    my $ReleaseInfo = $MainObject->GetReleaseInfo(
        Location  => '/opt/otobo/RELEASE'
    );

The returned value is a hashref. There are two possible keys: B<Product> and B<Version>.
The keys are only set when they are found in the release file.

=cut

sub GetReleaseInfo {
    my ( $Self, %Param ) = @_;

    if ( $Param{Filename} && $Param{Directory} ) {

        # filename clean up
        $Param{Filename} = $Self->FilenameCleanUp(
            Filename => $Param{Filename},
            Type     => $Param{Type} || 'Local',    # Local|Attachment|MD5
        );
        $Param{Location} = "$Param{Directory}/$Param{Filename}";
    }
    elsif ( $Param{Location} ) {

        # filename clean up
        $Param{Location} =~ s{//}{/}xmsg;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename and Directory or Location!',
        );

        return {};
    }

    if ( open( my $ReleaseFH, '<', $Param{Location} ) ) {    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)

        # extract the release info from the file content
        my %ReleaseInfo;
        LINE:
        while ( my $Line = <$ReleaseFH> ) {

            # filtering of comment lines
            next LINE if $Line =~ m/^#/;

            if ( $Line =~ m/^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                $ReleaseInfo{Product} = $1;
            }
            elsif ( $Line =~ m/^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                $ReleaseInfo{Version} = $1;
            }

            # all other lines are ignored
        }

        return \%ReleaseInfo;
    }

    # log error when the file could not be read
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Could not open $Param{Location} for reading.",
    );

    return {};
}

=head2 MD5sum()

get an C<MD5> sum of a file or a string

    my $MD5Sum = $MainObject->MD5sum(
        Filename => '/path/to/me_to_alal.xml',
    );

    my $MD5Sum = $MainObject->MD5sum(
        String => \$SomeString,
    );

    # note: needs more memory!
    my $MD5Sum = $MainObject->MD5sum(
        String => $SomeString,
    );

=cut

sub MD5sum {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Filename} && !defined( $Param{String} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Filename or String!',
        );
        return;
    }

    # md5sum file
    if ( $Param{Filename} ) {

        # open file
        my $FH;
        if ( !open $FH, '<', $Param{Filename} ) {    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)
            my $Error = $!;

            # Check if file exists only if system was not able to open it (to get better error message).
            if ( !-e $Param{Filename} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "File '$Param{Filename}' doesn't exist!",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't read '$Param{Filename}': $Error",
                );
            }
            return;
        }

        binmode $FH;
        my $MD5sum = Digest::MD5->new()->addfile($FH)->hexdigest();
        close $FH;

        return $MD5sum;
    }

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # md5sum string
    if ( !ref $Param{String} ) {
        $EncodeObject->EncodeOutput( \$Param{String} );
        return md5_hex( $Param{String} );
    }

    # md5sum scalar reference
    if ( ref $Param{String} eq 'SCALAR' ) {
        $EncodeObject->EncodeOutput( $Param{String} );
        return md5_hex( ${ $Param{String} } );
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Need a SCALAR reference like 'String => \$Content' in String param.",
    );

    return;
}

=head2 Dump()

serialize a data structure to a string in Data::Dumper format.
Strings are dumped in their internal format when no additional parameter,
or the additional parameter C<'binary'> is passed.

    my $Dump = $MainObject->Dump(
        $SomeVariable,
    );

is the same as

    my $Dump = $MainObject->Dump(
        $SomeVariable,
        'binary',
    );

Array and hash references are supported.

    my $Dump = $MainObject->Dump(
        {
            Key1 => $SomeVariable,
            Key2 => [qw(a list of words)],
        },
    );

When the extra parameter C<'ascii'> is passed, then the UTF-8 flag is not ignored when dumping strings.
Thus characters with code points > 127 will be dumped with escape codes. So C<'asdfÄÖÜ⛄'> will be Dumped as
C<$VAR1 = "asdf\x{c4}\x{d6}\x{dc}\x{26c4}";>.

    my $Dump = $MainObject->Dump(
        'asdfÄÖÜ⛄',
        'ascii',
    );

When a string, where the UTF8-flag is not set, contains bytes > 127, then the ascii-dump will also contain those
non-ASCII characters. This means that the option is misnamed.

=cut

sub Dump {
    my ( $Self, $Data, $Type ) = @_;

    # check needed data
    if ( !defined $Data ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need \$String in Dump()!"
        );
        return;
    }

    # apply default and check the parameter 'Type'
    $Type ||= 'binary';
    if ( $Type ne 'ascii' && $Type ne 'binary' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid Type '$Type'!"
        );
        return;
    }

    # mild pretty print
    $Data::Dumper::Indent = 1;

    # sort hash keys
    $Data::Dumper::Sortkeys = 1;

    # This Dump() is using Data::Dumper with a utf8 workarounds to handle
    # the bug [rt.cpan.org #28607] Data::Dumper::Dumper is dumping utf8
    # strings as latin1/8bit instead of utf8. Use Storable module used for
    # workaround.
    # -> http://rt.cpan.org/Ticket/Display.html?id=28607
    if ( $Type eq 'binary' ) {

        # Clone the data because we need to disable the utf8 flag in all
        # reference variables and do not to want to do this in the orig.
        # variables because they will still used in the system.
        my $DataNew = $Kernel::OM->Get('Kernel::System::Storable')->Clone( Data => \$Data );

        # Disable utf8 flag.
        $Self->_Dump($DataNew);

        # Dump it as binary strings.
        my $String = Dumper( ${$DataNew} );

        # Enable utf8 flag.
        Encode::_utf8_on($String);

        return $String;
    }

    # fallback if Storable can not be loaded
    return Dumper($Data);
}

=head2 DirectoryRead()

reads a directory and returns an array with results.

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/tmp',
        Filter    => 'Filenam*',
    );

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Path,
        Filter    => '*',
    );

read all files in subdirectories as well (recursive):

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Path,
        Filter    => '*',
        Recursive => 1,
    );

You can pass several additional filters at once:

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/tmp',
        Filter    => \@MyFilters,
    );

The result strings are absolute paths, and they are converted to utf8.

Use the 'Silent' parameter to suppress log messages when a directory
does not have to exist:

    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => '/special/optional/directory/',
        Filter    => '*',
        Silent    => 1,     # will not log errors if the directory does not exist
    );

Platform note: MacOS (HFS+) stores filenames as Unicode C<NFD> internally,
and DirectoryRead() will also report them as C<NFD>.

=cut

sub DirectoryRead {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Directory Filter)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed $Needed: $!",
                Priority => 'error',
            );
            return;
        }
    }

    # if directory doesn't exists stop
    if ( !-d $Param{Directory} && !$Param{Silent} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => "Directory doesn't exist: $Param{Directory}: $!",
            Priority => 'error',
        );
        return;
    }

    # check Filter param
    if ( ref $Param{Filter} ne '' && ref $Param{Filter} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => 'Filter param need to be scalar or array ref!',
            Priority => 'error',
        );
        return;
    }

    # prepare non array filter
    if ( ref $Param{Filter} ne 'ARRAY' ) {
        $Param{Filter} = [ $Param{Filter} ];
    }

    # executes glob for every filter
    my @GlobResults;
    my %Seen;

    for my $Filter ( @{ $Param{Filter} } ) {
        my @Glob = glob "$Param{Directory}/$Filter";

        # look for repeated values
        NAME:
        for my $GlobName (@Glob) {

            next NAME if !-e $GlobName;
            if ( !$Seen{$GlobName} ) {
                push @GlobResults, $GlobName;
                $Seen{$GlobName} = 1;
            }
        }
    }

    if ( $Param{Recursive} ) {

        # loop protection to prevent symlinks causing lockups
        $Param{LoopProtection}++;
        return if $Param{LoopProtection} > 100;

        # check all files in current directory
        my @Directories = glob "$Param{Directory}/*";

        DIRECTORY:
        for my $Directory (@Directories) {

            # return if file is not a directory
            next DIRECTORY if !-d $Directory;

            # repeat same glob for directory
            my @SubResult = $Self->DirectoryRead(
                %Param,
                Directory => $Directory,
            );

            # add result to hash
            for my $Result (@SubResult) {
                if ( !$Seen{$Result} ) {
                    push @GlobResults, $Result;
                    $Seen{$Result} = 1;
                }
            }
        }
    }

    # if no results
    return if !@GlobResults;

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # compose normalize every name in the file list
    my @Results;
    for my $Filename (@GlobResults) {

        # First convert filename to utf-8, with additional Check parameter
        # to replace possible malformed characters and prevent further errors.
        $Filename = $EncodeObject->Convert2CharsetInternal(
            Text  => $Filename,
            From  => 'utf-8',
            Check => 1,
        );

        push @Results, $Filename;
    }

    # always sort the result
    @Results = sort @Results;

    return @Results;
}

=head2 GenerateRandomString()

generate a random string of defined length, and of a defined alphabet.
Defaults to a length of 16 and alphanumerics ( 0..9, A-Z and a-z).

    my $String = $MainObject->GenerateRandomString();

returns

    $String = 'mHLOx7psWjMe5Pj7';

with specific length:

    my $String = $MainObject->GenerateRandomString(
        Length => 32,
    );

returns

    $String = 'azzHab72wIlAXDrxHexsI5aENsESxAO7';

with specific length and alphabet:

    my $String = $MainObject->GenerateRandomString(
        Length     => 32,
        Dictionary => [ 0..9, 'a'..'f' ], # hexadecimal
    );

returns

    $String = '9fec63d37078fe72f5798d2084fea8ad';


=cut

sub GenerateRandomString {
    my ( $Self, %Param ) = @_;

    # negative $Param{Length} produce an empty string
    # fractional $Param{Length} is truncated to the integer portion
    my $Length = $Param{Length} || 16;

    # The standard list of characters in the dictionary. Don't use special chars here.
    my @DictionaryChars = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );

    # override dictionary with custom list if given
    if ( $Param{Dictionary} && ref $Param{Dictionary} eq 'ARRAY' ) {
        @DictionaryChars = @{ $Param{Dictionary} };
    }

    # assuming that there are no dictionaries larger than 2^32
    my $DictionaryLength = scalar @DictionaryChars;

    # generate the string
    return join '', map { $DictionaryChars[ irand($DictionaryLength) ] } ( 1 .. $Length );
}

=begin Internal:

=cut

sub _Dump {
    my ( $Self, $Data ) = @_;

    # data is not a reference
    if ( !ref ${$Data} ) {
        Encode::_utf8_off( ${$Data} );

        return;
    }

    # data is a scalar reference
    if ( ref ${$Data} eq 'SCALAR' ) {

        # start recursion
        $Self->_Dump( ${$Data} );

        return;
    }

    # data is a hash reference
    if ( ref ${$Data} eq 'HASH' ) {
        KEY:
        for my $Key ( sort keys %{ ${$Data} } ) {
            next KEY if !defined ${$Data}->{$Key};

            # start recursion
            $Self->_Dump( \${$Data}->{$Key} );

            my $KeyNew = $Key;

            $Self->_Dump( \$KeyNew );

            if ( $Key ne $KeyNew ) {

                ${$Data}->{$KeyNew} = ${$Data}->{$Key};
                delete ${$Data}->{$Key};
            }
        }

        return;
    }

    # data is a array reference
    if ( ref ${$Data} eq 'ARRAY' ) {
        KEY:
        for my $Key ( 0 .. $#{ ${$Data} } ) {
            next KEY if !defined ${$Data}->[$Key];

            # start recursion
            $Self->_Dump( \${$Data}->[$Key] );
        }

        return;
    }

    # data is a ref reference
    if ( ref ${$Data} eq 'REF' ) {

        # start recursion
        $Self->_Dump( ${$Data} );

        return;
    }

    # data is a JSON::PP::Boolean
    if ( ref ${$Data} eq 'JSON::PP::Boolean' ) {

        # start recursion
        $Self->_Dump( ${$Data} );

        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Unknown ref '" . ref( ${$Data} ) . "'!",
    );

    return;
}

=end Internal:

=cut

1;
