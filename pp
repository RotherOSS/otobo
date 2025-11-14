#!/usr/bin/perl
use v5.24;
use strict;
use warnings;

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#
my $CurrPack = 'directory';
my $User = '';              # optional
my $Group = 'www-data';
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

$CurrPack  =~ s/\/$//;
my $WD      = `pwd`;
chomp $WD;
my $Owner   = $User || `whoami`;
chomp $Owner;
$Owner     .= ":$Group";
my $Program = GetProgram();
my @RegExesToSkip = (
    '\.git',
    '\.vscode',
    'README',
    'LICENSE',
    '\.otobo-ci.yml',
);

if ( !@ARGV ) {
    Usage();
}

for ( shift @ARGV ) {
    if (/^-*d$/) {
        SetPack( @ARGV );
    }
    elsif (/^-*p$/) {
        PrepF( @ARGV );
    }
    elsif (/^-*i$/) {
        InitF( $ARGV[0] );
    }
    elsif (/^-*u$/) {
        UpdateF( @ARGV );
    }
    elsif (/^-*s$/) {
        SOPM( @ARGV );
    }
    elsif (/^-*c$/) {
        CleanF( $ARGV[0] );
    }
    elsif (/^-*h$/) {
        Usage();
    }
    else {
        if ( -e $_ && -d $_ ) {
            InitF( $_ );
        }
        else {
            PrepF( $_, @ARGV );
        }
    }
}


