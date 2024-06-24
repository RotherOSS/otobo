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

package Kernel::System::VirtualFS::FS;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get data dir
    $Self->{DataDir}    = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/virtualfs';
    $Self->{Permission} = '660';

    # create data dir
    if ( !-d $Self->{DataDir} ) {
        mkdir $Self->{DataDir} || die $!;
    }

    # check write permissions
    if ( !-w $Self->{DataDir} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Can't write $Self->{DataDir}! try: \$OTOBO_HOME/bin/otobo.SetPermissions.pl!",
        );
        die "Can't write $Self->{DataDir}! try: \$OTOBO_HOME/bin/otobo.SetPermissions.pl!";
    }

    # config (not used right now)
    $Self->{Compress} = 0;
    $Self->{Crypt}    = 0;

    return $Self;
}

sub Read {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(BackendKey Mode)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my $Attributes = $Self->_BackendKeyParse(%Param);

    my $Content = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Directory => $Self->{DataDir} . $Attributes->{DataDir},
        Filename  => $Attributes->{Filename},
        Mode      => $Param{Mode},
    );

    # uncompress (in case)
    if ( $Attributes->{Compress} ) {

        # $Content = ...
    }

    # decrypt (in case)
    if ( $Attributes->{Crypt} ) {

        # $Content = ...
    }

    return if !$Content;
    return $Content;
}

sub Write {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Content Filename Mode)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # compress (in case)
    if ( $Self->{Compress} ) {

        # $Param{Content} = ...
    }

    # crypt (in case)
    if ( $Self->{Crypt} ) {

        # $Param{Content} = ...
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $MD5 = $MainObject->FilenameCleanUp(
        Filename => $Param{Filename},
        Type     => 'MD5',
    );

    my $DataDir = '';
    my @Dirs    = $Self->_SplitDir( Filename => $MD5 );

    DIRECTORY:
    for my $Dir (@Dirs) {

        $DataDir .= '/' . $Dir;

        next DIRECTORY if -e $Self->{DataDir} . $DataDir;
        next DIRECTORY if mkdir $Self->{DataDir} . $DataDir;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't create $Self->{DataDir}$DataDir: $!",
        );

        return;
    }

    # write article to fs
    my $Filename = $MainObject->FileWrite(
        Directory  => $Self->{DataDir} . $DataDir,
        Filename   => $MD5,
        Mode       => $Param{Mode},
        Content    => $Param{Content},
        Permission => $Self->{Permission},
    );

    return if !$Filename;

    my $BackendKey = $Self->_BackendKeyGenerate(
        Filename => $Filename,
        DataDir  => $DataDir,
        Compress => $Self->{Compress},
        Crypt    => $Self->{Crypt},
        Mode     => $Param{Mode},
    );

    return $BackendKey;
}

sub Delete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{BackendKey} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $_!",
        );
        return;
    }

    my $Attributes = $Self->_BackendKeyParse(%Param);

    return $Kernel::OM->Get('Kernel::System::Main')->FileDelete(
        Directory => $Self->{DataDir} . $Attributes->{DataDir},
        Filename  => $Attributes->{Filename},
    );
}

sub _BackendKeyGenerate {
    my ( $Self, %Param ) = @_;

    my $BackendKey = '';
    for my $Key ( sort keys %Param ) {
        $BackendKey .= "$Key=$Param{$Key};";
    }

    return $BackendKey;
}

sub _BackendKeyParse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{BackendKey} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $_!",
        );
        return;
    }

    my @Pairs = split /;/, $Param{BackendKey};

    my %Attributes;
    for my $Pair (@Pairs) {
        my ( $Key, $Value ) = split /=/, $Pair;
        $Attributes{$Key} = $Value;
    }

    return \%Attributes;
}

sub _SplitDir {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Filename} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $_!",
        );
        return;
    }

    my @Dir;
    $Dir[0] = substr $Param{Filename}, 0, 2;
    $Dir[1] = substr $Param{Filename}, 2, 2;

    return ( $Dir[0], $Dir[1] );
}

1;
