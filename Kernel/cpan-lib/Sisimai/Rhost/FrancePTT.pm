package Sisimai::Rhost::FrancePTT;
use v5.26;
use strict;
use warnings;

sub find {
    # Detect bounce reason from Orange and La Poste
    # @param    [Sisimai::Fact] argvs   Decdoed email object
    # @return   [String]                The bounce reason for Orange, La Poste
    # @see
    # - Orange Postmaster Page: https://postmaster.orange.fr/index.html
    # - https://www.postmastery.com/orange-postmaster-smtp-error-codes-ofr/
    # - https://smtpfieldmanual.com/provider/orange
    # @since v4.22.3
    my $class = shift;
    my $argvs = shift // return ""; return "" unless $argvs->{'diagnosticcode'};

    require Sisimai::Eb;
    state $errorcodes = {
        # - Your sending IP is listed on Abusix RBL
        #   Please visit: https://lookup.abusix.com/search?q=$IP
        "100" => $Sisimai::Eb::ReBLOC,

        # - Your sending IP is listed by SpamHaus RBL
        #   Please visit: https://check.spamhaus.org/listed/?searchterm=$IP
        # - 550 5.7.1 Service unavailable; client [192.0.2.1] blocked using Spamhaus
        #   Les emails envoyes vers la messagerie Laposte.net ont ete bloques par nos services.
        #   Afin de regulariser votre situation, nous vous invitons a cliquer sur le lien ci-dessous
        #   et a suivre la procedure.
        # - The emails sent to the mail host Laposte.net were blocked by our services. To regularize
        #   your situation please click on the link below and follow the procedure
        #   https://www.spamhaus.org/lookup/ LPNAAA_101 (in reply to RCPT TO command))
        '101' => $Sisimai::Eb::ReBLOC,

        # - Your sending IP is listed by Cloudmark RBL
        #   Please visit: https://csi.cloudmark.com/reset-request/?ip=$IP#
        # - 550 mwinf5c04 ME Adresse IP source bloquee pour incident de spam.
        # - Client host blocked for spamming issues. OFR006_102 Ref http://csi.cloudmark.com ...
        # - 550 5.5.0 Les emails envoyes vers la messagerie Laposte.net ont ete bloques par nos
        #   services. Afin de regulariser votre situation, nous vous invitons a cliquer sur le lien
        #   ci-dessous et a suivre la procedure.
        # - The emails sent to the mail host Laposte.net were blocked by our services. To regularize
        #   your situation please click on the link below and follow the procedure
        #   https://senderscore.org/blacklistlookup/  LPN007_102
        '102' => $Sisimai::Eb::ReBLOC,

        # - Your sending IP has been blacklisted by Orange
        #   Please contact Orange by using our contact form and select option
        #   "Un problème d'envoi d'emails vers les adresses Orange ou Wanadoo (deliverability issue)"
        # - 550 mwinf5c10 ME Service refuse. Veuillez essayer plus tard.
        # - Service refused, please try later. OFR006_103 192.0.2.1 [103]
        '103' => $Sisimai::Eb::ReBLOC,

        # - 421 mwinf5c79 ME Trop de connexions, veuillez verifier votre configuration.
        # - Too many connections, slow down. OFR005_104 [104]
        # - Too many connections, slow down. LPN105_104
        '104' => $Sisimai::Eb::ReRATE,

        # - Your IP address is missing a DNS PTR record, it also called a rDNS (reverse DNS)
        #   Please set up a valid DNS PTR record for your IP address that point to your domain,
        #   It's important that the sending IP address must match the IP address of the hostname
        #   defined in the PTR record
        # - Service refused, please try later. LPN006_107
        "107" => $Sisimai::Eb::ReQPTR,

        # - You are sending too many messages per SMTP connection
        #   Please reduce the number of messages per connection, recommended value is 100
        #   messages per connections
        # - Veuillez essayer plus tard. LPN003_109
        "109" => $Sisimai::Eb::ReRATE,

        # - Invalid HELO/EHLO
        #   Please set up a valid HELO/EHLO, it must be fully qualified domain name (FQDN) and
        #   should resolve (DNS record needed). E.g.: "mail.yourdomain.com"
        # - Veuillez essayer plus tard. OFR004_201
        "201" => $Sisimai::Eb::ReBLOC,
        "20X" => $Sisimai::Eb::ReBLOC,

        # - Sender's Domain name SPF Error
        #   Please verify your mail from domain name DNS/TXT configuration for your SPF
        #   configuration. Please visit https://mxtoolbox.com/supertool3?action=spf:$YOUR_DOMAIN
        #   to check your domain. (replace $YOUR_DOMAIN by your sender domain name)
        #   Please note:
        #     If you have changed your DNS record recently, please let DNS caches expire (TTL)
        "39X" => $Sisimai::Eb::ReAUTH,

        # - Sender's Domain DNS Error
        #   Please verify your mail from domain name DNS configuration. Your domain name must
        #   have valid A or MX records. You can check your DNS configuration on MxToolBox
        #   Please note:
        #     If you have changed your DNS record recently, please let DNS caches expire (TTL)
        # - 5.0.1 Emetteur invalide. Invalid Sender. LPN105_405
        # - 501 5.1.0 Emetteur invalide. Invalid Sender. OFR004_405 [405] (in reply to MAIL FROM command))
        '405' => $Sisimai::Eb::ReFROM,

        # - Your Sender has been rejected
        #   Please contact Orange by using our contact form and select option
        #   "Un problème d'envoi d'emails vers les adresses Orange ou Wanadoo (deliverability issue)"
        "406" => $Sisimai::Eb::ReFROM,

        # - User doesn't exist here
        #   Please remove this email address from your distribution list, it does not exist
        # - 550 5.1.1 Adresse d au moins un destinataire invalide.
        # - Invalid recipient. LPN416 (in reply to RCPT TO command)
        # - Invalid recipient. OFR_416 [416] (in reply to RCPT TO command)
        '416' => $Sisimai::Eb::ReUSER,

        # - 552 5.1.1 Boite du destinataire pleine.
        # - Recipient overquota. OFR_417 [417] (in reply to RCPT TO command))
        '417' => $Sisimai::Eb::ReFULL,

        # - 550 5.5.0 Boite du destinataire archivee.
        # - Archived recipient. LPN007_420 (in reply to RCPT TO command)
        '420' => $Sisimai::Eb::ReQUIT,

        # - Your sender domain name has been blacklisted
        #   Your sender domain name has been blacklisted by Abusix OR SpamHaus, Please visit:
        #   - https://lookup.abusix.com/search?q=$YOUR_DOMAIN 
        #   - https://check.spamhaus.org/listed/?searchterm=$YOUR_DOMAIN
        "425" => $Sisimai::Eb::ReFROM,

        # - 550 5.5.0 Le compte du destinataire est bloque. The recipient account isblocked.
        #   LPN007_426 (in reply to RCPT TO command)
        '426' => $Sisimai::Eb::ReQUIT,

        # - 421 4.2.0 Service refuse. Veuillez essayer plus tard. Service refused, please try later.
        #   OFR005_505 [505] (in reply to end of DATA command)
        # - 421 4.2.1 Service refuse. Veuillez essayer plus tard. Service refused, please try later.
        #   LPN007_505 (in reply to end of DATA command)
        '505' => $Sisimai::Eb::RePROC,

        # - Your message has been blocked by Orange, suspected spam
        #   Please contact Orange by using our contact form and select option
        #   "Un problème d'envoi d'emails vers les adresses Orange ou Wanadoo (deliverability issue)"
        # - Mail rejete. Mail rejected. OFR_506 [506]
        '506' => $Sisimai::Eb::ReSPAM,

        # - 550 5.5.0 Service refuse. Veuillez essayer plus tard. service refused, please try later.
        #   LPN005_510 (in reply to end of DATA command)
        '510' => $Sisimai::Eb::ReBLOC,

        # - DMARC authentication failed, message rejected as defined by your DMARC policy
        #   Please check your SPF/DKIM/DMARC configuration. Please visit MxToolBox DMARC to
        #   check your domain configuration
        "515" => $Sisimai::Eb::ReAUTH,

        # - 571 5.7.1 Message refused, DMARC verification Failed.
        # - Message refuse, verification DMARC en echec LPN007_517
        '517' => $Sisimai::Eb::ReAUTH,

        # - The sending IP address is not authorized to send messages for your domain as defined
        #   in the sender's Domain name SPF configuration (DNS/TXT)
        #   Please verify your mail from domain name DNS/TXT configuration for your SPF configuration.
        #   Please visit https://mxtoolbox.com/supertool3?action=spf:$YOUR_DOMAIN to check your
        #   domain. (replace $YOUR_DOMAIN by your sender domain name)
        "519" => $Sisimai::Eb::ReAUTH,

        # - Due to bad behavior you have been rate limited, please try again later
        #   Due to inappropriate behavior, you have been rate limited. Please check what you
        #   are trying to send
        # - 421 mwinf5c77 ME Service refuse. Veuillez essayer plus tard. Service refused, please try
        #   later. OFR_999 [999]
        "99X" => $Sisimai::Eb::ReRATE,

        # Other undocumented or old error codes
        "105" => "",                   # Veuillez essayer plus tard.
        "108" => "",                   # service refused, please try later. LPN001_108
        "305" => $Sisimai::Eb::ReSAFE, # 550 5.7.0 Code d'authentification invalide OFR_305
        "401" => $Sisimai::Eb::ReAUTH, # 550 5.5.0 SPF: *** is not allowed to send mail. LPN004_401
        "402" => $Sisimai::Eb::ReSAFE, # 550 5.5.0 Authentification requise. Authentication Required. LPN105_402
        "403" => $Sisimai::Eb::ReFROM, # 5.0.1 Emetteur invalide. Invalid Sender.
        "415" => $Sisimai::Eb::ReFROM, # Emetteur invalide. Invalid Sender. OFR_415
        "421" => $Sisimai::Eb::ReFROM, # 5.5.3 Mail from not owned by user. LPN105_421.
        "423" => "",                   # Service refused, please try later. LPN105_423
        "424" => "",                   # Veuillez essayer plus tard. LPN105_424
        "513" => "",                   # Mail rejete. Mail rejected. OUK_513
        "514" => $Sisimai::Eb::ReSIZE, # Taille limite du message atteinte
        "630" => $Sisimai::Eb::ReWONT, # 554 5.7.1 Client host rejected LPN000_630
    };
    state $messagesof = {
        $Sisimai::Eb::ReAUTH => [
            # - 421 smtp.orange.fr [192.0.2.1] Emetteur invalide, Veuillez verifier la configuration
            #   SPF/DNS de votre nom de domaine. Invalid Sender. SPF check failed, please verify the
            #   SPF/DNS configuration for your domain name.
            'spf/dns de votre nom de domaine',
        ],
    };
    my $issuedcode = $argvs->{'diagnosticcode'};
    my $reasontext = '';

    if( $issuedcode =~ /\b(LPN|LPNAAA|OFR|OUK)(_[0-9]{3}|[0-9]{3}[-_][0-9]{3})\b/i ) {
        # OUK_513, LPN105-104, OFR102-104, ofr_506
        my $v = sprintf("%03d", substr($1.$2, -3, 3));
        my $x = $v; $x =~ s/.\z/X/;
        $reasontext = $errorcodes->{ $v } || $errorcodes->{ $x };
    }
    return $reasontext if length $reasontext;

    $issuedcode = lc $issuedcode;
    for my $e ( keys %$messagesof ) {
        # Try to find the error message matches with the given error message string
        next unless grep { index($issuedcode, $_) > -1 } $messagesof->{ $e }->@*;
        $reasontext = $e;
        last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::FrancePTT - Detect the bounce reason returned from Orange and La Poste.

=head1 SYNOPSIS

    use Sisimai::Rhost::FrancePTT;

=head1 DESCRIPTION

C<Sisimai::Rhost::FrancePTT> detects the bounce reason from the content of C<Sisimai::Fact> object
as an argument of C<find()> method when the value of C<rhost> of the object end with C<laposte.net>
or C<orange.fr>. This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2021,2023-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

