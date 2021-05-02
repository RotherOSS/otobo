# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

use Kernel::Language;

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 1,
        );

        # do not check RichText enhanced mode
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText::EnhancedMode',
            Value => 0,
        );

        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Language => $Language,
            Groups   => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # remember to escape the strings correctly for Perl AND Javascript!
        my @TestCasesBasic = (
            {
                'Name'  => '1: Basic text with formatting tags which should be changed to be semantically correct',
                'Input' =>
                    'This is a test text with <b>some</b> <i>formatting</i> and <a href=\"http://www.test.de\">a link</a>. Also, there is a list: <ul><li>Listitem 1</li><li>Listitem 2</li></ul>.',
                'Expected' =>
                    "This is a test text with <strong>some</strong> <em>formatting</em> and <a href=\"http://www.test.de\">a link</a>. Also, there is a list:\n<ul>\n\t<li>Listitem 1</li>\n\t<li>Listitem 2</li>\n</ul>\n.",
            },
            {
                'Name'  => '2: Remove invalid/forbidden tags',
                'Input' =>
                    "This text contains a script tag: <script>alert(\'bla\');</script> and a table, though the enhanced mode is not enabled: <table><tr><td>One cell</td></tr></table>.",
                'Expected' =>
                    "This text contains a script tag: and a table, though the enhanced mode is not enabled:One cell<br />\n.",
            },
            {
                'Name'  => '3: Remove invalid/forbidden attributes',
                'Input' =>
                    'Here is an allowed element with a forbidden attribute: <strong data-uri=\"foo\">Strong text</strong>.',
                'Expected' => 'Here is an allowed element with a forbidden attribute: <strong>Strong text</strong>.',
            },
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # wait for the CKE to load
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('body.cke_editable', \$('.cke_wysiwyg_frame').contents()).length == 1"
        );

        # send some text to the CKE's textarea (we cant do it with Selenium directly because the textarea is not visible)
        my $SetCKEContent = 1;
        eval {
            $SetCKEContent = $Selenium->execute_script(
                q{
                    return CKEDITOR.instances.RichText.setData('This is a test text');
                }
            );
        };

        # if the result is undef, the command succeeded (o_O)
        $Self->Is(
            $SetCKEContent,
            undef,
            "Successfully sent data to the CKE instance."
        );

        # Wait until CKEditor content is updated.
        $Selenium->WaitFor(
            JavaScript => "return CKEDITOR.instances.RichText.getData() === \"This is a test text\";",
        );

        $Self->Is(
            $Selenium->execute_script('return CKEDITOR.instances.RichText.getData();'),
            'This is a test text',
            'Check plain text content.'
        );

        # now go through the test cases
        for my $TestCase (@TestCasesBasic) {

            # wait for the CKE to load
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('body.cke_editable', \$('.cke_wysiwyg_frame').contents()).length == 1"
            );

            $Selenium->execute_script( 'CKEDITOR.instances.RichText.setData("' . $TestCase->{Input} . '");' );

            my $EscapedText = $TestCase->{Expected};

            # Escape some chars for JS usage.
            $EscapedText =~ s{\n}{\\n}g;
            $EscapedText =~ s{"}{\\"}g;

            # Wait until CKEditor content is updated.
            $Selenium->WaitFor(
                JavaScript => "return CKEDITOR.instances.RichText.getData() === \"$EscapedText\";",
            );

            $Self->Is(
                $Selenium->execute_script('return CKEDITOR.instances.RichText.getData();'),
                $TestCase->{Expected},
                $TestCase->{Name}
            );
        }
    }
);

$Self->DoneTesting();
