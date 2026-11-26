# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

use v5.24;
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../..";

use Test2::V0;
use URI;

use Kernel::System::Auth::OpenIDConnect;
use Kernel::System::OpenIDConnect;
use Kernel::System::OpenIDConnect::OAuth2;

my @TokenRequests;
{
    local *Kernel::System::OpenIDConnect::OAuth2::_SendRequest = sub {
        my ( $Self, %Param ) = @_;
        push @TokenRequests, {
            Endpoint => $Param{Endpoint},
            PostData => [ @{ $Param{PostData} } ],
        };

        return {
            Success => 1,
            Content => { id_token => 'mock-id-token' },
        };
    };
    local *Kernel::System::OpenIDConnect::ValidateIDToken = sub {
        return { Success => 0 };
    };

    my $RFCVerifier  = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
    my $RFCChallenge = 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM';

    my $PKCEContext = CreateContext(
        UsePKCE       => 1,
        Verifiers     => [ $RFCVerifier, 'v' x 64, 'w' x 64, 'x' x 64, 'y' x 64, 'z' x 64, 'a' x 64, 'b' x 64 ],
        RequestConfig => {
            ResponseType        => ['code'],
            AdditionalScope     => ['profile'],
            CodeChallenge       => 'untrusted-config-challenge',
            CodeChallengeMethod => 'plain',
        },
    );

    my $PKCEFlow  = StartFlow($PKCEContext);
    my %PKCEQuery = QueryParameters( $PKCEFlow->{URL} );
    is( $PKCEQuery{code_challenge},        $RFCChallenge, 'authorization URL contains the RFC 7636 S256 challenge' );
    is( $PKCEQuery{code_challenge_method}, 'S256',        'authorization URL fixes the PKCE method to S256' );
    ok( index( $PKCEFlow->{URL}, $RFCVerifier ) == -1, 'authorization URL does not expose the verifier' );
    is( $PKCEContext->{Main}->{Lengths}->[1], 64, 'verifier is generated with the configured secure random string API' );

    my $PKCEStateData = StateData( $PKCEContext, $PKCEFlow );
    is(
        $PKCEStateData,
        {
            UsePKCE      => 1,
            CodeVerifier => $RFCVerifier
        },
        'state cache keeps the verifier in its server-side PKCE record'
    );
    my @OtherCacheData = map { $PKCEContext->{Cache}->{Values}->{$_} }
        grep { $_ ne $PKCEContext->{Cache}->CacheKey( Type => 'OpenIDConnect_State', Key => $PKCEFlow->{StatePrefix} ) }
        keys %{ $PKCEContext->{Cache}->{Values} };
    ok( !( scalar grep { ContainsScalar( $_, $RFCVerifier ) } @OtherCacheData ), 'verifier is absent from other cache entries' );
    my $StateSet = $PKCEContext->{Cache}->SetCall(
        Type => 'OpenIDConnect_State',
        Key  => $PKCEFlow->{StatePrefix}
    );
    is( $StateSet->{TTL},           300, 'PKCE state uses the configured state TTL' );
    is( $StateSet->{CacheInMemory}, 0,   'PKCE state keeps the distributed cache setting' );

    @TokenRequests = ();
    RunCallback( $PKCEContext, $PKCEFlow );
    my %PKCEBody = @{ $TokenRequests[0]->{PostData} };
    is( $PKCEBody{code_verifier}, $RFCVerifier, 'authorization-code token request carries the matching verifier' );
    is(
        $PKCEContext->{Cache}->Get(
            Type => 'OpenIDConnect_State',
            Key  => $PKCEFlow->{StatePrefix}
        ),
        undef,
        'callback consumes the PKCE state'
    );

    RunCallback( $PKCEContext, $PKCEFlow );
    is( scalar @TokenRequests, 1, 'replaying the callback cannot make a second token request' );

    my $DisabledAfterStartContext = CreateContext(
        UsePKCE       => 1,
        Verifiers     => [ 'c' x 64 ],
        RequestConfig => { ResponseType => ['code'] },
    );
    my $DisabledAfterStartFlow = StartFlow($DisabledAfterStartContext);
    $DisabledAfterStartContext->{Config}->{Values}->{'AuthModule::OpenIDConnect::Config'}->{Misc}->{UsePKCE} = 0;
    @TokenRequests = ();
    RunCallback( $DisabledAfterStartContext, $DisabledAfterStartFlow );
    my %DisabledAfterStartBody = @{ $TokenRequests[0]->{PostData} };
    is( $DisabledAfterStartBody{code_verifier}, 'c' x 64, 'in-flight PKCE verifier is used if configuration is later disabled' );

    my $SecondPKCEFlow  = StartFlow($PKCEContext);
    my %SecondPKCEQuery = QueryParameters( $SecondPKCEFlow->{URL} );
    my $SecondStateData = StateData( $PKCEContext, $SecondPKCEFlow );
    isnt( $SecondStateData->{CodeVerifier}, $RFCVerifier,  'each authorization request has a unique verifier' );
    isnt( $SecondPKCEQuery{code_challenge}, $RFCChallenge, 'each authorization request has a matching distinct challenge' );

    my $DefaultContext = CreateContext(
        UsePKCE       => 0,
        Verifiers     => [],
        RequestConfig => {
            ResponseType        => ['code'],
            CodeChallenge       => 'untrusted-config-challenge',
            CodeChallengeMethod => 'plain',
        },
    );
    my $DefaultFlow  = StartFlow($DefaultContext);
    my %DefaultQuery = QueryParameters( $DefaultFlow->{URL} );
    ok( !exists $DefaultQuery{code_challenge}, 'PKCE remains disabled by default' );
    is( StateData( $DefaultContext, $DefaultFlow ), 1, 'legacy state cache value is unchanged when PKCE is disabled' );

    @TokenRequests = ();
    RunCallback( $DefaultContext, $DefaultFlow );
    my %DefaultBody = @{ $TokenRequests[0]->{PostData} };
    ok( !exists $DefaultBody{code_verifier}, 'legacy authorization-code exchange has no verifier' );

    {
        local $Kernel::OM = $DefaultContext->{OM};
        $DefaultContext->{OAuth2}->RequestToken(
            TokenEndpoint => 'https://idp.example/token',
            ClientID      => 'client-id',
            ClientSecret  => 'client-secret',
            GrantType     => 'refresh_token',
            RefreshToken  => 'refresh-token',
            CodeVerifier  => $RFCVerifier,
        );
    }
    my %RefreshBody = @{ $TokenRequests[1]->{PostData} };
    is(
        \%RefreshBody,
        {
            grant_type    => 'refresh_token',
            refresh_token => 'refresh-token'
        },
        'PKCE verifier does not alter another OAuth2 grant'
    );

    my $WrongCookieFlow = StartFlow($PKCEContext);
    @TokenRequests = ();
    RunCallback( $PKCEContext, $WrongCookieFlow, CookieValue => 'wrong-cookie' );
    is( scalar @TokenRequests, 0, 'wrong CSRF cookie is rejected before token exchange' );
    ok( StateData( $PKCEContext, $WrongCookieFlow ), 'wrong CSRF cookie does not consume the state record' );

    my $WrongStateFlow = StartFlow($PKCEContext);
    my $WrongState     = 'wrongstate000000000000';
    RunCallback(
        $PKCEContext, $WrongStateFlow,
        State       => $WrongState,
        CookieValue => $WrongState
    );
    is( scalar @TokenRequests, 0, 'state without a matching cache record is rejected before token exchange' );
    ok( StateData( $PKCEContext, $WrongStateFlow ), 'wrong state does not consume the valid request state' );

    for my $Case (
        {
            Name   => 'expired',
            Mutate => sub { $_[0]->Delete( Type => 'OpenIDConnect_State', Key => $_[1] ) }
        },
        {
            Name   => 'missing verifier',
            Mutate => sub { $_[0]->Set( Type => 'OpenIDConnect_State', Key => $_[1], Value => { UsePKCE => 1 } ) }
        },
        {
            Name   => 'malformed verifier',
            Mutate => sub { $_[0]->Set( Type => 'OpenIDConnect_State', Key => $_[1], Value => { UsePKCE => 1, CodeVerifier => 'short' } ) }
        },
        )
    {
        my $Flow = StartFlow($PKCEContext);
        $Case->{Mutate}->( $PKCEContext->{Cache}, $Flow->{StatePrefix} );
        @TokenRequests = ();
        RunCallback( $PKCEContext, $Flow );
        is( scalar @TokenRequests, 0, "$Case->{Name} PKCE state is rejected before token exchange" );
    }

    my $NoCodeFlow = StartFlow($PKCEContext);
    @TokenRequests = ();
    RunCallback(
        $PKCEContext, $NoCodeFlow,
        Code    => undef,
        IDToken => 'implicit-token'
    );
    is( scalar @TokenRequests, 0, 'PKCE response without an authorization code is rejected' );
    like( $NoCodeFlow->{Backend}->{AuthError}, qr/authorization code required for PKCE/, 'missing PKCE authorization code produces a clear authentication error' );

    my $ImplicitContext = CreateContext(
        UsePKCE       => 1,
        Verifiers     => [ 'a' x 64 ],
        RequestConfig => { ResponseType => ['id_token'] },
    );
    my $ImplicitFlow = StartFlow($ImplicitContext);
    is( $ImplicitFlow->{PreAuth}, undef, 'PKCE refuses an implicit-only response type before redirect' );
    ok(
        ( scalar grep { $_->{Message} =~ /PKCE requires an authorization code response type/ } @{ $ImplicitContext->{Log}->{Entries} } ),
        'implicit-only PKCE configuration is reported clearly in the application log'
    );
}

