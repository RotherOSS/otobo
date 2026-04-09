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

package Kernel::Modules::AgentElasticsearch;

## nofilter(TidyAll::Plugin::OTOBO::Perl::DBObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $BackendConfigKey = 'ElasticsearchBackend';
    my $UserSettingsKey  = 'ElasticsearchResult';

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    my $ESSearchQuery = $ParamObject->GetParam( Param => 'FulltextES' );

    $ESSearchQuery =~ s/^\s+//;
    $ESSearchQuery =~ s/\s+$//;

    if ($ESSearchQuery) {

        $LayoutObject->SetEnv(
            Key   => 'FulltextES',
            Value => $ESSearchQuery
        );
    }

    # load backends
    my $Config = $ConfigObject->Get('ElasticsearchWidgetBackend');
    if ( !$Config ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No such config for %s', $BackendConfigKey ),
        );
    }

    # get shown backends
    my %Backends;
    BACKEND:
    for my $Name ( sort keys %{$Config} ) {

        # check permissions
        if ( $Config->{$Name}->{Permission} ) {

            my $PermissionOK = 0;
            my $ModuleReg    = $ConfigObject->Get('Frontend::Module')->{ $Config->{$Name}->{Permission} };

            if ( !$ModuleReg ) {

                next BACKEND;
            }

            # module permission check
            if (
                ref $ModuleReg->{GroupRo} eq 'ARRAY'
                && !scalar @{ $ModuleReg->{GroupRo} }
                && ref $ModuleReg->{Group} eq 'ARRAY'
                && !scalar @{ $ModuleReg->{Group} }
                )
            {
                $PermissionOK = 1;
            }
            else {
                my $AccessRo;
                my $AccessRw;

                PERMISSION:
                for my $Permission (qw(GroupRo Group)) {
                    my $AccessOk = 0;
                    my $Group    = $ModuleReg->{$Permission};
                    next PERMISSION if !$Group;
                    if ( ref $Group eq 'ARRAY' ) {
                        INNER:
                        for my $GroupName ( @{$Group} ) {
                            next INNER if !$GroupName;
                            next INNER if !$GroupObject->PermissionCheck(
                                UserID    => $Self->{UserID},
                                GroupName => $GroupName,
                                Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',

                            );
                            $AccessOk = 1;
                            last INNER;
                        }
                    }
                    else {
                        my $HasPermission = $GroupObject->PermissionCheck(
                            UserID    => $Self->{UserID},
                            GroupName => $Group,
                            Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',

                        );
                        if ($HasPermission) {
                            $AccessOk = 1;
                        }
                    }
                    if ( $Permission eq 'Group' && $AccessOk ) {
                        $AccessRo = 1;
                        $AccessRw = 1;
                    }
                    elsif ( $Permission eq 'GroupRo' && $AccessOk ) {
                        $AccessRo = 1;
                    }
                }
                if ( ( !$AccessRo && !$AccessRw ) || ( !$AccessRo && $AccessRw ) ) {
                    next BACKEND;
                }

                $PermissionOK = 1;
            }
        }

        my $Key = $UserSettingsKey . $Name;
        if ( defined $Self->{Session}{$Key} ) {
            $Backends{$Name} = $Self->{Session}{$Key};
        }
        else {
            $Backends{$Name} = $Config->{$Name}->{Default};
        }

        # Always show widgets with mandatory flag.
        if ( $Config->{$Name}->{Mandatory} ) {
            $Backends{$Name} = $Config->{$Name}->{Mandatory};
        }
    }

    # get needed objects
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

    # update preferences
    if ( $Self->{Subaction} eq 'UpdatePreferences' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Name = $ParamObject->GetParam( Param => 'Name' );

        # get preferences settings
        my @PreferencesOnly = $Self->_Element(
            Name            => $Name,
            Configs         => $Config,
            PreferencesOnly => 1,
        );
        if ( !@PreferencesOnly ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'No preferences for %s!', $Name ),
            );
        }

        # remember preferences
        for my $Param (@PreferencesOnly) {

            # get params
            my $Value = $ParamObject->GetParam( Param => $Param->{Name} );

            # update runtime vars
            $LayoutObject->{ $Param->{Name} } = $Value;

            # update session
            $SessionObject->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Param->{Name},
                Value     => $Value,
            );

            # update preferences
            if ( !$ConfigObject->Get('DemoSystem') ) {
                $UserObject->SetPreferences(
                    UserID => $Self->{UserID},
                    Key    => $Param->{Name},
                    Value  => $Value,
                );
            }
        }

        # deliver new content page
        my %ElementReload = $Self->_Element(
            Name    => $Name,
            Configs => $Config,
            AJAX    => 1
        );
        if ( !%ElementReload ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Can\'t get element data of %s!', $Name ),
            );
        }
        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => ${ $ElementReload{Content} },
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # update position
    elsif ( $Self->{Subaction} eq 'UpdatePosition' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @Backends = $ParamObject->GetArray( Param => 'Backend' );

        # get new order
        my $Key  = $UserSettingsKey . 'Position';
        my $Data = '';
        for my $Backend (@Backends) {
            $Backend =~ s{ \A Dashboard (.+?) -box \z }{$1}gxms;
            $Data .= $Backend . ';';
        }

        # update session
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Key,
            Value     => $Data,
        );

        # update preferences
        if ( !$ConfigObject->Get('DemoSystem') ) {
            $UserObject->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $Key,
                Value  => $Data,
            );
        }

        # send successful response
        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => '1',
        );
    }

    # deliver element
    elsif ( $Self->{Subaction} eq 'Element' ) {

        my $Name    = $ParamObject->GetParam( Param => 'Name' );
        my $SortBy  = $ParamObject->GetParam( Param => 'SortBy' );
        my $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' );

        my %Element = $Self->_Element(
            Name     => $Name,
            Configs  => $Config,
            AJAX     => 1,
            SortBy   => $SortBy,
            OrderBy  => $OrderBy,
            Backends => \%Backends,
        );

        if ( !%Element ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Can\'t get element data of %s!', $Name ),
            );
        }
        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => ${ $Element{Content} },
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my %ContentBlockData;

    # show dashboard
    $LayoutObject->Block(
        Name => 'Content',
        Data => \%ContentBlockData,
    );

    # set order of plugins
    my $Key = $UserSettingsKey . 'Position';
    my @Order;
    my $Value = $Self->{Session}{$Key};

    if ($Value) {
        @Order = split /;/, $Value;

        # only use active backends
        @Order = grep { $Config->{$_} } @Order;
    }
    if ( !@Order ) {
        for my $Name ( sort keys %Backends ) {
            push @Order, $Name;
        }
    }

    # add not ordered plugins (e. g. new active)
    NAME:
    for my $Name ( sort keys %Backends ) {
        my $Included = 0;
        ITEM:
        for my $Item (@Order) {
            next ITEM if $Item ne $Name;
            $Included = 1;
        }
        next NAME if $Included;
        push @Order, $Name;
    }

    # try every backend to load and execute it
    my @ContainerNames;
    NAME:
    for my $Name (@Order) {

        # get element data
        my %Element = $Self->_Element(
            Name     => $Name,
            Configs  => $Config,
            Backends => \%Backends,
        );
        next NAME if !%Element;

        next NAME if $Element{Content} eq '';

        # NameForm (to support IE, is not working with "-" in form names)
        my $NameForm = $Name;
        $NameForm =~ s{-}{}g;

        my %JSData = (
            Name     => $Name,
            NameForm => $NameForm,
        );

        push @ContainerNames, \%JSData;

        # rendering
        $LayoutObject->Block(
            Name => 'ContentLarge',
            Data => {
                %{ $Element{Config} },
                Name           => $Name,
                NameForm       => $NameForm,
                Content        => ${ $Element{Content} },
                CustomerID     => $Self->{CustomerID}     || '',
                CustomerUserID => $Self->{CustomerUserID} || '',
                FulltextES     => $ESSearchQuery,
                Title          => $Config->{$Name}->{Name},
            },
        );

        # show settings link if preferences are available
        if ( $Element{Preferences} && @{ $Element{Preferences} } ) {
            $LayoutObject->Block(
                Name => 'ContentLargePreferences',
                Data => {
                    %{ $Element{Config} },
                    Name     => $Name,
                    NameForm => $NameForm,
                },
            );
            PARAM:
            for my $Param ( @{ $Element{Preferences} } ) {

                # special parameters are added, which do not have a tt block,
                # because the displayed fields are added with the output filter,
                # so there is no need to call any block here
                next PARAM if !$Param->{Block};

                $LayoutObject->Block(
                    Name => 'ContentLargePreferencesItem',
                    Data => {
                        %{ $Element{Config} },
                        Name     => $Name,
                        NameForm => $NameForm,
                    },
                );
                if ( $Param->{Block} eq 'Option' ) {
                    $Param->{Option} = $LayoutObject->BuildSelection(
                        Data        => $Param->{Data},
                        Name        => $Param->{Name},
                        SelectedID  => $Param->{SelectedID},
                        Translation => $Param->{Translation},
                        Class       => 'Modernize',
                    );
                }
                $LayoutObject->Block(
                    Name => 'ContentLargePreferencesItemOption',
                    Data => {
                        %{ $Element{Config} },
                        %{$Param},
                        Data     => $Self->{Session}{ $Param->{Name} },
                        NamePref => $Param->{Name},
                        Name     => $Name,
                        NameForm => $NameForm,
                    },
                );
            }
        }
    }

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'ContainerNames',
        Value => \@ContainerNames,
    );

    $LayoutObject->Block( Name => 'MainMenu' );

    $Param{FulltextES} = $ESSearchQuery;

    return join '',
        $LayoutObject->Header,
        $LayoutObject->NavigationBar,
        $LayoutObject->Output(
            TemplateFile => 'AgentElasticsearchCommon',
            Data         => \%Param
        ),
        $LayoutObject->Footer;
}

