package PDF::API2::ViewerPreferences;

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp;
use PDF::API2::Basic::PDF::Utils;
use Scalar::Util qw(weaken);

our @CARP_NOT;

my @booleans = qw(HideToolbar HideMenubar HideWindowUI FitWindow CenterWindow
                  DisplayDocTitle PickTrayByPDFSize);

my @names = qw(NonFullScreenPageMode Direction Duplex PrintScaling
               ViewArea ViewClip PrintArea PrintClip);

=head1 NAME

PDF::API2::ViewerPreferences - How the PDF should be displayed or printed

=head1 METHODS

=over

=cut

sub _snake_case {
    my $name = shift();
    $name =~ s/^([A-Z]+)/lc($1)/e;
    $name =~ s/([A-Z]+)/'_' . lc($1)/ge;
    $name =~ s/pdfsize/pdf_size/;
    return $name;
}

sub _camel_case {
    my $name = shift();
    $name = ucfirst($name);
    $name =~ s/_([a-z]+)/ucfirst($1)/ge;
    $name =~ s/Ui$/UI/;
    $name =~ s/Pdf/PDF/;
    return $name;
}

=item $self = $class->new($pdf)

Creates a new ViewerPreferences object from a PDF::API2 object.

=cut

sub new {
    my ($class, $pdf) = @_;
    my $self = bless { pdf => $pdf }, $class;
    weaken $self->{'pdf'};
    return $self;
}

=item %preferences = $self->get_preferences()

Returns a hash containing all of the viewer preferences that are defined in the
PDF.

=cut

sub get_preferences {
    my $self = shift();
    my $prefs = $self->{'pdf'}->{'catalog'}->{'ViewerPreferences'};
    return unless $prefs;
    $prefs->realise();

    my %values;
    foreach my $pref (@booleans) {
        next unless $prefs->{$pref};
        $values{_snake_case($pref)} = $prefs->{$pref}->val() eq 'true' ? 1 : 0;
    }
    foreach my $pref (@names) {
        next unless $prefs->{$pref};
        if ($pref eq 'Direction') {
            $values{'direction'} = lc($prefs->{$pref}->val());
        }
        elsif ($pref eq 'Duplex') {
            my $value = $prefs->{$pref}->val();
            $value =~ s/Flip//;
            $value =~ s/Edge//;
            $values{'duplex'} = _snake_case($value);
        }
        elsif ($pref eq 'NonFullScreenPageMode') {
            my $value = _snake_case($prefs->{$pref}->val());
            $value =~ s/^use_//;
            $value = 'optional_content' if $value eq 'oc';
            $values{'non_full_screen_page_mode'} = $value;
        }
        else {
            $values{_snake_case($pref)} = _snake_case($prefs->{$pref}->val());
        }
    }
    if ($prefs->{'PrintPageRange'}) {
        my @ranges = map { $_->val() } @{$prefs->{'PrintPageRange'}};
        $values{'print_page_range'} = \@ranges;
    }
    if ($prefs->{'NumCopies'}) {
        $values{'num_copies'} = $prefs->{'NumCopies'}->val();
    }

    return %values;
}

=item $value = $self->get_preference($name)

Returns the value of the specified viewer preference if present, or C<undef> if
not.

=cut

sub get_preference {
    my ($self, $name) = @_;
    my %values = $self->get_preferences();
    return $values{$name};
}

=item $self->set_preferences(%values)

Sets one or more viewer preferences, as described in the preferences section
below.

=cut

sub _init_preferences {
    my $self = shift();
    if ($self->{'pdf'}->{'catalog'}->{'ViewerPreferences'}) {
        $self->{'pdf'}->{'catalog'}->{'ViewerPreferences'}->realise();
    }
    else {
        $self->{'pdf'}->{'catalog'}->{'ViewerPreferences'} = PDFDict();
    }
    $self->{'pdf'}->{'pdf'}->out_obj($self->{'pdf'}->{'catalog'});
    return $self->{'pdf'}->{'catalog'}->{'ViewerPreferences'};
}

