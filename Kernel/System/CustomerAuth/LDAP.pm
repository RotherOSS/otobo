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

package Kernel::System::CustomerAuth::LDAP;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;

use Net::LDAP;
use Net::LDAP::Util qw(escape_filter_value);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);
our @SoftObjectDependencies = (
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get ldap preferences
    $Self->{Die} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::Die' . $Param{Count} );
    if ( $ConfigObject->Get( 'Customer::AuthModule::LDAP::Host' . $Param{Count} ) ) {
        $Self->{Host} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::Host' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Customer::AuthModule::LDAPHost$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if (
        defined(
            $ConfigObject->Get( 'Customer::AuthModule::LDAP::BaseDN' . $Param{Count} )
        )
        )
    {
        $Self->{BaseDN} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::BaseDN' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Customer::AuthModule::LDAPBaseDN$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( $ConfigObject->Get( 'Customer::AuthModule::LDAP::UID' . $Param{Count} ) ) {
        $Self->{UID} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::UID' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need 'Customer::AuthModule::LDAP::UID$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    $Self->{SearchUserDN} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::SearchUserDN' . $Param{Count} ) || '';
    $Self->{SearchUserPw} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::SearchUserPw' . $Param{Count} ) || '';
    $Self->{GroupDN}      = $ConfigObject->Get( 'Customer::AuthModule::LDAP::GroupDN' . $Param{Count} )      || '';
    $Self->{AccessAttr}   = $ConfigObject->Get( 'Customer::AuthModule::LDAP::AccessAttr' . $Param{Count} )   || '';
    $Self->{UserAttr}     = $ConfigObject->Get( 'Customer::AuthModule::LDAP::UserAttr' . $Param{Count} )     || 'DN';
    $Self->{UserSuffix}   = $ConfigObject->Get( 'Customer::AuthModule::LDAP::UserSuffix' . $Param{Count} )   || '';

    # ldap filter always used
    $Self->{AlwaysFilter} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::AlwaysFilter' . $Param{Count} ) || '';

    # Net::LDAP new params
    if ( $ConfigObject->Get( 'Customer::AuthModule::LDAP::Params' . $Param{Count} ) ) {
        $Self->{Params} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::Params' . $Param{Count} );
    }
    else {
        $Self->{Params} = {};
    }

    $Self->{StartTLS} = $ConfigObject->Get( 'Customer::AuthModule::LDAP::StartTLS' . $Param{Count} ) || '';

    return $Self;
}

sub GetOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need What!"
        );
        return;
    }

    # module options
    my %Option = (
        PreAuth => 0,
    );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(User Pw)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    $Param{User} = $Self->_ConvertTo( $Param{User}, 'utf-8' );
    $Param{Pw}   = $Self->_ConvertTo( $Param{Pw},   'utf-8' );

    # get params
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $RemoteAddr  = $ParamObject->RemoteAddr() || 'Got no REMOTE_ADDR env!';

    # remove leading and trailing spaces
    $Param{User} =~ s/^\s+//;
    $Param{User} =~ s/\s+$//;

    # add user suffix
    if ( $Self->{UserSuffix} ) {
        $Param{User} .= $Self->{UserSuffix};

        # just in case for debug
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "CustomerUser: ($Param{User}) added $Self->{UserSuffix} to username!",
            );
        }
    }

    # just in case for debug!
    if ( $Self->{Debug} > 0 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$Param{User}' tried to authenticate with Pw: '$Param{Pw}' "
                . "(REMOTE_ADDR: $RemoteAddr)",
        );
    }

    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    my $LDAP = Net::LDAP->new( $Self->{Host}, %{ $Self->{Params} } );
    if ( !$LDAP ) {
        if ( $Self->{Die} ) {
            die "Can't connect to $Self->{Host}: $@";
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't connect to $Self->{Host}: $@",
        );
        return;
    }
    if ( $Self->{StartTLS} ) {
        my $Started = $LDAP->start_tls( verify => $Self->{StartTLS} );
        if ( !$Started ) {
            if ( $Self->{Die} ) {
                die "start_tls on $Self->{Host} failed: $@";
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "start_tls: '$Self->{StartTLS}' on $Self->{Host} failed: $@",
                );
                $LDAP->disconnect();
                return;
            }
        }
    }
    my $Result = '';
    if ( $Self->{SearchUserDN} && $Self->{SearchUserPw} ) {
        $Result = $LDAP->bind(
            dn       => $Self->{SearchUserDN},
            password => $Self->{SearchUserPw}
        );
    }
    else {
        $Result = $LDAP->bind();
    }
    if ( $Result->code() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'First bind failed! ' . $Result->error(),
        );
        return;
    }

    # build filter
    my $Filter = "($Self->{UID}=" . escape_filter_value( $Param{User} ) . ')';

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # perform user search
    $Result = $LDAP->search(
        base   => $Self->{BaseDN},
        filter => $Filter,
        attrs  => ['1.1'],
    );
    if ( $Result->code() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Search failed! ' . $Result->error(),
        );
        $LDAP->disconnect();
        return;
    }

    # get whole user dn
    my $UserDN = '';
    for my $Entry ( $Result->all_entries() ) {
        $UserDN = $Entry->dn();
    }

    # log if there is no LDAP user entry
    if ( !$UserDN ) {

        # failed login note
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $Param{User} authentication failed, no LDAP entry found!"
                . "BaseDN='$Self->{BaseDN}', Filter='$Filter', (REMOTE_ADDR: $RemoteAddr).",
        );

        # take down session
        $LDAP->unbind();
        $LDAP->disconnect();
        return;
    }

    # check if user need to be in a group!
    if ( $Self->{AccessAttr} && $Self->{GroupDN} ) {

        # just in case for debug
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => 'check for groupdn!',
            );
        }

        # search if we're allowed to
        my $Filter2 = '';
        if ( $Self->{UserAttr} eq 'DN' ) {
            $Filter2 = "($Self->{AccessAttr}=" . escape_filter_value($UserDN) . ')';
        }
        else {
            $Filter2 = "($Self->{AccessAttr}=" . escape_filter_value( $Param{User} ) . ')';
        }
        my $Result2 = $LDAP->search(
            base   => $Self->{GroupDN},
            filter => $Filter2,
            attrs  => ['1.1'],
        );
        if ( $Result2->code() ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Search failed! base='$Self->{GroupDN}', filter='$Filter2', "
                    . $Result2->error(),
            );
            $LDAP->unbind();
            $LDAP->disconnect();
            return;
        }

        # extract it
        my $GroupDN = '';
        for my $Entry ( $Result2->all_entries() ) {
            $GroupDN = $Entry->dn();
        }

        # log if there is no LDAP entry
        if ( !$GroupDN ) {

            # failed login note
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  =>
                    "CustomerUser: $Param{User} authentication failed, no LDAP group entry found"
                    . "GroupDN='$Self->{GroupDN}', Filter='$Filter2'! (REMOTE_ADDR: $RemoteAddr).",
            );

            # take down session
            $LDAP->unbind();
            $LDAP->disconnect();
            return;
        }
    }

    # bind with user data -> real user auth.
    $Result = $LDAP->bind(
        dn       => $UserDN,
        password => $Param{Pw}
    );
    if ( $Result->code() ) {

        # failed login note
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $Param{User} ($UserDN) authentication failed: '"
                . $Result->error() . "' (REMOTE_ADDR: $RemoteAddr).",
        );

        # take down session
        $LDAP->unbind();
        $LDAP->disconnect();
        return;
    }

    # login note
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  =>
            "CustomerUser: $Param{User} ($UserDN) authentication ok (REMOTE_ADDR: $RemoteAddr).",
    );

    # take down session
    $LDAP->unbind();
    $LDAP->disconnect();
    return $Param{User};
}

# TODO: this could be simplified because $Charset is always utf-8
sub _ConvertTo {
    my ( $Self, $Text, $Charset ) = @_;

    return if !defined $Text;

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    if ( !$Charset ) {
        $EncodeObject->EncodeInput( \$Text );

        return $Text;
    }

    # convert from input charset ($Charset) to directory charset (utf-8)
    return $EncodeObject->Convert(
        Text => $Text,
        From => $Charset,
        To   => 'utf-8',
    );
}

1;
