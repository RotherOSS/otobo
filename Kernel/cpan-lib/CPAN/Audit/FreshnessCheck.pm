package CPAN::Audit::FreshnessCheck;

use v5.10;

our $VERSION = '1.001';

=head1 NAME

CPAN::Audit::Freshness - check freshness of CPAN::Audit::DB

=head1 SYNOPSIS

    use CPAN::Audit::Freshness;

    # from the command-line, with default threshold
    % perl -MCPAN::Audit::Freshness cpan-audit

    # from the command-line, with specified threshold of 5 days
    % perl -MCPAN::Audit::Freshness=5 cpan-audit
    % env CPAN_AUDIT_FRESH_DAYS=30 perl -MCPAN::Audit::Freshness cpan-audit

=head1 DESCRIPTION

When loaded, this module outputs a warning if it thinks the version
of L<CPAN::Audit::DB> is too old. It does this by comparing the version
of that module, which is date-based, with the current time. The default
threshold is 30 days, although you can set the value of C<CPAN_AUDIT_FRESH_DAYS>.

There is no other functionality for this module.

=head1 LICENSE

This library is under the Artistic License 2.0.

=head1 AUTHOR

Copyright (C) 2022-2024 brian d foy, I<< <briandfoy@pobox.com> >>

=cut

sub import {
    my( $class, $days ) = @_;

    require Time::Piece;
    require CPAN::Audit::DB;
    my $template = '%Y%m%d';
    my( $year, $month, $day ) = (localtime)[5,4,3];
    $year += 1900; $month += 1;

    my $now_string = sprintf "%4d%02d%02d", $year, $month, $day;
    my $now_moment = Time::Piece->strptime( $now_string, $template );

    my $db_time   = CPAN::Audit::DB->VERSION =~ s/\..*//r;
    my $db_moment = Time::Piece->strptime( $db_time, $template );

    my $duration = int( ($now_moment - $db_moment) / 86_400 );
    warn "Database is $duration days old. Check for updates with `cpan -D CPAN::Audit::DB`\n"
        if $duration >= threshold($days);
    }

sub default_threshold { 30 }

sub threshold { $_[0] // $ENV{CPAN_AUDIT_FRESH_DAYS} // default_threshold() }

__PACKAGE__;
