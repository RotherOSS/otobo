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

package Kernel::System::EventHandler;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Pod::FunctionPod)

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::EventHandler - event handler interface

=head1 DESCRIPTION

Inherit from this class if you want to use events there.

    use parent qw(Kernel::System::EventHandler);

In your class, have to call L</EventHandlerInit()> first.

Then, to register events as they occur, use the L</EventHandler()>
method. It will call the event handler modules which are registered
for the given event, or queue them for later execution (so-called
'Transaction' events).

In the destructor, you should add a call to L</EventHandlerTransaction()>
to make sure that also C<Transaction> events will be executed correctly.
This is only necessary if you use C<Transaction> events in your class.

=head1 PUBLIC INTERFACE

=head2 EventHandlerInit()

Call this to initialize the event handling mechanisms to work
correctly with your object.

    $Self->EventHandlerInit(
        # name of configured event modules
        Config     => 'Example::EventModule',
    );

Example 1:

    $Self->EventHandlerInit(
        Config     => 'Ticket::EventModulePost',
    );

Example 1 XML config:

    <ConfigItem Name="Example::EventModule###99-EscalationIndex" Required="0" Valid="1">
        <Description Translatable="1">Example event module updates the example escalation index.</Description>
        <Group>Example</Group>
        <SubGroup>Core::Example</SubGroup>
        <Setting>
            <Hash>
                <Item Key="Module">Kernel::System::Example::Event::ExampleEscalationIndex</Item>
                <Item Key="Event">(ExampleSLAUpdate|ExampleQueueUpdate|ExampleStateUpdate|ExampleCreate)</Item>
                <Item Key="SomeOption">Some Option accessable via $Param{Config}->{SomeOption} in Run() of event module.</Item>
                <Item Key="Transaction">(0|1)</Item>
            </Hash>
        </Setting>
    </ConfigItem>

Example 2:

    $Self->EventHandlerInit(
        Config     => 'ITSM::EventModule',
    );

Example 2 XML config:

    <ConfigItem Name="ITSM::EventModule###01-HistoryAdd" Required="0" Valid="1">
        <Description Translatable="1">ITSM event module updates the history for Change and WorkOrder objects..</Description>
        <Group>ITSM Change Management</Group>
        <SubGroup>Core::ITSMEvent</SubGroup>
        <Setting>
            <Hash>
                <Item Key="Module">Kernel::System::ITSMChange::Event::HistoryAdd</Item>
                <Item Key="Event">(ChangeUpdate|WorkOrderUpdate|ChangeAdd|WorkOrderAdd)</Item>
                <Item Key="SomeOption">Some Option accessable via $Param{Config}->{SomeOption} in Run() of event module.</Item>
                <Item Key="Transaction">(0|1)</Item>
            </Hash>
        </Setting>
    </ConfigItem>
    <ConfigItem Name="ITSM::EventModule###02-HistoryAdd" Required="0" Valid="1">
        <Description Translatable="1">ITSM event module updates the ConfigItem History.</Description>
        <Group>ITSM Configuration Management</Group>
        <SubGroup>Core::ITSMEvent</SubGroup>
        <Setting>
            <Hash>
                <Item Key="Module">Kernel::System::ITSMConfigurationManagement::Event::HistoryAdd</Item>
                <Item Key="Event">(ConfigItemUpdate|ConfigItemAdd)</Item>
                <Item Key="SomeOption">Some Option accessable via $Param{Config}->{SomeOption} in Run() of event module.</Item>
                <Item Key="Transaction">(0|1)</Item>
            </Hash>
        </Setting>
    </ConfigItem>

=cut

sub EventHandlerInit {
    my ( $Self, %Param ) = @_;

    $Self->{EventHandlerInit} = \%Param;
    $Kernel::OM->ObjectRegisterEventHandler( EventHandler => $Self );

    return 1;
}

=head2 EventHandler()

call event handler, returns true if it was executed successfully.

Example 1:

    my $Success = $EventHandler->EventHandler(
        Event => 'TicketStateUpdate',   # event classification, passed to the configured event handlers
        Data  => {                      # data payload for the event, passed to the configured event handlers
            TicketID => 123,
        },
        UserID => 123,
        Transaction => 1,               # optional, 0 or 1
    );

In 'Transaction' mode, all events will be collected and executed together,
usually in the destructor of your object.

Example 2:

    my $Success = $EventHandler->EventHandler(
        Event => 'ChangeUpdate',
        Data  => {
            ChangeID => 123,
        },
        UserID => 123,
    );

=cut

