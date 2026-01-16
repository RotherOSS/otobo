This directory contains Perl modules from CPAN that are bundled with OTOBO.
All of these modules are implemented in pure Perl.

License information of the bundled modules can be found in the
[COPYING-Third-Party](../../COPYING-Third-Party) file.

The original list of the bundled distributions is maintained in the module `Kernel::System::Environment. Please keep
that list up to date when upgrading or adding distributions. The list from `Kernel::System::Environment` is also used by
the command *bin/otobo.CheckModules.pl*. That command can be used to generate a cpanfile for the bundled modules.
The generated cpanfile can then be used for updating *Kernel/cpan-lib*.
But that task is not trivial. So here is an exemplar workflow:

### Preparation for both quick update and complete regeneration

Starting in the OTOBO root dir.

    bin/otobo.CheckModules.pl --inst                                        # make sure that the deps are installed
    gvim Kernel/System/Environment.pm                                       # update BundleModulesDeclarationGet() if there are changes
    bin/otobo.CheckModules.pl --bundled-cpanfile > Kernel/cpan-lib/cpanfile # in case BundleModulesDeclarationGet() list has changed

### Streamlined procedure when there are only version updates

Only update modules where the version was updated in F<Kernel/cpan-lib/cpanfile>.

    cd Kernel/cpan-lib
    rm -rf local
    PERL5LIB=. cpanm --notest --installdeps . --local-lib local             # install into local/lib/perl5
    PERL5LIB=. cpanm --notest --installdeps . --local-lib local             # again, to see that the install was complete
    rm -rf local/lib/perl5/x86_64-linux-gnu-thread-multi                    # contains only perllocal.pod, exact path depends on host
    find local/lib/perl5 \( -name "*.pl" \) -delete
    find local/lib/perl5 \( -name "*.pod" \) -delete
    tree local/lib/perl5                                                    # check sanity
    cp -r local/lib/perl5/* .                                               # copy to actual destination

Then examine the differences and check in the verified changes.

    git diff
    git add --patch
    git commit

Finally clean up the temporary installation directory again:

    rm -rf local

### A fresh install of the bundled modules

The files will first be installed in a fresh working directory called new_cpan_lib.
The files that will actually be kept will be in new_cpan_lib/lib/perl5. The fresh install
works best with a freshly installed Perl. The eas

    cd Kernel
    rm -rf new_cpan_lib         ^                                     # a fresh start
    # comment out the HTML::Scrubber line in cpan-lib/cpanfile as this module has a hotfix
    cpanm --notest --installdeps ./cpan-lib --local-lib new_cpan_lib  # install about 64 distros locally into new_cpan_lib/lib/perl5
    cpanm --notest --installdeps ./cpan-lib --local-lib new_cpan_lib  # again, to see that the install was complete

#### Remove files and directories that should not be bundled with OTOBO

The reason why specific files are not included in the bundle is not always evident.

    cd new_cpan_lib/lib/perl5
    rm -rf x86_64-linux-gnu-thread-multi      # or a similar dir, depending on the devel machine
    rm -rf Apache Devel::Type::Tiny LWP/Debug # Apache::SOAP and others are not needed
    rm Class/Accessor/Faster.pm Net/IMAP/SimpleX.pm SOAP/Test.pm
    (cd IO; rm SessionData.pm SessionSet.pm)  # requested by SOAP::Lite, but not actually used
    (cd Net/SSLGlue; rm FTP.pm LDAP.pm LWP.pm Socket.pm)
    (cd SOAP/Transport; rm IO.pm LOCAL.pm LOOPBACK.pm MAILTO.pm POP3.pm TCP.pm)
    find . \( -name "*.pl" \) -delete         # just because this is the tradition
    find . \( -name "*.pod" \) -delete        # just because this is the tradition
    find . -type d -empty -delete             # empty dirs are not needed, usually dirs with documentation only

### Add files that do no originate from CPAN or are modified by OTOBO

These are Perl modules that belong to OTOBO but have to be in a specific namespace.

    cp -r ../../../cpan-lib/Devel/REPL Devel    # the plugins Devel::REPL::Plugin::OTOBO is not on CPAN
    cp -r ../../../cpan-lib/Plack Plack         # the Plack plugins are not on CPAN
    cp -r ../../../cpan-lib/Test2 Test2         # the OTOBO specific Test2::Require modules
    mkdir HTML
    cp ../../../cpan-lib/HTML/Scrubber.pm HTML  # with OTOBO specific modifications

### Install missing modules

There seems to be no easy way of forcing that the modules mentioned in the cpanfile
are installed when they are already available from a different location. So there is
a bit of manual work to to. First check for missing modules and then reinstall
them into local/lib/perl5. Which modules need to be reinstalled depends on the
current situation on the development machine. It might be useful to uninstall
modules in the system Perl with `sudo cpanm -U Class::Accessor::Chained`

    cd ../../..
    diff -r cpan-lib new_cpan_lib/lib/perl5 | grep -v cpanfile | grep -v README.md      # the goal is to have an empty list
    cpanm --notest --reinstall --local-lib new_cpan_lib Class::Accessor::Chained@0.01
    cpanm --notest --reinstall --local-lib new_cpan_lib Class::Accessor::Lite@0.08
    cpanm --notest --reinstall --local-lib new_cpan_lib Class::ReturnValue@0.55
    cpanm --notest --reinstall --local-lib new_cpan_lib CPAN::DistnameInfo@0.12
    cpanm --notest --reinstall --local-lib new_cpan_lib Encode::Locale@1.05
    cpanm --notest --reinstall --local-lib new_cpan_lib File::Slurp@9999.32
    cpanm --notest --reinstall --local-lib new_cpan_lib Font::TTF@1.06
    cpanm --notest --reinstall --local-lib new_cpan_lib IO::String@1.08
    cpanm --notest --reinstall --local-lib new_cpan_lib Module::CPANfile@1.1004
    cpanm --notest --reinstall --local-lib new_cpan_lib Module::Extract::VERSION@1.116
    cpanm --notest --reinstall --local-lib new_cpan_lib XML::LibXML::Simple@1.01

Clean up after modules were explicitly installed:

    cd new_cpan_lib/lib/perl5
    rm -rf x86_64-linux-gnu-thread-multi       # or a similar dir, depending on the devel machine
    find . \( -name "*.pl" \) -delete          # just because this is the tradition
    find . \( -name "*.pod" \) -delete         # just because this is the tradition
    find . -type d -empty -delete              # empty dirs are not needed, usually dirs with documentation only

### Finalize

Check again which files have beed added or updated:
    cd ../../..
    diff -r cpan-lib new_cpan_lib/lib/perl5 | grep -v cpanfile | grep -v README.md

Copy new or changed files into *cpan-lib*. Remove no longer needed files. Make sure that
the changes are submitted to git.

Remove the temporary dir.

    rm -rf new_cpan_lib
    git status
