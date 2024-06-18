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

use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use LWP::UserAgent ();

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TestUserLogin         = $Helper->TestUserCreate();
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

my $BaseURL = $ConfigObject->Get('HttpType') . '://';

$BaseURL .= $Helper->GetTestHTTPHostname() . '/';
$BaseURL .= $ConfigObject->Get('ScriptAlias') . 'index.pl?';

my $UserAgent = LWP::UserAgent->new(
    Timeout => 60,
);
$UserAgent->cookie_jar( {} );    # keep cookies

my $Response = $UserAgent->get(
    $BaseURL . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
);
if ( !$Response->is_success() ) {
    skip_all("Could not login to agent interface, aborting! URL: ${BaseURL}Action=Login;User=$TestUserLogin;Password=$TestUserLogin;");
}

my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
my $FormID            = $UploadCacheObject->FormIDCreate();

my $CheckUpload = sub {
    my %Param = @_;

    my $Response = $Param{Response};

    is( $Response->code, 200, "Response status is successful" );

    if ( $Param{Successful} ) {
        like(
            scalar $Response->content,
            qr{Action=PictureUpload},
            "Response check for link to uploaded image",
        );
        my ($ContentID) = $Response->content() =~ m{ContentID=(.*?)"};

        my $ContentResponse = $UserAgent->get("${BaseURL}Action=PictureUpload;FormID=$FormID;ContentID=$ContentID");

        is(
            $ContentResponse->content,
            $Param{Content},
            'Response content',
        );

        is(
            substr( $ContentResponse->header('Content-Type'), 0, 6 ),
            'image/',
            'Response content type',
        );
    }
    else {
        unlike(
            scalar $Response->content,
            qr{Action=PictureUpload},
            "Response check for link to uploaded image, no link is expected",
        );
    }
};

# Upload image correctly and verify it.
my $ResponseTest1 = $UserAgent->post(
    $BaseURL,
    Content_Type => 'form-data',
    Content      => {
        Action => 'PictureUpload',
        FormID => $FormID,
        upload => [
            undef, 'index1.png',
            'Content-Type' => 'image/png',
            Content        => '123'
        ],
    }
);

$CheckUpload->(
    Response   => $ResponseTest1,
    Successful => 1,
    Content    => '123'
);

# Upload image with wrong content-type, must fail.
my $ResponseTest2 = $UserAgent->post(
    $BaseURL,
    Content_Type => 'form-data',
    Content      => {
        Action => 'PictureUpload',
        FormID => $FormID,
        upload => [
            undef, 'index2.png',
            'Content-Type' => 'text/html',
            Content        => '123'
        ],
    }
);

$CheckUpload->(
    Response   => $ResponseTest2,
    Successful => 0
);

# Store image with wrong content-type and verify that it is not served by the application.
my $ContentID = 'inline695415.287823406.1544532925.8063442.1111111111@unittest.local';
$UploadCacheObject->FormIDAddFile(
    FormID      => $FormID,
    Filename    => 'index3.png',
    Content     => '123',
    ContentID   => $ContentID,
    ContentType => 'text/html',
    Disposition => 'inline',       # optional
);

my $ResponseTest3 = $UserAgent->get("${BaseURL}Action=PictureUpload;FormID=$FormID;ContentID=$ContentID");
ok(
    index(
        $ResponseTest3->content(),
        q|CKEDITOR.tools.callFunction(0, '', "The file is not an image that can be shown inline!"|
    ) > -1,
    'Response check for CKEditor error handler',
);

my $ContentSVG = <<'EOF';
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg">
<polygon id="triangle" points="0,0 0,50 50,0" fill="#009900" stroke='#004400'/>
<script type="text/javascript">alert(document.domain);</script></svg>
EOF

my $EscapedContentSVG = <<'EOF';



<svg version="1.1" baseprofile="full" xmlns="http://www.w3.org/2000/svg">
<polygon id="triangle" points="0,0 0,50 50,0" fill="#009900" stroke="#004400" />
</svg>
EOF

# Upload svg image with png file and script element.
my $ResponseTest4 = $UserAgent->post(
    $BaseURL,
    Content_Type => 'form-data',
    Content      => {
        Action => 'PictureUpload',
        FormID => $FormID,
        upload => [
            undef, 'index4.png',
            'Content-Type' => 'image/svg+xml',
            Content        => $ContentSVG,
        ],
    }
);

$CheckUpload->(
    Response   => $ResponseTest4,
    Successful => 1,
    Content    => $EscapedContentSVG,
);

done_testing;
