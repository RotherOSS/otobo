# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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

package Kernel::Modules::AdminDynamicFieldScreen;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::Web::Request',
    'Kernel::System::ZnunyHelper',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {%Param}, $Type;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    my $DynamicFields = $DynamicFieldObject->GetValidDynamicFields();
    $Self->{DynamicFields} = $DynamicFields;

    my $ValidDynamicFieldScreenList = $ZnunyHelperObject->_ValidDynamicFieldScreenListGet(
        Result => 'HASH',
    );

    $Self->{DynamicFieldScreens}   = $ValidDynamicFieldScreenList->{DynamicFieldScreens};
    $Self->{DefaultColumnsScreens} = $ValidDynamicFieldScreenList->{DefaultColumnsScreens};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get objects
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $SysConfigObject    = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LanguageObject     = $Kernel::OM->Get('Kernel::Language');

    $Self->{Subaction} = $ParamObject->GetParam( Param => 'Subaction' ) || '';

    my %DynamicFields         = %{ $Self->{DynamicFields} };
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    # check needed stuff
    NEEDED:
    for my $Needed (qw(Element Type)) {
        $Param{$Needed} = $ParamObject->GetParam( Param => $Needed );

        next NEEDED if $Param{$Needed};
    }

    my %Config = $Self->_GetConfig(%Param);

    # ------------------------------------------------------------ #
    # Edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Edit' ) {
        return $Self->_ShowEdit(
            %Param,
            Data => \%Config,
        );
    }

    # ------------------------------------------------------------ #
    # ActvityDialogEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check required parameters
        my @AvailableElements = $ParamObject->GetArray( Param => 'AvailableElements' );

        my @DisabledElements         = $ParamObject->GetArray( Param => 'DisabledElements' );
        my @AssignedElements         = $ParamObject->GetArray( Param => 'AssignedElements' );
        my @AssignedRequiredElements = $ParamObject->GetArray( Param => 'AssignedRequiredElements' );

        # get all Elements
        my %AvailableElements        = map { $_ => undef } @AvailableElements;
        my %DisabledElements         = map { $_ => '0' } @DisabledElements;
        my %AssignedElements         = map { $_ => '1' } @AssignedElements;
        my %AssignedRequiredElements = map { $_ => '2' } @AssignedRequiredElements;

        # build config hash
        my %Config = (
            %AvailableElements,
            %DisabledElements,
            %AssignedElements,
            %AssignedRequiredElements,
        );

        my $Success;
        my %ScreenConfig;
        $ScreenConfig{ $Param{Element} } ||= {};

        # get config of element
        if ( $Param{Type} eq 'DynamicField' ) {

            $ScreenConfig{ $Param{Element} } = \%Config;

            $Success = $ZnunyHelperObject->_DynamicFieldsScreenConfigImport(
                Config => \%ScreenConfig,
            );
        }
        elsif ( $Param{Type} eq 'DynamicFieldScreen' ) {

            for my $DynamicField ( sort keys %Config ) {
                $ScreenConfig{ $Param{Element} }->{$DynamicField} = $Config{$DynamicField};
            }

            $Success = $ZnunyHelperObject->_DynamicFieldsScreenEnable(%ScreenConfig);
        }
        elsif ( $Param{Type} eq 'DefaultColumnsScreen' ) {

            for my $DynamicField ( sort keys %Config ) {
                $ScreenConfig{ $Param{Element} }->{ 'DynamicField_' . $DynamicField } = $Config{$DynamicField};
            }

            $Success = $ZnunyHelperObject->_DefaultColumnsEnable(%ScreenConfig);
        }

        $Param{Priority} = 'Info';
        $Param{Message}  = $LanguageObject->Translate(
            "Settings were saved.",
        );

        if ( !$Success ) {
            $Param{Priority} = 'Error';
            $Param{Message}  = $LanguageObject->Translate(
                "System was not able to save the setting!",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            Data => \%Config,
        );
    }

    # ------------------------------------------------------------ #
    # Reset
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Reset' ) {

        $Self->{Subaction} = 'Edit';

        if (
            $Param{Type} ne 'DynamicFieldScreen'
            && $Param{Type} ne 'DefaultColumnsScreen'
            )
        {
            return $Self->_ShowOverview();
        }

        my $ExclusiveLockGUID;
        my %Setting = $SysConfigObject->SettingGet(
            Name => $Param{Element},
        );

        if ( !$Setting{ExclusiveLockGUID} ) {

            # Setting is not locked yet.
            $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                UserID    => $Self->{UserID},
                DefaultID => $Setting{DefaultID},
            );
        }
        elsif ( $Setting{ExclusiveLockUserID} != $Self->{UserID} ) {

            # Someone else locked the setting.
            $Param{Priority} = 'Error';
            $Param{Message}  = $LanguageObject->Translate(
                "Setting is locked by another user!",
            );

            return $Self->_ShowEdit(
                %Param,
                Data => \%Config,
            );
        }
        else {

            # Already locked to this user.
            $ExclusiveLockGUID = $Setting{ExclusiveLockGUID};
        }

        my $Success = $SysConfigObject->SettingReset(
            Name              => $Param{Element},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => $Self->{UserID},
        );

        if ( !$Success ) {

            $Param{Priority} = 'Error';
            $Param{Message}  = $LanguageObject->Translate(
                "System was not able to reset the setting!",
            );

            return $Self->_ShowEdit(
                %Param,
                Data => \%Config,
            );
        }

        $SysConfigObject->SettingUnlock(
            DefaultID => $Setting{DefaultID},
        );

        $Success = $ZnunyHelperObject->_RebuildConfig();

        $Param{Priority} = 'Info';
        $Param{Message}  = $LanguageObject->Translate(
            "Settings were reset.",
        );

        if ( !$Success ) {
            $Param{Priority} = 'Error';
            $Param{Message}  = $LanguageObject->Translate(
                "System was not able to reset the setting!",
            );
        }

        # get new config
        %Config = $Self->_GetConfig(%Param);

        return $Self->_ShowEdit(
            %Param,
            Data => \%Config,
        );
    }

    # ------------------------------------------------------------ #
    # Error
    # ------------------------------------------------------------ #
    else {
        return $Self->_ShowOverview();
    }

    return;
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %DynamicFields         = %{ $Self->{DynamicFields} };
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    # show output
    $LayoutObject->Block( Name => 'Overview' );

    for my $DynamicFieldScreen ( sort { $DynamicFieldScreens{$a} cmp $DynamicFieldScreens{$b} } keys %DynamicFieldScreens ) {

        # output row for DynamicFieldScreen
        $LayoutObject->Block(
            Name => 'DynamicFieldScreenOverviewRow',
            Data => {
                DynamicFieldScreen => $DynamicFieldScreen,
                Name               => $DynamicFieldScreens{$DynamicFieldScreen},
            },
        );
    }

    for my $DefaultColumnsScreen ( sort { $DefaultColumnsScreens{$a} cmp $DefaultColumnsScreens{$b} } keys %DefaultColumnsScreens ) {

        # output row for DefaultColumns
        $LayoutObject->Block(
            Name => 'DefaultColumnsScreenOverviewRow',
            Data => {
                DefaultColumnsScreen => $DefaultColumnsScreen,
                Name                 => $DefaultColumnsScreens{$DefaultColumnsScreen},
            },
        );
    }

    if ( !%DynamicFields ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
        );
    }
    else {

        for my $DynamicField ( sort keys %DynamicFields ) {

            # output row for DynamicField
            $LayoutObject->Block(
                Name => 'DynamicFieldOverviewRow',
                Data => {
                    DynamicField => $DynamicField,
                    Name         => $DynamicFields{$DynamicField},
                },
            );
        }
    }

    # output header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldScreen',
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $NoAssignedRequiredFieldRow;

    $Param{Action} = 'Edit';

    my %Data                  = %{ $Param{Data} || {} };
    my %DynamicFields         = %{ $Self->{DynamicFields} };
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    my %Screens = (
        %{ $Self->{DynamicFieldScreens} },
        %{ $Self->{DefaultColumnsScreens} },
    );

    # localize available fields, dynamic fields screens and default column screens
    my %AvailableElements = %DynamicFields;
    my %OtherElements     = %DefaultColumnsScreens;

    # set default size for template
    $Param{Size}   = 'Size1of4';
    $Param{Header} = 'Dynamic Fields for this Screen';

    if ( $Param{Type} eq 'DynamicField' ) {

        %AvailableElements = %Screens;
        %OtherElements     = %DynamicFields;

        $Param{Header}      = 'Screens for this Dynamic Field';
        $Param{HiddenReset} = 'Hidden';
    }
    elsif ( $Param{Type} eq 'DynamicFieldScreen' ) {

        # remove AssignedRequiredFieldRow off template if screen is AgentTicketZoom oder CustomTicketZoom
        if ( $Param{Element} =~ m{Zoom}msxi ) {

            # AssignedRequired is not needed for Zoom-Views
            $NoAssignedRequiredFieldRow = 1;
            $Param{Size}                = 'Size1of3';
            $Param{HiddenRequired}      = 'Hidden';
        }
        %OtherElements = %DynamicFieldScreens;
    }

    # output input page
    $LayoutObject->Block(
        Name => 'Edit',
        Data => {
            %Param,
            %Data,
        },
    );

    # shows sidebar selection
    for my $Element ( sort { $OtherElements{$a} cmp $OtherElements{$b} } keys %OtherElements ) {

        # output row
        $LayoutObject->Block(
            Name => 'ActionOverviewRowEdit',
            Data => {
                Element    => $OtherElements{$Element},
                ElementKey => $Element,
                Type       => $Param{Type},
            },
        );
    }

    # get used fields by the dynamic field group
    if (%Data) {

        ELEMENT:
        for my $Element ( sort keys %Data ) {

            next ELEMENT if !defined $Data{$Element};
            next ELEMENT if !$AvailableElements{$Element};

            # remove all spaces # or :
            my $ID = $Element;
            $ID =~ s/\s//g;
            $ID =~ s/\#*//g;
            $ID =~ s/\:\://g;

            my $BlockName = undef;

            if ( $Data{$Element} eq 0 ) {
                $BlockName = 'DisabledFieldRow';
            }
            elsif ( $Data{$Element} eq 1 ) {
                $BlockName = 'AssignedFieldRow';
            }
            elsif ( $Data{$Element} eq 2 && !$NoAssignedRequiredFieldRow ) {
                $BlockName = 'AssignedRequiredFieldRow';
            }

            next ELEMENT if !$BlockName;

            $LayoutObject->Block(
                Name => $BlockName,
                Data => {
                    Element => $Element,
                    Label   => $AvailableElements{$Element},
                    ID      => $ID,
                },
            );

            # remove used fields from available list
            delete $AvailableElements{$Element};
        }
    }

    # display available fields
    for my $Element (
        sort { $AvailableElements{$a} cmp $AvailableElements{$b} }
        keys %AvailableElements
        )
    {
        # remove all spaces # or :
        my $ID = $Element;
        $ID =~ s/\s//g;
        $ID =~ s/\#*//g;
        $ID =~ s/\:\://g;

        $LayoutObject->Block(
            Name => 'AvailableFieldRow',
            Data => {
                Element => $Element,
                Label   => $AvailableElements{$Element},
                ID      => $ID,
            },
        );
    }

    # output header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    if ( $Param{Message} && $Param{Priority} ) {
        $Output .= $LayoutObject->Notify(
            Priority => $Param{Priority} || 'Info',
            Info     => $Param{Message},
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldScreen',
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetConfig {
    my ( $Self, %Param ) = @_;

    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    my %Config;
    return %Config if !defined $Param{Type};

    # get config of element
    if ( $Param{Type} eq 'DynamicField' ) {
        my %ConfigItemConfig = $ZnunyHelperObject->_DynamicFieldsScreenConfigExport(
            DynamicFields => [ $Param{Element} ],
        );

        %Config = %{ $ConfigItemConfig{ $Param{Element} } || {} };
    }
    elsif ( $Param{Type} eq 'DynamicFieldScreen' ) {

        my %ConfigItemConfig = $ZnunyHelperObject->_DynamicFieldsScreenGet(
            ConfigItems => [ $Param{Element} ],
        );

        %Config = %{ $ConfigItemConfig{ $Param{Element} } || {} };
    }
    elsif ( $Param{Type} eq 'DefaultColumnsScreen' ) {

        my %ConfigItemConfig = $ZnunyHelperObject->_DynamicFieldsDefaultColumnsGet(
            ConfigItems => [ $Param{Element} ],
        );

        %Config = %{ $ConfigItemConfig{ $Param{Element} } || {} };
    }

    return %Config;

}

1;
