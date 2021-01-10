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
use Devel::StackTrace qw();
use Test2::V0;
use Test2::API qw(context run_subtest);
use Net::DNS::Resolver;
use Moo;
use Try::Tiny;

# OTOBO modules
use Kernel::Config;
use Kernel::System::User;
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::UnitTest::Helper',
);

# Extend Selenium::Remote::Driver only when Selenium testing is activated.
# Otherwise Selenium::Remote::Driver::BUILD would be called with missing paramters.
# Extending with 'around' is only done when the the class is actually extended.
{
    # check whether Selenium testing is activated.
    my $SeleniumTestsConfig = $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {};

    if ( $SeleniumTestsConfig->%* ) {

        extends 'Selenium::Remote::Driver';

        # Override internal command of base class.
        # We use it to output successful command runs to the UnitTest object.
        # Errors will cause an exeption. The exception will be passed to SeleniumErrorHandler().
        around _execute_command => sub {
            my $Orig  = shift;
            my $Self  = shift;
            my ($Res, $Params) = @_;

            # an exception is thrown in case of an error
            my $Result = $Self->$Orig( $Res, $Params );

            return $Result if $Self->_SuppressTestingEvents();

            my $TestName = 'Selenium command success: ';
            $TestName .= $Kernel::OM->Get('Kernel::System::Main')->Dump(
                {
                    Res    => $Res,
                    Params => $Params,
                }
            );

            my $Context = context();

            $Context->pass_and_release( $TestName );

            return $Result;
        };


        # Enhance get_alert_text() method of base class to return alert text as string.
        around get_alert_text => sub {    ## no critic
            my $Orig = shift;
            my $Self = shift;

            my $AlertText = $Self->$Orig();

            # Chrome returns HASH when there is no alert text.
            die "Alert dialog is not present" if ref $AlertText eq 'HASH';

            return $AlertText;
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
    is      => 'ro',
);

# keep a copy of the config
has _SeleniumTestsConfig => (
    is      => 'ro',
);

# some internals for error handling
has _StackTrace => (
    is      => 'rw',
);
has _SeleniumException => (
    is      => 'rw',
);

# If a test throws an exception, we'll record it here in an attribute so that we can
# take screenshots of *all* Selenium instances that are currently running on shutdown.
has _TestException => (
    is      => 'rw',
);

# suppress testing events
has _SuppressTestingEvents => (
    is      => 'rw',
);

=head1 NAME

Kernel::System::UnitTest::Selenium - run front end tests

This class extends Selenium::Remote::Driver when Selenium testing is activated.
You can use the full API of the base object. See L<https://metacpan.org/pod/Selenium::Remote::Driver>.

Activating Selenium is done by adding a hash element in F<Kernel/Config.pm>.
You need a running C<selenium> or C<phantomjs> server in order to do this successfully.
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
    my $Orig  = shift;
    my $Class = shift;

    # check whether Selenium testing is activated.
    my $SeleniumTestsConfig = $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {};

    return {
        SeleniumTestsActive  => 0,
        _SeleniumTestsConfig => $SeleniumTestsConfig,
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

        my $Host = $SeleniumTestsConfig->{remote_server_addr};
        my $Packet = $Resolver->search( $Host );

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
        error_handler        => sub {
            my $Self = shift;

            return $Self->SeleniumErrorHandler(@_);
        },
        $SeleniumTestsConfig->%*,
    );
};

sub BUILD {
    my $Self = shift;

    return unless $Self->SeleniumTestsActive();

    # Set screen size from config or use defauls.
    my $Height = $Self->_SeleniumTestsConfig()->{window_height}  || 1200;
    my $Width  = $Self->_SeleniumTestsConfig()->{window_width}  || 1400;

    $Self->_SuppressTestingEvents(1);

    # This works only because we have extended Selenium::Remove::Driver.
    $Self->set_window_size( $Height, $Width );

    $Self->_SuppressTestingEvents(0);

    return;
}

# Selenium::Remove::Driver uses this callback in case of errors.
# Errors should not be discarded, they should be thrown as exceptions.
# Selenium methods like find_element() will catch the exception.
# Most other methods won't.
sub SeleniumErrorHandler {
    my $Self = shift;
    my ( $Error ) = @_;

    # Generate stack trace information.
    #   Don't store caller args, as this sometimes blows up due to an internal Perl bug
    #   (see https://github.com/Perl/perl5/issues/10687).
    # Show only the stack frames in the test script,
    # that is skip the frames in the testing and in the Selenium modules.
    my $ShowFrame = 0;
    my $StackTrace = Devel::StackTrace->new(
        indent         => 1,
        no_args        => 1,
        message        => 'Selenium stack trace started',
        frame_filter   => sub {

            # Limit stack trace to test evaluation itself.
            if ( ! $ShowFrame ) {
                my $FileName = $_[0]->{caller}->[1];

                return 0 unless $FileName =~ m/\.t$/; # skip the internal frames

                $ShowFrame = 1; # show the last frame in the test script and all frames above
            }

            # Remove the long serialized eval texts from the frame to keep the trace short.
            if ( $_[0]->{caller}->[6] ) {
                $_[0]->{caller}->[6] = '{...}';
            }

            return 1;
        }
    )->as_string();

    $Self->_StackTrace($StackTrace);
    $Self->_SeleniumException($Error);

    die $Error;
}

=head2 RunTest()

runs a selenium test if Selenium testing is configured.

    $SeleniumObject->RunTest( sub { ... } );

=cut

sub RunTest {
    my $Self = shift;
    my ( $Code ) = @_;

    if ( ! $Self->SeleniumTestsActive() ) {
        skip_all( 'Selenium testing is not active, skipping tests.' );

        return;
    }

    try {
        $Code->();
    }
    catch {
        $Self->_TestException($_);  # remember the exception because the screenshot is taken later, during DEMOLISH
        fail($_);                   # report the failure before done_testing()
    };

    return;
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

    my $Code = sub {
        $Self->get($URL);

        $Self->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        ) || die "OTOBO API verification failed after page load.";
    };

    my $Context = context();

    my $Pass = run_subtest( 'VerifiedGet', $Code, { buffered => 1, inherit_trace => 1 } );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    die 'VerifiedGet() failed' unless $Pass;

    $Context->release;

    return;
}

