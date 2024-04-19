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

package Kernel::System::Web::Request;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Pod::FunctionPod)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use File::Basename qw(basename);
use List::Util     qw(uniq);

# CPAN modules
use HTTP::Message::PSGI   qw(req_to_psgi);
use HTTP::Request::Common qw(GET);
use Path::Class           qw(file);
use Plack::Request        ();
use Try::Tiny;

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CheckItem',
    'Kernel::System::Encode',
    'Kernel::System::Web::UploadCache',
    'Kernel::System::FormDraft',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::Web::Request - an object holding info on the current request

=head1 DESCRIPTION

Holds the request params and other info on the request.
Functions for handling form drafts.

=head1 PUBLIC INTERFACE

=head2 new()

create param object. Do not use it directly, instead use it via the OTOBO object manager.

The regular usage in the web interface modules, e.g. in L<Kernel::System::Web::InterfaceAgent>.

    use Kernel::System::ObjectManager;

    # the PSGI env is already available in the interface modules
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Web::Request' => {
            PSGIEnv => $PSGIEnv
        }
    );

    # later in the code
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

In the test scripts it is convenient to pass in a request object directly.

    use HTTP::Request::Common qw(GET);
    use Kernel::System::UnitTest::RegisterDriver;

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Web::Request' => {
            HTTPRequest => GET('http://www.example.com?a=4;b=5'),
        }
    );

    # the added parameter is used automatically later in the test script or in the used modules
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

If Kernel::System::Web::Request is instantiated several times, they will share the
same web request data. This can be helpful in filters which do not have access to the
ParamObject, for example.

When no C<PSGIEnv> or C<HTTPRequest> is registered than C<GET('/')> is used as a fallback.
This is relevant sometimes when an instance of C<Kernel::System::Web::Request> is needed outside a web context.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $PSGIEnv;
    if ( $Param{PSGIEnv} ) {

        # query object when PSGI env is passed, the recommended usage
        $PSGIEnv = $Param{PSGIEnv};
    }
    elsif ( $Param{HTTPRequest} ) {

        # a HTTP::Request object, used primarily in test scripts
        $PSGIEnv = req_to_psgi( $Param{HTTPRequest} );

        # req_to_psgi() does not split SCRIPT_NAME from PATH_INFO like it is done in otobo.psgi.
        # So, let's emulate this here. Note that the first '.*' matches greedily.
        if ( $PSGIEnv->{PATH_INFO} =~ m!(.*) / (.+)!x ) {
            $PSGIEnv->{PATH_INFO}   = $1;
            $PSGIEnv->{SCRIPT_NAME} = $2;
        }
    }
    else {

        # Use a basic request as a fallback.
        # This is needed because the ParamObject is sometimes created outside a web context.
        $PSGIEnv = req_to_psgi( GET('/') );
    }

    # Limit the max content length to the configured value
    # or to 5 MB as fallback.
    {
        my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
        my $PostMax       = $ConfigObject->Get('WebMaxFileUpload') || 1024 * 1024 * 5;
        my $ContentLength = $PSGIEnv->{CONTENT_LENGTH} // 0;

        # Setting WebMaxFileUpload to a negative value is prohibited in the GUI,
        # But it could have been set up manually.
        if ( $PostMax > 0 && $ContentLength > $PostMax ) {
            my $Error = sprintf
                '413 Request entity too large - POST_MAX=%dKB',
                $PostMax / 1024;
            my $DummyPlackRequest = Plack::Request->new( req_to_psgi( GET('/') ) );

            return bless {
                PlackRequest => $DummyPlackRequest,
                Error        => $Error
            }, $Type;
        }
    }

    # Plack::Request has no cgi_error() method. This means that failures in object creation
    # and in input parsing are only communcated via exceptions. Let'c catch the exception so
    # that the status can be checked with the Error() method.
    my ( $PlackRequest, $Error );
    try {
        # calling now only stores the environment
        $PlackRequest = Plack::Request->new($PSGIEnv);

        # actually parse the input and cache the result
        # this initializes $PlackRequest->env->{'plack.request.merged'}
        $PlackRequest->parameters;
    }
    catch {
        $Error = $_;
    };

    if ($Error) {
        my $DummyPlackRequest = Plack::Request->new( req_to_psgi( GET('/') ) );

        return bless {
            PlackRequest => $DummyPlackRequest,
            Error        => $Error
        }, $Type;
    }

    # construction went fine
    return bless { PlackRequest => $PlackRequest }, $Type;
}

