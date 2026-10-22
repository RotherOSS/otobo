package Sisimai::Mail::Mbox;
use v5.26;
use strict;
use warnings;
use File::Basename qw(basename dirname);
use IO::File;
use Class::Accessor::Lite (
    'new' => 0,
    'ro'  => [
        'dir',      # [String]  Directory name of the mbox
        'file',     # [String]  File name of the mbox
        'path',     # [String]  Path to mbox
        'size',     # [Integer] File size of the mbox
    ],
    'rw'  => [
        'offset',   # [Integer]  Offset position for seeking
        'handle',   # [IO::File] File handle
    ]
);

sub new {
    # Constructor of Sisimai::Mail::Mbox
    # @param    [String] argv1          Path to mbox
    # @return   [Sisimai::Mail::Mbox]   Object
    #           [Undef]                 is not a file or does not exist
    my $class = shift;
    my $argv1 = shift // return undef; return undef unless -f $argv1;
    my $param = {'offset' => 0};

    $param->{'dir'}    = File::Basename::dirname $argv1;
    $param->{'path'}   = $argv1;
    $param->{'size'}   = -s $argv1;
    $param->{'file'}   = File::Basename::basename $argv1;
    $param->{'handle'} = ref $argv1 ? $argv1 : IO::File->new($argv1, 'r');
    binmode $param->{'handle'};

    return bless($param, __PACKAGE__);
}

sub read {
    # Mbox reader, works as an iterator.
    # @return   [String] Contents of mbox
    my $self       = shift; return "" unless defined $self->{'path'};
    my $seekoffset = $self->{'offset'} // 0;
    my $filehandle = $self->{'handle'};
    my $readbuffer = '';

    unless( ref $self->{'path'} ) {
        # "path" is not IO::File object
        return "" unless -f $self->{'path'};
        return "" unless -T $self->{'path'};
    }
    return "" unless $self->{'offset'} < $self->{'size'};

    eval {
        $seekoffset = 0 if $seekoffset < 0;
        seek($filehandle, $seekoffset, 0);

        while( my $r = <$filehandle> ) {
            # Read the UNIX mbox file from 'From ' to the next 'From '
            last if( $readbuffer && substr($r, 0, 5) eq 'From ' );
            $readbuffer .= $r;
        }
        $seekoffset += length $readbuffer;
        $self->{'offset'} = $seekoffset;
        $filehandle->close unless $seekoffset < $self->{'size'};
    };
    return $readbuffer;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::Mail::Mbox - Mailbox reader

=head1 SYNOPSIS

    use Sisimai::Mail::Mbox;
    my $mailbox = Sisimai::Mail::Mbox->new('/var/spool/mail/root');
    while( my $r = $mailbox->read ) {
        print $r;   # print contents of each mail in mbox
    }

=head1 DESCRIPTION

C<Sisimai::Mail::Mbox> is a mailbox file (UNIX mbox) reader.

=head1 CLASS METHODS

=head2 C<B<new(I<path to mbox>)>>

C<new()> method is a constructor of C<Sisimai::Mail::Mbox>

    my $mailbox = Sisimai::Mail::Mbox->new('/var/mail/root');

=head1 INSTANCE METHODS

=head2 C<B<dir()>>

C<dir()> method returns the directory name of the UNIX mbox

    print $mailbox->dir;   # /var/mail

=head2 C<B<path()>>

C<path()> meethod returns the path to the mbox.

    print $mailbox->path;   # /var/mail/root

=head2 C<B<file()>>

C<file()> method returns the file name of the mbox.

    print $mailbox->file;   # root

=head2 C<B<size()>>

C<size()> method returns the file size of the mbox.

    print $mailbox->size;   # 94515

=head2 C<B<offset()>>

C<offset()> method returns the offset position for seeking the mbox. The value of C<"offset"> is a
bytes which have already read.

    print $mailbox->offset;   # 0

=head2 C<B<handle()>>

C<handle()> method returns file handle object C<IO::File> of the mbox.

    $mailbox->handle->close;

=head2 C<B<read()>>

C<read()> method works as an iterator for reading each email in the mbox.

    my $mailbox = Sisimai::Mail->new('/var/mail/neko');
    while( my $r = $mailbox->read ) {
        print $r;   # print each email in /var/mail/neko
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2019,2021,2024,2025 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

