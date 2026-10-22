package Sisimai::Eb;
use v5.26;
use strict;
use warnings;

#       _       ______                            
#   ___| |__   / /  _ \ ___  __ _ ___  ___  _ __  
#  / _ \ '_ \ / /| |_) / _ \/ _` / __|/ _ \| '_ \ 
# |  __/ |_) / / |  _ <  __/ (_| \__ \ (_) | | | |
#  \___|_.__/_/  |_| \_\___|\__,_|___/\___/|_| |_|
our $ReAUTH = "AuthFailure";
our $ReFAMA = "BadReputation";
our $ReBLOC = "Blocked";
our $ReBODY = "ContentError";
our $ReSENT = "Delivered";
our $ReSIZE = "EmailTooLarge";
our $ReTIME = "Expired";
our $ReTTLS = "FailedSTARTTLS";
our $ReFEED = "Feedback";
our $ReFILT = "Filtered";
our $ReMOVE = "HasMoved";
our $ReHOST = "HostUnknown";
our $ReFULL = "MailboxFull";
our $ReUNIX = "MailerError";
our $ReINET = "NetworkError";
our $RePASS = "NoRelaying";
our $Re00MX = "NotAccept";
our $ReNRFC = "NotCompliantRFC";
our $Re___1 = "OnHold";
our $ReWONT = "PolicyViolation";
our $ReFROM = "Rejected";
our $ReQPTR = "RequirePTR";
our $ReRATE = "RateLimited";
our $ReSAFE = "SecurityError";
our $ReSPAM = "SpamDetected";
our $ReSTOP = "Suppressed";
our $ReQUIT = "Suspend";
our $ReCOMM = "SyntaxError";
our $RePROC = "SystemError";
our $ReDISK = "SystemFull";
our $Re___0 = "Undefined";
our $ReUSER = "UserUnknown";
our $ReAWAY = "Vacation";
our $ReEXEC = "VirusDetected";

#       _       ______                                          _ 
#   ___| |__   / / ___|___  _ __ ___  _ __ ___   __ _ _ __   __| |
#  / _ \ '_ \ / / |   / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` |
# |  __/ |_) / /| |__| (_) | | | | | | | | | | | (_| | | | | (_| |
#  \___|_.__/_/  \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|
our $CeHELO = "HELO";
our $CeEHLO = "EHLO";
our $CeMAIL = "MAIL";
our $CeRCPT = "RCPT";
our $CeDATA = "DATA";
our $CeQUIT = "QUIT";
our $CeRSET = "RSET";
our $CeNOOP = "NOOP";
our $CeVRFY = "VRFY";
our $CeETRN = "ETRN";
our $CeEXPN = "EXPN";
our $CeHELP = "HELP";
our $CeAUTH = "AUTH";
our $CeTTLS = "STARTTLS";
our $CeXFWD = "XFORWARD";
our $CeCONN = "CONN"; # CONN is a pseudo SMTP command used only in Sisimai

#       _       ___        _   _
#   ___| |__   / / \   ___| |_(_) ___  _ __
#  / _ \ '_ \ / / _ \ / __| __| |/ _ \| '_ \
# |  __/ |_) / / ___ \ (__| |_| | (_) | | | |
#  \___|_.__/_/_/   \_\___|\__|_|\___/|_| |_|
#
# https://datatracker.ietf.org/doc/html/rfc3464#page-16
# 2.3.3 Action field
#   The Action field indicates the action performed by the Reporting-MTA as a result of its attempt
#   to deliver the message to this recipient address. This field MUST be present for each recipient
#   named in the DSN.
#
#   The syntax for the action-field is:
#     action-field = "Action" ":" action-value
#     action-value = "failed" / "delayed" / "delivered" / "relayed" / "expanded"
#
#   The action-value may be spelled in any combination of upper and lower case characters.
#
#     "failed"    indicates that the message could not be delivered to the recipient.
#                 The Reporting MTA has abandoned any attempts to deliver the message to this
#                 recipient. No further notifications should be expected.
#
#     "delayed"   indicates that the Reporting MTA has so far been unable to deliver or relay the
#                 message, but it will continue to attempt to do so. Additional notification
#                 messages may be issued as the message is further delayed or successfully
#                 delivered, or if delivery attempts are later abandoned.
#
#     "delivered" indicates that the message was successfully delivered to the recipient address
#                 specified by the sender, which includes "delivery" to a mailing list exploder.
#                 It does not indicate that the message has been read. This is a terminal state
#                 and no further DSN for this recipient should be expected.
#
#     "relayed"   indicates that the message has been relayed or gatewayed into an environment
#                 that does not accept responsibility for generating DSNs upon successful delivery.
#                 This action-value SHOULD NOT be used unless the sender has requested notification
#                 of successful delivery for this recipient.
#
#     "expanded"  indicates that the message has been successfully delivered to the recipient
#                 address as specified by the sender, and forwarded by the Reporting-MTA beyond
#                 that destination to multiple additional recipient addresses. An action-value of
#                 "expanded" differs from "delivered" in that "expanded" is not a terminal state.
#                 Further "failed" and/or "delayed" notifications may be provided.
our $AeFAIL = "failed";
our $AeSTAY = "delayed";
our $AeSENT = "delivered";
our $AePASS = "relayed";
our $AeEXPN = "expanded";

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Eb - Constants for email bounce

=head1 SYNOPSIS

    use Sisimai::Eb;
    print $Sisimai::Eb::ReAUTH; # AuthFailure

=head1 DESCRIPTION

C<Sisimai::Eb> keep constants referred from many classes in Sisimai.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

