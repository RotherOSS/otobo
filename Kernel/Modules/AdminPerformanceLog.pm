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

package Kernel::Modules::AdminPerformanceLog;

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # is performance log disabled?
    if ( !$ConfigObject->Get('PerformanceLog') ) {
        $LayoutObject->Block(
            Name => 'Disabled',
            Data => { %Param, },
        );

        # create & return output
        return join '',
            $LayoutObject->Header(),
            $LayoutObject->NavigationBar(),
            $LayoutObject->Output(
                TemplateFile => 'AdminPerformanceLog',
                Data         => \%Param,
            ),
            $LayoutObject->Footer();
    }

    $LayoutObject->Block(
        Name => 'Enabled',
        Data => { %Param, },
    );

    # reset log file
    if ( $Self->{Subaction} eq 'Reset' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        if ( !$Self->_DatabaseReset() ) {
            $LayoutObject->FatalError();
        }
        else {

            # redirect
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action}",
            );
        }
    }

    # show detail view
    elsif ( $Self->{Subaction} eq 'View' ) {

        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionOverview' );

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
        my %Action;
        my $MaxRequest = 0;
        my $MinuteSlot = $ParamObject->GetParam( Param => 'Minute' );
        $Param{Minute} = $MinuteSlot;
        my $Interface = $ParamObject->GetParam( Param => 'Interface' );
        my $Module    = $ParamObject->GetParam( Param => 'Module' );

        my $Slot = 60;    # aggregate by 1 h when showing long long periods
        if ( $MinuteSlot < 31 ) {
            $Slot = 1;    # aggregate by 1 m when showing only the last half hour
        }
        elsif ( $MinuteSlot < 61 ) {
            $Slot = 2;    # aggregate by 2 m
        }
        elsif ( $MinuteSlot < 121 ) {
            $Slot = 5;    # aggregate by 5 m
        }
        elsif ( $MinuteSlot < 1141 ) {
            $Slot = 30;    # aggregate by half hour
        }
        my $Data = $Self->_DatabaseRead();
        $LayoutObject->Block(
            Name => 'View',
            Data => {
                Age => $LayoutObject->CustomerAge(
                    Age   => $MinuteSlot * 60,
                    Space => ' '
                ),
                Interface => $Interface || '-',
                Module    => $Module    || '-',
                Period    => $Slot,
            },
        );

        $Param{Age} = $LayoutObject->CustomerAge(
            Age   => $MinuteSlot * 60,
            Space => ' '
        );
        $Param{Interface} = $Interface;
        $Param{Module}    = $Module;

        # Collect data per aggregation slot
        my $Minute = 0;
        my $Count  = 1;
        while ( $Count <= $MinuteSlot ) {
            ROW:
            for my $Row ( reverse @{$Data} ) {
                if (
                    $Row->[0] < ( time() - ( 60 * $Minute ) )
                    && $Row->[0] > ( time() - ( 60 * ( $Minute + $Slot ) ) )
                    )
                {

                    # for each action
                    my $ModuleCurrent = '';
                    if ( $Row->[4] =~ /^(.+?|)Action=(.+?)(&.*|)$/ ) {
                        $ModuleCurrent = $2;
                        if ( $Row->[4] =~ /Subaction=(.+?)(&.*|)$/ ) {
                            $ModuleCurrent .= '&' . $1;
                        }
                        if ($Interface) {
                            if ( !$Module && $Row->[1] ne $Interface ) {
                                next ROW;
                            }
                            if ( $Module && $Module ne $ModuleCurrent ) {
                                next ROW;
                            }
                        }

                        $Action{$Minute}->{Count}++;
                        if ( $MaxRequest < $Action{$Minute}->{Count} ) {
                            $MaxRequest = $Action{$Minute}->{Count};
                        }
                        if ( $Action{$Minute}->{Sum} ) {
                            $Action{$Minute}->{Sum} = $Action{$Minute}->{Sum} + $Row->[2];
                        }
                        else {
                            $Action{$Minute}->{Sum} = $Row->[2];
                        }
                        if ( !defined( $Action{$Minute}->{Max} ) ) {
                            $Action{$Minute}->{Max} = $Row->[2];
                        }
                        elsif ( $Action{$Minute}->{Max} < $Row->[2] ) {
                            $Action{$Minute}->{Max} = $Row->[2];
                        }
                        if ( !defined( $Action{$Minute}->{Min} ) ) {
                            $Action{$Minute}->{Min} = $Row->[2];
                        }
                        elsif ( $Action{$Minute}->{Min} > $Row->[2] ) {
                            $Action{$Minute}->{Min} = $Row->[2];
                        }
                    }
                }
                elsif ( $Row->[0] < ( time() - ( 60 * $Minute ) ) ) {
                    last ROW;
                }
            }
            $Minute += $Slot;
            $Count  += $Slot;
        }

        # display data per aggregation slot
        $Minute = 0;
        $Count  = 1;
        while ( $Count <= $MinuteSlot ) {

            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            $DateTimeObject->Subtract( Minutes => $Minute );

            # set output class
            if ( $Action{$Minute} ) {
                my $Average = $Action{$Minute}->{Sum} / $Action{$Minute}->{Count};
                my $I       = 100 / $MaxRequest;
                my $Width   = $Action{$Minute}->{Count} * $I || 1;

                $LayoutObject->Block(
                    Name => 'ViewRow',
                    Data => {
                        %{ $Action{$Minute} },
                        Sum     => sprintf( '%.3f', $Action{$Minute}->{Sum} || '0' ),
                        Max     => sprintf( '%.3f', $Action{$Minute}->{Max} || '0' ),
                        Min     => sprintf( '%.3f', $Action{$Minute}->{Min} || '0' ),
                        Average => sprintf( '%.3f', $Average ),
                        Date    => $DateTimeObject->ToString(),
                        Width   => $Width . '%',
                    },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'ViewRow',
                    Data => {
                        Min     => 0,
                        Max     => 0,
                        Count   => $Action{$Minute}->{Count} || '0',
                        Average => 0,
                        Date    => $DateTimeObject->ToString(),
                        Width   => '0%',
                    },
                );
            }
            $Minute += $Slot;
            $Count  += $Slot;
        }

        # create & return output
        return join '',
            $LayoutObject->Header(),
            $LayoutObject->NavigationBar(),
            $LayoutObject->Output(
                TemplateFile => 'AdminPerformanceLog',
                Data         => \%Param,
            ),
            $LayoutObject->Footer();
    }

    # show overview
    else {

        # get avarage times
        my $Data = [];
        if ( $ConfigObject->Get('PerformanceLog') ) {

            # check file size
            if ( $Self->_DatabaseCheck() ) {
                $LayoutObject->Block(
                    Name => 'Reset',
                    Data => {
                        Size => sprintf '%.1f MB',
                        ( $Self->_DatabaseCheck() / ( 1024 * 1024 ) ),
                    },
                );

                return join '',
                    $LayoutObject->Header(),
                    $LayoutObject->NavigationBar(),
                    $LayoutObject->Output(
                        TemplateFile => 'AdminPerformanceLog',
                        Data         => \%Param,
                    ),
                    $LayoutObject->Footer();
            }
            else {
                $Data = $Self->_DatabaseRead();
            }
        }

        $LayoutObject->Block(
            Name => 'Overview',
        );

        for my $Minute ( 5, 30, 60, 2 * 60, 24 * 60, 2 * 24 * 60 ) {
            my %Count;
            my %Action;
            my %Sum;
            my %Max;
            my %Min;
            ROW:
            for my $Row ( reverse @{$Data} ) {
                if ( $Row->[0] > time() - ( 60 * $Minute ) ) {

                    # whole
                    $Count{ $Row->[1] }++;
                    if ( $Sum{ $Row->[1] } ) {
                        $Sum{ $Row->[1] } = $Sum{ $Row->[1] } + $Row->[2];
                    }
                    else {
                        $Sum{ $Row->[1] } = $Row->[2];
                    }
                    if ( !defined( $Max{ $Row->[1] } ) ) {
                        $Max{ $Row->[1] } = $Row->[2];
                    }
                    elsif ( $Max{ $Row->[1] } < $Row->[2] ) {
                        $Max{ $Row->[1] } = $Row->[2];
                    }
                    if ( !defined( $Min{ $Row->[1] } ) ) {
                        $Min{ $Row->[1] } = $Row->[2];
                    }
                    elsif ( $Min{ $Row->[1] } > $Row->[2] ) {
                        $Min{ $Row->[1] } = $Row->[2];
                    }

                    # for each action
                    if ( $Row->[4] =~ /^(.+?|)Action=(.+?)(&.*|)$/ ) {
                        my $Module = $2;
                        if ( $Row->[4] =~ /Subaction=(.+?)(&.*|)$/ ) {
                            $Module .= '&' . $1;
                        }
                        $Action{$Module}->{Count}->{ $Row->[1] }++;
                        if ( $Action{$Module}->{Sum}->{ $Row->[1] } ) {
                            $Action{$Module}->{Sum}->{ $Row->[1] } = $Action{$Module}->{Sum}->{ $Row->[1] } + $Row->[2];
                        }
                        else {
                            $Action{$Module}->{Sum}->{ $Row->[1] } = $Row->[2];
                        }
                        if ( !defined( $Action{$Module}->{Max}->{ $Row->[1] } ) ) {
                            $Action{$Module}->{Max}->{ $Row->[1] } = $Row->[2];
                        }
                        elsif ( $Action{$Module}->{Max}->{ $Row->[1] } < $Row->[2] ) {
                            $Action{$Module}->{Max}->{ $Row->[1] } = $Row->[2];
                        }
                        if ( !defined( $Action{$Module}->{Min}->{ $Row->[1] } ) ) {
                            $Action{$Module}->{Min}->{ $Row->[1] } = $Row->[2];
                        }
                        elsif ( $Action{$Module}->{Min}->{ $Row->[1] } > $Row->[2] ) {
                            $Action{$Module}->{Min}->{ $Row->[1] } = $Row->[2];
                        }
                    }
                }
                else {
                    last ROW;
                }
            }

            if (%Sum) {
                $LayoutObject->Block(
                    Name => 'OverviewTable',
                    Data => {
                        Age =>
                            $LayoutObject->CustomerAge(
                                Age   => $Minute * 60,
                                Space => ' '
                            ),
                    },
                );
            }

            for my $Interface (qw(Agent Customer Public)) {
                if ( defined $Sum{$Interface} ) {

                    my $Average = $Sum{$Interface} / $Count{$Interface};
                    $LayoutObject->Block(
                        Name => 'OverviewInterface',
                        Data => {
                            Interface => $Interface,
                            Average   => sprintf( '%.3f', $Average ),
                            Count     => $Count{$Interface} || 0,
                            Minute    => $Minute,
                            Sum       => sprintf( '%.3f', $Sum{$Interface} || '0' ),
                            Max       => sprintf( '%.3f', $Max{$Interface} || '0' ),
                            Min       => sprintf( '%.3f', $Min{$Interface} || '0' ),
                        },
                    );

                    for my $Module ( sort keys %Action ) {
                        if ( defined $Action{$Module}->{Sum}->{$Interface} ) {

                            my $Average = $Action{$Module}->{Sum}->{$Interface}
                                / $Action{$Module}->{Count}->{$Interface};
                            $LayoutObject->Block(
                                Name => 'OverviewRow',
                                Data => {
                                    Interface => $Interface,
                                    Module    => $Module,
                                    Average   => sprintf( '%.3f', $Average ),
                                    Minute    => $Minute,
                                    Count     => $Action{$Module}->{Count}->{$Interface} || '0',
                                    Sum       => sprintf( '%.3f', $Action{$Module}->{Sum}->{$Interface} || '0' ),
                                    Max       => sprintf( '%.3f', $Action{$Module}->{Max}->{$Interface} || '0' ),
                                    Min       => sprintf( '%.3f', $Action{$Module}->{Min}->{$Interface} || '0' ),
                                },
                            );
                        }
                    }
                }
            }
        }

        # create & return output
        return join '',
            $LayoutObject->Header(),
            $LayoutObject->NavigationBar(),
            $LayoutObject->Output(
                TemplateFile => 'AdminPerformanceLog',
                Data         => \%Param,
            ),
            $LayoutObject->Footer();
    }

    return;    # never reached
}

sub _DatabaseCheck {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $File         = $ConfigObject->Get('PerformanceLog::File');

    # check file size
    my $FileSize = -s $File;
    if ( $FileSize > ( 1024 * 1024 * $ConfigObject->Get('PerformanceLog::FileMax') ) ) {
        return $FileSize;
    }
    else {
        return;
    }
}

sub _DatabaseReset {
    my ( $Self, %Param ) = @_;

    my $File = $Kernel::OM->Get('Kernel::Config')->Get('PerformanceLog::File');
    if ( !$Kernel::OM->Get('Kernel::System::Main')->FileDelete( Location => $File ) ) {
        return;
    }
    else {
        return 1;
    }
}

sub _DatabaseRead {
    my ( $Self, %Param ) = @_;

    my @Data;
    my $File     = $Kernel::OM->Get('Kernel::Config')->Get('PerformanceLog::File');
    my $ArrayRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
        Mode     => 'utf8',     # optional - binmode|utf8
        Result   => 'ARRAY',    # optional - SCALAR|ARRAY
    );
    if ($ArrayRef) {
        for ( @{$ArrayRef} ) {
            my $Line = $_;
            my @Row  = split( /::/, $Line );
            push @Data, \@Row;
        }
    }

    return \@Data;
}

1;
