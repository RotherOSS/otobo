#!/usr/bin/env perl
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

use strict;
use warnings;
use utf8;
use XML::LibXSLT;
use File::Find;

# Arg 1 is path to Test(s)
my $OtoboTests = $ARGV[0];

if ( !$OtoboTests || $OtoboTests eq '' ) {
    print STDERR "No tests specified!\n";
    exit 1;
}

# path to output of test reports
my $TapPath = '/opt/otobo/var/tap';

# prepare clean output paths
system("rm -rf $TapPath");
system("mkdir -p $TapPath");

# lib paths for prove
my $OtoboTestLibs = '$PERL5LIB:/opt/otobo/local/lib/perl5:/opt/otobo_install/local/lib/perl5/:/opt/otobo:/opt/otobo/Kernel/cpan-lib';

#print STDERR "$OtoboTestLibs\n";
#print STDERR "PERL5LIB=$OtoboTestLibs PERL_TEST_HARNESS_DUMP_TAP=$TapPath /usr/local/bin/prove -r --timer --formatter=TAP::Formatter::JUnit $OtoboTests;\n";

# run the test with prove and formatter
my $ExitCode
    = system("PERL5LIB=$OtoboTestLibs PERL_TEST_HARNESS_DUMP_TAP=$TapPath /usr/local/bin/prove -r --timer --formatter=TAP::Formatter::JUnit $OtoboTests "); # > /dev/null");

print STDERR "Exit Code: $ExitCode\n";

# now transform results for GitLab

# find all *.t.junit.xml files under $Path, recursively
my @Tests;
find(
    {
        wanted => sub {
            if ( $_ =~ /\.t.junit.xml$/ ) {
                push @Tests, $_;
            }
        },
        no_chdir => 1,
    },
    $TapPath
);

# load the XSL style document
my $StyleDoc = XML::LibXML->load_xml(
    location => "/opt/otobo/scripts/junit.xsl",
    no_cdata => 1
);

# prepare XSL transformer
my $Xslt       = XML::LibXSLT->new();
my $Stylesheet = $Xslt->parse_stylesheet($StyleDoc);

# transform each Test output and save as *.t.rspec.xml
foreach my $Test (@Tests) {

    pritn STDERR "Transform $Test\n";
    # load the source
    my $Source = XML::LibXML->load_xml( location => "$Test" );

    # do the xsl transform
    my $Results = $Stylesheet->transform($Source);

    # determine output file path
    my $Output = $Test;
    $Output =~ s/\.t\.junit\.xml/.t.rspec.xml/;

    # write enhanced xml file
    $Stylesheet->output_file( $Results, $Output );
}

if ( $ExitCode != 0 ) {
    exit $ExitCode;
}
