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

package Kernel::System::MailAccount::IMAP;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# other modules inherit from this module

# core modules

# CPAN modules
use Mail::IMAPClient 3.40 ();
use IO::Socket::SSL ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::PostMaster',
);

# these private subs will be overriden in child classes

sub _Type {
    return 'IMAP';
}

# The returned key value list will be passed to Mail::IMAPClient->new()
sub _ExtraIMAPClientArgs {

    # not special arguments
    return;
}

sub new {
    my ( $Class, %Param ) = @_;

    return bless {%Param}, $Class;
}

sub Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    NEEDED:
    for my $Key (qw(Login Password Host Timeout Debug)) {
        next NEEDED if defined $Param{$Key};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $_!"
        );

        return (
            Successful => 0,
            Message    => "Need $_!",
        );
    }

    # connect to host
    my $IMAPObject = Mail::IMAPClient->new(
        Server   => $Param{Host},
        Timeout  => $Param{Timeout},    # override the default timeout of 600s
        User     => $Param{Login},
        Password => $Param{Password},
        $Self->_ExtraIMAPClientArgs(),
        Debug => $Param{Debug},
        Uid   => 1,

        # see bug#8791: needed for some Microsoft Exchange backends
        Ignoresizeerrors => 1,
    );

    my $Type = $Self->_Type();

    # report failure
    return (
        Successful => 0,
        Message    => "$Type: Can't connect to $Param{Host}: $@\n"
    ) unless $IMAPObject;

    # looks good
    return (
        Successful => 1,
        IMAPObject => $IMAPObject,
    );
}

sub Fetch {
    my ( $Self, %Param ) = @_;

    # start a new incoming communication
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport   => 'Email',
            Direction   => 'Incoming',
            AccountType => $Param{Type},
            AccountID   => $Param{ID},
        },
    );

    # fetch again if still messages on the account
    my $CommunicationLogStatus = 'Successful';
    COUNT:
    for ( 1 .. 200 ) {
        my $FetchOK = $Self->_Fetch(
            %Param,
            CommunicationLogObject => $CommunicationLogObject,
        );
        if ( !$FetchOK ) {
            $CommunicationLogStatus = 'Failed';
        }

        last COUNT unless $Self->{Reconnect};
    }

    $CommunicationLogObject->CommunicationStop(
        Status => $CommunicationLogStatus,
    );

    return 1;
}

