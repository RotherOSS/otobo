package Sisimai::Lhost::Domino;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;
use Encode;
use Encode::Guess; Encode::Guess->add_suspects(Sisimai::String->encodenames->@*);

sub description { 'HCL Domino' }
sub inquire {
    # Detect an error from HCL Domino (Formerly IBM Domino (Formerly Lotus Domino))
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @since v4.0.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    my $match = 0; $match ||= 1 if index($mhead->{'subject'}, 'DELIVERY FAILURE:') == 0;
                   $match ||= 1 if index($mhead->{'subject'}, 'DELIVERY_FAILURE:') == 0;
    return undef unless $match > 0;

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = ['Content-Type: message/rfc822'];
    state $startingof = {'message' => ['Your message']};
    state $messagesof = {
        $Sisimai::Eb::ReUSER => [
            'not listed in Domino Directory',
            'not listed in public Name & Address Book',
            'no se encuentra en el Directorio de Domino',
            "non répertorié dans l'annuaire Domino",
            'Domino ディレクトリには見つかりません',
        ],
    };

    require Sisimai::RFC1123;
    my $fieldtable = Sisimai::RFC1894->FIELDTABLE;
    my $permessage = {};    # (Hash) Store values of each Per-Message field
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS]; my $v = undef;
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $subjecttxt = '';    # (String) The value of Subject:
    my $p = '';

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if index($e, $startingof->{'message'}->[0]) == 0;
            next;
        }
        next if ($readcursor & $indicators->{'deliverystatus'}) == 0 || $e eq "";

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
            #   kijitora@example.net
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
            #   User some.name (kijitora@example.net) not listed in Domino Directory
            $v->{'diagnosis'} = $e;

        } else {
            if( exists $v->{'diagnosis'} && $v->{'diagnosis'} eq 'because:' ) {
                # Error message, continued from the line "because:"
                $v->{'diagnosis'} = $e;

            } elsif( index($e, '  Subject: ') == 0 ) {
                #   Subject: Nyaa
                $subjecttxt = substr($e, 11,); 

            } else {
                # There are some fields defined in RFC3464, try to match
                my $f = Sisimai::RFC1894->match($e); next if $f < 1;
                my $o = Sisimai::RFC1894->field($e); next unless $o;
                next if $o->[3] eq 'addr';

                if( $o->[3] eq 'code' ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'}      ||= $o->[1];
                    $v->{'diagnosis'} ||= $o->[2];

                } else {
                    # Other DSN fields defined in RFC3464
                    next unless exists $fieldtable->{ $o->[0] };
                    next if $o->[3] eq "host" && Sisimai::RFC1123->is_internethost($o->[2]) == 0;
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
            last if $e->{'diagnosis'} eq "" || Sisimai::String->is_8bit(\$e->{'diagnosis'}) == 0;

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

    return {"ds" => $dscontents, "rfc822" => $emailparts->[1]};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Domino - bounce mail decoder class for HCL Domino L<https://www.hcl-software.com/domino>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Domino;

=head1 DESCRIPTION

C<Sisimai::Lhost::Domino> decodes a bounce email which created by HCL Domino L<https://www.hcl-software.com/domino>.
Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Domino->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method decodes a bounced email and return results as a array reference.
See C<Sisimai::Message> for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

