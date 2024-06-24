# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use Archive::Tar ();

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::VariableCheck qw(:all);

our $Self;

# get needed objects
my $ConfigObject                 = $Kernel::OM->Get('Kernel::Config');
my $MainObject                   = $Kernel::OM->Get('Kernel::System::Main');
my $SupportBundleGeneratorObject = $Kernel::OM->Get('Kernel::System::SupportBundleGenerator');
my $PackageObject                = $Kernel::OM->Get('Kernel::System::Package');
my $CSVObject                    = $Kernel::OM->Get('Kernel::System::CSV');
my $JSONObject                   = $Kernel::OM->Get('Kernel::System::JSON');
my $RegistrationObject           = $Kernel::OM->Get('Kernel::System::Registration');
my $SupportDataCollectorObject   = $Kernel::OM->Get('Kernel::System::SupportDataCollector');
my $TempObject                   = $Kernel::OM->Get('Kernel::System::FileTemp');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disabled the package deployment plugins, to avoid timeout issues in the test.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SupportDataCollector::DisablePlugins',
    Value => [
        'Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment',
    ],
);

# cleanup the Home variable (remove tailing "/")
my $Home = $ConfigObject->Get('Home');
$Home =~ s{\/\z}{};

my $ArchiveExists;
my $RandomNumber = $Helper->GetRandomNumber();
if ( !-e $Home . '/ARCHIVE' ) {

    # perfect time to test the missing ARCHVIVE
    my $Result = $SupportBundleGeneratorObject->Generate();

    ok( !$Result->{Success}, "Generate() - for a system without ARCHIVE file with false", );
}
else {
    $ArchiveExists = 1;
    my $Success = rename( $Home . '/ARCHIVE', $Home . '/ARCHIVE' . $RandomNumber );
    ok( $Success, "Found ARCHIVE file in a system, creating copy to restore it on the end of unit test." );
}

# create an ARCHIVE file on developer systems to continue working
my $ArchiveGeneratorTool = $Home . '/bin/otobo.CheckSum.pl';

# if tool is not present we can't continue
if ( !-e $ArchiveGeneratorTool ) {
    fail("$ArchiveGeneratorTool does not exist, we can't continue");
    done_testing();

    exit 0;
}

# execute ARCHIVE generator tool
my $Result = `$ArchiveGeneratorTool -a create`;

if ( !-e $Home . '/ARCHIVE' || -z $Home . '/ARCHIVE' ) {

    # if ARCHIVE file is not present we can't continue
    $Self->True(
        0,
        "ARCHIVE file is not generated, we can't continue",
    );

    done_testing();

    exit 0;
}
else {
    pass("ARCHIVE file is generated for UnitTest purpose");

    # delete Kernel/Config.pm file from archive file
    my $ArchiveContent = $MainObject->FileRead(
        Location => $Home . '/ARCHIVE',
        Result   => 'ARRAY',
    );
    my $Output;
    my $File = 'Kernel/Config.pm';
    LINE:
    for my $Line ( @{$ArchiveContent} ) {
        if ( $Line =~ m(\A\w+::$File\n\z) ) {
            next LINE;
        }
        $Output .= $Line;
    }

    my $FileLocation = $MainObject->FileWrite(
        Location => $Home . '/ARCHIVE',
        Content  => \$Output,
    );
}

# get OTOBO Version
my $OTOBOVersion = $ConfigObject->Get('Version');

# leave only mayor and minor level versions
$OTOBOVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTOBOVersion .= '.x';

my $TestPackage = '<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.0">
  <Name>Test - ' . $RandomNumber . '</Name>
  <Version>0.0.1</Version>
  <Vendor>Rother OSS GmbH</Vendor>
  <URL>https://otobo.io/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
  <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <Framework>' . $OTOBOVersion . '</Framework>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="TestSBG" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="var/TestSBG" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otobo_package>
';