sub set_preferences {
    my ($self, %values) = @_;
    my $prefs = $self->_init_preferences();
    local @CARP_NOT = qw(PDF::API2);
    foreach my $snake (keys %values) {
        my $camel = _camel_case($snake);
        if ($camel eq 'NonFullScreenPageMode') {
            my $value = $values{$snake};
            my $name = ($value eq 'none'             ? 'UseNone'     :
                        $value eq 'outlines'         ? 'UseOutlines' :
                        $value eq 'thumbnails'       ? 'UseThumbs'   :
                        $value eq 'optional_content' ? 'UseOC'       :
                        '');
            croak "Invalid value for $snake: $values{$snake}" unless $name;
            $prefs->{$camel} = PDFName($name);
        }
        elsif ($camel eq 'Direction') {
            my $name = $values{$snake};
            unless ($name =~ /^(?:L2R|R2L)$/i) {
                croak "Invalid value for $snake: $name";
            }
            $prefs->{$camel} = PDFName(uc $name);
        }
        elsif ($camel =~ /^(?:View|Print)(?:Area|Clip)$/) {
            my $name = ($values{$snake} eq 'media_box' ? 'MediaBox' :
                        $values{$snake} eq 'crop_box'  ? 'CropBox'  :
                        $values{$snake} eq 'bleed_box' ? 'BleedBox' :
                        $values{$snake} eq 'trim_box'  ? 'TrimBox'  :
                        $values{$snake} eq 'art_box'   ? 'ArtBox'   : '');
            croak "Invalid value for $snake: $name" unless $name;
            $prefs->{$camel} = PDFName($name);
        }
        elsif ($camel eq 'PrintScaling') {
            my $value = $values{$snake};
            my $name = ($value eq 'none'        ? 'None'       :
                        $value eq 'app_default' ? 'AppDefault' : '');
            croak "Invalid value for $snake: $name" unless $name;
            $prefs->{$camel} = PDFName($name);
        }
        elsif ($camel eq 'Duplex') {
            my $value = $values{$snake};
            my $name = ($value eq 'simplex'      ? 'Simplex'             :
                        $value eq 'duplex_short' ? 'DuplexFlipShortEdge' :
                        $value eq 'duplex_long'  ? 'DuplexFlipLongEdge'  : '');
            croak "Invalid value for $snake: $value" unless $name;
            $prefs->{$camel} = PDFName($name);
        }
        elsif ($camel eq 'PrintPageRange') {
            unless (ref($values{$snake}) eq 'ARRAY') {
                croak "The value for $snake must be a reference to an array";
            }
            my @range = @{$values{$snake}};
            unless (@range % 2 == 0) {
                croak "The value for $snake must contain pairs of page numbers";
            }
            if (join('', @range) =~ /\D/) {
                croak "The value for $snake may only contain page numbers";
            }
            $prefs->{$camel} = PDFArray(map { PDFNum($_) } @range);
        }
        elsif ($camel eq 'NumCopies') {
            unless ($values{$snake} =~ /^\d+$/) {
                croak "$snake: $values{$snake} is not an integer";
            }
            $prefs->{$camel} = PDFNum($values{$snake});
        }
        elsif (grep { $camel eq $_ } @booleans) {
            $prefs->{$camel} = PDFBool($values{$snake} ? 1 : 0);
        }
        else {
            croak "Unrecognized viewer preference '$snake'";
        }
    }
    return $self;
}

=back

=head1 PREFERENCES

Viewer Preferences describe how the document should be presented on screen or in
print.  Not all PDF viewers will respect these preferences.

Boolean preferences default to false and take (or return) 0 or 1 as arguments.

Bounding Box preferences take (or return) one of C<media_box>, C<crop_box>,
C<bleed_box>, C<trim_box>, or C<art_box>.

=over

=item hide_toolbar (boolean)

A flag specifying whether to hide the tool bars when the document is active.

=item hide_menubar (boolean)

A flag specifying whether to hide the menu bar when the document is active.

=item hide_window_ui (boolean)

A flag specifying whether to hide the user interface elements in the document's
window (such as scroll bars and navigation controls), leaving only the
document's contents displayed.

=item fit_window (boolean)

A flag specifying whether to resize the document's window to fit the size of the
first displayed page.

=item center_window (boolean)

A flag specifying whether to position the document's window in the center of the
screen.

=item display_doc_title (boolean)

A flag specifying whether the window's title bar should display the document
title taken from the Title entry of the document information directory.  If
false, the title bar should instead display the name of the PDF file containing
the document.

=item non_full_screen_page_mode (name)

The document's page mode, specifying how to display the document on exiting
full-screen mode.  Options are the same as C<page_mode> in L<PDF::API2> except
that the C<attachments> and C<full_screen> options aren't supported.

=item direction ('l2r' or 'r2l')

The predominant reading order for text (left-to-right or right-to-left).

This entry has no direct effect on the document's contents or page numbering but
may be used to determine the relative positioning of pages when displayed
side-by-side or printed n-up.

=item view_area (bounding box)

The name of the page boundary representing the area of a page that shall be
displayed when viewing the document on the screen.

=item view_clip (bounding box)

The name of the page boundary to which the contents of a page shall be clipped
when viewing the document on the screen.

=item print_area (bounding box)

The name of the page boundary representing the area of a page that shall be
rendered when printing the document.

=item print_clip (bounding box)

The name of the page boundary to which the contents of a page shall be clipped
when printing the document.

=item print_scaling ('none' or 'app_default')

The page scaling option that shall be selected when a print dialog is displayed
for this document.  C<none> represents no page scaling, and C<app_default>
represents the reader's default print scaling.

=item duplex ('simplex', 'duplex_short', or 'duplex_long')

The paper handling option that shall be used when printing the file from the
print dialog.  The duplex values represent whether the page should be flipped on
its short edge or long edge, respectively.

=item pick_tray_by_pdf_size (boolean)

A flag specifying whether the PDF page size shall be used to select the input
paper tray.  This setting influences only the preset values used to populate the
print dialog presented by the reader.

=item print_page_rage (an array of integer pairs)

The page numbers used to initialize the print dialog box when the file is
printed.  The array shall contain an even number of integers to be interpreted
in pairs, with each pair specifying the first and last pages in a sub-range of
pages to be printed.  The first page of the PDF file shall be denoted by 1.

=item num_copies (integer)

The number of copies that shall be printed when the print dialog is opened for
this file.

=back

=cut

1;
