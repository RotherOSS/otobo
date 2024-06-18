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

package Kernel::System::DynamicField::ObjectType::Article;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::DynamicField::ObjectType::Article

=head1 DESCRIPTION

Article object handler for DynamicFields

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::ObjectType::Article->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 PostValueSet()

perform specific functions after the Value set for this object type.

    my $Success = $DynamicFieldTicketHandlerObject->PostValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        Value              => $Value,                   # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub PostValueSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    #
    # This is a rare case where we don't have the TicketID of an article, even though the article API requires it.
    #   Since this is not called often and we don't want to cache on per-article basis, get the ID directly from the
    #   database and use it.
    #

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $TicketID;

    return if !$DBObject->Prepare(
        SQL => '
            SELECT ticket_id
            FROM article
            WHERE id = ?',
        Bind  => [ \$Param{ObjectID} ],
        Limit => 1,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $TicketID = $Row[0];
    }

    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine TicketID of Article $Param{ArticleID}!",
        );
        return;
    }

    # update change time
    return if !$DBObject->Do(
        SQL => '
            UPDATE ticket
            SET change_time = current_timestamp, change_by = ?
            WHERE id = ?',
        Bind => [ \$Param{UserID}, \$TicketID ],
    );

    my $HistoryValue    = $Param{Value}    // '';
    my $HistoryOldValue = $Param{OldValue} // '';

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get value for storing
    my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Value              => $HistoryValue,
    );
    $HistoryValue = $ValueStrg->{Value};

    my $OldValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Value              => $HistoryOldValue,
    );
    $HistoryOldValue = $OldValueStrg->{Value};

    my $FieldName;
    if ( !defined $Param{DynamicFieldConfig}->{Name} ) {
        $FieldName = '';
    }
    else {
        $FieldName = $Param{DynamicFieldConfig}->{Name};
    }

    my $FieldNameLength       = length $FieldName       || 0;
    my $HistoryValueLength    = length $HistoryValue    || 0;
    my $HistoryOldValueLength = length $HistoryOldValue || 0;

    # Name in ticket_history is like this form "\%\%FieldName\%\%$FieldName\%\%Value\%\%$HistoryValue\%\%OldValue\%\%$HistoryOldValue" up to 200 chars
    # \%\%FieldName\%\% is 13 chars
    # \%\%Value\%\% is 9 chars
    # \%\%OldValue\%\%$HistoryOldValue is 12
    # we have for info part of ticket history data ($FieldName+$HistoryValue+$OldValue) up to 166 chars
    # in this code is made substring. The same number of characters is provided for both of part in Name ($FieldName and $HistoryValue and $OldVAlue) up to 55 chars
    # if $FieldName and $HistoryValue and $OldVAlue is cut then info is up to 50 chars plus [...] (5 chars)
    # First it is made $HistoryOldValue, then it is made $FieldName, and then  $HistoryValue
    # Length $HistoryValue can be longer then 55 chars, also is for $OldValue.

    my $NoCharacters = 166;

    if ( ( $FieldNameLength + $HistoryValueLength + $HistoryOldValueLength ) > $NoCharacters ) {

        # OldValue is maybe less important
        # At first it is made HistoryOldValue
        # and now it is possible that for HistoryValue would FieldName be more than 55 chars
        if ( length($HistoryOldValue) > 55 ) {
            $HistoryOldValue = substr( $HistoryOldValue, 0, 50 );
            $HistoryOldValue .= '[...]';
        }

        # limit FieldName to 55 chars if is necessary
        my $FieldNameLength = int( ( $NoCharacters - length($HistoryOldValue) ) / 2 );
        my $ValueLength     = $FieldNameLength;
        if ( length($FieldName) > $FieldNameLength ) {

            # HistoryValue will be at least 55 chars or more, if is FieldName or HistoryOldValue less than 55 chars
            if ( length($HistoryValue) > $ValueLength ) {
                $FieldNameLength = $FieldNameLength - 5;
                $FieldName       = substr( $FieldName, 0, $FieldNameLength );
                $FieldName .= '[...]';
                $ValueLength  = $ValueLength - 5;
                $HistoryValue = substr( $HistoryValue, 0, $ValueLength );
                $HistoryValue .= '[...]';
            }
            else {
                $FieldNameLength = $NoCharacters - length($HistoryOldValue) - length($HistoryValue) - 5;
                $FieldName       = substr( $FieldName, 0, $FieldNameLength );
                $FieldName .= '[...]';
            }
        }
        else {
            $ValueLength = $NoCharacters - length($HistoryOldValue) - length($FieldName) - 5;
            if ( length($HistoryValue) > $ValueLength ) {
                $HistoryValue = substr( $HistoryValue, 0, $ValueLength );
                $HistoryValue .= '[...]';
            }
        }
    }

    # Add history entry.
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    $TicketObject->HistoryAdd(
        TicketID    => $TicketID,
        ArticleID   => $Param{ObjectID},
        HistoryType => 'ArticleDynamicFieldUpdate',

        # This insert is not optimal at all (not human readable), but will be kept due to backwards compatibility. The
        #   value will be converted for use in a more speaking form directly in AgentTicketHistory.pm before display.
        Name => '%%' . join(
            '%%',
            FieldName => $FieldName,
            Value     => ( $HistoryValue    // '' ),
            OldValue  => ( $HistoryOldValue // '' ),
        ),
        CreateUserID => $Param{UserID},
    );

    # clear ticket cache
    $TicketObject->_TicketCacheClear( TicketID => $TicketID );

    # Trigger event.
    $TicketObject->EventHandler(
        Event => 'ArticleDynamicFieldUpdate',
        Data  => {
            FieldName => $Param{DynamicFieldConfig}->{Name},
            Value     => $Param{Value},
            OldValue  => $Param{OldValue},
            TicketID  => $TicketID,
            ArticleID => $Param{ObjectID},
            UserID    => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ObjectDataGet()

retrieves the data of the current object.

    my %ObjectData = $DynamicFieldTicketHandlerObject->ObjectDataGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        UserID             => 123,
    );

returns:

    %ObjectData = (
        ObjectID => 123,
        Data     => {
            ArticleID              => 123,
            TicketID               => 2,
            CommunicationChannelID => 1,
            SenderTypeID           => 1,
            IsVisibleForCustomer   => 0,
            # ...
        }
    );

=cut

sub ObjectDataGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(DynamicFieldConfig UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check DynamicFieldConfig (general).
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # Check DynamicFieldConfig (internally).
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $ArticleID = $ParamObject->GetParam(
        Param => 'ArticleID',
    );

    return if !$ArticleID;

    my $TicketID = $ParamObject->GetParam(
        Param => 'TicketID',
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # In case TicketID is not in the web request, look for it using the article.
    if ( !$TicketID ) {
        $TicketID = $ArticleObject->TicketIDLookup(
            ArticleID => $ArticleID,
        );
    }

    if ( !$TicketID ) {
        return (
            ObjectID => $ArticleID,
            Data     => {},
        );
    }

    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        ArticleID => $ArticleID,
        TicketID  => $TicketID
    );

    my %ArticleData = $ArticleBackendObject->ArticleGet(
        ArticleID     => $ArticleID,
        DynamicFields => 1,
        TicketID      => $TicketID,
        UserID        => $Param{UserID},
    );

    return (
        ObjectID => $ArticleID,
        Data     => \%ArticleData,
    );
}

1;
