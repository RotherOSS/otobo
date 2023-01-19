# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Email::Sendmail;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{Type} = 'Sendmail';

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => 'Received message for sending, validating message contents.',
    );

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            my $ErrorMsg = "Need $_!";

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::Email::Sendmail',
                Value         => $ErrorMsg,
            );

            return $Self->_SendError(
                %Param,
                ErrorMessage => $ErrorMsg,
            );
        }
    }

    # from for arg
    my $Arg = $Param{From} ? quotemeta( $Param{From} ) : "''";

    # get recipients
    my $ToString = '';
    for my $To ( @{ $Param{ToArray} } ) {
        if ($ToString) {
            $ToString .= ', ';
        }
        $ToString .= $To;
        $Arg      .= ' ' . quotemeta($To);
    }

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => 'Checking availability of sendmail command.',
    );

    # check availability
    my %Result = $Self->Check();

    if ( !$Result{Success} ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::Sendmail',
            Value         => "Sendmail check error: $Result{ErrorMessage}",
        );

        return $Self->_SendError(
            %Param,
            %Result,
        );
    }

    $Param{CommunicationLogObject}->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    my $From = $Param{From} // '';
    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => "Sending email from '$From' to '$ToString'.",
    );

    # set sendmail binary
    my $Sendmail = $Result{Sendmail};

    # restore the child signal to the original value, in a daemon environment, child signal is set
    # to ignore causing problems with file handler pipe close
    local $SIG{'CHLD'} = 'DEFAULT';

    # invoke sendmail in order to send off mail, catching errors in a temporary file
    my $FH;
    my $GenErrorMessage = sub { return sprintf( q{Can't send message: %s!}, shift, ); };

    if ( !open( $FH, '|-', "$Sendmail $Arg " ) ) {    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
        my $ErrorMessage = $GenErrorMessage->($!);

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::Sendmail',
            Value         => "Error during message sending: $ErrorMessage",
        );

        return $Self->_SendError(
            %Param,
            ErrorMessage => $ErrorMessage,
        );
    }

    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $EncodeObject->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $EncodeObject->EncodeOutput( $Param{Body} );

    print $FH ${ $Param{Header} };
    print $FH "\n";
    print $FH ${ $Param{Body} };

    # Check if the filehandle was already closed because of an error
    #   (e. g. mail too large). See bug#9251.
    if ( !close($FH) ) {

        my $ErrorMessage = $GenErrorMessage->($!);

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Connection',
            Priority      => 'Error',
            Key           => 'Kernel::System::Email::Sendmail',
            Value         => "Error during message sending: $ErrorMessage",
        );

        return $Self->_SendError(
            %Param,
            ErrorMessage => $ErrorMessage,
        );
    }

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::Sendmail',
        Value         => "Email successfully sent from '$From' to '$ToString'!",
    );

    $Param{CommunicationLogObject}->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return $Self->_SendSuccess();
}

sub _SendSuccess {
    my ( $Self, %Param ) = @_;

    return {
        %Param,
        Success => 1,
    };
}

sub _SendError {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Failed',
    );

    return {
        Success => 0,
        %Param,
    };
}

sub Check {
    my ( $Self, %Param ) = @_;

    # get config data
    my $Sendmail = $Kernel::OM->Get('Kernel::Config')->Get('SendmailModule::CMD');

    # check if sendmail binary is there (strip all args and check if file exists)
    my $SendmailBinary = $Sendmail;
    $SendmailBinary =~ s/^(.+?)\s.+?$/$1/;
    if ( !-f $SendmailBinary ) {
        return (
            Success      => 0,
            ErrorMessage => "No such binary: $SendmailBinary!"
        );
    }

    return (
        Success  => 1,
        Sendmail => $Sendmail,
    );
}

1;