=head2 Error()

to get the error back.
The error usually does not contain a HTTP status code.

    if ( $ParamObject->Error() ) {
        print STDERR $ParamObject->Error() . "\n";
    }

=cut

sub Error {
    my ( $Self, %Param ) = @_;

    return unless defined $Self->{Error};

    return $Self->{Error};
}

=head2 GetParam()

to get the value of a single request parameter.
URL and body parameters are merged. URL params are first. The first value is taken.
For file uploads the entered file name is returned.
Per default, left and right trimming is performed on the returned value.
The trimming can be turned of by passing the parameter C<Raw>.

    my $Param = $ParamObject->GetParam(
        Param => 'ID',
        Raw   => 1,       # optional, input data is not changed
    );

When the parameter is not part of the query then C<undef> is returned.

The parameters B<POSTDATA>, B<PUTDATA>, and B<PATCHDATA> are a special case.
If the parameter corresponds to the request method, then the body of the request
is returned.

Note: the behavior for B<POSTDATA>, B<PUTDATA>, and B<PATCHDATA> diverges from OTOBO 10.1.x.
in previous versions these special parameters were only set when the body parameters were
not parsed.

=cut

sub GetParam {
    my ( $Self, %Param ) = @_;

    my $Key          = $Param{Param};
    my $PlackRequest = $Self->{PlackRequest};

    # special case for the body
    my $Method = $PlackRequest->method;
    if (
        ( $Method eq 'POST' || $Method eq 'PUT' || $Method eq 'PATCH' )
        &&
        $Key eq "${Method}DATA"
        )
    {
        return $PlackRequest->content;
    }

    # In rel-10_1 the method CGI::param() was used here. This method returnes the first value
    # in the case of multi-valued parameters. But Hash::MultiValue::{} returns
    # the last value. For the sake of compatablity the CGI.pm behavior is reproduced.
    # Plack Request does no decoding, so pass a byte array as key.
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Key );
    my ($Value) = $PlackRequest->parameters->get_all($Key);
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Value );

    # Stay compatible with CGI.pm by checking for file uploads.
    # The name of the file is returned when a file upload was found
    if ( !defined $Value && $PlackRequest->uploads->{$Key} ) {
        $Value = $PlackRequest->uploads->{$Key}->filename;
    }

    # no string cleaning is needed for undefined values
    return $Value unless defined $Value;

    # no string cleaning when specifically so requested
    return $Value if $Param{Raw};

    # If it is a plain string, perform trimming
    return $Value unless ref \$Value eq 'SCALAR';

    $Kernel::OM->Get('Kernel::System::CheckItem')->StringClean(
        StringRef => \$Value,
        TrimLeft  => 1,
        TrimRight => 1,
    );

    return $Value;
}

=head2 GetParamNames()

to get the names of all parameters passed in the request.
URL and body parameters are always merged.
File uploads are also included.

    my @ParamNames = $ParamObject->GetParamNames();

Example:

Called URL: index.pl?Action=AdminSystemConfiguration;Subaction=Save;Name=Config::Option::Valid

    my @ParamNames = $ParamObject->GetParamNames();
    print join ' :: ', @ParamNames;
    #prints Action :: Subaction :: Name

Attention: In OTOBO 10.1.x URL and body params were not merged.

=cut

