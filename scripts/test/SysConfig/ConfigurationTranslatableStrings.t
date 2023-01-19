# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

use Kernel::System::VariableCheck qw(:all);

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Get system home directory.
my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Read Sample.xml
my $XMLImputRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => "$Home/scripts/test/sample/SysConfig/XML/Sample.xml",
    Mode     => 'utf8',
);
$Self->IsNot(
    $XMLImputRef,
    undef,
    "FileRead() for Sample.xml",
);

my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');
my $SysConfigObject    = $Kernel::OM->Get('Kernel::System::SysConfig');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput    => ${$XMLImputRef},
    XMLFilename => 'Sample.xml',
);

for my $Setting ( sort @DefaultSettingAddParams ) {

    my $SettingName = $Setting->{XMLContentParsed}->{Name};

    $Self->Is(
        ref $Setting,
        'HASH',
        "SettingListParse() for $SettingName structure"
    );
    $Self->IsNot(
        scalar keys %{$Setting},
        0,
        "SettingListParse() for $SettingName cardinality"
    );

    # Extract translations for each parsed setting (results are saved in SysConfig object $Self)
    $SysConfigObject->_ConfigurationTranslatableStrings( Data => $Setting );
}

my %ExpectedResults = (
    'All tickets with reminder'                                               => 1,
    'Check UTF-8.'                                                            => 1,
    'Defines the next state of a ticket.'                                     => 1,
    'Event module that updates customer user object name for dynamic fields.' => 1,
    'Frontend module registration.'                                           => 1,
    'Left'                                                                    => 1,
    'Loader module registration for the agent interface.'                     => 1,
    'Overview of all open Tickets.'                                           => 1,
    'Parameters with UTF8 ∂ç≈ßčćđšžå'                             => 1,
    'Reminder Tickets'                                                        => 1,
    'Restores a ticket from the archive.'                                     => 1,
    'Right'                                                                   => 1,
    'Service view'                                                            => 1,
    'ServiceView'                                                             => 1,
    'Sets the default body text for notes.'                                   => 1,
    'Shows a list of all the involved agents.'                                => 1,
    'Specifies the available note types.'                                     => 1,
    'The format of the subject.'                                              => 1,
    'The identifier for a ticket.'                                            => 1,
);

# Get actual results from SysConfig object
my $Result = $SysConfigObject->{ConfigurationTranslatableStrings};
$Self->Is(
    ref $Result,
    'HASH',
    "\$SysConfigObject->{ConfigurationTranslatableStrings} structure",
);
$Self->IsNot(
    scalar keys %{$Result},
    0,
    "\$SysConfigObject->{ConfigurationTranslatableStrings} cardinality",
);

# Compare actual results with expected ones
$Self->IsDeeply(
    $Result,
    \%ExpectedResults,
    "\$SysConfigObject->{ConfigurationTranslatableStrings} result",
);

# Check full function
my @TranslatableStrings = $SysConfigObject->ConfigurationTranslatableStrings();
$Self->IsNot(
    scalar @TranslatableStrings,
    0,
    "ConfigurationTranslatableStrings() cardinality (Full)",
);

$Self->DoneTesting();
