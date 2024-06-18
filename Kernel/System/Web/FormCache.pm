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

package Kernel::System::Web::FormCache;

use strict;
use warnings;
use utf8;

# core modules
use MIME::Base64 qw(decode_base64 encode_base64);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Storable',
    'Kernel::System::Web::UploadCache',
);

=head1 NAME

Kernel::System::Web::FormCache - a cache which stores relevant form data

=head1 DESCRIPTION

All form data which has to be stored server side, except the upload cache.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $FormCacheObject = $Kernel::OM->Get('Kernel::System::Web::FormCache');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 PrepareFormID()

get the or create a Form ID and store it in the LayoutObject

    my $FormID = $FormCacheObject->PrepareFormID(
        LayoutObject => $LayoutObject,
        ParamObject  => $ParamObject,
    );

=cut

sub PrepareFormID {
    my ( $Self, %Param ) = @_;

    # check required params
    for my $Needed (qw/LayoutObject ParamObject/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # get form id or create a new one
    my $FormID = $Param{ParamObject}->GetParam( Param => 'FormID' ) || $Self->FormIDCreate();

    # store the FormID in the provided LayoutObject
    $Param{LayoutObject}{FormID} = $FormID;

    return $FormID;
}

=head2 GetFormData()

get data for a specific Form ID provided by the LayoutObject

    $FormCacheObject->GetFormData(
        LayoutObject => $LayoutObject,                          # must include SessionID
        FormID       => 123321,                                 # optional, if not provided, directly, has to be included in the LayoutObject
        Key          => 'PossibleValues_DynamicField_Name',     # optional - return data of a specific key
    );

=cut

sub GetFormData {
    my ( $Self, %Param ) = @_;

    # check required params
    for my $Needed (qw/LayoutObject/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $SessionID = $Param{LayoutObject}{SessionID};
    my $FormID    = $Param{FormID} || $Param{LayoutObject}{FormID};

    if ( !$FormID || !$SessionID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need FormID and SessionID in the LayoutObject!",
        );

        return;
    }

    if ( $Self->{Cache}{$SessionID}{$FormID} ) {

        return $Self->{Cache}{$SessionID}{$FormID}{ $Param{Key} } if $Param{Key};
        return $Self->{Cache}{$SessionID}{$FormID};
    }

    my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
    my $EncodeObject   = $Kernel::OM->Get('Kernel::System::Encode');
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    $DBObject->Prepare(
        SQL  => 'SELECT cache_key, cache_value, serialized FROM form_cache WHERE session_id = ? AND form_id = ?',
        Bind => [ \$SessionID, \$FormID ],
    );

    my %FormData;

    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # unserialized values can be handled directly
        if ( !$Row[2] ) {
            $FormData{ $Row[0] } = $Row[1];

            next ROW;
        }

        # deserialize the value
        my $Value = eval {
            $StorableObject->Deserialize( Data => decode_base64( $Row[1] ) );
        };

        $EncodeObject->EncodeOutput( \$Value );

        $FormData{ $Row[0] } = $Value;
    }

    $Self->{Cache}{$SessionID}{$FormID} = \%FormData;

    return $FormData{ $Param{Key} } if $Param{Key};
    return \%FormData;
}

=head2 SetFormData()

set data for a specific Form ID provided by the LayoutObject

    $FormCacheObject->SetFormData(
        LayoutObject => $LayoutObject,                          # must include SessionID
        FormID       => 123321,                                 # optional, if not provided, directly, has to be included in the LayoutObject
        Key          => 'DynamicField_Name_PossibleValues',
        Value        => { ... },                                # will delete data if undef or not provided
    );

=cut

sub SetFormData {
    my ( $Self, %Param ) = @_;

    # check required params
    for my $Needed (qw/LayoutObject Key/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $SessionID = $Param{LayoutObject}{SessionID};
    my $FormID    = $Param{FormID} || $Param{LayoutObject}{FormID};

    if ( !$FormID || !$SessionID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need FormID and SessionID in the LayoutObject!",
        );

        return;
    }

    $Self->{Cache}{$SessionID}{$FormID}{ $Param{Key} }       = $Param{Value};
    $Self->{CacheUpdate}{$SessionID}{$FormID}{ $Param{Key} } = 1;

    return 1;
}