#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub Usage {
    print "Usage: ./pp [command] [file(s)]\n".
          "\ti\t- Initialize files of cloned package repo (default command for directories)\n".
          "\tp\t- Prepare files (default command for file)\n".
          "\tu\t- Update files to newer OTOBO/OTRS version\n".
          "\ts\t- Create sopm file\n".
          "\tc\t- Clean files or whole repo\n".
          "\td\t- Set the directory (warning: changes file)\n".
          "\th\t- Show this usage explanation\n".
          "\n".
          "Precondition:\n".
          "  We and also the package directory are directly located in \$OTOBOHome.\n".
          "\n".
          "Examples for a new package (newpack):\n".
          "  - start by setting the correct directory (only needs to be executed once):\n".
          "      ./pp -d newpack\n".
          "  - create a completely new file in Kernel (touches, links, sets rights and prefills if template can be derived from path):\n".
          "      ./pp Kernel/System/MyMod.pm\n".
          "  - create a new file from an existing one in Kernel (links and sets rights):\n".
          "      mkdir -p newpack/Kernel/System; cp Kernel/System/JSON.pm newpack/Kernel/System/MyMod.pm; ./pp Kernel/System/MyMod.pm\n".
          "  - create a new file from an existing one in Custom or var (copies, sets \$origin, links etc., and creates a backup in case of var/):\n".
          "      ./pp Kernel/System/JSON.pm\n".
          "  - create initial sopm (description and later changes have to be done manually):\n".
          "      ./pp -s NewPack\n".
          "  - clean up:\n".
          "      ./pp -c\n".
          "";

    exit 0;
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub InitF {

    my $Pack = $_[0] || $CurrPack;
    if ( !$Pack ) {
        die "Package directory needed.\n";
    }
    if ( !-e $Pack ) {
        Usage() if !@_;
        die "'$Pack' does not exist or is not a directory.\n";
    }

    my $IsInstalled;
    if ( $Program eq 'otobo' ) {
        $IsInstalled = PrepareInstalled( Mode => 'Init' );
    }

    # needed for correct links
    $Pack = $Pack =~ /^\// ? $Pack : "$WD/$Pack";
    if ( !-d $Pack ) {
        die "'$Pack' is not a directory.\n";
    }

    my @FileList = `find $Pack -path $Pack/.git -prune -o -type f -print`;

    FILE:
    for my $File ( @FileList ) {
        next FILE if grep { $File =~ /$_/ } @RegExesToSkip;

        chomp $File;
        $File =~ s/^\.?\/?$Pack\/+//;

        if ( -e $File ) {
            if ( -e "$File.pp_backup" ) {
                die "$File.pp_backup already exists! Aborting the whole process. Directory is not cleaned!\n";
            }

            print "Preparing backup of '$File' and linking it.\n";
            system "mv $File $File.pp_backup; ln -s $Pack/$File $File";
        }

        print "Linking '$File'.\n";

        my $Dir = $File;
        if ( $Dir =~ s/\/[^\/]+$// ) {
            system "mkdir -p $Dir";
        }
        system "ln -s $Pack/$File $File";
    }

    if ( $Owner ) {
        print "Setting Ownership to $Owner\n";
        system "chown -R $Owner $Pack";
    }
    print "To complete this step, you probably want to run:\nbin/otobo.Console.pl Maint::Config::Rebuild\n";

    return 1;
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub PrepF {
    my @Files;
    my $Pack;
    for my $File ( @_ ) {
        if ( -e $File && -d $File ) {
            if ( $Pack ) {
                die "Cannot interpret two directories given with Prepare command: Please exclude '$Pack' or '$File'.\n";
            }
            $Pack = $File;
        }
        else {
            push @Files, $File;
        }
    }

    $Pack = $Pack || $CurrPack;
    if ( !$Pack ) {
        die "Package directory needed.\n";
    }

    # needed for correct links
    $Pack = $Pack =~ /^\// ? $Pack : "$WD/$Pack";
    if ( !-d $Pack ) {
        die "'$Pack' is not a directory.\n";
    }

    FILE:
    for my $File ( @Files ) {
        if ( -e "$Pack/$File" ) {
            if ( -e $File ) {
                warn "Both, '$Pack/$File' as well as '$File' are present. Nothing to do...\n";
                next FILE;
            }
            if ( !-f "$Pack/$File" ) {
                warn "'$Pack/$File' exists, but is not a regular file. Action not defined...\n";
                next FILE;
            }

            print "Linking '$File' to existing '$Pack/$File'\n";
            my $Dir = $File;
            if ( $Dir =~ s/\/[^\/]+$// ) {
                system "mkdir -p $Dir";
            }
            system "ln -s $Pack/$File $File";
            next FILE;
        }

        if ( -e $File ) {
            if ( -l $File ) {
                warn "'$File' is already a link - check please. Skipping...\n";
                next FILE;
            }
            if ( $File =~ /^Custom\// ) {
                warn "'$File' already exists - check please. Skipping...\n";
                next FILE;
            }

            if ( $File =~ /^Kernel\// ) {
                if ( -e "Custom/$File" ) {
                    warn "'Custom/$File' already exists - check please. Skipping...\n";
                    next FILE;
                }

                print "Linking 'Custom/$File' to '$Pack/Custom/$File'";
                my $Dir = "Custom/$File";
                $Dir =~ s/\/[^\/]+$//;
                if ( !-e "$Pack/Custom/$File" ) {
                    print " and preparing latter from the original.\n";
                    system "mkdir -p $Pack/$Dir; mkdir -p $Dir";

                    # copy file and add $origin
                    my $Commit = `git --no-pager log -n 1 --pretty=format:%H -- $File` || '';
                    open my $in,  "< $File" or ( warn "Could not open $File to read. Skipping...\n" && next FILE );
                    open my $out, "> $Pack/Custom/$File" or ( warn "Could not open $Pack/Custom/$File to write. Skipping...\n" && next FILE );
                    while ( <$in> ) {
                        print $out $_;
                        if ( /^# Copyright/ ) {
                            until ( /^# --\s*$/ || !$_ ) {
                                $_ = <$in>;
                                print $out $_ if defined $_;
                            }
                            if ( $_ ) {
                                print $out "# \$origin: $Program - $Commit - $File\n# --\n";
                            }
                            while ( <$in> ) { print $out $_ }
                        }
                    }
                }
                else {
                    print "\n";
                }
                system "ln -s $Pack/Custom/$File Custom/$File";
                next FILE;
            }

            if ( -e "$File.pp_backup" ) {
                warn "$File.pp_backup already present. Skipping...\n";
                next FILE;
            }

            print "Creating Backup of '$File', linking '$File' to '$Pack/$File' and copying latter from original.\n";
            my $Dir = $File;
            if ( $Dir =~ s/\/[^\/]+$// ) {
                system "mkdir -p $Pack/$Dir";
            }
            system "cp $File $Pack/$File; mv $File $File.pp_backup";
            system "ln -s $Pack/$File $File";
        }

        else {
            print "Touching '$Pack/$File' and linking '$File' to '$Pack/$File'.\n";
            my $Dir = $File;
            if ( $Dir =~ s/\/[^\/]+$// ) {
                system "mkdir -p $Dir";
                system "mkdir -p $Pack/$Dir";
            }
            system "touch $Pack/$File; ln -s $Pack/$File $File";
            my $Template;
            for ( $File ) {
                if ( /\.pm$/ ) {
                    $Template = 'GenericPM';
                }
                elsif ( /^Kernel\/Config.+\.xml$/ ) {
                    $Template = 'Config';
                }
                elsif ( /^Kernel\/Output\/HTML.+\.tt$/ ) {
                    $Template = 'Template';
                }
                elsif ( /\.js$/ ) {
                    $Template = 'JS';
                }
                elsif ( /\.css$/ ) {
                    $Template = 'CSS';
                }
                elsif ( /\/test\/Selenium\/.+\.t$/ ) {
                    $Template = 'SeleniumTest';
                }
                elsif ( /\.t$/ ) {
                    $Template = 'UnitTest';
                }
                else {
                    print "Couldn't derive Template Type from Path '$_'. Skipping Prefilling.\n";
                    return 1;
                }
            }
            print "Using Template $Template to prefill the touched file.\n";
            my $Copyright = <<'COPYRIGHT';
--
OTOBO is a web-based ticketing system for service organisations.
--
Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
Copyright (C) 2019-<current_year> Rother OSS GmbH, https://otobo.io/
--
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
--
COPYRIGHT
            my (undef, undef, undef, undef, undef, $CurrentYear) = localtime();
            $CurrentYear+= 1900;
            $Copyright =~ s/<current_year>/$CurrentYear/;
            my $Boilerplate = '';
            my $StartCode = '';
            # default case shouldn't be necessary because of fallback cases above
            for ( $Template ) {
                if ( /^GenericPM$/ ) {
                    $Copyright =~ s/^/# /mg;
                    $Boilerplate = <<'BOILERPLATE';
package <package>;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
BOILERPLATE
                    $StartCode = <<'STARTCODE';
sub new {
my ( $Type, %Param ) = @_;

# allocate new hash for object
my $Self = {%Param};
bless( $Self, $Type );

return $Self;
}

1;
STARTCODE
                }
                elsif ( /^Module$/i ) {
                    $Copyright =~ s/^/# /mg;
                    $Boilerplate = <<'BOILERPLATE';
package <package>;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;
BOILERPLATE
                    my $Package = $File =~ s/\//::/gr;
                    $Package =~ s/\.pm$//;
                    $Boilerplate =~ s/<package>/$Package/;
                    $StartCode = <<'STARTCODE';
sub new {
my ( $Type, %Param ) = @_;

# allocate new hash for object
my $Self = {%Param};
bless( $Self, $Type );

return $Self;
}

sub Run {
my ( $Self, %Param ) = @_;
}

1;
STARTCODE

                }
                elsif ( /^System$/i ) {
                    $Copyright =~ s/^/# /mg;
                    $Boilerplate = <<'BOILERPLATE';
package <package>;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (

);

=head1 NAME

[name_placeholder]

=head1 DESCRIPTION

[description_placeholder]

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

my $<libname>Object = $Kernel::OM->Get('<package>');

=cut
BOILERPLATE
                    my $Package = $File =~ s/\//::/gr;
                    $Package =~ s/\.pm$//;
                    $Boilerplate =~ s/<package>/$Package/g;
                    my $LibName = $File =~ s/(^.+\/|\.pm$)//gr;
                    $Boilerplate =~ s/<libname>/$LibName/;
                    $StartCode = <<'STARTCODE';
sub new {
my ( $Type, %Param ) = @_;

# allocate new hash for object
my $Self = {%Param};
bless( $Self, $Type );

return $Self;
}

sub Run {
my ( $Self, %Param ) = @_;
}

1;
STARTCODE
                }
                elsif ( /^Config$/i ) {
                    $Copyright = '';
                    $Boilerplate = <<'BOILERPLATE';
<?xml version="1.0" encoding="utf-8" ?>
<otobo_config version="2.0" init="[placeholder]">
<Setting Name="" Required="" Valid="" ConfigLevel="">
    <Description Translatable="1"></Description>
    <Navigation></Navigation>
    <Value>
    </Value>
</Setting>
</otobo_config>
BOILERPLATE
                }
                elsif ( /^Template$/i ) {
                    $Copyright =~ s/^/# /mg;
                }
                elsif ( /^JS$/i ) {
                    $Copyright =~ s/^/\/\/ /mg;
                    $Boilerplate = <<'BOILERPLATE';
"use strict";

var <base_object> = <base_object> || {};
<further_objects>
BOILERPLATE
                    # omit path
                    ( my $FileShort ) = grep { /\.js$/ } ( split( '\/', $File ) );
                    my @MemberOf = split( '\.', $FileShort );
                    # remove '.js'
                    pop @MemberOf;
                    my $CurrentObject = join( '.', @MemberOf );
                    my $Base = shift @MemberOf;
                    $Boilerplate =~ s/<base_object>/$Base/g;
                    my $FurtherObjects = join( "\n", map {
                        $Base .= ".$_";
                        "$Base = $Base || {};"
                    } @MemberOf[0 .. $#MemberOf - 1] );
                    $Boilerplate =~ s/<further_objects>/$FurtherObjects/;
                    $StartCode = <<'STARTCODE';
/**
* @namespace <current_object>
* @memberof <member>
* @author
* @description
*      [description_placeholder]
*/
<current_object> = (function (TargetNS) {

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(<current_object> || {}));
STARTCODE
                    $StartCode =~ s/<current_object>/$CurrentObject/g;
                    $StartCode =~ s/<member>/$Base/;
                }
                elsif ( /^CSS$/i ) {
                    $Copyright =~ s/^--\n/\/\* /;
                    $Copyright =~ s/--$/\*\//;
                    $Copyright =~ s/--//g;
                    $Boilerplate = <<'BOILERPLATE';
/**
* @package     Skin "Default"
* @section     [placeholder]
* @subsection  [placeholder]
*/
BOILERPLATE
                }
                elsif ( /^UnitTest$/i ) {
                    $Copyright =~ s/^/# /mg;
                    $Boilerplate = <<'BOILERPLATE';
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we ware running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# OTOBO modules

use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
sub {

    my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
}
);
BOILERPLATE
                }
                elsif ( /^SeleniumTest$/i ) {
                    $Copyright =~ s/^/# /mg;
                    $Boilerplate = <<'BOILERPLATE';
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we ware running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
'Kernel::System::UnitTest::Helper' => {
    RestoreDatabase => 1,
},
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
BOILERPLATE
                }
            }
            open( my $FH, '>', "$Pack/$File" ) or die "Could not open Filehandle to touched File, please check.\n";
            print "Writing prefillable content to file.\n";
            print $FH join( "\n", grep { $_ } ( $Copyright, $Boilerplate, $StartCode ) );
            close $FH;
        }
    }

    if ( $Owner ) {
        print "Setting Ownership to $Owner\n";
        system "chown -R $Owner $Pack";
    }

    return 1;
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub UpdateF {

    my $Pack = $_[0] || $CurrPack;
    if ( !$Pack ) {
        die "Package directory needed.\n";
    }
    if ( !-e $Pack ) {
        die "'$Pack' does not exist.\n";
    }

    my @FileList;
    if ( $Pack =~ /^ITSM/i ) {
        @FileList = `find $Pack/Kernel $Pack/Custom $Pack/var/httpd/htdocs $Pack/scripts/test -type f -print`;
    }
    else {
        @FileList = `find $Pack/Custom $Pack/var/httpd/htdocs $Pack/scripts/test -type f -print`;
    }

    FILE:
    for my $File ( @FileList ) {
        chomp($File);
        my $OrigFile = $File;
        $OrigFile =~ s/^\.?\/?$Pack(:?\/Custom)?\/?//;

        if ( !-e $OrigFile ) {
            if ( $File =~ /^\.?\/?$Pack\/Custom/ ) {
                warn "'$File' seems to be in Custom directory, but could not find original file '$OrigFile'."
            }

            next FILE;
        }

        my $CurrentCommit = `git --no-pager log -n 1 --pretty=format:%H -- $OrigFile` || '';
        my $LastCommit = `grep -P '^(#|//) \\\$origin:' $File`;

        # do nothing if the file is still up to date
        next FILE if ( $LastCommit && $LastCommit =~ /$CurrentCommit/ );

        # else vimdiff and change the commit line
        print "vimdiff $OrigFile $File #and update \$origin\n";
        system "vimdiff $OrigFile $File; mv $File $File.tmp.shouldnotsee";

        open my $in,  "< $File.tmp.shouldnotsee" or ( warn "Could not open $File.tmp.shouldnotsee to read. Please check!\n" && next FILE );
        open my $out, "> $File" or ( warn "Could not open $File to write. Please check!\n" && next FILE );
        while ( <$in> ) {
            print $out $_;
            if ( /^# Copyright/ ) {
                until ( /^# --\s*$/ || !$_ ) {
                    $_ = <$in>;
                    print $out $_ if defined $_;
                }
                if ( $_ ) {
                    print $out "# \$origin: $Program - $CurrentCommit - $OrigFile\n# --\n";
                }

                # check whether $origin was already present
                $_ = <$in>;
                if ( /\$origin/ ) {
                    # skip the old origin and one "# --"
                    $_ = <$in>;
                }
                else {
                    print $out $_;
                }

                while ( <$in> ) { print $out $_ }
            }
            elsif ( /^\/\/ Copyright/ ) {
                until ( /^\/\/ --\s*$/ || !$_ ) {
                    $_ = <$in>;
                    print $out $_ if defined $_;
                }
                if ( $_ ) {
                    print $out "// \$origin: $Program - $CurrentCommit - $OrigFile\n// --\n";
                }

                # check whether $origin was already present
                $_ = <$in>;
                if ( /\$origin/ ) {
                    # skip the old origin and one "# --"
                    $_ = <$in>;
                }
                else {
                    print $out $_;
                }

                while ( <$in> ) { print $out $_ }
            }
        }

        close $in;
        system "rm $File.tmp.shouldnotsee";
    }

    return 1;
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub CleanF {

    my $Pack = $_[0] || $CurrPack;
    if ( !$Pack ) {
        die "Package directory needed.\n";
    }
    if ( !-e $Pack ) {
        die "'$Pack' does not exist.\n";
    }

    my @FileList = `find $Pack -path $Pack/.git -prune -o -type f -print`;

    for my $File ( @FileList ) {
        chomp($File);
        $File =~ s/^\.?\/?$Pack\/+//;

        if ( -l $File ) {
            print "Deleting link '$File' and restoring pp_backup if it is present.\n";
            system "rm $File";

            if ( -e "$File.pp_backup" ) {
                system "mv $File.pp_backup $File";
            }
        }

        elsif ( -e $File ) {
            warn "Skipping existing file '$File' as it is not a softlink.\n";
        }
    }

    my $IsInstalled;
    if ( $Program eq 'otobo' ) {
        $IsInstalled = PrepareInstalled( Mode => 'Clean' );
    }

    print "To complete this step, you probably want to run:\nbin/otobo.Console.pl Maint::Config::Rebuild --cleanup\n";

    return 1;
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub SOPM {

    my $Name;
    my $Pack;
    for my $File ( @_ ) {
        if ( -e $File && -d $File ) {
            if ( $Pack ) {
                die "Cannot interpret two directories given with Prepare command: Please exclude '$Pack' or '$File'.\n";
            }
            $Pack = $File;
        }
        else {
            if ( $Name ) {
                die "Decide on one name please. Either '$Name' or '$File'.\n";
            }
            $Name = $File;
        }
    }
    $Pack = $Pack || $CurrPack;

    if ( !$Name ) {
        die "A Name has to be provided.\n";
    }
    if ( !$Pack ) {
        die "Package directory needed.\n";
    }
    if ( -e "$Pack/$Name.sopm" ) {
        die "$Pack/$Name.sopm already exists!\n";
    }

    # try to derive framework version
    my $FrameworkVersion = '10.0.x';
    my $PackageVersion   = '10.0.0';
    if ( -e "RELEASE" ) {
        open my $release, "<", "RELEASE";
        while (my $line = <$release>) {
            if ( $line =~ /^VERSION = (?<major>\d{2})\.(?<minor>\d{1})\.(\d{1}|x)$/ ) {
                $FrameworkVersion = "$+{major}.$+{minor}.x";
                $PackageVersion   = "$+{major}.$+{minor}.0";
            }
        }
        close $release;
    }

    my @FileList = `find $Pack -path $Pack/.git -prune -o -type f -print | sort`;

    open my $sopm, "> $Pack/$Name.sopm" or die "Could not open $Pack/$Name.sopm to write:\n$!\n";

    print $sopm
'<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.0">
    <Name>'.$Name.'</Name>
    <Version>'.$PackageVersion.'</Version>
    <Framework>'.$FrameworkVersion.'</Framework>
    <Vendor>Rother OSS GmbH</Vendor>
    <URL>https://otobo.io/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">..</Description>
    <Filelist>
';

    for my $File ( @FileList ) {
        chomp($File);
        $File =~ s/^\.?\/?$Pack\/+//;
        print $sopm "        <File Permission=\"660\" Location=\"$File\" />\n";
    }

    print $sopm
'    </Filelist>
</otobo_package>
';

    return 1;
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub GetProgram {
    open my $Rel, "< RELEASE" or return '';

    while ( <$Rel> ) {
        if ( /^\s*product\s*=\s*(otrs|otobo)/i ) { return lc $1 }
    }

    return '';
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub SetPack {
    if ( !$_[0] || !-d $_[0] ) {
        $_[0] .= '';
        die "Please provide the directory of the package. '$_[0]' is invalid.\n";
    }

    if ( -e "$0.tmp_setpack" ) {
        die "$0.tmp_setpack exists. Cannot execute.\n";
    }

    open my $orig, "< $0" or die "Cannot open $0 to read.\n";
    open my $new, "> $0.tmp_setpack" or die "Cannot open $0.tmp_setpack to write.\n";

    WHILE:
    while ( <$orig> ) {
        if ( /^\s*my\s+\$CurrPack/ ) {
            print $new "my \$CurrPack = '$_[0]';\n";
            last WHILE;
        }
        print $new $_;
    }
    while ( <$orig> ) { print $new $_ }

    system "mv $0.tmp_setpack $0; chmod +x $0;";
}

#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+#

sub PrepareInstalled {
    my %Param = @_;

    my $SOPM = `find $CurrPack -name \\*.sopm`;

    return if !$SOPM;

    chomp $SOPM;

    use lib '.';
    use lib 'Kernel/cpan-lib';
    use lib 'Custom';

    eval {
        require Kernel::System::ObjectManager;
    };
    return if $@;

    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my $FileString  = $MainObject->FileRead( Location => $SOPM );
    my %Structure   = $PackageObject->PackageParse( String => $FileString );

    return if !$Structure{Name}{Content};

    my $IsInstalled = $PackageObject->PackageIsInstalled( Name => $Structure{Name}{Content} );

    return if !$IsInstalled;

    print "$Structure{Name}{Content} is already installed.\n";

    my $OrigPackage;
    my %OrigStructure;
    my $DeployOK;
    INST:
    for my $Package ( $PackageObject->RepositoryList() ) {
        next INST if $Package->{Name}->{Content} ne $Structure{Name}{Content};

        $DeployOK = $PackageObject->DeployCheck(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
        );

        # get package
        $OrigPackage   = $PackageObject->RepositoryGet(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
            Result  => 'SCALAR',
        );
        %OrigStructure = $PackageObject->PackageParse( String => $OrigPackage );

        last INST;
    }

    for ( $Param{Mode} ) {
        if ( 'Init' ) {
            if ( !$DeployOK ) {
                warn "$Structure{Name}{Content} is not installed correctly. Not changing it.\n";

                return;
            }

            print "Deleting installed package files to prepare for substitution.\n";
            for my $File ( $OrigStructure{Filelist}->@* ) {
                system "rm $File->{Location}";
            }

            return 1;
        }
        elsif ( 'Clean' ) {
            if ( $DeployOK ) {
                print "$Structure{Name}{Content} is already installed correctly. Not changing it.\n";

                return;
            }

            print "Reinstall original package.\n";

            return $PackageObject->PackageReinstall( String => $OrigPackage );
        }
        else {
            warn "No orders given.\n";
        }
    }

    return;
}
