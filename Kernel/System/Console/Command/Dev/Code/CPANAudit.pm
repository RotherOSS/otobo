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

package Kernel::System::Console::Command::Dev::Code::CPANAudit;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use Config;    # import %Config
use Cwd qw(abs_path);
use List::Util qw(none);

# CPAN modules
use CPAN::Audit 20260308.002 ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::JSON',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Scan CPAN dependencies in Kernel/cpan-lib and in the system for known vulnerabilities.');

    $Self->AddOption(
        Name        => 'dump-otobo-evaluations',
        Description => 'Show the relevance for OTOBO of advisories evaluated by the OTOBO team',
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get options
    my $DoDumpEvaluations = $Self->GetOption('dump-otobo-evaluations');

    my %Evaluations = $Self->GetOtoboEvaluations;

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    if ($DoDumpEvaluations) {
        $Self->Print(
            $JSONObject->Encode(
                Data     => \%Evaluations,
                SortKeys => 1,
                Pretty   => 1,
            )
        );

        # always successfull
        return 0;
    }

    # Do the actual auditing per default
    my $Audit = CPAN::Audit->new(
        no_color    => 1,
        no_corelist => 0,
        ascii       => 0,
        verbose     => 0,
        quiet       => 0,
        interactive => 0,
    );

    # We need to pass an explicit list of paths to be scanned by CPAN::Audit, otherwise it will fallback to @INC which
    # includes our complete tree, with article storage, cache, temp files, etc. It can result in a downgraded
    # performance if this command is run often.
    # Please see bug#14666 for more information.
    #
    # Normalize the pathes before comparing them as @INC has pathes like '/opt/otobo/bin/psgi-bin/../../Custom'.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Home         = abs_path( $ConfigObject->Get('Home') // '/opt/otobo' );
    my @PathsToScan;
    PATH:
    for my $Path (@INC) {

        # no need to search in non-existing dirs
        next PATH unless $Path;
        next PATH unless -d $Path;

        # older Perls have '.' in @INC. This path is not excluded, just to stay on the safe side

        # ignore the search pathes with OTOBO files
        my $AbsPath = abs_path($Path);

        next PATH if $AbsPath eq $Home;             # OTOBO home folder
        next PATH if $AbsPath eq "$Home/Custom";    # Custom folder

        push @PathsToScan, $Path;
    }

    my $Result = $Audit->command( 'installed', @PathsToScan );

    # Consider the evaluations by the OTOBO team
    my $NumRelevantAdvisories = 0;
    for my $DistName ( keys $Result->{dists}->%* ) {
        my $Dist = $Result->{dists}->{$DistName};

        ADVISORY:
        for my $Advisory ( $Dist->{advisories}->@* ) {
            my $Evaluation        = $Evaluations{ $Advisory->{id} };
            my $EvaluationApplies = $Evaluation ? 1 : 0;

            # some advisories are relevant only in special cases
            if ($Evaluation) {
                if ( $Evaluation->{only_relevant_for_32bit_perl} && !$Config{use64bitall} ) {
                    $EvaluationApplies = 0;    # evaluation does not apply on 32bit Perl
                }

                # Currently not used, but might be useful in future
                if ( $Evaluation->{only_when_version_is} ) {
                    if ( none { "==$_" eq $Dist->{version} } $Evaluation->{only_when_version_is}->@* ) {
                        $EvaluationApplies = 0;    # evaluation does not apply for unknown versions
                    }
                }
            }

            if ($EvaluationApplies) {
                $Advisory->{otobo_evaluation} = $Evaluation;
                $NumRelevantAdvisories += $Evaluation->{is_relevant_for_otobo};
            }
            else {

                # evaluations that do not apply count as not being not evaluated
                $Advisory->{otobo_evaluation} = { has_been_evaluated => 0 };
                $NumRelevantAdvisories++;
            }
        }
    }

    # tell about the OTOBO evaluation
    $Result->{meta}->{total_otobo_relevant_advisories} = $NumRelevantAdvisories;

    $Self->Print(
        $JSONObject->Encode(
            Data     => $Result,
            SortKeys => 1,
            Pretty   => 1,
        )
    );

    my $NumAdvisories = $Result->{meta}->{total_otobo_relevant_advisories} // $Result->{meta}->{total_advisories} // -1;

    return $NumAdvisories ? 1 : 0;
}

sub GetOtoboEvaluations {
    my %Reason = (
        Mojolicious => <<'END_REASON',
This advisory is about default encryption settings when creating a new Mojolicious app.
But OTOBO uses Mojolicious in a very limited way, only as a helper for the S3 compatible backend.
Therefore default settings for new applications are of no concern here.
END_REASON

        cpanm => <<'END_REASON',
In Docker based installations the commands /opt/otobo/bin/docker/carton and /usr/local/bin/cpanm
have been patched to download source via HTTPS.
END_REASON

        debian_unimportant => <<'END_REASON',
Debian has classified the urgency of this advisory as unimportant. OTOBO does the same.
END_REASON

        ldaps => <<'END_REASON',
The advisory is about default settings in the underlying module Net::LDAPS. In OTOBO the admin
is responsible for setting up the connection to the LDAP server.
END_REASON

        'xsendfile' => <<'END_REASON',
The advisory is about the Plack middlewarx Plack::Middleware::XSendfile. This middleware is not used
in OTOBO.
END_REASON

        thirtytwo_bit_perl => <<'END_REASON',
The advisory is only relevant for 32bit builds of Perl. But this is a 64bit build of Perl.
END_REASON

        text_linefold => <<'END_REASON',
The advisory is about the module Text::LineFold. This module is not used in OTOBO.
It is installed only because it is included in Unicode::LineBreak.
Unicode::LineBreak is installed because Unicode::GCString is needed by the test suite.

        crypt_with_md5 => <<'END_REASON',
The advisory is relevant only when customer or user passwords are stored in the database in MD5 crypted form.
Using MD5 for crypting passwords is discouraged in OTOBO. Therefore this advisory is not relevant in regular installations.
END_REASON
    );

    return
        'CPANSA-Mojolicious-2024-58134' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{Mojolicious},
        },
        'CPANSA-Mojolicious-2024-58135' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{Mojolicious},
        },
        'CPANSA-App-cpanminus-2024-45321' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{cpanm},
        },
        'CPANSA-File-Temp-2011-4116' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{debian_unimportant},
        },
        'CPANSA-Net-LDAPS-2020-16093' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{ldaps},
        },
        'CPANSA-Plack-2026-7381' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{xsendfile},
        },
        'CPANSA-perl-2026-8376' => {
            only_relevant_for_32bit_perl => 1,
            is_relevant_for_otobo        => 0,
            reason                       => $Reason{thirtytwo_bit_perl},
        },
        'CPANSA-Unicode-LineBreak-2026-8594' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{text_linefold},
        },
        'CPANSA-Crypt-PasswdMD5-2026-6659' => {
            is_relevant_for_otobo => 0,
            reason                => $Reason{crypt_with_md5},
        },
        ;
}

1;