done_testing();

sub CreateContext {
    my (%Param) = @_;

    my $RequestConfig = $Param{RequestConfig} // { ResponseType => ['code'] };
    my $OpenIDConfig  = {
        ClientSettings => {
            ClientID     => 'client-id',
            ClientSecret => 'client-secret',
            RedirectURI  => 'https://otobo.example/otobo/index.pl?Action=Login',
        },
        ProviderSettings => {},
        Misc             => {
            UsePKCE    => $Param{UsePKCE},
            RandLength => 22,
            RandTTL    => 300,
        },
    };
    my $Config = Local::OIDC::PKCE::Config->new(
        Values => {
            'AuthModule::OpenIDConnect::AuthRequest' => $RequestConfig,
            'AuthModule::OpenIDConnect::Config'      => $OpenIDConfig,
        },
    );
    my $Cache   = Local::OIDC::PKCE::Cache->new();
    my $Main    = Local::OIDC::PKCE::Main->new( Verifiers => $Param{Verifiers} // [] );
    my $Layout  = Local::OIDC::PKCE::Layout->new();
    my $Request = Local::OIDC::PKCE::Request->new( Layout => $Layout );
    my $Log     = Local::OIDC::PKCE::Log->new();
    my $Objects = {
        'Kernel::Config'                               => $Config,
        'Kernel::System::Cache'                        => $Cache,
        'Kernel::System::Main'                         => $Main,
        'Kernel::Output::HTML::Layout'                 => $Layout,
        'Kernel::System::Web::Request'                 => $Request,
        'Kernel::System::Log'                          => $Log,
        'Kernel::System::Language'                     => Local::OIDC::PKCE::Language->new(),
        'Kernel::System::OpenIDConnect::Token'         => Local::OIDC::PKCE::Token->new(),
        'Kernel::System::OpenIDConnect::Configuration' => Local::OIDC::PKCE::Configuration->new(),
        'Kernel::System::OpenIDConnect::OAuth2'        => Kernel::System::OpenIDConnect::OAuth2->new(),
        'Kernel::System::OpenIDConnect'                => Kernel::System::OpenIDConnect->new(),
    };
    my $OM = Local::OIDC::PKCE::ObjectManager->new( Objects => $Objects );

    return {
        Config  => $Config,
        Cache   => $Cache,
        Main    => $Main,
        Layout  => $Layout,
        Request => $Request,
        Log     => $Log,
        OAuth2  => $Objects->{'Kernel::System::OpenIDConnect::OAuth2'},
        OM      => $OM,
    };
}

sub StartFlow {
    my ($Context) = @_;
    local $Kernel::OM = $Context->{OM};

    my $Backend = Kernel::System::Auth::OpenIDConnect->new();
    my $PreAuth = $Backend->PreAuth();
    return { PreAuth => $PreAuth } if !$PreAuth;

    my %Query = QueryParameters( $PreAuth->{RedirectURL} );
    return {
        Backend     => $Backend,
        URL         => $PreAuth->{RedirectURL},
        State       => $Query{state},
        StatePrefix => substr( $Query{state}, 0, 22 ),
    };
}

sub RunCallback {
    my ( $Context, $Flow, %Param ) = @_;
    return if !$Flow->{Backend};

    my $State         = exists $Param{State} ? $Param{State} : $Flow->{State};
    my %RequestParams = ( state => $State );
    my $Code          = exists $Param{Code} ? $Param{Code} : 'authorization-code';
    $RequestParams{code}     = $Code           if defined $Code;
    $RequestParams{id_token} = $Param{IDToken} if defined $Param{IDToken};

    my $StatePrefix = substr( $State, 0, 22 );
    my $CookieValue = exists $Param{CookieValue} ? $Param{CookieValue} : $Context->{Layout}->{Cookies}->{ 'OIDCCSRF-' . $StatePrefix };
    my %Cookies     = ( 'OIDCCSRF-' . $StatePrefix => $CookieValue );
    $Context->{Request}->SetCallback(
        Params  => \%RequestParams,
        Cookies => \%Cookies
    );

    local $Kernel::OM = $Context->{OM};
    return $Flow->{Backend}->Auth();
}

sub QueryParameters {
    my ($URL) = @_;
    return URI->new($URL)->query_form;
}

sub StateData {
    my ( $Context, $Flow ) = @_;
    return if !$Flow->{StatePrefix};
    return $Context->{Cache}->Get(
        Type => 'OpenIDConnect_State',
        Key  => $Flow->{StatePrefix}
    );
}

sub ContainsScalar {
    my ( $Value, $Needle ) = @_;
    return defined $Value && $Value eq $Needle if !ref $Value;
    return scalar grep { ContainsScalar( $_, $Needle ) } values %{$Value} if ref $Value eq 'HASH';
    return scalar grep { ContainsScalar( $_, $Needle ) } @{$Value}        if ref $Value eq 'ARRAY';
    return;
}

package Local::OIDC::PKCE::ObjectManager;

sub new { my ( $Class, %Param ) = @_; return bless \%Param, $Class }
sub Get { my ( $Self,  $Name )  = @_; return $Self->{Objects}->{$Name} }

package Local::OIDC::PKCE::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new { my ( $Class, %Param ) = @_; return bless \%Param, $Class }
sub Get { my ( $Self,  $Name )  = @_; return $Self->{Values}->{$Name} }

package Local::OIDC::PKCE::Cache;     ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {
        Values   => {},
        SetCalls => []
    }, $Class;
}
sub CacheKey { my ( $Self, %Param ) = @_; return $Param{Type} . "\0" . $Param{Key} }

