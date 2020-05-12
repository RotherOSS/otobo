#!/usr/bin/perl
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

# To profile single requests, install Devel::NYTProf and start this script as
# PERL5OPT=-d:NYTProf NYTPROF='trace=1:start=no' plackup bin/cgi-bin/app.psgi
# then append &NYTProf=mymarker to a request.
# This creates a file called nytprof-mymarker.out, which you can process with
# nytprofhtml -f nytprof-mymarker.out
# Then point your browser at nytprof/index.html

use strict;
use warnings;
use 5.24.0;

use lib '/opt/otobo/';
use lib '/opt/otobo/Kernel/cpan-lib';
use lib '/opt/otobo/Custom';

## nofilter(TidyAll::Plugin::OTOBO::Perl::SyntaxCheck)

use CGI::Emulate::PSGI;
use Module::Refresh;
use Plack::Builder;

# Preload frequently used modules to speed up client spawning.
use CGI ();
use CGI::Carp ();

# enable this if you use mysql
#use DBD::mysql ();
#use Kernel::System::DB::mysql;

# enable this if you use postgresql
#use DBD::Pg ();
#use Kernel::System::DB::postgresql;

# enable this if you use oracle
#use DBD::Oracle ();
#use Kernel::System::DB::oracle;

# Preload Net::DNS if it is installed. It is important to preload Net::DNS because otherwise loading
#   could take more than 30 seconds.
eval { require Net::DNS };

# Preload DateTime, an expensive external dependency.
use DateTime ();

# Preload dependencies that are always used.
use Template ();
use Encode qw(:all);

# this might improve performance
CGI->compile(':cgi');

# Workaround: some parts of OTOBO use exit to interrupt the control flow.
#   This would kill the Plack server, so just use die instead.
BEGIN {
    *CORE::GLOBAL::exit = sub { die "exit called\n"; };
}

print STDERR "PLEASE NOTE THAT PLACK SUPPORT IS CURRENTLY EXPERIMENTAL AND NOT SUPPORTED!\n";

my $App = CGI::Emulate::PSGI->handler(
    sub {

        # Cleanup values from previous requests.
        CGI::initialize_globals();

        # Populate SCRIPT_NAME as OTOBO needs it in some places.
        ( $ENV{SCRIPT_NAME} ) = $ENV{PATH_INFO} =~ m{/([A-Za-z\-_]+\.pl)};    ## no critic

        # Fallback to agent login if we could not determine handle...
        if ( !defined $ENV{SCRIPT_NAME} || ! -e "/opt/otobo/bin/cgi-bin/$ENV{SCRIPT_NAME}" ) {
            $ENV{SCRIPT_NAME} = 'index.pl';                                   ## no critic
        }

        eval {

            # Reload files in @INC that have changed since the last request.
            Module::Refresh->refresh();
        };
        warn $@ if $@;

        my $Profile;
        if ( $ENV{NYTPROF} && $ENV{REQUEST_URI} =~ /NYTProf=([\w-]+)/ ) {
            $Profile = 1;
            DB::enable_profile("nytprof-$1.out");
        }

        # Load the requested script
        eval {
            do "/opt/otobo/bin/cgi-bin/$ENV{SCRIPT_NAME}";
        };
        if ( $@ && $@ ne "exit called\n" ) {
            warn $@;
        }

        if ($Profile) {
            DB::finish_profile();
        }
    },
);

# Small helper function to determine the path to a static file
my $StaticPath = sub {

    # Everything in otobo-web/js or otobo-web/skins is a static file.
    return 0 if $_ !~ m{-web/js/|-web/skins/};

    # Return only the relative path.
    $_ =~ s{^.*?-web/(js/.*|skins/.*)}{$1}smx;

    return $_;
};

# Create a Static middleware to serve static files directly without invoking the OTOBO
#   application handler.
builder {
    enable 'Static',
        path        => $StaticPath,
        root        => "/opt/otobo/var/httpd/htdocs",
        pass_trough => 0;
    $App;
}