# tests for GenerateCustom Files Archive
my @CustomFilesArchiveTests = (
    {
        Name          => 'Framework - Only Config',
        RequiredFiles => ["$Home/Kernel/Config.pm"],
    },
    {
        Name          => 'Package - Only Config',
        RequiredFiles => ["$Home/Kernel/Config.pm"],
        ProhibitFiles => [
            "$Home/TestSBG",
            "$Home/var/TestSBG",
        ],
        InstallPackages => {
            Test => $TestPackage,
        },
    },
    {
        Name          => 'Package - Modified File',
        RequiredFiles => [
            "$Home/Kernel/Config.pm",
            "$Home/var/TestSBG",
        ],
        ProhibitFiles => [
            "$Home/TestSBG",
        ],
        ModifyFiles => [
            "$Home/var/TestSBG",
        ],
        UninstallPackages => {
            Test => $TestPackage,
        },
    },
);

my @FilesToDelete;
for my $Test (@CustomFilesArchiveTests) {

    # prepare testing environment
    if ( IsHashRefWithData( $Test->{InstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{InstallPackages} } ) {
            my $Success = $PackageObject->PackageInstall( String => $Test->{InstallPackages}->{$Package} );
            ok( $Success, "$Test->{Name}: PackageInstall() - Package:'$Package' with True", );
        }
    }

    if ( IsArrayRefWithData( $Test->{ModifyFiles} ) ) {

        for my $File ( @{ $Test->{ModifyFiles} } ) {

            # this operation is destructive be aware of it!
            my $Content = $Helper->GetRandomID();
            $Content .= "\n";
            my $FileLocation = $MainObject->FileWrite(
                Location => $File,
                Content  => \$Content,
            );
            $Self->IsNot(
                $FileLocation,
                undef,
                "$Test->{Name}: Modified File - $File"
            );
            push @FilesToDelete, $File;
        }
    }

    # execute function
    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateCustomFilesArchive();

    $Self->IsNot(
        bytes::length( ${$Content} ) / ( 1024 * 1024 ),
        0,
        "$Test->{Name}: GenerateCustomFilesArchive() - The size of the application.tar is not 0",
    );
    my $ExpectedFilename = 'application.tar';
    if ( $Filename =~ m{\.gz\z} ) {
        $ExpectedFilename .= '.gz';
    }
    $Self->Is(
        $Filename,
        $ExpectedFilename,
        "$Test->{Name}: GenerateCustomFilesArchive() - Filename"
    );

    # save as a tmp file
    my ( $FileHandle, $TmpFilename ) = $TempObject->TempFile();
    binmode $FileHandle;
    print $FileHandle ${$Content};
    close $FileHandle;

    # new instance from tar object
    my $TarObject = Archive::Tar->new();

    # get files from tar
    my $FileCount = $TarObject->read($TmpFilename);
    $Self->IsNot(
        $FileCount,
        undef,
        "$Test->{Name}: GenerateCustomFilesArchive() - The number of files within application.tar should not be undef",
    );
    my @FileList = $TarObject->get_files();

    # create a lookup table (@FileList contains Archive::Tar::File objects)
    my %FileListLookup = map { $_->full_path() => 1 } sort @FileList;

    # check for files that must be in the application.tar file
    if ( IsArrayRefWithData( $Test->{RequiredFiles} ) ) {
        for my $File ( @{ $Test->{RequiredFiles} } ) {

            # Remove leading slash; Archive::Tar 2.28+ allows absolute path names.
            $File =~ s{\A\/}{};
            $Self->True(
                $FileListLookup{$File} // $FileListLookup{"/$File"},
                "$Test->{Name}: GenerateCustomFilesArchive() - Required:'$File' is in the application.tar file",
            );
        }
    }

    # check for files that must be in the application.tar file
    if ( IsArrayRefWithData( $Test->{ProhibitFiles} ) ) {
        for my $File ( @{ $Test->{ProhibitFiles} } ) {

            # Remove leading slash; Archive::Tar 2.28+ allows absolute path names.
            $File =~ s{\A\/}{};
            $Self->False(
                $FileListLookup{$File} // $FileListLookup{"/$File"},
                "$Test->{Name}: GenerateCustomFilesArchive() - Prohibit'$File' is not the application.tar file",
            );
        }
    }

    # clean environment
    if ( IsHashRefWithData( $Test->{UninstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{UninstallPackages} } ) {
            my $Success = $PackageObject->PackageUninstall(
                String => $Test->{UninstallPackages}->{$Package}
            );
            ok( $Success, "$Test->{Name}: PackageUninstall() - Package:'$Package' with True" );
            for my $File (@FilesToDelete) {
                unlink $File . '.custom_backup';
            }
        }
    }
}

