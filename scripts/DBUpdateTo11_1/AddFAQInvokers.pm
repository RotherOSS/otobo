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

package scripts::DBUpdateTo11_1::AddFAQInvokers;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_1::AddFAQInvokers - Add FAQ invokers to the Elasticsearch webservice

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $Webservice       = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    if ( !$Webservice ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Did not find the Elasticsearch webservice!",
        );
        return;
    }

    $Webservice->{Config}->{Requester}->{Invoker}->{FAQIngestAttachment} = {
        Description => '',
        Type        => 'Elasticsearch::FAQManagement',
    };
    $Webservice->{Config}->{Requester}->{Invoker}->{FAQManagement} = {
        Description => '',
        Type        => 'Elasticsearch::FAQManagement',
        Events      => [
            {
                Event        => 'FAQCreate',
                Asynchronous => '0'
            },
            {
                Asynchronous => '0',
                Event        => 'FAQDelete'
            },
            {
                Event        => 'FAQUpdate',
                Asynchronous => '0'
            },
            {
                Event        => 'FAQAttachmentAddPost',
                Asynchronous => '0'
            },
            {
                Asynchronous => '0',
                Event        => 'FAQAttachmentDeletePost'
            }
        ],
    };
    $Webservice->{Config}->{Requester}->{Transport}->{Config}->{InvokerControllerMapping}->{FAQIngestAttachment} = {
        Command    => 'POST',
        Controller => '/tmpattachments/:docapi/:id?pipeline=:path',
    };
    $Webservice->{Config}->{Requester}->{Transport}->{Config}->{InvokerControllerMapping}->{FAQManagement} = {
        Command    => 'POST',
        Controller => '/faq/:docapi/:id',
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
        return;
    }

    return 1;
}

1;
