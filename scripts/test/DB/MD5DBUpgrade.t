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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# Test the MD5 function in MySQL and in PostgreSQL
# Implicitly this script also tests Kernel::System::Main::MD5sum.

# get needed objects
my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

# create database for tests
my $XML = '
<Table Name="test_md5_conversion">
    <Column Name="message_id" Required="true" Size="3800" Type="VARCHAR"/>
    <Column Name="message_id_md5" Required="false" Size="32" Type="VARCHAR"/>
</Table>
';
my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );
my @SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

# create data
my %MessageIDs;
my $Success;

INSERT:
for ( 1 .. 10_000 ) {

    my $RandomString = $MainObject->GenerateRandomString( Length => 50 );
    $MessageIDs{$RandomString} = $MainObject->MD5sum( String => $RandomString );
    $Success = $DBObject->Do(
        SQL => 'INSERT INTO test_md5_conversion ( message_id )'
            . ' VALUES ( ? )',
        Bind => [ \$RandomString ],
    );

    last INSERT unless $Success;
}
$Self->True( $Success, '10000 INSERTs ok' );

# conversion to MD5
if (
    $DBObject->GetDatabaseFunction('Type') eq 'mysql'
    || $DBObject->GetDatabaseFunction('Type') eq 'postgresql'
    )
{
    $Self->True(
        $DBObject->Do(
            SQL => 'UPDATE test_md5_conversion SET message_id_md5 = MD5(message_id)'
            )
            || 0,
        "UPDATE statement",
    );
}
else {

    my %MD5sum;
    $DBObject->Prepare(
        SQL => 'SELECT message_id, message_id_md5
                    FROM test_md5_conversion
                ',
    );
    MESSAGEID:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        next MESSAGEID if !$Row[0];
        $MD5sum{ $Row[0] } = $MainObject->MD5sum( String => $Row[0] );
    }

    for my $MessageID ( sort keys %MD5sum ) {
        $DBObject->Do(
            SQL => "UPDATE test_md5_conversion
                     SET message_id_md5 = ?
                     WHERE message_id = ?",
            Bind => [ \$MD5sum{$MessageID}, \$MessageID ],
        );
    }

}

# test conversion
my $PrepareSuccess = $DBObject->Prepare(
    SQL => 'SELECT message_id, message_id_md5 FROM test_md5_conversion',
);
if ( !$PrepareSuccess ) {

    done_testing();

    exit 0;
}

my $Result = 1;

RESULT:
while ( my @Row = $DBObject->FetchrowArray() ) {
    next RESULT if $Row[1] eq $MessageIDs{ $Row[0] };

    $Result = 0;
}

$Self->True( $Result, 'Conversion result' );

# cleanup
$Self->True(
    $DBObject->Do( SQL => 'DROP TABLE test_md5_conversion' ) || 0,
    "Do() DROP TABLE",
);

done_testing();
