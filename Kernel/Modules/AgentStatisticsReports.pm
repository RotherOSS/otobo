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

package Kernel::Modules::AgentStatisticsReports;

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $NeededData (qw( UserID Subaction AccessRo SessionID ))
    {
        if ( !$Param{$NeededData} ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Got no %s!', $NeededData ),
            );
        }
        $Self->{$NeededData} = $Param{$NeededData};
    }

    # AccessRw controls the adding/editing of statistics.
    for my $Param (qw( AccessRw RequestedURL)) {
        if ( $Param{$Param} ) {
            $Self->{$Param} = $Param{$Param};
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Subaction = $Self->{Subaction};

    my %RoSubactions = (
        Overview => 'OverviewScreen',
        View     => 'ViewScreen',
        Run      => 'RunAction',
    );

    if ( $RoSubactions{$Subaction} ) {
        if ( !$Self->{AccessRo} ) {
            return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->NoPermission( WithHeader => 'yes' );
        }
        my $Method = $RoSubactions{$Subaction};
        return $Self->$Method();
    }

    my %RwSubactions = (
        Add                => 'AddScreen',
        AddAction          => 'AddAction',
        Edit               => 'EditScreen',
        EditAction         => 'EditAction',
        DeleteAction       => 'DeleteAction',
        StatsAddWidgetAJAX => 'StatsAddWidgetAJAX',
    );

    if ( $RwSubactions{$Subaction} ) {
        if ( !$Self->{AccessRw} ) {
            return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->NoPermission( WithHeader => 'yes' );
        }
        my $Method = $RwSubactions{$Subaction};
        return $Self->$Method();
    }

    # No (known) subaction?
    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->ErrorScreen(
        Message => Translatable('Invalid Subaction.'),
    );
}

sub OverviewScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

    # get all Stats from the db
    my %ResultHash = %{
        $StatsReportObject->StatsReportList(
            Valid => 0,
        ) // {}
    };

    my @Results = sort { $ResultHash{$a} cmp $ResultHash{$b} } keys %ResultHash;

    for my $Result (@Results) {
        my $StatReport = $StatsReportObject->StatsReportGet(
            ID => $Result,
        );

        $LayoutObject->Block(
            Name => 'Result',
            Data => {
                %$StatReport,
                AccessRw => $Self->{AccessRw},
            },
        );
    }

    if ( !@Results ) {
        $LayoutObject->Block(
            Name => 'NoDataFound',
        );
    }

    # Build output.
    return join '',
        $LayoutObject->Header(
            Title => Translatable('Overview'),
        ),
        $LayoutObject->NavigationBar(),
        $LayoutObject->Output(
            Data => {
                %Param,
                AccessRw => $Self->{AccessRw},
            },
            TemplateFile => 'AgentStatisticsReportsOverview',
        ),
        $LayoutObject->Footer();
}

sub AddScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # In case of page reload because of errors
    my %Errors   = %{ $Param{Errors}   // {} };
    my %GetParam = %{ $Param{GetParam} // {} };

    my %Frontend;

    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Frontend{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Errors{'ValidIDInvalid'} || '' ),
    );

    # Build output.
    return join '',
        $LayoutObject->Header(
            Title => Translatable('Add New Statistics Report'),
        ),
        $LayoutObject->NavigationBar(),
        $LayoutObject->Output(
            TemplateFile => 'AgentStatisticsReportsAdd',
            Data         => {
                %Frontend,
                %Errors,
                %GetParam,
            },
        ),
        $LayoutObject->Footer();
}

sub AddAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

    my %Errors;

    my %GetParam;
    for my $Key (qw(Name Description ValidID)) {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
        if ( !length $GetParam{$Key} ) {    # Valid can be 0
            $Errors{ $Key . 'ServerError' }     = 'ServerError';
            $Errors{ $Key . 'ServerErrorText' } = Translatable('This field is required.');
        }
    }

    # Check if name is already in use.
    my %StatsList = %{
        $StatsReportObject->StatsReportList(
            Valid => 0,
        ) // {}
    };
    my %StatsListReverse = reverse %StatsList;

    if ( $StatsListReverse{ $GetParam{Name} } ) {
        $Errors{NameServerError}     = 'ServerError';
        $Errors{NameServerErrorText} = Translatable('This name is already in use, please choose a different one.');
    }

    if (%Errors) {
        return $Self->AddScreen(
            Errors   => \%Errors,
            GetParam => \%GetParam,
        );
    }

    my $StatsReportID = $StatsReportObject->StatsReportAdd(
        %GetParam,
        Config => {
            Description => $GetParam{Description},
        },
        UserID => $Self->{UserID},
    );
    if ( !$StatsReportID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not create report.'),
        );
    }

    return $LayoutObject->Redirect(
        OP => "Action=AgentStatisticsReports;Subaction=Edit;StatsReportID=$StatsReportID",
    );
}

