This directory contains bundled pure-perl CPAN modules that are used by OTOBO.

License information of the bundled modules can be found in the
[COPYING-Third-Party](../../COPYING-Third-Party) file.

A list of the bundled distributions is also kept in the module Kernel::System::Environment. Please keep it
up to date when adding distributions. The list from Kernel::System::Environment is also used by
bin/otobo.CheckModules.pl. That command can be used to generate a cpanfile for the bundled modules.
The generated cpanfile can the be used for updating Kernel/cpan-lib.
But that is not trivial. So here is an exemplar workflow:

### a fresh install of the modules

    bin/otobo.CheckModules.pl --inst                                     # make sure that the deps are installed
    mkdir tmp-cpan-lib                                                   # initially empty
    bin/otobo.CheckModules.pl --bundled-cpanfile > tmp-cpan-lib/cpanfile # declaration of needed modules
    cd tmp-cpan-lib                                                      # start in an empty dir
    cpanm --notest --installdeps . --local-lib local                     # install locally
    cpanm --notest --installdeps . --local-lib local                     # again, to see that the install was complete
    find local/lib/perl5/ -name '*.pl' -delete                           # just because of tradition
    find local/lib/perl5/ -name '*.pod' -delete                          # ditto

### install missing modules

There seems to be no easy way of forcing that the modules mentioned in the cpanfile
are installed when they are already available from a different location. So there is
a bit of manual work to to. First check for missing modules and then reinstall
them into local/lib/perl5. Which modules need to be reinstalled depends on the
current situation on the development machine.

    diff -r ../Kernel/cpan-lib/ local/lib/perl5/                      # looking for missing modules
    cpanm --notest --reinstall --local-lib local CPAN::DistnameInfo@0.12
    cpanm --notest --reinstall --local-lib local Encode::Locale@1.05
    cpanm --notest --reinstall --local-lib local File::Slurp@9999.32
    cpanm --notest --reinstall --local-lib local Font::TTF@1.06
    cpanm --notest --reinstall --local-lib local IO::String@1.08
    cpanm --notest --reinstall --local-lib local Module::CPANfile@1.1004
    cpanm --notest --reinstall --local-lib local Module::Extract::VERSION@1.116
    cpanm --notest --reinstall --local-lib local XML::LibXML::Simple@1.01

Remove files and directories that should not remain in Kernel/cpan-lib.

    rm -rf local/lib/perl5/x86_64-linux-gnu-thread-multi              # or a similar dir, depending on the devel machine
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
    find local/lib/perl5/ -name '*.pl' -delete                        # just because of tradition
    find local/lib/perl5/ -name '*.pod' -delete                       # ditto
    find . -type d -empty -delete                                     # empty dirs are not needed, usually dirs with documentation only

Add files that do no originate from CPAN.

    cp -r ../Kernel/cpan-lib/Devel/REPL local/lib/perl5/Devel         # the plugins Devel::REPL::Plugin::OTOBO is not on CPAN
    cp -r ../Kernel/cpan-lib/Plack local/lib/perl5/Plack              # the Plack plugins are not on CPAN
    cp -r ../Kernel/cpan-lib/README.md local/lib/perl5                # these instructions

Finalize.

    diff -r ../Kernel/cpan-lib/ local/lib/perl5/ > diff.out           # inspect the diff
    cd ..                                                             # back into the otobo dir
    cp Kernel/cpan-lib/README.md README-cpan-lib.md                   # safe this file
    rm -rf Kernel/cpan-lib/                                           # start on a clean slate
    cp -r tmp-cpan-lib/local/lib/perl5 Kernel/cpan-lib                # only the new files
    git status                                                        # inspect
    git diff                                                          # inspect in detail