sub _Fetch {
    my ( $Self, %Param ) = @_;

    my $CommunicationLogObject = $Param{CommunicationLogObject};

    $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    my $Type = $Self->_Type();

    # check needed stuff
    KEY:
    for my $Key (qw(Login Password Host Trusted QueueID)) {
        next KEY if defined $Key;

        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => "Kernel::System::MailAccount::$Type",
            Value         => "$_ not defined!",
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );
        $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

        return;
    }

    KEY:
    for my $Key (qw(Login Password Host)) {
        next KEY if $Param{$Key};

        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => "Kernel::System::MailAccount::$Type",
            Value         => "Need $_!",
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

        return;
    }

    my $Debug = $Param{Debug} || 0;
    my $Limit = $Param{Limit} || 5000;
    my $CMD   = $Param{CMD}   || 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # MaxEmailSize is in kB in SysConfig, default is 6 MiB, that is 6 mebibyte
    my $MaxEmailSize = $ConfigObject->Get('PostMasterMaxEmailSize') || 1024 * 6;

    my $MaxPopEmailSession = $ConfigObject->Get('PostMasterReconnectMessage') || 20;
    my $Timeout            = 60;
    my $FetchCounter       = 0;

    $Self->{Reconnect} = 0;

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => "Kernel::System::MailAccount::$Type",
        Value         => "Open connection to '$Param{Host}' ($Param{Login}).",
    );

    my %Connect;
    eval {
        %Connect = $Self->Connect(
            Host     => $Param{Host},
            Login    => $Param{Login},
            Password => $Param{Password},
            Timeout  => $Timeout,
            Debug    => $Debug
        );

        return 1;
    } || do {
        my $Error = $@;
        %Connect = (
            Successful => 0,
            Message    =>
                "Something went wrong while trying to connect to '$Type => $Param{Login}/$Param{Host}': ${ Error }",
        );
    };

    if ( !$Connect{Successful} ) {
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => "Kernel::System::MailAccount::$Type",
            Value         => $Connect{Message},
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        $CommunicationLogObject->CommunicationStop( Status => 'Failed' );

        return;
    }

    my $IMAPOperation = sub {
        my ( $Operation, @Params ) = @_;

        my $IMAPObject = $Connect{IMAPObject};
        my $ScalarResult;
        my @ArrayResult;
        my $Wantarray = wantarray;

        eval {
            if ($Wantarray) {
                @ArrayResult = $IMAPObject->$Operation(@Params);
            }
            else {
                $ScalarResult = $IMAPObject->$Operation(@Params);
            }

            return 1;    # eval block was successful
        } || do {
            my $Error = $@;
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => sprintf(
                    "Error while executing '$Type->%s(%s)': %s",
                    $Operation,
                    join( ',', @Params ),
                    $Error,
                ),
            );
        };

        return @ArrayResult if $Wantarray;
        return $ScalarResult;
    };

    # read folder from MailAccount configuration
    my $IMAPFolder = $Param{IMAPFolder} || 'INBOX';
    my $Messages;
    my $NumberOfMessages     = 0;
    my $ConnectionWithErrors = 0;
    my $MessagesWithError    = 0;

    eval {
        $IMAPOperation->( 'select', $IMAPFolder, ) || die "Could not select: $@\n";

        # get a reference to an array of message numbers
        $Messages         = $IMAPOperation->( 'messages', ) || die "Could not retrieve messages : $@\n";
        $NumberOfMessages = scalar $Messages->@*;

        if ($CMD) {
            print "$Type: I found $NumberOfMessages messages on $Param{Login}/$Param{Host}. ";
        }

        return 1;
    } || do {
        my $Error = $@;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => sprintf(
                "Error while retrieving the messages '$Type': %s",
                $Error,
            ),
        );

        $ConnectionWithErrors = 1;
    };

    # fetch messages
    if ( $Messages && !$NumberOfMessages ) {
        if ($CMD) {
            print "$Type: No messages on $Param{Login}/$Param{Host}\n";
        }
    }
    elsif ($NumberOfMessages) {
        MESSAGE_NO:
        for my $Messageno ( $Messages->@* ) {

            # check if reconnect is needed
            $FetchCounter++;
            if ( $FetchCounter > $MaxPopEmailSession ) {
                $Self->{Reconnect} = 1;

                if ($CMD) {
                    print "$Type: Reconnect Session after $MaxPopEmailSession messages...\n";
                }

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Info',
                    Key           => "Kernel::System::MailAccount::$Type",
                    Value         => "Reconnect session after $MaxPopEmailSession messages.",
                );

                last MESSAGE_NO;
            }

            if ($CMD) {
                print "$Type: Message $FetchCounter/$NumberOfMessages ($Param{Login}/$Param{Host})\n";
            }

            # check maximum message size
            my $MessageSize = $IMAPOperation->( 'size', $Messageno, );
            if ( !defined $MessageSize ) {
                my $ErrorMessage = "$Type: Can't determine the size of email '$Messageno/$NumberOfMessages' from $Param{Login}/$Param{Host}!";

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => "Kernel::System::MailAccount::$Type",
                    Value         => $ErrorMessage,
                );

                $ConnectionWithErrors = 1;

                if ($CMD) {
                    print "\n";
                }

                next MESSAGE_NO;
            }

            $MessageSize = int( $MessageSize / 1024 );
            if ( $MessageSize > $MaxEmailSize ) {

                my $ErrorMessage = "$Type: Can't fetch email $Messageno from $Param{Login}/$Param{Host}. "
                    . "Email too big ($MessageSize KB - max $MaxEmailSize KB)!";

                $CommunicationLogObject->ObjectLog(
                    ObjectLogType => 'Connection',
                    Priority      => 'Error',
                    Key           => "Kernel::System::MailAccount::$Type",
                    Value         => $ErrorMessage,
                );

                $ConnectionWithErrors = 1;
            }
            else {

                # safety protection
                my $FetchDelay = ( $FetchCounter % 20 == 0 ? 1 : 0 );
                if ( $FetchDelay && $CMD ) {
                    print "$Type: Safety protection: waiting 1 second before processing next mail...\n";

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => "Kernel::System::MailAccount::$Type",
                        Value         => 'Safety protection: waiting 1 second before fetching next message from server.',
                    );

                    sleep 1;
                }

                # get message (header and body)
                my $Message = $IMAPOperation->( 'message_string', $Messageno, );
                if ( !$Message ) {

                    my $ErrorMessage = "$Type: Can't process mail, email no $Messageno is empty!";

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Error',
                        Key           => "Kernel::System::MailAccount::$Type",
                        Value         => $ErrorMessage,
                    );

                    $ConnectionWithErrors = 1;
                }
                else {
                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => "Kernel::System::MailAccount::$Type",
                        Value         => "Message '$Messageno' successfully received from server.",
                    );

                    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );
                    my $MessageStatus = 'Successful';

                    my $PostMasterObject = $Kernel::OM->Create(
                        'Kernel::System::PostMaster',
                        ObjectParams => {
                            $Self->%*,
                            Email                  => \$Message,
                            Trusted                => $Param{Trusted} || 0,
                            Debug                  => $Debug,
                            CommunicationLogObject => $CommunicationLogObject,
                        },
                    );

                    # In case of error, mark message as failed.
                    my @Return = eval {
                        return $PostMasterObject->Run( QueueID => $Param{QueueID} || 0 );
                    };
                    my $Exception = $@ || undef;

                    if ( !$Return[0] ) {
                        $MessagesWithError += 1;

                        if ($Exception) {
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'error',
                                Message  => 'Exception while processing mail: ' . $Exception,
                            );
                        }

                        my $File = $Self->_ProcessFailed( Email => $Message );

                        $CommunicationLogObject->ObjectLog(
                            ObjectLogType => 'Message',
                            Priority      => 'Error',
                            Key           => "Kernel::System::MailAccount:$Type",
                            Value         => "$Type: Could not process message. Raw mail saved ($File, report it on https://github.com/RotherOSS/otobo/issues)!",
                        );

                        $MessageStatus = 'Failed';
                    }

                    # mark email to delete once it was processed
                    $IMAPOperation->( 'delete_message', $Messageno, );

                    $CommunicationLogObject->ObjectLog(
                        ObjectLogType => 'Connection',
                        Priority      => 'Debug',
                        Key           => "Kernel::System::MailAccount::$Type",
                        Value         => "Message '$Messageno' marked for deletion.",
                    );

                    undef $PostMasterObject;

                    $CommunicationLogObject->ObjectLogStop(
                        ObjectLogType => 'Message',
                        Status        => $MessageStatus,
                    );
                }

                # check limit
                $Self->{Limit}++;
                if ( $Self->{Limit} >= $Limit ) {
                    $Self->{Reconnect} = 0;
                    last MESSAGE_NO;
                }
            }

            if ($CMD) {
                print "\n";
            }

            # Discarding ticket object to enable triggering of
            # ticket events even in case of mail server timeout
            $Kernel::OM->ObjectsDiscard(
                Objects => ['Kernel::System::Ticket'],
            );
        }
    }

    # log status
    if ( $Debug > 0 || $FetchCounter ) {
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Info',
            Key           => "Kernel::System::MailAccount::$Type",
            Value         => "$Type: Fetched $FetchCounter email(s) from $Param{Login}/$Param{Host}.",
        );
    }
    $IMAPOperation->( 'close', );
    if ($CMD) {
        print "$Type: Connection to $Param{Host} closed.\n\n";
    }

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Debug',
        Key           => "Kernel::System::MailAccount::Type",
        Value         => "Connection to '$Param{Host}' closed.",
    );

    if ($ConnectionWithErrors) {
        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        return;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );
    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    return if $MessagesWithError;
    return 1;
}

sub _ProcessFailed {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Email} ) {

        my $ErrorMessage = "'Email' not defined!";

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );
        return;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/spool/';
    my $MD5        = $MainObject->MD5sum(
        String => \$Param{Email},
    );
    my $Location = $Home . 'problem-email-' . $MD5;

    return $MainObject->FileWrite(
        Location   => $Location,
        Content    => \$Param{Email},
        Mode       => 'binmode',
        Type       => 'Local',
        Permission => '640',
    );
}

1;
