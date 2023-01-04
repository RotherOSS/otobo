package DateTime::TimeZone::ICal::Spec;

use 5.010;
use strict;
use warnings FATAL => 'all';

use Moo;
use namespace::autoclean;

with 'DateTime::TimeZone::ICal::Parsing';

=head1 NAME

DateTime::TimeZone::ICal::Spec - Class for holding Standard/DST specs

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    # assume $vtimezone is a Data::ICal::Entry::TimeZone
    my @spec = @{$vtimezone->entries}

    @spec = map { DateTime::TimeZone::ICal::Spec->from_ical_entry } @spec;

=head1 METHODS

=head2 new %PARAMS

=over 4

=item dtstart

=cut

has dtstart => (
    is => 'ro',
    required => 1,
);

=item tzoffsetto

=cut

has tzoffsetto => (
    is => 'ro',
    required => 1,
);

=item tzoffsetfrom

=cut

has tzoffsetfrom => (
    is => 'ro',
    required => 1,
);

=item rrule

=cut

has _rrule => (
    is => 'ro',
    default => sub { [] },
    init_arg => 'rrule',
);

=item rdate

=cut

has _rdate => (
    is => 'ro',
    default => sub { [] },
    init_arg => 'rdate',
#    isa => 'ArrayRef[DateTime]',
);

=item tzname

=cut

has tzname => (
    is => 'ro',
    default => sub { [] },
);

=item comment

=cut

has comment => (
    is => 'ro',
    default => sub { [] },
);

=back

=cut

sub BUILD {
    my $self = shift;

    # fix the offset of dtstart
    my $start = $self->dtstart;
    $start->set_time_zone($self->tzoffsetto);

    # now fix the recurrence rules
    my $set;
    for my $rule (@{$self->_rrule}) {
        my $x = eval { DateTime::Format::ICal->parse_recurrence
              (recurrence => $rule, dtstart => $start) } or next;
        $set = $set ? $set->union($x) : $x;
    }

    # XXX don't do rdate for now

    $self->recurrence($set);
}

=head2 recurrence

=cut

has recurrence => (
    is => 'rw',
);

=head2 from_ical_entry $ENTRY

=cut


sub from_ical_entry {
    my ($class, $entry) = @_;


    # make sure this is legit
    return unless $entry->can('ical_entry_type')
        and $entry->ical_entry_type =~ /^(?:STANDARD|DAYLIGHT)$/;

    my %out;

    for my $name ($entry->mandatory_unique_properties,
               $entry->optional_unique_properties) {
        my ($prop) = @{$entry->property($name) || []};
        $prop = $class->parse_val($prop);
        $out{$name} = $prop;
    }

    for my $name ($entry->mandatory_repeatable_properties,
               $entry->optional_repeatable_properties) {
        my @prop = @{$entry->property($name) || []};
        @prop = map { $class->parse_val($_) } @prop;
        $out{$name} = \@prop;
    }

    # this is a class method
    $class = ref $class if ref $class;

    return $class->new(%out);
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

    perldoc DateTime::TimeZone::ICal::Spec


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
L<http://www.apache.org/licenses/LICENSE-2.0>.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.

=cut

1; # End of DateTime::TimeZone::ICal::Spec