# tests for GeneratePackageList

my @GeneratePackageListTests = (
    {
        Name => 'No Packages',
    },
    {
        Name            => 'Test Package',
        InstallPackages => {
            Test => $TestPackage,
        },
        UninstallPackages => {
            Test => $TestPackage,
        },
    },
);

for my $Test (@GeneratePackageListTests) {

    my @OriginalList = $PackageObject->RepositoryList(
        Result => 'short',
    );

    # prepare testing environment
    if ( IsHashRefWithData( $Test->{InstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{InstallPackages} } ) {
            my $Success = $PackageObject->PackageInstall( String => $Test->{InstallPackages}->{$Package} );
            ok( $Success, "$Test->{Name}: PackageInstall() - Package:'$Package' with True" );
        }
    }

    # execute function
    my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GeneratePackageList();

    if ( $Test->{InstallPackages} || scalar @OriginalList ) {
        $Self->IsNot(
            bytes::length( ${$Content} ) / ( 1024 * 1024 ),
            0,
            "$Test->{Name}: GeneratePackageList() - The size of the InstalledPackages.csv is not 0",
        );
    }
    else {
        $Self->Is(
            bytes::length( ${$Content} ),
            0,
            "$Test->{Name}: GeneratePackageList() - The size of the InstalledPackages.csv is 0",
        );
    }
    $Self->Is(
        $Filename,
        'InstalledPackages.csv',
        "$Test->{Name}: GeneratePackageList() - Filename"
    );

    my @PackageListRaw = $PackageObject->RepositoryList( Result => 'Short' );

    my @PackageList;
    for my $Package (@PackageListRaw) {

        my @PackageData = (
            [
                $Package->{Name},
                $Package->{Version},
                $Package->{MD5sum},
                $Package->{Vendor},
            ],
        );

        push @PackageList, @PackageData;
    }

    my $RefArray = $CSVObject->CSV2Array(
        String => ${$Content},
    );

    $Self->IsDeeply(
        $RefArray,
        \@PackageList,
        "$Test->{Name}: GeneratePackageList() - Content"
    );

    # clean environment
    if ( IsHashRefWithData( $Test->{UninstallPackages} ) ) {

        for my $Package ( sort keys %{ $Test->{UninstallPackages} } ) {
            my $Success = $PackageObject->PackageUninstall(
                String => $Test->{UninstallPackages}->{$Package}
            );
            ok( $Success, "$Test->{Name}: PackageUninstall() - Package:'$Package' with True" );
        }
    }
}

# GenerateRegistrationInfo tests
my %RegistrationInfo = $RegistrationObject->RegistrationDataGet();