sub Set {
    my ( $Self, %Param ) = @_;
    $Self->{Values}->{ $Self->CacheKey(%Param) } = $Param{Value};
    push @{ $Self->{SetCalls} }, {%Param};
    return 1;
}
sub Get { my ( $Self, %Param ) = @_; return $Self->{Values}->{ $Self->CacheKey(%Param) } }
sub Delete { my ( $Self, %Param ) = @_; delete $Self->{Values}->{ $Self->CacheKey(%Param) }; return 1 }

sub SetCall {
    my ( $Self, %Param ) = @_;
    my $Key = $Self->CacheKey(%Param);
    my ($Call) = reverse grep { $Self->CacheKey(%$_) eq $Key } @{ $Self->{SetCalls} };
    return $Call;
}

package Local::OIDC::PKCE::Main;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new { my ( $Class, %Param ) = @_; return bless { Verifiers => $Param{Verifiers}, Counter => 0, Lengths => [] }, $Class }

sub GenerateRandomString {
    my ( $Self, %Param ) = @_;
    push @{ $Self->{Lengths} }, $Param{Length};
    return shift @{ $Self->{Verifiers} } if $Param{Length} == 64;
    return sprintf 'state%017d', ++$Self->{Counter};
}

package Local::OIDC::PKCE::Layout;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless { Cookies => {} }, $Class;
}
sub SetCookie { my ( $Self, %Param ) = @_; $Self->{Cookies}->{ $Param{Key} } = $Param{Value}; return 1 }

