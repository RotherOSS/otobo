# Do not change this file manually.
# Instead adapt bin/otobo.CheckModules.pl and call
#    ./bin/otobo.CheckModules.pl --cpanfile > cpanfile

# Required for compressed file generation (in perlcore).
requires 'Archive::Tar';

# Required for compressed file generation.
requires 'Archive::Zip';

# Support for readonly Perl variables
requires 'Const::Fast';

# Neater interface for capturing STDOUT and STDERR.
requires 'Capture::Tiny';

requires 'Date::Format';

requires 'DateTime', '>= 1.08';

# A CSS minifier written in XS
requires 'CSS::Minifier::XS', '>= 0.09';

requires 'Convert::BinHex';

requires 'DBI';

# Sane persistent database connection
requires 'DBIx::Connector';

requires 'Digest::SHA';

requires 'File::chmod';

# HTTP style message
requires 'HTTP::Message', '>= 6.18';

# A JavaScript minifier written in XS
requires 'JavaScript::Minifier::XS';

# JSON parsing and generation
requires 'JSON::XS';

requires 'List::Util', '>= 1.45';

requires 'List::AllUtils', '>= 0.11';

requires 'LWP::UserAgent';

# Required for random number generator.
requires 'Moo';

# clean up imported methodes
requires 'namespace::autoclean';

requires 'Net::DNS', '>= 1.05';

# Required by Kernel/cpan-lib/Mail/Mailer/smtps.pm
requires 'Net::SMTP::SSL';

# Neater path manipulation and some utils
requires 'Path::Class';

# Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)
requires 'Plack';

# needed by Kernel/cpan-lib/Crypt/Random/Source.pm
requires 'Sub::Exporter';

# Template::Toolkit, the rendering engine of OTOBO.
requires 'Template::Toolkit';

# The fast data stash for Template::Toolkit.
requires 'Template::Stash::XS';

requires 'Text::CSV', '>= 1.95';

# A fast backend that is used by Text::CSV
requires 'Text::CSV_XS', '>= 1.34';

requires 'Text::Trim';

# Required for high resolution timestamps.
requires 'Time::HiRes';

requires 'Try::Tiny';

requires 'Types::Serialiser';

# for generating properly escaped URLs
requires 'URI';

# Required for XML processing.
requires 'XML::LibXML';

# Required for fast and correct YAML processing.
requires 'YAML::XS', '>= 0.62';

# For internationalised sorting
requires 'Unicode::Collate';

# Set HTTP headers
requires 'Plack::Middleware::Header';

# Twist some HTTP variables so that the reverse proxy is transparent
requires 'Plack::Middleware::ReverseProxy';


feature 'apache:mod_perl', 'Support for feature apache:mod_perl' => sub {
    # Improves Performance on Apache webservers dramatically.
    requires 'ModPerl::Util';

};

feature 'auth:openidconnect', 'Support for feature auth:openidconnect' => sub {
    # Required for authentication via OpenIDConnect.
    requires 'Crypt::JWT';

};

feature 'db:mysql', 'Support for database MySQL' => sub {
    # Required to connect to a MariaDB or MySQL database.
    # >= 4.00: just to have some minimum version, please use a more recent version
    # != 4.042: This version had encoding related issues. Version 4.043 was a rollback to 4.0.41
    # < 5.001: This version can't be installed with the MariaDB client library
    requires 'DBD::mysql', '>= 4.00, != 4.042, < 5.001';

};

feature 'db:odbc', 'Support for database access via ODBC' => sub {
    # Required to connect to a MS-SQL database.
    # Version 1.23 not supported: This version is broken and not useable! Please upgrade to a higher version.
    requires 'DBD::ODBC', '!= 1.23';

};

feature 'db:oracle', 'Support for database Oracle' => sub {
    # Required to connect to a Oracle database.
    requires 'DBD::Oracle';

};

feature 'db:postgresql', 'Support for database PostgreSQL' => sub {
    # Required to connect to a PostgreSQL database.
    requires 'DBD::Pg';

};

feature 'db:sqlite', 'Support for database SQLLite' => sub {
    # Required to connect to a SQLite database.
    requires 'DBD::SQLite';

};

feature 'devel:debugging', 'Features which can be useful in development environments' => sub {
    # nicer formatting when dumping data structures
    requires 'Data::Dump', '>= 1.25';

    # convenient and informative dumping data structures
    requires 'Data::Dx', '>= 0.000010';

};

