package OTOBO::Htmx::App;

use v5.26; # indented heredocs
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

get '/show_last_logins' => sub {
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my %SessionID2UserFullName = $DBObject->SelectMapping(
        SQL => <<~'END_SQL',
            SELECT session_id, data_value
              FROM sessions
              WHERE data_key = 'UserFullName'
            END_SQL
    );
    my $LastLogins = $DBObject->SelectAll(
        SQL => <<~'END_SQL',
            SELECT session_id, data_value
              FROM sessions
              WHERE data_key = 'UserLastLoginTimestamp'
              ORDER BY data_value DESC
            END_SQL
        Limit => 5,
    );

    my @Rows =
        map { [ \'td', { id => $_->[0] }, $SessionID2UserFullName{ $_->[0] }, $_->[1] ] }
        $LastLogins->@*;

    return join "\n",
        '',
        $h->div(
            { id => 'breadcrumbs', 'hx-swap-oob' => "true" },
            [
                \'pre', "PID=$$ " . 'Breadcrumbs updated at: ' . localtime,
            ],
        ),
        $h->div(
            { class => 'Content', 'hx-get' => "htmx/empty", 'hx-swap' => 'outerHTML' },
            [
                \'table',
                [
                    \'tr',
                    [ \'th', { id => 'sample_head' },  'Full Name', 'Last Login' ],
                    @Rows,
                ],
            ],
        );
};

get '/empty' => sub {
    state $Count = 1;
    $Count++;

    return join "\n",
        '',
        $h->div(
            { 'hx-get' => "htmx/show_last_logins", 'hx-swap' => 'outerHTML' },
            "Show table again: PID=$$ Count=$Count"
        );
};

true;
