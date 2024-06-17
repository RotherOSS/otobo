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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::DefaultUser;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Auth',
    'Kernel::System::Group',
    'Kernel::System::User',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    # get needed objects
    my $UserObject  = $Kernel::OM->Get('Kernel::System::User');
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    my %UserList = $UserObject->UserList(
        Type  => 'Short',
        Valid => '1',
    );

    my $DefaultPassword;

    my $SuperUserID;
    USER:
    for my $UserID ( sort keys %UserList ) {
        if ( $UserList{$UserID} eq 'root@localhost' ) {
            $SuperUserID = 1;
            last USER;
        }
    }

    if ($SuperUserID) {

        $DefaultPassword = $Kernel::OM->Get('Kernel::System::Auth')->Auth(
            User => 'root@localhost',
            Pw   => 'root',
        );
    }

    if ($DefaultPassword) {
        $Self->AddResultProblem(
            Label   => Translatable('Default Admin Password'),
            Value   => '',
            Message =>
                Translatable(
                    'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.'
                ),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Default Admin Password'),
            Value => '',
        );
    }

    return $Self->GetResults();
}

1;
