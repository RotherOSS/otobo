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

package scripts::test::sample::GenericAgent::TestGenericAgent;

use strict;
use warnings;

our @ObjectDependencies = (
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Param{New}->{Location} ) {
        print STDERR "Need Location!\n";
        return;
    }

    # filename clean up
    $Param{New}->{Location} =~ s/\/\//\//g;

    # set open mode (if file exists, lock it on open, done by '+<')
    my $Exists;
    if ( -f $Param{New}->{Location} ) {
        $Exists = 1;
    }
    my $Mode = '>';
    if ($Exists) {
        $Mode = '+<';
    }
    if ( $Param{New}->{Mode} && $Param{New}->{Mode} =~ /^(utf8|utf\-8)/i ) {
        $Mode = '>:utf8';
        if ($Exists) {
            $Mode = '+<:utf8';
        }
    }

    # return if file can not open
    my $FH;
    if ( !open $FH, $Mode, $Param{New}->{Location} ) {
        print STDERR "Can't write '$Param{New}->{Location}': $!",
            return;
    }

    # lock file (Exclusive Lock)
    if ( !flock $FH, 2 ) {
        print STDERR "Can't lock '$Param{New}->{Location}': $!";
    }

    # empty file first (needed if file is open by '+<')
    truncate $FH, 0;

    # write file if content is not undef
    if ( defined ${ $Param{New}->{Content} } ) {
        print $FH ${ $Param{New}->{Content} };
    }

    # write empty file if content is undef
    else {
        print $FH '';
    }

    # close the file handle
    close $FH;

    return $Param{New}->{Location};
}

1;
