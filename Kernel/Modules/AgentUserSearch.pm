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

package Kernel::Modules::AgentUserSearch;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {%Param}, $Type;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config for frontend
    $Self->{Config} = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    my $JSON;

    # search users
    if ( !$Self->{Subaction} ) {

        # get needed params
        my $Search     = $ParamObject->GetParam( Param => 'Term' )   || '';
        my $Groups     = $ParamObject->GetParam( Param => 'Groups' ) || '';
        my $MaxResults = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 20 );

        # get all members of the groups
        my %GroupUsers;
        if ($Groups) {
            my @GroupNames = split /,\s+/, $Groups;

            GROUPNAME:
            for my $GroupName (@GroupNames) {

                # allow trailing comma
                next GROUPNAME if !$GroupName;

                # get group object
                my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

                my $GroupID = $GroupObject->GroupLookup(
                    Group => $GroupName,
                );

                next GROUPNAME if !$GroupID;

                # get users in group
                my %Users = $GroupObject->PermissionGroupGet(
                    GroupID => $GroupID,
                    Type    => 'ro',
                );

                my @UserIDs = keys %Users;
                @GroupUsers{@UserIDs} = @UserIDs;
            }
        }

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get user list
        my %UserList = $UserObject->UserSearch(
            Search => $Search,
            Valid  => 1,
        );

        my $MaxResultCount = $MaxResults;

        # the data that will be sent as response
        my @Data;

        USERID:
        for my $UserID ( sort { $UserList{$a} cmp $UserList{$b} } keys %UserList ) {

            # if groups are required and user is not member of one of the groups
            # then skip the user
            if ( $Groups && !$GroupUsers{$UserID} ) {
                next USERID;
            }

            # The values in %UserList are in the form: 'mm Max Mustermann'.
            # So assemble a neater string for display.
            # (Actually UserSearch() contains code for formating, but that is usually not called.)
            my %User = $UserObject->GetUserData(
                UserID => $UserID,
                Valid  => $Param{Valid},
            );

            my $UserValue = sprintf '"%s" <%s>',
                $User{UserFullname},
                $User{UserEmail};

            push @Data, {
                UserKey   => $UserID,
                UserValue => $UserValue,
            };

            $MaxResultCount--;
            last USERID if $MaxResultCount <= 0;
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => \@Data,
        );
    }

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json',
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;
