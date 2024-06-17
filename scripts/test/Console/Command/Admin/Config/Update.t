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

use strict;
use warnings;
use v5.24;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my %DefaultSettingAddTemplate = (
    Description    => "Test.",
    Navigation     => "Core::Test",
    IsInvisible    => 0,
    IsReadonly     => 0,
    IsRequired     => 0,
    IsValid        => 1,
    HasConfigLevel => 0,
    XMLFilename    => 'UnitTest.xml',
);

my $SettingsXML = << 'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otobo_config version="2.0" init="Framework">
    <Setting Name="Test0" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
</otobo_config>
EOF

    # Get SysConfig XML object.
    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput    => $SettingsXML,
    XMLFilename => 'UnitTest.xml',
);

for my $Setting (@DefaultSettingAddParams) {

    my $Value = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
        Data => $Setting->{XMLContentParsed}->{Value},
    );

    $Setting->{EffectiveValue} = $SysConfigObject->SettingEffectiveValueGet(
        Value => $Value,
    );
}

my $RandomID = $HelperObject->GetRandomID();

# Get SysConfig DB object.
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DefaultID0 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[0] },
    Name                     => "Test0$RandomID",
    UserModificationPossible => 0,
    UserModificationActive   => 0,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID0,
    0,
    "DefaultSettingAdd() - Test0",
);

my $DefaultID1 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[1] },
    Name                     => "Test1$RandomID",
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID1,
    0,
    "DefaultSettingAdd() - Test1",
);

# Get testing random number
my $RandomNumber = $HelperObject->GetRandomNumber();

my $FileName = 'ConfigItem' . $RandomNumber;

my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $SourcePath = "$Home/var/tmp/$FileName.yaml";

# make sure the system is clean
if ( -e $SourcePath ) {

    my $Success = unlink $SourcePath;

    $Self->True(
        $Success,
        "Deleted temporary file $SourcePath with true",
    );
}

my @Tests = (
    {
        Name     => 'No Options',
        Options  => [],
        ExitCode => 1,
    },
    {
        Name     => 'Missing setting-name value',
        Options  => ['--setting-name'],
        ExitCode => 1,
    },
    {
        Name     => 'Missing source-path and value',
        Options  => [ '--setting-name', "Test0$RandomID" ],
        ExitCode => 1,
    },
    {
        Name     => 'Missing source-path value',
        Options  => [ '--setting-name', "Test0$RandomID", '--source-path' ],
        ExitCode => 1,
    },
    {
        Name     => 'Wrong setting-name',
        Options  => [ '--setting-name', 'ANOTVALIDSETTINGNAME', '--source-path', $SourcePath ],
        ExitCode => 1,
    },
    {
        Name     => 'source-path + value',
        Options  => [ '--setting-name', "Test0$RandomID", '--source-path', $SourcePath, '--value', 'Test' ],
        ExitCode => 1,
    },
    {
        Name     => 'Wrong source-path',
        Options  => [ '--setting-name', "Test0$RandomID", '--source-path', 'invalidpath' ],
        ExitCode => 1,
    },
    {
        Name     => 'Missing value value',
        Options  => [ '--setting-name', "Test0$RandomID", '--value' ],
        ExitCode => 1,
    },
    {
        Name        => 'Empty file source-path',
        YAMLContent => '',
        Options     => [ '--setting-name', "Test0$RandomID", '--source-path', $SourcePath ],
        ExitCode    => 1,
    },
    {
        Name        => 'Wrong content file source-path',
        YAMLContent => "---\nTest Update:\n-test",
        Options     => [ '--setting-name', "Test0$RandomID", '--source-path', $SourcePath ],
        ExitCode    => 1,
    },
    {
        Name           => 'Correct value',
        Options        => [ '--setting-name', "Test0$RandomID", '--value', 'Test Update 1', '--no-deploy' ],
        ExpectedResuts => 'Test Update 1',
        ExitCode       => 0,
    },
    {
        Name           => 'Correct content file source-path',
        YAMLContent    => "---\nTest Update 2",
        Options        => [ '--setting-name', "Test0$RandomID", '--source-path', $SourcePath, '--no-deploy' ],
        ExpectedResuts => 'Test Update 2',
        ExitCode       => 0,
    },
    {
        Name           => 'Correct empty value',
        Options        => [ '--setting-name', "Test0$RandomID", '--value', '', '--no-deploy' ],
        ExpectedResuts => '',
        ExitCode       => 0,
    },
    {
        Name     => 'Missing valid value',
        Options  => [ '--setting-name', "Test0$RandomID", '--valid', '--no-deploy' ],
        ExitCode => 1,
    },
    {
        Name     => 'Correct valid value - invalid',
        Options  => [ '--setting-name', "Test0$RandomID", '--valid', '0', '--no-deploy' ],
        ExitCode => 0,
        IsValid  => 0,
    },
    {
        Name     => 'Correct valid value - valid',
        Options  => [ '--setting-name', "Test0$RandomID", '--valid', '1', '--no-deploy' ],
        ExitCode => 0,
        IsValid  => 1,
    },
    {
        Name           => 'Reset config to default value',
        Options        => [ '--setting-name', "Test0$RandomID", '--reset', '--no-deploy' ],
        ExitCode       => 0,
        ExpectedResuts => 'Test',
        Test           => 1,
    },
);

# get needed objects
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::Update');

TEST:
for my $Test (@Tests) {

    if ( defined $Test->{YAMLContent} ) {

        # Write configuration in a file.
        my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $SourcePath,
            Content  => \$Test->{YAMLContent},
            Mode     => 'utf8',
        );

        $Self->IsNot(
            $FileLocation,
            undef,
            "$Test->{Name} FireWrite - SourcePath",
        );
    }

    my $ExitCode = $CommandObject->Execute( @{ $Test->{Options} } );

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name}",
    );

    next TEST if $Test->{ExitCode} == 1;

    my %Setting = $SysConfigObject->SettingGet(
        Name => $Test->{Options}->[1],
    );

    if ( defined $Test->{IsValid} ) {
        $Self->IsDeeply(
            $Setting{IsValid},
            $Test->{IsValid},
            "$Test->{Name} - IsValid check"
        );

        next TEST;
    }

    $Self->IsDeeply(
        $Setting{EffectiveValue},
        $Test->{ExpectedResuts},
        "$Test->{Name} - EffectiveValue check",
    );
}

# remember to clean the system
if ( -e $SourcePath ) {

    my $Success = unlink $SourcePath;

    $Self->True(
        $Success,
        "Deleted temporary file $SourcePath with true",
    );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
