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

package Kernel::System::UnitTest::Selenium;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules
use MIME::Base64 qw(decode_base64);
use File::Path qw(remove_tree);
use Time::HiRes qw();

# CPAN modules
use Devel::StackTrace();
use Test2::API qw(context);
use Net::DNS::Resolver;

# OTOBO modules
use Kernel::Config;
use Kernel::System::User;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::DateTime',
    'Kernel::System::UnitTest::Helper',
);

# If a test throws an exception, we'll record it here in a package variable so that we can
#   take screenshots of *all* Selenium instances that are currently running on shutdown.
our $TestException;

=head1 NAME

Kernel::System::UnitTest::Selenium - run front end tests

This class inherits from Selenium::Remote::Driver. You can use
its full API (see
L<http://search.cpan.org/~aivaturi/Selenium-Remote-Driver-0.15/lib/Selenium/Remote/Driver.pm>).

Every successful Selenium command will be logged as a successful unit test.
In case of an error, an exception will be thrown that you can catch in your
unit test file and handle with C<HandleError()> in this class. It will output
a failing test result and generate a screen shot for analysis.

=head2 new()

create a selenium object to run front end tests.

To do this, you need a running C<selenium> or C<phantomjs> server.

Specify the connection details in C<Config.pm>, like this:

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

Then you can use the full API of L<Selenium::Remote::Driver> on this object.

=cut

sub new {
    my $Class = shift;

    # check whether Selenium testing is activated.
    my %SeleniumTestsConfig =  ( $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {} )->%*;

    return bless { SeleniumTestsActive => 0 }, $Class unless %SeleniumTestsConfig;

    for my $Needed (qw(remote_server_addr port browser_name platform)) {
        if ( !$SeleniumTestsConfig{$Needed} ) {
            die "SeleniumTestsConfig must provide $Needed!";
        }
    }

    # Run the tests only when the remote address can be resolved.
    # This avoid the need for manually adaption the test config.
    my $DoCheckServerAddr = delete $SeleniumTestsConfig{check_server_addr};
    if ( $DoCheckServerAddr ) {

        # try to resolve the server, but don't wait for a long time
        my $Resolver = Net::DNS::Resolver->new();
        $Resolver->tcp_timeout(1);
        $Resolver->udp_timeout(1);

        my $Host = $SeleniumTestsConfig{remote_server_addr};
        my $Packet = $Resolver->search( $Host );

        # no Selenium testing when the remote server can't be resolved
        return bless { SeleniumTestsActive => 0 }, $Class unless $Packet;
    }

    $Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass('Selenium::Remote::Driver')
        || die "Could not load Selenium::Remote::Driver";

    $Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::System::UnitTest::Selenium::WebElement')
        || die "Could not load Kernel::System::UnitTest::Selenium::WebElement";

    # looks like is_wd3 can't be passed in the constructor,
    # and that an automatic check is not implemented
    my $IsWD3 = delete $SeleniumTestsConfig{is_wd3};

    # TEMPORARY WORKAROUND FOR GECKODRIVER BUG https://github.com/mozilla/geckodriver/issues/1470:
    #   If marionette handshake fails, wait and try again. Can be removed after the bug is fixed
    #   in a new geckodriver version.
    my $Self = eval {
        $Class->SUPER::new(
            webelement_class => 'Kernel::System::UnitTest::Selenium::WebElement',
            error_handler    => sub {
                my $Self = shift;

                return $Self->SeleniumErrorHandler(@_);
            },
            %SeleniumTestsConfig
        );
    };
    if ($@) {
        my $Exception = $@;

        # Only handle this specific geckodriver exception.
        die $Exception if $Exception !~ m{Socket timeout reading Marionette handshake data};

        # Sleep and try again, bail out if it fails a second time.
        #   A long sleep of 10 seconds is acceptable here, as it occurs only very rarely.
        sleep 10;

        $Self = $Class->SUPER::new(
            webelement_class => 'Kernel::System::UnitTest::Selenium::WebElement',
            error_handler    => sub {
                my $Self = shift;

                return $Self->SeleniumErrorHandler(@_);
            },
            %SeleniumTestsConfig
        );
    }

    $Self->{SeleniumTestsActive}  = 1;

    # TODO: remove this workaround when it is no longer needed
    if ( defined $IsWD3 ) {
        $Self->{is_wd3} = $IsWD3;
    }

    # Not sure what this was used for.
    # $Self->{UnitTestDriverObject}->{SeleniumData} = { %{ $Self->get_capabilities() }, %{ $Self->status() } };
    # $Self->debug_on();

    # set screen size from config or use defauls
    {
        my $Height = $SeleniumTestsConfig{window_height} || 1200;
        my $Width  = $SeleniumTestsConfig{window_width}  || 1400;
        $Self->set_window_size( $Height, $Width );
    }

    $Self->{BaseURL} = $Kernel::OM->Get('Kernel::Config')->Get('HttpType') . '://';
    $Self->{BaseURL} .= Kernel::System::UnitTest::Helper->GetTestHTTPHostname();

    # Remember the start system time for the selenium test run.
    $Self->{TestStartSystemTime} = time;    ## no critic

    return $Self;
}

sub SeleniumErrorHandler {
    my ( $Self, $Error ) = @_;

    my $SuppressFrames;

    # Generate stack trace information.
    #   Don't store caller args, as this sometimes blows up due to an internal Perl bug
    #   (see https://github.com/Perl/perl5/issues/10687).
    my $StackTrace = Devel::StackTrace->new(
        indent         => 1,
        no_args        => 1,
        ignore_package => [ 'Selenium::Remote::Driver', 'Try::Tiny', __PACKAGE__ ],
        message        => 'Selenium stack trace started',
        frame_filter   => sub {

            # Limit stack trace to test evaluation itself.
            return 0          if $SuppressFrames;

            # TODO: this needs to be adapted
            $SuppressFrames++ if $_[0]->{caller}->[3] eq 'Kernel::System::UnitTest::Driver::Run';

            # Remove the long serialized eval texts from the frame to keep the trace short.
            if ( $_[0]->{caller}->[6] ) {
                $_[0]->{caller}->[6] = '{...}';
            }

            return 1;
        }
    )->as_string();

    $Self->{_SeleniumStackTrace} = $StackTrace;
    $Self->{_SeleniumException}  = $Error;

    die $Error;
}

=head2 RunTest()

runs a selenium test if Selenium testing is configured.

    $SeleniumObject->RunTest( sub { ... } );

=cut

sub RunTest {
    my $Self = shift;
    my ( $Code ) = @_;

    my $Context = context();

    if ( $Self->{SeleniumTestsActive} ) {
        eval {
            $Code->();
        };

        if ( $@ ) {
            $TestException = $@;     # remember the exception becaus the screenshot is taken later, during DEMOLISH
            $Context->fail( $@ );    # report the failure before done_testing()
        }

    }
    else {
        $Context->skip( 'Selenium testing is not active, skipping tests.' );
    }

    $Context->release();

    return 1;
}

=begin Internal:

=head2 _execute_command()

Override internal command of base class.

We use it to output successful command runs to the UnitTest object.
Errors will cause an exeption and be caught elsewhere.

=end Internal:

=cut

sub _execute_command {    ## no critic
    my $Self  = shift;
    my ($Res, $Params) = @_;

    my $Result = $Self->SUPER::_execute_command( $Res, $Params );

    # The command 'quit' is called in the destructor on this packages.
    # Destruction usually happens after done_testing(), which is bad.
    # So don't emit a testing event for 'quit'.
    if ( ref $Res eq 'HASH' && $Res->{command} ) {
        my %CommandIsSkipped = (
            quit       => 1,
            screenshot => 1,
        );

        return $Result if $CommandIsSkipped{ $Res->{command} };
    }

    my $TestName = 'Selenium command success: ';
    $TestName .= $Kernel::OM->Get('Kernel::System::Main')->Dump(
        {
            Res    => $Res,
            Params => $Params,
        }
    );

    my $Context = context();

    if ( $Self->{SuppressCommandRecording} ) {
        $Context->note( $TestName );
    }
    else {
        $Context->pass( $TestName );
    }

    $Context->release();

    return $Result;
}

=head2 get()

Override get method of base class to prepend the correct base URL.

    $SeleniumObject->get(
        $URL,
    );

=cut

sub get {    ## no critic
    my ( $Self, $URL ) = @_;

    if ( $URL !~ m{http[s]?://}smx ) {
        $URL = "$Self->{BaseURL}/$URL";
    }

    $Self->SUPER::get($URL);

    return;
}

=head2 get_alert_text()

Override get_alert_text() method of base class to return alert text as string.

    my $AlertText = $SeleniumObject->get_alert_text();

returns

    my $AlertText = 'Some alert text!'

=cut

sub get_alert_text {    ## no critic
    my ($Self) = @_;

    my $AlertText = $Self->SUPER::get_alert_text();

    die "Alert dialog is not present" if ref $AlertText eq 'HASH';    # Chrome returns HASH when there is no alert text.

    return $AlertText;
}

=head2 VerifiedGet()

perform a get() call, but wait for the page to be fully loaded (works only within OTOBO).
Will die() if the verification fails.

    $SeleniumObject->VerifiedGet(
        $URL,
    );

=cut

sub VerifiedGet {
    my ( $Self, $URL ) = @_;

    $Self->get($URL);

    $Self->WaitFor(
        JavaScript =>
            'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
    ) || die "OTOBO API verification failed after page load.";

    return;
}

=head2 VerifiedRefresh()

perform a refresh() call, but wait for the page to be fully loaded (works only within OTOBO).
Will die() if the verification fails.

    $SeleniumObject->VerifiedRefresh();

=cut

sub VerifiedRefresh {
    my ( $Self, $URL ) = @_;

    $Self->refresh();

    $Self->WaitFor(
        JavaScript =>
            'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
    ) || die "OTOBO API verification failed after page load.";

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

    # check needed stuff
    for (qw(Type User Password)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );

            return;
        }
    }

    my $Context = context();

    $Context->note( 'Initiating login...' );

    # we will try several times to log in
    my $MaxTries = 5;

    TRY:
    for my $Try ( 1 .. $MaxTries ) {

        eval {
            my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

            if ( $Param{Type} eq 'Agent' ) {
                $ScriptAlias .= 'index.pl';
            }
            else {
                $ScriptAlias .= 'customer.pl';
            }

            $Self->get("${ScriptAlias}");

            $Self->delete_all_cookies();
            $Self->VerifiedGet("${ScriptAlias}?Action=Login;User=$Param{User};Password=$Param{Password}");

            # login successful?
            $Self->find_element( 'a#LogoutButton', 'css' );    # dies if not found

            $Context->pass( 'Login sequence ended...' );
        };

        # an error happend
        if ($@) {

            $Context->note( "Login attempt $Try of $MaxTries not successful." );

            # try again
            next TRY if $Try < $MaxTries;

            $Context->release();

            die "Login failed!";
        }

        # login was sucessful
        else {
            last TRY;
        }
    }

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
        ElementExists  => ['css-selector', 'css'],
        ElementMissing => 'xpath-selector',                  # Wait until an element is not present
        ElementMissing => ['css-selector', 'css'],
        JavaScript     => 'return $(".someclass").length',   # Javascript code that checks condition
        WindowCount    => 2,                                 # Wait until this many windows are open
        Time           => 20,                                # optional, wait time in seconds (default 20)
    );

