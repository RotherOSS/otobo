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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Unregister all notification modules.
$Helper->ConfigSettingChange(
    Valid => 0,
    Key   => 'Frontend::NotifyModule',
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::Output::HTML::Layout' => {
        UserID => 1,
    },
);
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

# here everyone can insert example data for the tests
my %Data = (
    Created                   => '2007-11-30 08:58:54',
    CreateTime                => '2007-11-30 08:58:54',
    ChangeTime                => '2007-11-30 08:58:54',
    TicketFreeTime            => '2007-11-30 08:58:54',
    TicketFreeTime1           => '2007-11-30 08:58:54',
    TicketFreeTime2           => '2007-11-30 08:58:54',
    TimeStartMax              => '2007-11-30 08:58:54',
    TimeStopMax               => '2007-11-30 08:58:54',
    UpdateTimeDestinationDate => '2007-11-30 08:58:54',
    Body                      => "What do you\n mean with body?"
);

my $StartTime = time();

# --------------------------------------------------------------------#
# Search for $Data{""} etc. because this is the most dangerous bug if you
# modify the Output function
# --------------------------------------------------------------------#

# check the header
my $Header     = $LayoutObject->Header( Title => 'HeaderTest' );
my $HeaderFlag = 1;
if (
    $Header =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $Header =~ m{ <dtl \W if }msx
    )
{
    $HeaderFlag = 0;

}
$Self->True(
    $HeaderFlag,
    'Header() check the output for not replaced variables',
);

# check the navigation bar
my $NavigationBar  = $LayoutObject->NavigationBar();
my $NavigationFlag = 1;
if (
    $NavigationBar =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $NavigationBar =~ m{ <dtl \W if }msx
    )
{
    $NavigationFlag = 0;
}
$Self->True(
    $NavigationFlag,
    'NavigationBar() check the output for not replaced variables',
);

# check the footer
my $Footer     = $LayoutObject->Footer();
my $FooterFlag = 1;
if (
    $Footer =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) }msx
    || $Footer =~ m{ <dtl \W if }msx
    )
{
    $FooterFlag = 0;
}
$Self->True(
    $FooterFlag,
    'Footer() check the output for not replaced variables',
);

# check all dtl files
my $HomeDirectory = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $DTLDirectory  = $HomeDirectory . '/Kernel/Output/HTML/Templates/Standard/';
my $DIR;
if ( !opendir $DIR, $DTLDirectory ) {
    note("Can not open Directory: $DTLDirectory");
    done_testing();

    exit 0;
}

my @Files = ();
while ( defined( my $Filename = readdir $DIR ) ) {
    if ( $Filename =~ m{ \. dtl $}xms ) {
        push( @Files, "$DTLDirectory/$Filename" );
    }
}
closedir $DIR;

for my $File (@Files) {
    if ( $File =~ m{ / ( [^/]+ ) \. dtl}smx ) {
        my $DTLName = $1;

        # find all blocks auf the dtl files
        my $ContentARRAYRef = $MainObject->FileRead(
            Location => $File,
            Result   => 'ARRAY'
        );
        my @Blocks             = ();
        my %DoubleBlockChecker = ();
        for my $Line ( @{$ContentARRAYRef} ) {
            if ( $Line =~ m{ <!-- \s{0,1} dtl:block: (.+?) \s{0,1} --> }smx ) {
                if ( !$DoubleBlockChecker{$1} ) {
                    push @Blocks, $1;
                }
            }
        }

        # call all blocks
        for my $Block (@Blocks) {

            # do it three times (its more realistic)
            for ( 1 .. 3 ) {
                $LayoutObject->Block(
                    Name => $Block,
                    Data => \%Data,
                );
            }
        }

        # call the output function
        my $Output = $LayoutObject->Output(
            TemplateFile => $DTLName,
            Data         => \%Data,
        );
        my $OutputFlag = 1;
        if (
            $Output =~ m{ \$ (QData|LQData|Data|Env|QEnv|Config|Include) \{" }msx
            || $Output =~ m{ <dtl \W if }msx
            )
        {
            $OutputFlag = 0;
        }
        $Self->True(
            $OutputFlag,
            "Output() check the output for not replaced variables in $DTLName",
        );
    }
}

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