feature 'devel:encoding', 'Modules for debugging encoding issues' => sub {
    # for deeply inspecting scalars, especially strings
    requires 'Data::Peek';

    # for deeply inspecting strings
    requires 'String::Dump';

};

feature 'devel:i18n', 'Modules for dealing with translation and internationalisation' => sub {
    # module for manipulating .po entries
    requires 'Locale::PO';

};

feature 'devel:test', 'Modules for running the test suite' => sub {
    # for deeply inspecting scalars, especially strings
    requires 'Data::Peek';

    # used by Kernel::System::UnitTest::Selenium
    requires 'Selenium::Remote::Driver', '>= 1.49';

    # a quick compile check
    requires 'Test::Compile';

    # basic test functions
    requires 'Test2::Suite';

    # contains Test2::API which is used in Kernel::System::UnitTest::Driver
    requires 'Test::Simple';

    # testing PSGI apps and URLs
    requires 'Test2::Tools::HTTP';

    # support for formatting test results
    requires 'Unicode::GCString';

};

feature 'div:bcrypt', 'Support for feature div:bcrypt' => sub {
    # For strong password hashing.
    requires 'Crypt::Eksblowfish::Bcrypt';

};

feature 'div:cldr', 'Support for feature div:cldr' => sub {
    # localisation from the CLDR project
    requires 'Locale::CLDR', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Ar', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::De', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Es', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Fr', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Hu', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Ko', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Nb', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Pt', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Ru', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Sr', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Zh', '== 0.44.1';

};

feature 'div:hanextra', 'Support for feature div:hanextra' => sub {
    # Required to handle mails with several Chinese character sets.
    requires 'Encode::HanExtra', '>= 0.23';

};

feature 'div:ldap', 'Support for feature div:ldap' => sub {
    # Required for directory authentication.
    requires 'Net::LDAP';

};

feature 'div:qrcode', 'Support for feature div:qrcode' => sub {
    # Support for QR code in PDF files
    requires 'Text::QRCode';

};

feature 'div:ssl', 'Support for feature div:ssl' => sub {
    # Required for SSL connections to web and mail servers.
    # Please consider updating to version 2.066 or higher: This version fixes email sending (bug#14357).
    requires 'IO::Socket::SSL';

};

feature 'div:xslt', 'Support for feature div:xslt' => sub {
    # Required for Generic Interface XSLT mapping module.
    requires 'XML::LibXSLT';

};

feature 'gazelle', 'Required packages if you want to use Gazelle webserver' => sub {
    # High-performance preforking PSGI/Plack web server
    requires 'Gazelle';

    # Used when plackup is run with the -R option. This option restarts the server when files have changed.
    requires 'Linux::Inotify2';

};

feature 'graph:graphviz', 'Support for feature graph:graphviz' => sub {
    # A wrapper for AT&T's Graphviz
    requires 'GraphViz2', '>= 2.67';

};

feature 'mail', 'Features enabling communication with a mail-server' => sub {
    # Simple Mail Transfer Protocol Client.
    # Please consider updating to version 3.11 or higher: This version fixes email sending (bug#14357).
    requires 'Net::SMTP';

};

feature 'mail:imap', 'Support for feature mail:imap' => sub {
    # Required for IMAP TLS connections.
    requires 'Mail::IMAPClient', '>= 3.22';

};

feature 'mail:ntlm', 'Support for feature mail:ntlm' => sub {
    # Required for NTLM authentication mechanism in IMAP connections.
    requires 'Authen::NTLM';

};

feature 'mail:sasl', 'Support for feature mail:sasl' => sub {
    # Required for MD5 authentication mechanisms in IMAP connections.
    requires 'Authen::SASL';

};

feature 'mail:ssl', 'Support for feature mail:ssl' => sub {
    # Required for SSL connections to web and mail servers.
    # Please consider updating to version 2.066 or higher: This version fixes email sending (bug#14357).
    requires 'IO::Socket::SSL';

};