sub EditScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

    # In case of page reload because of errors
    my %Errors   = %{ $Param{Errors}   // {} };
    my %GetParam = %{ $Param{GetParam} // {} };

    if ( !( $GetParam{StatsReportID} = $ParamObject->GetParam( Param => 'StatsReportID' ) ) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need StatsReportID!'),
        );
    }

    for my $Key (qw(LanguageID ValidID)) {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
    }

    my %StatsReport = %{
        $StatsReportObject->StatsReportGet(
            ID => $GetParam{StatsReportID},
        ) // {}
    };
    if ( !%StatsReport ) {
        return $LayoutObject->Redirect(
            OP => "Action=AgentStatisticsReports;Subaction=Overview",
        );
    }
    my %Frontend;

    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Frontend{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $GetParam{ValidID} || $StatsReport{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Errors{'ValidIDInvalid'} || '' ),
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Frontend{BrowserFound} = ( $ConfigObject->Get('PhantomJS::Bin') || $ConfigObject->Get('GoogleChrome::Bin') ) ? 1 : 0;

    my %Format = %{ $ConfigObject->Get('Stats::Format') || {} };

    my %FilteredFormats;
    for my $Key ( sort keys %Format ) {
        if ( $Frontend{BrowserFound} ) {
            $FilteredFormats{$Key} = $Format{$Key} if $Key =~ m{^D3|^Print}smx;
        }
        else {
            $FilteredFormats{$Key} = $Format{$Key} if $Key eq 'Print';
        }
    }

    # Languages for offline generation
    my $DefaultUsedLanguages = $ConfigObject->Get('DefaultUsedLanguages');
    $Frontend{LanguageOption} = $LayoutObject->BuildSelection(
        Data       => $DefaultUsedLanguages,
        Name       => 'LanguageID',
        HTMLQuote  => 0,
        SelectedID => $GetParam{LanguageID}
            || $StatsReport{Config}->{LanguageID}
            || $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage}
            || $ConfigObject->Get('DefaultLanguage'),
        Class => 'Modernize Validate_DependingRequiredAND Validate_Depending_CronDefinition '
            . ( $Errors{'LanguageIDInvalid'} || '' ),
    );

    my $StatsList = $Kernel::OM->Get('Kernel::System::Stats')->GetStatsList(
        OrderBy   => 'StatNumber',
        Direction => 'ASC',
        UserID    => $Self->{UserID},
    );

    my @StatsDropdownList;

    my $StatsHook = $ConfigObject->Get('Stats::StatsHook');

    for my $StatID ( @{ $StatsList // [] } ) {
        my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet( StatID => $StatID );

        my $HasAvailableFormat;
        VALUE:
        for my $Value ( @{ $Stat->{Format} } ) {
            next VALUE if !defined $FilteredFormats{$Value};
            $HasAvailableFormat++;
        }

        if ($HasAvailableFormat) {
            push @StatsDropdownList, {
                Key   => $StatID,
                Value => $StatsHook . $Stat->{StatNumber} . " - " . $Stat->{Title},
            };
        }

    }

    # Dropdown with possible stats to add
    $Frontend{StatAddOption} = $LayoutObject->BuildSelection(
        Data         => \@StatsDropdownList,
        Name         => 'StatsAdd',
        Class        => 'Modernize W50pc',
        PossibleNone => 1,
    );

    $Frontend{StatsWidgets} = [];
    my $OutputCounter = 1;

    STAT_CONFIG:
    for my $StatConfig ( @{ $StatsReport{Config}->{StatsConfiguration} // [] } ) {
        next STAT_CONFIG if !ref $StatConfig;

        my $StatID = $StatConfig->{StatGetParams}->{StatID};
        next STAT_CONFIG if !$StatID;

        my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
            StatID => $StatID,
        );
        next STAT_CONFIG if !ref $Stat;

        my @ParameterErrors;

        eval {
            $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsGet(
                Stat         => $Stat,
                UserGetParam => $StatConfig->{StatGetParams},
            );
        };

        if ( $@ || ref $@ eq 'ARRAY' ) {
            @ParameterErrors = @{$@};
            $Errors{StatisticConfigInvalid} = 1;
        }

        # Fetch the stat again as StatsParamGet might have modified it in between.
        $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet( StatID => $StatID );

        my $StatsParamsWidget = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsWidget(
            Stat          => $Stat,
            UserGetParam  => $StatConfig->{StatGetParams},
            Formats       => \%FilteredFormats,
            OutputCounter => $OutputCounter++,
        );
        if ( !$StatsParamsWidget ) {
            $Errors{StatisticConfigInvalid} = 1;
        }

        my $Content = $LayoutObject->Output(
            TemplateFile => 'StatisticsReports/StatsWidget',
            Data         => {
                %{$Stat},
                Errors             => \@ParameterErrors,
                StatsParamsWidget  => $StatsParamsWidget,
                StatReportSettings => $StatConfig->{StatReportSettings},
            },
        );

        push @{ $Frontend{StatsWidgets} }, $Content;
    }

    my $CronDefinition = $GetParam{CronDefinition} || $StatsReport{Config}->{CronDefinition};
    if ($CronDefinition) {
        my $CronNextEvent = $Kernel::OM->Get('Kernel::System::CronEvent')->NextEventGet(
            Schedule => $CronDefinition,
        ) // 0;

        if ($CronNextEvent) {

            my $CronNextRunTime = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $CronNextEvent,
                },
            );

            $Frontend{CronNextRunTimeStamp} = $CronNextRunTime->ToString();
            my $CronLastRun = $StatsReport{Config}->{CronLastRun} // 0;

            if ($CronLastRun) {

                # $CronLastRun is in epoch format in StatsReport config
                my $CronLastRunTime = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        Epoch => $CronLastRun,
                    },
                );

                $Frontend{CronLastRunTimeStamp} = $CronLastRunTime->ToString();

                my $CronPreviousEvent = $Kernel::OM->Get('Kernel::System::CronEvent')->PreviousEventGet(
                    Schedule => $CronDefinition,
                ) // 0;

                my $CronPreviousEventTime = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $CronPreviousEvent,
                    },
                );

                # The previous run might not yet have finished
                if ( $CronLastRunTime < $CronPreviousEventTime ) {
                    $Frontend{CronNextRunTimeStamp} = $CronPreviousEventTime->ToString();
                }

            }
        }

    }

    # Build output.
    return join '',
        $LayoutObject->Header(
            Title => Translatable('Edit Statistics Report'),
        ),
        $LayoutObject->NavigationBar(),
        $LayoutObject->Output(
            TemplateFile => 'AgentStatisticsReportsEdit',
            Data         => {
                %StatsReport,
                %Frontend,
                %Errors,
                %GetParam,
            },
        ),
        $LayoutObject->Footer();
}

