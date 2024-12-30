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

package Kernel::System::UnitTest::Formatter;

use strict;
use warnings;
use v5.24;
use utf8;

# core modules
use File::Path qw(remove_tree);

# Otobo modules
use Kernel::System::UnitTest::Formatter::Session;

use parent 'TAP::Formatter::Console';

our $ObjectManagerDisabled = 1;

# this is a custom Otobo TAP Formatter to present the Otobo TAP unittest results
# in not-so-standard junit rpsec.xml file format.
#
# see: https://metacpan.org/pod/TAP::Formatter::JUnit
#      as an example for TAP formatters
# see: https://gitlab.com/gitlab-org/gitlab/-/issues/299086
#      discussion about actual xml format used by GitLab
# see: https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/parsers/test/junit.rb
#      how GitLab actually parses the junit.xml files
#

sub new {

    my ( $Type, $Params ) = @_;

    # allocate new hash for object
    my $Self = bless {
        Dom        => XML::LibXML::Document->new( '1.0', 'UTF-8' ),
        TestSuites => [],
        $Params->%*
    }, $Type;

    return $Self;
}

# virtual method called from prove for each *.t file that is run.
sub open_test {
    my ( $Self, $Test, $Parser ) = @_;
    my $Session = Kernel::System::UnitTest::Formatter::Session->new(
        Name          => $Test,
        Formatter     => $Self,
        Parser        => $Parser,
        PassingToDoOk => $ENV{ALLOW_PASSING_TODOS} ? 1 : 0,
        Dom           => $Self->{Dom},
        TestSuites    => [],
    );
    return $Session;
}

# virtual method called from prove to generate summary.
sub summary {
    my $Self = shift;

    return if !$Self->verbosity();

    my @Suites = @{ $Self->{TestSuites} };

    my $Session = Kernel::System::UnitTest::Formatter::Session->new(
        Name          => undef,
        Formatter     => $Self,
        Parser        => undef,
        PassingToDoOk => $ENV{ALLOW_PASSING_TODOS} ? 1 : 0,
        Dom           => $Self->{Dom},
        TestSuites    => \@Suites,

    );
    my $Junit = $Session->_XmlTestSuites(
        Ref      => {},
        Children => \@Suites
    );

    print STDOUT $Junit->toString() . "\n";

    return;
}

1;
