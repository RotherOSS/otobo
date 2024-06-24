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

package Kernel::Modules::AdminSystemConfiguration;

use strict;
use warnings;

# core modules

# CPAN modules
use URI::Escape qw(uri_unescape);

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $EntityType = $ParamObject->GetParam( Param => 'EntityType' ) || '';

    if ($EntityType) {

        # Set Entity Type.
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastEntityType',
            Value     => $EntityType,
        );

        # Update also environment at this moment to include the link in the sidebar
        $LayoutObject->SetEnv(
            Key   => 'LastEntityType',
            Value => $EntityType,
        );
    }

    my $ConfigLevel = $Kernel::OM->Get('Kernel::Config')->Get('ConfigLevel') || 0;

    # collect some data which needs to be passed to several screens
    my %OutputData = (
        CategoriesStrg  => $Self->_GetCategoriesStrg(),
        InvalidSettings => $Self->_CheckInvalidSettings(),
        ConfigLevel     => $ConfigLevel,
    );

    # Create navigation tree
    if ( $Self->{Subaction} eq 'AJAXNavigationTree' ) {

        my $Category               = $ParamObject->GetParam( Param => 'Category' )               || '';
        my $UserModificationActive = $ParamObject->GetParam( Param => 'UserModificationActive' ) || '0';
        my $IsValid                = $ParamObject->GetParam( Param => 'IsValid' ) // undef;

        my %Tree = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationNavigationTree(
            Category               => $Category,
            UserModificationActive => $UserModificationActive,
            IsValid                => $IsValid,
        );

        my $Output = $LayoutObject->Output(
            TemplateFile => 'SystemConfiguration/NavigationTree',
            Data         => {
                Tree => \%Tree,
            },
        );

        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Output || '',
            Type        => 'inline',
        );
    }

    # Search for settings using ajax
    elsif ( $Self->{Subaction} eq 'AJAXSearch' ) {

        my $Search     = $ParamObject->GetParam( Param => 'Term' ) || '';
        my $MaxResults = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 20 );
        my @Data;

        if ($Search) {
            my @SettingList = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationList();

            SETTING:
            for my $Setting ( sort { $a->{Name} cmp $b->{Name} } @SettingList ) {

                # Skip setting if search term doesn't match.
                next SETTING if $Setting->{Name} !~ m{\Q$Search\E}msi;

                push @Data, $Setting->{Name};
                last SETTING if scalar @Data >= $MaxResults;
            }
        }

        # JSON output
        return $LayoutObject->JSONReply(
            Data => \@Data
        );
    }

    elsif ( $Self->{Subaction} eq 'Invalid' ) {

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my @SettingNames = $SysConfigObject->ConfigurationInvalidList();
        my @Parameters   = (
            {
                Name  => Translatable('Invalid settings'),
                Value => 'Invalid',
            }
        );

        my @SettingList;

        # Check if setting is fixed but not yet deployed.
        for my $SettingName (@SettingNames) {
            my %Setting = $SysConfigObject->SettingGet(
                Name            => $SettingName,
                OverriddenInXML => 1,
                UserID          => $Self->{UserID},
            );

            my %EffectiveValueCheck = $SysConfigObject->SettingEffectiveValueCheck(
                EffectiveValue   => $Setting{EffectiveValue},
                XMLContentParsed => $Setting{XMLContentParsed},
                UserID           => $Self->{UserID},
            );

            if ( !$EffectiveValueCheck{Error} ) {
                $Setting{EffectiveValueFixed} = 1;
            }

            push @SettingList, \%Setting;
        }

        # get favorites from user preferences
        my $Favourites;
        my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
            UserID => $Self->{UserID},
        );

        if ( $UserPreferences{UserSystemConfigurationFavourites} ) {
            $Favourites = $Kernel::OM->Get('Kernel::System::JSON')->Decode( Data => $UserPreferences{UserSystemConfigurationFavourites} );
        }

        for my $Setting (@SettingList) {
            my %LockStatus = $SysConfigObject->SettingLockCheck(
                DefaultID           => $Setting->{DefaultID},
                ExclusiveLockGUID   => $Setting->{ExclusiveLockGUID} || '1',
                ExclusiveLockUserID => $Self->{UserID},
            );

            # append status
            %{$Setting} = (
                %{$Setting},
                %LockStatus,
            );

            # check if this setting is a favorite of the current user
            if ( grep { $_ eq $Setting->{Name} } @{$Favourites} ) {
                $Setting->{IsFavourite} = 1;
            }

            $Setting->{HTMLStrg} = $SysConfigObject->SettingRender(
                Setting => $Setting,
                RW      => ( $Setting->{Locked} && $Setting->{Locked} == 2 ) ? 1 : 0,
                UserID  => $Self->{UserID},
            );

            if ( $Setting->{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
                $Setting->{Invalid} = 1;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        my $RootNavigation = $ParamObject->GetParam( Param => 'RootNavigation' ) || '';

        # Get navigation tree
        my %Tree = $SysConfigObject->ConfigurationNavigationTree();

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationSpecialGroup',
            Data         => {
                GroupName         => $LayoutObject->{LanguageObject}->Translate('Invalid Settings'),
                GroupLink         => 'AdminSystemConfiguration;Subaction=Invalid',
                GroupEmptyMessage =>
                    $LayoutObject->{LanguageObject}->Translate("There are no invalid settings active at this time."),
                Results     => scalar @SettingList,
                SettingList => \@SettingList,
                %OutputData,
            },
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'UserModificationsCount' ) {

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
        my $SettingName = $ParamObject->GetParam( Param => 'Name' ) || '';

        my %UsersList;
        if ( $SysConfigObject->can('UserSettingModifiedValueList') ) {    # OTOBO Community Solution
            %UsersList = $SysConfigObject->UserSettingModifiedValueList(
                Name => $SettingName,
            );
        }

        my $Result = keys %UsersList;

        return $LayoutObject->JSONReply(
            Data => $Result // 0
        );
    }

    # Search for settings.
    elsif ( $Self->{Subaction} eq 'Search' ) {

        my $Search   = $ParamObject->GetParam( Param => 'Search' )   || '';
        my $Category = $ParamObject->GetParam( Param => 'Category' ) || '';
        my @SettingList;

        if ( $Search || $Category ) {

            my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
            my @Result          = $SysConfigObject->ConfigurationSearch(
                Search   => $Search,
                Category => $Category,
            );

            if ( scalar @Result ) {

                for my $SettingName ( sort @Result ) {

                    my %Setting = $SysConfigObject->SettingGet(
                        Name            => $SettingName,
                        OverriddenInXML => 1,
                        UserID          => $Self->{UserID},
                    );

                    $Setting{HTMLStrg} = $SysConfigObject->SettingRender(
                        Setting => \%Setting,
                        RW      => $Setting{ExclusiveLockGUID} ? 1 : 0,
                        UserID  => $Self->{UserID},
                    );
                    push @SettingList, \%Setting;
                }
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationSearch',
            Data         => {
                Search      => $Search,
                Category    => $Category,
                Results     => scalar @SettingList,
                SettingList => \@SettingList,
                %OutputData,
            },
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # Search dialog
    elsif ( $Self->{Subaction} eq 'SearchDialog' ) {

        my $Output = $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationSearchDialog',
            Data         => {
                %OutputData,
                SearchTerm => $ParamObject->GetParam( Param => 'Term' ) || '',
            },
            %Param,
        );

        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Output || '',
            Type        => 'inline',
        );
    }

    # Favourites
    elsif ( $Self->{Subaction} eq 'Favourites' ) {

        my @SettingList;

        my $Favourites;
        my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
            UserID => $Self->{UserID},
        );

        if ( $UserPreferences{UserSystemConfigurationFavourites} ) {
            $Favourites = $Kernel::OM->Get('Kernel::System::JSON')->Decode( Data => $UserPreferences{UserSystemConfigurationFavourites} );
        }

        if ($Favourites) {

            my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

            for my $SettingName ( sort @{$Favourites} ) {

                my %Setting = $SysConfigObject->SettingGet(
                    Name            => $SettingName,
                    OverriddenInXML => 1,
                    UserID          => $Self->{UserID},
                );

                $Setting{HTMLStrg} = $SysConfigObject->SettingRender(
                    Setting => \%Setting,
                    RW      => $Setting{ExclusiveLockGUID} ? 1 : 0,
                    UserID  => $Self->{UserID},
                );

                $Setting{IsFavourite} = 1;

                push @SettingList, \%Setting;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationSpecialGroup',
            Data         => {
                GroupName         => $LayoutObject->{LanguageObject}->Translate('My favourite settings'),
                GroupLink         => 'AdminSystemConfiguration;Subaction=Favourites',
                GroupEmptyMessage =>
                    $LayoutObject->{LanguageObject}->Translate("You currently don't have any favourite settings."),
                Results     => scalar @SettingList,
                SettingList => \@SettingList,
                %OutputData,
            },
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # direct link
    elsif ( $Self->{Subaction} eq 'View' ) {

        my $SettingName = $ParamObject->GetParam( Param => 'Setting' ) || '';
        my @SettingList;

        if ($SettingName) {

            # URL-decode setting name, just in case. Please see bug#13271 for more information.
            $SettingName = uri_unescape($SettingName);

            my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
            my %Setting         = $SysConfigObject->SettingGet(
                Name            => $SettingName,
                OverriddenInXML => 1,
                UserID          => $Self->{UserID},
            );

            if ( %Setting && !$Setting{IsInvisible} ) {

                $Setting{HTMLStrg} = $SysConfigObject->SettingRender(
                    Setting => \%Setting,
                    RW      => $Setting{ExclusiveLockGUID} ? 1 : 0,
                    UserID  => $Self->{UserID},
                );

                push @SettingList, \%Setting;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        my $DeploymentID = $ParamObject->GetParam( Param => 'DeploymentID' );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationView',
            Data         => {
                DeploymentID => $DeploymentID,
                View         => $SettingName,
                SettingList  => \@SettingList,
                %OutputData,
            },
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # direct link to a group of settings
    elsif ( $Self->{Subaction} eq 'ViewCustomGroup' ) {

        my @Names = $ParamObject->GetArray( Param => 'Names' );
        my @SettingList;
        my @SettingListInvalid;

        if ( scalar @Names ) {

            my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
            for my $Name ( sort @Names ) {

                my %Setting = $SysConfigObject->SettingGet(
                    Name            => $Name,
                    OverriddenInXML => 1,
                    UserID          => $Self->{UserID},
                );

                if (%Setting) {

                    $Setting{HTMLStrg} = $SysConfigObject->SettingRender(
                        Setting => \%Setting,
                        RW      => $Setting{ExclusiveLockGUID} ? 1 : 0,
                        UserID  => $Self->{UserID},
                    );

                    push @SettingList, \%Setting;
                }
                else {
                    push @SettingListInvalid, $Name;
                }
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ( scalar @SettingListInvalid ) {
            my $SettingsInvalid = join ', ', @SettingListInvalid;
            $Output .= $LayoutObject->Notify( Info => $LayoutObject->{LanguageObject}->Translate( "The following settings could not be found: %s", $SettingsInvalid ) );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationView',
            Data         => {
                %OutputData,
                Type               => 'CustomList',
                SettingList        => \@SettingList,
                SettingListInvalid => \@SettingListInvalid,
                CategoriesStrg     => $Self->_GetCategoriesStrg(),
            },
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # Only locked settings
    elsif ( $Self->{Subaction} eq 'SearchLocked' ) {

        my @SettingList;

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my @Result          = $SysConfigObject->ConfigurationLockedSettingsList(
            ExclusiveLockUserID => $Self->{UserID},
        );

        if ( scalar @Result ) {

            for my $SettingName ( sort @Result ) {

                my %Setting = $SysConfigObject->SettingGet(
                    Name            => $SettingName,
                    OverriddenInXML => 1,
                    UserID          => $Self->{UserID},
                );

                $Setting{HTMLStrg} = $SysConfigObject->SettingRender(
                    Setting => \%Setting,
                    RW      => $Setting{ExclusiveLockGUID} ? 1 : 0,
                    UserID  => $Self->{UserID},
                );
                push @SettingList, \%Setting;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationSearch',
            Data         => {
                Results     => scalar @SettingList,
                SettingList => \@SettingList,
                %OutputData,
            },
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # import/export
    elsif ( $Self->{Subaction} eq 'ImportExport' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationImportExport',
            Data         => {
            },
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # Export current configuration.
    elsif ( $Self->{Subaction} eq 'ConfigurationExport' ) {

        my $Filename = 'Export_Current_System_Configuration.yml';

        # Get configuration data.
        my $ConfigurationDumpYAML = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDump(
            SkipDefaultSettings  => 1,                                                               # Default settings are not needed.
            SkipModifiedSettings => 0,                                                               # Modified settings should always be present.
            SkipUserSettings     => $ParamObject->GetParam( Param => 'SkipUserSettings' ) ? 0 : 1,
        );

        # Send the result to the browser.
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $ConfigurationDumpYAML,
            Type        => 'attachment',
            Filename    => $Filename,
            NoCache     => 1,
        );
    }

    elsif ( $Self->{Subaction} eq 'ConfigurationImport' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        if ( !$Kernel::OM->Get('Kernel::Config')->Get('ConfigImportAllowed') ) {
            return $LayoutObject->FatalError(
                Message => Translatable('Import not allowed!'),
            );
        }

        my $FormID      = $ParamObject->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        my $ConfigurationLoad = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationLoad(
            ConfigurationYAML => $UploadStuff{Content},
            UserID            => $Self->{UserID},
        );

        my $ExtraParams;

        if ( !$ConfigurationLoad ) {

            return $LayoutObject->ErrorScreen(
                Message =>
                    Translatable(
                        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.'
                    ),
            );
        }
        elsif ( $ConfigurationLoad && $ConfigurationLoad eq '-1' ) {
            $ExtraParams = 'DontKnowSettings=1;';
        }

        return $LayoutObject->Redirect(
            OP => "Action=AdminSystemConfigurationDeployment;Subaction=Deployment;$ExtraParams"
        );
    }

    # Just show the overview.
    else {

        my @SettingList = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationList();

        # secure mode message (don't allow this action till secure mode is enabled)
        if ( !$Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
            return $LayoutObject->SecureMode();
        }

        # generate version for links to the manual,
        # only major and minor version are relevant, like 11.0 for version 11.0.1
        my ($ManualVersion) = $Kernel::OM->Get('Kernel::Config')->Get('Version') =~ m/^(\d{2}\.\d+)/;

        return join '',
            $LayoutObject->Header,
            $LayoutObject->NavigationBar,
            $LayoutObject->Output(
                TemplateFile => 'AdminSystemConfiguration',
                Data         => {
                    ManualVersion => $ManualVersion,
                    SettingCount  => scalar @SettingList,
                    %OutputData,
                },
            ),
            $LayoutObject->Footer;
    }
}

sub _GetCategoriesStrg {
    my ( $Self, %Param ) = @_;

    # get selected category
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $Category = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Category' )
        || $UserPreferences{UserSystemConfigurationCategory};
    my %Categories = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationCategoriesGet();

    my %CategoryData = map { $_ => $Categories{$_}->{DisplayName} } keys %Categories;

    my $CategoriesStrg = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data         => \%CategoryData,
        Name         => 'Category',
        SelectedID   => $Category || Translatable('All'),
        PossibleNone => 0,
        Translation  => 1,
        Sort         => 'AlphaNumericKey',
        Class        => 'Modernize',
        Title        => $Kernel::OM->Get('Kernel::Language')->Translate('Category Search'),
    );

    return $CategoriesStrg;
}

sub _CheckInvalidSettings {
    my ( $Self, %Param ) = @_;

    my @InvalidSettings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationInvalidList(
        CachedOnly => 1,
    );

    return 0 if !@InvalidSettings;

    return 1;
}

1;