package Local::OIDC::PKCE::Request;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new         { my ( $Class, %Param ) = @_; return bless { Layout => $Param{Layout}, Params => {}, Cookies => {} }, $Class }
sub SetCallback { my ( $Self, %Param ) = @_; $Self->{Params} = $Param{Params}; $Self->{Cookies} = $Param{Cookies}; return 1 }
sub GetParam    { my ( $Self, %Param ) = @_; return $Self->{Params}->{ $Param{Param} } }

sub GetCookie {
    my ( $Self, %Param ) = @_;
    return $Self->{Cookies}->{ $Param{Key} } if exists $Self->{Cookies}->{ $Param{Key} };
    return $Self->{Layout}->{Cookies}->{ $Param{Key} };
}

package Local::OIDC::PKCE::Log;        ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless { Entries => [] }, $Class;
}
sub Log { my ( $Self, %Param ) = @_; push @{ $Self->{Entries} }, \%Param; return 1 }

package Local::OIDC::PKCE::Configuration;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}
sub GetAuthorizationEndpoint { return 'https://idp.example/authorize' }
sub GetTokenEndpoint         { return 'https://idp.example/token' }

package Local::OIDC::PKCE::Language;         ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub Translate {
    my ( $Self, $Text ) = @_;
    return $Text;
}

package Local::OIDC::PKCE::Token;            ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

package main;                                ## no critic qw(Modules::ProhibitMultiplePackages)