feature 'optional', 'Support for feature optional' => sub {
    # support for the REST requests to the S3 storage
    requires 'Mojolicious', '>= 9.22';

    # correct and fast JSON support, used by Mojo::JSON
    requires 'Cpanel::JSON::XS';

    # support for S3 using Mojo::UserAgent
    requires 'Mojolicious::Plugin::AWS';

    # Required to connect to a MariaDB or MySQL database.
    # >= 4.00: just to have some minimum version, please use a more recent version
    # != 4.042: This version had encoding related issues. Version 4.043 was a rollback to 4.0.41
    # < 5.001: This version can't be installed with the MariaDB client library
    requires 'DBD::mysql', '>= 4.00, != 4.042, < 5.001';

    # Required to connect to a MS-SQL database.
    # Version 1.23 not supported: This version is broken and not useable! Please upgrade to a higher version.
    requires 'DBD::ODBC', '!= 1.23';

    # Required to connect to a Oracle database.
    requires 'DBD::Oracle';

    # Required to connect to a PostgreSQL database.
    requires 'DBD::Pg';

    # Required to connect to a SQLite database.
    requires 'DBD::SQLite';

    # Improves Performance on Apache webservers dramatically.
    requires 'ModPerl::Util';

    # Simple Mail Transfer Protocol Client.
    # Please consider updating to version 3.11 or higher: This version fixes email sending (bug#14357).
    requires 'Net::SMTP';

    # Required for IMAP TLS connections.
    requires 'Mail::IMAPClient', '>= 3.22';

    # Required for MD5 authentication mechanisms in IMAP connections.
    requires 'Authen::SASL';

    # Required for NTLM authentication mechanism in IMAP connections.
    requires 'Authen::NTLM';

    # For usage with Redis Cache Server.
    requires 'Redis';

    # Recommended for usage with Redis Cache Server. (it`s compatible with `Redis`, but **~2x faster**)
    requires 'Redis::Fast';

    # High-performance preforking PSGI/Plack web server
    requires 'Gazelle';

    # Used when plackup is run with the -R option. This option restarts the server when files have changed.
    requires 'Linux::Inotify2';

    # A wrapper for AT&T's Graphviz
    requires 'GraphViz2', '>= 2.67';

    # Required for authentication via OpenIDConnect.
    requires 'Crypt::JWT';

    # Required to handle mails with several Chinese character sets.
    requires 'Encode::HanExtra', '>= 0.23';

    # Required for SSL connections to web and mail servers.
    # Please consider updating to version 2.066 or higher: This version fixes email sending (bug#14357).
    requires 'IO::Socket::SSL';

    # Required for directory authentication.
    requires 'Net::LDAP';

    # For strong password hashing.
    requires 'Crypt::Eksblowfish::Bcrypt';

    # localisation from the CLDR project
    requires 'Locale::CLDR', '== 0.44.1';

    # Required for Generic Interface XSLT mapping module.
    requires 'XML::LibXSLT';

    # Support for QR code in PDF files
    requires 'Text::QRCode';

    # nicer formatting when dumping data structures
    requires 'Data::Dump', '>= 1.25';

    # convenient and informative dumping data structures
    requires 'Data::Dx', '>= 0.000010';

    # for deeply inspecting scalars, especially strings
    requires 'Data::Peek';

    # for deeply inspecting strings
    requires 'String::Dump';

    # used by Kernel::System::UnitTest::Selenium
    requires 'Selenium::Remote::Driver', '>= 1.49';

    # a quick compile check
    requires 'Test::Compile';

    # basic test functions
    requires 'Test2::Suite';

    # contains Test2::API which is used in Kernel::System::UnitTest::Driver
    requires 'Test::Simple';

    # testing PSGI apps and URLs
    requires 'Test2::Tools::HTTP';

    # support for formatting test results
    requires 'Unicode::GCString';

    # module for manipulating .po entries
    requires 'Locale::PO';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Ar', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::De', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Es', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Fr', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Hu', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Ko', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Nb', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Pt', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Ru', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Sr', '== 0.44.1';

    # language packs from the CLDR project
    requires 'Locale::CLDR::Locales::Zh', '== 0.44.1';

};

feature 'performance:redis', 'Support for feature performance:redis' => sub {
    # For usage with Redis Cache Server.
    requires 'Redis';

    # Recommended for usage with Redis Cache Server. (it`s compatible with `Redis`, but **~2x faster**)
    requires 'Redis::Fast';

};

feature 'storage:s3', 'AWS S3 compatible storage' => sub {
    # support for the REST requests to the S3 storage
    requires 'Mojolicious', '>= 9.22';

    # correct and fast JSON support, used by Mojo::JSON
    requires 'Cpanel::JSON::XS';

    # support for S3 using Mojo::UserAgent
    requires 'Mojolicious::Plugin::AWS';

};
