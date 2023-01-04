package DateTime::TimeZone::_ICal;

use parent 'DateTime::TimeZone';

# kill the DateTime::TimeZone constructor
sub new {
    bless {}, shift || __PACKAGE__
}

package DateTime::TimeZone::ICal;

use 5.010;
use strict;
use warnings FATAL => 'all';

use Moo;
use namespace::autoclean;

use base 'DateTime::TimeZone::_ICal';

use DateTime::TimeZone::ICal::Spec;

with 'DateTime::TimeZone::ICal::Parsing';


=head1 NAME

DateTime::TimeZone::ICal - iCal VTIMEZONE entry to DateTime::TimeZone

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

    use Data::ICal;
    use DateTime::Format::ICal;
    use DateTime::TimeZone::ICal;

    my $ical = Data::ICal->new(filename => 'foo.ics');

    # generate a table of time zones
    my (%tz, @events);
    for my $entry (@{$ical->entries}) {
        my $type = $entry->ical_entry_type;
        if ($type eq 'VTIMEZONE') {
            my $dtz = DateTime::TimeZone::ICal->from_ical_entry($entry);
            $tz{$dtz->name} = $dtz;
        }
        elsif ($type eq 'VEVENT') {
            push @events, $entry;
        }
        # ... handle other iCal objects ...
     }

     # now we can use this dictionary of time zones elsewhere:

     for my $event (@events) {
         # get a property that is a date
         my ($dtstart) = @{$event->property('dtstart')};

         # get the time zone key from the property parameters
         my $tzid = $dtstart->parameters->{TZID};

         # convert the date in the ordinary fashion
         my $dt = DateTime::Format::ICal->parse_datetime($dtstart->value);

         # the datetime will be 'floating', therefore unaffected
         $dt->set_time_zone($tz{$tzid}) if $tzid and $tz{$tzid};

         # ... do other processing ...
     }

=head1 DESCRIPTION