sub GetParamNames {
    my $Self = shift;

    # fetch all names, URL and body is already merged
    my @ParamNames = uniq
        keys $Self->{PlackRequest}->parameters->%*,
        keys $Self->{PlackRequest}->uploads->%*;
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \@ParamNames );

    return @ParamNames;
}

=head2 GetArray()

to get array request parameters.
By default, trimming is performed on the data.

    my @Param = $ParamObject->GetArray(
        Param => 'ID',
        Raw   => 1,     # optional, input data is not changed
    );

URL and body parameters are merged. URL parameters come before body parameters

=cut

sub GetArray {
    my ( $Self, %Param ) = @_;

    my @Values = $Self->{PlackRequest}->parameters->get_all( $Param{Param} );
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \@Values );

    return @Values if $Param{Raw};

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    VALUE:
    for my $Value (@Values) {

        # don't validate objects from file uploads
        next VALUE if !$Value || ref \$Value ne 'SCALAR';

        $CheckItemObject->StringClean(
            StringRef => \$Value,
            TrimLeft  => 1,
            TrimRight => 1,
        );
    }

    return @Values;
}

=head2 SetArray()

set the values of a parameter. An empty list removes the parameter.

This method should be used carefully, because it has the potential to cause
unexpected consequences. For new, it is only used for supporting form draft.

    # delete param
    my $Success1 = $ParamObject->SetArray(
        Param  => 'ID',
        Values => [],
    );

    # single value
    my $Success1 = $ParamObject->SetArray(
        Param  => 'ID',
        Values => [ 123 ],
    );

    # multi values
    my $Success3 = $ParamObject->SetArray(
        Param  => 'ID',
        Values => [ 123, 'asdf', '' ],
    );

The value 1 is returned in the case of success.
An empty list is returned in the case of problems.

=cut

sub SetArray {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    ARGUMENT:
    for my $Argument (qw(Param Values)) {
        next ARGUMENT if $Param{$Argument};

        return;
    }
    if ( ref $Param{Values} ne 'ARRAY' ) {

        return;
    }

    if ( $Param{Values}->@* ) {
        $Self->{PlackRequest}->env->{'plack.request.merged'}->set( $Param{Param}, $Param{Values}->@* );
    }
    else {
        $Self->{PlackRequest}->env->{'plack.request.merged'}->remove( $Param{Param} );
    }

    return 1;
}

=head2 Content

Returns the request content in a raw byte string for POST requests.
This is a wrapper around C<Plack::Request::content()>.

    my $RawBody = $ParamObject->Content();

No parameters are handled.

=cut

sub Content {
    my ($Self) = @_;

    return $Self->{PlackRequest}->content;
}

=head2 GetUploadAll()

gets file upload data.

    my %File = $ParamObject->GetUploadAll(
        Param  => 'FileParam',  # the name of the request parameter containing the file data
    );

    returns (
        Filename    => 'abc.txt',
        ContentType => 'text/plain',
        Content     => 'Some text',
    );

Returns an empty list when no uploaded file was found.

=cut

sub GetUploadAll {
    my ( $Self, %Param ) = @_;

    # get upload
    my $Upload = $Self->{PlackRequest}->uploads->{ $Param{Param} };

    return unless $Upload;

    # get real file name from the Plack::Request::Upload object
    my $UploadFilenameOrig = $Upload->filename;

    my $NewFileName = basename("$UploadFilenameOrig");    # use "" to get filename of anony. object
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$NewFileName );

    # replace all devices like c: or d: and dirs for IE!
    # TODO: is this still needed ???
    $NewFileName =~ s/.:\\(.*)/$1/g;
    $NewFileName =~ s/.*\\(.+?)/$1/g;

    # $Upload->path return the path to the temporary file
    my $Content     = file( $Upload->path )->slurp;
    my $ContentType = $Upload->content_type;

    return (
        Filename    => $NewFileName,
        Content     => $Content,
        ContentType => $ContentType,
    );
}

=head2 GetCookie()

get a cookie

    my $String = $ParamObject->GetCookie(
        Key => ID,
    );

