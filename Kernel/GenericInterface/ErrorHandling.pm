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

package Kernel::GenericInterface::ErrorHandling;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::GenericInterface::Debugger ();
use Kernel::System::VariableCheck      qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::GenericInterface::Webservice',
);

=head1 NAME

Kernel::GenericInterface::ErrorHandling - Error object to execute registered error handler modules

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not create it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ErrorObject = $Kernel::OM->Get('Kernel::GenericInterface::ErrorHandling');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 HandleError()

Receives the current web service and operation or invoker data, as well as the result
of the C<HandleError()> method from the related invoker or operation.
The data will be printed via the debugger.
For every registered error handler its configuration will be checked to determine if
it should be called.

    my $Result =  $ErrorObject->HandleError(
        WebserviceID      => 1,                     # ID of the configured remote web service to use
        WebserviceConfig  => $WebserviceConfig,
        CommunicationID   => '02a381c622d5f93df868a42151db1983', # communication ID of current debugger instance
        CommunicationType => 'Requester',                        # May be 'Requester' or 'Provider'
        CommunicationName => 'CreateTicket',                     # optional, name of Invoker or Operation
        ErrorStage        => 'MappingIn',                        # stage where error occurred
        Summary           => $ErrorSummary,
        Data              => $ErrorData,                         # data provided from the origin of the error
        PastExecutionData => $PastExecutionDataStructure,        # optional
    );

returns

    $Result = {
        Success      => 0,
        ErrorMessage => $ErrorSummary,              # returns summary from call
    };

=cut

