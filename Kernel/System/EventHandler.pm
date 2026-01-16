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

Kernel::System::EventHandler - support for event handling, dispatch emitted events to their subscribers

=head1 DESCRIPTION

The module L<Kernel::System::EventHandler> is not instantiated on its own. It is only meant to enhance the functionality
of other classes. It constitutes a trait as it adds new methods and attributes to a class.

Despite its name, the module itself does not implement actions that handle events. Instead it acts as
the dispatcher that connects event emitters and subscribers.
Classes enhanced by L<Kernel::System::EventHandler> are called event emitters.
L<Kernel::System::Ticket> is an example for an event emitter as it emits ticket related events.

The actual handling of events is delegated to subscriber, aka event handling modules. They can be thought of as
modules which provide callback functions. An example for a subscriber is
L<Kernel::System::Ticket::Event::ArchiveRestore>.

Events are dispatched based on a category and the event name. For example L<Kernel::System::Ticket> declares
that it emits events in the category C<Ticket::EventModulePost>. The emitted events have names
like 'TicketCreate' and 'TicketDelete'.

The connection between event emitters and event subscribers is done via the SysConfig. Subscribers
must be declared in the SysConfig and the must specify which category of event they are handling.

The business logic code of the emitter emits events by calling the method C<EventHandler()>
Only the subscribers matching category are executed. Based on the event name, the subscriber
decides which events are ignored and which are acted upon.

A special feature is that there are two types of subscribers. The modules
without the attribute I<Transaction> handle the event immediately when it is emitted.
The modules marked as I<Transaction> handle the event at a
deferred time. The execution of the transaction subscribers is usually triggered by the
destruction of the object manager C<$Kernel::OM>. But any other code may also trigger the execution
by calling C<EventHandlerTransaction()> on the emitter.

=head2 Usage by an emitter

A class that wants to use event handling, aka emitter, must inherit from this class.

    use parent qw(Kernel::System::EventHandler);

An emitter needs to indicate which category of events it emits.
It also needs to register itself with the object manager. Both goals are achieved by calling L</EventHandlerInit()>.
This is usually already done in the constructor.

The emitter emits an event by calling the method L</EventHandler()>.
This method will call the subscribers which are subscribed to the category of the emitter.
L<Kernel::System::EventHandler()> will also queue the event so that the transaction subscribers can be triggered later.
The events are handled in the order of insertion, that is in FIFO order. Note that the queue are per emitter, not global.

In the destructor of the emitter you should add a call to L</EventHandlerTransaction()>
to make sure that also C<Transaction> events will be executed correctly.
This is only necessary if there are C<Transaction> subscribers of your category.

=head2 Special case in Kernel::System::MailQueue

An instance of C<Kernel::System::MailQueue> emits the events 'ArticleEmailSending(Queued|Sent|Error)'. These events are handled
by the transaction subscriber C<Kernel::System::Ticket::Event::NotificationEvent>. But in this
context the notifications should be sent out immediately. This goal is achieved by passing a special combination
of parameters and attributes. Please note that this is not the recommended practice.

=head1 PUBLIC INTERFACE

=head2 EventHandlerInit()

Call this method in order to initialize the event handling mechanism, to declare your category.

    $Self->EventHandlerInit(
        Config     => 'Example::EventModule', # category of event handling modules
    );

The emitter also registers itself with the object manager.

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

The system is flexible enough to accommodate for extensions of OTOBO core.

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

    # declare the category of this emitter
    # %Param is something like: ( Config => 'ITSM::EventModule' )
    $Self->{EventHandlerInit} = \%Param;

    # Register the emitter with the object manager. Giving the object manager
    # the chance to handle events with the transaction subscribers.
    $Kernel::OM->ObjectRegisterEventHandler( EventHandler => $Self );

    return 1;
}

=head2 EventHandler()

emits an event. It returns true if the immediate subscribers had been executed successfully.

Example 1:

    my $Success = $EventHandler->EventHandler(
        Event => 'TicketStateUpdate',   # event name, passed to the subscribers
        Data  => {                      # data payload for the event, passed to the subscribers
            TicketID => 123,
        },
        UserID => 123,
    );

Example 2:

    my $Success = $EventHandler->EventHandler(
        Event => 'ChangeUpdate',
        Data  => {
            ChangeID => 123,
        },
        UserID => 123,
    );

There is an additional parameter C<Transaction> which should be used only internally.
This parameter indicates that the transaction subscribers should do their work.

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

    # get configured subscribers from SysConfig
    my $Modules = $Kernel::OM->Get('Kernel::Config')->Get( $Self->{EventHandlerInit}->{Config} );

    # nothing to do when there are no subscribers
    return 1 unless $Modules;

    # Store the events so that they can be handled later by the transaction subscribers.
    # Only when we are nor currently running the transaction modules.
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

handle the queued events with the transaction subscribers.

    $EventHandler->EventHandlerTransaction();

This method is called during the destructor of the object manager.
It can also be called by long running scripts.

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

    # Remember that we are in the mode that handles the queued events. That is, we are
    # running the transaction subscribers for these events. In this mode, both
    # the immediate and the transaction subscribers are running immediately
    # when an event is emitted. New events are not added to the queue.
    $Self->{EventHandlerTransaction} = 1;

    ## nofilter(TidyAll::Plugin::OTOBO::Perl::ObjectManagerCreation)
    # Set up a clean object manager here to enable correct handling of nested transactions.
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

    # loop protection
    $Kernel::OM->{TransactionDepth} = ( $OuterOM->{TransactionDepth} // 0 ) + 1;
    if ( $Kernel::OM->{TransactionDepth} > 250 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Ran into event loop! Stopping execution. Current unprocessed events: "
                . join( ", " . map { $_->{Event} // '' } @{ $Self->{EventHandlerPipe} // {} } ),
        );

        return;
    }

    # handle the queued events on end of transaction
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

    # The localized object manager is destroyed here. This means that the method DESTROY is called.
    # DESTROY runs the transaction subscribers for the events that were generated
    # while running the above loop.

    return 1;
}

=head2 EventHandlerHasQueuedTransactions()

returns a true value if there are queued events. The queued events
are handled in C<EventHandlerTransaction()> by the transaction event modules.

=cut

sub EventHandlerHasQueuedTransactions {
    my ( $Self, %Param ) = @_;

    return IsArrayRefWithData( $Self->{EventHandlerPipe} );
}

1;
