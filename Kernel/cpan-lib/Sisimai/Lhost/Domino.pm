package Sisimai::Lhost::Domino;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;
use Sisimai::String;
use Encode;
use Encode::Guess; Encode::Guess->add_suspects(Sisimai::String->encodenames->@*);

sub description { 'IBM Domino Server' }
sub inquire {
    # Detect an error from IBM Domino
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.0.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    while(1) {
        $match ||= 1 if index($mhead->{'subject'}, 'DELIVERY FAILURE:') == 0;
        $match ||= 1 if index($mhead->{'subject'}, 'DELIVERY_FAILURE:') == 0;
        last;
    }
    return undef unless $match > 0;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = { 'message' => ['Your message'] };
    state $messagesof = {
        'userunknown' => [
            'not listed in Domino Directory',
            'not listed in public Name & Address Book',
            'no se encuentra en el Directorio de Domino',
            "non répertorié dans l'annuaire Domino",
            'Domino ディレクトリには見つかりません',
        ],
        'filtered'    => ['Cannot route mail to user'],
        'systemerror' => ['Several matches found in Domino Directory'],
    };

    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $permessage = {};    # (Hash) Store values of each Per-Message field
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $subjecttxt = '';    # (String) The value of Subject:
    my $v = undef;
    my $p = '';

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
            next;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};
        next unless length $e;

        # Your message
        #
        #   Subject: Test Bounce
        #
        # was not delivered to:
        #
        #   kijitora@example.net
        #
        # because:
        #
        #   User some.name (kijitora@example.net) not listed in Domino Directory
        #
        $v = $dscontents->[-1];
        if( $e eq 'was not delivered to:' ) {
            # was not delivered to:
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{'recipient'} ||= $e;
            $recipients++;

        } elsif( index($e, '  ') == 0 && index($e, '@') > -1 && index($e, ' ', 3) < 0 ) {
            # Continued from the line "was not delivered to:"
            #   kijitora@example.net
            $v->{'recipient'} = Sisimai::Address->s3s4(substr($e, 2,));

        } elsif( $e eq 'because:' ) {
            # because:
            $v->{'diagnosis'} = $e;

        } else {
            if( exists $v->{'diagnosis'} && $v->{'diagnosis'} eq 'because:' ) {
                # Error message, continued from the line "because:"
                $v->{'diagnosis'} = $e;

            } elsif( index($e, '  Subject: ') == 0 ) {
                #   Subject: Nyaa
                $subjecttxt = substr($e, 11,); 

            } elsif( my $f = Sisimai::RFC1894->match($e) ) {
                # There are some fields defined in RFC3464, try to match
                next unless my $o = Sisimai::RFC1894->field($e);
                next if $o->[-1] eq 'addr';

                if( $o->[-1] eq 'code' ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'}      ||= $o->[1];
                    $v->{'diagnosis'} ||= $o->[2];

                } else {
                    # Other DSN fields defined in RFC3464
                    next unless exists $fieldtable->{ $o->[0] };
                    $v->{ $fieldtable->{ $o->[0] } } = $o->[2];

                    next unless $f == 1;
                    $permessage->{ $fieldtable->{ $o->[0] } } = $o->[2];
                }
            }
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Check the utf8 flag and fix
        UTF8FLAG: while(1) {
            # Delete the utf8 flag because there are a string including some characters which have 
            # utf8 flag but utf8::is_utf8 returns false
            last unless length $e->{'diagnosis'};
            last unless Sisimai::String->is_8bit(\$e->{'diagnosis'});

            my $cv = $e->{'diagnosis'};
            my $ce = Encode::Guess->guess($cv);
            last unless ref $ce;

            $cv = Encode::encode_utf8($cv);
            $e->{'diagnosis'} = $cv;
            last;
        }

        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'recipient'} = Sisimai::Address->s3s4($e->{'recipient'});
        $e->{ $_ }      ||= $permessage->{ $_ } || '' for keys %$permessage;

        for my $r ( keys %$messagesof ) {
            # Check each regular expression of Domino error messages
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } $messagesof->{ $r }->@*;
            $e->{'reason'}   = $r;
            $e->{'status'} ||= Sisimai::SMTP::Status->code($r, 0) || '';
            last;
        }
    }

    # Set the value of $subjecttxt as a Subject if there is no original message in the bounce mail.
    $emailparts->[1] .= sprintf("Subject: %s\n", $subjecttxt) if index($emailparts->[1], "\nSubject:") < 0;

    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Domino - bounce mail parser class for IBM Domino Server.

=head1 SYNOPSIS

    use Sisimai::Lhost::Domino;

=head1 DESCRIPTION

Sisimai::Lhost::Domino parses a bounce email which created by IBM Domino Server. Methods in the module
are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Domino->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