=cut

sub WaitFor {
    my ( $Self, %Param ) = @_;

    if (
        !$Param{JavaScript}
        && !$Param{WindowCount}
        && !$Param{AlertPresent}
        && !$Param{Callback}
        && !$Param{ElementExists}
        && !$Param{ElementMissing}
        )
    {
        die "Need JavaScript, WindowCount, ElementExists, ElementMissing, Callback or AlertPresent.";
    }

    local $Self->{SuppressCommandRecording} = 1;

    $Param{Time} //= 20;
    my $WaitedSeconds = 0;
    my $Interval      = 0.1;
    my $WaitSeconds   = 0.5;

    while ( $WaitedSeconds <= $Param{Time} ) {
        if ( $Param{JavaScript} ) {
            return 1 if $Self->execute_script( $Param{JavaScript} );
        }
        elsif ( $Param{WindowCount} ) {
            return 1 if scalar( @{ $Self->get_window_handles() } ) == $Param{WindowCount};
        }
        elsif ( $Param{AlertPresent} ) {

            # Eval is needed because the method would throw if no alert is present (yet).
            return 1 if eval { $Self->get_alert_text() };
        }
        elsif ( $Param{Callback} ) {
            return 1 if $Param{Callback}->();
        }
        elsif ( $Param{ElementExists} ) {
            my @Arguments
                = ref( $Param{ElementExists} ) eq 'ARRAY' ? @{ $Param{ElementExists} } : $Param{ElementExists};

            if ( eval { $Self->find_element(@Arguments) } ) {
                Time::HiRes::sleep($WaitSeconds);

                return 1;
            }
        }
        elsif ( $Param{ElementMissing} ) {
            my @Arguments
                = ref( $Param{ElementMissing} ) eq 'ARRAY' ? @{ $Param{ElementMissing} } : $Param{ElementMissing};

            if ( !eval { $Self->find_element(@Arguments) } ) {
                Time::HiRes::sleep($WaitSeconds);

                return 1;
            }
        }

        Time::HiRes::sleep($Interval);
        $WaitedSeconds += $Interval;
        $Interval      += 0.1;
    }

    my $Argument = '';
    for my $Key (qw(JavaScript WindowCount AlertPresent)) {
        $Argument = "$Key => $Param{$Key}" if $Param{$Key};
    }
    $Argument = "Callback" if $Param{Callback};

    # Use the selenium error handler to generate a stack trace.
    die $Self->SeleniumErrorHandler("WaitFor($Argument) failed.\n");
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

    if ( !$Param{FrameSelector} ) {
        die 'Need FrameSelector.';
    }

    if ( $Param{WaitForLoad} ) {
        $Self->WaitFor(
            JavaScript => "return typeof(\$('$Param{FrameSelector}').get(0).contentWindow.Core) == 'object'
                && typeof(\$('$Param{FrameSelector}').get(0).contentWindow.Core.App) == 'object'
                && \$('$Param{FrameSelector}').get(0).contentWindow.Core.App.PageLoadComplete;",
            Time => $Param{Time},
        );
    }

    $Self->switch_to_frame( $Self->find_element( $Param{FrameSelector}, 'css' ) );

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

=cut

sub DragAndDrop {

    my ( $Self, %Param ) = @_;

    # Value is optional parameter
    for my $Needed (qw(Element Target)) {
        if ( !$Param{$Needed} ) {
            die "Need $Needed";
        }
    }

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

    # Move mouse to from element, drag and drop
    $Self->mouse_move_to_location( element => $Element );

    # Holds the mouse button on the element
    $Self->button_down();

    # Make sure Target is visible
    $Self->WaitFor(
        JavaScript => 'return typeof($) === "function" && $(\'' . $Param{Target} . ':visible\').length;',
    );
    my $Target = $Self->find_element( $Param{Target}, 'css' );

    # Move mouse to the destination
    $Self->mouse_move_to_location(
        element => $Target,
        %TargetOffset,
    );

    # Release
    $Self->button_up();

    return;
}

=head2 HandleError()

use this method to handle any Selenium exceptions.

    $SeleniumObject->HandleError($@);

It will create a failing test result and store a screen shot of the page
for analysis (in folder /var/otobo-unittest if it exists, in $Home/var/httpd/htdocs otherwise).

=cut

sub HandleError {
    my $Self = shift;
    my ( $Error, $InGlobalDestruction ) = @_;

    # If we really have a selenium error, get the stack trace for it.
    if ( $Self->{_SeleniumStackTrace} && $Error eq $Self->{_SeleniumException} ) {
        $Error .= "\n" . $Self->{_SeleniumStackTrace};
    }

    my $Context = context();

    if ( $InGlobalDestruction ) {
        $Context->note( $Error );
    }
    else {
        $Context->fail( $Error );
    }

    # Don't create a test entry for the screenshot command,
    #   to make sure it gets attached to the previous error entry.
    local $Self->{SuppressCommandRecording} = 1;

    my $Data = $Self->screenshot();
    if ( !$Data ) {
        $Context->release();

        return;
    }

    $Data = decode_base64($Data);

    # Attach the screenshot to the actual error entry.
    my $Filename = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomNumber() . '.png';

    # TODO: is that feature still useful ? AFAIK OTOBO has no test result upload service.
    #$Kernel::OM->Get('Kernel::System::UnitTest::Driver')->AttachSeleniumScreenshot(
    #    Filename => $Filename,
    #    Content  => $Data
    #);

    # Store screenshots in a local folder from where they can be opened directly in the browser.
    my $LocalScreenshotDir = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/httpd/htdocs/SeleniumScreenshots';
    mkdir $LocalScreenshotDir || return $Self->False( 1, "Could not create $LocalScreenshotDir." );

    my $HttpType = $Kernel::OM->Get('Kernel::Config')->Get('HttpType');
    my $Hostname = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetTestHTTPHostname();
    my $URL      = "$HttpType://$Hostname/"
        . $Kernel::OM->Get('Kernel::Config')->Get('Frontend::WebPath')
        . "SeleniumScreenshots/$Filename";

    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Directory => $LocalScreenshotDir,
        Filename  => $Filename,
        Content   => \$Data,
    ) || return $Self->False( 1, "Could not write file $LocalScreenshotDir/$Filename" );

    #
    # If a shared screenshot folder is present, then we also store the screenshot there for external use.
    #
    if ( -d '/var/otobo-unittest/' && -w '/var/otobo-unittest/' ) {

        my $SharedScreenshotDir = '/var/otobo-unittest/SeleniumScreenshots';
        mkdir $SharedScreenshotDir || return $Self->False( 1, "Could not create $SharedScreenshotDir." );

        my $WriteSuccess = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Directory => $SharedScreenshotDir,
            Filename  => $Filename,
            Content   => \$Data,
        );
        if ( ! $WriteSuccess ) {
            $Context->note( "Could not write file $SharedScreenshotDir/$Filename" );

            $Context->release();

            return;
        }
    }

    # Make sure the screenshot URL is output even in non-verbose mode to make it visible
    #   for debugging, but don't register it as a test failure to keep the error count more correct.
    $Context->note( "Saved screenshot in $URL" );

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
    my ($InGlobalDestruction) = @_;

    if ($TestException) {
        $Self->HandleError($TestException, $InGlobalDestruction);
    }

    if ( $Self->{SeleniumTestsActive} ) {
        $Self->SUPER::DEMOLISH(@_);

        # Cleanup possibly leftover zombie firefox profiles.
        my @LeftoverFirefoxProfiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => '/tmp/',
            Filter    => 'anonymous*webdriver-profile',
        );

        for my $LeftoverFirefoxProfile (@LeftoverFirefoxProfiles) {
            if ( -d $LeftoverFirefoxProfile ) {
                remove_tree($LeftoverFirefoxProfile);
            }
        }

        # Cleanup all sessions which were created after the selenium test start time.
        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        my @Sessions = $AuthSessionObject->GetAllSessionIDs();

        SESSION:
        for my $SessionID (@Sessions) {

            my %SessionData = $AuthSessionObject->GetSessionIDData( SessionID => $SessionID );

            next SESSION if !%SessionData;
            next SESSION
                if $SessionData{UserSessionStart} && $SessionData{UserSessionStart} < $Self->{TestStartSystemTime};

            $AuthSessionObject->RemoveSessionID( SessionID => $SessionID );
        }
    }

    return;
}

