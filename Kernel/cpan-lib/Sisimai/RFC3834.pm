package Sisimai::RFC3834;
use v5.26;
use strict;
use warnings;

# http://tools.ietf.org/html/rfc3834
sub description { 'Detector for auto replied message' }
sub inquire {
    # Detect auto reply message as RFC3834
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.1.28
    my $class = shift;
    my $mhead = shift // return undef; return undef unless keys %$mhead;
    my $mbody = shift // return undef; return undef unless ref $mbody eq 'SCALAR';
    my $lower = {};

    my $markingsof = {'boundary' => '__SISIMAI_PSEUDO_BOUNDARY__'};
    my $lowerlabel = ['from', 'to', 'subject', 'auto-submitted', 'precedence', 'x-apple-action'];

    for my $e ( @$lowerlabel ) {
        # Set lower-cased value of each header related to auto-response
        next unless exists  $mhead->{ $e };
        $lower->{ $e } = lc $mhead->{ $e };
    }

    state $donotparse = {
        'from'    => ['root@', 'postmaster@', 'mailer-daemon@'],
        'to'      => ['root@'],
        'subject' => [
            'security information for', # sudo(1)
            'mail failure -',           # Exim
        ],
    };
    state $autoreply0 = {
        # http://www.iana.org/assignments/auto-submitted-keywords/auto-submitted-keywords.xhtml
        'auto-submitted' => ['auto-generated', 'auto-replied', 'auto-notified'],
        'precedence'     => ['auto_reply'],
        'subject'        => ['auto:', 'auto response:', 'automatic reply:', 'out of office:', 'out of the office:'],
        'x-apple-action' => ['vacation'],
    };
    state $subjectset = qr{\A(?>
         (?:.+?)?re:
        |auto(?:[ ]response):
        |automatic[ ]reply:
        |out[ ]of[ ]office:
        )
        [ ]*(.+)\z
    }x;
    state $suspending = [
        ["this email inbox", " is no longer in use."],
    ];

    my $leave = 0; DETECT_EXCLUSION_MESSAGE: for my $e ( keys %$donotparse ) {
        # Exclude message from root@
        next unless exists  $lower->{ $e };
        next unless grep { index($lower->{ $e }, $_) > -1 } $donotparse->{ $e }->@*;
        $leave = 1;
        last;
    }
    return undef if $leave;

    my $match = 0; DETECT_AUTO_REPLY_MESSAGE0: for my $e ( keys %$autoreply0 ) {
        # RFC3834 Auto-Submitted and other headers
        next unless exists  $lower->{ $e };
        next unless grep { index($lower->{ $e }, $_) == 0 } $autoreply0->{ $e }->@*;

        $match++;
        last;
    }
    return undef unless $match;

    require Sisimai::Eb;
    require Sisimai::Lhost;
    my $dscontents = [Sisimai::Lhost->DELIVERYSTATUS]; my $v = $dscontents->[-1];
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $maxmsgline = 5;     # (Integer) Max message length(lines)
    my $haveloaded = 0;     # (Integer) The number of lines loaded from message body
    my $blanklines = 0;     # (Integer) Counter for countinuous blank lines
    my $countuntil = 1;     # (Integer) Maximun value of blank lines in the body part

    RECIPIENT_ADDRESS: {
        # Try to get the address of the recipient
        for my $e ('reply-to', 'from', 'return-path') {
            # Get the recipient address
            next unless exists  $mhead->{ $e };

            $v->{'recipient'} = $mhead->{ $e };
            last;
        }

        if( $v->{'recipient'} ) {
            # Clean-up the recipient address
            $v->{'recipient'} = Sisimai::Address->s3s4($v->{'recipient'});
            $recipients++;
        }
    }
    return undef unless $recipients;

    if( $mhead->{'content-type'} ) {
        # Get the boundary string and set regular expression for matching with the boundary string.
        my $q = Sisimai::RFC2045->boundary($mhead->{'content-type'}, 0);
        $markingsof->{'boundary'} = $q if $q;
    }

    MESSAGE_BODY: {
        # Get vacation message
        for my $e ( split("\n", $$mbody) ) {
            # Read the first 5 lines except a blank line
            $countuntil += 1 if index($e, $markingsof->{'boundary'}) > -1;

            unless( length $e ) {
                # Check a blank line
                last if ++$blanklines > $countuntil;
                next;
            }
            next if rindex($e, ' ') < 0;
            next if index($e, 'Content-Type') == 0 || index($e, 'Content-Transfer') == 0;

            $v->{'diagnosis'} .= $e.' ';
            $haveloaded++;
            last if $haveloaded >= $maxmsgline;
        }
        $v->{'diagnosis'} ||= $mhead->{'subject'};
    }
    $v->{'reason'} = $Sisimai::Eb::ReAWAY;

    my $cv = lc $v->{'diagnosis'}; for my $e ( @$suspending ) {
        # Check that the auto-replied message indicates the "Suspend" reason or not.
        next unless Sisimai::String->aligned(\$cv, $e);
        $v->{'reason'} = $Sisimai::Eb::ReQUIT; last;
    }

    $v->{'date'}      = $mhead->{'date'};
    $v->{'status'}    = '';

    # Get the Subject header from the original message
    my $rfc822part = $lower->{'subject'} =~ $subjectset ? 'Subject: '.$1."\n" : '';
    return {"ds" => $dscontents, "rfc822" => $rfc822part};
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::RFC3834 - RFC3834 auto reply message detector

=head1 SYNOPSIS

    use Sisimai::RFC3834;

=head1 DESCRIPTION

C<Sisimai::RFC3834> is a class which called from called from only C<Sisimai::Message> when other
C<Sisimai::Lhost::*> modules did not detected a bounce reason.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> method returns the description string of this module.

    print Sisimai::RFC3834->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes an auto replied message and return results as an array reference. See
C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

