This directory contains bundled pure-perl CPAN modules that are used by OTOBO.

License information of the bundled modules can be found in the
[COPYING-Third-Party](../../COPYING-Third-Party) file.

A list of the bundled distributions is also kept in the module Kernel::System::Environment. Please keep it
up to date when adding distributions. The list from Kernel::System::Environment is also used by
bin/otobo.CheckModules.pl. That command can generate a cpanfile for the bundled modules.
The generated cpanfile can be used for updating Kernel/cpan-lib.
But that is not trivial. So here is an exemplar workflow:

    bin/otobo.CheckModules.pl --inst                                  # make sure that the deps are installed
    mkdir tmp-cpan-lib                                                # initially empty
    bin/otobo.CheckModules.pl --bundled-cpanfile > tmp-cpan-lib/cpanfile
    cd tmp-cpan-lib                                                   # start in an empty dir
    cpanm --notest --installdeps . --local-lib local                  # install locally
    cpanm --notest --reinstall --local-lib local CPAN::DistnameInfo   # because the exact version happened to be already installed
    cpanm --notest --reinstall --local-lib local Encode::Locale       # ditto
    cpanm --notest --reinstall --local-lib local Font::TTF            # ditto
    cpanm --notest --reinstall --local-lib local IO::String           # ditto
    cpanm --notest --reinstall --local-lib local Module::CPANfile     # ditto
    cpanm --notest --reinstall --local-lib local XML::LibXML::Simple  # ditto
    find local/lib/perl5/ -name '*.pl' -delete                        # just because of tradition
    find local/lib/perl5/ -name '*.pod' -delete                       # ditto
    rm -rf local/lib/perl5/x86_64-linux-gnu-thread-multi              # that dir is not useful
    rm -rf local/lib/perl5/Apache                                     # Apache::SOAP is not needed
    rm local/lib/perl5/Net/IMAP/SimpleX.pm                            # not sure why this was removed in Kernel/cpan-lib
    rm local/lib/perl5/Net/SSLGlue/FTP.pm                             # ditto
    rm local/lib/perl5/Net/SSLGlue/LDAP.pm                            # ditto
    rm local/lib/perl5/Net/SSLGlue/LWP.pm                             # ditto
    rm local/lib/perl5/Net/SSLGlue/Socket.pm                          # ditto
    rm local/lib/perl5/SOAP/Test.pm                                   # ditto
    rm local/lib/perl5/SOAP/Transport/IO.pm                           # ditto
    rm local/lib/perl5/SOAP/Transport/LOCAL.pm                        # ditto
    rm local/lib/perl5/SOAP/Transport/LOOPBACK.pm                     # ditto
    rm local/lib/perl5/SOAP/Transport/MAILTO.pm                       # ditto
    rm local/lib/perl5/SOAP/Transport/POP3.pm                         # ditto
    rm local/lib/perl5/SOAP/Transport/TCP.pm                          # ditto
    rm local/lib/perl5/Test/LongString.pm                             # ditto
    find . -type d -empty -delete                                     # empty dirs are not needed, usually dirs with documentation only
    cp -r ../Kernel/cpan-lib/Devel/REPL local/lib/perl5/Devel         # the plugins Devel::REPL::Plugin::OTOBO is not on CPAN
    cp -r ../Kernel/cpan-lib/Plack local/lib/perl5/Plack              # the Plack plugins are not on CPAN
    cp -r ../Kernel/cpan-lib/README.md local/lib/perl5                # this instructions
    diff -r ../Kernel/cpan-lib/ local/lib/perl5/ > diff.out           # inspect the diff
    rm -rf ../Kernel/cpan-lib/                                        # start on a clean slate
    cp -r local/lib/perl5 Kernel/cpan-lib                             # only the new files
    cd ../Kernel/cpan-lib
    git diff