Conforming iCal documents (L<RFC
5545|https://tools.ietf.org/html/rfc5545>) have three ways to
represent C<DATE-TIME> values: UTC, local, and specified through the
C<TZID> mechanism. C<TZID> I<parameters> in relevant properties are
references to the same C<TZID> I<property> in one of a list of
C<VTIMEZONE> objects, where the information about UTC offsets and
their recurrence is embedded in the document.

In practice, many generators of iCal documents use, as C<TZID> keys,
valid labels from L<the Olson
database|http://www.iana.org/time-zones>, but others, notably
Microsoft Outlook, do not. RFC 5545 explicitly declines to specify a
naming convention, so it is sometimes necessary to construct the time
zone offsets and daylight savings changes from the C<VTIMEZONE> data
itself, rather than just inferring it from the name. That's where this
module comes in.

=head1 METHODS

The only differences in interface for this module are its constructor
and one method, L</from_ical_entry>. The rest of the interface should
work exactly the same way as L<DateTime::TimeZone>, so please consult
its documentation for other functionality.

This module overrides the following methods:

=over 4

=item

L<name|DateTime::TimeZone/name>

=item

L<category|DateTime::TimeZone/category>

=cut

has category => (
    is      => 'ro',
#    isa     => 'Undef',
    default => sub { undef },
);

=item

L<is_floating|DateTime::TimeZone/is_floating>

=cut

has is_floating => (
    is      => 'ro',
#    isa     => 'Bool',
    default => sub { 0 },
);

=item

L<is_olson|DateTime::TimeZone/is_olson>

=cut

has is_olson => (
    is      => 'ro',
#    isa     => 'Bool',
    default => sub { 0 },
);

=item

L<offset_for_datetime|DateTime::TimeZone/offset_for_datetime>

=cut

# this private generic accessor drives all other accessors
sub _spec_for {
    my ($self, $dt) = @_;

    my %spec;
    # find the most appropriate standard and daylight entries
    for my $k (qw(standard daylight)) {
        # this will pick the spec closest to the datetime
        my @specs = @{$self->$k} or next;

        # no sense in this rigmarole if there's only one spec
        if (@specs == 1) {
            $spec{$k} = $specs[0];
            next;
        }

        my ($spec) = sort { DateTime::Duration->compare
              ($dt - $a->dtstart, $dt - $b->dtstart, $dt)
          } grep { $dt >= $_->dtstart } @specs;

        # get the oldest one if the datetime is too old
        ($spec) = reverse @specs unless $spec;

        # now assign it
        $spec{$k} = $spec;
    }

    if ($spec{daylight}) {
        # now we find which of the recurrences is closest;
        my ($sr, $dr) = map { $spec{$_}->recurrence } qw(standard daylight);

        # XXX HO-LEE-CRAP these set methods are slow.
        #my $sd = $sr->current($dt) if $sr;
        #my $dd = $dr->current($dt) if $dr;

        # NO.
        # # if dd is bigger than sd then we are in daylight savings
        # if ($sd && $dd && $dd > $sd) {

        # the above is accurate but it's unacceptably, RIDICULOUSLY slow.

        # instead we're going to assume that daylight savings time is
        # pinned to the year

        # just take the first instance of each and then subtract th
        if ($sr && $dr) {
            #my $sd = ($sr->min->utc_rd_values
            my ($sm, $dm) = ($sr->min, $dr->min);

            my $sd = ($sm->utc_rd_values)[1] / 86400 + $sm->day_of_year;
            my $dd = ($dm->utc_rd_values)[1] / 86400 + $dm->day_of_year;
            my $nd = ($dt->utc_rd_values)[1] / 86400 + $dt->day_of_year;

            #warn "$sd $dd $nd";

            if ($nd >= $dd && $nd <= $sd) {
                return wantarray ? ($spec{daylight}, 1) : $spec{daylight};
            }
        }
    }

    return $spec{standard};
}

sub offset_for_datetime {
    my ($self, $dt) = @_;

    my $spec = $self->_spec_for($dt);

    $self->offset_as_seconds($spec->tzoffsetto);
}

=item

L<offset_for_local_datetime|DateTime::TimeZone/offset_for_local_datetime>

=cut

sub offset_for_local_datetime {
    my ($self, $dt) = @_;

    my $spec = $self->_spec_for($dt);

    $self->offset_as_seconds($spec->tzoffsetto);
}

=item

L<is_dst_for_datetime|DateTime::TimeZone/is_dst_for_datetime>

=cut

sub is_dst_for_datetime {
    my ($self, $dt) = @_;

    my (undef, $dst) = $self->_spec_for($dt);

    $dst ? 1 : 0;
}

=item

L<short_name_for_datetime|DateTime::TimeZone/short_name_for_datetime>

=cut

sub short_name_for_datetime {
    my ($self, $dt) = @_;

    my $spec = $self->_spec_for($dt);

    $spec->tzname;
}

=item

L<is_utc|DateTime::TimeZone/is_utc>

=cut

sub is_utc {
    my $self = shift;
    if (@{$self->daylight} == 0) {
        if (my ($latest) = @{$self->standard}) {
            return $self->offset_as_seconds($latest->tzoffsetto) == 0;
        }
    }
}

=item

L<has_dst_changes|DateTime::TimeZone/has_dst_changes>

=cut

sub has_dst_changes {
    return scalar @{shift->daylight};
}

=back

=head2 new %PARAMS

The constructor has been modified to permit the assembly of a time
zone specification from piecemeal data. These are the following
initialization parameters:

=over 4

=item tzid

This is the C<TZID> of the iCal entry. Note that the accessor to
retrieve the value from an instantiated object is C<name>, for
congruence with L<DateTime::TimeZone>.

=cut

has name => (
    is       => 'ro',
    init_arg => 'tzid',
    default  => sub { 'VTIMEZONE' },
);

=item standard

This is an C<ARRAY> reference of L<DateTime::TimeZone::ICal::Spec>
instances, or otherwise of C<HASH> references congruent to that
module's constructor, which will be coerced into said objects. This
parameter is I<required>, and there must be I<at least> one member in
the C<ARRAY>.

=cut

has standard => (
    is       => 'ro',
#    isa      => sub { die unless ref $_[1] eq 
#    isa      => 'DateTime::TimeZone::ICal::Part',
    required => 1,
    default => sub { [] },
);


=item daylight

Same deal but for Daylight Savings Time. This parameter is optional,
as is its contents.

=cut

has daylight => (
    is => 'ro',
    default => sub { [] },
);

=back

In practice you may not need to ever use this constructor directly,
but it may come in handy for instances where you need to compose
non-standard time zone behaviour from scratch.

=cut

sub BUILD {
    my $self = shift;

    for my $speclist ($self->standard, $self->daylight) {
        # now sort them
        @$speclist = sort { $b->dtstart <=> $a->dtstart } @$speclist;
    }
}

=head2 from_ical_entry $ENTRY [, $USE_DATA ]

This class method converts a L<Data::ICal::Entry> object of type
C<VTIMEZONE> into a L<DateTime::TimeZone::ICal> object. It will
C<croak> if the input is malformed, so wrap it in an C<eval> or
equivalent if you expect that possibility.

This method attempts to check if an existing L<DateTime::TimeZone> can
be instantiated from the C<TZID>, thus skipping over any local
processing. This behaviour can be overridden with the C<$USE_DATA>
flag.

=cut

sub from_ical_entry {
    my ($class, $entry, $use_data) = @_;

    my %out;

    for my $name ($entry->mandatory_unique_properties,
               $entry->optional_unique_properties) {
        my ($prop) = @{$entry->property($name) || []};
        $prop = $class->parse_val($prop);
        $out{$name} = $prop;
    }

    # search for an existing time zone unless overridden
    unless ($use_data) {
        my $tz = eval { DateTime::TimeZone->new(name => $out{tzid}) };
        return $tz if $tz;
    }

    for my $name ($entry->mandatory_repeatable_properties,
               $entry->optional_repeatable_properties) {
        my @prop = @{$entry->property($name) || []};
        @prop = map { $class->parse_val($_) } @prop;
        $out{$name} = \@prop;
    }

    for my $spec (@{$entry->entries}) {
        my $type = lc $spec->ical_entry_type;
        if ($type =~ /^(?:standard|daylight)$/) {
            my $x = $out{$type} ||= [];

            my $y = DateTime::TimeZone::ICal::Spec->from_ical_entry($spec);

            push @$x, $y if $y;
        }
    }

    $class = ref $class if ref $class;

    return $class->new(\%out);
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

    perldoc DateTime::TimeZone::ICal


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

=head1 SEE ALSO

=over 4

=item L<DateTime::TimeZone>

=item L<DateTime::Format::ICal>

=item L<Data::ICal>

=item L<RFC 5545|https://tools.ietf.org/html/rfc5545>

=item L<IANA Time Zones (Olson Database)|http://www.iana.org/time-zones>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Dorian Taylor.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License.  You may
obtain a copy of the License at
L<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.

=cut

1; # End of DateTime::TimeZone::ICal
