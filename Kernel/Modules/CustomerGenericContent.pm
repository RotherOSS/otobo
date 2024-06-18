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

package Kernel::Modules::CustomerGenericContent;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

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

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ModuleKey    = $ParamObject->GetParam( Param => 'Key' ) // '';

    if ( !$ModuleKey ) {
        return $LayoutObject->FatalError(
            Message => Translatable('Need Key!'),
        );
    }

    if ( !$Self->{Subaction} ) {
        my %HeaderMap;
        my $HeaderConfig = $Kernel::OM->Get('Kernel::Config')->Get('CustomerGenericHTMLContent::HeaderMap') // {};
        for my $Entry ( sort keys $HeaderConfig->%* ) {
            %HeaderMap = (
                %HeaderMap,
                $HeaderConfig->{$Entry}->%*,
            );
        }

        return join(
            '',
            (
                $LayoutObject->CustomerHeader(),
                $LayoutObject->Output(
                    TemplateFile => 'CustomerGenericContent',
                    Data         => {
                        Key    => $ModuleKey,
                        Header => $HeaderMap{$ModuleKey} // 'Additional Information',
                    },
                ),
                $LayoutObject->CustomerNavigationBar(),
                $LayoutObject->CustomerFooter(),
            )
        );
    }

    # generate the iframe content
    elsif ( $Self->{Subaction} eq 'Show' ) {

        my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

        my %ModuleMap;
        my $ModuleConfig = $Kernel::OM->Get('Kernel::Config')->Get('CustomerGenericHTMLContent::ModuleMap') // {};
        for my $Entry ( sort keys $ModuleConfig->%* ) {
            %ModuleMap = (
                %ModuleMap,
                $ModuleConfig->{$Entry}->%*,
            );
        }

        if ( !$ModuleMap{$ModuleKey} ) {
            return $LayoutObject->FatalError(
                Message => Translatable('Invalid Key!'),
            );
        }

        my $Module = 'Kernel::Output::HTML::GenericContent::' . $ModuleMap{$ModuleKey};
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Failed to require '$Module' defined for '$ModuleKey'!",
            );

            return $LayoutObject->FatalError(
                Message => Translatable('Failed to load Content!'),
            );
        }

        my $ContentObject = $Module->new();

        my $Content = $ContentObject->Content(
            Interface    => 'Customer',
            ModuleKey    => $ModuleKey,
            LayoutObject => $LayoutObject,
            ParamObject  => $ParamObject,
            UserID       => $Self->{UserID},
        );

        if ( !$Content ) {
            return $LayoutObject->FatalError(
                Message => Translatable('Failed to load Content!'),
            );
        }

        $Content = $HTMLUtilsObject->DocumentComplete(
            String            => $Content,
            Charset           => 'utf-8',
            CustomerInterface => 1,
        );

        return $LayoutObject->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $Content,
            Charset     => 'utf-8',
        );
    }

    return $LayoutObject->FatalError(
        Message => Translatable('Destination unknown.'),
    );
}

1;
