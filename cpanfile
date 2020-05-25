# Do not change this file manually.
# Instead adapt bin/otobo.CheckModules.pl and call
#    ./bin/otobo.CheckModules.pl --cpanfile > cpanfile

# Required for compressed file generation (in perlcore).
requires 'Archive::Tar';
# Required for compressed file generation.
requires 'Archive::Zip';
requires 'Date::Format';
requires 'DateTime';
requires 'DBI';
requires 'Digest::SHA';
# Do a 'force install Scalar::Util' via cpan shell to fix this problem. Please make sure to have an c compiler and make installed before.
requires 'List::Util::XS';
requires 'LWP::UserAgent';
requires 'Net::DNS';
# Template::Toolkit, the rendering engine of OTOBO.
requires 'Template::Toolkit';
# The fast data stash for Template::Toolkit.
requires 'Template::Stash::XS';
# Required for high resolution timestamps.
requires 'Time::HiRes';
# Required for XML processing.
requires 'XML::LibXML';
# Required for fast YAML processing.
requires 'YAML::XS';

feature 'mysql', 'Support for database MySQL' => sub {
    # Required to connect to a MySQL database.
    requires 'DBD::mysql';
};

feature 'odbc', 'Support for database access via ODBC' => sub {
    # Required to connect to a MS-SQL database.
    requires 'DBD::ODBC';
};

feature 'oracle', 'Support for database Oracle' => sub {
    # Required to connect to a Oracle database.
    requires 'DBD::Oracle';
};

feature 'plack', 'Suppport for plack' => sub {
    # Support old fashioned CGI in a PSGI application
    requires 'CGI::Emulate::PSGI';
    # High-performance preforking PSGI/Plack web server
    requires 'Gazelle';
    # Required by Math::Random::Secure in Kernel/cpan-lib
    requires 'Moo';
    # Neater path manipulation and some utils
    requires 'Path::Class';
    # Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)
    requires 'Plack';
    # Serve static files
    requires 'Plack::App::File';
    # Set HTTP headers
    requires 'Plack::Middleware::Header';
    # Set environment variables
    requires 'Plack::Middleware::ForceEnv';
    # PSGI SOAP adapter
    requires 'SOAP::Transport::HTTP::Plack';
};

feature 'postgresql', 'Support for database PostgreSQL' => sub {
    # Required to connect to a PostgreSQL database.
    requires 'DBD::Pg';
};
