# Do not change this file manually.
# Instead adapt bin/otobo.CheckModules.pl and call
#    ./bin/otobo.CheckModules.pl --cpanfile > cpanfile

requires 'Archive::Tar';
requires 'Archive::Zip';
requires 'Date::Format';
requires 'DateTime';
requires 'DBI';
requires 'Digest::SHA';
requires 'List::Util::XS';
requires 'LWP::UserAgent';
requires 'Net::DNS';
requires 'Template::Toolkit';
requires 'Template::Stash::XS';
requires 'Time::HiRes';
requires 'XML::LibXML';
requires 'YAML::XS';

feature 'mysql', 'Support for database MySQL' => sub {
requires 'DBD::mysql';
};

feature 'odbc', 'Support for database access via ODBC' => sub {
requires 'DBD::ODBC';
};

feature 'oracle', 'Support for database Oracle' => sub {
requires 'DBD::Oracle';
};

feature 'plack', 'Suppport for plack' => sub {
requires 'CGI::Emulate::PSGI';
requires 'Moo';
requires 'Plack';
requires 'Plack::App::File';
requires 'Plack::Middleware::Header';
requires 'Plack::Middleware::ForceEnv';
requires 'SOAP::Transport::HTTP::Plack';
requires 'Starman';
};

feature 'postgresql', 'Support for database PostgreSQL' => sub {
requires 'DBD::Pg';
};