=cut

sub GetCookie {
    my ( $Self, %Param ) = @_;

    return $Self->{PlackRequest}->cookies->{ $Param{Key} };
}

=head2 RemoteAddr()

get the remote address of the HTTP client.
This is a wrapper around C<Plack::Request::address()>.

    my $RemoteAddr = $ParamObject->RemoteAddr();

No parameters are handled.

=cut

sub RemoteAddr {
    my ($Self) = @_;

    return $Self->{PlackRequest}->address;
}

=head2 RemoteUser()

get the remote user.
This is a wrapper around C<Plack::Request::user()>.

    my $RemoteUser = $ParamObject->RemoteUser();

No parameters are handled.

=cut

sub RemoteUser {
    my ($Self) = @_;

    return $Self->{PlackRequest}->user;
}

=head2 ScriptName()

return the script name as a partial URL, for self-referring scripts.
This is a wrapper around C<Plack::Request::script_name()>.

    my $ScriptName = $ParamObject->ScriptName();

No parameters are handled.

=cut

sub ScriptName {
    my ($Self) = @_;

    # fix erroneous double slashes at the beginning of SCRIPT_NAME as it worked in OTRS
    my $ScriptName = $Self->{PlackRequest}->script_name;
    $ScriptName =~ s{^//+}{/};

    return $ScriptName;
}

=head2 ServerProtocol()

return info about the protocol.
This is a wrapper of C<Plack::Request::protocol()>.

    my $ServerProtocol = $ParamObject->ServerProtocol();

No parameters are handled.

=cut

sub ServerProtocol {
    my ($Self) = @_;

    return $Self->{PlackRequest}->protocol;
}

=head2 ServerSoftware()

return info which server is running.
This is a re-implementation of C<CGI::server_software()>.

    my $ServerSoftware = $ParamObject->ServerSoftware();

No parameters are handled.

=cut

sub ServerSoftware {
    my ($Self) = @_;

    return $Self->{PlackRequest}->env->{SERVER_SOFTWARE};
}

=head2 RequestURI()

Returns the interpreted pathname of the requested document or CGI (relative to the document root). Or undef if not set.
This is a wrapper around C<Plack::Request::request_uri()>.

    my $RequestURI = $ParamObject->RequestURI();

No parameters are handled.

=cut

sub RequestURI {
    my ($Self) = @_;

    return $Self->{PlackRequest}->request_uri;
}

=head2 ContentType()

Returns content-type header.
This is a wrapper around C<Plack::Request::content_type()>.

    my $ContentType = $ParamObject->ContentType();

No parameters are handled.

=cut

sub ContentType {
    my ($Self) = @_;

    return $Self->{PlackRequest}->content_type;
}

=head2 QueryString()

Returns the query string.
This is a wrapper around C<Plack::Request::query_string()>.

    my $QueryString = $ParamObject->QueryString();

No parameters are handled.

=cut

sub QueryString {
    my ($Self) = @_;

    return $Self->{PlackRequest}->query_string;
}

=head2 RequestMethod()

Most of the time either GET or POST.
This is a wrapper around C<Plack::Request::method()>.

    my $RequestMethod = $ParamObject->RequestMethod();

No parameters are handled.

=cut

sub RequestMethod {
    my ($Self) = @_;

    return $Self->{PlackRequest}->method;
}

=head2 PathInfo()

Returns additional path information from the script URL.
This is a wrapper around C<Plack::Request::path_info()>.

    my $PathInfo = $ParamObject->PathInfo();

No parameters are handled.

=cut

sub PathInfo {
    my ($Self) = @_;

    return $Self->{PlackRequest}->path_info;
}

=head2 Headers

This is a wrapper around C<Plack::Request::headers()>.
Returns an instance of C<HTTP::Headers::Fast> containing the request headers.
That object was constructed from the I<HTTP_> fields of the PSGI environment.

    my $Headers = $ParamObject->Headers();

No parameters are handled.

=cut

sub Headers {
    my ($Self) = @_;

    return $Self->{PlackRequest}->headers;
}

=head2 Header

This is a wrapper around C<Plack::Request::header()>.

=cut

sub Header {
    my ( $Self, @Parameters ) = @_;

    return $Self->{PlackRequest}->header(@Parameters);
}

=head2 HTTP()

Called with a single argument, this method gets the value
of a PSGI environment variable. The variable is C<"HTTP_$Parameter">
when the parameter does not start with "HTTP_" or is "HTTP".
Otherwise "HTTP_" is not prepended.
These variables are set from the corresponding HTTP headers. The case of C<$Parameter>
is not significant and B<_> may be used instead of B<->.

    my $UserAgent = $ParamObject->HTTP('USER_AGENT');

is the same as

    my $UserAgent = $ParamObject->HTTP('User-Agent');

or

    my $UserAgent = $ParamObject->HTTP('HTTP_USER_AGENT');

Called without an argument, this method returns the list
of the HTTP environment variables.

This is a re-implementation of C<CGI::http()>.

=cut

sub HTTP {
    my ( $Self, $Parameter ) = @_;

    if ( defined $Parameter ) {
        $Parameter =~ tr/-a-z/_A-Z/;
        if ( $Parameter =~ m/^HTTP(?:_|$)/ ) {
            return $Self->{PlackRequest}->env->{$Parameter};
        }

        return $Self->{PlackRequest}->env->{"HTTP_$Parameter"};
    }

    # return list of keys when no parameter was passed
    return grep {m/^HTTP(?:_|$)/} sort keys $Self->{PlackRequest}->env->%*;
}

=head2 HttpsIsOn()

checks whether the PSGI environment value I<HTTPS> is set and whether
it is set to I<ON>. The value I<ON> is checked in a case insensitive way.

    my $HttpsIsOn = $ParamObject->HttpsIsOn;

Returns 0 or 1.

=cut

sub HttpsIsOn {
    my ($Self) = @_;

    my $Https = $Self->{PlackRequest}->env->{HTTPS};

    return 0 unless defined $Https;
    return 1 if uc $Https eq 'ON';
    return 0;
}

=head2 IsAJAXRequest()

checks if the current request was sent by AJAX

    my $IsAJAXRequest = $ParamObject->IsAJAXRequest();

=cut

sub IsAJAXRequest {
    my ($Self) = @_;

    # access request headers via the method http().
    return ( $Self->{PlackRequest}->header('X-Requested-With') // '' ) eq 'XMLHttpRequest' ? 1 : 0;
}

=head2 LoadFormDraft()

Load specified draft.
This will read stored draft data and inject it into the param object
for transparent use by frontend module.

    my $FormDraftID = $ParamObject->LoadFormDraft(
        FormDraftID => 123,
        UserID  => 1,
    );

=cut

sub LoadFormDraft {
    my ( $Self, %Param ) = @_;

    return if !$Param{FormDraftID} || !$Param{UserID};

    # get draft data
    my $FormDraft = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftGet(
        FormDraftID => $Param{FormDraftID},
        UserID      => $Param{UserID},
    );

    return unless IsHashRefWithData($FormDraft);

    # Verify action.
    my $Action = $Self->GetParam( Param => 'Action' );

    return unless $FormDraft->{Action} eq $Action;

    # add draft name to form data
    $FormDraft->{FormData}->{FormDraftTitle} = $FormDraft->{Title};

    # create FormID and add to form data
    my $FormID = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    $FormDraft->{FormData}->{FormID} = $FormID;

    # set form data to param object, depending on type
    KEY:
    for my $Key ( sort keys %{ $FormDraft->{FormData} } ) {
        my $Value = $FormDraft->{FormData}->{$Key} // '';

        # meddling with the innards of Plack::Request

        # array value
        if ( IsArrayRefWithData($Value) ) {
            $Self->SetArray(
                Param  => $Key,
                Values => $Value
            );

            next KEY;
        }

        # scalar value
        $Self->SetArray(
            Param  => $Key,
            Values => [$Value]
        );
    }

    # add UploadCache data
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    for my $File ( @{ $FormDraft->{FileData} } ) {
        return unless $UploadCacheObject->FormIDAddFile(
            %{$File},
            FormID => $FormID,
        );
    }

    return $Param{FormDraftID};
}

=head2 SaveFormDraft()

Create or replace draft using data from param object and upload cache.
Specified params can be overwritten if necessary.

    my $FormDraftID = $ParamObject->SaveFormDraft(
        UserID         => 1
        ObjectType     => 'Ticket',
        ObjectID       => 123,
        OverrideParams => {               # optional, can contain strings and array references
            Subaction   => undef,
            UserID      => 1,
            CustomParam => [ 1, 2, 3, ],
            ...
        },
    );

=cut

sub SaveFormDraft {
    my ( $Self, %Param ) = @_;

    # check params
    return if !$Param{UserID} || !$Param{ObjectType} || !IsInteger( $Param{ObjectID} );

    # gather necessary data for backend
    my %MetaParams;
    for my $Param (qw(Action FormDraftID FormDraftTitle FormID)) {
        $MetaParams{$Param} = $Self->GetParam(
            Param => $Param,
        );
    }
    return unless $MetaParams{Action};

    # determine session name param (SessionUseCookie = 0) for exclusion
    my $SessionName = $Kernel::OM->Get('Kernel::Config')->Get('SessionName') || 'SessionID';

    # compile override list
    my %OverrideParams = IsHashRefWithData( $Param{OverrideParams} ) ? %{ $Param{OverrideParams} } : ();

    # these params must always be excluded for safety, they take precedence
    for my $Name (
        qw(Action ChallengeToken FormID FormDraftID FormDraftTitle FormDraftAction LoadFormDraftID),
        $SessionName
        )
    {
        $OverrideParams{$Name} = undef;
    }

    # Gather all params.
    #   Exclude, add or override by using OverrideParams if necessary.
    my @ParamNames = $Self->GetParamNames();
    my %ParamSeen;
    my %FormData;
    PARAM:
    for my $Param ( @ParamNames, sort keys %OverrideParams ) {
        next PARAM if $ParamSeen{$Param}++;
        my $Value;

        # check for overrides first
        if ( exists $OverrideParams{$Param} ) {

            # allow only strings and array references as value
            if (
                IsStringWithData( $OverrideParams{$Param} )
                || IsArrayRefWithData( $OverrideParams{$Param} )
                )
            {
                $Value = $OverrideParams{$Param};
            }

            # skip all other parameters (including those specified to be excluded by using 'undef')
            else {
                next PARAM;
            }
        }

        # get other values from param object
        if ( !defined $Value ) {
            my @Values = $Self->GetArray( Param => $Param );
            next PARAM unless IsArrayRefWithData( \@Values );

            # store single occurances as string
            if ( scalar @Values == 1 ) {
                $Value = $Values[0];
            }

            # store multiple occurances as array reference
            else {
                $Value = \@Values;
            }
        }

        $FormData{$Param} = $Value;
    }

    # get files from upload cache
    my @FileData = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDGetAllFilesData(
        FormID => $MetaParams{FormID},
    );

    # prepare data to add or update draft
    my %FormDraft = (
        FormData    => \%FormData,
        FileData    => \@FileData,
        FormDraftID => $MetaParams{FormDraftID},
        ObjectType  => $Param{ObjectType},
        ObjectID    => $Param{ObjectID},
        Action      => $MetaParams{Action},
        Title       => $MetaParams{FormDraftTitle},
        UserID      => $Param{UserID},
    );

    # update draft
    if ( $MetaParams{FormDraftID} ) {
        return unless $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftUpdate(%FormDraft);
        return 1;
    }

    # create new draft
    return unless $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftAdd(%FormDraft);
    return 1;
}

1;
