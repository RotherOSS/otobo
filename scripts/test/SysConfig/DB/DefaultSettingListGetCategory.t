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
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.1">
    <Name>TestPackage1</Name>
    <Version>0.0.1</Version>
    <Vendor>Rother OSS GmbH</Vendor>
    <URL>https://otobo.io/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">TestPackage1.</Description>
    <Framework>10.1.x</Framework>
    <BuildDate>2016-10-11 02:35:46</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdG9ib19jb25maWcgdmVyc2lvbj0iMi4wIiBpbml0PSJBcHBsaWNhdGlvbiI+CiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTE6OlNldHRpbmcxIiBSZXF1aXJlZD0iMCIgVmFsaWQ9IjEiPiAKICAgICAgICA8RGVzY3JpcHRpb24gVHJhbnNsYXRhYmxlPSIxIj5UZXN0IFNldHRpbmcuPC9EZXNjcmlwdGlvbj4KICAgICAgICA8S2V5d29yZHM+VGVzdFBhY2thZ2U8L0tleXdvcmRzPgogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlPC9OYXZpZ2F0aW9uPgogICAgICAgICAgICA8VmFsdWU+CiAgICAgICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IlN0cmluZyI+PC9JdGVtPgogICAgICAgICAgICA8L1ZhbHVlPgogICAgPC9TZXR0aW5nPgo8L290b2JvX2NvbmZpZz4K</File>
    </Filelist>
</otobo_package>
';

my $String2 = '<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.1">
    <Name>TestPackage2</Name>
    <Version>0.0.1</Version>
    <Vendor>Rother OSS GmbH</Vendor>
    <URL>https://otobo.io/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">TestPackage2.</Description>
    <Framework>10.1.x</Framework>
    <BuildDate>2016-10-11 02:36:29</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage2.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdG9ib19jb25maWcgdmVyc2lvbj0iMi4wIiBpbml0PSJBcHBsaWNhdGlvbiI+CiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTI6OlNldHRpbmcxIiBSZXF1aXJlZD0iMCIgVmFsaWQ9IjEiPgogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlPC9OYXZpZ2F0aW9uPgogICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJTdHJpbmciPjwvSXRlbT4KICAgICAgICA8L1ZhbHVlPgogICAgPC9TZXR0aW5nPgogICAgPFNldHRpbmcgTmFtZT0iVGVzdFBhY2thZ2UyOjpTZXR0aW5nMiIgUmVxdWlyZWQ9IjAiIFZhbGlkPSIxIj4KICAgICAgICA8RGVzY3JpcHRpb24gVHJhbnNsYXRhYmxlPSIxIj5UZXN0IFNldHRpbmcuPC9EZXNjcmlwdGlvbj4KICAgICAgICA8TmF2aWdhdGlvbj5Db3JlOjpUZXN0UGFja2FnZTwvTmF2aWdhdGlvbj4KICAgICAgICA8VmFsdWU+CiAgICAgICAgICAgIDxJdGVtIFZhbHVlVHlwZT0iU3RyaW5nIj48L0l0ZW0+CiAgICAgICAgPC9WYWx1ZT4KICAgIDwvU2V0dGluZz4KPC9vdG9ib19jb25maWc+Cg==</File>
    </Filelist>
</otobo_package>
';

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# Cleanup the system.
for my $PackageName (qw(TestPackage1 TestPackage2)) {
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackageRemove = $PackageObject->PackageUninstall(
            Name    => $PackageName,
            Version => '0.0.1',
        );

        $Self->True(
            $PackageRemove,
            "PackageUninstall() $PackageName",
        );
    }
}
my $Counter = 0;
for my $PackageString ( $String, $String2 ) {
    $Counter++;
    my $PackageName = "TestPackage$Counter";
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackagUninstall = $PackageObject->PackageUninstall( String => $PackageString );

        $Self->True(
            $PackagUninstall,
            "PackageUninstall() $PackageName",
        );
    }

    my $PackageInstall = $PackageObject->PackageInstall( String => $PackageString );
    $Self->True(
        $PackageInstall,
        "PackageInstall() $PackageName",
    );
}

my @Tests = (
    {
        Name   => 'TestPackage1',
        Config => {
            Category      => 'TestPackage1',
            CategoryFiles => ['TestPackage1.xml'],
        },
        ExpectedResults => {
            'TestPackage1::Setting1' => 1,
        },
    },
    {
        Name   => 'TestPackage2',
        Config => {
            Category      => 'TestPackage2',
            CategoryFiles => ['TestPackage2.xml'],
        },
        ExpectedResults => {
            'TestPackage2::Setting1' => 1,
            'TestPackage2::Setting2' => 1,
        },
    },
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

for my $Test (@Tests) {
    my @List = $SysConfigDBObject->DefaultSettingListGet( %{ $Test->{Config} } );

    my %Results = map { $_->{Name} => 1 } @List;

    $Self->IsDeeply(
        \%Results,
        $Test->{ExpectedResults},
        "$Test->{Name} DefaultSettingListGet() Category Search",
    );
}

my @List2 = $SysConfigDBObject->DefaultSettingList();
$Self->True(
    scalar @List2,
    'DefaultSettingList() returned some value.'
);
for my $Item (@List2) {
    my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
        DefaultID => $Item->{DefaultID},
    );
    if ( $DefaultSetting{Name} ne $Item->{Name} ) {
        $Self->Is(
            $Item->{Name},
            $DefaultSetting{Name},
            "DefaultSettingList() is DIFFERENT from DefaultSettingGet() for ID $Item->{DefaultID} .",
        );
    }

    # would produce +1000 tests - that would be alsways OK
    # else {
    #     $Self->Is(
    #         $List2{$ID},
    #         $DefaultSetting{Name},
    #         "DefaultSettingList() has same data as DefaultSettingGet() for $ID .",
    #     );
    # }
}

# Cleanup the system.
$Counter = 0;
for my $PackageString ( $String, $String2 ) {
    $Counter++;
    my $PackageName = "TestPackage$Counter";
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackagUninstall = $PackageObject->PackageUninstall( String => $PackageString );

        $Self->True(
            $PackagUninstall,
            "PackagUninstall() $PackageName",
        );
    }
}

$Self->DoneTesting();
