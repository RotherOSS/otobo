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

package Kernel::System::Web::Request;

use strict;
use warnings;

use CGI ();
use CGI::Carp;
use File::Path qw();
use File::Basename qw(basename);

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

Kernel::System::Web::Request - interface for the current HTTP request

=head1 DESCRIPTION

All CGI param functions. Functions for handling form drafts.

=head1 PUBLIC INTERFACE

=head2 new()

create param object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

In some cases, e.g. in test scripts, passing in a query object can be useful:

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Web::Request' => {
            WebRequest => CGI::PSGI->new($env), # optional, e. g. if PSGI is used
        }
    );
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

If Kernel::System::Web::Request is instantiated several times, they will share the
same CGI data (this can be helpful in filters which do not have access to the
ParamObject, for example.

If you need to reset the CGI data before creating a new instance, use

    CGI::initialize_globals();

before calling Kernel::System::Web::Request->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # max 5 MB posts
    $CGI::POST_MAX = $ConfigObject->Get('WebMaxFileUpload') || 1024 * 1024 * 5;

    # The query is usually constructed from the CGI relevant environment variables, e.g. QUERY_STRING,
    # and from reading STDIN.
    # In specific cases, e.g. test scripts, a already prepared query object can be passed in.
    $Self->{Query} = $Param{WebRequest} || CGI->new();

    return $Self;
}

=head2 Error()

to get the error back

    if ( $ParamObject->Error() ) {
        print STDERR $ParamObject->Error() . "\n";
    }

=cut

sub Error {
    my ( $Self, %Param ) = @_;

    return if !$Self->{Query}->cgi_error();

    return $Self->{Query}->cgi_error() . ' - POST_MAX=' . ( $CGI::POST_MAX / 1024 ) . 'KB';
}

=head2 GetParam()

to get single request parameters. By default, trimming is performed on the data.

    my $Param = $ParamObject->GetParam(
        Param => 'ID',
        Raw   => 1,       # optional, input data is not changed
    );

=cut

sub GetParam {
    my ( $Self, %Param ) = @_;

    my $Value = $Self->{Query}->param( $Param{Param} );

    # Fallback to query string for mixed requests.
    my $RequestMethod = $Self->{Query}->request_method() // '';
    if ( $RequestMethod eq 'POST' && !defined $Value ) {
        $Value = $Self->{Query}->url_param( $Param{Param} );
    }

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Value );

    my $Raw = defined $Param{Raw} ? $Param{Raw} : 0;

    if ( !$Raw ) {

        # If it is a plain string, perform trimming
        if ( ref \$Value eq 'SCALAR' ) {
            $Kernel::OM->Get('Kernel::System::CheckItem')->StringClean(
                StringRef => \$Value,
                TrimLeft  => 1,
                TrimRight => 1,
            );
        }
    }

    return $Value;
}

=head2 GetParamNames()

to get names of all parameters passed to the script.

    my @ParamNames = $ParamObject->GetParamNames();

Example:

Called URL: index.pl?Action=AdminSystemConfiguration;Subaction=Save;Name=Config::Option::Valid

    my @ParamNames = $ParamObject->GetParamNames();
    print join " :: ", @ParamNames;
    #prints Action :: Subaction :: Name

=cut

sub GetParamNames {
    my $Self = shift;

    # fetch all names
    my @ParamNames = $Self->{Query}->param();

    # Fallback to query string for mixed requests.
    my $RequestMethod = $Self->{Query}->request_method() // '';
    if ( $RequestMethod eq 'POST' ) {
        my %POSTNames;
        @POSTNames{@ParamNames} = @ParamNames;
        my @GetNames = $Self->{Query}->url_param();
        GETNAME:
        for my $GetName (@GetNames) {
            next GETNAME if !defined $GetName;
            push @ParamNames, $GetName if !exists $POSTNames{$GetName};
        }
    }

    for my $Name (@ParamNames) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Name );
    }

    return @ParamNames;
}

=head2 GetArray()

to get array request parameters.
By default, trimming is performed on the data.

    my @Param = $ParamObject->GetArray(
        Param => 'ID',
        Raw   => 1,     # optional, input data is not changed
    );

