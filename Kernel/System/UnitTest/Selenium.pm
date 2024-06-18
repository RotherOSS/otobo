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

package Kernel::System::UnitTest::Selenium;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use File::Path  qw(remove_tree);
use Time::HiRes ();
use File::Spec  ();
use File::Copy  qw(copy);

# CPAN modules
use Test2::V0;
use Test2::API         qw(context run_subtest);
use Net::DNS::Resolver ();
use Moo;
use Try::Tiny;
use URI ();

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our $ObjectManagerDisabled = 1;

# Extend Selenium::Remote::Driver only when Selenium testing is activated.
# Otherwise Selenium::Remote::Driver::BUILD would be called with missing paramters.
# Extending with 'around' is only done when the the class is actually extended.
{
    # Check whether Selenium testing is activated.
    # Note that $Kernel::OM must exist before this module is loaded.
    my $SeleniumTestsConfig = $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {};

    if ( $SeleniumTestsConfig->%* ) {

        extends 'Test::Selenium::Remote::Driver';

        # Override internal command of base class.
        # We use it to output successful command runs to the UnitTest object.
        # No special error handler is set up.
        around _execute_command => sub {
            my $Orig = shift;
            my $Self = shift;
            my ( $Res, $Params ) = @_;

            # an exception is thrown in case of an error
            my $Result = $Self->$Orig( $Res, $Params );

            # decide whether to emit extra testing events for logging calls of _execute_command()
            return $Result unless $Self->LogExecuteCommandActive;

            # do emit extra testing events for logging calls of _execute_command()
            my $Description = 'Selenium command success: ' .
                $Kernel::OM->Get('Kernel::System::Main')->Dump(
                    {
                        Res    => $Res,
                        Params => $Params,
                    }
                );

            my $Context = context();

            $Context->pass_and_release($Description);

            return $Result;
        };
    }
}

# switch Selenium testing on and off
has SeleniumTestsActive => (
    is      => 'ro',
    default => 0,
);

# for cleaning up Sessions started by the unit tests
has _TestStartSystemTime => (
    is => 'ro',
);

# keep a copy of the config
has _SeleniumTestsConfig => (
    is => 'ro',
);

# suppress testing events
has LogExecuteCommandActive => (
    is      => 'rw',
    default => 0,
);

=head1 NAME

Kernel::System::UnitTest::Selenium - run front end tests

=head1 DESCRIPTION

This class extends Selenium::Remote::Driver when Selenium testing is activated.
You can use the full API of the base object. See L<https://metacpan.org/pod/Selenium::Remote::Driver>.

Activating Selenium is done by adding a hash element in F<Kernel/Config.pm>.
You need a running C<selenium> server in order to do this successfully.
Here are some examples:

    # For testing with Firefox until v. 47 (testing with recent FF and marionette is currently not supported):
    $Self->{'SeleniumTestsConfig'} = {
        remote_server_addr  => 'localhost',
        #check_server_addr   => 1,   # optional, skip test when remote_server_addr can't be resolved via DNS
        #is_wd3              => 0,   # in special cases when JSONWire should be forced
        #is_wd3              => 1,   # in special cases when WebDriver 3 should be forced
        port                => '4444',
        platform            => 'ANY',
        browser_name        => 'firefox',
        extra_capabilities => {
            marionette     => \0,   # Required to run FF 47 or older on Selenium 3+.
        },
    };

    # For testing with Chrome/Chromium (requires installed geckodriver):
    $Self->{'SeleniumTestsConfig'} = {
        remote_server_addr  => 'localhost',
        port                => '4444',
        platform            => 'ANY',
        browser_name        => 'chrome',
        #check_server_addr   => 1,   # optional, skip test when remote_server_addr can't be resolved via DNS
        #is_wd3              => 0,   # in special cases when JSONWire should be forced
        #is_wd3              => 1,   # in special cases when WebDriver 3 should be forced
        extra_capabilities => {
            chromeOptions => {
                # disable-infobars makes sure window size calculations are ok
                args => [ "disable-infobars" ],
            },
        },
    };

