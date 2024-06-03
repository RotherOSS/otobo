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

package Kernel::System::Web::InterfaceMigrateFromOTRS;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::Web::InterfaceMigrateFromOTRS - the migration web interface

=head1 DESCRIPTION

This module generates the content for F<migration.pl>.

=head1 PUBLIC INTERFACE

=head2 new()

create the web interface object for 'migration.pl'.

    use Kernel::System::Web::InterfaceMigrateFromOTRS;

    my $Interface = Kernel::System::Web::InterfaceMigrateFromOTRS->new();

    # with debugging enabled
    my $Interface = Kernel::System::Web::InterfaceMigrateFromOTRS->new(
        Debug => 1
    );

=cut

sub new {
    my ( $Class, %Param ) = @_;

    # start with an empty hash for the new object
    my $Self = bless {}, $Class;

    # set debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # register object params
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => $Kernel::OM->Get('Kernel::Config')->Get('CGILogPrefix') || 'MigrateFromOTRS',
        },
        'Kernel::System::Web::Request' => {
            WebRequest => $Param{WebRequest} || 0,
        },
    );

    # debug info
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => 'Global handle started...',
        );
    }

    return $Self;
}

=head2 Run()

execute the object.

    $Interface->Run();

=cut

sub Run {
    my $Self = shift;

    # get common framework params
    my %Param;
    {
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        $Param{Action}     = $ParamObject->GetParam( Param => 'Action' )     || 'MigrateFromOTRS';
        $Param{Subaction}  = $ParamObject->GetParam( Param => 'Subaction' )  || '';
        $Param{NextScreen} = $ParamObject->GetParam( Param => 'NextScreen' ) || '';
    }

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
        },
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check secure mode
    if ( $Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        print
            $LayoutObject->Header(),
            $LayoutObject->Error(
                Message => Translatable('SecureMode active!'),
                Comment => Translatable(
                    'If you want to re-run migration.pl, then disable the SecureMode in the SysConfig.'
                ),
            ),
            $LayoutObject->Footer();

        return;
    }

    # run modules if a version value exists
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {

        # create $GenericObject
        my $GenericObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
            %Param,
            Debug => $Self->{Debug},
        );

        # output filters are not applied for this interface
        print $GenericObject->Run();

        return;
    }

    # print an error screen as the fallback
    print join '',
        $LayoutObject->Header(),
        $LayoutObject->Error(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Action "%s" not found!', $Param{Action} ),
            Comment => Translatable('Please contact the administrator.'),
        ),
        $LayoutObject->Footer();

    return;
}

1;
