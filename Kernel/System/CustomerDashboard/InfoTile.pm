# # --
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

package Kernel::System::CustomerDashboard::InfoTile;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::Cache',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::XML',
);

=for stopwords infotile

=head1 NAME

Kernel::System::CustomerDashboard::InfoTile - infotile lib

=head1 DESCRIPTION

All infotile functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $InfoTileObject = $Kernel::OM->Get('Kernel::System::Stats');

=cut

sub new {

    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;

}

=head2 InfoTileAdd()

add a new infotile entry

    my $ID = $InfoTileObject->InfoTileAdd(
        UserID         => $UserID,
        StartDate      => $StartDate,
        StopDate       => $StopDate,
        Name           => $Name,
        Content        => $Content,
        MarqueeContent => $MarqueeContent,
        Groups         => $Groups (optional when user is admin)
    );

=cut

sub InfoTileAdd {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID Name)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    # get needed objects
    my $XMLObject      = $Kernel::OM->Get('Kernel::System::XML');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # get new ID
    my $ID   = 1;
    my @Keys = $XMLObject->XMLHashSearch(
        Type => 'InfoTiles',
    );
    if (@Keys) {
        my @SortKeys = sort { $a <=> $b } @Keys;
        $ID = $SortKeys[-1] + 1;
    }

    # requesting current time stamp
    my $TimeStamp = $DateTimeObject->ToString();

    my $StartDateString = '';
    if ( $Param{StartDateUsed} ) {
        my $StartDate = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $Param{StartDate},
            }
        );
        $StartDateString = $StartDate->ToString();
    }

    my $StopDateString = '';
    if ( $Param{StopDateUsed} ) {
        my $StopDate = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $Param{StopDate},
            }
        );
        $StopDateString = $StopDate->ToString();
    }

    my %MetaData = (
        ID => [
            { Content => $ID },
        ],
        Name => [
            { Content => $Param{Name} },
        ],
        Content => [
            { Content => $Param{Content} },
        ],
        MarqueeContent => [
            { Content => $Param{MarqueeContent} },
        ],
        StartDate => [
            { Content => $StartDateString },
        ],
        StartDateUsed => [
            { Content => $Param{StartDateUsed} },
        ],
        StopDate => [
            { Content => $StopDateString },
        ],
        StopDateUsed => [
            { Content => $Param{StopDateUsed} }
        ],
        Groups => [
            { Content => $Param{Groups} }
        ],
        Created => [
            { Content => $TimeStamp },
        ],
        CreatedBy => [
            { Content => $Param{UserID} },
        ],
        Changed => [
            { Content => $TimeStamp },
        ],
        ChangedBy => [
            { Content => $Param{UserID} },
        ],
        ValidID => [
            { Content => $Param{ValidID} },
        ],
    );

    # compose new info tile entry
    my @XMLHash = (
        { otobo_infotile => [ \%MetaData ] },
    );
    my $Success = $XMLObject->XMLHashAdd(
        Type    => 'InfoTiles',
        Key     => $ID,
        XMLHash => \@XMLHash,
    );
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Can not add a new info tile entry!',
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'InfoTiles'
    );

    return $ID;

}

=head2 InfoTileGet()

get a hash ref of the info tile entries you need

    my $HashRef = $InfoTileObject->InfoTileGet(
        ID  => '123',
    );

=cut

sub InfoTileGet {
    my ( $Self, %Param ) = @_;

    # check necessary data
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!'
        );
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = "InfoTileGet::ID::$Param{ID}";

    my $Cache = $CacheObject->Get(
        Type          => 'InfoTiles',
        Key           => $CacheKey,
        CacheInMemory => 0,
    );

    return $Cache if ref $Cache eq 'HASH';

    # get hash from storage
    my @XMLHash = $Kernel::OM->Get('Kernel::System::XML')->XMLHashGet(
        Type => 'InfoTiles',
        Key  => $Param{ID},
    );

    if ( !$XMLHash[0] ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't get ID $Param{ID}!",
        );
        return;
    }

    my %InfoTile;
    my $InfoTileXML = $XMLHash[0]->{otobo_infotile}->[1];

    # process all strings
    $InfoTile{ID} = $Param{ID};
    for my $Key (
        qw(ID Name Content MarqueeContent StartDate StartDateUsed StopDate StopDateUsed Created CreatedBy Changed ChangedBy ValidID Groups
        )
        )
    {
        if ( defined $InfoTileXML->{$Key}->[1]->{Content} ) {
            $InfoTile{$Key} = $InfoTileXML->{$Key}->[1]->{Content};
        }
    }

    # time zone
    if ( defined $InfoTileXML->{TimeZone}->[1]->{Content} ) {

        # Check if stored time zone is valid. It can happen stored time zone is still an old-style offset. Otherwise,
        # fall back to the system time zone. Please see bug#13373 for more information.
        if ( Kernel::System::DateTime->IsTimeZoneValid( TimeZone => $InfoTileXML->{TimeZone}->[1]->{Content} ) ) {
            $InfoTile{TimeZone} = $InfoTileXML->{TimeZone}->[1]->{Content};
        }
        else {
            $InfoTile{TimeZone} = Kernel::System::DateTime->OTOBOTimeZoneGet();
        }
    }

    $CacheObject->Set(
        Type          => 'InfoTile',
        Key           => $CacheKey,
        Value         => \%InfoTile,
        TTL           => 24 * 60 * 60,
        CacheInMemory => 0,
    );

    return \%InfoTile;
}