Every successful Selenium command will be logged as a successful unit test.
In case of an error, an exception will be thrown that you can catch in your
unit test file and handle with C<HandleError()> in this class. It will output
a failing test result including a stack trace and generate a screen shot for analysis.

=cut

around BUILDARGS => sub {
    my ( $Orig, $Class, @Args ) = @_;

    # check whether Selenium testing is configured.
    my $SeleniumTestsConfig = $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {};

    # no Selenium testing when there is no config.
    return {
        SeleniumTestsActive => 0,
        SeleniumTestsConfig => $SeleniumTestsConfig,
    } unless $SeleniumTestsConfig->%*;

    for my $Needed (qw(remote_server_addr port browser_name platform)) {
        if ( !$SeleniumTestsConfig->{$Needed} ) {
            die "SeleniumTestsConfig must provide $Needed!";
        }
    }

    # Run the tests only when the remote address can be resolved.
    # This avoid the need for manually adaption the test config.
    if ( $SeleniumTestsConfig->{check_server_addr} ) {

        # try to resolve the server, but don't wait for a long time
        my $Resolver = Net::DNS::Resolver->new();
        $Resolver->tcp_timeout(1);
        $Resolver->udp_timeout(1);

        my $Host   = $SeleniumTestsConfig->{remote_server_addr};
        my $Packet = $Resolver->search($Host);

        # no Selenium testing when the remote server can't be resolved
        return {
            SeleniumTestsActive  => 0,
            _SeleniumTestsConfig => $SeleniumTestsConfig,
        } unless $Packet;
    }

    $Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::System::UnitTest::Selenium::WebElement')
        || die "Could not load Kernel::System::UnitTest::Selenium::WebElement";

    my $BaseURL = join '://',
        $Kernel::OM->Get('Kernel::Config')->Get('HttpType'),
        $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetTestHTTPHostname();

    # Remember the start system time for the selenium test run.
    # This is needed for cleaning up OTOBO sessions.
    my $TestStartSystemTime = time;

    return $Class->$Orig(
        SeleniumTestsActive  => 1,
        _SeleniumTestsConfig => $SeleniumTestsConfig,
        _TestStartSystemTime => $TestStartSystemTime,
        base_url             => $BaseURL,
        webelement_class     => 'Kernel::System::UnitTest::Selenium::WebElement',
        javascript           => 1,                                                  # must be explicitly set, as the default is 0 in Test::Selenium::Remove::Driver
        $SeleniumTestsConfig->%*,
        @Args,
    );
};

sub BUILD {
    my $Self = shift;

    return unless $Self->SeleniumTestsActive();

    # Set screen size from config or use defauls.
    my $Height = $Self->_SeleniumTestsConfig()->{window_height} || 1200;
    my $Width  = $Self->_SeleniumTestsConfig()->{window_width}  || 1400;

    my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
    $Self->LogExecuteCommandActive(0);

    # This works only because we have extended Selenium::Remove::Driver.
    $Self->set_window_size( $Height, $Width );

    $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

    return;
}

=head1 PUBLIC INTERFACE

=head2 RunTest()

runs a selenium test only if Selenium testing is activated.

    $SeleniumObject->RunTest( sub { ... } );

=cut

sub RunTest {
    my ( $Self, $Code ) = @_;

    if ( !$Self->SeleniumTestsActive() ) {
        skip_all('Selenium testing is not active, skipping tests.');

        return;
    }

    # This emits a passing event when there is no exception.
    # In case of an exception, the exception will be return as a diagnostic
    # and a failing event will be emitted. $@ will hold the exception.
    my $CodeSuccess = try_ok {
        $Code->();
    }
    'RunTest: no exception';

    if ( !$CodeSuccess ) {

        # HandleError() will create screenshots of the open windows
        $Self->HandleError($@);
    }

    return;
}

=head2 VerifiedGet()