sub EditAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

    my %Errors;
    my %GetParam;

    if ( !( $GetParam{StatsReportID} = $ParamObject->GetParam( Param => 'StatsReportID' ) ) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need StatsReportID!'),
        );
    }

    my %OldStatsReport = %{
        $StatsReportObject->StatsReportGet(
            ID => $GetParam{StatsReportID},
        ) // {}
    };

    if ( !%OldStatsReport ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not find report.'),
        );
    }

    for my $Key (qw(Name Description ValidID)) {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
        if ( !length $GetParam{$Key} ) {    # Valid can be 0
            $Errors{ $Key . 'ServerError' }     = 'ServerError';
            $Errors{ $Key . 'ServerErrorText' } = Translatable('This field is required.');
        }
    }

    my %NewConfig = (
        CronLastRun => $OldStatsReport{Config}->{CronLastRun},
        Description => $GetParam{Description},
    );

    for my $Key (
        qw(
        CronDefinition LanguageID EmailSubject EmailBody EmailRecipients
        Headline Title PreambleCaption Preamble EpilogueCaption Epilogue)
        )
    {
        $GetParam{$Key}  = $ParamObject->GetParam( Param => $Key ) // '';
        $NewConfig{$Key} = $GetParam{$Key};
    }

    if ( $GetParam{CronDefinition} ) {
        if (
            !$Kernel::OM->Get('Kernel::System::CronEvent')->PreviousEventGet(
                Schedule => $GetParam{CronDefinition}
            )
            )
        {
            $Errors{'CronDefinitionServerError'}     = 'ServerError';
            $Errors{'CronDefinitionServerErrorText'} = Translatable('Please provide a valid cron entry.');
        }

        for my $Key (qw( EmailSubject EmailBody EmailRecipients)) {
            if ( !$GetParam{$Key} ) {
                $Errors{ $Key . 'ServerError' }     = 'ServerError';
                $Errors{ $Key . 'ServerErrorText' } = Translatable('This field is required.');
            }
        }
    }

    $GetParam{StatsConfiguration} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $ParamObject->GetParam( Param => 'StatsConfiguration' ),
    );
    $NewConfig{StatsConfiguration} = $GetParam{StatsConfiguration};

    # Check if name is already in use.
    my %StatsList = %{
        $StatsReportObject->StatsReportList(
            Valid => 0,
        ) // {}
    };
    my %StatsListReverse = reverse %StatsList;

    if ( $StatsListReverse{ $GetParam{Name} } && $StatsListReverse{ $GetParam{Name} } ne $GetParam{StatsReportID} ) {
        $Errors{NameServerError}     = 'ServerError';
        $Errors{NameServerErrorText} = Translatable('This name is already in use, please choose a different one.');
    }

    if (%Errors) {
        return $Self->EditScreen(
            Errors   => \%Errors,
            GetParam => \%GetParam,
        );
    }

    my $StatsReportID = $StatsReportObject->StatsReportUpdate(
        ID => $GetParam{StatsReportID},
        %GetParam,
        Config => \%NewConfig,
        UserID => $Self->{UserID},
    );
    if ( !$StatsReportID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not update report.'),
        );
    }

    if ( $ParamObject->GetParam( Param => 'SaveAndFinish' ) ) {
        return $LayoutObject->Redirect( OP => "Action=AgentStatisticsReports;Subaction=Overview" );
    }
    return $Self->EditScreen(
        Errors   => \%Errors,
        GetParam => \%GetParam,
    );
}

