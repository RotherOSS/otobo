# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

# core modules

# CPAN modules
use HTTP::Request::Common qw(POST);
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::Output::HTML::Layout  ();
use Kernel::System::VariableCheck qw(:all);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DFBackendObject    = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
my $UserObject         = $Kernel::OM->Get('Kernel::System::User');

my $RandomID = $Helper->GetRandomID;
diag "RandomID is $RandomID";

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserID = 1;    # root

# create agents
my $FirstUserID = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User1',
    UserLogin     => 'TestUser1' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test1' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);
ok( $FirstUserID, 'Creation of first agent' );

my $SecondUserID = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User2',
    UserLogin     => 'TestUser2' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test2' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);
ok( $SecondUserID, 'Creation of second agent' );

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    Lang         => 'en',
    UserTimeZone => 'UTC',
);

# collect user data and build string for html selection comparison
my %UserList = $UserObject->UserSearch(
    Search => '*',
    Valid  => 1,
);
my %UserLookup = map {
    my $UserName = $UserObject->UserName(
        UserID => $_,
    );
    my %Preferences = $UserObject->GetPreferences(
        UserID => $_
    );
    $_ => $LayoutObject->Ascii2Html( Text => qq{"$UserName" <$Preferences{UserEmail}>} )
} keys %UserList;

my $UserSelectionString               = '';
my $UserSelectionSelectedString       = '  <option value="" selected="selected">-</option>';
my $UserSelectionSelectedAgent1String = '';
my $UserSelectionSelectedAgent2String = '';
for my $UserID ( sort { $UserLookup{$a} cmp $UserLookup{$b} } keys %UserLookup ) {
    $UserSelectionString         = join( "\n", ( $UserSelectionString,         '  <option value="' . $UserID . '">' . $UserLookup{$UserID} . '</option>' ) );
    $UserSelectionSelectedString = join( "\n", ( $UserSelectionSelectedString, '  <option value="' . $UserID . '">' . $UserLookup{$UserID} . '</option>' ) );
    if ( $UserID eq $FirstUserID ) {
        $UserSelectionSelectedAgent1String
            = join( "\n", ( $UserSelectionSelectedAgent1String, '  <option value="' . $UserID . '" selected="selected">' . $UserLookup{$UserID} . '</option>' ) );
    }
    else {
        $UserSelectionSelectedAgent1String
            = join( "\n", ( $UserSelectionSelectedAgent1String, '  <option value="' . $UserID . '">' . $UserLookup{$UserID} . '</option>' ) );
    }
    if ( $UserID eq $SecondUserID ) {
        $UserSelectionSelectedAgent2String
            = join( "\n", ( $UserSelectionSelectedAgent2String, '  <option value="' . $UserID . '" selected="selected">' . $UserLookup{$UserID} . '</option>' ) );
    }
    else {
        $UserSelectionSelectedAgent2String
            = join( "\n", ( $UserSelectionSelectedAgent2String, '  <option value="' . $UserID . '">' . $UserLookup{$UserID} . '</option>' ) );
    }
}

# remove preceding newline which is created due to initialization with empty string
$UserSelectionString               =~ s/^\n//;
$UserSelectionSelectedAgent1String =~ s/^\n//;
$UserSelectionSelectedAgent2String =~ s/^\n//;

# add empty value to the end
$UserSelectionString               .= "\n  <option value=\"\">-</option>";
$UserSelectionSelectedAgent1String .= "\n  <option value=\"\">-</option>";
$UserSelectionSelectedAgent2String .= "\n  <option value=\"\">-</option>";

# use a fixed year to compare the time selection results
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2013-12-12 00:00:00',
        },
    )->ToEpoch()
);

