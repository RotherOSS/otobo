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

# Get the database connection from the OTOBO config
my ($DSN, $DatabaseUser, $DatabasePw);
{
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $DSN          = $ConfigObject->Get('TestDatabaseDSN')  || $ConfigObject->Get('DatabaseDSN');
    $DatabaseUser = $ConfigObject->Get('TestDatabaseUser') || $ConfigObject->Get('DatabaseUser');
    $DatabasePw   = $ConfigObject->Get('TestDatabasePw')   || $ConfigObject->Get('DatabasePw');
}


get '/' => sub {
    my $c = shift;

    $c->render(text => 'Hello 🌍!' . join ',', $DSN, $DatabaseUser, $DatabasePw);
};

app->start;