=cut

sub GetArray {
    my ( $Self, %Param ) = @_;

    my @Values = $Self->{Query}->multi_param( $Param{Param} );

    # Fallback to query string for mixed requests.
    my $RequestMethod = $Self->{Query}->request_method() // '';
    if ( $RequestMethod eq 'POST' && !@Values ) {
        @Values = $Self->{Query}->url_param( $Param{Param} );
    }

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \@Values );

    my $Raw = defined $Param{Raw} ? $Param{Raw} : 0;

    if ( !$Raw ) {

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        VALUE:
        for my $Value (@Values) {

            # don't validate CGI::File::Temp objects from file uploads
            next VALUE if !$Value || ref \$Value ne 'SCALAR';

            $CheckItemObject->StringClean(
                StringRef => \$Value,
                TrimLeft  => 1,
                TrimRight => 1,
            );
        }
    }

    return @Values;
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

=cut

sub GetUploadAll {
    my ( $Self, %Param ) = @_;

    # get upload
    my $Upload = $Self->{Query}->upload( $Param{Param} );
    return if !$Upload;

    # get real file name
    my $UploadFilenameOrig = $Self->GetParam( Param => $Param{Param} ) || 'unknown';

    my $NewFileName = basename("$UploadFilenameOrig");    # use "" to get filename of anony. object
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$NewFileName );

    # replace all devices like c: or d: and dirs for IE!
    $NewFileName =~ s/.:\\(.*)/$1/g;
    $NewFileName =~ s/.*\\(.+?)/$1/g;

    # return a string
    my $Content = '';
    while (<$Upload>) {
        $Content .= $_;
    }
    close $Upload;

    my $ContentType = $Self->_GetUploadInfo(
        Filename => $UploadFilenameOrig,
        Header   => 'Content-Type',
    );

    return (
        Filename    => $NewFileName,
        Content     => $Content,
        ContentType => $ContentType,
    );
}

sub _GetUploadInfo {
    my ( $Self, %Param ) = @_;

    # get file upload info
    my $FileInfo = $Self->{Query}->uploadInfo( $Param{Filename} );

    # return if no upload info exists
    return 'application/octet-stream' if !$FileInfo;

    # return if no content type of upload info exists
    return 'application/octet-stream' if !$FileInfo->{ $Param{Header} };

    # return content type of upload info
    return $FileInfo->{ $Param{Header} };
}

=head2 SetCookie()

set a cookie

    $ParamObject->SetCookie(
        Key     => ID,
        Value   => 123456,
        Expires => '+3660s',
        Path    => 'otobo/',     # optional, only allow cookie for given path
        Secure  => 1,           # optional, set secure attribute to disable cookie on HTTP (HTTPS only)
        HTTPOnly => 1,          # optional, sets HttpOnly attribute of cookie to prevent access via JavaScript
    );

=cut

