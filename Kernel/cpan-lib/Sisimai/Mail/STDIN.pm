package Sisimai::Mail::STDIN;
use v5.26;
use strict;
use warnings;
use IO::Handle;
use Class::Accessor::Lite (
    'new' => 0,
    'ro'  => [
        'path',     # [String]  Fixed string "<STDIN>"
        'size',     # [Integer] Data size which has been read
    ],
    'rw'  => [
        'offset',   # [Integer]  The number of emails which have been read
        'handle',   # [IO::File] File handle
    ]
);

sub new {
    # Constructor of Sisimai::Mail::STDIN
    # @return   [Sisimai::Mail::STDIN] Object
    my $class = shift;
    my $param = {
        'path'   => '<STDIN>',
        'size'   => 0,
        'offset' => 0,
        'handle' => IO::Handle->new->fdopen(fileno(STDIN), 'r'),
    };
    return bless($param, __PACKAGE__);
}

sub read {
    # Mbox reader, works as an iterator.
    # @return   [String] Contents of mbox
    my $self       = shift; return "" unless -T $self->{'handle'};
    my $readhandle = $self->{'handle'};
    my $readbuffer = '';
    eval {
        $readhandle = $self->{'handle'}->fdopen(fileno(STDIN), 'r') unless eof $readhandle;

        while( my $r = <$readhandle> ) {
            # Read an email from the mailbox file
            last if( $readbuffer && substr($r, 0, 5) eq 'From ' );
            $readbuffer .= $r;
        }
    };
    $self->{'size'}   += length $readbuffer;
    $self->{'offset'} += 1;
    return $readbuffer;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::Mail::STDIN - Mailbox reader

=head1 SYNOPSIS

    use Sisimai::Mail::STDIN;
    my $mailbox = Sisimai::Mail::STDIN->new();
    while( my $r = $mailbox->read ) {
        print $r;   # print data read from STDIN
    }

=head1 DESCRIPTION

C<Sisimai::Mail::STDIN> read email data from Standard-In

=head1 CLASS METHODS

=head2 C<B<new()>>

C<new()> method is a constructor of C<Sisimai::Mail::STDIN>

    my $mailbox = Sisimai::Mail::STDIN->new();

=head1 INSTANCE METHODS

=head2 C<B<path()>>

C<path()> metehod returns a fixed string C<"<STDIN>">

    print $mailbox->path;   # "<STDIN>"

=head2 C<B<size()>>

C<size()> method returns the data size which has been read

    print $mailbox->size;   # 2202

=head2 C<B<offset()>>

C<offset()> method returns the offset position for seeking the mbox. The value of C<"offset"> is a
bytes which have already read.

    print $mailbox->offset;   # 0

=head2 C<B<handle()>>

C<handle()> method returns file handle object C<IO::Handle> of the mbox.

    $mailbox->handle;

=head2 C<B<read()>>

C<read()> method works as an iterator for reading each email in the mbox.

    my $mailbox = Sisimai::Mail->new();
    while( my $r = $mailbox->read ) {
        print $r;   # print data read from STDIN
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018-2021,2024,2025 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