sub ViewScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

    # In case of page reload because of errors
    my %Errors   = %{ $Param{Errors}   // {} };
    my %GetParam = %{ $Param{GetParam} // {} };

    if ( !( $GetParam{StatsReportID} = $ParamObject->GetParam( Param => 'StatsReportID' ) ) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need StatsReportID!'),
        );
    }

    my %StatsReport = %{
        $StatsReportObject->StatsReportGet(
            ID => $GetParam{StatsReportID},
        ) // {}
    };
    if ( !%StatsReport ) {
        return $LayoutObject->Redirect(
            OP => "Action=AgentStatisticsReports;Subaction=Overview",
        );
    }
    my %Frontend;
    $Frontend{Stats} = [];

    STAT_CONFIG:
    for my $StatConfig ( @{ $StatsReport{Config}->{StatsConfiguration} // [] } ) {
        next STAT_CONFIG if !ref $StatConfig;

        my $StatID = $StatConfig->{StatGetParams}->{StatID};
        next STAT_CONFIG if !$StatID;

        my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
            StatID => $StatID,
        );
        next STAT_CONFIG if !ref $Stat;

        my $StatsConfigurationValid
            = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsConfigurationValidate(
                Stat   => $Stat,
                Errors => {},
            );
        if ( !$StatsConfigurationValid ) {
            $Frontend{Errors} = 1;
            next STAT_CONFIG;
        }

        eval {
            $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsGet(
                Stat         => $Stat,
                UserGetParam => $StatConfig->{StatGetParams},
            );
        };

        if ($@) {
            $Frontend{Errors} = 1;
        }
        else {
            push @{ $Frontend{Stats} }, $StatConfig->{StatReportSettings}->{Title} || $Stat->{Title};
        }
    }

    # Build output.
    return join '',
        $LayoutObject->Header(
            Title => Translatable('View Statistics Report'),
        ),
        $LayoutObject->NavigationBar(),
        $LayoutObject->Output(
            TemplateFile => 'AgentStatisticsReportsView',
            Data         => {
                %StatsReport,
                %Frontend,
                %Errors,
                %GetParam,
                AccessRw => $Self->{AccessRw},
            },
        ),
        $LayoutObject->Footer();
}