sub _Element {
    my ( $Self, %Param ) = @_;

    my $Name                  = $Param{Name};
    my $Configs               = $Param{Configs};
    my $Backends              = $Param{Backends};
    my $SortBy                = $Param{SortBy};
    my $OrderBy               = $Param{OrderBy};
    my $ColumnFilter          = $Param{ColumnFilter};
    my $GetColumnFilter       = $Param{GetColumnFilter};
    my $GetColumnFilterSelect = $Param{GetColumnFilterSelect};

    # load backends
    my $Module = $Configs->{$Name}->{Module};
    return unless $Kernel::OM->Get('Kernel::System::Main')->Require($Module);

    my $Object = $Module->new(
        %{$Self},
        Config                => $Configs->{$Name},
        Name                  => $Name,
        CustomerID            => $Self->{CustomerID}     || '',
        CustomerUserID        => $Self->{CustomerUserID} || '',
        SortBy                => $SortBy,
        OrderBy               => $OrderBy,
        ColumnFilter          => $ColumnFilter,
        GetColumnFilter       => $GetColumnFilter,
        GetColumnFilterSelect => $GetColumnFilterSelect,
    );

    # Perform the actual data fetching and computation on the mirror DB, if configured
    local $Kernel::System::DB::UseMirrorDB = 1;

    # get module preferences
    my @Preferences = $Object->Preferences();

    return @Preferences if $Param{PreferencesOnly};

    # Perform the actual data fetching and computation on the mirror DB, if configured
    local $Kernel::System::DB::UseMirrorDB = 1;

    if ( $Param{FilterContentOnly} ) {
        my $FilterContent = $Object->FilterContent(
            FilterColumn   => $Param{FilterColumn},
            Config         => $Configs->{$Name},
            Name           => $Name,
            CustomerID     => $Self->{CustomerID}     || '',
            CustomerUserID => $Self->{CustomerUserID} || '',
        );
        return $FilterContent;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # add backend to settings selection
    if ($Backends) {
        my $Checked = '';
        if ( $Backends->{$Name} || $Configs->{$Name}->{Mandatory} ) {
            $Checked = 'checked ';
        }

        # Check whether the widget is forcibly displayed.
        # Mandatory widgets are displayed as read-only.
        my $Readonly = '';
        if ( $Configs->{$Name}->{Mandatory} ) {
            $Readonly = 'disabled="disabled"';
        }

        $LayoutObject->Block(
            Name => 'ContentSettings',
            Data => {
                $Configs->{$Name}->%*,
                Name     => $Name,
                Checked  => $Checked,
                Readonly => $Readonly,
            },
        );

        return if !$Backends->{$Name};
    }

    # check backends cache (html page cache)
    my $Content = $Object->Run(
        AJAX           => $Param{AJAX},
        CustomerID     => $Self->{CustomerID}     || '',
        CustomerUserID => $Self->{CustomerUserID} || '',
    );

    # check if content should be shown
    return if !$Content;

    # return result
    return (
        Content     => \$Content,
        Config      => $Configs->{$Name},
        Preferences => \@Preferences,
    );
}

1;
