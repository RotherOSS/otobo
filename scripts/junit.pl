#!/usr/local/bin/perl

use strict;
use utf8;
use XML::LibXSLT;
use File::Find;

# path to output of test reports
my $Path = '/opt/otobo/var/tap';

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
    $Path
);

# load the XSL style document
my $StyleDoc = XML::LibXML->load_xml( location=>"/opt/otobo/scripts/junit.xsl", no_cdata=>1 ); 

# prepare XSL transformer
my $Xslt = XML::LibXSLT->new(); 
my $Stylesheet = $Xslt->parse_stylesheet( $StyleDoc ); 

# transform each Test output and save as *.t.rspec.xml
foreach my $Test ( @Tests ) {
    
    
    # load the source
    my $Source = XML::LibXML->load_xml( location => "$Test" ); 
    
    # do the xsl transform
    my $Results = $Stylesheet->transform( $Source ); 

    # determine output file path
    my $Output = $Test;
    $Output =~ s/\.t\.junit\.xml/.t.rspec.xml/;
    
    # write enhanced xml file
    $Stylesheet->output_file( $Results, $Output );
}