sub HandleError {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(WebserviceID WebserviceConfig CommunicationID CommunicationType ErrorStage Summary Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Got no $Needed!",
            );

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }
    }

    # Add error message to debugger.
    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig    => $Param{WebserviceConfig}->{Debugger},
        WebserviceID      => $Param{WebserviceID},
        CommunicationType => $Param{CommunicationType},
        CommunicationID   => $Param{CommunicationID},
    );

    $DebuggerObject->Error(
        Summary => $Param{Summary},
        Data    => $Param{Data},
    );

    my $ErrorHandlingConfig = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::ErrorHandling::Module');

    if ( !IsHashRefWithData($ErrorHandlingConfig) ) {
        return $Self->_LogAndReturn(
            %Param,
            ErrorMessage => $Param{Summary},
        );
    }

    my $ErrorHandlingModules  = $Param{WebserviceConfig}->{ $Param{CommunicationType} }->{ErrorHandling}         || {};
    my $ErrorHandlingPriority = $Param{WebserviceConfig}->{ $Param{CommunicationType} }->{ErrorHandlingPriority} || {};

    # Check for configured error handling modules and priority.
    if ( !IsHashRefWithData($ErrorHandlingModules) || !IsArrayRefWithData($ErrorHandlingPriority) ) {

        # Obviously nothing configured, just return.
        return {
            Success => 1,
        };
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Run all registered and activated error handler modules.
    my @ReturnData;
    my $ReScheduleData;
    my %StopAfterMatch;
    my %FilterRegexStrings;
    ERRORHANDLINGCONFIGKEY:
    for my $ErrorHandlingConfigKey ( @{$ErrorHandlingPriority} ) {
        next ERRORHANDLINGCONFIGKEY if !$ErrorHandlingConfigKey;

        if ( !IsHashRefWithData( $ErrorHandlingModules->{$ErrorHandlingConfigKey} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Error handling module name not found for entry '$ErrorHandlingConfigKey' in WebserviceID $Param{WebserviceID} ($Param{CommunicationType})!",
            );

            next ERRORHANDLINGCONFIGKEY;
        }

        my $ModuleConfig       = $ErrorHandlingModules->{$ErrorHandlingConfigKey};
        my $ModuleRegistration = $ErrorHandlingConfig->{ $ModuleConfig->{Type} };
        next ERRORHANDLINGCONFIGKEY if $StopAfterMatch{ $ModuleConfig->{Type} };

        if ( !IsHashRefWithData($ModuleRegistration) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Error handling module config registration not found for entry '$ErrorHandlingConfigKey' in WebserviceID $Param{WebserviceID} ($Param{CommunicationType})!",
            );

            next ERRORHANDLINGCONFIGKEY;
        }

        # Check if the registration for each error handler module is valid.
        if ( !$ModuleRegistration->{Name} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Module registration for error handling entry '$ErrorHandlingConfigKey' is invalid in WebserviceID $Param{WebserviceID} ($Param{CommunicationType})!",
            );

            next ERRORHANDLINGCONFIGKEY;
        }

        my $ErrorHandlingModule = 'Kernel::GenericInterface::ErrorHandling::' . $ModuleConfig->{Type};

        # Check if backend field exists.
        if ( !$MainObject->Require($ErrorHandlingModule) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Can't load error handling module '$ErrorHandlingModule' in WebserviceID $Param{WebserviceID} ($Param{CommunicationType})!",
            );

            next ERRORHANDLINGCONFIGKEY;
        }

        # Check if error handling object should be called based on filters.
        my $CommunicationNameFilterName;
        if ( $Param{CommunicationType} eq 'Requester' ) {
            $CommunicationNameFilterName = 'InvokerFilter';
        }
        else {
            $CommunicationNameFilterName = 'OperationFilter';
        }

        if ( IsArrayRefWithData( $ModuleConfig->{$CommunicationNameFilterName} ) ) {

            # Only execute module for configured invoker/operations.
            next ERRORHANDLINGCONFIGKEY if !IsStringWithData( $Param{CommunicationName} );
            if ( !grep { $_ eq $Param{CommunicationName} } @{ $ModuleConfig->{$CommunicationNameFilterName} } ) {
                next ERRORHANDLINGCONFIGKEY;
            }
        }

        if ( IsArrayRefWithData( $ModuleConfig->{ErrorStageFilter} ) ) {

            # Only execute module for configured error stages.
            next ERRORHANDLINGCONFIGKEY if !grep { $_ eq $Param{ErrorStage} } @{ $ModuleConfig->{ErrorStageFilter} };
        }

        if ( IsStringWithData( $ModuleConfig->{ErrorMessageContentFilter} ) ) {

            # OPrepare filter strings.
            my @FilterParams = (qw(Summary Data));
            if ( !%FilterRegexStrings ) {
                for my $FilterParam (@FilterParams) {
                    if ( IsString( $Param{$FilterParam} ) ) {
                        $FilterRegexStrings{$FilterParam} = $Param{$FilterParam};
                    }
                    else {
                        $FilterRegexStrings{$FilterParam} = $MainObject->Dump( $Param{$FilterParam} );
                    }
                }
            }

            # Only execute module if configured regex contains any matches.
            my $RegexMatch;
            my $FilterRegex = qr{$ModuleConfig->{ErrorMessageContentFilter}};
            FILTERPARAM:
            for my $FilterParam (@FilterParams) {
                next FILTERPARAM if $FilterRegexStrings{$FilterParam} !~ $FilterRegex;
                $RegexMatch = 1;
                last FILTERPARAM;
            }

            next ERRORHANDLINGCONFIGKEY if !$RegexMatch;
        }

        my $ErrorHandlingObject = $Kernel::OM->Get($ErrorHandlingModule);
        if ( !$ErrorHandlingObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Couldn't create an object of error handling module '$ModuleConfig->{Type}' in WebserviceID $Param{WebserviceID} ($Param{CommunicationType})!",
            );

            next ERRORHANDLINGCONFIGKEY;
        }

        if ( ref $ErrorHandlingObject ne $ErrorHandlingModule ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Error handling object for module '$ModuleConfig->{Type}' was not created successfully in WebserviceID $Param{WebserviceID} ($Param{CommunicationType})!",
            );

            next ERRORHANDLINGCONFIGKEY;
        }

        my $ErrorHandlingResult = $ErrorHandlingObject->Run(
            %Param,
            ModuleConfig => $ModuleConfig,
        );
        if ( !$ErrorHandlingResult->{Success} ) {
            return $Self->_LogAndReturn(
                %Param,
                ErrorMessage => $ErrorHandlingResult->{ErrorMessage},
            );
        }

        push @ReturnData, {
            ModuleConfig => $ModuleConfig,
            ModuleData   => $ErrorHandlingResult->{Data},
            ModuleName   => $ErrorHandlingConfigKey,
        };

        $DebuggerObject->Debug(
            Summary => "Executed error handling module '$ErrorHandlingConfigKey'",
            Data    => $ReturnData[-1],
        );

        if ( IsHashRefWithData( $ErrorHandlingResult->{ReScheduleData} ) ) {
            $ReScheduleData = $ErrorHandlingResult->{ReScheduleData};

            # Print desired reschedule result.
            $DebuggerObject->Info(
                Summary => "Got reschedule decision from error handling '$ErrorHandlingConfigKey'",
                Data    => $ErrorHandlingResult->{ReScheduleData},
            );
        }

        # Check if we should skip some/all further modules.
        if ( IsStringWithData( $ModuleConfig->{StopAfterMatch} ) ) {
            last ERRORHANDLINGCONFIGKEY if $ModuleConfig->{StopAfterMatch} eq 'all';
            if ( $ModuleConfig->{StopAfterMatch} eq 'backend' ) {
                $StopAfterMatch{ $ModuleConfig->{Type} } = 1;
            }
        }

        next ERRORHANDLINGCONFIGKEY if !IsHashRefWithData( $ErrorHandlingResult->{Data} );
    }

    # Print final rescheduling info.
    if (
        IsHashRefWithData($ReScheduleData)
        && $ReScheduleData->{ReSchedule}
        )
    {
        $DebuggerObject->Notice(
            Summary => 'Request will be retried again at:',
            Data    => $ReScheduleData->{ExecutionTime},
        );
    }

    return {
        Success        => 1,
        Data           => \@ReturnData,
        ReScheduleData => $ReScheduleData,
    };
}

sub _LogAndReturn {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(WebserviceID WebserviceConfig CommunicationID CommunicationType Summary ErrorMessage)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Got no $Needed!",
            );

            return {
                Success      => 0,
                ErrorMessage => $Param{Summary} || "Got no $Needed!",
            };
        }
    }

    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig    => $Param{WebserviceConfig}->{Debugger},
        WebserviceID      => $Param{WebserviceID},
        CommunicationType => $Param{CommunicationType},
        CommunicationID   => $Param{CommunicationID},
    );

    $DebuggerObject->Error(
        Summary => $Param{ErrorMessage},
    );

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Param{ErrorMessage},
    );

    return {
        Success      => 0,
        ErrorMessage => $Param{ErrorMessage},
    };
}

1;
