package Sisimai::Lhost::AmazonSES;
use parent 'Sisimai::Lhost';
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

# ---------------------------------------------------------------------------------------------
# "notificationType": "Bounce"
# https://docs.aws.amazon.com/ses/latest/dg/notification-contents.html#bounce-object
#
# Bounce types
#   The bounce object contains a bounce type of Undetermined, Permanent, or Transient. The
#   Permanent and Transient bounce types can also contain one of several bounce subtypes.
#
#   When you receive a bounce notification with a bounce type of Transient, you might be
#   able to send email to that recipient in the future if the issue that caused the message
#   to bounce is resolved.
#
#   When you receive a bounce notification with a bounce type of Permanent, it's unlikely
#   that you'll be able to send email to that recipient in the future. For this reason, you
#   should immediately remove the recipient whose address produced the bounce from your
#   mailing lists.
#
# "bounceType"/"bounceSubType" "Desription"
# Undetermined/Undetermined -- The bounce message didn't contain enough information for
#                              Amazon SES to determine the reason for the bounce.
#
# Permanent/General ---------- When you receive this type of bounce notification, you should
#                              immediately remove the recipient's email address from your
#                              mailing list.
# Permanent/NoEmail ---------- It was not possible to retrieve the recipient email address
#                              from the bounce message.
# Permanent/Suppressed ------- The recipient's email address is on the Amazon SES suppression
#                              list because it has a recent history of producing hard bounces.
# Permanent/OnAccountSuppressionList
#                              Amazon SES has suppressed sending to this address because it
#                              is on the account-level suppression list.
# 
# Transient/General ---------- You might be able to send a message to the same recipient
#                              in the future if the issue that caused the message to bounce
#                              is resolved.
# Transient/MailboxFull ------ the recipient's inbox was full.
# Transient/MessageTooLarge -- message you sent was too large
# Transient/ContentRejected -- message you sent contains content that the provider doesn't allow
# Transient/AttachmentRejected the message contained an unacceptable attachment
state $ReasonPair = {
    "Suppressed"               => $Sisimai::Eb::ReSTOP,
    "OnAccountSuppressionList" => $Sisimai::Eb::ReSTOP,
    "General"                  => $Sisimai::Eb::Re___1,
    "MailboxFull"              => $Sisimai::Eb::ReFULL,
    "MessageTooLarge"          => $Sisimai::Eb::ReSIZE,
    "ContentRejected"          => $Sisimai::Eb::ReBODY,
    "AttachmentRejected"       => $Sisimai::Eb::ReSAFE,
};

