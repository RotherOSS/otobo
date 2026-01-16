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

package Kernel::System::Auth::LDAP;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules
use Net::LDAP;
use Net::LDAP::Util qw(escape_filter_value);

# OTOBO modules

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
    my $Self = bless {}, $Type;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get ldap preferences
    $Self->{Count} = $Param{Count} || '';
    $Self->{Die}   = $ConfigObject->Get( 'AuthModule::LDAP::Die' . $Param{Count} );
    if ( $ConfigObject->Get( 'AuthModule::LDAP::Host' . $Param{Count} ) ) {
        $Self->{Host} = $ConfigObject->Get( 'AuthModule::LDAP::Host' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need AuthModule::LDAP::Host$Param{Count} in Kernel/Config.pm",
        );

        return;
    }

    # the BaseDN is required
    if ( defined( $ConfigObject->Get( 'AuthModule::LDAP::BaseDN' . $Param{Count} ) ) ) {
        $Self->{BaseDN} = $ConfigObject->Get( 'AuthModule::LDAP::BaseDN' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need AuthModule::LDAP::BaseDN$Param{Count} in Kernel/Config.pm",
        );

        return;
    }

    # the UID, indicating the attribute containing the OTOBO user id, is required
    if ( $ConfigObject->Get( 'AuthModule::LDAP::UID' . $Param{Count} ) ) {
        $Self->{UID} = $ConfigObject->Get( 'AuthModule::LDAP::UID' . $Param{Count} );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need AuthModule::LDAP::UID$Param{Count} in Kernel/Config.pm",
        );

        return;
    }

    # optional settings
    $Self->{SearchUserDN}  = $ConfigObject->Get( 'AuthModule::LDAP::SearchUserDN' . $Param{Count} )  || '';
    $Self->{SearchUserPw}  = $ConfigObject->Get( 'AuthModule::LDAP::SearchUserPw' . $Param{Count} )  || '';
    $Self->{GroupDN}       = $ConfigObject->Get( 'AuthModule::LDAP::GroupDN' . $Param{Count} )       || '';
    $Self->{AccessAttr}    = $ConfigObject->Get( 'AuthModule::LDAP::AccessAttr' . $Param{Count} )    || 'memberUid';
    $Self->{UserAttr}      = $ConfigObject->Get( 'AuthModule::LDAP::UserAttr' . $Param{Count} )      || 'DN';
    $Self->{UserSuffix}    = $ConfigObject->Get( 'AuthModule::LDAP::UserSuffix' . $Param{Count} )    || '';
    $Self->{UserLowerCase} = $ConfigObject->Get( 'AuthModule::LDAP::UserLowerCase' . $Param{Count} ) || 0;
    $Self->{Params}        = $ConfigObject->Get( 'AuthModule::LDAP::Params' . $Param{Count} )        || {};
    $Self->{AlwaysFilter}  = $ConfigObject->Get( 'AuthModule::LDAP::AlwaysFilter' . $Param{Count} )  || '';
    $Self->{StartTLS}      = $ConfigObject->Get( 'AuthModule::LDAP::StartTLS' . $Param{Count} )      || '';

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

    # get the remote address for log messages
    my $RemoteAddr;
    {
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
        $RemoteAddr = $ParamObject->RemoteAddr() || 'Got no REMOTE_ADDR env!';
    }

    # remove leading and trailing spaces
    $Param{User} =~ s/^\s+//;
    $Param{User} =~ s/\s+$//;

    # Convert username to lower case letters.
    # This is often not necessary as the attribute uid is usually already case insensitive.
    if ( $Self->{UserLowerCase} ) {
        $Param{User} = lc $Param{User};
    }

    # Debugging can only be activated in the source code,
    # so that sensitive information is not inadvertently leaked.
    my $Debug = 0;

    # add user suffix
    if ( $Self->{UserSuffix} ) {
        $Param{User} .= $Self->{UserSuffix};

        # just in case for debug
        if ($Debug) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "User: $Param{User} added $Self->{UserSuffix} to username!",
            );
        }
    }

    # just in case for debug!
    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "User: $Param{User} tried to authenticate (REMOTE_ADDR: $RemoteAddr)",
        );
    }

    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    my $LDAP = Net::LDAP->new( $Self->{Host}, %{ $Self->{Params} } );
    if ( !$LDAP ) {
        if ( $Self->{Die} ) {
            die "Can't connect to $Self->{Host}: $@";
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't connect to $Self->{Host}: $@",
            );

            return;
        }
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
        $LDAP->disconnect();
        return;
    }

    # build filter
    my $Filter = "($Self->{UID}=" . escape_filter_value( $Param{User} ) . ')';

    # join an optional filter condition with '&', that is 'logical and'
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # perform user search
    $Result = $LDAP->search(
        base   => $Self->{BaseDN},
        filter => $Filter,
        attrs  => [ $Self->{UID} ],
    );
    if ( $Result->code() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Search failed! ' . $Result->error(),
        );
        $LDAP->unbind();
        $LDAP->disconnect();

        return;
    }

    # get whole user distinctive name,
    # when more than one entry is found then the picked entry is random, as no sort order was specified
    my $UserDN = '';
    my $User   = '';
    for my $Entry ( $Result->all_entries() ) {
        $UserDN = $Entry->dn();
        $User   = $Entry->get_value( $Self->{UID} );
    }

    # log if there is no LDAP user entry
    if ( !$UserDN || !$User ) {

        # failed login note
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "User: $Param{User} authentication failed, no LDAP entry found!"
                . "BaseDN='$Self->{BaseDN}', Filter='$Filter', (REMOTE_ADDR: $RemoteAddr).",
        );

        # take down session
        $LDAP->unbind();
        $LDAP->disconnect();

        return;
    }

    # check if user needs to be in a group!
    if ( $Self->{AccessAttr} && $Self->{GroupDN} ) {

        # just in case for debug
        if ($Debug) {
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

            # take down session
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
                Message  => "User: $Param{User} authentication failed, no LDAP group entry found"
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
            Message  => "User: $Param{User} ($UserDN) authentication failed: '"
                . $Result->error()
                . "' (REMOTE_ADDR: $RemoteAddr).",
        );

        # take down session
        $LDAP->unbind();
        $LDAP->disconnect();

        return;
    }

    # maybe check if pw is expired
    # if () {
    #     $Kernel::OM->Get('Kernel::System::Log')->Log(
    #         Priority => 'info',
    #         Message  => "Password is expired!",
    #     );
    #     return;
    # }

    # login note
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => "User: $Param{User} ($UserDN) authentication ok (REMOTE_ADDR: $RemoteAddr).",
    );

    # take down session
    $LDAP->unbind();
    $LDAP->disconnect();

    return $User;
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
