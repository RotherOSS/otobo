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

package Kernel::System::Package::Event::SyncWithS3;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Mojo::AWS::S3;
use Mojo::DOM;
use Mojo::Date;
use Mojo::JSON qw(encode_json);
use Mojo::URL;
use Mojo::UserAgent;

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }

    # TODO: AWS bucket must be set up in Kubernetes config map
    my $Bucket       = 'otobo-20211018a';
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Region       = $ConfigObject->Get('Ticket::Article::Backend::MIMEBase::ArticleStorageS3::Region')
        || die 'Got no AWS Region!';
    my $UserAgent = Mojo::UserAgent->new();
    my $S3Object  = Mojo::AWS::S3->new(
        transactor => $UserAgent->transactor,
        service    => 's3',
        region     => $Region,
        access_key => 'test',
        secret_key => 'test',
    );

    # generate Mojo transaction for submitting plain to S3
    my $FilePath = join '/', $Bucket, 'OTOBO', 'Kernel', 'Config', 'Files', 'event_package.json';
    my $Now      = Mojo::Date->new(time)->to_datetime;
    my $URL      = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
    my %Headers  = ( 'Content-Type' => 'application/json' );

    # TODO: get a more sensible content
    my $JSONContent = encode_json( \%Param );
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$JSONContent );

    my $Transaction = $S3Object->signed_request(
        method         => 'PUT',
        datetime       => $Now,
        url            => $URL,
        signed_headers => \%Headers,
        payload        => [$JSONContent],
    );

    # run blocking request
    $UserAgent->start($Transaction);

    # TODO: check success
    return 1;
}

1;
