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
use Mojo::Exception qw(check);

# OTOBO modules
use Kernel::System::ObjectManager;

plugin 'TagHelpers';

# Get the database connection from the OTOBO config
my $Prefix = 'dbviewer', # actually same as default
my ($DSN);
{
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $DSN             = $ConfigObject->Get('TestDatabaseDSN')  || $ConfigObject->Get('DatabaseDSN');
    my $DatabaseUser = $ConfigObject->Get('TestDatabaseUser') || $ConfigObject->Get('DatabaseUser');
    my $DatabasePw   = $ConfigObject->Get('TestDatabasePw')   || $ConfigObject->Get('DatabasePw');

    # Add the route /dbviewer via the plugin Mojolicious::Plugin::DBViewer when the connect succeeds.
    eval {
        plugin(
            'DBViewer',
            dsn        => $DSN,
            user       => $DatabaseUser,
            password   => $DatabasePw,
            Prefix     => $Prefix,
            site_title => 'OTOBO DB Viewer',
        );
    };

    # write a neater error message
    check (
        default => sub {
            get "/$Prefix" => sub {
                my $c = shift;

                $c->render(
                    text => "Sorry, @{[ $c->tag( code => $DSN ) ]} is not available. Did you run installer.pl?"
                );
            };
        },
    );
}

get '/' => sub {
    my $c = shift;

    $c->render(
        text => "Hello 🌍! See @{[ $c->link_to( 'OTOBO DBViewer' => $Prefix) ]} for the database @{[ $c->tag( code => $DSN) ]}."
    );
};

app->start;
