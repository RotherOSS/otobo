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

feature 'docker', 'Optional modules that are included in the Docker image' => sub {
    # For strong password hashing.
    requires 'Crypt::Eksblowfish::Bcrypt';
    # Recommended for faster AJAX/JavaScript handling.
    requires 'JSON::XS';
    # Required for IMAP TLS connections.
    requires 'Mail::IMAPClient';
    # Required for directory authentication.
    requires 'Net::LDAP';
    # Recommended for faster CSV handling.
    requires 'Text::CSV_XS';
    # Required for Generic Interface XSLT mapping module.
    requires 'XML::LibXSLT';
};

feature 'mojo', 'Suppport for mojo' => sub {
    # a web framework that makes web development fun again
    requires 'Mojolicious';
    # Mojolicious plugin to display database information on browser
    requires 'Mojolicious::Plugin::DBViewer';
};

feature 'mysql', 'Support for database MySQL' => sub {
    # Required to connect to a MySQL database.
    requires 'DBD::mysql';
};

feature 'odbc', 'Support for database access via ODBC' => sub {
    # Required to connect to a MS-SQL database.
    requires 'DBD::ODBC';
};

feature 'optional', 'Modules that are not required' => sub {
    # Improves Performance on Apache webservers with mod_perl enabled.
    requires 'Apache::DBI';
    # Avoids web server restarts on mod_perl.
    requires 'Apache2::Reload';
    # Support old fashioned CGI in a PSGI application
    requires 'CGI::Emulate::PSGI';
    # Adapt CGI.pm to the PSGI protocol
    requires 'CGI::PSGI';
    # For strong password hashing.
    requires 'Crypt::Eksblowfish::Bcrypt';
    # Required to connect to a MySQL database.
    requires 'DBD::mysql';
    # Required to connect to a MS-SQL database.
    requires 'DBD::ODBC';
    # Required to connect to a Oracle database.
    requires 'DBD::Oracle';
    # Required to connect to a PostgreSQL database.
    requires 'DBD::Pg';
    # Sane persistent database connection
    requires 'DBIx::Connector';
    # Required to handle mails with several Chinese character sets.
    requires 'Encode::HanExtra';
    # High-performance preforking PSGI/Plack web server
    requires 'Gazelle';
    # Required for SSL connections to web and mail servers.
    requires 'IO::Socket::SSL';
    # Recommended for faster AJAX/JavaScript handling.
    requires 'JSON::XS';
    # Used with the -R option of plackup. Restart the server when files have changed.
    requires 'Linux::Inotify2';
    # Required for IMAP TLS connections.
    requires 'Mail::IMAPClient';
    # Improves Performance on Apache webservers dramatically.
    requires 'ModPerl::Util';
    # a web framework that makes web development fun again
    requires 'Mojolicious';
    # Mojolicious plugin to display database information on browser
    requires 'Mojolicious::Plugin::DBViewer';
    # Required by Math::Random::Secure in Kernel/cpan-lib
    requires 'Moo';
    # Required for directory authentication.
    requires 'Net::LDAP';
    # Simple Mail Transfer Protocol Client.
    requires 'Net::SMTP';
    # Neater path manipulation and some utils
    requires 'Path::Class';
    # Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)
    requires 'Plack';
    # Serve static files
    requires 'Plack::App::File';
    # Set environment variables
    requires 'Plack::Middleware::ForceEnv';
    # Set HTTP headers
    requires 'Plack::Middleware::Header';
    # Set environment variables
    requires 'Plack::Middleware::Rewrite';
    # PSGI SOAP adapter
    requires 'SOAP::Transport::HTTP::Plack';
    # Recommended for faster CSV handling.
    requires 'Text::CSV_XS';
    # Required for Generic Interface XSLT mapping module.
    requires 'XML::LibXSLT';
    # Recommended for XML processing.
    requires 'XML::Parser';
    # For usage with Redis Cache Server.
    requires 'Redis';
    # Recommended for usage with Redis Cache Server. (it`s compatible with `Redis`, but **~2x faster**)
    requires 'Redis::Fast';
};

feature 'oracle', 'Support for database Oracle' => sub {
    # Required to connect to a Oracle database.
    requires 'DBD::Oracle';
};

feature 'plack', 'Suppport for plack' => sub {
    # Support old fashioned CGI in a PSGI application
    requires 'CGI::Emulate::PSGI';
    # Adapt CGI.pm to the PSGI protocol
    requires 'CGI::PSGI';
    # Sane persistent database connection
    requires 'DBIx::Connector';
    # High-performance preforking PSGI/Plack web server
    requires 'Gazelle';
    # Used with the -R option of plackup. Restart the server when files have changed.
    requires 'Linux::Inotify2';
    # Required by Math::Random::Secure in Kernel/cpan-lib
    requires 'Moo';
    # Neater path manipulation and some utils
    requires 'Path::Class';
    # Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)
    requires 'Plack';
    # Serve static files
    requires 'Plack::App::File';
    # Set environment variables
    requires 'Plack::Middleware::ForceEnv';
    # Set HTTP headers
    requires 'Plack::Middleware::Header';
    # Set environment variables
    requires 'Plack::Middleware::Rewrite';
    # PSGI SOAP adapter
    requires 'SOAP::Transport::HTTP::Plack';
};

feature 'postgresql', 'Support for database PostgreSQL' => sub {
    # Required to connect to a PostgreSQL database.
    requires 'DBD::Pg';
};