# execute function
my ( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateRegistrationInfo();

if (%RegistrationInfo) {
    $Self->IsNot(
        bytes::length( ${$Content} ) / ( 1024 * 1024 ),
        0,
        "GenerateRegistrationInfo() - The size of the RegistrationInfo.json is not 0",
    );
}

# by encoding an empty string into JSON it will produce '{}' which is exactly 2 bytes
else {
    $Self->Is(
        bytes::length( ${$Content} ),
        2,
        "GenerateRegistrationInfo() - The size of the  RegistrationInfo.json is 2",
    );
}
$Self->Is(
    $Filename,
    'RegistrationInfo.json',
    "GenerateRegistrationInfo() - Filename"
);

my $PerlStructureScalar = $JSONObject->Decode(
    Data => ${$Content},
);

if (%RegistrationInfo) {
    for my $Attribute (
        qw(
            FQDN OTOBOVersion OSType OSVersion DatabaseVersion PerlVersion
            Description SupportDataSending RegistrationKey APIKey State Type
        )
        )
    {
        $Self->IsNot(
            $PerlStructureScalar->{$Attribute},
            undef,
            "GenerateRegistrationInfo() - $Attribute should not be undef",
        );
        $Self->IsNot(
            $PerlStructureScalar->{$Attribute},
            '',
            "GenerateRegistrationInfo() - $Attribute should not be empty",
        );
    }
}

# GenerateSupportData tests
my %OriginalResult = $SupportDataCollectorObject->Collect(
    WebTimeout => 40,
);

# for this test we will just check that both results has the same identifiers
my %OriginalIdentifiers;
for my $Entry ( @{ $OriginalResult{Result} } ) {
    $OriginalIdentifiers{ $Entry->{Identifier} } = $Entry->{DisplayPath};
}
$OriginalResult{Result} = \%OriginalIdentifiers;

# for some strange reasons if mod_perl is activated, it happens that some times it uses it and
# sometimes is doesn't for this test we delete the possible offending identifiers
for my $Identifier (
    qw(
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheDBIUsed
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheReloadUsed
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModDeflateLoaded
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModHeadersLoaded
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL_API_VERSION
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::PERL_USE_UNSAFE_INC
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::LANGUAGE
    )
    )
{
    delete $OriginalResult{Result}->{$Identifier};
}

# execute function
( $Content, $Filename ) = $SupportBundleGeneratorObject->GenerateSupportData();

if (%OriginalResult) {
    $Self->IsNot(
        bytes::length( ${$Content} ) / ( 1024 * 1024 ),
        0,
        "GenerateSupportData() - The size of the SupportData.json is not 0",
    );
}
else {
    $Self->Is(
        bytes::length( ${$Content} ),
        0,
        "GenerateSupportData() - The size of the  SupportData.json is 0",
    );
}
$Self->Is(
    $Filename,
    'SupportData.json',
    "GenerateSupportData() - Filename"
);

$PerlStructureScalar = $JSONObject->Decode(
    Data => ${$Content},
);

my %NewIdentifiers;
for my $Entry ( @{ $PerlStructureScalar->{Result} } ) {
    $NewIdentifiers{ $Entry->{Identifier} } = $Entry->{DisplayPath};
}
$PerlStructureScalar->{Result} = \%NewIdentifiers;

# for some strange reasons if mod_perl is activated, it happens that some times it uses it and
# sometimes is doesn't for this test we delete the possible offending identifiers
for my $Identifier (
    qw(
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheDBIUsed
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ApacheReloadUsed
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModDeflateLoaded
        Kernel::System::SupportDataCollector::Plugin::Webserver::Apache::Performance::ModHeadersLoaded
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::MOD_PERL_API_VERSION
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::PERL_USE_UNSAFE_INC
        Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables::LANGUAGE
    )
    )
{
    delete $PerlStructureScalar->{Result}->{$Identifier};
}

$Self->IsDeeply(
    \%OriginalResult,
    $PerlStructureScalar,
    "GenerateSupportData() - Result",
);

# Generate ZZZZUnitTestMaskPasswords.pm to check later for mask passwords.
my $MaskPasswordIdentifier = $Helper->GetRandomNumber() . 'MaskPasswords';
my $MaskPasswordFile       = 'ZZZZUnitTest' . $MaskPasswordIdentifier . '.pm';
my $MaskPasswordContent    = <<"END_CUSTOM_CODE";
# OTOBO config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZZUnitTest$MaskPasswordIdentifier;
use strict;
use warnings;
no warnings \'redefine\';
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;

    # Simple tests.
    \$Self->{DatabasePw} = 'some-pass';
    \$Self->{'DatabasePw'} = 'some-pass2';
    \$Self->{'Customer::AuthModule::DB::CustomerPassword'} = 'password123';
    \$Self->{'Customer::AuthModule::DB::Password'} = 'password456';

    # Complex tests.
    \$Self->{CustomerUser} = {
        Name   => 'Database Backend',
        Module => 'Kernel::System::CustomerUser::DB',
        Params => {
           User => 'OTOBO',
           Password => 'secure-password',
           Table => 'customer_user',
        },
    };

    \$Self->{CustomerUser} = {
        Name => 'LDAP Backend',
        Module => 'Kernel::System::CustomerUser::LDAP',
        Params => {
            # ldap host
            Host => 'bay.csuhayward.edu',

            # ldap base dn
            BaseDN => 'ou=seas,o=csuh',

            # search scope (one|sub)
            SSCOPE => 'sub',

            # The following is valid but would only be necessary if the
            # anonymous user does NOT have permission to read from the LDAP tree
            UserDN => 'UnitTester',
            UserPw => 'strong-secret-password',
        },
    };

    # HTTP credentials test.
    \$Self->{'DocumentSearch::Nodes'} = [
        {
            DNS  => 'https://elastic:search\@localhost:9200',
            Name => 'test',
        },
    ];
}
1;
END_CUSTOM_CODE

