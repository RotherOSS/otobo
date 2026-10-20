package Sisimai::Lhost::Exchange2007;
use parent 'Sisimai::Lhost';
use feature ':5.10';
use strict;
use warnings;

sub description { 'Microsoft Exchange Server 2007' }
sub inquire {
    # Detect an error from Microsoft Exchange Server 2007
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to parse or the arguments are missing
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # Content-Language: en-US, fr-FR
    $match ||= 1 if index($mhead->{'subject'}, 'Undeliverable')    == 0;
    $match ||= 1 if index($mhead->{'subject'}, 'Non_remis_')       == 0;
    $match ||= 1 if index($mhead->{'subject'}, 'Non recapitabile') == 0;
    return undef unless $match > 0;

    return undef unless defined $mhead->{'content-language'};
    $match += 1 if length $mhead->{'content-language'} == 2; # JP
    $match += 1 if length $mhead->{'content-language'} == 5; # ja-JP
    return undef unless $match > 1;

    # These headers exist only a bounce mail from Office365
    return undef if $mhead->{'x-ms-exchange-crosstenant-originalarrivaltime'};
    return undef if $mhead->{'x-ms-exchange-crosstenant-fromentityheader'};

    state $indicators = __PACKAGE__->INDICATORS;
    state $boundaries = [
        'Original message headers:',                # en-US
        "tes de message d'origine :",               # fr-FR/En-têtes de message d'origine
        'Intestazioni originali del messaggio:',    # it-CH
    ];
    state $markingsof = {
        'message' => [
            'Diagnostic information for administrators:',           # en-US
            'Informations de diagnostic pour les administrateurs',  # fr-FR
            'Informazioni di diagnostica per gli amministratori',   # it-CH
        ],
        'error'   => [' RESOLVER.', ' QUEUE.'],
        'rhost'   => [
            'Generating server',        # en-US
            'Serveur de g',             # fr-FR/Serveur de g辿n辿ration
            'Server di generazione',    # it-CH
        ],
    };
    state $ndrsubject = {
        'SMTPSEND.DNS.NonExistentDomain'=> 'hostunknown',   # 554 5.4.4 SMTPSEND.DNS.NonExistentDomain
        'SMTPSEND.DNS.MxLoopback'       => 'networkerror',  # 554 5.4.4 SMTPSEND.DNS.MxLoopback
        'RESOLVER.ADR.BadPrimary'       => 'systemerror',   # 550 5.2.0 RESOLVER.ADR.BadPrimary
        'RESOLVER.ADR.RecipNotFound'    => 'userunknown',   # 550 5.1.1 RESOLVER.ADR.RecipNotFound
        'RESOLVER.ADR.ExRecipNotFound'  => 'userunknown',   # 550 5.1.1 RESOLVER.ADR.ExRecipNotFound
        'RESOLVER.ADR.RecipLimit'       => 'toomanyconn',   # 550 5.5.3 RESOLVER.ADR.RecipLimit
        'RESOLVER.ADR.InvalidInSmtp'    => 'systemerror',   # 550 5.1.0 RESOLVER.ADR.InvalidInSmtp
        'RESOLVER.ADR.Ambiguous'        => 'systemerror',   # 550 5.1.4 RESOLVER.ADR.Ambiguous, 420 4.2.0 RESOLVER.ADR.Ambiguous
        'RESOLVER.RST.AuthRequired'     => 'securityerror', # 550 5.7.1 RESOLVER.RST.AuthRequired
        'RESOLVER.RST.NotAuthorized'    => 'rejected',      # 550 5.7.1 RESOLVER.RST.NotAuthorized
        'RESOLVER.RST.RecipSizeLimit'   => 'mesgtoobig',    # 550 5.2.3 RESOLVER.RST.RecipSizeLimit
        'QUEUE.Expired'                 => 'expired',       # 550 4.4.7 QUEUE.Expired
    };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $emailparts = Sisimai::RFC5322->part($mbody, $boundaries);
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $connvalues = 0;     # (Integer) Flag, 1 if all the value of $connheader have been set
    my $connheader = {
        'rhost' => '',      # The value of Reporting-MTA header or "Generating Server:"
    };
    my $v = undef;

    for my $e ( split("\n", $emailparts->[0]) ) {
        # Read error messages and delivery status lines from the head of the email to the previous
        # line of the beginning of the original message.
        unless( $readcursor ) {
            # Beginning of the bounce message or message/delivery-status part
            $readcursor |= $indicators->{'deliverystatus'} if grep { index($e, $_) == 0 } $markingsof->{'message'}->@*;
            next;
        }
        next unless $readcursor & $indicators->{'deliverystatus'};

        if( $connvalues == scalar(keys %$connheader) ) {
            # Diagnostic information for administrators:
            #
            # Generating server: mta2.neko.example.jp
            #
            # kijitora@example.jp
            # #550 5.1.1 RESOLVER.ADR.RecipNotFound; not found ##
            #
            # Original message headers:
            $v = $dscontents->[-1];

            if( index($e, ' ') < 0 && index($e, '@') > 1 ) {
                # kijitora@example.jp
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = Sisimai::Address->s3s4($e);
                $recipients++;

            } else {
                my $cr = Sisimai::SMTP::Reply->find($e)  || '';
                my $cs = Sisimai::SMTP::Status->find($e) || '';
                if( $cr || $cs ) {
                    # #550 5.1.1 RESOLVER.ADR.RecipNotFound; not found ##
                    # #550 5.2.3 RESOLVER.RST.RecipSizeLimit; message too large for this recipient ##
                    # Remote Server returned '550 5.1.1 RESOLVER.ADR.RecipNotFound; not found'
                    # 3/09/2016 8:05:56 PM - Remote Server at mydomain.com (10.1.1.3) returned '550 4.4.7 QUEUE.Expired; message expired'
                    $v->{'replycode'} = $cr;
                    $v->{'status'}    = $cs;
                    $v->{'diagnosis'} = $e;

                } else {
                    # Continued line of error messages
                    next unless $v->{'diagnosis'};
                    next unless substr($v->{'diagnosis'}, -1, 1) eq '=';
                    substr($v->{'diagnosis'}, -1, 1, $e);
                }
            }
        } else {
            # Diagnostic information for administrators:
            #
            # Generating server: mta22.neko.example.org
            next unless grep { index($e, $_) == 0 } $markingsof->{'rhost'}->@*;
            next if $connheader->{'rhost'};
            $connheader->{'rhost'} = substr($e, index($e, ':') + 1,);
            $connvalues++;
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        my $p = -1;

        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        for my $q ( $markingsof->{'error'}->@* ) {
        # Find an error message, get an error code
            $p = index($e->{'diagnosis'}, $q);
            last if $p > -1;
        }
        next unless $p > 0;

        # #550 5.1.1 RESOLVER.ADR.RecipNotFound; not found ##
        my $f = substr($e->{'diagnosis'}, $p + 1, index($e->{'diagnosis'}, ';') - $p - 1);
        for my $r ( keys %$ndrsubject ) {
            # Try to match with error subject strings
            next unless $f eq $r;
            $e->{'reason'} = $ndrsubject->{ $r };
            last;
        }
    }
    return { 'ds' => $dscontents, 'rfc822' => $emailparts->[1] };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::Exchange2007 - bounce mail parser class for C<Microsft Exchange Server 2007>.

=head1 SYNOPSIS

    use Sisimai::Lhost::Exchange2007;

=head1 DESCRIPTION

Sisimai::Lhost::Exchange2007 parses a bounce email which created by C<Microsoft Exchange Server 2007>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::Exchange2007->description;

=head2 C<B<inquire(I<header data>, I<reference to body string>)>>

C<inquire()> method parses a bounced email and return results as a array reference. See Sisimai::Message
for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2021,2023 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
