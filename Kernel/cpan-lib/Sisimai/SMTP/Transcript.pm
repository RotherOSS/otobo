package Sisimai::SMTP::Transcript;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;
use Sisimai::SMTP::Reply;
use Sisimai::SMTP::Status;
use Sisimai::SMTP::Command;

sub rise {
    # Decode the transcript of the SMTP session and makes the structured data
    # @param    [String] argv0  A transcript text MTA returned
    # @param    [String] argv1  A label string of a SMTP client
    # @param    [String] argv2  A label string of a SMTP server
    # @return   [Array]         Structured data
    # @return   [undef]         Failed to decode or the 1st argument is missing
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift // return undef;
    my $argv1 = shift // '>>>'; # Label for an SMTP Client
    my $argv2 = shift // '<<<'; # Label for an SMTP Server

    # 1. Replace label strings of SMTP client/server at the each line
    $argv0 =~ s/^[ ]+$argv1\s+/>>> /gm; return undef unless index($argv0, '>>> ') > -1;
    $argv0 =~ s/^[ ]+$argv2\s+/<<< /gm; return undef unless index($argv0, '<<< ') > -1;

    # 2. Remove strings until the first '<<<' or '>>>'
    my $esmtp = [];
    my $table = sub {
        return {
            'command'   => undef,   # SMTP command
            'argument'  => '',      # An argument of each SMTP command sent from a client
            'parameter' => {},      # Parameter pairs of the SMTP command
            'response'  => {        # A Response from an SMTP server
                'reply'  => '',     # - SMTP reply code such as 550
                'status' => '',     # - SMTP status such as 5.1.1
                'text'   => [],     # - Response text lines
            }
        };
    };

    my $cx = undef;                 # Current session for $esmtp
    my $p1 = index($argv0, '>>>');  # Sent command
    my $p2 = index($argv0, '<<<');  # Server response
    if( $p2 < $p1 ) {
        # An SMTP server response starting with '<<<' is the first
        push @$esmtp, $table->();
        $cx = $esmtp->[-1];
        $cx->{'command'} = $Sisimai::Eb::CeCONN;
        $argv0 = substr($argv0, $p2,) if $p2 > -1;

    } else {
        # An SMTP command starting with '>>>' is the first
        $argv0 = substr($argv0, $p1,) if $p1 > -1;
    }

    # 3. Remove unused lines, concatenate folded lines
    $argv0 = substr($argv0, 0, index($argv0, "\n\n") - 1); # Remove strings from the first blank line to the tail
    $argv0 =~ s/\n[ ]+/ /g;                                # Concatenate folded lines to each previous line

    for my $e ( split("\n", $argv0) ) {
        # 4. Read each SMTP command and server response
        if( index($e, '>>> ') == 0 ) {
            # SMTP client sent a command ">>> SMTP-command arguments"
            my $thecommand = Sisimai::SMTP::Command->find($e) || next;
            my $commandarg = Sisimai::String->sweep(substr($e, index($e, $thecommand) + length($thecommand),));
            my $parameters = '';

            push @$esmtp, $table->();
            $cx = $esmtp->[-1];
            $cx->{'command'} = uc $thecommand;

            if( $thecommand eq $Sisimai::Eb::CeMAIL || $thecommand eq $Sisimai::Eb::CeRCPT || $thecommand eq $Sisimai::Eb::CeXFWD ) {
                # MAIL or RCPT
                if( index($commandarg, 'FROM:') == 0 || index($commandarg, 'TO:') == 0 ) {
                    # >>> MAIL FROM: <neko@example.com> SIZE=65535
                    # >>> RCPT TO: <kijitora@example.org>
                    my $p4 = index($commandarg, '<');
                    my $p5 = index($commandarg, '>');
                    $cx->{'argument'} = substr($commandarg, $p4 + 1, $p5 - $p4 - 1);
                    $parameters = substr($commandarg, $p5 + 1,);

                } else {
                    # >>> XFORWARD NAME=neko2-nyaan3.y.example.co.jp ADDR=230.0.113.2 PORT=53672
                    # <<< 250 2.0.0 Ok
                    # >>> XFORWARD PROTO=SMTP HELO=neko2-nyaan3.y.example.co.jp IDENT=2LYC6642BLzFK3MM SOURCE=REMOTE
                    # <<< 250 2.0.0 Ok
                    $parameters = $commandarg;
                    $commandarg = '';
                }

                for my $f ( split(" ", $parameters) ) {
                    # SIZE=22022, PROTO=SMTP, and so on
                    next if index($f, '=') < 1 || length $f < 3;

                    my @ee = (split('=', $f)); next unless scalar @ee == 2;
                    $cx->{'parameter'}->{ lc $ee[0] } = $ee[1];
                }
            } else {
                # HELO, EHLO, AUTH, DATA, QUIT or Other SMTP command
                $cx->{'argument'} = $commandarg;
            }
        } else {
            # SMTP server sent a response "<<< response text"
            my $p3 = index($e, '<<< '); next unless $p3 == 0; substr($e, $p3, 4, '');

            $cx->{'response'}->{'reply'}  = Sisimai::SMTP::Reply->find($e)  || '';
            $cx->{'response'}->{'status'} = Sisimai::SMTP::Status->find($e) || '';
            push $cx->{'response'}->{'text'}->@*, $e;
        }
    }
    return undef unless scalar @$esmtp;
    return $esmtp;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::SMTP::Transcript - Transcript of the SMTP session decoder

=head1 SYNOPSIS

    use Sisimai::SMTP::Transcript;
    my $v = Sisimai::SMTP::Transcript->rise($transcript, 'In:' 'Out:')

=head1 DESCRIPTION

C<Sisimai::SMTP::Transcript> provides a decoding method for converting the transcript of the SMTP
session to the structured data.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2022-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

