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

package Kernel::System::PostMaster::Filter::CMD;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get parser object
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config options
    my %Config;
    my @Set;
    if ( $Param{JobConfig} && ref( $Param{JobConfig} ) eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };

        if ( IsArrayRefWithData( $Config{Set} ) ) {
            @Set = @{ $Config{Set} };
        }
        elsif ( IsHashRefWithData( $Config{Set} ) ) {

            for my $Key ( sort keys %{ $Config{Set} } ) {
                push @Set, {
                    Key   => $Key,
                    Value => $Config{Set}->{$Key},
                };
            }
        }
    }

    # check CMD config param
    if ( !$Config{CMD} ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::CMD',
            Value         => "Need CMD config option in PostMaster::PreFilterModule job!",
        );
        return;
    }

    # execute prog
    my $TmpFile = $Kernel::OM->Get('Kernel::Config')->Get('TempDir') . "/PostMaster.Filter.CMD.$$";

    if ( open my $Prog, '|-', "$Config{CMD} > $TmpFile" ) {    ## no critic qw(OTOBO::ProhibitOpen)
        print $Prog $Self->{ParserObject}->GetPlainEmail();
        close $Prog;
    }

    if ( -s $TmpFile ) {
        open my $In, '<', $TmpFile;                            ## no critic qw(OTOBO::ProhibitOpen)
        my $Ret = <$In>;
        close $In;

        # set new params
        for my $SetItem (@Set) {
            my $Key   = $SetItem->{Key};
            my $Value = $SetItem->{Value};

            $Param{GetParam}->{$Key} = $Value;

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::Filter::CMD',
                Value         =>
                    "Set param '$Key' to '$Value' because of '$Ret' (Message-ID: $Param{GetParam}->{'Message-ID'})",
            );
        }
    }

    unlink $TmpFile;

    return 1;
}

1;