sub SetCookie {
    my ( $Self, %Param ) = @_;

    $Param{Path} ||= '';

    return $Self->{Query}->cookie(
        -name     => $Param{Key},
        -value    => $Param{Value},
        -expires  => $Param{Expires},
        -secure   => $Param{Secure}   || '',
        -httponly => $Param{HTTPOnly} || '',
        -path     => '/' . $Param{Path},
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

    return $Self->{Query}->cookie( $Param{Key} );
}

=head2 RemoteAddr()

get the remote address of the HTTP client.
This is a wrapper around CGI::remote_addr().

    my $RemoteAddr = $ParamObject->RemoteAddr();

=cut

sub RemoteAddr {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->remote_addr(@Params);
}

=head2 RemoteUser()

get the remote user.
This is a wrapper around CGI::remote_user().

    my $RemoteUser = $ParamObject->RemoteUser();

=cut

sub RemoteUser {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->remote_user(@Params);
}

=head2 ScriptName()

return the script name as a partial URL, for self-referring scripts.
This is a wrapper around CGI::script_name().

    my $ScriptName = $ParamObject->ScriptName();

=cut

sub ScriptName {
    my ( $Self, @Params ) = @_;

    # fix erroneous double slashes at the beginning of SCRIPT_NAME as it worked in OTRS
    my $ScriptName = $Self->{Query}->script_name(@Params);
    $ScriptName =~ s{^//+}{/};

    return $ScriptName;
}

=head2 ServerProtocol()

return info about the protocol.
This is a wrapper around CGI::server_protocol().

    my $ServerProtocol = $ParamObject->ServerProtocol();

=cut

sub ServerProtocol {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->server_protocol(@Params);
}

=head2 ServerSoftware()

return info which server is running.
This is a wrapper around CGI::server_software().

    my $ServerSoftware = $ParamObject->ServerSoftware();

=cut

sub ServerSoftware {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->server_software(@Params);
}

=head2 RequestURI()

Returns the interpreted pathname of the requested document or CGI (relative to the document root). Or undef if not set.
This is a wrapper around CGI::request_uri().

    my $RequestURI = $ParamObject->RequestURI();

=cut

sub RequestURI {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->request_uri(@Params);
}

=head2 ContentType()

Returns content-type header.
This is a wrapper around CGI::content_type().

    my $ContentType = $ParamObject->ContentType();

=cut

sub ContentType {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->content_type(@Params);
}

=head2 EnvQueryString()

Returns the original query string.
This is a wrapper around CGI::env_query_string().

    my $QueryString = $ParamObject->EnvQueryString();

=cut

sub EnvQueryString {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->env_query_string(@Params);
}

=head2 RequestMethod()

Usually either GET or POST.
This is a wrapper around CGI::request_method().

    my $RequestMethod = $ParamObject->RequestMethod();

=cut

sub RequestMethod {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->request_method(@Params);
}

=head2 PathInfo()

Returns additional path information from the script URL.
This is a wrapper around CGI::path_info().

    my $PathInfo = $ParamObject->PathInfo();

=cut

sub PathInfo {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->path_info(@Params);
}

=head2 HTTP()

get the HTTP environment variable. Called with a single argument get the specific environment variable.
This is a wrapper around CGI::http().

    my $UserAgent = $ParamObject->HTTP('USER_AGENT');

=cut

sub HTTP {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->http(@Params);
}

=head2 HTTPS()

same as HTTP(), but operate on the HTTPS environment variables.
This is a wrapper around C<CGI::https()>.

    my $UserAgent = $ParamObject->HTTPS('USER_AGENT');

=cut

sub HTTPS {
    my ( $Self, @Params ) = @_;

    return $Self->{Query}->https(@Params);
}

=head2 IsAJAXRequest()

checks if the current request was sent by AJAX

    my $IsAJAXRequest = $ParamObject->IsAJAXRequest();

=cut

sub IsAJAXRequest {
    my ( $Self, %Param ) = @_;

    return ( $Self->{Query}->http('X-Requested-With') // '' ) eq 'XMLHttpRequest' ? 1 : 0;
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
    return if !IsHashRefWithData($FormDraft);

    # Verify action.
    my $Action = $Self->GetParam( Param => 'Action' );
    return if $FormDraft->{Action} ne $Action;

    # add draft name to form data
    $FormDraft->{FormData}->{FormDraftTitle} = $FormDraft->{Title};

    # create FormID and add to form data
    my $FormID = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    $FormDraft->{FormData}->{FormID} = $FormID;

    # set form data to param object, depending on type
    KEY:
    for my $Key ( sort keys %{ $FormDraft->{FormData} } ) {
        my $Value = $FormDraft->{FormData}->{$Key} // '';

        # array value
        if ( IsArrayRefWithData($Value) ) {
            $Self->{Query}->param(
                -name   => $Key,
                -values => $Value,
            );
            next KEY;
        }

        # scalar value
        $Self->{Query}->param(
            -name  => $Key,
            -value => $Value,
        );
    }

    # add UploadCache data
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    for my $File ( @{ $FormDraft->{FileData} } ) {
        return if !$UploadCacheObject->FormIDAddFile(
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
    return if !$MetaParams{Action};

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
            next PARAM if !IsArrayRefWithData( \@Values );

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
        return if !$Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftUpdate(%FormDraft);
        return 1;
    }

    # create new draft
    return if !$Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftAdd(%FormDraft);
    return 1;
}

1;
