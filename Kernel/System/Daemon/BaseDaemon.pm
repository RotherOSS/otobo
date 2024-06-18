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

package Kernel::System::Daemon::BaseDaemon;

use strict;
use warnings;

=head1 NAME

Kernel::System::Daemon::BaseDaemon - daemon base class

=head1 DESCRIPTION

Base class for daemon modules.

=head1 PUBLIC INTERFACE

=head2 PreRun()

Perform additional validations/preparations and wait times before Run().

Override this method in your daemons.

If this method returns true, execution will be continued. If it returns false,
the main daemon aborts at this point, and Run() will not be called and the complete
daemon module dies waiting to be recreated again in the next loop.

=cut

sub PreRun {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 Run()

Runs the daemon.

Override this method in your daemons.

If this method returns true, execution will be continued. If it returns false, the
main daemon aborts at this point, and PostRun() will not be called and the complete
daemon module dies waiting to be recreated again in the next loop.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 PostRun()

Perform additional clean-ups and wait times after Run().

Override this method in your daemons.

If this method returns true, execution will be continued. If it returns false, the
main daemon aborts at this point, and PreRun() will not be called again and the
complete daemon module dies waiting to be recreated again in the next loop.

=cut

sub PostRun {
    my ( $Self, %Param ) = @_;

    sleep 1;

    return 1;
}

=head2 Summary()

Provides a summary of what is the daemon doing in the current time, the summary is in form of tabular
data and it must contain a header, the definition of the columns, the data, and a message if there
was no data.

    my @Summary = $DaemonObject->Summary();

returns

    @Summary = (
        {
            Header => 'Header Message',
            Column => [
                {
                    Name        => 'somename',
                    DisplayName => 'some name',
                    Size        => 40,
                },
                # ...
            ],
            Data => [
                {
                    somename => $ScalarValue,
                    # ...
                },
                # ...
            ],
            NoDataMessage => "Show this message if there is no data.",
        },
    );

Override this method in your daemons.

=cut

sub Summary {
    my ( $Self, %Param ) = @_;

    return ();
}

1;
