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

package Kernel::System::PostMaster::LoopProtectionCommon;
## nofilter(TidyAll::Plugin::OTOBO::Perl::Time)

use strict;
use warnings;
use utf8;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config options
    $Self->{PostmasterMaxEmails} = $Kernel::OM->Get('Kernel::Config')->Get('PostmasterMaxEmails') || 40;
    $Self->{PostmasterMaxEmailsPerAddress} =
        $Kernel::OM->Get('Kernel::Config')->Get('PostmasterMaxEmailsPerAddress') || {};

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $Self->{LoopProtectionDate} = $DateTimeObject->Format( Format => '%Y-%m-%d' );

    return $Self;
}

1;
