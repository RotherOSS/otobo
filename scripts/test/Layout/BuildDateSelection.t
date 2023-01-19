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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'TimeInputFormat',
    Value => 'Option',
);

my $SetConfig = sub {
    my %Param = @_;

    my $Success = $ConfigObject->Set(
        Key   => $Param{Key},
        Value => $Param{Value},
    );
    $Self->True(
        $Success,
        ( $Param{Message} || "SysConfig Set() for key $Param{Key}" ) . "with true",
    );
};

my @Tests = (

    {
        Name           => 'No options',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2016-02-10 09:04:23',                            # in OTOBO time zone
        Config         => {},
        ExpectedValue  => '<select id="Month" name="Month" title="Month">
  <option value="2" selected="selected">02</option>
</select>
<select class=" " id="Day" name="Day" title="Day">
  <option value="10" selected="selected">10</option>
</select>
<select id="Year" name="Year" title="Year">
  <option value="2016" selected="selected">2016</option>
</select>',
    },
    {
        Name           => 'No options',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2016-02-10 23:04:23',                            # in OTOBO time zone
        Config         => {},
        ExpectedValue  => '<select id="Month" name="Month" title="Month">
  <option value="2" selected="selected">02</option>
</select>
<select class=" " id="Day" name="Day" title="Day">
  <option value="11" selected="selected">11</option>
</select>
<select id="Year" name="Year" title="Year">
  <option value="2016" selected="selected">2016</option>
</select>',
    },
    {
        Name           => 'Long Format',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2016-02-10 09:04:23',    # in OTOBO time zone
        Config         => {
            Format => 'DateInputFormatLong',
        },
        ExpectedValue => '<select id="Month" name="Month" title="Month">
  <option value="2" selected="selected">02</option>
</select>
<select class=" " id="Day" name="Day" title="Day">
  <option value="10" selected="selected">10</option>
</select>
<select id="Year" name="Year" title="Year">
  <option value="2016" selected="selected">2016</option>
</select>
<select id="Hour" name="Hour" title="Hours">
  <option value="9" selected="selected">09</option>
</select>
<select id="Minute" name="Minute" title="Minutes">
  <option value="4" selected="selected">04</option>
</select>',
    },
    {
        Name           => 'Long Format',
        OTOBOTimeZone  => 'Europe/Berlin',
        UserTimeZone   => 'America/New_York',
        DateTimeString => '2016-05-01 04:24:06',    # in OTOBO time zone
        Config         => {
            Format => 'DateInputFormatLong',
        },
        ExpectedValue => '<select id="Month" name="Month" title="Month">
  <option value="4" selected="selected">04</option>
</select>
<select class=" " id="Day" name="Day" title="Day">
  <option value="30" selected="selected">30</option>
</select>
<select id="Year" name="Year" title="Year">
  <option value="2016" selected="selected">2016</option>
</select>
<select id="Hour" name="Hour" title="Hours">
  <option value="22" selected="selected">22</option>
</select>
<select id="Minute" name="Minute" title="Minutes">
  <option value="24" selected="selected">24</option>
</select>',
    },
    {
        Name           => 'Optional',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2016-10-02 09:04:23',    # in OTOBO time zone
        Config         => {
            Prefix       => 'Test',
            TestOptional => 1,
        },
        ExpectedValue =>
            '<input type="checkbox" name="TestUsed" id="TestUsed" value="1" class="" title="Check to activate this date" />
<select id="TestMonth" name="TestMonth" title="Month">
  <option value="10" selected="selected">10</option>
</select>
<select class=" " id="TestDay" name="TestDay" title="Day">
  <option value="2" selected="selected">02</option>
</select>
<select id="TestYear" name="TestYear" title="Year">
  <option value="2016" selected="selected">2016</option>
</select>',
    },
    {
        Name           => 'Optional',
        OTOBOTimeZone  => 'Europe/Berlin',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2016-10-02 00:04:23',    # in OTOBO time zone
        Config         => {
            Prefix       => 'Test',
            TestOptional => 1,
        },
        ExpectedValue =>
            '<input type="checkbox" name="TestUsed" id="TestUsed" value="1" class="" title="Check to activate this date" />
<select id="TestMonth" name="TestMonth" title="Month">
  <option value="10" selected="selected">10</option>
</select>
<select class=" " id="TestDay" name="TestDay" title="Day">
  <option value="2" selected="selected">02</option>
</select>
<select id="TestYear" name="TestYear" title="Year">
  <option value="2016" selected="selected">2016</option>
</select>',
    },
    {
        Name           => 'No Options (Input)',
        OTOBOTimeZone  => 'Europe/Berlin',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2016-10-02 00:04:23',    # in OTOBO time zone
        Config         => {},
        SetConfig      => {
            Key     => 'TimeInputFormat',
            Value   => 'Input',
            Message => 'Set TimeInputFormat to Input',
        },
        ExpectedValue =>
            '<input type="text" class="" name="Month" id="Month" size="2" maxlength="2" title="Month" value="10" />
<input type="text" class=" " name="Day" id="Day" size="2" maxlength="2" title="Day" value="02" />
<input type="text" class="" name="Year" id="Year" size="4" maxlength="4" title="Year" value="2016" />',
    },
    {
        Name           => 'Long Format (Input)',
        OTOBOTimeZone  => 'Europe/Berlin',
        UserTimeZone   => 'UTC',
        DateTimeString => '2016-10-02 00:04:23',    # in OTOBO time zone
        Config         => {
            Format => 'DateInputFormatLong',
        },
        ExpectedValue =>
            '<input type="text" class="" name="Month" id="Month" size="2" maxlength="2" title="Month" value="10" />
<input type="text" class=" " name="Day" id="Day" size="2" maxlength="2" title="Day" value="01" />
<input type="text" class="" name="Year" id="Year" size="4" maxlength="4" title="Year" value="2016" />
<input type="text" class="" name="Hour" id="Hour" size="2" maxlength="2" title="Hours" value="22" />
<input type="text" class="" name="Minute" id="Minute" size="2" maxlength="2" title="Minutes" value="04" />',
    },
    {
        Name           => 'Optional (Input)',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2016-06-08 23:04:23',    # in OTOBO time zone
        Config         => {
            Prefix       => 'Test',
            TestOptional => 1,
        },
        ExpectedValue =>
            '<input type="checkbox" name="TestUsed" id="TestUsed" value="1" class="" title="Check to activate this date" />
<input type="text" class="" name="TestMonth" id="TestMonth" size="2" maxlength="2" title="Month" value="06" />
<input type="text" class=" " name="TestDay" id="TestDay" size="2" maxlength="2" title="Day" value="09" />
<input type="text" class="" name="TestYear" id="TestYear" size="4" maxlength="4" title="Year" value="2016" />',
    },

    # TODO: add more tests for the different parameters here!
    {
        Name           => 'Disabled',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2016-06-08 23:04:23',    # in OTOBO time zone
        Config         => {
            Disabled => 1,
        },
        SetConfig => {
            Key     => 'TimeInputFormat',
            Value   => 'Option',
            Message => 'Set TimeInputFormat to Option',
        },
        ExpectedValue => '<select disabled="disabled" id="Month" name="Month" title="Month">
  <option value="6" selected="selected">06</option>
</select>
<select class=" " disabled="disabled" id="Day" name="Day" title="Day">
  <option value="8" selected="selected">08</option>
</select>
<select disabled="disabled" id="Year" name="Year" title="Year">
  <option value="2016" selected="selected">2016</option>
</select>',
    },
    {
        Name           => 'Disabled Long Format',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2014-06-08 23:24:23',    # in OTOBO time zone
        Config         => {
            Format   => 'DateInputFormatLong',
            Disabled => 1,
        },
        ExpectedValue => '<select disabled="disabled" id="Month" name="Month" title="Month">
  <option value="6" selected="selected">06</option>
</select>
<select class=" " disabled="disabled" id="Day" name="Day" title="Day">
  <option value="9" selected="selected">09</option>
</select>
<select disabled="disabled" id="Year" name="Year" title="Year">
  <option value="2014" selected="selected">2014</option>
</select>
<select disabled="disabled" id="Hour" name="Hour" title="Hours">
  <option value="1" selected="selected">01</option>
</select>
<select disabled="disabled" id="Minute" name="Minute" title="Minutes">
  <option value="24" selected="selected">24</option>
</select>',
    },
    {
        Name           => 'Disabled Optional',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2014-06-08 23:24:23',    # in OTOBO time zone
        Config         => {
            Prefix       => 'Test',
            TestOptional => 1,
            Disabled     => 1,
        },
        ExpectedValue =>
            '<input type="checkbox" name="TestUsed" id="TestUsed" value="1" class="" title="Check to activate this date" disabled="disabled"/>
<select disabled="disabled" id="TestMonth" name="TestMonth" title="Month">
  <option value="6" selected="selected">06</option>
</select>
<select class=" " disabled="disabled" id="TestDay" name="TestDay" title="Day">
  <option value="8" selected="selected">08</option>
</select>
<select disabled="disabled" id="TestYear" name="TestYear" title="Year">
  <option value="2014" selected="selected">2014</option>
</select>',
    },
    {
        Name           => 'Disabled (Input)',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2014-06-08 23:24:23',    # in OTOBO time zone
        Config         => {
            Disabled => 1,
        },
        SetConfig => {
            Key     => 'TimeInputFormat',
            Value   => 'Input',
            Message => 'Set TimeInputFormat to Input',
        },
        ExpectedValue =>
            '<input type="text" class="" name="Month" id="Month" size="2" maxlength="2" title="Month" value="06" readonly="readonly"/>
<input type="text" class=" " name="Day" id="Day" size="2" maxlength="2" title="Day" value="08" readonly="readonly"/>
<input type="text" class="" name="Year" id="Year" size="4" maxlength="4" title="Year" value="2014" readonly="readonly"/>',
    },
    {
        Name           => 'Disabled (Input)',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2014-06-09 01:24:23',    # in OTOBO time zone
        Config         => {
            Disabled => 1,
        },
        SetConfig => {
            Key     => 'TimeInputFormat',
            Value   => 'Input',
            Message => 'Set TimeInputFormat to Input',
        },
        ExpectedValue =>
            '<input type="text" class="" name="Month" id="Month" size="2" maxlength="2" title="Month" value="06" readonly="readonly"/>
<input type="text" class=" " name="Day" id="Day" size="2" maxlength="2" title="Day" value="09" readonly="readonly"/>
<input type="text" class="" name="Year" id="Year" size="4" maxlength="4" title="Year" value="2014" readonly="readonly"/>',
    },
    {
        Name           => 'Disabled Long Format (Input)',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2014-06-08 23:24:23',            # in OTOBO time zone
        Config         => {
            Format   => 'DateInputFormatLong',
            Disabled => 1,
        },
        ExpectedValue =>
            '<input type="text" class="" name="Month" id="Month" size="2" maxlength="2" title="Month" value="06" readonly="readonly"/>
<input type="text" class=" " name="Day" id="Day" size="2" maxlength="2" title="Day" value="08" readonly="readonly"/>
<input type="text" class="" name="Year" id="Year" size="4" maxlength="4" title="Year" value="2014" readonly="readonly"/>
<input type="text" class="" name="Hour" id="Hour" size="2" maxlength="2" title="Hours" value="23" readonly="readonly"/>
<input type="text" class="" name="Minute" id="Minute" size="2" maxlength="2" title="Minutes" value="24" readonly="readonly"/>',
    },
    {
        Name           => 'Disabled Long Format (Input)',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2014-06-08 23:24:23',            # in OTOBO time zone
        Config         => {
            Format   => 'DateInputFormatLong',
            Disabled => 1,
        },
        ExpectedValue =>
            '<input type="text" class="" name="Month" id="Month" size="2" maxlength="2" title="Month" value="06" readonly="readonly"/>
<input type="text" class=" " name="Day" id="Day" size="2" maxlength="2" title="Day" value="09" readonly="readonly"/>
<input type="text" class="" name="Year" id="Year" size="4" maxlength="4" title="Year" value="2014" readonly="readonly"/>
<input type="text" class="" name="Hour" id="Hour" size="2" maxlength="2" title="Hours" value="01" readonly="readonly"/>
<input type="text" class="" name="Minute" id="Minute" size="2" maxlength="2" title="Minutes" value="24" readonly="readonly"/>',
    },
    {
        Name           => 'Disabled Optional (Input)',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => undef,
        DateTimeString => '2014-06-08 23:24:23',         # in OTOBO time zone
        Config         => {
            Prefix       => 'Test',
            TestOptional => 1,
            Disabled     => 1,
        },
        ExpectedValue =>
            '<input type="checkbox" name="TestUsed" id="TestUsed" value="1" class="" title="Check to activate this date" disabled="disabled"/>
<input type="text" class="" name="TestMonth" id="TestMonth" size="2" maxlength="2" title="Month" value="06" readonly="readonly"/>
<input type="text" class=" " name="TestDay" id="TestDay" size="2" maxlength="2" title="Day" value="08" readonly="readonly"/>
<input type="text" class="" name="TestYear" id="TestYear" size="4" maxlength="4" title="Year" value="2014" readonly="readonly"/>',
    },
    {
        Name           => 'Disabled Optional (Input)',
        OTOBOTimeZone  => 'UTC',
        UserTimeZone   => 'Europe/Berlin',
        DateTimeString => '2014-06-08 23:24:23',         # in OTOBO time zone
        Config         => {
            Prefix       => 'Test',
            TestOptional => 1,
            Disabled     => 1,
        },
        ExpectedValue =>
            '<input type="checkbox" name="TestUsed" id="TestUsed" value="1" class="" title="Check to activate this date" disabled="disabled"/>
<input type="text" class="" name="TestMonth" id="TestMonth" size="2" maxlength="2" title="Month" value="06" readonly="readonly"/>
<input type="text" class=" " name="TestDay" id="TestDay" size="2" maxlength="2" title="Day" value="09" readonly="readonly"/>
<input type="text" class="" name="TestYear" id="TestYear" size="4" maxlength="4" title="Year" value="2014" readonly="readonly"/>',
    },
);

