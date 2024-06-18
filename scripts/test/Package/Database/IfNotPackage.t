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

use Test2::V0;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# Do not use RestoreDatabae here, in our tests the first contained package remains installed
#   with this option.
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $PackageAction = sub {
    my %Param = @_;

    my $FileString = $Param{FileString};

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my $Success;
    if ( $Param{Action} eq 'Install' ) {
        $Success = $PackageObject->PackageInstall(
            String => $FileString,
            Force  => 1,
        );

        $Self->True(
            $Success,
            "$Param{TestName} PackageInstall()"
        );
    }
    elsif ( $Param{Action} eq 'Uninstall' ) {
        $Success = $PackageObject->PackageUninstall(
            String => $FileString,
            Force  => 1,
        );

        $Self->True(
            $Success,
            "$Param{TestName} PackageUninstall()"
        );
    }

    return $Success;
};

my $TableExists = sub {
    my %Param = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TableNames = map { lc $_ => 1 } $DBObject->ListTables();

    return 0 if !$TableNames{ lc $Param{Table} };

    return 1;
};

my $ExecuteXMLDBString = sub {

    my %Param = @_;

    # Check needed stuff.
    if ( !$Param{XMLString} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need XMLString!",
        );
        return;
    }

    my $XMLString = $Param{XMLString};

    # Create database specific SQL and PostSQL commands out of XML.
    my @SQL;
    my @SQLPost;
    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # Create database specific SQL.
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # Create database specific PostSQL.
    push @SQLPost, $DBObject->SQLProcessorPost();

    # Execute SQL.
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );

        note $SQL;

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );

            return;
        }
    }

    return 1;
};

# get OTOBO Version
my $OTOBOVersion = $Kernel::OM->Get('Kernel::Config')->Get('Version');

# leave only major and minor level versions
$OTOBOVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTOBOVersion .= '.x';

my $RandomID = $Helper->GetRandomID();

my %Packages = (
    'Package1' => << "EOF",
<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.1">
    <Name>Package1$RandomID</Name>
    <Version>1.0.1</Version>
    <Vendor>Rother OSS GmbH</Vendor>
    <URL>https://otobo.io/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">OTOBO Community Edition. For more information, please have a look at the official documentation at https://doc.otobo.org/doc/manual/otobo-business-solution/6.0/en/html/.</Description>
    <Framework>$OTOBOVersion</Framework>
    <PackageIsVisible>1</PackageIsVisible>
    <PackageIsDownloadable>1</PackageIsDownloadable>
    <PackageIsRemovable>1</PackageIsRemovable>
    <BuildDate>2016-03-04 18:02:26</BuildDate>
    <BuildHost>otobo.master.mandalore.com</BuildHost>
    <DatabaseInstall Type="post" IfNotPackage="Package2$RandomID">
        <TableCreate Type="post" Name="$RandomID">
            <Column AutoIncrement="true" Name="id" PrimaryKey="true" Required="true" Type="BIGINT"></Column>
            <Column Name="name" Required="true" Size="200" Type="VARCHAR"></Column>
        </TableCreate>
    </DatabaseInstall>
</otobo_package>
EOF

    'Package2' => << "EOF",
<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.1">
    <Name>Package2$RandomID</Name>
    <Version>1.0.1</Version>
    <Vendor>Rother OSS GmbH</Vendor>
    <URL>https://otobo.io/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">OTOBO Community Edition. For more information, please have a look at the official documentation at https://doc.otobo.org/doc/manual/otobo-business-solution/6.0/en/html/.</Description>
    <Framework>$OTOBOVersion</Framework>
    <PackageIsVisible>1</PackageIsVisible>
    <PackageIsDownloadable>1</PackageIsDownloadable>
    <PackageIsRemovable>1</PackageIsRemovable>
    <BuildDate>2016-03-04 18:02:26</BuildDate>
    <BuildHost>otobo.master.mandalore.com</BuildHost>
</otobo_package>
EOF
);

my @Tests = (
    {
        Name            => 'Clean System',
        PackageInstall  => [ $Packages{Package1} ],
        ExpectedResults => 1,
    },
    {
        Name            => 'Installed Package',
        PackageInstall  => [ $Packages{Package2}, $Packages{Package1} ],
        ExpectedResults => 0,
    },
);

for my $Test (@Tests) {

    if ( $Test->{PackageInstall} ) {
        for my $Package ( @{ $Test->{PackageInstall} } ) {
            $PackageAction->(
                Action     => 'Install',
                TestName   => $Test->{Name},
                FileString => $Package,
            );
        }
    }

    my $Result = $TableExists->( Table => $RandomID );
    $Self->Is(
        $Result,
        $Test->{ExpectedResults},
        "$Test->{Name} TableExists: $Result"
    );

    if ($Result) {
        $ExecuteXMLDBString->( XMLString => "<TableDrop Name=\"$RandomID\" />" );
    }

    if ( $Test->{PackageInstall} ) {
        for my $Package ( @{ $Test->{PackageInstall} } ) {
            $PackageAction->(
                Action     => 'Uninstall',
                TestName   => $Test->{Name},
                FileString => $Package,
            );
        }
    }
}

done_testing;