perform a get() call, but wait for the page to be fully loaded (works only within OTOBO).
Will throw an exception when the verification fails.

    $SeleniumObject->VerifiedGet(
        $URL,
    );

The input parameter is a string.

=cut

sub VerifiedGet {
    my ( $Self, $URL ) = @_;

    my $Context = context();

    my $Code = sub {
        $Self->get($URL);

        $Self->WaitFor(
            JavaScript => 'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );
    };

    my $Pass = run_subtest(
        'VerifiedGet',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    $Context->throw('VerifiedGet() failed') unless $Pass;

    $Context->release();

    return;
}

=head2 VerifiedRefresh()

perform a refresh() call, but wait for the page to be fully loaded (works only within OTOBO).
Will throw an exception if the verification fails.

    $SeleniumObject->VerifiedRefresh();

=cut

sub VerifiedRefresh {
    my ( $Self, $URL ) = @_;

    my $Context = context();

    my $Code = sub {
        $Self->refresh();

        $Self->WaitFor(
            JavaScript => 'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );
    };

    my $Pass = run_subtest(
        'VerifiedRefresh',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    $Context->throw('VerifiedRefresh() failed') unless $Pass;

    $Context->release();

    return;
}

=head2 Login()

login to agent or customer interface

    $SeleniumObject->Login(
        Type     => 'Agent', # Agent|Customer
        User     => 'someuser',
        Password => 'somepassword',
    );

=cut

sub Login {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    # check needed stuff
    for (qw(Type User Password)) {
        if ( !$Param{$_} ) {
            note("Need parameter '$_' for Login()");

            return;
        }
    }

    my $Code = sub {

        # we will try up to $MaxTries times to log in
        my $MaxTries        = 5;
        my $LoginSuccessful = 0;

        TRY:
        for my $Try ( 1 .. $MaxTries ) {

            my $ToDo = todo('errors in the login loop are ignored');

            run_subtest(
                "login attempt $Try/$MaxTries",
                sub {
                    eval {
                        # handle some differences between agent and customer interface
                        my $LoginPage = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
                        my $LogoutXPath;          # Logout link differs between Agent and Customer interface.
                        my $CheckForGDPRBlurb;    # only customers need to accept GDPR during login
                        if ( $Param{Type} eq 'Agent' ) {
                            $LoginPage .= 'index.pl';
                            $LogoutXPath       = q{//a[@id='LogoutButton']};
                            $CheckForGDPRBlurb = 0;
                        }
                        else {
                            $LoginPage .= 'customer.pl';
                            $LogoutXPath       = q{//a[@id='oooAvatar']};
                            $CheckForGDPRBlurb = 1;
                        }

                        $Self->get($LoginPage);

                        $Self->delete_all_cookies();

                        # Actually log in, making sure that the params are URL encoded.
                        # Keep the URL relative, so that the configured base URL applies.
                        my $LoginURL = URI->new($LoginPage);
                        $LoginURL->query_form(
                            {
                                Action   => 'Login',
                                User     => $Param{User},
                                Password => $Param{Password},
                            },
                            ';'
                        );
                        $Self->VerifiedGet( $LoginURL->as_string() );

                        # In the customer interface there is a data privacy blurb that must be accepted.
                        # Note that find_element_by_xpath() does not throw exceptions.
                        # The method returns 0 when the element is not found.
                        if ($CheckForGDPRBlurb) {
                            my $AcceptGDPRLink = $Self->find_element_by_xpath(q{//a[@id="AcceptGDPR"]});
                            if ($AcceptGDPRLink) {
                                $AcceptGDPRLink->click();
                            }
                        }

                        # login successful?
                        $Self->find_element( $LogoutXPath, 'xpath' );    # throws exception if not found
                    };

                    if ($@) {

                        # login was not successful
                        note("Login attempt $Try/$MaxTries failed");
                    }
                    else {

                        # no error happend
                        note("Login attempt $Try/$MaxTries succeeded");
                        $LoginSuccessful = 1;
                    }
                },
                {
                    buffered      => 1,
                    inherit_trace => 1
                }
            );

            # no need to try again when login succeeded
            last TRY if $LoginSuccessful;
        }

        # this decides whether the subtest succeeds
        ok( $LoginSuccessful, 'Login successful' );
    };

    my $Pass = run_subtest(
        'Login',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    $Context->throw('Login() failed') unless $Pass;

    $Context->release();

    return 1;
}

=head2 WaitFor()

wait with increasing sleep intervals until the given condition is true or the wait time is over.
Exactly one condition (JavaScript or WindowCount) must be specified.

    my $Success = $SeleniumObject->WaitFor(
        AlertPresent   => 1,                                 # Wait until an alert, confirm or prompt dialog is present
        Callback       => sub { ... }                        # Wait until function returns true
        ElementExists  => 'xpath-selector'                   # Wait until an element is present
        ElementExists  => [
            'css-selector',
            'css'
        ],
        ElementMissing => 'xpath-selector',                  # Wait until an element is not present
        ElementMissing => [
            'css-selector',
            'css'
        ],
        JavaScript     => 'return $(".someclass").length',   # Javascript code that checks condition
        JavaScript     => [                                  # pass an arrayref when arguments are needed
            q{return arguments[0].length},
            $SomeElement
        ],
        WindowCount    => 2,                                 # Wait until this many windows are open
        Time           => 20,                                # optional, wait time in seconds (default 20)
    );

=cut

sub WaitFor {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    if (
        !$Param{JavaScript}
        && !$Param{WindowCount}
        && !$Param{AlertPresent}
        && !$Param{Callback}
        && !$Param{ElementExists}
        && !$Param{ElementMissing}
        )
    {
        $Context->throw("Need JavaScript, WindowCount, ElementExists, ElementMissing, Callback or AlertPresent.");
    }

    my $TimeOut                 = $Param{Time} // 20;              # time span after which WaitFor() gives up
    my $WaitedSeconds           = 0;                               # counting up to $TimeOut
                                                                   # Apparently some WaitFor() call fail because some elements show up only briefly.
                                                                   # This might cause heisenbugs.
                                                                   # Therefore fine tune the initial sleep times.
    my $Interval                = 0.1;                             # starting value of intervals, except for find_element()
    my @FindElementIntervals    = ( 0.025, 0.050, 0.075, 0.1 );    # shorter initials intervals for find_element()
    my $IntervalIncrement       = 0.1;                             # make the intervals larger the longer the wait time is
    my $FindElementSleepSeconds = 0.5;                             # sleep after a successful find_element(), no idea why this is useful

    my $Success = 0;

    WAIT:
    while ( $WaitedSeconds <= $TimeOut ) {

        if ( $Param{JavaScript} ) {
            my @Arguments                   = ref $Param{JavaScript} eq 'ARRAY' ? $Param{JavaScript}->@* : $Param{JavaScript};
            my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
            $Self->LogExecuteCommandActive(0);

            my $Ret = $Self->execute_script(@Arguments);

            $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

            if ($Ret) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{WindowCount} ) {
            my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
            $Self->LogExecuteCommandActive(0);

            my $NumWindows = scalar $Self->get_window_handles()->@*;

            $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

            if ( $NumWindows == $Param{WindowCount} ) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{AlertPresent} ) {

            my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
            $Self->LogExecuteCommandActive(0);

            # Eval is needed because the method would throw if no alert is present (yet).
            my $Ret = eval { $Self->get_alert_text() };

            $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

            if ($Ret) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{Callback} ) {
            my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
            $Self->LogExecuteCommandActive(0);

            my $Ret = $Param{Callback}->();

            $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

            if ($Ret) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{ElementExists} ) {
            my @Arguments = ref $Param{ElementExists} eq 'ARRAY' ? $Param{ElementExists}->@* : $Param{ElementExists};

            my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
            $Self->LogExecuteCommandActive(0);

            my $Ret = eval { $Self->find_element(@Arguments) };

            $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

            if ($Ret) {
                Time::HiRes::sleep($FindElementSleepSeconds);

                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{ElementMissing} ) {
            my @Arguments = ref $Param{ElementMissing} eq 'ARRAY' ? $Param{ElementMissing}->@* : $Param{ElementMissing};

            my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
            $Self->LogExecuteCommandActive(0);

            my $Ret = eval { $Self->find_element(@Arguments) };

            $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

            if ( !$Ret ) {
                Time::HiRes::sleep($FindElementSleepSeconds);

                $Success = 1;

                last WAIT;
            }
        }

        # Interval timing is solely trial and error
        if ( @FindElementIntervals && ( $Param{ElementExists} || $Param{ElementMissing} ) ) {
            $Interval = shift @FindElementIntervals;
        }
        Time::HiRes::sleep($Interval);
        $WaitedSeconds += $Interval;
        $Interval      += $IntervalIncrement;

        $Context->note("waited for $WaitedSeconds s");
    }

    # something short that identfies the WaitFor target
    my $Argument = '';
    {
        # scalar or arrayref parameters
        for my $Key (qw(JavaScript WindowCount AlertPresent ElementExists ElementMissing)) {
            if ( $Param{$Key} ) {
                my $Value = ref $Param{$Key} eq 'ARRAY' ? $Param{$Key}->[0] : $Param{$Key};
                $Argument = join ' => ', $Key, $Value;
            }
        }

        # more complex parameters
        for my $Key (qw(Callback)) {
            $Argument = $Key if $Param{$Key};
        }
    }

    # Release context and throw exception in case of failure.
    # Don't care about any special handling for the stack trace.
    $Context->throw("WaitFor($Argument) timed out") unless $Success;

    # successful
    $Context->pass_and_release("WaitFor($Argument)");

    return 1;
}

=head2 SwitchToFrame()

Change focus to another frame on the page. If C<WaitForLoad> is passed, it will wait until the frame has loaded the
page completely.

    my $Success = $SeleniumObject->SwitchToFrame(
        FrameSelector => '.Iframe',     # (required) CSS selector of the frame element
        WaitForLoad   => 1,             # (optional) Wait until the frame has loaded, if necessary
        Time          => 20,            # (optional) Wait time in seconds (default 20)
    );

=cut

sub SwitchToFrame {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    $Context->throw('Need FrameSelector.') unless $Param{FrameSelector};

    if ( $Param{WaitForLoad} ) {
        $Self->WaitFor(
            JavaScript => "return typeof(\$('$Param{FrameSelector}').get(0).contentWindow.Core) == 'object'
                && typeof(\$('$Param{FrameSelector}').get(0).contentWindow.Core.App) == 'object'
                && \$('$Param{FrameSelector}').get(0).contentWindow.Core.App.PageLoadComplete;",
            Time => $Param{Time},
        );
    }

    $Self->switch_to_frame( $Self->find_element( $Param{FrameSelector}, 'css' ) );

    $Context->release();

    return 1;
}

=head2 DragAndDrop()

Drag and drop an element.

    $SeleniumObject->DragAndDrop(
        Element         => '.Element', # (required) css selector of element which should be dragged
        Target          => '.Target',  # (required) css selector of element on which the dragged element should be dropped
        TargetOffset    => {           # (optional) Offset for target. If not specified, the mouse will move to the middle of the element.
            X   => 150,
            Y   => 100,
        }
    );

See also C<Selenium::ActionChains::drag_and_drop()>.
The difference in these subroutines is that C<drag_and_drop> does not support target offset.

=cut

sub DragAndDrop {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    # Value is optional parameter
    for my $Needed (qw(Element Target)) {
        $Context->throw("Need $Needed") unless $Param{$Needed};
    }

    my $Code = sub {

        my %TargetOffset;
        if ( $Param{TargetOffset} ) {
            %TargetOffset = (
                xoffset => $Param{TargetOffset}->{X} || 0,
                yoffset => $Param{TargetOffset}->{Y} || 0,
            );
        }

        # Make sure Element is visible
        $Self->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(\'' . $Param{Element} . ':visible\').length;',
        );
        my $Element = $Self->find_element( $Param{Element}, 'css' );

        # Make sure Target is visible
        $Self->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(\'' . $Param{Target} . ':visible\').length;',
        );
        my $Target = $Self->find_element( $Param{Target}, 'css' );

        # Move mouse to from element, drag and drop
        $Self->mouse_move_to_location( element => $Element );

        # Holds the mouse button on the element
        $Self->button_down();

        # Move mouse to the destination
        $Self->mouse_move_to_location(
            element => $Target,
            %TargetOffset,
        );

        # Release
        $Self->button_up();

        # With WebDriver 3 the preceeding mouse movements and mouse button actions are only queued.
        # Perform the actions now.
        $Self->general_action();
    };

    my $Pass = run_subtest(
        'DragAndDrop',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    $Context->throw('DragAndDrop failed') unless $Pass;

    $Context->release();

    return;
}

=head2 HandleError()

use this method to handle any Selenium exceptions.

    $SeleniumObject->HandleError($@);

It will store a screen shot of the page in $OTOBO_HOME/var/httpd/htdocs/SeleniumScreenshots.
If the folder /var/otobo-unittest exists, then a copy of the screenshot will be placed there too.

=cut

sub HandleError {
    my ( $Self, $Error ) = @_;

    my $Context = context();

    # Store screenshots in a local folder from where they can be opened directly in the browser.
    # If we can't store the screenshots, then there is no use in creating them.
    my $LocalScreenshotDir = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/httpd/htdocs/SeleniumScreenshots';
    mkdir $LocalScreenshotDir unless -e $LocalScreenshotDir;
    if ( !-d $LocalScreenshotDir ) {
        $Context->note("Could not create the screenshot directory $LocalScreenshotDir: $!");
        $Context->release();

        return;
    }

    # If a shared screenshot folder is present, then we also store the screenshot there for external use.
    my $SharedScreenshotDir;
    if ( -d -w '/var/otobo-unittest/' ) {

        $SharedScreenshotDir = '/var/otobo-unittest/SeleniumScreenshots';
        mkdir $SharedScreenshotDir unless -e $SharedScreenshotDir;
        if ( !-d $SharedScreenshotDir ) {
            $Context->note("Could not create the directory $SharedScreenshotDir: $!");

            undef $SharedScreenshotDir;
        }
    }

    # No need to log generation of the screenshot.
    my $PrevLogExecuteCommandActive = $Self->LogExecuteCommandActive;
    $Self->LogExecuteCommandActive(0);

    # the file name of the screenshot is random
    my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomNumber();

    # take screen shots of all browser windows
    my $WindowCount = 1;
    WINDOW_HANDLE:
    for my $WindowHandle ( $Self->get_window_handles()->@* ) {

        # select the window
        try {
            $Self->switch_to_window($WindowHandle);
        }
        catch {
            next WINDOW_HANDLE;
        };

        my $Filename  = "${RandomID}_${WindowCount}.png";
        my $LocalPath = File::Spec->catfile( $LocalScreenshotDir, $Filename );

        # No worries when the screenshot can't be written.
        $Self->capture_screenshot($LocalPath);

        if ( !-f $LocalPath ) {
            $Context->note("Could not create screenshot $LocalPath");

            next WINDOW_HANDLE;
        }

        # Tell the tester about the screenshot.
        {
            my $HttpType = $Kernel::OM->Get('Kernel::Config')->Get('HttpType');
            my $Hostname = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetTestHTTPHostname();
            my $URL      = "$HttpType://$Hostname/"
                . $Kernel::OM->Get('Kernel::Config')->Get('Frontend::WebPath')
                . "SeleniumScreenshots/$Filename";

            $Context->note("Saved screenshot in $URL");
        }

        # If a shared screenshot folder is present, then we also store the screenshot there for external use.
        next WINDOW_HANDLE unless $SharedScreenshotDir;

        my $SharedScreenshotDir = '/var/otobo-unittest/SeleniumScreenshots';
        mkdir $SharedScreenshotDir unless -e $SharedScreenshotDir;
        if ( !-d $SharedScreenshotDir ) {
            $Context->note("Could not create the directory $SharedScreenshotDir: $!");

            next WINDOW_HANDLE;
        }

        my $CopySuccess = copy( $LocalPath, $SharedScreenshotDir );
        if ( !$CopySuccess ) {
            $Context->note("Could not write file $SharedScreenshotDir/$Filename");
        }
    }
    continue {
        $WindowCount++;
    }

    $Self->LogExecuteCommandActive($PrevLogExecuteCommandActive);

    $Context->release();

    return;
}

=head2 DEMOLISH()

override DEMOLISH from L<Selenium::Remote::Driver> (required because this class is managed by L<Moo>).
Performs proper error handling (calls C<HandleError()> if needed). Adds a unit test result to indicate the shutdown,
and performs some clean-ups.

=cut

sub DEMOLISH {
    my $Self = shift;

    return unless $Self->SeleniumTestsActive();

    $Self->LogExecuteCommandActive(0);

    # Cleanup possibly leftover zombie firefox profiles.
    {
        my @LeftoverFirefoxProfiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => '/tmp/',
            Filter    => 'anonymous*webdriver-profile',
        );

        for my $LeftoverFirefoxProfile (@LeftoverFirefoxProfiles) {
            if ( -d $LeftoverFirefoxProfile ) {
                remove_tree($LeftoverFirefoxProfile);
            }
        }
    }

    # Cleanup all sessions which were created after the selenium test start time.
    {
        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        my @Sessions = $AuthSessionObject->GetAllSessionIDs();

        SESSION:
        for my $SessionID (@Sessions) {

            my %SessionData = $AuthSessionObject->GetSessionIDData( SessionID => $SessionID );

            next SESSION unless %SessionData;
            next SESSION
                if $SessionData{UserSessionStart} && $SessionData{UserSessionStart} < $Self->_TestStartSystemTime();

            $AuthSessionObject->RemoveSessionID( SessionID => $SessionID );
        }
    }

    return;
}

=head2 WaitForjQueryEventBound()

waits until event handler is bound to the selected C<jQuery> element.

    $SeleniumObject->WaitForjQueryEventBound(
        CSSSelector => 'li > a#Test',       # (required) css selector
        Event       => 'click',             # (optional) Specify event name. Default 'click'.
    );

=cut

sub WaitForjQueryEventBound {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    # Check needed stuff.
    if ( !$Param{CSSSelector} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CSSSelector!",
        );

        return;
    }

    my $Event = $Param{Event} || 'click';

    my $Code = sub {

        # Wait for element availability.
        $Self->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("' . $Param{CSSSelector} . '").length;'
        );

        # Wait for jQuery initialization.
        $Self->WaitFor(
            JavaScript => 'return Object.keys($("' . $Param{CSSSelector} . '")[0]).length > 0'
        );

        # Get jQuery object keys.
        my $Keys = $Self->execute_script(
            'return Object.keys($("' . $Param{CSSSelector} . '")[0]);'
        );

        if ( !IsArrayRefWithData($Keys) ) {
            $Context->throw("Couldn't determine jQuery object id");
        }

        my $JQueryObjectID;

        KEY:
        for my $Key ( @{$Keys} ) {
            if ( $Key =~ m{^jQuery\d+$} ) {
                $JQueryObjectID = $Key;

                last KEY;
            }
        }

        if ( !$JQueryObjectID ) {
            $Context->throw("Couldn't determine jQuery object id.");
        }

        # Wait until click event is bound to the element.
        $Self->WaitFor(
            JavaScript =>
                'return $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events
                    && $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events.' . $Event . '
                    && $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events.' . $Event . '.length > 0;',
        );
    };

    my $Pass = run_subtest(
        'WaitForjQueryEventBound()',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    $Context->throw('WaitForjQueryEventBound() failed') unless $Pass;

    $Context->release();

    return 1;
}

=head2 InputFieldValueSet()

sets modernized input field value.

    $SeleniumObject->InputFieldValueSet(
        Element => 'css-selector',              # (required) css selector
        Value   => 3,                           # (optional) Value
    );

Sometimes a longer timeout is needed.

    $SeleniumObject->InputFieldValueSet(
        Element => 'css-selector',              # (required) css selector
        Value   => 3,                           # (optional) Value
        Time    => 60,                          # (optional) timeout in seconds
    );

=cut

sub InputFieldValueSet {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    # Check needed stuff.
    if ( !$Param{Element} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Element!",
        );

        $Context->throw('Missing Element.');
    }

    my $Value = $Param{Value} // '';

    # Quote text of Value is not array and if not already quoted.
    if ( $Value !~ m{^\[} && $Value !~ m{^".*"$} ) {
        $Value = qq{"$Value"};
    }

    my $Code = sub {

        # Set selected value.
        $Self->execute_script(
            "\$('$Param{Element}').val($Value).trigger('redraw.InputField').trigger('change');"
        );

        # Wait until selection tree is closed.
        $Self->WaitFor(
            ElementMissing => [ '.InputField_ListContainer', 'css' ],
            Time           => $Param{Time},
        );
    };

    my $Pass = run_subtest(
        'InputFieldValueSet()',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    $Context->throw('InputFieldValueSet() failed') unless $Pass;

    $Context->release();

    return 1;
}

=head2 find_element_by_xpath_ok

Call call Selenium::Remote::Driver::find_element_by_xpath() and emit testing event accordingly.

=cut

sub find_element_by_xpath_ok {
    my ( $Self, $Selector, $TestDescription ) = @_;

    $TestDescription //= 'find_element_by_xpath_ok';

    my $Context = context();

    my $MaybeElement = $Self->find_element_by_xpath($Selector);

    if ($MaybeElement) {
        $Context->pass_and_release($TestDescription);

        return 1;
    }

    $Context->fail_and_release($TestDescription);

    return 0;
}

=head2 find_no_element_by_xpath_ok

Call call Selenium::Remote::Driver::find_element_by_xpath() and emit testing event accordingly.

=cut

sub find_no_element_by_xpath_ok {
    my ( $Self, $Selector, $TestDescription ) = @_;

    $TestDescription //= 'find_no_element_by_xpath_ok';

    my $Context = context();

    my $MaybeElement = $Self->find_element_by_xpath($Selector);

    if ( !$MaybeElement ) {
        $Context->pass_and_release($TestDescription);

        return 1;
    }

    $Context->fail_and_release($TestDescription);

    return 0;
}

=head2 find_element_by_css_ok

Call call Selenium::Remote::Driver::find_element_by_css() and emit testing event accordingly.

=cut

sub find_element_by_css_ok {
    my ( $Self, $Selector, $TestDescription ) = @_;

    $TestDescription //= 'find_element_by_css_ok';

    my $Context = context();

    my $MaybeElement = $Self->find_element_by_css($Selector);

    if ($MaybeElement) {
        $Context->pass_and_release($TestDescription);

        return 1;
    }

    $Context->fail_and_release($TestDescription);

    return 0;
}

=head2 find_no_element_by_css_ok

Call call Selenium::Remote::Driver::find_element_by_css() and emit testing event accordingly.

=cut

sub find_no_element_by_css_ok {
    my ( $Self, $Selector, $TestDescription ) = @_;

    $TestDescription //= 'find_no_element_by_css_ok';

    my $Context = context();

    my $MaybeElement = $Self->find_element_by_css($Selector);

    if ( !$MaybeElement ) {
        $Context->pass_and_release($TestDescription);

        return 1;
    }

    $Context->fail_and_release($TestDescription);

    return 0;
}

1;