sub EventHandler {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get configured event handling modules from SysConfig
    my $Modules = $Kernel::OM->Get('Kernel::Config')->Get( $Self->{EventHandlerInit}->{Config} );

    # nothing to do when there are no event handling modules
    return 1 unless $Modules;

    # remember events only on normal mode
    if ( !$Self->{EventHandlerTransaction} ) {
        $Self->{EventHandlerPipe} //= [];
        push $Self->{EventHandlerPipe}->@*, \%Param;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # load modules and execute
    MODULE:
    for my $Module ( sort keys %{$Modules} ) {

        # If the module has an event configuration, determine if it should be executed for this event,
        #   and store the result in a small cache to avoid repetition on jobs involving many tickets.
        #   Values in the cache are either the number 1 or the empty string q{}.
        if ( !defined $Self->{ExecuteModuleOnEvent}->{$Module}->{ $Param{Event} } ) {
            if ( !$Modules->{$Module}->{Event} ) {
                $Self->{ExecuteModuleOnEvent}->{$Module}->{ $Param{Event} } = 1;
            }
            else {
                $Self->{ExecuteModuleOnEvent}->{$Module}->{ $Param{Event} } =
                    $Param{Event} =~ /$Modules->{$Module}->{Event}/;
            }
        }

        if ( $Self->{ExecuteModuleOnEvent}->{$Module}->{ $Param{Event} } ) {

            if ( $Self->{EventHandlerTransaction} && !$Param{Transaction} ) {

                # This is a special case. A new event was fired during processing of
                #   the queued events in transaction mode. This event must be immediately
                #   processed.
            }
            else {

                # This is the regular case. A new event was fired in regular mode, or
                #   we are processing a queued event in transaction mode. Only execute
                #   this if the transaction settings of event and listener are the same.

                # skip if we are not in transaction mode, but module is in transaction
                next MODULE if !$Param{Transaction} && $Modules->{$Module}->{Transaction};

                # skip if we are in transaction mode, but module is not in transaction
                next MODULE if $Param{Transaction} && !$Modules->{$Module}->{Transaction};
            }

            # load event module
            next MODULE if !$MainObject->Require( $Modules->{$Module}->{Module} );

            eval {
                # execute event backend
                my $Generic = $Modules->{$Module}->{Module}->new();

                $Generic->Run(
                    %Param,
                    Config => $Modules->{$Module},
                );
            };
            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$Module died with: $@",
                );
            }
        }
    }

    return 1;
}

=head2 EventHandlerTransaction()

handle all queued 'Transaction' events which were collected up to this point.

    $EventHandler->EventHandlerTransaction();

Call this method in the destructor of your object which inherits from
Kernel::System::EventHandler, like this:

    sub DESTROY {
        my $Self = shift;

        # execute all transaction events
        $Self->EventHandlerTransaction();

        return 1;
    }

=cut

sub EventHandlerTransaction {
    my ( $Self, %Param ) = @_;

    # remember, we are in destroy mode, do not execute new events
    $Self->{EventHandlerTransaction} = 1;

    ## nofilter(TidyAll::Plugin::OTOBO::Perl::ObjectManagerCreation)
    # set up a clean object manager here to enable correct handling of nested transactions
    my $OuterOM = $Kernel::OM;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    # The aim of instantiating a new $Kernel::OM is to have new
    # objects of all EventHandler-objects to set up fresh pipes.
    # But keep some objects for performance and compatibility reasons.
    #
    # The reason for keeping the Encode object is special. Keeping Kernel::System::Encode
    # avoids that binmode is called in the constructor.
    # This is important for batch processes as binmode increments the stack.
    # The large stack size causes core dumps when the unlimit for the stack size, usually 8192 kB,
    # is reached.
    my @KeepObjects = (
        'Kernel::System::Cache',
        'Kernel::System::DB',
        'Kernel::Config',
        'Kernel::System::Log',
        'Kernel::System::Encode',
    );
    for my $Object (@KeepObjects) {
        $Kernel::OM->{Objects}{$Object}            = $OuterOM->{Objects}{$Object};
        $Kernel::OM->{ObjectDependencies}{$Object} = $OuterOM->{ObjectDependencies}{$Object};
    }

    # execute events on end of transaction
    if ( $Self->{EventHandlerPipe} ) {

        for my $Params ( @{ $Self->{EventHandlerPipe} } ) {
            $Self->EventHandler(
                %Param,
                %{$Params},
                Transaction => 1,
            );
        }

        # delete event pipe
        undef $Self->{EventHandlerPipe};
    }

    # reset transaction mode
    $Self->{EventHandlerTransaction} = 0;

    return 1;
}

=head2 EventHandlerHasQueuedTransactions()

Return a true value if there are queued transactions. The queued transactions
are handled in C<EventHandlerTransaction()>.

=cut

sub EventHandlerHasQueuedTransactions {
    my ( $Self, %Param ) = @_;

    return IsArrayRefWithData( $Self->{EventHandlerPipe} );
}

1;
