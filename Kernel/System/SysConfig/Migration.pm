# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::SysConfig::Migration;

use strict;
use warnings;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

use Kernel::System::VariableCheck qw( :all );

=head1 NAME

Kernel::System::SysConfig::Migration - System configuration settings migration tools.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SysConfigMigrationObject = $Kernel::OM->Get('Kernel::System::SysConfig::Migration');

=cut

sub new {
    my ( $Class ) = @_;

    # allocate new hash for object
    return bless {}, $Class;
}

=head2 MigrateConfigEffectiveValues()

Migrate the configs effective values to the new format for OTOBO 10.

    my $Result = $SysConfigMigrationObject->MigrateConfigEffectiveValues(
        FileClass       => $FileClass,
        FilePath        => $FilePath,
        NoOutput        => 1,                                       # ( 0 | 1 ) optional, default 0.
                                                                    # if set to 1 no info output will be printed to the screen.
        PackageSettings => [                                        # (optional) only migrate the given package settings
            'Frontend::Module###AdminGeneralCatalog',
            'Frontend::NavigationModule###AdminGeneralCatalog',
            'GeneralCatalogPreferences###Comment2',
            'GeneralCatalogPreferences###Permissions',
            'Loader::Agent::CommonJS###100-GeneralCatalog'
        ],
        PackageLookupNewConfigName => {
            'Ticket::EventModulePost###999-GenericInterface' => 'Ticket::EventModulePost###9900-GenericInterface',
        },
        ReturnMigratedSettingsCounts => 1,                          # (optional) returns an array with counts of un/successful migrated settings
    );

Returns:

    $Result = 1;    # True on success or false on error.
                    # or
                    # if ReturnMigratedSettingsCounts parameter is set
    $Result =  {
        AllSettingsCount      => 1,
        MissingSettings       => [],
        UnsuccessfullSettings => [],
    };

=cut