=head2 InfoTileListGet()

get a list of info tile entries by user id

    my $InfoTileList = $InfoTileObject->InfoTileListGet(
       UserID => $UserID
    );

=cut

sub InfoTileListGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    my @SearchResult;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = "InfoTileListGet::XMLSearch";

    my $Cache = $CacheObject->Get(
        Type          => 'InfoTiles',
        Key           => $CacheKey,
        CacheInMemory => 0,
    );

    # Do we have a cache available?
    if ( ref $Cache eq 'ARRAY' ) {
        @SearchResult = @{$Cache};
    }
    else {

        # get xml object
        my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

        # No cache. Is there info tile data yet?
        @SearchResult = $XMLObject->XMLHashSearch( Type => 'InfoTiles' );

    }

    # fetch items
    my %Result;
    for my $ID (@SearchResult) {

        my $InfoTile = $Self->InfoTileGet(
            ID => $ID
        );

        $Result{$ID} = $InfoTile;
    }

    return \%Result;

}

=head2 InfoTileUpdate()

update an existing infotile entry

    my $ID = $InfoTileObject->InfoTileUpdate(
        UserID => $UserID,
        ID => $ID,
        StartDate => $StartDate,
        StopDate => $StopDate,
        Name => $Name,
        Content => $Content,
        MarqueeContent => $MarqueeContent,
        Groups => $Groups (optional when user is admin)
    );

=cut

sub InfoTileUpdate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID ID Name)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    if ( !$Param{Groups} && $Param{LightAdmin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Groups.",
        );
        return;
    }

    # date start shouldn't be higher than stop date
    return if ( $Param{StartDateUsed} && $Param{StopDateUsed} && $Param{StartDate} > $Param{StopDate} );

    # check necessary data
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!'
        );
    }

    # get needed objects
    my $XMLObject      = $Kernel::OM->Get('Kernel::System::XML');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # requesting current time stamp
    my $TimeStamp = $DateTimeObject->ToString();

    my $StartDateString = '';
    if ( $Param{StartDateUsed} ) {
        my $StartDate = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $Param{StartDate},
            }
        );
        $StartDateString = $StartDate->ToString();
    }

    my $StopDateString = '';
    if ( $Param{StopDateUsed} ) {
        my $StopDate = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $Param{StopDate},
            }
        );
        $StopDateString = $StopDate->ToString();
    }

    my %MetaData = (
        Name => [
            { Content => $Param{Name} },
        ],
        Content => [
            { Content => $Param{Content} },
        ],
        MarqueeContent => [
            { Content => $Param{MarqueeContent} },
        ],
        StartDate => [
            { Content => $StartDateString },
        ],
        StartDateUsed => [
            { Content => $Param{StartDateUsed} }
        ],
        StopDate => [
            { Content => $StopDateString },
        ],
        StopDateUsed => [
            { Content => $Param{StopDateUsed} }
        ],
        Groups => [
            { Content => $Param{Groups} }
        ],
        Changed => [
            { Content => $TimeStamp },
        ],
        ChangedBy => [
            { Content => $Param{UserID} },
        ],
        ValidID => [
            { Content => $Param{ValidID} },
        ],
    );

    # compose new info tile entry
    my @XMLHash = (
        { otobo_infotile => [ \%MetaData ] },
    );

    my $Success = $XMLObject->XMLHashUpdate(
        Type    => 'InfoTiles',
        Key     => $Param{ID},
        XMLHash => \@XMLHash,
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Can not update info tile entry!',
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'InfoTiles'
    );

    return $Param{ID};

}

=head2 InfoTileDelete()

remove an infotile entry

    my $Deleted = $InfoTileObject->InfoTileDelete(
        ID => $ID,
        UserID => $UserID
    );

=cut

sub InfoTileDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key",
            );
            return;
        }
    }

    my $Permission = $Self->InfoTilePermission(
        ID     => $Param{ID},
        UserID => $Param{UserID},
        Type   => 'rw',
    );
    my $Success = 0;

    # get needed objects
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    if ($Permission) {
        $Success = $XMLObject->XMLHashDelete(
            Type => 'InfoTiles',
            Key  => $Param{ID},
        );
    }

    if ( !$Permission || !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Can not delete info tile entry!',
        );
        return;
    }

    return 1;

}

=head2 InfoTilePermission()

return boolean permission of user for info tile entry

    my $Permission = $InfoTileObject->InfoTilePermission(
        ID => $ID,
        UserID => $UserID,
        Type => $Type
    );

=cut

sub InfoTilePermission {

    my ( $Self, %Param ) = @_;

    # check for needed stuff
    for my $Needed (qw(Type ID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
            return;
        }
    }

    # get needed objects
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    my %GroupList = $GroupObject->PermissionUserGet(
        UserID => $Param{UserID},
        Type   => $Param{Type},
    );

    my $InfoTile = $Self->InfoTileGet(
        ID => $Param{ID},
    );

    for my $GroupName ( values %GroupList ) {
        if ( $GroupName eq 'admin' ) {
            return 1;
        }
    }

    if ( !$InfoTile->{Groups} ) {
        return 0;
    }

    my @InfoTileGroups = split /,/, $InfoTile->{Groups};

    for my $GroupID (@InfoTileGroups) {
        if ( !$GroupList{$GroupID} ) {
            return 0;
        }
    }

    return 1;

}

1;
