# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::SupportDataCollector::Plugin::OS::PerlModules;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $Output;
    open( my $FH, '-|', "perl $Home/bin/otobo.CheckModules.pl nocolors --all" );    ## no critic qw(OTOBO::ProhibitOpen)

    while ( my $Line = <$FH> ) {
        $Output .= $Line;
    }
    close($FH);

    if (
        $Output =~ m{Not \s installed! \s \(required}ismx
        || $Output =~ m{failed!}ismx
        )
    {
        $Self->AddResultProblem(
            Label   => Translatable('Perl Modules'),
            Value   => $Output,
            Message => Translatable('Not all required Perl modules are correctly installed.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Perl Modules'),
            Value => $Output,
        );
    }

    return $Self->GetResults();
}

1;
