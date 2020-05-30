#!/usr/bin/env perl

=head1 NAME

dbviewer.pl - a Mojolicious::Lite app for viewing the OTOBO database

=head1 SYNOPSIS

    # using the Mojolicious devel webserver
    morbo bin/morbo-bin/otobo.psgi

=head1 DESCRIPTION

A Mojolicious::Lite application.

Gets the database connection setup from Kernel::Config.

=head1 SEE ALSO

L<https://metacpan.org/pod/Mojolicious::Plugin::DBViewer>

=cut

use strict;
use warnings;
use 5.24.0;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# core modules

# CPAN modules
use Mojolicious::Lite;

# OTOBO modules
use Kernel::System::ObjectManager;

get '/' => sub {
    my $c = shift;

    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $c->render(text => 'Hello 🌍!');
};

app->start;