# prepare dynamic fields to include in set
my @IncludeDFConfigs = (

    # Fields to include in SetOfAgentsAndTexts
    {
        Name         => 'Text5' . $RandomID,
        Label        => 'Text5',
        LabelEscaped => 'Text5',
        FieldOrder   => 123,
        FieldType    => 'Text',
        ObjectType   => 'Ticket',
        Config       => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name         => 'Text6' . $RandomID,
        Label        => 'Text6',
        LabelEscaped => 'Text6',
        FieldOrder   => 123,
        FieldType    => 'Text',
        ObjectType   => 'Ticket',
        Config       => {
            MultiValue => 1,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name         => 'Agent1' . $RandomID,
        Label        => 'Agent1',
        LabelEscaped => 'Agent1',
        FieldOrder   => 123,
        FieldType    => 'Agent',
        ObjectType   => 'Ticket',
        Config       => {
            EditFieldMode => 'Dropdown',
            PossibleNone  => 1,
            Multiselect   => 0,
            MultiValue    => 0,
            GroupFilter   => [],
            Tooltip       => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name         => 'Agent2' . $RandomID,
        Label        => 'Agent2',
        LabelEscaped => 'Agent2',
        FieldOrder   => 123,
        FieldType    => 'Agent',
        ObjectType   => 'Ticket',
        Config       => {
            EditFieldMode => 'Dropdown',
            PossibleNone  => 1,
            Multiselect   => 0,
            MultiValue    => 1,
            GroupFilter   => [],
            Tooltip       => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
);

for my $IncludeDFConfig (@IncludeDFConfigs) {

    my $Success = $DynamicFieldObject->DynamicFieldAdd(
        $IncludeDFConfig->%*,
    );

    ok( $Success, 'Creation of set-included dynamic field ' . $IncludeDFConfig->{Name} );
}

# theres is not really needed to add the dynamic fields for this test, we can define a static
# set of configurations
my %DynamicFieldConfigs = (
    Text => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextField',
        Label         => 'TextField <special chars="äüø">',
        LabelEscaped  => 'TextField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Text',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => 'Default',
            Link         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    TextArea => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextAreaField',
        Label         => 'TextAreaField <special chars="äüø">',
        LabelEscaped  => 'TextAreaField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'TextArea',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => "Multi\nLine",
            Rows         => '',
            Cols         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Checkbox => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CheckboxField',
        Label         => 'CheckboxField <special chars="äüø">',
        LabelEscaped  => 'CheckboxField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Checkbox',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '1',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Dropdown => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DropdownField',
        Label         => 'DropdownField <special chars="äüø">',
        LabelEscaped  => 'DropdownField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Dropdown',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => 2,
            Link               => '',
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Multiselect => {
        ID            => 123,
        InternalField => 0,
        Name          => 'MultiselectField',
        Label         => 'MultiselectField <special chars="äüø">',
        LabelEscaped  => 'MultiselectField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Multiselect',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => 2,
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    DateTime => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateTimeField',
        Label         => 'DateTimeField <special chars="äüø">',
        LabelEscaped  => 'DateTimeField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'DateTime',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '2013-08-21 16:45:00',
            Link          => '',
            YearsPeriod   => '1',
            YearsInFuture => '5',
            YearsInPast   => '5',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Date => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateField',
        Label         => 'DateField <special chars="äüø">',
        LabelEscaped  => 'DateField &lt;special chars=&quot;äüø&quot;&gt;',
        FieldOrder    => 123,
        FieldType     => 'Date',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '2013-08-21 00:00:00',
            Link          => '',
            YearsPeriod   => '1',
            YearsInFuture => '5',
            YearsInPast   => '5',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },

    # Set, using the previously created Text5 and Text6 and agent fields
    Set => {
        ID            => 123,
        InternalField => 0,
        Name          => 'SetOfAgentsAndTexts',
        Label         => 'Set of agents and texts',
        LabelEscaped  => 'Set of agents and texts',
        FieldOrder    => 123,
        FieldType     => 'Set',
        ObjectType    => 'Ticket',
        Config        => {
            MultiValue => 0,
            Tooltip    => '',
            Include    => [
                { DF => 'Text5' . $RandomID },
                { DF => 'Text6' . $RandomID },
                { DF => 'Agent1' . $RandomID },
                { DF => 'Agent2' . $RandomID },
            ],
        },
        ValidID => 1,
    },
);

# define tests
my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name    => 'Empty Config',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing DynamicFieldConfig',
        Config => {
            DynamicFieldConfig => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Missing LayoutObject',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => undef,
            ParamObject        => $ParamObject,
        },
        Success => 0,
    },
    {
        Name   => 'Missing ParamObject',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => undef,
        },
        Success => 0,
    },

    # Dynamic Field Text
    {
        Name   => 'Text: No value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",

<input type="text" class="DynamicFieldText W50pc MyClass" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="" />
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}">
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Text: No value / Default',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="text" class="DynamicFieldText W50pc MyClass" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="Default" />
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}">
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Text: special chars',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '<special chars="äüø">',
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="text" class="DynamicFieldText W50pc MyClass" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="&lt;special chars=&quot;äüø&quot;&gt;" />
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}">
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Text: UTF8 value direct',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="text" class="DynamicFieldText W50pc MyClass" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß" />
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}">
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Text: UTF8 value web request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="text" class="DynamicFieldText W50pc MyClass" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß" />
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}">
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Text: UTF8 value template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="text" class="DynamicFieldText W50pc MyClass" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß" />
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}">
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Text: Mandatory',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'A Value',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="text" class="DynamicFieldText W50pc MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="A Value" />
<div id="DynamicField_$DynamicFieldConfigs{Text}->{Name}Error" class="TooltipErrorMessage">
    <p>
        This field is required.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}" class="Mandatory">
    <span class="Marker">*</span>
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Text: Server Error',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'A Value',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="text" class="DynamicFieldText W50pc MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{Text}->{Name}" name="DynamicField_$DynamicFieldConfigs{Text}->{Name}" title="$DynamicFieldConfigs{Text}->{LabelEscaped}" value="A Value" />
<div id="DynamicField_$DynamicFieldConfigs{Text}->{Name}ServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Text}->{Name}" for="DynamicField_$DynamicFieldConfigs{Text}->{Name}">
$DynamicFieldConfigs{Text}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },

    # Dynamic Field TextArea
    {
        Name   => 'TextArea: No value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800"></textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}">
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: No value / Default',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800">Multi
Line</textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}">
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: special chars',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '<special chars="äüø">',
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800">&lt;special chars=&quot;äüø&quot;&gt;</textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}">
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: UTF8 value direct',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800">äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß</textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}">
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: UTF8 value web request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800">äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß</textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}">
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: UTF8 value template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800">äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß</textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}">
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: Mandatory',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'A Value',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass Validate_Required Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800">A Value</textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        This field is required or The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" class="Mandatory">
    <span class="Marker">*</span>
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: Server Error',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'A Value',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field => <<"EOF",
<textarea class="DynamicFieldTextArea MyClass ServerError Validate_MaxLength" id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" name="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}" title="$DynamicFieldConfigs{TextArea}->{LabelEscaped}" rows="7" cols="42" data-maxlength="3800">A Value</textarea>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}Error" class="TooltipErrorMessage">
    <p>
        The field content is too long! Maximum size is 3800 characters.
    </p>
