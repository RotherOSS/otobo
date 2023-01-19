# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::Dashboard::ProductNotify;

use strict;
use warnings;

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

    return (
        %{ $Self->{Config} },
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if cloud services are disabled
    my $CloudServicesDisabled = $ConfigObject->Get('CloudServices::Disabled') || 0;

    return '' if $CloudServicesDisabled;

    # get current
    my $Product = $ConfigObject->Get('Product');
    my $Version = $ConfigObject->Get('Version');

    my $CloudService = 'PublicFeeds';
    my $Operation    = 'ProductFeed';

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check cache
    my $CacheKey = "CloudService::" . $CloudService . "::Operation::" . $Operation . "::Language::"
        . $LayoutObject->{UserLanguage} . "::Product::" . $Product . "::Version::$Version";

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheContent = $CacheObject->Get(
        Type => 'DashboardProductNotify',
        Key  => $CacheKey,
    );

    return $CacheContent if defined $CacheContent;

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {
                        Product => $Product,
                        Version => $Version,
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
        return $LayoutObject->{LanguageObject}->Translate('Can\'t connect to Product News server!');
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    if ( !IsHashRefWithData($OperationResult) ) {
        return $LayoutObject->{LanguageObject}->Translate('Can\'t get Product News from server!');
    }
    elsif ( !$OperationResult->{Success} ) {
        return $OperationResult->{ErrorMessage} ||
            $LayoutObject->{LanguageObject}->Translate('Can\'t get Product News from server!');
    }

    my $ProductFeed = $OperationResult->{Data};

    # remember if content got shown
    my $ContentFound = 0;

    # show messages
    if ( IsArrayRefWithData( $ProductFeed->{Message} ) ) {

        MESSAGE:
        for my $Message ( @{ $ProductFeed->{Message} } ) {

            next MESSAGE if !$Message;

            # remember if content got shown
            $ContentFound = 1;
            $LayoutObject->Block(
                Name => 'ContentProductMessage',
                Data => {
                    Message => $Message,
                },
            );
        }
    }

    # show release updates
    if ( IsArrayRefWithData( $ProductFeed->{Release} ) ) {

        RELEASE:
        for my $Release ( @{ $ProductFeed->{Release} } ) {

            next RELEASE if !$Release;

            # check if release is newer then the installed one
            next RELEASE if !$Self->_CheckVersion(
                Version1 => $Version,
                Version2 => $Release->{Version},
            );

            # remember if content got shown
            $ContentFound = 1;
            $LayoutObject->Block(
                Name => 'ContentProductRelease',
                Data => {
                    Name     => $Release->{Name},
                    Version  => $Release->{Version},
                    Link     => $Release->{Link},
                    Severity => $Release->{Severity},
                },
            );
        }
    }

    # check if content got shown, if true, render block
    my $Content;
    if ($ContentFound) {
        $Content = $LayoutObject->Output(
            TemplateFile => 'AgentDashboardProductNotify',
            Data         => {
                %{ $Self->{Config} },
            },
        );
    }

    # check if we need to set CacheTTL based on feed
    if ( $ProductFeed->{CacheTTL} ) {
        $Self->{Config}->{CacheTTLLocal} = $ProductFeed->{CacheTTL};
    }

    # cache result
    if ( $Self->{Config}->{CacheTTLLocal} ) {
        $CacheObject->Set(
            Type  => 'DashboardProductNotify',
            Key   => $CacheKey,
            Value => $Content || '',
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    # return content
    return $Content;
}

sub _CheckVersion {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Version1 Version2)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );

            return;
        }
    }
    for my $Type (qw(Version1 Version2)) {
        $Param{$Type} =~ s/\s/\./g;
        $Param{$Type} =~ s/[A-z]/0/g;

        my @Parts = split /\./, $Param{$Type};
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            if ( IsNumber( $Parts[$_] ) ) {
                $Param{$Type} .= sprintf( "%04d", $Parts[$_] );
            }
            else {
                $Param{$Type} .= '0000';
            }
        }
        $Param{$Type} = int( $Param{$Type} );
    }

    return 1 if ( $Param{Version2} > $Param{Version1} );

    return;
}

1;
