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

package Kernel::Output::HTML::Layout::Template;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use Scalar::Util qw(weaken);

# CPAN modules
use Template            ();
use Template::Stash::XS ();
use Template::Context   ();
use Template::Plugins   ();

# OTOBO modules
use Kernel::Output::Template::Provider ();

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Template - template rendering engine based on Template::Toolkit

=head1 SYNOPSIS

    # No instances of this class should be created directly.
    # Instead the module is loaded implicitly by Kernel::Output::HTML::Layout
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

=head1 PUBLIC INTERFACE

=head2 Output()

generates HTML output based on a template file.

Using a template file:

    my $HTML = $LayoutObject->Output(
        TemplateFile => 'AdminLog',
        Data         => \%TemplateData,
    );

Using a template string:

    my $HTML = $LayoutObject->Output(
        Template => '<b>[% Data.SomeKey | html %]</b>',
        Data     => \%TemplateData,
    );

=head3 Additional parameters:

=over 4

=item AJAX

AJAX-specific adjustments, this causes [% WRAPPER JSOnDocumentComplete %] blocks NOT
to be replaced. This is important to be able to generate snippets which can be cached.
Also, JavaScript data added with AddJSData() or AddJSBoolean() calls is appended to the output here.

    my $HTML = $LayoutObject->Output(
        TemplateFile   => 'AdminLog.tt',
        Data           => \%Param,
        AJAX           => 1,
    );

=back

=cut