</div>
<div id="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}ServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{TextArea}->{Name}" for="DynamicField_$DynamicFieldConfigs{TextArea}->{Name}">
$DynamicFieldConfigs{TextArea}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },

    # Dynamic Field Checkbox
    {
        Name   => 'Checkbox: No value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}"  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: No value / Default',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}" checked  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Value direct',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}" checked  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Value web request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_CheckboxFieldUsed => 1,
                DynamicField_CheckboxField     => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}" checked  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Value web request (not used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_CheckboxFieldUsed => undef,
                DynamicField_CheckboxField     => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}"  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Value template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_CheckboxFieldUsed => 1,
                DynamicField_CheckboxField     => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}" checked  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Value template (not used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_CheckboxFieldUsed => undef,
                DynamicField_CheckboxField     => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}"  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Mandatory',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}" checked  value="1">
<div id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Error" class="TooltipErrorMessage">
    <p>
        This field is required.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" class="Mandatory">
    <span class="Marker">*</span>
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Server Error',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1" />
<input type="checkbox" class="DynamicFieldCheckbox MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}" checked  value="1">
<div id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}ServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Confirmation Needed',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ConfirmationNeeded => 1
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="radio" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used0" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="" checked  />
Ignore this field.
<div class="clear"></div>
<input type="radio" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used1" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}Used" value="1"  />
<input type="checkbox" class="DynamicFieldCheckbox MyClass" id="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" name="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" title="$DynamicFieldConfigs{Checkbox}->{LabelEscaped}" checked  value="1">
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Checkbox}->{Name}" for="DynamicField_$DynamicFieldConfigs{Checkbox}->{Name}">
$DynamicFieldConfigs{Checkbox}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },

    # Dynamic Field Dropdown
    {
        Name   => 'Dropdown: No value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: No value / Default',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2" selected="selected">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Value direct',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Value web request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_DropdownField => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Value template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_DropdownField => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Mandatory',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 2,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<select class="DynamicFieldText Modernize MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2" selected="selected">B</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}Error" class="TooltipErrorMessage">
    <p>
        This field is required.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" class="Mandatory">
    <span class="Marker">*</span>
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Server Error',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 2,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field => <<"EOF",
<select class="DynamicFieldText Modernize MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2" selected="selected">B</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}ServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Possible Values Filter',
        Config => {
            DynamicFieldConfig   => $DynamicFieldConfigs{Dropdown},
            LayoutObject         => $LayoutObject,
            ParamObject          => $ParamObject,
            Value                => 2,
            Class                => 'MyClass',
            UseDefaultValue      => 0,
            PossibleValuesFilter => {
                2 => 'Value2',
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="2" selected="selected">Value2</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: No Possible None',
        Config => {
            DynamicFieldConfig => {
                $DynamicFieldConfigs{Dropdown}->%*,
                Config => {
                    $DynamicFieldConfigs{Dropdown}{Config}->%*,
                    PossibleNone => 0,
                },
            },
            LayoutObject         => $LayoutObject,
            ParamObject          => $ParamObject,
            Value                => 1,
            Class                => 'MyClass',
            UseDefaultValue      => 0,
            OverridePossibleNone => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Confirmation needed',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ConfirmationNeeded => 1,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="5">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: AJAX Options',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            AJAXUpdate         => 1,
            UpdatableFields    => [ 'StateID', 'PriorityID', ],
        },
        ExpectedResults => {
            Field => <<"EOF",
<select class="DynamicFieldText Modernize MyClass FormUpdate" id="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" name="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" size="1">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
</select>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Dropdown}->{Name}" for="DynamicField_$DynamicFieldConfigs{Dropdown}->{Name}">
$DynamicFieldConfigs{Dropdown}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },

    # Dynamic Field Multiselect
    {
        Name   => 'Multiselect: No value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: No value / Default',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2" selected="selected">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value direct',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value direct (multiple)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => [ 1, 2 ],
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2" selected="selected">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value web request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_MultiselectField => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value web request (multiple)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_MultiselectField => [ 1, 2 ],
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2" selected="selected">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_MultiselectField => 1,
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value template (multiple)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_MultiselectField => [ 1, 2 ],
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2" selected="selected">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Mandatory',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 2,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<select class="DynamicFieldText Modernize MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2" selected="selected">B</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}Error" class="TooltipErrorMessage">
    <p>
        This field is required.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" class="Mandatory">
    <span class="Marker">*</span>
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Server Error',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 2,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field => <<"EOF",
<select class="DynamicFieldText Modernize MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1">A</option>
  <option value="2" selected="selected">B</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}ServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Possible Values Filter',
        Config => {
            DynamicFieldConfig   => $DynamicFieldConfigs{Multiselect},
            LayoutObject         => $LayoutObject,
            ParamObject          => $ParamObject,
            Value                => 2,
            Class                => 'MyClass',
            UseDefaultValue      => 0,
            PossibleValuesFilter => {
                2 => 'Value2',
            },
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="2" selected="selected">Value2</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: No Possible None',
        Config => {
            DynamicFieldConfig => {
                $DynamicFieldConfigs{Multiselect}->%*,
                Config => {
                    $DynamicFieldConfigs{Multiselect}{Config}->%*,
                    PossibleNone => 0,
                },
            },
            LayoutObject         => $LayoutObject,
            ParamObject          => $ParamObject,
            Value                => 1,
            Class                => 'MyClass',
            UseDefaultValue      => 0,
            OverridePossibleNone => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: AJAX Options',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 1,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            AJAXUpdate         => 1,
            UpdatableFields    => [ 'StateID', 'PriorityID', ],
        },
        ExpectedResults => {
            Field => <<"EOF",
<select class="DynamicFieldText Modernize MyClass FormUpdate" id="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" multiple="multiple" name="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
  <option value="">-</option>
  <option value="1" selected="selected">A</option>
  <option value="2">B</option>
</select>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Multiselect}->{Name}" for="DynamicField_$DynamicFieldConfigs{Multiselect}->{Name}">
$DynamicFieldConfigs{Multiselect}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },

    # Dynamic Field DateTime
    {
        Name   => 'DateTime: No value / Default',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" value="1" checked class="DynamicFieldText DateSelection MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8" selected="selected">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month Validate_DateHour_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour Validate_DateMinute_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21" selected="selected">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select> - <select class="Validate_DateHour DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" title="Hours">
  <option value="0">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16" selected="selected">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
</select>:<select class="Validate_DateMinute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" title="Minutes">
  <option value="0">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
  <option value="32">32</option>
  <option value="33">33</option>
  <option value="34">34</option>
  <option value="35">35</option>
  <option value="36">36</option>
  <option value="37">37</option>
  <option value="38">38</option>
  <option value="39">39</option>
  <option value="40">40</option>
  <option value="41">41</option>
  <option value="42">42</option>
  <option value="43">43</option>
  <option value="44">44</option>
  <option value="45" selected="selected">45</option>
  <option value="46">46</option>
  <option value="47">47</option>
  <option value="48">48</option>
  <option value="49">49</option>
  <option value="50">50</option>
  <option value="51">51</option>
  <option value="52">52</option>
  <option value="53">53</option>
  <option value="54">54</option>
  <option value="55">55</option>
  <option value="56">56</option>
  <option value="57">57</option>
  <option value="58">58</option>
  <option value="59">59</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used">
$DynamicFieldConfigs{DateTime}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Value direct',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '2013-12-12 00:00:00',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" value="1" checked class="DynamicFieldText DateSelection MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month Validate_DateHour_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour Validate_DateMinute_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select> - <select class="Validate_DateHour DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" title="Hours">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
</select>:<select class="Validate_DateMinute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" title="Minutes">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
  <option value="32">32</option>
  <option value="33">33</option>
  <option value="34">34</option>
  <option value="35">35</option>
  <option value="36">36</option>
  <option value="37">37</option>
  <option value="38">38</option>
  <option value="39">39</option>
  <option value="40">40</option>
  <option value="41">41</option>
  <option value="42">42</option>
  <option value="43">43</option>
  <option value="44">44</option>
  <option value="45">45</option>
  <option value="46">46</option>
  <option value="47">47</option>
  <option value="48">48</option>
  <option value="49">49</option>
  <option value="50">50</option>
  <option value="51">51</option>
  <option value="52">52</option>
  <option value="53">53</option>
  <option value="54">54</option>
  <option value="55">55</option>
  <option value="56">56</option>
  <option value="57">57</option>
  <option value="58">58</option>
  <option value="59">59</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used">
$DynamicFieldConfigs{DateTime}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Value web request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 12,
                DynamicField_DateTimeFieldDay    => 12,
                DynamicField_DateTimeFieldHour   => 0,
                DynamicField_DateTimeFieldMinute => 0,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" value="1" checked class="DynamicFieldText DateSelection MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month Validate_DateHour_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour Validate_DateMinute_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select> - <select class="Validate_DateHour DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" title="Hours">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
</select>:<select class="Validate_DateMinute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" title="Minutes">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
  <option value="32">32</option>
  <option value="33">33</option>
  <option value="34">34</option>
  <option value="35">35</option>
  <option value="36">36</option>
  <option value="37">37</option>
  <option value="38">38</option>
  <option value="39">39</option>
  <option value="40">40</option>
  <option value="41">41</option>
  <option value="42">42</option>
  <option value="43">43</option>
  <option value="44">44</option>
  <option value="45">45</option>
  <option value="46">46</option>
  <option value="47">47</option>
  <option value="48">48</option>
  <option value="49">49</option>
  <option value="50">50</option>
  <option value="51">51</option>
  <option value="52">52</option>
  <option value="53">53</option>
  <option value="54">54</option>
  <option value="55">55</option>
  <option value="56">56</option>
  <option value="57">57</option>
  <option value="58">58</option>
  <option value="59">59</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used">
$DynamicFieldConfigs{DateTime}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Value web request (using default value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 1,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 12,
                DynamicField_DateTimeFieldDay    => 12,
                DynamicField_DateTimeFieldHour   => 0,
                DynamicField_DateTimeFieldMinute => 0,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" value="1" checked class="DynamicFieldText DateSelection MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month Validate_DateHour_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour Validate_DateMinute_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select> - <select class="Validate_DateHour DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" title="Hours">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
</select>:<select class="Validate_DateMinute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" title="Minutes">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
  <option value="32">32</option>
  <option value="33">33</option>
  <option value="34">34</option>
  <option value="35">35</option>
  <option value="36">36</option>
  <option value="37">37</option>
  <option value="38">38</option>
  <option value="39">39</option>
  <option value="40">40</option>
  <option value="41">41</option>
  <option value="42">42</option>
  <option value="43">43</option>
  <option value="44">44</option>
  <option value="45">45</option>
  <option value="46">46</option>
  <option value="47">47</option>
  <option value="48">48</option>
  <option value="49">49</option>
  <option value="50">50</option>
  <option value="51">51</option>
  <option value="52">52</option>
  <option value="53">53</option>
  <option value="54">54</option>
  <option value="55">55</option>
  <option value="56">56</option>
  <option value="57">57</option>
  <option value="58">58</option>
  <option value="59">59</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used">
$DynamicFieldConfigs{DateTime}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Value template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 12,
                DynamicField_DateTimeFieldDay    => 12,
                DynamicField_DateTimeFieldHour   => 0,
                DynamicField_DateTimeFieldMinute => 0,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" value="1" checked class="DynamicFieldText DateSelection MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month Validate_DateHour_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour Validate_DateMinute_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select> - <select class="Validate_DateHour DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" title="Hours">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
</select>:<select class="Validate_DateMinute DynamicFieldText DateSelection MyClass" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" title="Minutes">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
  <option value="32">32</option>
  <option value="33">33</option>
  <option value="34">34</option>
  <option value="35">35</option>
  <option value="36">36</option>
  <option value="37">37</option>
  <option value="38">38</option>
  <option value="39">39</option>
  <option value="40">40</option>
  <option value="41">41</option>
  <option value="42">42</option>
  <option value="43">43</option>
  <option value="44">44</option>
  <option value="45">45</option>
  <option value="46">46</option>
  <option value="47">47</option>
  <option value="48">48</option>
  <option value="49">49</option>
  <option value="50">50</option>
  <option value="51">51</option>
  <option value="52">52</option>
  <option value="53">53</option>
  <option value="54">54</option>
  <option value="55">55</option>
  <option value="56">56</option>
  <option value="57">57</option>
  <option value="58">58</option>
  <option value="59">59</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used">
$DynamicFieldConfigs{DateTime}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Mandatory',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '2013-12-12 00:00:00',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" value="1" checked class="DynamicFieldText DateSelection MyClass Validate_Required" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText DateSelection MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month Validate_DateHour_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour Validate_DateMinute_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute DynamicFieldText DateSelection MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText DateSelection MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select> - <select class="Validate_DateHour DynamicFieldText DateSelection MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" title="Hours">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
</select>:<select class="Validate_DateMinute DynamicFieldText DateSelection MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" title="Minutes">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
  <option value="32">32</option>
  <option value="33">33</option>
  <option value="34">34</option>
  <option value="35">35</option>
  <option value="36">36</option>
  <option value="37">37</option>
  <option value="38">38</option>
  <option value="39">39</option>
  <option value="40">40</option>
  <option value="41">41</option>
  <option value="42">42</option>
  <option value="43">43</option>
  <option value="44">44</option>
  <option value="45">45</option>
  <option value="46">46</option>
  <option value="47">47</option>
  <option value="48">48</option>
  <option value="49">49</option>
  <option value="50">50</option>
  <option value="51">51</option>
  <option value="52">52</option>
  <option value="53">53</option>
  <option value="54">54</option>
  <option value="55">55</option>
  <option value="56">56</option>
  <option value="57">57</option>
  <option value="58">58</option>
  <option value="59">59</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}UsedError" class="TooltipErrorMessage">
    <p>
        This field is required.
    </p>
</div>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" class="Mandatory">
    <span class="Marker">*</span>
$DynamicFieldConfigs{DateTime}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Server Error',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '2013-12-12 00:00:00',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" value="1" checked class="DynamicFieldText DateSelection MyClass ServerError" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText DateSelection MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Month Validate_DateHour_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour Validate_DateMinute_DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute DynamicFieldText DateSelection MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText DateSelection MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select> - <select class="Validate_DateHour DynamicFieldText DateSelection MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Hour" title="Hours">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
</select>:<select class="Validate_DateMinute DynamicFieldText DateSelection MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" name="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Minute" title="Minutes">
  <option value="0" selected="selected">00</option>
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
  <option value="32">32</option>
  <option value="33">33</option>
  <option value="34">34</option>
  <option value="35">35</option>
  <option value="36">36</option>
  <option value="37">37</option>
  <option value="38">38</option>
  <option value="39">39</option>
  <option value="40">40</option>
  <option value="41">41</option>
  <option value="42">42</option>
  <option value="43">43</option>
  <option value="44">44</option>
  <option value="45">45</option>
  <option value="46">46</option>
  <option value="47">47</option>
  <option value="48">48</option>
  <option value="49">49</option>
  <option value="50">50</option>
  <option value="51">51</option>
  <option value="52">52</option>
  <option value="53">53</option>
  <option value="54">54</option>
  <option value="55">55</option>
  <option value="56">56</option>
  <option value="57">57</option>
  <option value="58">58</option>
  <option value="59">59</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}UsedServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{DateTime}->{Name}Used">
$DynamicFieldConfigs{DateTime}->{LabelEscaped}:
</label>
EOF

        },
        Success => 1,
    },

    # Dynamic Field Date
    {
        Name   => 'Date: No value / Default',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" value="1" checked class="DynamicFieldText MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8" selected="selected">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{Date}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{Date}->{Name}Month DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21" selected="selected">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Date}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used">
