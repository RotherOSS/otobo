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

package Kernel::Output::HTML::Dashboard::News;

use strict;
use warnings;
use v5.24;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return
        %{ $Self->{Config} },
        CacheKey => 'RSSNewsFeed-'
        . $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage};
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if cloud services are disabled
    my $CloudServicesDisabled = $Kernel::OM->Get('Kernel::Config')->Get('CloudServices::Disabled');

    return '' if $CloudServicesDisabled;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Language = $LayoutObject->{UserLanguage};

    # cleanup main language for languages like es_MX (es in this case)
    $Language = substr $Language, 0, 2;

    my $CloudService = 'PublicFeeds';
    my $Operation    = 'NewsFeed';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {
                        Language => $Language,
                    },
                },
            ],
        },
    );

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Run');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {
        return $LayoutObject->{LanguageObject}->Translate('Can\'t connect to OTOBO News server!');
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    if ( !IsHashRefWithData($OperationResult) ) {
        return $LayoutObject->{LanguageObject}->Translate('Can\'t get OTOBO News from server!');
    }
    elsif ( !$OperationResult->{Success} ) {
        return $OperationResult->{ErrorMessage} ||
            $LayoutObject->{LanguageObject}->Translate('Can\'t get OTOBO News from server!');
    }

    my $NewsFeed = $OperationResult->{Data}->{News};

    return if !IsArrayRefWithData($NewsFeed);

    my $Count = 0;
    ITEM:
    for my $Item ( @{$NewsFeed} ) {
        $Count++;

        last ITEM if $Count > $Self->{Config}->{Limit};

        my $Time = $Item->{Time};
        my $Ago;
        if ($Time) {
            my $SystemDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Time,
                },
            );

            my $CurSystemDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

            $Ago = $CurSystemDateTimeObject->ToEpoch() - $SystemDateTimeObject->ToEpoch();
            $Ago = $LayoutObject->FormatAge(
                Age   => $Ago,
                Space => ' ',
            );
        }

        $LayoutObject->Block(
            Name => 'ContentSmallRSSOverviewRow',
            Data => { %{$Item} },
        );
        if ($Ago) {
            $LayoutObject->Block(
                Name => 'ContentSmallRSSTimeStamp',
                Data => {
                    Ago => $Ago,
                    %{$Item},
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'ContentSmallRSS',
                Data => {
                    Ago => $Ago,
                    %{$Item},
                },
            );
        }
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardRSSOverview',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    return $Content;
}

1;
