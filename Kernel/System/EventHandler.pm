# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

Kernel::System::EventHandler - event handling trait

=head1 DESCRIPTION

This module is not instantiated on its own. It is only meant to provide enhanced functionality
to other classes. As it adds new methods and attributes to a class it constitutes a trait.
C<Kernel::System::Ticket> is an example for a class that employs this enhancement mechanism.
An instance of such an enhanced class constitutes an event handler object.

The trait C<Kernel::System::EventHandler> provides the possibility to use event handling modules like
C<Kernel::System::Ticket::Event::ArchiveRestore>. These event handling modules must have been registered
in the OTOBO SysConfig under a category like "Ticket::EventModulePost".
The event handler object first expresses interest in a specific category.
Then the business logic code of the event handler object may emit events which are then handled by the relevant modules.
Only the modules matching both the category and the name of the event are executed.

A special feature is that there are two types of event handling modules. The modules without the attribute I<Transaction>
handle the event immediately when the event is emitted. The modules marked as I<Transaction> handle the events at a
deferred time. The execution of the transaction event handling modules is primarily triggered by destruction of the object manager.
But any other code may also trigger the execution by calling C<EventHandlerTransaction()> on the event handler object.

=head2 Usage by an event handler object

A class that wants to use event handling must inherit from this class.

    use parent qw(Kernel::System::EventHandler);

An event handler object needs to indicate in which category of event handling modules it is interested.
It also needs to register itself with the object manager. Both goals are achieved by calling L</EventHandlerInit()>.
This is usually already done in the constructor.

The event handler object emits an event by calling the method L</EventHandler()>.
This method will call the event handling modules to which the class is subscribed and
and which are registered for the specific event.
L</EventHandler()> will also queue the event so that the Transaction event handling modules can be triggered later.

In the destructor of the enhanced class you should add a call to L</EventHandlerTransaction()>
to make sure that also C<Transaction> events will be executed correctly.
This is only necessary if you use C<Transaction> event handling modules in your class.

=head2 Special case in Kernel::System::MailQueue

An instance of C<Kernel::System::MailQueue> emits the events 'ArticleEmailSending(Queued|Sent|Error)'. These events are handled
by the transaction event handling module C<Kernel::System::Ticket::Event::NotificationEvent>. But in this
context the notifications should be sent out immediately. This goal is achieved by passing a special combination
of parameters and attributes. This is not the recommended practice.

=head1 PUBLIC INTERFACE

=head2 EventHandlerInit()

Call this method in order to initialize the event handling mechanism.

    $Self->EventHandlerInit(
        Config     => 'Example::EventModule', # category of event handling modules
    );

The event handler object expressed interest in the passed category.
It also registers itself with the object manager.

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

    # subscribe to a category of event handling modules
    # %Param is something like: ( Config => 'ITSM::EventModule' )
    $Self->{EventHandlerInit} = \%Param;

    # Register the event handler object with the object manager. Giving the object manager
    # the chance to handle events with the transaction even handling modules
    $Kernel::OM->ObjectRegisterEventHandler( EventHandler => $Self );

    return 1;
}

=head2 EventHandler()

emits an event. It returns true if the immediate event handling modules were executed successfully.

Example 1:

    my $Success = $EventHandler->EventHandler(
        Event => 'TicketStateUpdate',   # event name, passed to the event handling modules
        Data  => {                      # data payload for the event, passed to the event handling modules
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
This parameter indicates that the transaction event handling modules should be executed.

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

    # Store the events so that they can be handled later by the transaction event handling modules.
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

handle the queued events with the transaction event handling modules

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