$DynamicFieldConfigs{Date}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Date: Value direct',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '2013-12-12 00:00:00',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" value="1" checked class="DynamicFieldText MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{Date}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{Date}->{Name}Month DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Date}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used">
$DynamicFieldConfigs{Date}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Date: Value web request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 12,
                DynamicField_DateFieldDay   => 12,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" value="1" checked class="DynamicFieldText MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{Date}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{Date}->{Name}Month DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Date}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used">
$DynamicFieldConfigs{Date}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Date: Value web request (using default value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 1,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 12,
                DynamicField_DateFieldDay   => 12,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" value="1" checked class="DynamicFieldText MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{Date}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{Date}->{Name}Month DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Date}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used">
$DynamicFieldConfigs{Date}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Date: Value template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Template           => {
                DynamicField_DateFieldUsed   => 1,
                DynamicField_DateFieldYear   => 2013,
                DynamicField_DateFieldMonth  => 12,
                DynamicField_DateFieldDay    => 12,
                DynamicField_DateFieldHour   => 0,
                DynamicField_DateFieldMinute => 0,
            },
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" value="1" checked class="DynamicFieldText MyClass" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{Date}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{Date}->{Name}Month DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText MyClass" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Date}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used">
$DynamicFieldConfigs{Date}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Date: Mandatory',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '2013-12-12 00:00:00',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" value="1" checked class="DynamicFieldText MyClass Validate_Required" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{Date}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{Date}->{Name}Month DynamicFieldText MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText MyClass Validate_Required" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{Date}->{Name}UsedError" class="TooltipErrorMessage">
    <p>
        This field is required.
    </p>
