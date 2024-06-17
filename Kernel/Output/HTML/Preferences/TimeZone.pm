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

package Kernel::Output::HTML::Preferences::TimeZone;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw( UserID UserObject ConfigItem )) {
        die "Got no $Needed!" if !$Self->{$Needed};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my $PreferencesKey   = $Self->{ConfigItem}->{PrefKey};
    my $TimeZones        = Kernel::System::DateTime->TimeZoneList();
    my %TimeZones        = map { $_ => $_ } sort @{$TimeZones};
    my $SelectedTimeZone = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $PreferencesKey );

    # Use stored time zone only if it's valid. It can happen that user preferences store an old-style offset which is
    #   not valid anymore. Please see bug#13374 for more information.
    if (
        $Param{UserData}->{$PreferencesKey}
        && Kernel::System::DateTime->IsTimeZoneValid( TimeZone => $Param{UserData}->{$PreferencesKey} )
        )
    {
        $SelectedTimeZone = $Param{UserData}->{$PreferencesKey};
    }

    $SelectedTimeZone ||= Kernel::System::DateTime->UserDefaultTimeZoneGet();

    my @Params = ();
    push(
        @Params,
        {
            %Param,
            Name       => $PreferencesKey,
            Data       => \%TimeZones,
            Block      => 'Option',
            SelectedID => $SelectedTimeZone,
        },
    );

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        for my $Value ( @{ $Param{GetParam}->{$Key} } ) {

            # pref update db
            if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $Value,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $Value,
                );
            }
        }
    }

    $Self->{Message} = Translatable('Time zone updated successfully!');
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
