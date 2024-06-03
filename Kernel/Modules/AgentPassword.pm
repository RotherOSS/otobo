# --
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## nofilter(TidyAll::Plugin::OTOBO::Legal::LicenseValidator)

package Kernel::Modules::AgentPassword;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::User',
);

use parent qw(Kernel::Modules::BasePassword);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{UserObject} = $Kernel::OM->Get('Kernel::System::User');

    return $Self;
}

1;