</div>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Date}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" class="Mandatory">
    <span class="Marker">*</span>
$DynamicFieldConfigs{Date}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
    {
        Name   => 'Date: Server Error',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => '2013-12-12 00:00:00',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field => <<"EOF",
<div class="DynamicFieldDate">
<input type="checkbox" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used" value="1" checked class="DynamicFieldText MyClass ServerError" title="Check to activate this date" >&nbsp;<select class="Validate_DateMonth DynamicFieldText MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Month" title="Month">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
</select>/<select class="Validate_DateDay Validate_DateYear_DynamicField_$DynamicFieldConfigs{Date}->{Name}Year Validate_DateMonth_DynamicField_$DynamicFieldConfigs{Date}->{Name}Month DynamicFieldText MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Day" title="Day">
  <option value="1">01</option>
  <option value="2">02</option>
  <option value="3">03</option>
  <option value="4">04</option>
  <option value="5">05</option>
  <option value="6">06</option>
  <option value="7">07</option>
  <option value="8">08</option>
  <option value="9">09</option>
  <option value="10">10</option>
  <option value="11">11</option>
  <option value="12" selected="selected">12</option>
  <option value="13">13</option>
  <option value="14">14</option>
  <option value="15">15</option>
  <option value="16">16</option>
  <option value="17">17</option>
  <option value="18">18</option>
  <option value="19">19</option>
  <option value="20">20</option>
  <option value="21">21</option>
  <option value="22">22</option>
  <option value="23">23</option>
  <option value="24">24</option>
  <option value="25">25</option>
  <option value="26">26</option>
  <option value="27">27</option>
  <option value="28">28</option>
  <option value="29">29</option>
  <option value="30">30</option>
  <option value="31">31</option>
</select>/<select class="Validate_DateYear DynamicFieldText MyClass ServerError" id="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" name="DynamicField_$DynamicFieldConfigs{Date}->{Name}Year" title="Year">
  <option value="2008">2008</option>
  <option value="2009">2009</option>
  <option value="2010">2010</option>
  <option value="2011">2011</option>
  <option value="2012">2012</option>
  <option value="2013" selected="selected">2013</option>
  <option value="2014">2014</option>
  <option value="2015">2015</option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
</select>
<div id="DynamicField_$DynamicFieldConfigs{Date}->{Name}UsedServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
</div>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Date}->{Name}Used" for="DynamicField_$DynamicFieldConfigs{Date}->{Name}Used">
$DynamicFieldConfigs{Date}->{LabelEscaped}:
</label>
EOF

        },
        Success => 1,
    },
    {
        Name   => 'Set: Correct Value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Set},
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,

            # a list of Set values
            Value => [

                # actually only on Set value in the list
                {

                    # value for the first dynamic field in the set
                    "Text5$RandomID" => 'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',

                    # value for the second dynamic field in the set
                    "Text6$RandomID" => [
                        'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                        'Text4: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                    ],

                    # value for the third dynamic field in the set
                    "Agent1$RandomID" => $FirstUserID,

                    # value for the fourth dynamic field in the set
                    "Agent2$RandomID" => [
                        $FirstUserID,
                        $SecondUserID,
                    ],
                },
            ],
            Class => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF",
<input type="hidden" id="DynamicField_$DynamicFieldConfigs{Set}->{Name}_0" name="SetIndex_$DynamicFieldConfigs{Set}->{Name}" value="0"/>
<fieldset class="DynamicFieldSet">
                        <div class="Row Row_DynamicField" style="grid-template-columns: 1fr">
                            <div class="FieldCell" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[0]->{Name}_0" for="DynamicField_$IncludeDFConfigs[0]->{Name}_0">
$IncludeDFConfigs[0]->{LabelEscaped}:
</label>
                                <div class="Field">
<input type="text" class="DynamicFieldText W50pc" id="DynamicField_$IncludeDFConfigs[0]->{Name}_0" name="DynamicField_$IncludeDFConfigs[0]->{Name}_0" title="$IncludeDFConfigs[0]->{LabelEscaped}" value="Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN" />
                                </div>
                                <div class="Clear"></div>
                            </div>
                        </div>
                        <div class="Row Row_DynamicField MultiValue" style="grid-template-columns: 1fr">
                            <div class="FieldCell MultiValue_0" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[1]->{Name}_0" for="DynamicField_$IncludeDFConfigs[1]->{Name}_0">
$IncludeDFConfigs[1]->{LabelEscaped}:
</label>
                                <div class="Field">
<input type="text" class="DynamicFieldText W50pc" id="DynamicField_$IncludeDFConfigs[1]->{Name}_0_0" name="DynamicField_$IncludeDFConfigs[1]->{Name}_0" title="$IncludeDFConfigs[1]->{LabelEscaped}" value="Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN" />
                                </div>
                                <div class="AddRemoveValueRow">
                                    <a class="RemoveValueRow"><i class="fa fa-minus-square"></i></a>
                                    <a class="AddValueRow"><i class="fa fa-plus-square"></i></a>
                                </div>
                                <div class="Clear"></div>
                            </div>
                            <div class="FieldCell MultiValue_1" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[1]->{Name}_0" for="DynamicField_$IncludeDFConfigs[1]->{Name}_0">
$IncludeDFConfigs[1]->{LabelEscaped}:
</label>
                                <div class="Field">
<input type="text" class="DynamicFieldText W50pc" id="DynamicField_$IncludeDFConfigs[1]->{Name}_0_1" name="DynamicField_$IncludeDFConfigs[1]->{Name}_0" title="$IncludeDFConfigs[1]->{LabelEscaped}" value="Text4: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN" />
                                </div>
                                <div class="AddRemoveValueRow">
                                    <a class="RemoveValueRow"><i class="fa fa-minus-square"></i></a>
                                    <a class="AddValueRow"><i class="fa fa-plus-square"></i></a>
                                </div>
                                <div class="Clear"></div>
                            </div>
                            <div class="MultiValue_Template" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[1]->{Name}_0" for="DynamicField_$IncludeDFConfigs[1]->{Name}_0">
$IncludeDFConfigs[1]->{LabelEscaped}:
</label>
                                <div class="Field">
<input type="text" class="DynamicFieldText W50pc" id="DynamicField_$IncludeDFConfigs[1]->{Name}_0_Template" name="DynamicField_$IncludeDFConfigs[1]->{Name}_0" title="$IncludeDFConfigs[1]->{LabelEscaped}" value="Text4: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN" />
                                </div>
                                <div class="AddRemoveValueRow">
                                    <a class="RemoveValueRow"><i class="fa fa-minus-square"></i></a>
                                    <a class="AddValueRow"><i class="fa fa-plus-square"></i></a>
                                </div>
                            </div>
                        </div>
                        <div class="Row Row_DynamicField" style="grid-template-columns: 1fr">
                            <div class="FieldCell" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[2]->{Name}_0" for="DynamicField_$IncludeDFConfigs[2]->{Name}_0">
$IncludeDFConfigs[2]->{LabelEscaped}:
</label>
                                <div class="Field">
<select class="DynamicFieldReference DynamicFieldText Modernize FormUpdate" id="DynamicField_$IncludeDFConfigs[2]->{Name}_0" name="DynamicField_$IncludeDFConfigs[2]->{Name}_0">
$UserSelectionSelectedAgent1String
</select>
                                </div>
                                <div class="Clear"></div>
                            </div>
                        </div>
                        <div class="Row Row_DynamicField MultiValue" style="grid-template-columns: 1fr">
                            <div class="FieldCell MultiValue_0" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[3]->{Name}_0_0" for="DynamicField_$IncludeDFConfigs[3]->{Name}_0_0">
$IncludeDFConfigs[3]->{LabelEscaped}:
</label>
                                <div class="Field">
<select class="DynamicFieldReference DynamicFieldText Modernize FormUpdate" id="DynamicField_$IncludeDFConfigs[3]->{Name}_0_0" name="DynamicField_$IncludeDFConfigs[3]->{Name}_0">
$UserSelectionSelectedAgent1String
</select>
                                </div>
                                <div class="AddRemoveValueRow">
                                    <a class="RemoveValueRow"><i class="fa fa-minus-square"></i></a>
                                    <a class="AddValueRow"><i class="fa fa-plus-square"></i></a>
                                </div>
                                <div class="Clear"></div>
                            </div>
                            <div class="FieldCell MultiValue_1" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[3]->{Name}_0_0" for="DynamicField_$IncludeDFConfigs[3]->{Name}_0_0">
$IncludeDFConfigs[3]->{LabelEscaped}:
</label>
                                <div class="Field">
<select class="DynamicFieldReference DynamicFieldText Modernize FormUpdate" id="DynamicField_$IncludeDFConfigs[3]->{Name}_0_1" name="DynamicField_$IncludeDFConfigs[3]->{Name}_0">
$UserSelectionSelectedAgent2String
</select>
                                </div>
                                <div class="AddRemoveValueRow">
                                    <a class="RemoveValueRow"><i class="fa fa-minus-square"></i></a>
                                    <a class="AddValueRow"><i class="fa fa-plus-square"></i></a>
                                </div>
                                <div class="Clear"></div>
                            </div>
                            <div class="MultiValue_Template" style="grid-column: 1 / span 1">
                                <label id="LabelDynamicField_$IncludeDFConfigs[3]->{Name}_0_0" for="DynamicField_$IncludeDFConfigs[3]->{Name}_0_0">
$IncludeDFConfigs[3]->{LabelEscaped}:
</label>
                                <div class="Field">
<select class="DynamicFieldReference DynamicFieldText Modernize FormUpdate" id="DynamicField_$IncludeDFConfigs[3]->{Name}_0_Template" name="DynamicField_$IncludeDFConfigs[3]->{Name}_0">
$UserSelectionString
</select>
                                </div>
                                <div class="AddRemoveValueRow">
                                    <a class="RemoveValueRow"><i class="fa fa-minus-square"></i></a>
                                    <a class="AddValueRow"><i class="fa fa-plus-square"></i></a>
                                </div>
                            </div>
                        </div>
</fieldset>
EOF
            Label => <<"EOF",
<label id="LabelDynamicField_$DynamicFieldConfigs{Set}->{Name}" for="DynamicField_$DynamicFieldConfigs{Set}->{Name}">
$DynamicFieldConfigs{Set}->{LabelEscaped}:
</label>
EOF
        },
        Success => 1,
    },
);

