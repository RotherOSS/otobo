package DateTime::TimeZone::ICal::Parsing;

use 5.010;
use strict;
use warnings FATAL => 'all';

use Moo::Role;
use namespace::autoclean;

use DateTime;
use DateTime::Span;
use DateTime::Set;
use DateTime::Format::ICal;
use URI;

=head1 NAME

DateTime::TimeZone::ICal::Parsing - Role for iCal parsing operations

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

# this is the subset of relevant properties and their default types
my %PROPS = (
    COMMENT         => 'TEXT',
    DTSTART         => 'DATE-TIME',
    TZID            => 'TEXT',
    TZNAME          => 'TEXT',
    TZOFFSETFROM    => 'UTC-OFFSET',
    TZOFFSETTO      => 'UTC-OFFSET',
    TZURL           => 'URI',
    RDATE           => 'DATE-TIME',
    RRULE           => 'RECUR',
    'LAST-MODIFIED' => 'DATE-TIME',
);

# these are different from above
my %TYPES = (
    DATE         => sub { DateTime::Format::ICal->parse_datetime($_[1]) },
    'DATE-TIME'  => sub { DateTime::Format::ICal->parse_datetime($_[1]) },
    DURATION     => sub { DateTime::Format::ICal->parse_duration($_[1]) },
    FLOAT        => sub {
        my ($x) = ($_[1] =~ /^\s*([+-]?\d+(?:\.\d+))\s*$/); $x },
    INTEGER      => sub {
        my ($x) = ($_[1] =~ /^\s*([+-]?\d+)\s*$/); $x },
    PERIOD       => sub {
        my ($start, $end) = split m!\s*/+\s*!, $_[1];
        $start = DateTime::Format::ICal->parse_datetime($start);
        if ($end =~ /^[Pp]/) {
            $end = DateTime::Format::ICal->parse_duration($end);
            $end = $start + $end;
        }
        else {
            $end = DateTime::Format::ICal->parse_datetime($end);
        }

        DateTime::Span->from_datetimes(start => $start, end => $end);
    },
    RECUR        => sub { $_[1] }, # leave this for now
    TEXT         => sub { $_[1] },
    URI          => sub { URI->new($_[1]) },
    'UTC-OFFSET' => sub { my ($x) = ($_[1] =~ /^\s*([+-]?\d{4})\s*/); $x },
);

=head1 SYNOPSIS

    with 'DateTime::TimeZone::ICal::Parsing';

    # ...

=head1 METHODS

=head2 parse_val

Parses a property value and returns a more interesting and usable
datatype.

=cut

sub parse_val {
    my ($self, $prop) = @_;
    return unless $prop;

    my $val  = $prop->value;
    return unless defined $prop->value;

    my $name = $prop->key;
    my $type = $prop->parameters->{VALUE} || $PROPS{uc $name} || 'TEXT';

    $val = eval { $TYPES{$type}->($self, $val) };
    warn "$name $type $@" if $@;
    return if $@;

    $val;
}

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-datetime-timezone-ical at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DateTime-TimeZone-ICal>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DateTime::TimeZone::ICal::Parsing

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTime-TimeZone-ICal>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DateTime-TimeZone-ICal>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DateTime-TimeZone-ICal>

=item * Search CPAN

L<http://search.cpan.org/dist/DateTime-TimeZone-ICal/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Dorian Taylor.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License.  You may
obtain a copy of the License at
L<http://www.apache.org/licenses/LICENSE-2.0> .

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.

=cut

1; # End of DateTime::TimeZone::ICal::Parsing