sub MigrateConfigEffectiveValues {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FileClass FilePath)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %OTOBO5Config;
    delete $INC{ $Param{FilePath} };
    $Kernel::OM->Get('Kernel::System::Main')->Require( $Param{FileClass} );
    $Param{FileClass}->Load( \%OTOBO5Config );

    my $OTOBO5ConfigFileContentList = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Param{FilePath},
        Result   => 'ARRAY',
    );

    my @DisabledOTOBO5Config;
    for my $Line ( @{$OTOBO5ConfigFileContentList} ) {

        # Check if the line starts with a delete.
        if ( $Line =~ m{ \A delete[ ]\$Self->\{(.+)\};}xms ) {
            my $DisabledSettingString = $1;
            $DisabledSettingString =~ s{['"]}{}xmsg;
            $DisabledSettingString =~ s{\}->\{}{###}xmsg;
            push @DisabledOTOBO5Config, $DisabledSettingString;
        }
    }

    # get all OTOBO 10 default settings
    my @DefaultSettings = $SysConfigObject->ConfigurationList();

    # search for settings with ### in the name
    # my @SearchResult = grep /###/, sort values %DefaultSettings;
    my @SearchResult = grep { $_->{Name} =~ m{###} } @DefaultSettings;

    # find all the setting which have sublevels and store them in a hash for OTOBO 10
    my %SettingsWithSubLevelsOTOBO6;
    for my $Setting (@SearchResult) {

        my @SettingNameParts = split /###/, $Setting->{Name};

        my $FirstLevelKey = shift @SettingNameParts;
        my $LastLevelKey  = pop @SettingNameParts;

        if (
            @SettingNameParts

            # Skip any setting with more than one sub-levels in hash key (unsupported in OTOBO 5).
            && !defined $SettingsWithSubLevelsOTOBO6{$FirstLevelKey}->{ $SettingNameParts[0] }
            )
        {
            $SettingsWithSubLevelsOTOBO6{$FirstLevelKey}->{ $SettingNameParts[0] }->{$LastLevelKey} = 1;
        }
        else {
            $SettingsWithSubLevelsOTOBO6{$FirstLevelKey}->{$LastLevelKey} = 1;
        }
    }

    # get the needed ArticleTypeMapping from a YML file (needed for Postmaster filter settings later)
    my $TaskConfig         = $Self->GetTaskConfig( Module => 'MigrateArticleData' );
    my %ArticleTypeMapping = %{ $TaskConfig->{ArticleTypeMapping} };

    # build a lookup hash of all given package settings
    my %PackageSettingLookup;
    if ( IsArrayRefWithData( $Param{PackageSettings} ) ) {
        %PackageSettingLookup = map { $_ => 1 } @{ $Param{PackageSettings} };
    }

    # to store settings which do not exist in OTOBO 10
    my @MissingSettings;

    # to store unsuccessfull settings which could not be migrated
    my @UnsuccessfullSettings;

    # Add an additional mapping for 2-Level settings, which have a renamed first part.
    if ( $Param{PackageLookupNewConfigName} ) {

        my %AdditionalMapping;
        for my $OldName ( sort keys %{ $Param{PackageLookupNewConfigName} } ) {
            my $NewName = $Param{PackageLookupNewConfigName}->{$OldName};

            $OldName =~ s{#.*\z}{}ms;
            $NewName =~ s{#.*\z}{}ms;
            $AdditionalMapping{$OldName} = $NewName;
        }

        %{ $Param{PackageLookupNewConfigName} } = ( %{ $Param{PackageLookupNewConfigName} }, %AdditionalMapping );
    }

    SETTINGNAME:
    for my $SettingName ( sort keys %OTOBO5Config ) {

        # skip loader common settings
        next SETTINGNAME if $SettingName eq 'Loader::Agent::CommonCSS';
        next SETTINGNAME if $SettingName eq 'Loader::Agent::CommonJS';
        next SETTINGNAME if $SettingName eq 'Loader::Customer::CommonCSS';
        next SETTINGNAME if $SettingName eq 'Loader::Customer::CommonJS';

        # skip no longer existing sysconfig settings
        next SETTINGNAME if $SettingName eq 'CustomerPreferencesView';
        next SETTINGNAME if $SettingName eq 'DisableMSIFrameSecurityRestricted';
        next SETTINGNAME if $SettingName eq 'Frontend::AnimationEnabled';
        next SETTINGNAME if $SettingName eq 'LogModule::SysLog::LogSock';
        next SETTINGNAME if $SettingName eq 'PreferencesView';
        next SETTINGNAME if $SettingName eq 'Ticket::Frontend::ComposeExcludeCcRecipients';
        next SETTINGNAME if $SettingName eq 'TimeZoneUser';
        next SETTINGNAME if $SettingName eq 'TimeZoneUserBrowserAutoOffset';
        next SETTINGNAME if $SettingName eq 'Ticket::StorageModule';
        next SETTINGNAME if $SettingName eq 'Ticket::StorageModule::CheckAllBackends';
        next SETTINGNAME if $SettingName eq 'ArticleDir';

        my $CheckSubLevels;
        if ( $SettingsWithSubLevelsOTOBO6{$SettingName} ) {
            $CheckSubLevels = 1;
        }
        elsif (
            $Param{PackageLookupNewConfigName}
            && $Param{PackageLookupNewConfigName}->{$SettingName}
            && $SettingsWithSubLevelsOTOBO6{ $Param{PackageLookupNewConfigName}->{$SettingName} }
            )
        {
            $CheckSubLevels = 1;
        }

        # check if this OTOBO5 setting has subhashes in the name
        if ($CheckSubLevels) {

            SETTINGKEYFIRSTLEVEL:
            for my $SettingKeyFirstLevel ( sort keys %{ $OTOBO5Config{$SettingName} } ) {

                # there is a second level
                # example: Ticket::Frontend::AgentTicketZoom###Widgets###0100-TicketInformation
                if (
                    $SettingsWithSubLevelsOTOBO6{$SettingName}->{$SettingKeyFirstLevel}
                    && IsHashRefWithData( $SettingsWithSubLevelsOTOBO6{$SettingName}->{$SettingKeyFirstLevel} )
                    && IsHashRefWithData( $OTOBO5Config{$SettingName}->{$SettingKeyFirstLevel} )
                    )
                {

                    SETTINGKEYSECONDLEVEL:
                    for my $SettingKeySecondLevel (
                        sort keys %{ $OTOBO5Config{$SettingName}->{$SettingKeyFirstLevel} }
                        )
                    {

                        # get the effective value from the OTOBO 5 config
                        my $OTOBO5EffectiveValue
                            = $OTOBO5Config{$SettingName}->{$SettingKeyFirstLevel}->{$SettingKeySecondLevel};

                        # build the new setting key
                        my $NewSettingKey
                            = $SettingName . '###' . $SettingKeyFirstLevel . '###' . $SettingKeySecondLevel;

                        # check and convert config name if it has been renamed in OTOBO 10
                        # otherwise it will use the given old name
                        $NewSettingKey = $Self->_LookupNewConfigName(
                            OldName                    => $NewSettingKey,
                            PackageLookupNewConfigName => $Param{PackageLookupNewConfigName},
                        );

                        # skip settings which are not in the given package settings
                        if ( %PackageSettingLookup && !$PackageSettingLookup{$NewSettingKey} ) {
                            next SETTINGKEYSECONDLEVEL;
                        }

                        # try to get the default setting from OTOBO 10 for the new setting name
                        my %OTOBO6Setting = $SysConfigObject->SettingGet(
                            Name  => $NewSettingKey,
                            NoLog => 1,
                        );

                        # skip settings which already have been modified in the meantime
                        next SETTINGKEYSECONDLEVEL if $OTOBO6Setting{ModifiedID};

                        # skip this setting if it is a readonly setting
                        next SETTINGKEYSECONDLEVEL if $OTOBO6Setting{IsReadonly};

                        # log if there is a setting that can not be found in OTOBO 10 (might come from packages)
                        if ( !%OTOBO6Setting ) {
                            push @MissingSettings, $NewSettingKey;
                            next SETTINGKEYSECONDLEVEL;
                        }

                        # check if the setting value structure from OTOBO 5 is still valid on OTOBO6
                        my %Result = $SysConfigObject->SettingEffectiveValueCheck(
                            EffectiveValue   => $OTOBO5EffectiveValue,
                            XMLContentParsed => $OTOBO6Setting{XMLContentParsed},
                            NoValidation     => 1,
                            UserID           => 1,
                        );

                        if ( !$Result{Success} ) {
                            push @UnsuccessfullSettings, $NewSettingKey;
                            next SETTINGKEYSECONDLEVEL;
                        }

                        # update the setting.
                        %Result = $Self->_SettingUpdate(
                            Name           => $NewSettingKey,
                            IsValid        => 1,
                            EffectiveValue => $OTOBO5EffectiveValue,
                        );

                        if ( !$Result{Success} ) {
                            push @UnsuccessfullSettings, $NewSettingKey;
                            next SETTINGKEYSECONDLEVEL;
                        }
                    }
                }

                # there is only one level
                # example: Ticket::Frontend::AgentTicketService###StripEmptyLines
                else {

                    # get the effective value from the OTOBO 5 config
                    my $OTOBO5EffectiveValue = $OTOBO5Config{$SettingName}->{$SettingKeyFirstLevel};

                    # build the new setting key
                    my $NewSettingKey = $SettingName . '###' . $SettingKeyFirstLevel;

                    # Skip not longer existing settings.
                    if ( $NewSettingKey eq 'Ticket::Frontend::OverviewSmall###ColumnHeader' ) {
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # check and convert config name if it has been renamed in OTOBO 10
                    # otherwise it will use the given old name
                    $NewSettingKey = $Self->_LookupNewConfigName(
                        OldName                    => $NewSettingKey,
                        PackageLookupNewConfigName => $Param{PackageLookupNewConfigName},
                    );

                    # skip settings which are not in the given package settings
                    if ( %PackageSettingLookup && !$PackageSettingLookup{$NewSettingKey} ) {
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # try to get the default setting from OTOBO 10 for the modified setting name
                    my %OTOBO6Setting = $SysConfigObject->SettingGet(
                        Name  => $NewSettingKey,
                        NoLog => 1,
                    );

                    # skip settings which already have been modified in the meantime
                    next SETTINGKEYFIRSTLEVEL if $OTOBO6Setting{ModifiedID};

                    # skip this setting if it is a readonly setting
                    next SETTINGKEYFIRSTLEVEL if $OTOBO6Setting{IsReadonly};

                    # log if there is a setting that can not be found in OTOBO 10 (might come from packages)
                    if ( !%OTOBO6Setting ) {
                        push @MissingSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # migrate frontend module registrations
                    if (
                        $SettingName eq 'Frontend::Module'
                        || $SettingName eq 'CustomerFrontend::Module'
                        || $SettingName eq 'PublicFrontend::Module'
                        )
                    {

                        # migrate (and split) the frontend module settings
                        my $Result = $Self->_MigrateFrontendModuleSetting(
                            FrontendSettingName  => $SettingName,
                            FrontendModuleName   => $SettingKeyFirstLevel,
                            OTOBO5EffectiveValue => $OTOBO5EffectiveValue,
                            OTOBO6Setting        => \%OTOBO6Setting,
                        );

                        # success
                        next SETTINGKEYFIRSTLEVEL if $Result;

                        # error
                        push @UnsuccessfullSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # migrate preferences groups settings
                    if ( $SettingName eq 'PreferencesGroups' ) {

                        # delete no longer needed column key
                        delete $OTOBO5EffectiveValue->{Column};

                        # add new PreferenceGroup key from OTOBO 10
                        $OTOBO5EffectiveValue->{PreferenceGroup} = $OTOBO6Setting{EffectiveValue}->{PreferenceGroup};
                    }

                    # Migrate Postmaster settings for
                    #   PostMaster::PreFilterModule
                    #   PostMaster::PreCreateFilterModule
                    #   PostMaster::PostFilterModule
                    #   PostMaster::CheckFollowUpModule
                    if (
                        $SettingName
                        =~ m{ \A PostMaster::(PreFilter|PreCreateFilter|PostFilter|CheckFollowUp)Module \z }xms
                        )
                    {

                        # update no longer existing module.
                        if (
                            $OTOBO5EffectiveValue->{Module} eq
                            'Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck'
                            )
                        {
                            $OTOBO5EffectiveValue->{Module}
                                = 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck';
                        }

                        # Define mapping for old to new keys.
                        my %Old2NewKeyMapping = (
                            'X-OTOBO-ArticleType'          => 'X-OTOBO-IsVisibleForCustomer',
                            'X-OTOBO-FollowUp-ArticleType' => 'X-OTOBO-FollowUp-IsVisibleForCustomer',
                            'ArticleType'                  => 'IsVisibleForCustomer',
                        );

                        OLDKEY:
                        for my $OldKey ( sort keys %Old2NewKeyMapping ) {

                            my $NewKey = $Old2NewKeyMapping{$OldKey};

                            # Convert subentries below Match and Set.
                            AREA:
                            for my $Area (qw(Match Set)) {
                                next AREA if !IsHashRefWithData( $OTOBO5EffectiveValue->{$Area} );
                                next AREA if !$OTOBO5EffectiveValue->{$Area}->{$OldKey};

                                # Add the new key with the converted value from the old key.
                                $OTOBO5EffectiveValue->{$Area}->{$NewKey}
                                    = $ArticleTypeMapping{ $OTOBO5EffectiveValue->{$Area}->{$OldKey} }->{Visible};

                                # Delete the old key.
                                delete $OTOBO5EffectiveValue->{$Area}->{$OldKey};
                            }

                            # Convert direct entries.
                            next OLDKEY if !$OTOBO5EffectiveValue->{$OldKey};

                            # Add the new key with the converted value from the old key.
                            $OTOBO5EffectiveValue->{$NewKey}
                                = $ArticleTypeMapping{ $OTOBO5EffectiveValue->{$OldKey} }->{Visible};

                            # Delete the old key.
                            delete $OTOBO5EffectiveValue->{$OldKey};
                        }
                    }

                    # check if the setting value structure from OTOBO 5 is still valid on OTOBO6
                    my %Result = $SysConfigObject->SettingEffectiveValueCheck(
                        EffectiveValue   => $OTOBO5EffectiveValue,
                        XMLContentParsed => $OTOBO6Setting{XMLContentParsed},
                        NoValidation     => 1,
                        UserID           => 1,
                    );

                    if ( !$Result{Success} ) {
                        push @UnsuccessfullSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # update the setting.
                    %Result = $Self->_SettingUpdate(
                        Name           => $NewSettingKey,
                        IsValid        => 1,
                        EffectiveValue => $OTOBO5EffectiveValue,
                    );

                    if ( !$Result{Success} ) {
                        push @UnsuccessfullSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }
                }
            }
        }

        # setting has no subhashes in the name
        # example: Cache::Module
        else {

            # skip TimeZone::Calendar settings (they are handled else where)
            next SETTINGNAME if $SettingName =~ m{ \A TimeZone::Calendar[1-9] \z }xms;

            # check and convert config name if it has been renamed in OTOBO 10
            # otherwise it will use the given old name
            my $NewSettingName = $Self->_LookupNewConfigName(
                OldName                    => $SettingName,
                PackageLookupNewConfigName => $Param{PackageLookupNewConfigName},
            );

            # skip settings which are not in the given package settings
            if ( %PackageSettingLookup && !$PackageSettingLookup{$NewSettingName} ) {
                next SETTINGNAME;
            }

            # get the (default) setting from OTOBO 10 for this setting name
            my %OTOBO6Setting = $SysConfigObject->SettingGet(
                Name  => $NewSettingName,
                NoLog => 1,
            );

            # skip this setting if it has already been modified in the meantime
            next SETTINGNAME if $OTOBO6Setting{ModifiedID};

            # skip this setting if it is a readonly setting
            next SETTINGNAME if $OTOBO6Setting{IsReadonly};

            # Log if there is a setting that can not be found in OTOBO 10 (might come from packages)
            if ( !%OTOBO6Setting ) {
                push @MissingSettings, $NewSettingName;
                next SETTINGNAME;
            }

            my $OTOBO5EffectiveValue = $OTOBO5Config{$SettingName};

            # the ticket number generator random is dropped from OTOBO 10, enforce that DateChecksum is set instead
            if (
                $NewSettingName eq 'Ticket::NumberGenerator'
                && $OTOBO5EffectiveValue eq 'Kernel::System::Ticket::Number::Random'
                )
            {
                $OTOBO5EffectiveValue = 'Kernel::System::Ticket::Number::DateChecksum';
            }

            # check if the setting value structure from OTOBO 5 is still valid on OTOBO6
            my %Result = $SysConfigObject->SettingEffectiveValueCheck(
                EffectiveValue   => $OTOBO5EffectiveValue,
                XMLContentParsed => $OTOBO6Setting{XMLContentParsed},
                NoValidation     => 1,
                UserID           => 1,
            );

            if ( !$Result{Success} ) {

                push @UnsuccessfullSettings, $NewSettingName;
                next SETTINGNAME;
            }

            # update the setting.
            %Result = $Self->_SettingUpdate(
                Name           => $NewSettingName,
                IsValid        => 1,
                EffectiveValue => $OTOBO5EffectiveValue,
            );

            if ( !$Result{Success} ) {
                push @UnsuccessfullSettings, $NewSettingName;
                next SETTINGNAME;
            }
        }
    }

    my $DisabledSettingsCount = 0;

    # Set all settings which are disabled in OTOBO 5 to disabled.
    DISABLEDSETTINGNAME:
    for my $DisabledSettingKey (@DisabledOTOBO5Config) {

        # Check and convert config name if it has been renamed in OTOBO 10
        #   otherwise it will use the given old name.
        my $NewSettingKey = $Self->_LookupNewConfigName(
            OldName                    => $DisabledSettingKey,
            PackageLookupNewConfigName => $Param{PackageLookupNewConfigName},
        );

        # Skip settings which are not in the given package settings.
        if ( %PackageSettingLookup && !$PackageSettingLookup{$NewSettingKey} ) {
            next DISABLEDSETTINGNAME;
        }

        # Try to get the default setting from OTOBO 10 for the modified setting name.
        my %OTOBO6Setting = $SysConfigObject->SettingGet(
            Name  => $NewSettingKey,
            NoLog => 1,
        );

        # Skip settings which already have been modified in the meantime.
        next DISABLEDSETTINGNAME if $OTOBO6Setting{ModifiedID};

        # Skip this setting if it is a readonly setting.
        next DISABLEDSETTINGNAME if $OTOBO6Setting{IsReadonly};

        # Skip this setting if it is a required setting.
        next DISABLEDSETTINGNAME if $OTOBO6Setting{IsRequired};

        # Log if there is a setting that can not be found in OTOBO 10 (might come from packages).
        if ( !%OTOBO6Setting ) {
            push @MissingSettings, $NewSettingKey;
            next DISABLEDSETTINGNAME;
        }

        # Disable the setting.
        my %Result = $Self->_SettingUpdate(
            Name    => $NewSettingKey,
            IsValid => 0,
        );

        if ( !$Result{Success} ) {
            push @UnsuccessfullSettings, $NewSettingKey;
            next DISABLEDSETTINGNAME;
        }

        $DisabledSettingsCount++;
    }

    # do not print the following status output if not wanted
    return 1 if $Param{NoOutput};

    my $AllSettingsCount = scalar keys %OTOBO5Config;

    print "\n";
    print "        - AllSettingsCount: " . $AllSettingsCount . "\n";
    print "        - DisabledCount: " . $DisabledSettingsCount . "\n";
    print "        - MissingCount: " . scalar @MissingSettings . "\n";
    print "        - UnsuccessfullCount: " . scalar @UnsuccessfullSettings . "\n\n";

    if (@MissingSettings) {
        print "\nMissing Settings: \n";
        for my $Setting (@MissingSettings) {
            print $Setting . "\n";
        }
    }

    if (@UnsuccessfullSettings) {
        print "\nUnsuccessfull Settings: \n";
        for my $Setting (@UnsuccessfullSettings) {
            print $Setting . "\n";
        }
    }

    if ( $Param{ReturnMigratedSettingsCounts} ) {
        return {
            AllSettingsCount      => $AllSettingsCount,
            DisabledSettingsCount => $DisabledSettingsCount,
            MissingSettings       => \@MissingSettings,
            UnsuccessfullSettings => \@UnsuccessfullSettings,
        };
    }

    return 1;
}

=head2 NavigationLookupGet()

Get a list of all old Sub-Groups and the corresponding new navigation.

    my %NavigationLookup = $SysConfigMigrationObject->NavigationLookupGet();

Returns:

    %NavigationLookup = (
        'Old::Subgroup' => 'New::Navigation',
        # ...
    );

=cut

sub NavigationLookupGet {
    my ( $Self, %Param ) = @_;

    return (
        'CloudService::Admin::ModuleRegistration'      => 'CloudService::Admin::ModuleRegistration',
        'ConfigLog'                                    => 'ConfigLog',
        'ConfigSwitch'                                 => 'ConfigSwitch',
        'Core'                                         => 'Core',
        'Core::AppointmentCalendar::Event'             => 'Core::Event::AppointmentCalendar',
        'Core::Cache'                                  => 'Core::Cache',
        'Core::CustomerCompany'                        => 'Core::CustomerCompany',
        'Core::CustomerUser'                           => 'Core::CustomerUser',
        'Core::Daemon::ModuleRegistration'             => 'Daemon::ModuleRegistration',
        'Core::DynamicField'                           => 'Core::DynamicFields',
        'Core::Fetchmail'                              => 'Core::Email',
        'Core::FulltextSearch'                         => 'Core::Ticket::FulltextSearch',
        'Core::LinkObject'                             => 'Core::LinkObject',
        'Core::Log'                                    => 'Core::Log',
        'Core::MIME-Viewer'                            => 'Frontend::Agent::MIMEViewer',
        'Core::MirrorDB'                               => 'Core::DB::Mirror',
        'Core::Package'                                => 'Core::Package',
        'Core::PDF'                                    => 'Core::PDF',
        'Core::PerformanceLog'                         => 'Core::PerformanceLog',
        'Core::PostMaster'                             => 'Core::Email::PostMaster',
        'Core::Queue'                                  => 'Core::Queue',
        'Core::ReferenceData'                          => 'Core::ReferenceData',
        'Core::Sendmail'                               => 'Core::Email',
        'Core::Session'                                => 'Core::Session',
        'Core::SOAP'                                   => 'Core::SOAP',
        'Core::Stats'                                  => 'Core::Stats',
        'Core::Ticket'                                 => 'Core::Ticket',
        'Core::TicketACL'                              => 'Core::Ticket::ACL',
        'Core::TicketBulkAction'                       => 'Frontend::Agent::View::TicketBulk',
        'Core::TicketDynamicFieldDefault'              => 'Core::Ticket::DynamicFieldDefault',
        'Core::TicketWatcher'                          => 'Core::Ticket',
        'Core::Time'                                   => 'Core::Time',
        'Core::Time::Calendar1'                        => 'Core::Time::Calendar1',
        'Core::Time::Calendar2'                        => 'Core::Time::Calendar2',
        'Core::Time::Calendar3'                        => 'Core::Time::Calendar3',
        'Core::Time::Calendar4'                        => 'Core::Time::Calendar4',
        'Core::Time::Calendar5'                        => 'Core::Time::Calendar5',
        'Core::Time::Calendar6'                        => 'Core::Time::Calendar6',
        'Core::Time::Calendar7'                        => 'Core::Time::Calendar7',
        'Core::Time::Calendar8'                        => 'Core::Time::Calendar8',
        'Core::Time::Calendar9'                        => 'Core::Time::Calendar9',
        'Core::Transition'                             => 'Core::ProcessManagement',
        'Core::Web'                                    => 'Frontend::Base',
        'Core::WebUserAgent'                           => 'Core::WebUserAgent',
        'Crypt::PGP'                                   => 'Core::Crypt::PGP',
        'Crypt::SMIME'                                 => 'Core::Crypt::SMIME',
        'CustomerInformationCenter'                    => 'Frontend::Agent::View::CustomerInformationCenter',
        'Daemon::SchedulerCronTaskManager::Task'       => 'Daemon::SchedulerCronTaskManager::Task',
        'Daemon::SchedulerGenericAgentTaskManager'     => 'Daemon::SchedulerGenericAgentTaskManager',
        'Daemon::SchedulerGenericInterfaceTaskManager' => 'Daemon::SchedulerGenericInterfaceTaskManager',
        'Daemon::SchedulerTaskWorker'                  => 'Daemon::SchedulerTaskWorker',
        'DynamicFields::Driver::Registration'          => 'Core::DynamicFields::DriverRegistration',
        'DynamicFields::ObjectType::Registration'      => 'Core::DynamicFields::ObjectTypeRegistration',

        # 'Frontend::Admin'                                  => 'Frontend::Admin',
        'Frontend::Admin::AdminCustomerCompany'   => 'Frontend::Admin::View::CustomerCompany',
        'Frontend::Admin::AdminCustomerUser'      => 'Frontend::Admin::View::CustomerUser',
        'Frontend::Admin::AdminNotificationEvent' => 'Frontend::Admin::View::NotificationEvent',
        'Frontend::Admin::AdminSelectBox'         => 'Frontend::Admin::View::SelectBox',

        # 'Frontend::Admin::ModuleRegistration'              => 'Frontend::Admin::ModuleRegistration',
        'Frontend::Admin::SearchRouter'                    => 'Frontend::Admin::ModuleRegistration::MainMenu::Search',
        'Frontend::Agent'                                  => 'Frontend::Agent',
        'Frontend::Agent::Auth::TwoFactor'                 => 'Core::Auth::Agent::TwoFactor',
        'Frontend::Agent::Dashboard'                       => 'Frontend::Agent::View::Dashboard',
        'Frontend::Agent::Dashboard::EventsTicketCalendar' => 'Frontend::Agent::View::Dashboard::EventsTicketCalendar',
        'Frontend::Agent::Dashboard::TicketFilters'        => 'Frontend::Agent::View::Dashboard::TicketFilters',
        'Frontend::Agent::LinkObject'                      => 'Frontend::Agent::LinkObject',
        'Frontend::Agent::ModuleMetaHead'                  => 'Frontend::Agent',
        'Frontend::Agent::ModuleNotify'                    => 'Frontend::Agent::FrontendNotification',
        'Frontend::Agent::NavBarModule'                    => 'Frontend::Agent::ModuleRegistration',
        'Frontend::Agent::Preferences'                     => 'Frontend::Agent::View::Preferences',
        'Frontend::Agent::SearchRouter'                    => 'Frontend::Agent::ModuleRegistration::MainMenu::Search',
        'Frontend::Agent::Stats'                           => 'Frontend::Agent::Stats',
        'Frontend::Agent::Ticket::ArticleAttachmentModule' => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::Ticket::ArticleComposeModule'    => 'Frontend::Agent::ArticleComposeModule',
        'Frontend::Agent::Ticket::ArticleViewModule'       => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::Ticket::ArticleViewModulePre'    => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::Ticket::MenuModule'              => 'Frontend::Agent::View::TicketZoom::MenuModule',
        'Frontend::Agent::Ticket::MenuModulePre'           => 'Frontend::Agent::TicketOverview::MenuModule',
        'Frontend::Agent::Ticket::OverviewMenuModule'      => 'Frontend::Agent::TicketOverview::MenuModule',
        'Frontend::Agent::Ticket::ViewBounce'              => 'Frontend::Agent::View::TicketBounce',
        'Frontend::Agent::Ticket::ViewBulk'                => 'Frontend::Agent::View::TicketBulk',
        'Frontend::Agent::Ticket::ViewClose'               => 'Frontend::Agent::View::TicketClose',
        'Frontend::Agent::Ticket::ViewCompose'             => 'Frontend::Agent::View::TicketCompose',
        'Frontend::Agent::Ticket::ViewCustomer'            => 'Frontend::Agent::View::TicketCustomer',
        'Frontend::Agent::Ticket::ViewEmailNew'            => 'Frontend::Agent::View::TicketEmailNew',
        'Frontend::Agent::Ticket::ViewEmailOutbound'       => 'Frontend::Agent::View::TicketEmailOutbound',
        'Frontend::Agent::Ticket::ViewEscalation'          => 'Frontend::Agent::View::TicketEscalation',
        'Frontend::Agent::Ticket::ViewForward'             => 'Frontend::Agent::View::TicketForward',
        'Frontend::Agent::Ticket::ViewFreeText'            => 'Frontend::Agent::View::TicketFreeText',
        'Frontend::Agent::Ticket::ViewHistory'             => 'Frontend::Agent::View::TicketHistory',
        'Frontend::Agent::Ticket::ViewLocked'              => 'Frontend::Agent::View::TicketLocked',
        'Frontend::Agent::Ticket::ViewMerge'               => 'Frontend::Agent::View::TicketMerge',
        'Frontend::Agent::Ticket::ViewMove'                => 'Frontend::Agent::View::TicketMove',
        'Frontend::Agent::Ticket::ViewNote'                => 'Frontend::Agent::View::TicketNote',
        'Frontend::Agent::Ticket::ViewOwner'               => 'Frontend::Agent::View::TicketOwner',
        'Frontend::Agent::Ticket::ViewPending'             => 'Frontend::Agent::View::TicketPending',
        'Frontend::Agent::Ticket::ViewPhoneInbound'        => 'Frontend::Agent::View::TicketPhoneInbound',
        'Frontend::Agent::Ticket::ViewPhoneNew'            => 'Frontend::Agent::View::TicketPhoneNew',
        'Frontend::Agent::Ticket::ViewPhoneOutbound'       => 'Frontend::Agent::View::TicketPhoneOutbound',
        'Frontend::Agent::Ticket::ViewPrint'               => 'Frontend::Agent::View::TicketPrint',
        'Frontend::Agent::Ticket::ViewPriority'            => 'Frontend::Agent::View::TicketPriority',
        'Frontend::Agent::Ticket::ViewProcess'             => 'Frontend::Agent::View::TicketProcess',
        'Frontend::Agent::Ticket::ViewQueue'               => 'Frontend::Agent::View::TicketQueue',
        'Frontend::Agent::Ticket::ViewResponsible'         => 'Frontend::Agent::View::TicketResponsible',
        'Frontend::Agent::Ticket::ViewSearch'              => 'Frontend::Agent::View::TicketSearch',
        'Frontend::Agent::Ticket::ViewService'             => 'Frontend::Agent::View::TicketService',
        'Frontend::Agent::Ticket::ViewStatus'              => 'Frontend::Agent::View::TicketStatus',
        'Frontend::Agent::Ticket::ViewWatch'               => 'Frontend::Agent::View::TicketWatch',
        'Frontend::Agent::Ticket::ViewZoom'                => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::TicketOverview'                  => 'Frontend::Agent::TicketOverview',
        'Frontend::Agent::ToolBarModule'                   => 'Frontend::Agent::ToolBar',
        'Frontend::Agent::ViewCustomerUserSearch'          => 'Frontend::Agent::View::CustomerUserAddressBook',
        'Frontend::Agent::CustomerInformationCenter'       => 'Frontend::Agent::View::CustomerInformationCenter',
        'Frontend::Agent::Stats'                           => 'Frontend::Agent::View::Stats',
        'Frontend::Customer'                               => 'Frontend::Customer',
        'Frontend::Customer::Auth'                         => 'Core::Auth::Customer',
        'Frontend::Customer::Auth::TwoFactor'              => 'Core::Auth::Customer::TwoFactor',
        'Frontend::Customer::ModuleMetaHead'               => 'Frontend::Customer',
        'Frontend::Customer::ModuleNotify'                 => 'Frontend::Customer::FrontendNotification',
        'Frontend::Customer::ModuleRegistration'           => 'Frontend::Customer::ModuleRegistration',
        'Frontend::Customer::NavBarModule'                 => 'Frontend::Customer::ModuleRegistration',
        'Frontend::Customer::Preferences'                  => 'Frontend::Customer::View::Preferences',
        'Frontend::Customer::Ticket::ViewNew'              => 'Frontend::Customer::View::TicketMessage',
        'Frontend::Customer::Ticket::ViewPrint'            => 'Frontend::Customer::View::TicketPrint',
        'Frontend::Customer::Ticket::ViewSearch'           => 'Frontend::Customer::View::TicketSearch',
        'Frontend::Customer::Ticket::ViewZoom'             => 'Frontend::Customer::View::TicketZoom',
        'Frontend::Customer::TicketOverview'               => 'Frontend::Customer::View::TicketOverview',
        'Frontend::Public'                                 => 'Frontend::Public',
        'Frontend::Public::ModuleRegistration'             => 'Frontend::Public::ModuleRegistration',
        'Frontend::Queue::Preferences'                     => 'Core::Queue',
        'Frontend::Service::Preferences'                   => 'Core::Service',
        'Frontend::SLA::Preferences'                       => 'Core::SLA',
        'GenericInterface::Invoker::ModuleRegistration'    => 'GenericInterface::Invoker::ModuleRegistration',
        'GenericInterface::Mapping::ModuleRegistration'    => 'GenericInterface::Mapping::ModuleRegistration',
        'GenericInterface::Operation::ModuleRegistration'  => 'GenericInterface::Operation::ModuleRegistration',
        'GenericInterface::Operation::ResponseLoggingMaxSize' => 'GenericInterface::Operation::ResponseLoggingMaxSize',
        'GenericInterface::Operation::TicketCreate'           => 'GenericInterface::Operation::TicketCreate',
        'GenericInterface::Operation::TicketSearch'           => 'GenericInterface::Operation::TicketSearch',
        'GenericInterface::Operation::TicketUpdate'           => 'GenericInterface::Operation::TicketUpdate',
        'GenericInterface::Transport::ModuleRegistration'     => 'GenericInterface::Transport::ModuleRegistration',
        'GenericInterface::Webservice'                        => 'GenericInterface::Webservice',
        'SystemMaintenance'                                   => 'Core::SystemMaintenance',

        # Packages
        'OutputFilter'                       => 'Frontend::Base::OutputFilter',
        'Frontend::Customer::ModuleMetaHead' => 'Frontend::Customer',
        'Frontend::Public::ModuleMetaHead'   => 'Frontend::Public',

        # OTOBOCommunity
        'Core::NotificationEvent'               => 'Frontend::Agent::View::NotificationView',
        'Core::NotificationView'                => 'Frontend::Agent::View::NotificationView',
        'Core::NotificationView::BulkAction'    => 'Frontend::Agent::View::NotificationView',
        'Frontend::Agent::NotificationView'     => 'Frontend::Agent::View::NotificationView',
        'Frontend'                              => 'Frontend::Base',
        'Frontend::Admin::AdminContactWithData' => 'Frontend::Admin::View::ContactWithData',
    );
}

=head1 PRIVATE INTERFACE

=head2 _LookupNewConfigName()

Helper function to lookup new config names for configuration settings
where the name has been changed from OTOBO 5 to OTOBO 10.

    my $NewName = $SysConfigMigrationObject->_LookupNewConfigName(
        OldName => 'CustomerCompany::EventModulePost###100-UpdateCustomerUsers',
    );

Returns:

    True on success or false on error.

=cut

sub _LookupNewConfigName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OldName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OldName!",
        );
        return;
    }

    # mapping table: old name -> new name
    my %Old2NewName = (
        'CustomerCompany::EventModulePost###100-UpdateCustomerUsers' =>
            'CustomerCompany::EventModulePost###2000-UpdateCustomerUsers',

        'CustomerCompany::EventModulePost###110-UpdateTickets' =>
            'CustomerCompany::EventModulePost###2300-UpdateTickets',

        'CustomerCompany::EventModulePost###1000-GenericInterface' =>
            'CustomerCompany::EventModulePost###9900-GenericInterface',

        'CustomerUser::EventModulePost###100-UpdateDynamicFieldObjectName' =>
            'CustomerUser::EventModulePost###2000-UpdateDynamicFieldObjectName',

        'CustomerUser::EventModulePost###100-UpdateSearchProfiles' =>
            'CustomerUser::EventModulePost###2100-UpdateSearchProfiles',

        'CustomerUser::EventModulePost###100-UpdateServiceMembership' =>
            'CustomerUser::EventModulePost###2200-UpdateServiceMembership',

        'CustomerUser::EventModulePost###1000-GenericInterface' =>
            'CustomerUser::EventModulePost###9900-GenericInterface',

        'CustomerUser::EventModulePost###120-UpdateTickets' =>
            'CustomerUser::EventModulePost###2300-UpdateTickets',

        'DynamicField::EventModulePost###1000-GenericInterface' =>
            'DynamicField::EventModulePost###9900-GenericInterface',

        'Frontend::NotifyModule###5-Ticket::TicketEscalation' =>
            'Frontend::NotifyModule###5000-Ticket::TicketEscalation',

        'Frontend::NotifyModule###100-CloudServicesDisabled' =>
            'Frontend::NotifyModule###1000-CloudServicesDisabled',

        'Frontend::NotifyModule###200-UID-Check' =>
            'Frontend::NotifyModule###2000-UID-Check',

        'Frontend::NotifyModule###300-ShowAgentOnline' =>
            'Frontend::NotifyModule###3000-ShowAgentOnline',

        'Frontend::NotifyModule###400-ShowCustomerOnline' =>
            'Frontend::NotifyModule###4000-ShowCustomerOnline',

        'Frontend::NotifyModule###500-OutofOffice-Check' =>
            'Frontend::NotifyModule###5500-OutofOffice-Check',

        'Frontend::NotifyModule###600-SystemMaintenance-Check' =>
            'Frontend::NotifyModule###6000-SystemMaintenance-Check',

        'Frontend::NotifyModule###700-AgentTimeZone-Check' =>
            'Frontend::NotifyModule###7000-AgentTimeZone-Check',

        'Frontend::NotifyModule###800-Daemon-Check' =>
            'Frontend::NotifyModule###8000-Daemon-Check',

        'Frontend::NotifyModule###900-Generic' =>
            'Frontend::NotifyModule###9000-Generic',

        'Frontend::ToolBarModule###1-Ticket::AgentTicketQueue' =>
            'Frontend::ToolBarModule###110-Ticket::AgentTicketQueue',

        'Frontend::ToolBarModule###2-Ticket::AgentTicketStatus' =>
            'Frontend::ToolBarModule###120-Ticket::AgentTicketStatus',

        'Frontend::ToolBarModule###3-Ticket::AgentTicketEscalation' =>
            'Frontend::ToolBarModule###130-Ticket::AgentTicketEscalation',

        'Frontend::ToolBarModule###4-Ticket::AgentTicketPhone' =>
            'Frontend::ToolBarModule###140-Ticket::AgentTicketPhone',

        'Frontend::ToolBarModule###5-Ticket::AgentTicketEmail' =>
            'Frontend::ToolBarModule###150-Ticket::AgentTicketEmail',

        'Frontend::ToolBarModule###6-Ticket::AgentTicketProcess' =>
            'Frontend::ToolBarModule###160-Ticket::AgentTicketProcess',

        'Frontend::ToolBarModule###7-Ticket::TicketResponsible' =>
            'Frontend::ToolBarModule###170-Ticket::TicketResponsible',

        'Frontend::ToolBarModule###8-Ticket::TicketWatcher' =>
            'Frontend::ToolBarModule###180-Ticket::TicketWatcher',

        'Frontend::ToolBarModule###9-Ticket::TicketLocked' =>
            'Frontend::ToolBarModule###190-Ticket::TicketLocked',

        'Frontend::ToolBarModule###10-Ticket::AgentTicketService' =>
            'Frontend::ToolBarModule###200-Ticket::AgentTicketService',

        'Frontend::ToolBarModule###11-Ticket::TicketSearchProfile' =>
            'Frontend::ToolBarModule###210-Ticket::TicketSearchProfile',

        'Frontend::ToolBarModule###12-Ticket::TicketSearchFulltext' =>,
        'Frontend::ToolBarModule###220-Ticket::TicketSearchFulltext',

        'Frontend::ToolBarModule###13-CICSearchCustomerID' =>
            'Frontend::ToolBarModule###230-CICSearchCustomerID',

        'Frontend::ToolBarModule###14-CICSearchCustomerUser' =>
            'Frontend::ToolBarModule###240-CICSearchCustomerUser',

        'Package::EventModulePost###1000-GenericInterface' =>
            'Package::EventModulePost###9900-GenericInterface',

        'Package::EventModulePost###99-SupportDataSend' =>
            'Package::EventModulePost###9000-SupportDataSend',

        'Queue::EventModulePost###1000-GenericInterface' =>
            'Queue::EventModulePost###9900-GenericInterface',

        'Queue::EventModulePost###130-UpdateQueue' =>
            'Queue::EventModulePost###2300-UpdateQueue',

        'Ticket::EventModulePost###100-ArchiveRestore' =>
            'Ticket::EventModulePost###2300-ArchiveRestore',

        'Ticket::EventModulePost###110-AcceleratorUpdate' =>
            'Ticket::EventModulePost###2600-AcceleratorUpdate',

        'Ticket::EventModulePost###120-ForceOwnerResetOnMove' =>
            'Ticket::EventModulePost###2700-ForceOwnerResetOnMove',

        'Ticket::EventModulePost###130-ForceStateChangeOnLock' =>
            'Ticket::EventModulePost###2800-ForceStateChangeOnLock',

        'Ticket::EventModulePost###140-ResponsibleAutoSet' =>
            'Ticket::EventModulePost###3000-ResponsibleAutoSet',

        'Ticket::EventModulePost###150-TicketPendingTimeReset' =>
            'Ticket::EventModulePost###3300-TicketPendingTimeReset',

        'Ticket::EventModulePost###500-NotificationEvent' =>
            'Ticket::EventModulePost###7000-NotificationEvent',

        'Ticket::EventModulePost###900-GenericAgent' =>
            'Ticket::EventModulePost###9700-GenericAgent',

        'Ticket::EventModulePost###910-EscalationIndex' =>
            'Ticket::EventModulePost###6000-EscalationIndex',

        'Ticket::EventModulePost###920-EscalationStopEvents' =>
            'Ticket::EventModulePost###4300-EscalationStopEvents',

        'Ticket::EventModulePost###930-ForceUnlockOnMove' =>
            'Ticket::EventModulePost###3600-ForceUnlockOnMove',

        'Ticket::EventModulePost###940-TicketArticleNewMessageUpdate' =>
            'Ticket::EventModulePost###4000-TicketArticleNewMessageUpdate',

        'Ticket::EventModulePost###950-DynamicFieldFromCustomerUser' =>
            'Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser',

        'Ticket::EventModulePost###998-TicketProcessTransitions' =>
            'Ticket::EventModulePost###9800-TicketProcessTransitions',

        'Ticket::EventModulePost###999-GenericInterface' =>
            'Ticket::EventModulePost###9900-GenericInterface',

        'Ticket::EventModulePost###TicketDynamicFieldDefault' =>
            'Ticket::EventModulePost###9600-TicketDynamicFieldDefault',

        'Ticket::Frontend::ArticleComposeModule###1-SignEmail' =>
            'Ticket::Frontend::ArticleComposeModule###2-SignEmail',

        'Ticket::Frontend::ArticleComposeModule###2-CryptEmail' =>
            'Ticket::Frontend::ArticleComposeModule###3-CryptEmail',

        'Ticket::Frontend::ArticlePreViewModule###1-SMIME' =>
            'Ticket::Frontend::ArticlePreViewModule###2-SMIME',

        'PostMaster::PreCreateFilterModule###000-FollowUpArticleTypeCheck' =>
            'PostMaster::PreCreateFilterModule###000-FollowUpArticleVisibilityCheck',

        'Ticket::Frontend::AgentTicketSearch###Defaults###From' =>
            'Ticket::Frontend::AgentTicketSearch###Defaults###MIMEBase_From',

        'Ticket::Frontend::AgentTicketSearch###Defaults###To' =>
            'Ticket::Frontend::AgentTicketSearch###Defaults###MIMEBase_To',

        'Ticket::Frontend::AgentTicketSearch###Defaults###Cc' =>
            'Ticket::Frontend::AgentTicketSearch###Defaults###MIMEBase_Cc',

        'Ticket::Frontend::AgentTicketSearch###Defaults###Subject' =>
            'Ticket::Frontend::AgentTicketSearch###Defaults###MIMEBase_Subject',

        'Ticket::Frontend::AgentTicketSearch###Defaults###Body' =>
            'Ticket::Frontend::AgentTicketSearch###Defaults###MIMEBase_Body',

        # Moved and renamed config setting from OTOBOCommunity.xml to Framework.xml
        'ChatEngine::AgentOnlineThreshold' => 'SessionAgentOnlineThreshold',

        # Moved and renamed config setting from OTOBOCommunity.xml to Framework.xml
        'ChatEngine::CustomerOnlineThreshold' => 'SessionCustomerOnlineThreshold',

        %{ $Param{PackageLookupNewConfigName} // {} },
    );

    # get the new name if found, otherwise use the given old name
    my $NewName = $Old2NewName{ $Param{OldName} } || $Param{OldName};

    return $NewName;
}

=head2 _MigrateFrontendModuleSetting()

Helper function to migrate a frontend module setting from OTOBO 5 to OTOBO 10.

    my $NewName = $SysConfigMigrationObject->_MigrateFrontendModuleSetting(
        FrontendSettingName => 'Frontend::Module',
        FrontendModuleName  => 'AgentTicketQueue',
        OTOBO5EffectiveValue => {
            'Description' => 'Overview of all open Tickets.',
            'Group' => [ 'users', 'admin' ],
            'GroupRo' => [ 'stats' ],
            'Loader' => {
                'CSS' => [
                    'Core.AgentTicketQueue.css',
                    'Core.AllocationList.css'
                ],
                'JavaScript' => [
                  'Core.UI.AllocationList.js',
                  'Core.Agent.TableFilters.js'
                ],
            },
            'NavBar' => [
                {
                  'AccessKey' => 'o',
                  'Block' => '',
                  'Description' => 'Overview of all open Tickets. xxx xxx',
                  'Link' => 'Action=AgentTicketQueue',
                  'LinkOption' => '',
                  'Name' => 'Queue view',
                  'NavBar' => 'Ticket',
                  'Prio' => '100',
                  'Type' => ''
                },
                {
                  'AccessKey' => 't',
                  'Block' => 'ItemArea',
                  'Description' => 'xxx',
                  'Link' => 'Action=AgentTicketQueue',
                  'LinkOption' => '',
                  'Name' => 'Tickets',
                  'NavBar' => 'Ticket',
                  'Prio' => '200',
                  'Type' => 'Menu'
                }
              ],
            'NavBarName' => 'Ticket',
            'Title' => 'QueueView',
        },
        OTOBO6Setting => \%OTOBO6Setting,
    );

Returns:

    True on success or false on error.

=cut

sub _MigrateFrontendModuleSetting {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FrontendSettingName FrontendModuleName OTOBO5EffectiveValue OTOBO6Setting)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get the group settings from OTOBO 5 config
    my @Group   = @{ $Param{OTOBO5EffectiveValue}->{Group}   || [] };
    my @GroupRo = @{ $Param{OTOBO5EffectiveValue}->{GroupRo} || [] };

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # ###########################################################################
    # migrate the frontend module setting
    # (it will contain only the registration,
    # loader and navigation settings will be separate settings now)
    # ###########################################################################

    # set some attributes from OTOBO 5
    ATTRIBUTE:
    for my $Attribute (qw(Description Title NavBarName)) {
        next ATTRIBUTE if !$Param{OTOBO5EffectiveValue}->{$Attribute};
        $Param{OTOBO6Setting}->{EffectiveValue}->{$Attribute} = $Param{OTOBO5EffectiveValue}->{$Attribute};
    }

    # set group settings from OTOBO 5
    $Param{OTOBO6Setting}->{EffectiveValue}->{Group}   = \@Group;
    $Param{OTOBO6Setting}->{EffectiveValue}->{GroupRo} = \@GroupRo;

    # check if the setting value structure from OTOBO 5 is still valid on OTOBO 10
    my %Result = $SysConfigObject->SettingEffectiveValueCheck(
        EffectiveValue   => $Param{OTOBO5EffectiveValue},
        XMLContentParsed => $Param{OTOBO6Setting}->{XMLContentParsed},
        NoValidation     => 1,
        UserID           => 1,
    );

    return if !$Result{Success};

    # lock the setting
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $Param{OTOBO6Setting}->{Name},
        Force  => 1,
        UserID => 1,
    );

    # update the setting
    %Result = $SysConfigObject->SettingUpdate(
        Name              => $Param{OTOBO6Setting}->{Name},
        IsValid           => 1,
        EffectiveValue    => $Param{OTOBO6Setting}->{EffectiveValue},
        ExclusiveLockGUID => $ExclusiveLockGUID,
        NoValidation      => 1,
        UserID            => 1,
    );

    # unlock the setting again
    $SysConfigObject->SettingUnlock(
        Name => $Param{OTOBO6Setting}->{Name},
    );

    return if !$Result{Success};

    # ###########################################################################
    # migrate the NavBarModule settings
    # ###########################################################################
    if ( $Param{OTOBO5EffectiveValue}->{NavBarModule} ) {

        my $NavBarModuleSettingName = 'Frontend::NavigationModule###' . $Param{FrontendModuleName};

        # try to get the (default) setting from OTOBO 10 for the NavBarModule setting
        my %OTOBO6NavBarModuleSetting = $SysConfigObject->SettingGet(
            Name  => $NavBarModuleSettingName,
            NoLog => 1,
        );

        if (
            %OTOBO6NavBarModuleSetting
            && !$OTOBO6NavBarModuleSetting{ModifiedID}
            && !$OTOBO6NavBarModuleSetting{IsReadonly}
            )
        {

            # set group settings from OTOBO 5
            $OTOBO6NavBarModuleSetting{EffectiveValue}->{Group}   = \@Group;
            $OTOBO6NavBarModuleSetting{EffectiveValue}->{GroupRo} = \@GroupRo;

            # take NavBarModule settings from OTOBO 5
            for my $Attribute ( sort keys %{ $Param{OTOBO5EffectiveValue}->{NavBarModule} } ) {
                $OTOBO6NavBarModuleSetting{EffectiveValue}->{$Attribute}
                    = $Param{OTOBO5EffectiveValue}->{NavBarModule}->{$Attribute};
            }

            # lock the setting
            my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                Name   => $NavBarModuleSettingName,
                Force  => 1,
                UserID => 1,
            );

            # update the setting
            my %Result = $SysConfigObject->SettingUpdate(
                Name              => $NavBarModuleSettingName,
                IsValid           => 1,
                EffectiveValue    => $OTOBO6NavBarModuleSetting{EffectiveValue},
                ExclusiveLockGUID => $ExclusiveLockGUID,
                NoValidation      => 1,
                UserID            => 1,
            );

            # unlock the setting again
            $SysConfigObject->SettingUnlock(
                Name => $NavBarModuleSettingName,
            );

            return if !$Result{Success};
        }
    }

    # ###########################################################################
    # migrate the NavBar settings
    # ###########################################################################

    # Skip navbar items if name is empty.
    my @OTOBO5NavBar = grep {
        defined $_->{Name} && length $_->{Name}
    } @{ $Param{OTOBO5EffectiveValue}->{NavBar} || [] };

    if (@OTOBO5NavBar) {

        # get all OTOBO 10 default settings
        my @DefaultSettings = $SysConfigObject->ConfigurationList();

        # search for OTOBO 10 NavBar settings
        #
        # this will find settings like:
        #            Frontend::Navigation###
        #    CustomerFrontend::Navigation###
        #      PublicFrontend::Navigation###
        #
        $Param{FrontendSettingName} =~ s{Frontend::Module}{Frontend::Navigation}gsmx;

        my $Search       = $Param{FrontendSettingName} . '###' . $Param{FrontendModuleName} . '###';
        my @SearchResult = grep { $_->{Name} =~ m{$Search} } @DefaultSettings;

        if ( scalar @SearchResult == 1 ) {

            # try to get the (default) setting from OTOBO 10 for the NavBar setting
            my %OTOBO6NavBarSetting = $SysConfigObject->SettingGet(
                Name  => $SearchResult[0]->{Name},
                NoLog => 1,
            );

            return if !%OTOBO6NavBarSetting;

            # skip this setting if it has already been modified in the meantime
            return 1 if $OTOBO6NavBarSetting{ModifiedID};

            # skip this setting if it is a readonly setting
            return 1 if $OTOBO6NavBarSetting{IsReadonly};

            $OTOBO6NavBarSetting{EffectiveValue} = [];

            for my $OTOBO5NavBarItem (@OTOBO5NavBar) {

                if ( !$OTOBO5NavBarItem->{Group} ) {
                    $OTOBO5NavBarItem->{Group} = \@Group;
                }
                if ( !$OTOBO5NavBarItem->{GroupRo} ) {
                    $OTOBO5NavBarItem->{GroupRo} = \@GroupRo;
                }

                push @{ $OTOBO6NavBarSetting{EffectiveValue} }, $OTOBO5NavBarItem;
            }

            # Save the updated effective value for the current setting.
            my %Result = $Self->_SettingUpdate(
                Name           => $SearchResult[0]->{Name},
                EffectiveValue => $OTOBO6NavBarSetting{EffectiveValue},
                IsValid        => 1,
                UserID         => 1,
            );

            return if !$Result{Success};
        }
    }

    # No NavBar entries exists in OTOBO 5 config for the frontend modulel, so we disable all nav bar settings
    #   for this frontend navigation.
    else {

        # get all OTOBO 10 default settings
        my @DefaultSettings = $SysConfigObject->ConfigurationList();

        # search for OTOBO 10 NavBar settings
        #
        # this will find settings like:
        #            Frontend::Navigation###
        #    CustomerFrontend::Navigation###
        #      PublicFrontend::Navigation###
        #
        $Param{FrontendSettingName} =~ s{Frontend::Module}{Frontend::Navigation}gsmx;

        my $Search       = $Param{FrontendSettingName} . '###' . $Param{FrontendModuleName} . '###';
        my @SearchResult = grep { $_->{Name} =~ m{$Search} } @DefaultSettings;

        NAVBARSETTING:
        for my $NavBarSetting (@SearchResult) {
            my $NavBarSettingName = $NavBarSetting->{Name};

            # try to get the (default) setting from OTOBO 10 for the NavBar setting
            my %OTOBO6NavBarSetting = $SysConfigObject->SettingGet(
                Name  => $NavBarSettingName,
                NoLog => 1,
            );

            next NAVBARSETTING if !%OTOBO6NavBarSetting;

            # skip this setting if it is already invalid
            next NAVBARSETTING if !$OTOBO6NavBarSetting{IsValid};

            # skip this setting if it has already been modified in the meantime
            next NAVBARSETTING if $OTOBO6NavBarSetting{ModifiedID};

            # skip this setting if it is a readonly setting
            next NAVBARSETTING if $OTOBO6NavBarSetting{IsReadonly};

            # skip this setting if it is a required setting
            next NAVBARSETTING if $OTOBO6NavBarSetting{IsRequired};

            # Disable the setting.
            my %Result = $Self->_SettingUpdate(
                Name    => $NavBarSettingName,
                IsValid => 0,
            );

            return if !$Result{Success};
        }
    }

    return 1;
}

=head2 _SettingUpdate()

This method locks provided settings(by force), updates them and unlock the setting.

    my %Result = $SysConfigMigrationObject->_SettingUpdate(
        Name           => 'Setting::Name',
        IsValid        => 1,                         # (optional) 1 or 0, modified 0
        EffectiveValue => $SettingEffectiveValue,    # (optional)
    );

Returns:

    %Result = (
        Success => 1,        # or false in case of an error
        Error   => undef,    # error message
    );

=cut

sub _SettingUpdate {
    my ( $Self, %Param ) = @_;

    return if !$Param{Name};

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # lock the setting
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $Param{Name},
        Force  => 1,
        UserID => 1,
    );

    # Disable the setting.
    my %Result = $SysConfigObject->SettingUpdate(
        Name              => $Param{Name},
        IsValid           => $Param{IsValid},
        EffectiveValue    => $Param{EffectiveValue},
        ExclusiveLockGUID => $ExclusiveLockGUID,
        NoValidation      => 1,
        UserID            => 1,
    );

    # unlock the setting again
    $SysConfigObject->SettingUnlock(
        Name => $Param{Name},
    );

    return %Result;
}

1;
