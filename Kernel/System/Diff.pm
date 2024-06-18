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

package Kernel::System::Diff;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Text::Diff                qw(diff);
use Text::Diff::FormattedHTML qw(diff_strings);

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Diff - Compare two strings and display difference

=head1 DESCRIPTION

Compare two strings and display difference.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $DiffObject = $Kernel::OM->Get('Kernel::System::Diff');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 Compare()

Compare two strings and return the difference.

    $DiffObject->Compare(
        Source => 'String 1',       # (required) String
        Target => 'String 2',       # (required) String
    );

    Result:
    my %Diff = (
        HTML  => '<table class="DataTable diff">
<tr class=\'change\'><td><em>1</em></td><td><em>1</em></td><td>String <del>1</del></td><td>String <ins>2</ins></td></tr>
</table>
',
        Plain => '<div class="file"><span class="fileheader"></span><div class="hunk"><span class="hunkheader">@@ -1 +1 @@
        Plain => <<'END_TXT',
@@ -1 +1 @@
-String 1
\ No newline at end of file
+String 2
\ No newline at end of file
END_TXT
        },
    );

=cut

sub Compare {
    my ( $Self, %Param ) = @_;

    $Kernel::OM = $Kernel::OM;    # avoid 'once' warning
    for my $Needed (qw(Source Target)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my %Result;

    # Get HTML diff.
    $Result{HTML} = diff_strings( { vertical => 0 }, $Param{Source}, $Param{Target} );

    # Find the table class(es) and add the OTOBO DataTable class.
    $Result{HTML} =~ s{class='diff'}{class="DataTable diff"}xmsg;

    # Add <span>'s to <td>'s.
    $Result{HTML} =~ s{<td>(\d+)<\/td>}{<td><em>$1</em></td>}xmsg;
    $Result{HTML} =~ s{<td>(.[^<]*)<\/td>}{<td><span>$1</span></td>}xmsg;

    # Get plain diff.
    $Result{Plain} = diff( \$Param{Source}, \$Param{Target} );

    return %Result;
}

1;