=head2 FormIDCreate()

create a new Form ID - usually this will be called by PrepareFormID() rather than directly

    my $FormID = $FormCacheObject->FormIDCreate();

=cut

sub FormIDCreate {

    # return a new form id - this is also used by Web::UploadCache
    return time() . '.' . rand(12341241);
}

=head2 FormIDRemove()

remove all data for a provided Form ID, including the Web::UploadCache

    $FormCacheObject->FormIDRemove(
        FormID       => 123456,         # at least one of the following is required
        SessionID    => 654321,
        LayoutObject => $LayoutObject,
    );

=cut

sub FormIDRemove {
    my ( $Self, %Param ) = @_;

    if ( $Param{LayoutObject} ) {
        $Param{SessionID} = $Param{LayoutObject}{SessionID} || $Param{SessionID};
        $Param{FormID}    = $Param{LayoutObject}{FormID}    || $Param{FormID};
    }

    if ( !$Param{SessionID} && !$Param{FormID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need at least one of form or session id!",
        );

        return;
    }

    my @SQLWhere;
    my @Bind;

    if ( $Param{SessionID} ) {
        push @SQLWhere, 'session_id = ?';
        push @Bind,     \$Param{SessionID};
    }

    if ( $Param{FormID} ) {
        push @SQLWhere, 'form_id = ?';
        push @Bind,     \$Param{FormID};
    }

    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM form_cache WHERE ' . join( ' AND ', @SQLWhere ),
        Bind => \@Bind,
    );

    # clear the upload cache
    return $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDRemove(%Param) && $Success;
}

=head2 CleanUpExpired()
Removed no longer needed temporary files.

Each file older than 1 day will be removed.

    $FormCacheObject->CleanUpExpired();

=cut

sub CleanUpExpired {
    my ( $Self, %Param ) = @_;

    my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime');
    $CurrentTime->Subtract( Days => 1 );

    my $Yesterday = $CurrentTime->ToString();

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM form_cache WHERE create_time < ?',
        Bind => [ \$Yesterday ],
    );

    return 1;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    return 1 if !$Self->{CacheUpdate};

    # get objects
    my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    SESSIONID:
    for my $SessionID ( keys $Self->{CacheUpdate}->%* ) {
        next SESSIONID if !IsHashRefWithData( $Self->{CacheUpdate}{$SessionID} );

        FORMID:
        for my $FormID ( keys $Self->{CacheUpdate}{$SessionID}->%* ) {
            next FORMID if !IsHashRefWithData( $Self->{CacheUpdate}{$SessionID}{$FormID} );

            # extract session data to update
            my $Data = $Self->{Cache}{$SessionID}{$FormID};

            my @KeysToDelete;
            my %DataToStore;

            KEY:
            for my $Key ( $Self->{CacheUpdate}{$SessionID}{$FormID}->%* ) {
                push @KeysToDelete, $Key;

                # undefined values will just be deleted
                next KEY if !defined $Data->{$Key};

                my $Serialized = 0;
                my $Value      = $Data->{$Key};
                if ( ref $Value ) {
                    $Value = encode_base64(
                        $StorableObject->Serialize( Data => $Value )
                    );
                    $Serialized = 1;
                }

                push $DataToStore{Keys}->@*,       $Key;
                push $DataToStore{Values}->@*,     $Value;
                push $DataToStore{Serialized}->@*, $Serialized;
            }

            # delete all changed keys
            $DBObject->DoArray(
                SQL  => 'DELETE FROM form_cache WHERE session_id = ? AND form_id = ? AND cache_key = ?',
                Bind => [ $SessionID, $FormID, \@KeysToDelete ],
            );

            # store all new data
            $DBObject->DoArray(
                SQL  => 'INSERT INTO form_cache (session_id, form_id, cache_key, cache_value, serialized, create_time) VALUES (?, ?, ?, ?, ?, current_timestamp)',
                Bind => [ $SessionID, $FormID, $DataToStore{Keys}, $DataToStore{Values}, $DataToStore{Serialized} ],
            );
        }
    }

    return 1;
}

1;