=head1 DEPRECATED FUNCTIONS

=head2 WaitForjQueryEventBound()

waits until event handler is bound to the selected C<jQuery> element. Deprecated - it will be removed in the future releases.

    $SeleniumObject->WaitForjQueryEventBound(
        CSSSelector => 'li > a#Test',       # (required) css selector
        Event       => 'click',             # (optional) Specify event name. Default 'click'.
    );

=cut

sub WaitForjQueryEventBound {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{CSSSelector} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CSSSelector!",
        );

        return;
    }

    my $Event = $Param{Event} || 'click';

    # Wait for element availability.
    $Self->WaitFor(
        JavaScript => 'return typeof($) === "function" && $("' . $Param{CSSSelector} . '").length;'
    );

    # Wait for jQuery initialization.
    $Self->WaitFor(
        JavaScript =>
            'return Object.keys($("' . $Param{CSSSelector} . '")[0]).length > 0'
    );

    # Get jQuery object keys.
    my $Keys = $Self->execute_script(
        'return Object.keys($("' . $Param{CSSSelector} . '")[0]);'
    );

    if ( !IsArrayRefWithData($Keys) ) {
        die "Couldn't determine jQuery object id";
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
        die "Couldn't determine jQuery object id.";
    }

    # Wait until click event is bound to the element.
    $Self->WaitFor(
        JavaScript =>
            'return $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events
                && $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events.' . $Event . '
                && $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events.' . $Event . '.length > 0;',
    );

    return 1;
}

=head2 InputFieldValueSet()

sets modernized input field value.

    $SeleniumObject->InputFieldValueSet(
        Element => 'css-selector',              # (required) css selector
        Value   => 3,                           # (optional) Value
    );

=cut

sub InputFieldValueSet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Element} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Element!",
        );
        die 'Missing Element.';
    }
    my $Value = $Param{Value} // '';

    if ( $Value !~ m{^\[} && $Value !~ m{^".*"$} ) {

        # Quote text of Value is not array and if not already quoted.
        $Value = "\"$Value\"";
    }

    # Set selected value.
    $Self->execute_script(
        "\$('$Param{Element}').val($Value).trigger('redraw.InputField').trigger('change');"
    );

    # Wait until selection tree is closed.
    $Self->WaitFor(
        ElementMissing => [ '.InputField_ListContainer', 'css' ],
    );

    return 1;
}

1;