sub RunAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

    # In case of page reload because of errors
    my %Errors   = %{ $Param{Errors}   // {} };
    my %GetParam = %{ $Param{GetParam} // {} };

    if ( !( $GetParam{StatsReportID} = $ParamObject->GetParam( Param => 'StatsReportID' ) ) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need StatsReportID!'),
        );
    }

    my %StatsReport = %{
        $StatsReportObject->StatsReportGet(
            ID => $GetParam{StatsReportID},
        ) // {}
    };
    if ( !%StatsReport ) {
        return $LayoutObject->Redirect(
            OP => "Action=AgentStatisticsReports;Subaction=Overview",
        );
    }
    my %Frontend;

    STAT_CONFIG:
    for my $StatConfig ( @{ $StatsReport{Config}->{StatsConfiguration} // [] } ) {
        next STAT_CONFIG if !ref $StatConfig;

        my $StatID = $StatConfig->{StatGetParams}->{StatID};
        next STAT_CONFIG if !$StatID;

        my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
            StatID => $StatID,
        );
        next STAT_CONFIG if !ref $Stat;

        my $StatsConfigurationValid
            = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsConfigurationValidate(
                Stat   => $Stat,
                Errors => {},
            );
        if ( !$StatsConfigurationValid ) {
            $Frontend{Errors} = 1;

            next STAT_CONFIG;
        }

        eval {
            $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsGet(
                Stat         => $Stat,
                UserGetParam => $StatConfig->{StatGetParams},
            );
        };

        if ($@) {
            $Frontend{Errors} = 1;
        }
    }

    if (%Errors) {
        return $Self->EditScreen(
            Errors => %Errors,
        );
    }

    my $PDFGeneratorObject = $Kernel::OM->Get('Kernel::Output::PDF::StatisticsReports');

    my $PDFString = $PDFGeneratorObject->GeneratePDF(
        StatsReport => \%StatsReport,
        UserID      => $Self->{UserID},
    );
    my $Title = $StatsReport{Config}->{Title};

    return $LayoutObject->Attachment(
        Filename    => $Title . '.pdf',
        ContentType => 'application/pdf',
        Content     => $PDFString,
        Type        => 'inline',
    );
}

sub DeleteAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $StatsReportID = $ParamObject->GetParam( Param => 'StatsReportID' );
    if ( !$StatsReportID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Delete: Got no StatsReportID!'),
        );
    }

    # challenge token check for write action
    $LayoutObject->ChallengeTokenCheck();
    $Kernel::OM->Get('Kernel::System::StatsReport')->StatsReportDelete(
        ID     => $StatsReportID,
        UserID => $Self->{UserID},
    );
    return $LayoutObject->Redirect( OP => 'Action=AgentStatisticsReports;Subaction=Overview' );
}

sub StatsAddWidgetAJAX {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $StatID        = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'StatID' );
    my $OutputCounter = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'OutputCounter' );

    if ( !$StatID ) {
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
            ContentType => 'application/json',
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode( Data => { Success => 0 } ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet( StatID => $StatID );

    if ( !$Stat ) {
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
            ContentType => 'application/json',
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode( Data => { Success => 0 } ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $BrowserFound = ( $ConfigObject->Get('PhantomJS::Bin') || $ConfigObject->Get('GoogleChrome::Bin') ) ? 1 : 0;
    my %Format       = %{ $ConfigObject->Get('Stats::Format') || {} };

    my %FilteredFormats;
    for my $Key ( sort keys %Format ) {
        if ($BrowserFound) {
            $FilteredFormats{$Key} = $Format{$Key} if $Key =~ m{^D3|^Print}smx;
        }
        else {
            $FilteredFormats{$Key} = $Format{$Key} if $Key eq 'Print';
        }
    }

    my $StatsParamsWidget = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsWidget(
        Stat          => $Stat,
        Formats       => \%FilteredFormats,
        AJAX          => 1,
        OutputCounter => $OutputCounter,
    );

    if ( !$StatsParamsWidget ) {
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
            ContentType => 'application/json',
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode( Data => { Success => 0 } ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'StatisticsReports/StatsWidget',
        Data         => {
            %{$Stat},
            StatsParamsWidget => $StatsParamsWidget,
        },
    );

    my $JSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => {
            Success => 1,
            Content => $Content,
        }
    );
    return $LayoutObject->Attachment(
        ContentType => 'application/json',
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
