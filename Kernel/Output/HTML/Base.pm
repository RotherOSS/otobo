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

package Kernel::Output::HTML::Base;

use strict;
use warnings;

use utf8;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

=head1 NAME

Kernel::Output::HTML::Base - Base class for Output classes

=head1 DESCRIPTION

    package Kernel::Output::HTML::ToolBar::MyToolBar;
    use parent 'Kernel::Output::HTML::Base';

    # methods go here

=head1 PUBLIC INTERFACE

=head2 new()

Creates an object. Call it not on this class, but on a subclass.

    use Kernel::Output::HTML::ToolBar::MyToolBar;
    my $Object = Kernel::Output::HTML::ToolBar::MyToolBar->new(
        UserID  => 123,
    );

=cut

1;
