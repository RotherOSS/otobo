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

package scripts::DBUpdateTo11_1::EleasticsearchBindArticleEditEvent;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Package',
    'Kernel::System::GenericInterface::Webservice',
);

=head1 NAME

scripts::DBUpdateTo11_1::EleasticsearchBindArticleEditEvent - Bind the ArticleEdit event for TicketManagement Invoker

=cut

use parent qw(scripts::DBUpdateTo11_1::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $Webservice       = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    if ( !$Webservice ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Did not find the Elasticsearch webservice!",
        );
        return 1;
    }

    my $Events = $Webservice->{Config}->{Requester}->{Invoker}->{TicketManagement}->{Events};

    my $HasArticleEdit = 0;

    EVENT:
    for my $Event ( $Events->@* ) {

        if ( $Event->{Event} eq 'ArticleEdit' ) {
            $HasArticleEdit = 1;
            last EVENT;
        }
    }

    if ( !$HasArticleEdit ) {

        push $Events->@*, {
            Event        => 'ArticleEdit',
            Asynchronous => 0,
        };

        my $Success = $WebserviceObject->WebserviceUpdate(
            %{$Webservice},
            UserID => 1,
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not update the Elasticsearch webservice!",
            );
            return 1;
        }
    }

    return 1;
}

1;
