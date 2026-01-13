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

package Kernel::Modules::AdminPostMasterFilter;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set pref for columns key
    $Self->{PrefKeyIncludeInvalid} = 'IncludeInvalid' . '-' . $Self->{Action};

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    $Self->{IncludeInvalid} = $Preferences{ $Self->{PrefKeyIncludeInvalid} };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $Name           = $ParamObject->GetParam( Param => 'Name' );
    my $OldName        = $ParamObject->GetParam( Param => 'OldName' );
    my $ValidID        = $ParamObject->GetParam( Param => 'ValidID' );
    my $StopAfterMatch = $ParamObject->GetParam( Param => 'StopAfterMatch' ) || 0;
    my %GetParam       = ();

    $Param{IncludeInvalid} = $ParamObject->GetParam( Param => 'IncludeInvalid' );

    if ( defined $Param{IncludeInvalid} ) {
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{PrefKeyIncludeInvalid},
            Value  => $Param{IncludeInvalid},
        );

        $Self->{IncludeInvalid} = $Param{IncludeInvalid};
    }

    # fetch and pass on filters
    my %SearchItems;
    for my $SearchItem (qw(SearchFilter SearchValue)) {
        $SearchItems{$SearchItem}->@* = split( /,/, $ParamObject->GetParam( Param => $SearchItem ) || '' );
    }

    $SearchItems{SearchTerm} = $ParamObject->GetParam( Param => 'SearchTerm' ) || undef;

    for my $Number ( 1 .. $ConfigObject->Get('PostmasterHeaderFieldCount') ) {
        $GetParam{"MatchHeader$Number"} = $ParamObject->GetParam( Param => "MatchHeader$Number" );
        $GetParam{"MatchValue$Number"}  = $ParamObject->GetParam( Param => "MatchValue$Number" );
        $GetParam{"MatchNot$Number"}    = $ParamObject->GetParam( Param => "MatchNot$Number" );
        $GetParam{"SetHeader$Number"}   = $ParamObject->GetParam( Param => "SetHeader$Number" );
        $GetParam{"SetValue$Number"}    = $ParamObject->GetParam( Param => "SetValue$Number" );
    }

    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Delete = $PostMasterFilter->FilterDelete(
            Name => $Name,
        );

        if ( !$Delete ) {
            return $LayoutObject->ErrorScreen();
        }

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => $Delete,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {
        return $Self->_MaskUpdate( Data => {} );
    }

    # ------------------------------------------------------------ #
    # update
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {
        my %Data = $PostMasterFilter->FilterGet( Name => $Name );
        if ( !%Data ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'No such filter: %s', $Name ),
            );
        }
        return $Self->_MaskUpdate(
            Name => $Name,
            Data => \%Data,
        );
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdateAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @Match;
        my @Set;
        my @Not;

        for my $Number ( 1 .. $ConfigObject->Get('PostmasterHeaderFieldCount') ) {
            if ( $GetParam{"MatchHeader$Number"} && length $GetParam{"MatchValue$Number"} ) {
                push @Match, {
                    Key   => $GetParam{"MatchHeader$Number"},
                    Value => $GetParam{"MatchValue$Number"},
                };
                push @Not, {
                    Key   => $GetParam{"MatchHeader$Number"},
                    Value => $GetParam{"MatchNot$Number"},
                };
            }

            if ( $GetParam{"SetHeader$Number"} && length $GetParam{"SetValue$Number"} ) {
                push @Set, {
                    Key   => $GetParam{"SetHeader$Number"},
                    Value => $GetParam{"SetValue$Number"},
                };
            }
        }
        my %Errors = ();
        if (@Match) {
            my $InvalidCount = 0;
            for my $MatchItem (@Match) {
                $InvalidCount++;
                my $MatchValue = $MatchItem->{Value};
                if ( !eval { my $Regex = qr/$MatchValue/; 1; } ) {
                    $Errors{"MatchHeader${InvalidCount}Invalid"} = 'ServerError';
                    $Errors{"MatchValue${InvalidCount}Invalid"}  = 'ServerError';
                }
            }
        }
        else {
            $Errors{"MatchHeader1Invalid"} = 'ServerError';
            $Errors{"MatchValue1Invalid"}  = 'ServerError';
        }

        if (@Set) {
            my $InvalidCount = 0;
            for my $SetItem (@Set) {
                $InvalidCount++;
                if ( !defined $SetItem->{Value} ) {
                    $Errors{"SetHeader${InvalidCount}Invalid"} = 'ServerError';
                    $Errors{"SetValue${InvalidCount}Invalid"}  = 'ServerError';
                }
            }
        }
        else {
            $Errors{"SetHeader1Invalid"} = 'ServerError';
            $Errors{"SetValue1Invalid"}  = 'ServerError';
        }

        # Name validation
        if ( $Name eq '' ) {
            $Errors{"NameInvalid"} = 'ServerError';
        }

        # ValidID validation
        if ( !( $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $ValidID ) ) ) {
            $Errors{"ValidOptionInvalid"} = 'ServerError';
        }

        # If it's not edit action, verify there is no filters with same name.
        if ( $Name ne $OldName ) {
            my %Data = $PostMasterFilter->FilterGet( Name => $Name );
            if (%Data) {
                $Errors{"NameInvalid"} = 'ServerError';
            }
        }

        if (%Errors) {
            return $Self->_MaskUpdate(
                Name => $Name,
                Data => {
                    %Errors,
                    OldName        => $OldName,
                    Name           => $Name,
                    Set            => \@Set,
                    Match          => \@Match,
                    StopAfterMatch => $StopAfterMatch,
                    Not            => \@Not,
                },
            );
        }
        $PostMasterFilter->FilterDelete( Name => $OldName );
        $PostMasterFilter->FilterAdd(
            Name           => $Name,
            ValidID        => $ValidID,
            Match          => \@Match,
            Set            => \@Set,
            StopAfterMatch => $StopAfterMatch,
            Not            => \@Not,
        );

        # if the user would like to continue editing the postmaster filter, just redirect to the update screen
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Subaction=Update;Name=$Name" );
        }
        else {

            # otherwise return to overview
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        my %ValidList   = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        my %ValidLookup = reverse %ValidList;
        my @ValidIDs    = ( $ValidLookup{'valid'}, $ValidLookup{'invalid-temporarily'} );
        if ( $Self->{IncludeInvalid} ) {
            push @ValidIDs, $ValidLookup{'invalid'};
        }

        my %List = $PostMasterFilter->FilterList(
            %SearchItems,
            ValidIDs => \@ValidIDs,
        );

        $LayoutObject->Block(
            Name => 'Overview',
            Data => { %Param, },
        );
        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionAdd' );
        $LayoutObject->Block(
            Name => 'IncludeInvalid',
            Data => {
                IncludeInvalid        => $Self->{IncludeInvalid},
                IncludeInvalidChecked => $Self->{IncludeInvalid} ? 'checked' : '',
            },
        );
        $LayoutObject->Block( Name => 'Filter' );

        # all headers
        my @Headers = @{ $ConfigObject->Get('PostmasterX-Header') };

        # add Dynamic Field headers
        my $DynamicFields = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
            Valid      => 1,
            ObjectType => [ 'Ticket', 'Article' ],
            ResultType => 'HASH',
        );
        for my $DynamicField ( values %$DynamicFields ) {
            push @Headers, 'X-OTOBO-DynamicField-' . $DynamicField;
            push @Headers, 'X-OTOBO-FollowUp-DynamicField-' . $DynamicField;
        }

        my %Header = map { $_ => $_ } @Headers;
        $Header{''}   = '-';
        $Header{Body} = 'Body';

        # set headers
        my %SetHeader = ();
        for my $HeaderKey ( sort keys %Header ) {
            if ( $HeaderKey =~ /^x-otobo/i ) {
                $SetHeader{$HeaderKey} = $HeaderKey;
            }
        }
        $SetHeader{''} = '-';

        # render filter block
        my $SearchFilterStrg = $LayoutObject->BuildSelection(
            Data         => \%Header,
            Name         => 'SearchFilter',
            Class        => 'Modernize W100pc FilterBox',
            SelectedID   => $SearchItems{SearchFilter},
            Translation  => 0,
            HTMLQuote    => 1,
            Multiple     => 1,
            PossibleNone => 1,
        );

        # render filter block
        my $SearchValueStrg = $LayoutObject->BuildSelection(
            Data         => \%SetHeader,
            Name         => 'SearchValue',
            Class        => 'Modernize W100pc FilterBox',
            SelectedID   => $SearchItems{SearchValue},
            Translation  => 0,
            HTMLQuote    => 1,
            Multiple     => 1,
            PossibleNone => 1,
        );

        $LayoutObject->Block(
            Name => 'Search',
            Data => {
                SearchFilterStrg => $SearchFilterStrg,
                SearchTerm       => $SearchItems{SearchTerm} || '',
                SearchValueStrg  => $SearchValueStrg,
            },
        );

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => { %Param, },
        );

        if (%List) {
            my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
            for my $Key ( sort keys %List ) {
                my %Data = $PostMasterFilter->FilterGet( Name => $Key );
                $LayoutObject->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        Name           => $Key,
                        StopAfterMatch => $Data{StopAfterMatch} ? 'Yes' : 'No',
                        Valid          => $ValidList{ $Data{ValidID} },
                    },
                );
            }
        }
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPostMasterFilter',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _MaskUpdate {
    my ( $Self, %Param ) = @_;

    my %Data    = %{ $Param{Data} };
    my $Counter = 0;
    if ( $Data{Match} ) {
        for my $Index ( 0 .. ( scalar @{ $Data{Match} } ) - 1 ) {
            if ( $Data{Match}->[$Index]->{Key} && length $Data{Match}->[$Index]->{Value} ) {
                $Counter++;
                $Data{"MatchValue$Counter"}  = $Data{Match}->[$Index]->{Value};
                $Data{"MatchHeader$Counter"} = $Data{Match}->[$Index]->{Key};
                $Data{"MatchNot$Counter"}    = $Data{Not}->[$Index]->{Value} ? ' checked ' : '';
            }
        }
    }
    $Counter = 0;
    if ( $Data{Set} ) {
        for my $Item ( @{ $Data{Set} } ) {
            if ( $Item->{Key} && length $Item->{Value} ) {
                $Counter++;
                $Data{"SetValue$Counter"}  = $Item->{Value};
                $Data{"SetHeader$Counter"} = $Item->{Key};
            }
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            Action => $Self->{Subaction},
            Name   => $Param{Name},
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # all headers
    my @Headers = @{ $ConfigObject->Get('PostmasterX-Header') };

    # add Dynamic Field headers
    my $DynamicFields = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        Valid      => 1,
        ObjectType => [ 'Ticket', 'Article' ],
        ResultType => 'HASH',
    );
    for my $DynamicField ( values %$DynamicFields ) {
        push @Headers, 'X-OTOBO-DynamicField-' . $DynamicField;
        push @Headers, 'X-OTOBO-FollowUp-DynamicField-' . $DynamicField;
    }

    my %Header = map { $_ => $_ } @Headers;
    $Header{''}   = '-';
    $Header{Body} = 'Body';

    # otobo header
    my %SetHeader = ();
    for my $HeaderKey ( sort keys %Header ) {
        if ( $HeaderKey =~ /^x-otobo/i ) {
            $SetHeader{$HeaderKey} = $HeaderKey;
        }
    }
    $SetHeader{''} = '-';

    # build strings
    for my $Number ( 1 .. $ConfigObject->Get('PostmasterHeaderFieldCount') ) {
        $Data{"MatchHeader$Number"} = $LayoutObject->BuildSelection(
            Data        => \%Header,
            Name        => "MatchHeader$Number",
            SelectedID  => $Data{"MatchHeader$Number"},
            Class       => 'Modernize ' . ( $Data{ 'MatchHeader' . $Number . 'Invalid' } || '' ),
            Translation => 0,
            HTMLQuote   => 1,
        );
        $Data{"SetHeader$Number"} = $LayoutObject->BuildSelection(
            Data        => \%SetHeader,
            Name        => "SetHeader$Number",
            SelectedID  => $Data{"SetHeader$Number"},
            Class       => 'Modernize ' . ( $Data{ 'SetHeader' . $Number . 'Invalid' } || '' ),
            Translation => 0,
            HTMLQuote   => 1,
        );
    }
    $Data{"StopAfterMatch"} = $LayoutObject->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes'
        },
        Name        => 'StopAfterMatch',
        SelectedID  => $Data{StopAfterMatch} || 0,
        Class       => 'Modernize Validate_RequiredDropdown',
        Translation => 1,
        HTMLQuote   => 1,
    );

    my $OldName = $Data{Name};
    if ( $Param{Data}->{NameInvalid} ) {
        $OldName = $Data{OldName};
    }

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{Data}{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param, %Data,
            OldName => $OldName,
            Action  => $Self->{Subaction},
        },
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminPostMasterFilter',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

1;
