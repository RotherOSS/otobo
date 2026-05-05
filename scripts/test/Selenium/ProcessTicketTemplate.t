# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::UnitTest::Selenium;

# CPAN modules
use Test2::V0;

our $Self;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new;

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');
        my $ActivityObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $ProcessObject  = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
        my $QueueObject            = $Kernel::OM->Get('Kernel::System::Queue');
        my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
        my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

        $Kernel::OM->ObjectParamAdd(
            $Helper => {
                RestoreDatabase => 1,
            },
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        my $RandomID = $Helper->GetRandomID();
        my $ActivityDialogID = $ActivityDialogObject->ActivityDialogAdd(
            EntityID    => "ActivityDialog-$RandomID",
            Name        => 'Some activity dialog',
            Config => {
                DescriptionLong => '',
                RequiredLock => 0,
                Permission => '',
                Fields => {
                                Article => {
                                                DescriptionLong => '',
                                                Config => {
                                                            IsVisibleForCustomer => '0',
                                                            StandardTemplates => '1',
                                                            CommunicationChannel => 'Internal',
                                                            TimeUnits => '0'
                                                            },
                                                Display => '1',
                                                DefaultValue => '',
                                                DescriptionShort => ''
                                            }
                            },
                SubmitAdviceText => '',
                SubmitButtonText => '',
                DescriptionShort => 'Some description',
                Interface => [
                                    'AgentInterface'
                                ],
                DirectSubmit => 0,
                FieldOrder => [
                                    'Article'
                                ],
                InputFieldDefinition => ''
            },
            UserID      => 1,
        );
        ok(
            $ActivityDialogID,
            "Created Activity Dialog - ID $ActivityDialogID"
        );

        my $ActivityID = $ActivityObject->ActivityAdd(
            EntityID    => "Activity-$RandomID",
            Name        => 'Some Activity',
            Config      => {
                        'ActivityDialog' => {
                                              '1' => "ActivityDialog-$RandomID"
                                            }
            },
            UserID      => 1,
        );
        ok(
            $ActivityDialogID,
            "Created Activity - ID $ActivityID"
        );

        my $ProcessEntityID = "Process-$RandomID";
        my $ProcessID = $ProcessObject->ProcessAdd(
            EntityID => $ProcessEntityID,
            UserID => 1,
            Layout => {
                        "Activity-$RandomID" => {
                            'left' => 166,
                            'top' => '46.421875'
                        }
            },
            StateEntityID => 'S1',
            Config => {
                        'Path' => {
                                    "Activity-$RandomID" => {}
                                    },
                        StartActivityDialog => "ActivityDialog-$RandomID",
                        Description => 'Some process of mine',
                        StartActivity => "Activity-$RandomID"
                        },
            Name => "Process $RandomID"
        );
        ok(
            $ProcessID,
            "Created Process - ID $ProcessID"
        );

        # deploy process
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminProcessManagement"
        );

        $Selenium->find_element("//a[contains(\@href, 'Subaction=ProcessSync' )]")->VerifiedClick();

        # create process templates
        my @StandardTemplateIDs;
        my @StandardTemplateValues;
        for my $Index (1 .. 5) {
            my $StandardTemplateText = "Standard Template Text $Index";
            my $StandardTemplateID = $StandardTemplateObject->StandardTemplateAdd(
                Name => "Template-$RandomID-$Index",
                ContentType => 'text/html',
                ID => '',
                ValidID => '1',
                Template => $StandardTemplateText,
                TemplateType => 'ProcessDialog',
                Comment => '',
                UserID => 1,
            );
            ok(
                $StandardTemplateID,
                "Created Standard Template - ID $StandardTemplateID"
            );
            for my $QueueID (1 .. 4) {
                $QueueObject->QueueStandardTemplateMemberAdd(
                    QueueID            => $QueueID,
                    StandardTemplateID => $StandardTemplateID,
                    Active             => 1,
                    UserID             => 1,
                );
            }
            push @StandardTemplateIDs, $StandardTemplateID;
            push @StandardTemplateValues, $StandardTemplateText;
        }

        # load process templates in process ticket mask
        my $Index = 0;
        for my $StandardTemplateID (@StandardTemplateIDs) {
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentTicketProcess"
            );

            $Selenium->execute_script(
                "\$('#ProcessEntityID').val('$ProcessEntityID').trigger('redraw.InputField').trigger('change')"
            );

            $Selenium->WaitFor(
                JavaScript => "return \$('#StandardTemplateID').length > 0;",
            );        

            # select template
            $Selenium->execute_script(
                "\$('#StandardTemplateID').val('$StandardTemplateID').trigger('redraw.InputField').trigger('change')"
            );

            $Selenium->WaitFor(
                JavaScript => "return \$('#RichText').val();",
                Timeout    => 5,
            );        

            # check template text
            is(
                $Selenium->execute_script("return \$('#RichText').val();"),
                "<p>$StandardTemplateValues[$Index]</p>",
                "Check template $Index text field"
            );

            $Index++;
        }

    }

);

$Self->DoneTesting;
