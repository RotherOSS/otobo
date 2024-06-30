This directory contains Perl modules from CPAN that are bundled with OTOBO.
All of these modules are implemented in pure Perl.

License information of the bundled modules can be found in the
[COPYING-Third-Party](../../COPYING-Third-Party) file.

The original list of the bundled distributions is maintained in the module Kernel::System::Environment. Please keep
that list up to date when upgrading or adding distributions. The list from Kernel::System::Environment is also used by
bin/otobo.CheckModules.pl. That command can be used to generate a cpanfile for the bundled modules.
The generated cpanfile can then be used for updating Kernel/cpan-lib.
But that task is not trivial. So here is an exemplar workflow:

### Preparation for both quick update and complete regeneration

Starting in the OTOBO root dir.

    bin/otobo.CheckModules.pl --inst                                        # make sure that the deps are installed
    gvim Kernel/System/Environment.pm                                       # update BundleModulesDeclarationGet() if there are changes
    bin/otobo.CheckModules.pl --bundled-cpanfile > Kernel/cpan-lib/cpanfile # in case BundleModulesDeclarationGet() list has changed
    cd Kernel/cpan-lib

### Shortcut when there are only version updates

Only update modules where the version was updated in F<Kernel/cpan-lib/cpanfile>.

    rm -rf local
    PERL5LIB=. cpanm --notest --installdeps . --local-lib local             # install into local/lib/perl5
    PERL5LIB=. cpanm --notest --installdeps . --local-lib local             # again, to see that the install was complete
    rm -rf local/lib/perl5/x86_64-linux-gnu-thread-multi                    # contains only perllocal.pod
    cp -r local/lib/perl5/* .                                               # copy to actual destination

Then examine the diffs and check in the verified changes.

Finally clean up the temporary dir again:

    rm -rf local

### A fresh install of the bundled modules

    cpanm --notest --installdeps . --local-lib local                        # install locally into local/lib/perl5
    cpanm --notest --installdeps . --local-lib local                        # again, to see that the install was complete

### Remove files and directories that should not be bundled with OTOBO

The reason why specific files are not included in the bundle is not always evident.

    rm -rf local/lib/perl5/x86_64-linux-gnu-thread-multi              # or a similar dir, depending on the devel machine
    rm -rf local/lib/perl5/Apache                                     # Apache::SOAP is not needed
    rm local/lib/perl5/Net/IMAP/SimpleX.pm
    rm local/lib/perl5/Net/SSLGlue/FTP.pm
    rm local/lib/perl5/Net/SSLGlue/LDAP.pm
    rm local/lib/perl5/Net/SSLGlue/LWP.pm
    rm local/lib/perl5/Net/SSLGlue/Socket.pm
    rm local/lib/perl5/SOAP/Test.pm
    rm local/lib/perl5/SOAP/Transport/IO.pm
    rm local/lib/perl5/SOAP/Transport/LOCAL.pm
    rm local/lib/perl5/SOAP/Transport/LOOPBACK.pm
    rm local/lib/perl5/SOAP/Transport/MAILTO.pm
    rm local/lib/perl5/SOAP/Transport/POP3.pm
    rm local/lib/perl5/SOAP/Transport/TCP.pm
    rm local/lib/perl5/Test/LongString.pm
    find . \( -name "*.pl" \) -delete                      # just because this is the tradition
    find . -type d -empty -delete                                     # empty dirs are not needed, usually dirs with documentation only

### Add files that do no originate from CPAN.

    cp -r Devel/REPL local/lib/perl5/Devel         # the plugins Devel::REPL::Plugin::OTOBO is not on CPAN
    cp -r Plack local/lib/perl5/Plack              # the Plack plugins are not on CPAN

### Install missing modules

There seems to be no easy way of forcing that the modules mentioned in the cpanfile
are installed when they are already available from a different location. So there is
a bit of manual work to to. First check for missing modules and then reinstall
them into local/lib/perl5. Which modules need to be reinstalled depends on the
current situation on the development machine.

    diff -r . local/lib/perl5/ | grep -v cpanfile | grep -v README.md      # the goal is to see only 'local'
    cpanm --notest --reinstall --local-lib local CPAN::DistnameInfo@0.12
    cpanm --notest --reinstall --local-lib local Font::TTF@1.06
    cpanm --notest --reinstall --local-lib local IO::String@1.08
    cpanm --notest --reinstall --local-lib local Module::CPANfile@1.1004
    cpanm --notest --reinstall --local-lib local Module::Extract::VERSION@1.116
    cpanm --notest --reinstall --local-lib local XML::LibXML::Simple@1.01

Clean up again when module were installed

    rm -rf local/lib/perl5/x86_64-linux-gnu-thread-multi              # or a similar dir, depending on the devel machine
    find . \( -name "*.pl" \) -delete                # just because this is the tradition
    find . -type d -empty -delete                                     # empty dirs are not needed, usually dirs with documentation only

### Finalize

Copy new or changed files into Kernel/cpan-lib. Remove no longer needed files. Make sure that
the changes are submitted to git.

    diff -r . local/lib/perl5/ | grep -v cpanfile | grep -v README.md      # the goal is to see only 'local'

Remove the temporary dir.

    rm -rf local
    git status