# execute tests
for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        my $FieldHTML;

        if ( IsHashRefWithData( $Test->{Config} ) ) {
            my %Config = $Test->{Config}->%*;

            if ( IsHashRefWithData( $Test->{Config}->{CGIParam} ) ) {

                # create a new HTTP::Request object to simulate a web request
                my $HTTPRequest = POST( '/', [ $Test->{Config}->{CGIParam}->%* ] );
                $Config{ParamObject} = Kernel::System::Web::Request->new(
                    HTTPRequest => $HTTPRequest,
                );
            }
            $FieldHTML = $DFBackendObject->EditFieldRender(%Config);
        }
        else {
            $FieldHTML = $DFBackendObject->EditFieldRender;
        }

        if ( $Test->{Success} ) {

            # TODO Have a look at the newlines produced during template rendering. See Issue #1135
            $FieldHTML->{Field} =~ s/^\n+//;
            $FieldHTML->{Field} =~ s/\n+$//;
            $FieldHTML->{Field} =~ s/\n{2,}/\n/g;

            # Remove lines which consist only of whitespace
            $FieldHTML->{Field} =~ s/^\s+\n//gm;

            # Heredocs always have the newline, even if it is not expected
            if ( $FieldHTML->{Field} !~ m{\n$} ) {

                # chomp $Test->{ExpectedResults}->{Field};

                # TODO Have a look at the newlines produced during template rendering. See Issue #1135
                $Test->{ExpectedResults}->{Field} =~ s/^\n+//;
                $Test->{ExpectedResults}->{Field} =~ s/\n+$//;
            }

            is(
                $FieldHTML,
                {
                    Field => T(),
                    Label => T(),
                },
                "EditFieldRender() gave the expected structure",
            );
            is(
                $FieldHTML,
                $Test->{ExpectedResults},
                "EditFieldRender() gave the expected content",
            );
        }
        else {
            is( $FieldHTML, undef, 'EditFieldRender failed, as expected' );
        }
    };
}

done_testing;
