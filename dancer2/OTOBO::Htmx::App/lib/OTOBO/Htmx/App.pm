package OTOBO::Htmx::App;

use v5.24;
use strict;
use warnings;
#use namespace::autoclean; # Dancer2 imports symbols
use utf8;

# core modules

# CPAN modules
use HTML::Tiny ();
use Dancer2;

# OTOBO modules

my $h = HTML::Tiny->new( mode => 'html' );

get '/show_table' => sub {
    return join "\n",
        '',
        $h->div(
            { id => 'breadcrumbs', 'hx-swap-oob' => "true" },
            [
                \'pre', 'Breadcrumbs updated: ' . localtime,
            ],
        ),
        $h->div(
            { 'hx-get' => "htmx/empty", 'hx-swap' => 'outerHTML' },
            [
                \'table',
                [
                    \'tr',
                    [ \'th', { id => 'sample_head' },  'Key', 'Value' ],
                    [ \'th', { id => 'sample_col_1' }, 'App', 'OTOBO::Htmx::App' ],
                    [ \'th', { id => 'sample_col_2' }, 'Time', (scalar localtime) ],
                ],
            ],
        );
};

get '/empty' => sub {
    return "\n" . $h->div(
        { 'hx-get' => "htmx/show_table", 'hx-swap' => 'outerHTML' },
        'Show table'
    );
};

true;