sub Output {
    my ( $Self, %Param ) = @_;

    $Param{Data} ||= {};

    # get and check param Data
    if ( ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need HashRef in Param Data! Got: '" . ref( $Param{Data} ) . "'!",
        );
        $Self->FatalError;
    }

    # fill init Env
    if ( !$Self->{EnvRef} ) {
        %{ $Self->{EnvRef} } = %ENV;

        # all $Self->{*}
        for ( sort keys %{$Self} ) {
            if ( defined $Self->{$_} && !ref $Self->{$_} ) {
                $Self->{EnvRef}->{$_} = $Self->{$_};
            }
        }
    }

    # add new env
    if ( $Self->{EnvNewRef} ) {
        for my $Key ( sort keys %{ $Self->{EnvNewRef} } ) {
            $Self->{EnvRef}->{$Key} = $Self->{EnvNewRef}->{$Key};
        }
        undef $Self->{EnvNewRef};
    }

    # otobo.psgi seemingly does not set REQUEST_SCHEME
    if ( !$Self->{EnvRef}{REQUEST_SCHEME} && $Self->{EnvRef}{HTTPS} ) {
        $Self->{EnvRef}{REQUEST_SCHEME} = lc( $Self->{EnvRef}{HTTPS} ) eq 'on' ? 'https' : 'http';
    }

    # if we use the HTML5 input type 'email' jQuery Validate will always validate
    # we do not want that if CheckEmailAddresses is set to 'no' in SysConfig
    $Self->{EnvRef}->{EmailFieldType} = $Kernel::OM->Get('Kernel::Config')->Get('CheckEmailAddresses') ? 'email' : 'text';

    my @TemplateFolders = (
        "$Self->{CustomTemplateDir}",
        "$Self->{CustomStandardTemplateDir}",
        "$Self->{TemplateDir}",
        "$Self->{StandardTemplateDir}",
    );

    my $TemplateString;

    if ( $Param{TemplateFile} ) {
        $Param{TemplateFileTT} .= "$Param{TemplateFile}.tt";
    }

    # take templates from string/array
    elsif ( defined $Param{Template} && ref $Param{Template} eq 'ARRAY' ) {
        for ( @{ $Param{Template} } ) {
            $TemplateString .= $_;
        }
    }
    elsif ( defined $Param{Template} ) {
        $TemplateString = $Param{Template};
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Template or TemplateFile Param!',
        );
        $Self->FatalError;
    }

    if ( !$Self->{TemplateObject} ) {

        $Self->{TemplateProviderObject} = Kernel::Output::Template::Provider->new(
            {
                INCLUDE_PATH => \@TemplateFolders,
                COMPILE_EXT  => '.ttc',
            }
        );
        $Self->{TemplateProviderObject}->OTOBOInit(
            LayoutObject => $Self,
        );

        my $Plugins = Template::Plugins->new(
            {
                PLUGIN_BASE => 'Kernel::Output::Template::Plugin',
            }
        );

        my $Context = Template::Context->new(
            {
                STASH          => Template::Stash::XS->new(),
                LOAD_TEMPLATES => [ $Self->{TemplateProviderObject} ],
                LOAD_PLUGINS   => [$Plugins],
            }
        );

        # Store a weak reference to the LayoutObject in the context
        #   to avoid ring references. We need it for the plugins.
        $Context->{LayoutObject} = $Self;
        weaken( $Context->{LayoutObject} );

        my $Success = $Self->{TemplateObject} = Template->new(
            {
                CONTEXT => $Context,

                #DEBUG => Template::Constants::DEBUG_ALL,
            }
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Template::ERROR;",
            );

            # $Self->FatalError(); # Don't use FatalError here, might cause infinite recursion
            die "$Template::ERROR\n";
        }
    }

    my $Output;
    my $Success = $Self->{TemplateObject}->process(
        $Param{TemplateFileTT} // \$TemplateString,
        {
            Data   => $Param{Data} // {},
            global => {
                BlockData      => $Self->{BlockData} // [],
                KeepScriptTags => $Param{AJAX}       // 0,
            },
        },
        \$Output,
    );
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Self->{TemplateObject}->error(),
        );
        $Self->FatalError();
    }

    # If the browser does not send the session cookie, we need to append it to all links and image urls.
    #   We cannot do this in the template preprocessor because links are often dynamically generated.
    if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {

        # rewrite a hrefs
        $Output =~ s{
            (<a.+?href=") \s* (.+?) (\#.+?|) (".+?>)
        }
        {
            my $AHref   = $1;
            my $Target  = $2;
            my $End     = $3;
            my $RealEnd = $4;
            if (
                lc($Target) =~ m/^(?:http:|https:|#|ftp:)/        # external link or anchor in same page
                ||
                !$Self->{SessionID}                               # don't add a session ID when there isn't one
                ||
                lc($Target) =~ m!^//!                             # protocol relative links
                ||
                $Target !~ /\.(pl|php|cgi|fcg|fcgi|fpl)(\?|$)/    # only dynamic HTML
                ||
                $Target =~ /\Q$Self->{SessionName}\E/             # session ID not already included
            )
            {
                $AHref.$Target.$End.$RealEnd;
            }
            else {
                $AHref.$Target.';'.$Self->{SessionName}.'='.$Self->{SessionID}.$End.$RealEnd;
            }
        }iegxs;

        # rewrite img and iframe src
        $Output =~ s{
            (<(?:img|iframe).+?src=") \s* (.+?)(".+?>)
        }
        {
            my $AHref  = $1;
            my $Target = $2;
            my $End    = $3;
            if (
                lc($Target) =~ m{^http s? :}smx
                ||
                !$Self->{SessionID}                               # don't add a session ID when there isn't one
                ||
                $Target !~ /\.(pl|php|cgi|fcg|fcgi|fpl)(\?|$)/    # only dynamic HTML
                ||
                $Target =~ /\Q$Self->{SessionName}\E/             # session ID not already included
            )
            {
                $AHref.$Target.$End;
            }
            else {
                $AHref.$Target.'&'.$Self->{SessionName}.'='.$Self->{SessionID}.$End;
            }
        }iegxs;
    }

    #
    # "Post" Output filter handling
    #
    if ( $Self->{FilterElementPost} && ref $Self->{FilterElementPost} eq 'HASH' ) {

        # extract filter list
        my %FilterList = %{ $Self->{FilterElementPost} };

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        FILTER:
        for my $Filter ( sort keys %FilterList ) {

            # extract filter config
            my $FilterConfig = $FilterList{$Filter};

            # extract template list
            my %TemplateList = %{ $FilterConfig->{Templates} || {} };

            next FILTER if !$Param{TemplateFile};
            next FILTER if !$TemplateList{ $Param{TemplateFile} };

            next FILTER if !$Kernel::OM->Get('Kernel::System::Main')->Require( $FilterConfig->{Module} );

            # create new instance
            my $Object = $FilterConfig->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            next FILTER if !$Object;

            # run output filter
            $Object->Run(
                %{$FilterConfig},
                Data         => \$Output,
                TemplateFile => $Param{TemplateFile} || '',
            );
        }
    }

    # AddJSData() handling
    if ( $Param{AJAX} ) {
        my %Data = %{ $Self->{_JSData} // {} };
        if (%Data) {
            my $JSONString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data     => \%Data,
                SortKeys => 1,
            );
            $Output
                .= "\n<script type=\"text/javascript\">//<![CDATA[\n\"use strict\";\nCore.Config.AddConfig($JSONString);\n//]]></script>";
        }
        delete $Self->{_JSData};
    }

    return $Output;
}

=head2 AddJSOnDocumentComplete()

dynamically add JavaScript code that should be executed in Core.App.Ready().
Call this for any dynamically generated code that is not in a template.

    $LayoutObject->AddJSOnDocumentComplete(
        Code => $MyCode,
    );

=cut

sub AddJSOnDocumentComplete {
    my ( $Self, %Param ) = @_;

    $Self->{_JSOnDocumentComplete} //= [];
    push @{ $Self->{_JSOnDocumentComplete} }, $Param{Code};

    return;
}

=head2 AddJSData()

dynamically add JavaScript data that should be handed over to
JavaScript via Core.Config.

The booleans values C<true> and C<false> are not supported in the passed data structure.
They would be serialized to C<"true"> and C<"false">, which are both true values.
As a workaround, use C<"1"> for true and C<''> for false.

    $LayoutObject->AddJSData(
        Key   => 'Key1',  # the key to store this data
        Value => { ... }  # simple or complex data
    );

=cut

sub AddJSData {
    my ( $Self, %Param ) = @_;

    return unless $Param{Key};

    $Self->{_JSData} //= {};
    $Self->{_JSData}->{ $Param{Key} } = $Param{Value};

    return;
}

1;