=head2 VerifiedRefresh()

perform a refresh() call, but wait for the page to be fully loaded (works only within OTOBO).
Will die() if the verification fails.

    $SeleniumObject->VerifiedRefresh();

=cut

sub VerifiedRefresh {
    my $Self = shift;
    my ( $URL ) = @_;

    my $Code = sub {
        $Self->refresh();

        $Self->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        ) || die "OTOBO API verification failed after page load.";
    };

    my $Context = context();

    my $Pass = run_subtest( 'VerifiedRefresh', $Code, { buffered => 1, inherit_trace => 1 } );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    die 'VerifiedRefresh() failed' unless $Pass;

    $Context->release;

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
    my $Self  = shift;
    my %Param = @_;

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

    my $Code = sub {
        # we will try several times to log in
        my $MaxTries = 5;

        TRY:
        for my $Try ( 1 .. $MaxTries ) {

            eval {
                my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
                my $LogoutXPath; # Logout link differs between Agent and Customer interface.
                my $AcceptGDPR;  # whether GDPR needs to be accepted during login
                if ( $Param{Type} eq 'Agent' ) {
                    $ScriptAlias .= 'index.pl';
                    $LogoutXPath = q{//a[@id='LogoutButton']};
                    $AcceptGDPR  = 0;
                }
                else {
                    $ScriptAlias .= 'customer.pl';
                    $LogoutXPath = q{//a[@title='Logout']};
                    $AcceptGDPR  = 0;
                }

                $Self->get($ScriptAlias);

                $Self->delete_all_cookies();
                $Self->VerifiedGet("${ScriptAlias}?Action=Login;User=$Param{User};Password=$Param{Password}");

                # In the customer interface there is a data privacy blurb that must be accepted.
                # Note that find_element_by_xpath() does not throw exceptions,
                # the method returns 0 when the element is not found.
                if ( $AcceptGDPR ) {
                    my $AcceptGDPRLink = $Self->find_element_by_xpath( q{//a[@id="AcceptGDPR"]} );
                    if ( $AcceptGDPRLink ) {
                        $AcceptGDPRLink->click();
                    }
                }

                # login successful?
                $Self->find_element( $LogoutXPath, 'xpath' );    # dies if not found

                pass( 'Login sequence ended...' );
            };

            # an error happend
            if ($@) {

                note( "Login attempt $Try of $MaxTries not successful." );

                # try again
                next TRY if $Try < $MaxTries;

                die "Login failed!";
            }

            # login was sucessful
            else {
                last TRY;
            }
        }
    };

    my $Context = context();

    my $Pass = run_subtest( 'Login', $Code, { buffered => 1, inherit_trace => 1 } );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    die 'Login() failed' unless $Pass;

    $Context->release;

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
    my $Self  = shift;
    my %Param = @_;

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
        die "Need JavaScript, WindowCount, ElementExists, ElementMissing, Callback or AlertPresent.";
    }

    $Param{Time} //= 20;
    my $WaitedSeconds = 0;
    my $Interval      = 0.1;
    my $WaitSeconds   = 0.5;
    my $Success = 0;

    WAIT:
    while ( $WaitedSeconds <= $Param{Time} ) {

        if ( $Param{JavaScript} ) {
            $Self->_SuppressTestingEvents(1);
            my $Ret = $Self->execute_script( $Param{JavaScript} );
            $Self->_SuppressTestingEvents(0);

            if ( $Ret ) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{WindowCount} ) {
            $Self->_SuppressTestingEvents(1);
            my $Ret = scalar( @{ $Self->get_window_handles() } ) == $Param{WindowCount};
            $Self->_SuppressTestingEvents(0);

            if ( $Ret ) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{AlertPresent} ) {
            $Self->_SuppressTestingEvents(1);
            # Eval is needed because the method would throw if no alert is present (yet).
            my $Ret = eval { $Self->get_alert_text() };
            $Self->_SuppressTestingEvents(0);

            if ( $Ret ) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{Callback} ) {
            $Self->_SuppressTestingEvents(1);
            my $Ret =  $Param{Callback}->();
            $Self->_SuppressTestingEvents(0);

            if ( $Ret ) {
                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{ElementExists} ) {
            my @Arguments
                = ref( $Param{ElementExists} ) eq 'ARRAY' ? @{ $Param{ElementExists} } : $Param{ElementExists};

            $Self->_SuppressTestingEvents(1);
            my $Ret = eval { $Self->find_element(@Arguments) };
            $Self->_SuppressTestingEvents(0);
            if ( $Ret ) {
                Time::HiRes::sleep($WaitSeconds);

                $Success = 1;

                last WAIT;
            }
        }
        elsif ( $Param{ElementMissing} ) {
            my @Arguments
                = ref( $Param{ElementMissing} ) eq 'ARRAY' ? @{ $Param{ElementMissing} } : $Param{ElementMissing};

            $Self->_SuppressTestingEvents(1);
            my $Ret = eval { $Self->find_element(@Arguments) };
            $Self->_SuppressTestingEvents(0);
            if ( ! $Ret ) {
                Time::HiRes::sleep($WaitSeconds);

                $Success = 1;

                last WAIT;
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

    # Release context and throw exception in case of failure.
    # Don't care about any special handling for the stack trace.
    $Context->throw( "WaitFor($Argument) failed.") unless $Success;

    $Context->pass_and_release( "WaitFor($Argument)" );

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
    my $Self  = shift;
    my %Param = @_;

    # Value is optional parameter
    for my $Needed (qw(Element Target)) {
        die "Need $Needed" unless $Param{$Needed};
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
    };

    my $Context = context();

    my $Pass = run_subtest( 'DragAndDrop', $Code, { buffered => 1, inherit_trace => 1 } );

    # run_subtest() does an implicit eval(), but we want do bail out on the first error
    die 'DragAndDrop failed' unless $Pass;

    $Context->release;

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
    if ( $Self->_StackTrace()  && $Error eq $Self->_SeleniumException() ) {
        $Error .= "\n" . $Self->_StackTrace();
    }

    my $Context = context();

    if ( $InGlobalDestruction ) {
        $Context->note( $Error );
    }
    else {
        $Context->fail( $Error );
    }

    # Don't create a test entry for the screenshot command,
    # to make sure it gets attached to the previous error entry.
    my $PrevSuppressTestingEvents = $Self->_SuppressTestingEvents();
    $Self->_SuppressTestingEvents(1);
    my $Data = $Self->screenshot();
    $Self->_SuppressTestingEvents($PrevSuppressTestingEvents);
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

    # Looks like for some reason $InGlobalDestruction is not reliable.
    # So, let's assume that the Kernel::System::UnitTest::Selenium is always demolished
    # after the done_testing().
    $InGlobalDestruction = 1;

    # $SuppressCommandRecording is not localised because one DEMOLISH is called after the other.
    # This is ok because no testing events should be emitted during demolist and after the script is finished.
    if ( $InGlobalDestruction ) {
        $Self->_SuppressTestingEvents(1);
    }

    if ($Self->_TestException()) {
        $Self->HandleError($Self->_TestException(), $InGlobalDestruction);
    }

    return unless $Self->SeleniumTestsActive();

    {

        # TODO: no testing event from auto-quitting Selenium
        #if ( $InGlobalDestruction ) {
        #    local $Self->{SuppressCommandRecording} = 1;

        #    $Self->SUPER::DEMOLISH(@_);
        #}
        #else {
        #    $Self->SUPER::DEMOLISH(@_);
        #}

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

            next SESSION unless %SessionData;
            next SESSION
                if $SessionData{UserSessionStart} && $SessionData{UserSessionStart} < $Self->_TestStartSystemTime();

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
