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

package Kernel::System::PostMaster::LoopProtection::FS;

use strict;
use warnings;

use parent 'Kernel::System::PostMaster::LoopProtectionCommon';

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
);

sub new {
    my ( $Type, %Param ) = @_;
    my $Self = $Type->SUPER::new(%Param);

    $Self->{LoopProtectionLog} = $Kernel::OM->Get('Kernel::Config')->Get('LoopProtectionLog')
        || die 'No Config option "LoopProtectionLog"!';
    $Self->{LoopProtectionLog} .= '-' . $Self->{LoopProtectionDate} . '.log';

    return $Self;
}

sub SendEmail {
    my ( $Self, %Param ) = @_;

    my $To = $Param{To} || return;

    # write log

    if ( open( my $Out, '>>', $Self->{LoopProtectionLog} ) ) {    ## no critic qw(OTOBO::ProhibitOpen)
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        print $Out "$To;" . $DateTimeObject->Format( Format => '%a %b %{day} %H:%M:%S %Y' ) . ";\n";
        close $Out;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "LoopProtection! Can't write '$Self->{LoopProtectionLog}': $!!",
        );
    }

    return 1;
}

sub Check {
    my ( $Self, %Param ) = @_;

    my $To    = $Param{To} || return;
    my $Count = 0;

    # check existing logfile

    if ( !open( my $In, '<', $Self->{LoopProtectionLog} ) ) {    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)

        # create new log file
        if ( !open( my $Out, '>', $Self->{LoopProtectionLog} ) ) {    ## no critic qw(OTOBO::ProhibitOpen)
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "LoopProtection! Can't write '$Self->{LoopProtectionLog}': $!!",
            );
        }
        else {
            close $Out;
        }
    }
    else {

        # open old log file
        while ( my $Line = <$In> ) {
            my @Data = split /;/, $Line;
            if ( $Data[0] eq $To ) {
                $Count++;
            }
        }
        close($In);
    }

    # check possible loop
    my $Max = $Self->{PostmasterMaxEmailsPerAddress}{ lc $To } // $Self->{PostmasterMaxEmails};

    if ( $Max && $Count >= $Max ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "LoopProtection: send no more emails to '$To'! Max. count of $Self->{PostmasterMaxEmails} has been reached!",
        );
        return;
    }

    return 1;
}

1;