TESTCASE:
for my $Test (@Tests) {

    $ConfigObject->Set(
        Key   => 'OTOBOTimeZone',
        Value => $Test->{OTOBOTimeZone},
    );

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Test->{DateTimeString},
        },
    );

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            Lang         => 'en',
            UserTimeZone => $Test->{UserTimeZone},
        },
    );

    if ( $Test->{SetConfig} ) {
        $SetConfig->( %{ $Test->{SetConfig} } );
    }

    # run every test twice:
    # 1. Fixed date/time, BuildSelection retrieves its own date/time which will be the set fixed date/time
    # 2. Explicit date/time via parameters to BuildSelection
    #
    # Note: Due to calculation of TimeSecDiff in Kernel::System::DateTime based on the current date,
    # the Layout object has to be recreated within the test to be able to fetch a Time object
    # that has the fixed date/time set.
    for my $DateTimeAsParams ( 0, 1 ) {
        my %BuildSelectionParams = %{ $Test->{Config} };
        if ($DateTimeAsParams) {
            my $DateTimeValues = $DateTimeObject->Get();
            my $Prefix         = $BuildSelectionParams{Prefix} || '';
            $BuildSelectionParams{ $Prefix . 'Year' }   = $DateTimeValues->{Year};
            $BuildSelectionParams{ $Prefix . 'Month' }  = $DateTimeValues->{Month};
            $BuildSelectionParams{ $Prefix . 'Day' }    = $DateTimeValues->{Day};
            $BuildSelectionParams{ $Prefix . 'Hour' }   = $DateTimeValues->{Hour};
            $BuildSelectionParams{ $Prefix . 'Minute' } = $DateTimeValues->{Minute};
        }
        else {
            FixedTimeSet( $DateTimeObject->ToEpoch() );
        }

        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        my $HTML         = $LayoutObject->BuildDateSelection(%BuildSelectionParams);

        # remove non selected options for easy compare
        $HTML =~ s{\s+<option\s+value="\d+">\d+</option>}{}msxg;

        # remove /, : and - and convert them into new lines
        $HTML =~ s{</select>(?: / | : | \s-\s)<select}{</select>\n<select}msxg;
        $HTML =~ s{/>(?: / | : | \s-\s)<input}{/>\n<input}msxg;

        # remove checkbox space and convert it to new line
        $HTML =~ s{/>&nbsp;<}{/>\n<}msxg;

        $Self->Is(
            $HTML,
            $Test->{ExpectedValue},
            "BuildDateSelection(): $Test->{Name}, OTOBO time zone $Test->{OTOBOTimeZone}, "
                . ( $Test->{UserTimeZone} ? "user time zone $Test->{UserTimeZone}" : 'no user time zone' )
                . ", date/time " . ( $DateTimeAsParams ? 'as explicit parameters' : 'via fixed date/time' ),
        );

        $Kernel::OM->ObjectsDiscard(
            Objects => [ 'Kernel::Output::HTML::Layout', ],
        );

        FixedTimeUnset();
    }
}

$Self->DoneTesting();
