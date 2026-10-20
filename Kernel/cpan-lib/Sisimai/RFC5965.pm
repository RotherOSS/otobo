package Sisimai::RFC5965;
use v5.26;
use strict;
use warnings;
use constant FIELDINDEX => [
    # https://datatracker.ietf.org/doc/html/rfc5965
    # Required Fields
    # The following report header fields MUST appear exactly once:
    'Feedback-Type', 'User-Agent', 'Version',

    # Optional Fields Appearing Once
    # The following header fields are optional and MUST NOT appear more than once:
    # - "Reporting-MTA" is defined in Sisimai::RFC1894->FIELDINDEX()
    'Original-Envelope-Id', 'Original-Mail-From', 'Arrival-Date', 'Source-IP', 'Incidents',

    # Optional Fields Appearing Multiple Times
    # The following set of header fields are optional and may appear any number of times as
    # appropriate:
    'Authentication-Results', 'Original-Rcpt-To', 'Reported-Domain', 'Reported-URI',

    # The historic field "Received-Date" SHOULD also be accepted and interpreted identically to
    # "Arrival-Date".  However, if both are present, the report is malformed and SHOULD be
    # treated as described in Section 4.
    'Received-Date',
];

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::RFC5965 - A class for An Extensible Format for Email Feedback Reports

=head1 SYNOPSIS

    use Sisimai::RFC5965;

=head1 DESCRIPTION

C<Sisimai::RFC5965> provide methods related to An Extensible Format for Email Feedback Reports

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2023-2025 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