my @ExpectedResults = (
    {
        Name   => 'DatabasePw (normal)',
        Result => "\$Self->{DatabasePw} = 'xxx';",
    },
    {
        Name   => 'DatabasePw (with single quotes)',
        Result => "\$Self->{'DatabasePw'} = 'xxx';",
    },
    {
        Name   => 'CustomerPassword (Customer::AuthModule::DB::CustomerPassword)',
        Result => "\$Self->{'Customer::AuthModule::DB::CustomerPassword'} = 'xxx';",
    },
    {
        Name   => 'Password (Customer::AuthModule::DB::Password)',
        Result => "\$Self->{'Customer::AuthModule::DB::Password'} = 'xxx';",
    },
    {
        Name   => 'Password (CustomerUser DB backend)',
        Result => "Password => 'xxx'",
    },
    {
        Name   => 'UserPw (CustomerUser LDAP backend)',
        Result => "UserPw => 'xxx'",
    },
    {
        Name   => 'DNS (Document search nodes)',
        Result => "DNS  => 'https://[user]:[password]\@localhost:9200'"
    }
);

$Helper->CustomCodeActivate(
    Code       => $MaskPasswordContent,
    Identifier => $MaskPasswordIdentifier,
);

# Generate tests
$Result = $SupportBundleGeneratorObject->Generate();

ok( $Result->{Success}, "Generate() - With True", );
$Self->IsNot(
    bytes::length( $Result->{Data}->{Filecontent} ) / ( 1024 * 1024 ),
    0,
    "Generate() - The size of the file is not 0",
);
$Self->IsNot(
    bytes::length( $Result->{Data}->{Filecontent} ) / ( 1024 * 1024 ),
    $Result->{Data}->{Filesize},
    "Generate() - The size of the file",
);
$Self->IsNot(
    $Result->{Data}->{Filename},
    undef,
    "Generate() - Filename"
);

# save as a tmp file
my ( $FileHandle, $TmpFilename ) = $TempObject->TempFile();
binmode $FileHandle;
print $FileHandle ${ $Result->{Data}->{Filecontent} };
close $FileHandle;

# new instance from tar object
my $TarObject = Archive::Tar->new();

# get files from tar
my $FileCount = $TarObject->read($TmpFilename);
$Self->Is(
    $FileCount,
    5,
    "Generate() - The number of files",
);
my @FileList = $TarObject->get_files();

# create a lookup table (@FileList contains Archive::Tar::File objects)
my %FileListLookup = map { $_->name() => 1 } sort @FileList;

# check for files that must be in the tar file
my @ExpectedFiles   = qw(InstalledPackages.csv RegistrationInfo.json SupportData.json);
my $ApplicationFile = 'application.tar';
if ( $Result->{Data}->{Filename} =~ m{\.gz} ) {
    $ApplicationFile .= '.gz';
}
push @ExpectedFiles, $ApplicationFile;
for my $File (@ExpectedFiles) {
    $Self->True(
        $FileListLookup{$File},
        "Generate() - Required:'$File' is in the tar file",
    );
}

TARFILE:
for my $TarFile (@FileList) {

    next TARFILE if $TarFile->name() ne $ApplicationFile;

    my $TargetPath = $Home . '/' . $ApplicationFile;

    $TarFile->extract($TargetPath);
    $TarObject->read($TargetPath);

    my @List = $TarObject->get_files();

    FILE:
    for my $File (@List) {

        next FILE unless $File->name() eq $MaskPasswordFile;

        my $Content = $File->get_content();

        # Look for masked password settings.
        for my $Test (@ExpectedResults) {

            ok( index( $Content, $Test->{Result} ) > 0, "$Test->{Name} is masked." );
        }
    }

    my $Success = unlink $TargetPath;
    ok( $Success, "$TargetPath was deleted." );
}

# cleanup
my $Success = unlink $Home . '/ARCHIVE';
ok( $Success, "UnitTest ARCHIVE file is deleted" );

if ($ArchiveExists) {
    my $Success = rename( $Home . '/ARCHIVE' . $RandomNumber, $Home . '/ARCHIVE' );
    ok( $Success, "Original ARCHIVE file is restored" );
}

done_testing;
