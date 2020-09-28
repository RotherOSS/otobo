# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new();

$Self->True( $Kernel::OM, 'Could build object manager' );

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# depending on the config some missing modules can be ignored
my $SkipCryptSMIME;
if ( !$ConfigObject->Get('SMIME') ) {
    $SkipCryptSMIME = 1;
}

my $SkipCryptPGP;
if ( !$ConfigObject->Get('PGP') ) {
    $SkipCryptPGP = 1;
}

my $SkipChat;
if ( !$ConfigObject->Get('ChatEngine::Active') ) {
    $SkipChat = 1;
}

my $SkipCalendar;
if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar', Silent => 1 ) ) {
    $SkipCalendar = 1;
}

my $SkipTeam;
if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {
    $SkipTeam = 1;
}

my $Home = $ConfigObject->Get('Home');

# get main object
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my %OperationChecked;

my @DirectoriesToSearch = (
    '/bin',
    '/Custom/Kernel/Output',
    '/Custom/Kernel/System',
    '/Kernel/GenericInterface',
    '/Kernel/Output',
    '/Kernel/System',
    '/var/packagesetup'
);

for my $Directory ( sort @DirectoriesToSearch ) {
    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Home . $Directory,
        Filter    => [ '*.pm', '*.pl' ],
        Recursive => 1,
    );

    LOCATION:
    for my $Location (@FilesInDirectory) {
        my $ContentSCALARRef = $MainObject->FileRead(
            Location => $Location,
        );

        my $Module = $Location;
        $Module =~ s{$Home\/+}{}msx;

        # check if file contains a call to another module using Object manager
        #    for example: $Kernel::OM->Get('Kernel::Config')->Get('Home');
        #    the regular expression will match until $Kernel::OM->Get('Kernel::Config')->Get(
        #    including possible line returns
        #    for this example:
        #    $1 will contain Kernel::Config
        #    $2 will contain Get
        OPERATION:
        while (
            ${$ContentSCALARRef}
            =~ m{ \$Kernel::OM \s* -> \s* Get\( \s* '([^']+)'\) \s* -> \s* ([a-zA-Z1-9]+)\( }msxg
            )
        {

            # skip if the function for the object was already checked before
            next OPERATION if $OperationChecked{"$1->$2()"};

            # skip crypt object if it is not configured
            next OPERATION if $1 eq 'Kernel::System::Crypt::SMIME'          && $SkipCryptSMIME;
            next OPERATION if $1 eq 'Kernel::System::Crypt::PGP'            && $SkipCryptPGP;
            next OPERATION if $1 eq 'Kernel::System::Chat'                  && $SkipChat;
            next OPERATION if $1 eq 'Kernel::System::ChatChannel'           && $SkipChat;
            next OPERATION if $1 eq 'Kernel::System::VideoChat'             && $SkipChat;
            next OPERATION if $1 eq 'Kernel::System::Calendar'              && $SkipCalendar;
            next OPERATION if $1 eq 'Kernel::System::Calendar::Appointment' && $SkipCalendar;
            next OPERATION if $1 eq 'Kernel::System::Calendar::Team'        && $SkipTeam;

            # load object
            my $Object = $Kernel::OM->Get("$1");

            my $Success = $Object->can($2);

            $Self->True(
                $Success,
                "$Module | $1->$2()",
            );

            # remember the already checked operation
            $OperationChecked{"$1->$2()"} = 1;
        }
    }
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

$Self->DoneTesting();