# https://aws.amazon.com/ses/
sub description { 'Amazon SES(Sending): https://aws.amazon.com/ses/' };
sub inquire {
    # Detect an error from Amazon SES
    # @param    [Hash] mhead    Message headers of a bounce email (JSON)
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    # @see https://docs.aws.amazon.com/ses/latest/dg/notification-contents.html
    # @since v4.0.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef; return undef unless index($$mbody, "{") > -1;
    return undef unless exists $mhead->{'x-amz-sns-message-id'};
    return undef unless        $mhead->{'x-amz-sns-message-id'};

    my $proceedsto = 0;
    my $sespayload = $$mbody;
    while(1) {
        # Remote the following string begins with "--"
        # --
        # If you wish to stop receiving notifications from this topic, please click or visit the link below to unsubscribe:
        # https://sns.us-west-2.amazonaws.com/unsubscribe.html?SubscriptionArn=arn:aws:sns:us-west-2:1...
        my $p1 = index($$mbody, "\n\n--\n");
        $sespayload =  substr($$mbody, 0, $p1) if $p1 > 0;
        $sespayload =~ s/!\n //g;
        my $p2 = index($sespayload, '"Message"');

        if( $p2 > 0 ) {
            # The JSON included in the email is a format like the following:
            # {
            #  "Type" : "Notification",
            #  "MessageId" : "02f86d9b-eecf-573d-b47d-3d1850750c30",
            #  "TopicArn" : "arn:aws:sns:us-west-2:123456789012:SES-EJ-B",
            #  "Message" : "{\"notificationType\"...
            $sespayload =~ s/\\//g;
            my $p3 = index($sespayload, "{",  $p2 + 9);
            my $p4 = index($sespayload, "\n", $p2 + 9);
            $sespayload =  substr($sespayload, $p3, $p4 - $p3);
            $sespayload =~ s/,$//g;
            $sespayload =~ s/"$//g;
        }
        last if index($sespayload, "notificationType") < 0 || index($sespayload, "{") != 0;
        last if substr($sespayload, -1, 1) ne "}";
        $proceedsto = 1; last;
    }
    return undef unless $proceedsto;

    # Load as JSON string and decode
    require JSON;
    my $jsonobject = undef; eval { $jsonobject = JSON->new->decode($sespayload) };
    if( $@ ) {
        # Something wrong in decoding JSON
        warn sprintf(" ***warning: Failed to decode JSON: %s", $@);
        return undef;
    }
    return undef unless exists $jsonobject->{'notificationType'};

    require Sisimai::RFC1123;
    require Sisimai::SMTP::Reply;
    require Sisimai::SMTP::Status;
    require Sisimai::SMTP::Command;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $recipients = 0;
    my $whatnotify = substr($jsonobject->{"notificationType"}, 0, 1) || "";
    my $v          = $dscontents->[-1];

    if( $whatnotify eq "B" ) {
        # "notificationType":"Bounce"
        my $p = $jsonobject->{"bounce"};
        my $r = $p->{"bounceType"} eq "Permanent" ? "5" : "4";

        for my $e ( $p->{"bouncedRecipients"}->@* ) {
            # {"emailAddress":"neko@example.jp", "action":"failed", "status":"5.1.1", "diagnosticCode": "..."}
            if( $v->{"recipient"} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{"recipient"} = $e->{"emailAddress"};
            $v->{"diagnosis"} = $e->{"diagnosticCode"};
            $v->{"command"}   = Sisimai::SMTP::Command->find($v->{"diagnosis"});
            $v->{"action"}    = $e->{"action"};
            $v->{"status"}    = Sisimai::SMTP::Status->find($v->{"diagnosis"}, $r);
            $v->{"replycode"} = Sisimai::SMTP::Reply->find($v->{"diagnosis"}, $v->{"status"});
            $v->{"date"}      = $p->{"timestamp"};
            $v->{"lhost"}     = Sisimai::RFC1123->find($p->{"reportingMTA"});
            $recipients++;

            for my $f ( keys %$ReasonPair ) {
                # Try to find the bounce reason by "bounceSubType"
                next unless $ReasonPair->{ $f } eq $p->{"bounceSubType"};
                $v->{"reason"} = $f; last;
            }
        }
    } elsif( $whatnotify eq "C" ) {
        # "notificationType":"Complaint"
        my $p = $jsonobject->{"complaint"}; for my $e ( $p->{"complainedRecipients"}->@* ) {
            # {"emailAddress":"neko@example.jp"}
            if( $v->{"recipient"} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{"recipient"}    = $e->{"emailAddress"};
            $v->{"reason"}       = $Sisimai::Eb::ReFEED;
            $v->{"feedbacktype"} = $p->{"complaintFeedbackType"};
            $v->{"date"}         = $p->{"timestamp"};
            $v->{"diagnosis"}    = sprintf(qq|{"feedbackid":"%s", "useragent":"%s"}|, $p->{"feedbackId"}, $p->{"userAgent"});
            $recipients++;
        }
    } elsif( $whatnotify eq "D" ) {
        # "notificationType":"Delivery"
        my $p = $jsonobject->{"delivery"}; for my $e ( $p->{"recipients"}->@* ) {
            # {"recipients":["neko@example.jp"]}
            if( $v->{"recipient"} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $v->{"recipient"} = $e;
            $v->{"reason"}    = $Sisimai::Eb::ReSENT;
            $v->{"action"}    = $Sisimai::Eb::AeSENT;
            $v->{"date"}      = $p->{"timestamp"};
            $v->{"lhost"}     = $p->{"reportingMTA"};
            $v->{"diagnosis"} = $p->{"smtpResponse"};
            $v->{"status"}    = Sisimai::SMTP::Status->find($v->{"diagnosis"}, "2");
            $v->{"replycode"} = Sisimai::SMTP::Reply->find($v->{"diagnosis"}, "2");
            $recipients++;
        }
    } else {
        # Unknown "notificationType" value
        warn sprintf(" ***warning: There is no notificationType field or unknown type of notificationType field");
        return undef;
    }
    return undef unless $recipients;

    # Time::Piece->strptime() cannot parse "2016-11-25T01:49:01.000Z" format
    for my $e ( @$dscontents ) { s/T/ /, s/[.]\d{3}Z$// for $e->{'date'} }

    # Generate pseudo email headers as the original message
    my $cv = "";
    my $ch = ["date", "subject"];
    my $or = $jsonobject->{'mail'};

    map { $cv .= sprintf("%s: %s\n", $_->{"name"}, $_->{"value"}) } $or->{"headers"}->@*;
    map { $cv .= sprintf("%s: %s\n", ucfirst($_), $or->{"commonHeaders"}->{ $_ }) if exists $or->{"commonHeaders"}->{ $_ } } @$ch;

    return {"ds" => $dscontents, "rfc822" => $cv};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost::AmazonSES - bounce mail decoder class for Amazon SES L<https://aws.amazon.com/ses/>

=head1 SYNOPSIS

    use Sisimai::Lhost::AmazonSES;

=head1 DESCRIPTION

C<Sisimai::Lhost::AmazonSES> decodes a JSON string which created by Amazon Simple Email Service
L<https://aws.amazon.com/ses/>. Methods in the module are called from only C<Sisimai::Message>.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Lhost::AmazonSES->description;

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
