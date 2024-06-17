# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::Modules::CustomerDynamicFieldDBDetails;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get params
    for my $Item (qw(DynamicFieldName ID)) {
        $Param{$Item} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Item );
    }

    # check needed stuff
    if ( !$Param{DynamicFieldName} && !$Param{ID} ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No DynamicFieldName or ID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get the pure DynamicField name without prefix
    my $DynamicFieldName = substr( $Param{DynamicFieldName}, 13 );

    # get the dynamic field value for the current ticket
    my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => $DynamicFieldName,
    );

    # get the dynamic field database object
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::DynamicFieldDB' => {
            DynamicFieldConfig => $DynamicFieldConfig,
        },
    );
    my $DynamicFieldDBObject = $Kernel::OM->Get('Kernel::System::DynamicFieldDB');

    # perform the search based on the given dynamic field config
    my @Result = $DynamicFieldDBObject->DatabaseSearchDetails(
        Config     => $DynamicFieldConfig->{Config},
        Identifier => $Param{ID},
    );

    # show the search overview page
    $LayoutObject->Block(
        Name => 'DetailsOverview',
        Data => {
            DynamicFieldName => $DynamicFieldName,
        },
    );

    # iterate over the needed column and assign
    # them to the details overview
    COLUMN:
    for my $Column ( @{ $Result[0] } ) {

        next COLUMN if !$Column->{Label};
        next COLUMN if !$Column->{Data};

        $LayoutObject->Block(
            Name => 'DetailsRow',
            Data => {
                ColumnHead => $Column->{Label},
                ColumnData => $Column->{Data},
            },
        );
    }

    # start with page ...
    my $Output = $LayoutObject->CustomerHeader( Type => 'Small' );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'CustomerDynamicFieldDBDetails',
        Data         => {
            %Param,
            DynamicFieldName => $DynamicFieldName,
        }
    );
    $Output .= $LayoutObject->CustomerFooter( Type => 'Small' );

    return $Output;
}

sub _JSONReturn {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build JSON output
    my $JSON = $LayoutObject->JSONEncode(
        Data => [ $Param{Success} ],
    );

    # send response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON || $LayoutObject->JSONEncode(
            Data => [],
        ),
        Type    => 'inline',
        NoCache => 1,
    );
}

1;
