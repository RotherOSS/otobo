package Sisimai::SMTP::Status;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::String;

# http://www.iana.org/assignments/smtp-enhanced-status-codes/smtp-enhanced-status-codes.xhtml
# -------------------------------------------------------------------------------------------------
# [Class Sub-Codes]
# 2.X.Y Success
# 4.X.Y Persistent Transient Failure
# 5.X.Y Permanent Failure
#
# -------------------------------------------------------------------------------------------------
# [Subject Sub-Codes]
# X.0.X --- Other or Undefined Status
#           There is no additional subject information available.
#
# X.1.X --- Addressing Status
#           The address status reports on the originator or destination address. It may include
#           address syntax or validity. These errors can generally be corrected by the sender and
#           retried.
#
# X.2.X --- Mailbox Status
#           Mailbox status indicates that something having to do with the mailbox has caused this
#           DSN. Mailbox issues are assumed to be under the general control of the recipient.
#
# X.3.X --- Mail System Status
#           Mail system status indicates that something having to do with the destination system
#           has caused this DSN. System issues are assumed to be under the general control of the
#           destination system administrator.
#
# X.4.X --- Network and Routing Status
#           The networking or routing codes report status about the delivery system itself. These
#           system components include any necessary infrastructure such as directory and routing
#           services. Network issues are assumed to be under the control of the destination or
#           intermediate system administrator.
#
# X.5.X --- Mail Delivery Protocol Status
#           The mail delivery protocol status codes report failures involving the message delivery
#           protocol. These failures include the full range of problems resulting from
#           implementation errors or an unreliable connection.
#
# X.6.X --- Message Content or Media Status
#           The message content or media status codes report failures involving the content of the
#           message. These codes report failures due to translation, transcoding, or otherwise
#           unsupported message media. Message content or media issues are under the control of both
#           the sender and the receiver, both of which must support a common set of supported
#           content-types.
#
# X.7.X --- Security or Policy Status
#           The security or policy status codes report failures involving policies such as
#           per-recipient or per-host filtering and cryptographic operations. Security and policy
#           status issues are assumed to be under the control of either or both the sender and
#           recipient.  Both the sender and recipient must permit the exchange of messages and
#           arrange the exchange of necessary keys and certificates for cryptographic operations.
#
# -------------------------------------------------------------------------------------------------
# [Enumerated Status Codes]
# X.0.0  Any    Other undefined Status:(RFC 3463)
#                 Other undefined status is the only undefined error code. It should be used for all
#                 errors for which only the class of the error is known.
#
# X.1.0  ---    Other address status:(RFC 3463)
#                 Something about the address specified in the message caused this DSN.
#
# X.1.1  451    Bad destination mailbox address:(RFC3463)
#        550      The mailbox specified in the address does not exist. For Internet mail names, this
#                 means the address portion to the the left of the "@" sign is invalid. This code is
#                 only useful for permanent failures.
#
# X.1.2  ---    Bad destination system addres:
#                 The destination system specified in the address does not exist or is incapable of
#                 accepting mail. For Internet mail names, this means the address portion to the
#                 right of the "@" is invalid for mail. This code is only useful for permanent
#                 failures.
#
# X.1.3  501    Bad destination mailbox address syntax:
#                 The destination address was syntactically invalid. This can apply to any field in
#                 the address. This code is only useful for permanent failures.
#
# X.1.4  ---    Destination mailbox address ambiguous:(RFC 3463)
#                 The mailbox address as specified matches one or more recipients on the destination
#                 system. This may result if a heuristic address mapping algorithm is used to map
#                 the specified address to a local mailbox name.
#
# X.1.5  250    Destination address valid:(RFC 3463)
#                 This mailbox address as specified was valid. This status code should be used for
#                 positive delivery reports.
#
# X.1.6  ---    Destination mailbox has moved, No forwarding address:(RFC 3463)
#                 The mailbox address provided was at one time valid, but mail is no longer being
#                 accepted for that address. This code is only useful for permanent failures.
#
# X.1.7  ---    Bad sender's mailbox address syntax:(RFC 3463)
#                 The sender's address was syntactically invalid. This can apply to any field in
#                 the address.
#
# X.1.8  451    Bad sender's system address:(RFC 3463)
#        501      The sender's system specified in the address does not exist or is incapable of
#                 accepting return mail. For domain names, this means the address portion to the
#                 right of the "@" is invalid for mail.
#
# X.1.9  ---    Message relayed to non-compliant mailer:(RFC 5248, 3886)
#                 The mailbox address specified was valid, but the message has been relayed to a
#                 system that does not speak this protocol; no further information can be provided.
#
# X.1.10 ---    Recipient address has null MX:(RFC 7505)
#                 This status code is returned when the associated address is marked as invalid
#                 using a null MX.
# -------------------------------------------------------------------------------------------------
# X.2.0  ---    Other or undefined mailbox status:(RFC 3463)
#                 The mailbox exists, but something about the destination mailbox has caused the
#                 sending of this DSN.
#
# X.2.1  ---    Mailbox disabled, not accepting messages:(RFC 3463)
#                 The mailbox exists, but is not accepting messages. This may be a permanent error
#                 if the mailbox will never be re-enabled or a transient error if the mailbox is
#                 only temporarily disabled.
#
# X.2.2  552    Mailbox full:(RFC 3463)
#                 The mailbox is full because the user has exceeded a per-mailbox administrative
#                 quota or physical capacity. The general semantics implies that the recipient can
#                 delete messages to make more space available. This code should be used as a
#                 persistent transient failure.
#
# X.2.3  552    Message length exceeds administrative limit:(RFC 3463)
#                 A per-mailbox administrative message length limit has been exceeded. This status
#                 code should be used when the per-mailbox message length limit is less than the
#                 general system limit. This code should be used as a permanent failure.
#
# X.2.4  450    Mailing list expansion problem:(RFC 3463)
#        452      The mailbox is a mailing list address and the mailing list was unable to be
#                 expanded. This code may represent a permanent failure or a persistent transient
#                 failure.
# -------------------------------------------------------------------------------------------------
# X.3.0  221    Other or undefined mail system status:(RFC 3463)
#        250      The destination system exists and normally accepts mail, but something about the
#        421,451  system has caused the generation of this DSN.
#        550,554
#
# X.3.1  452    Mail system full:(RFC 3463)
#                 Mail system storage has been exceeded. The general semantics imply that the
#                 individual recipient may not be able to delete material to make room for
#                 additional messages. This is useful only as a persistent transient error.
#
# X.3.2  453    System not accepting network messages:(RFC 3463)
#        521      The host on which the mailbox is resident is not accepting messages. Examples of
#                 such conditions include an imminent shutdown, excessive load, or system
#                 maintenance. This is useful for both permanent and persistent transient errors.
#
# X.3.3  ---    System not capable of selected features:(RFC 3463)
#                 Selected features specified for the message are not supported by the destination
#                 system. This can occur in gateways when features from one domain cannot be mapped
#                 onto the supported feature in another.
#
# X.3.4  552    Message too big for system:(RFC 3463)
#        554      The message is larger than per-message size limit. This limit may either be for
#                 physical or administrative reasons. This is useful only as a permanent error.
#
# X.3.5  ---    System incorrectly configured:(RFC 3463)
#                 The system is not configured in a manner that will permit it to accept this
#                 message.
# -------------------------------------------------------------------------------------------------
# X.4.0  ---    Other or undefined network or routing status:(RFC 3463)
#                 Something went wrong with the networking, but it is not clear what the problem is,
#                 or the problem cannot be well expressed with any of the other provided detail
#                 codes.
#
# X.4.1  451    No answer from host:(RFC 3463)
#                 The outbound connection attempt was not answered, because either the remote system
#                 was busy, or was unable to take a call. This is useful only as a persistent
#                 transient error.
#
# X.4.2  421    Bad connection:(RFC 3463)
#                 The outbound connection was established, but was unable to complete the message
#                 transaction, either because of time-out, or inadequate connection quality. This
#                 is useful only as a persistent transient error.
#
# X.4.3  451    Directory server failure:(RFC 3463)
#        550      The network system was unable to forward the message, because a directory server
#                 was unavailable. This is useful only as a persistent transient error. The
#                 inability to connect to an Internet DNS server is one example of the directory
#                 server failure error.
#
# X.4.4  ---    Unable to route:(RFC 3463)
#                 The mail system was unable to determine the next hop for the message because the
#                 necessary routing information was unavailable from the directory server. This is
#                 useful for both permanent and persistent transient errors. A DNS lookup returning
#                 only an SOA (Start of Administration) record for a domain name is one example of
#                 the unable to route error.
#
# X.4.5  451    Mail system congestion:(RFC 3463)
#                 The mail system was unable to deliver the message because the mail system was
#                 congested. This is useful only as a persistent transient error.
#
# X.4.6  ---    Routing loop detected:(RFC 3463)
#                 A routing loop caused the message to be forwarded too many times, either because
#                 of incorrect routing tables or a user-forwarding loop. This is useful only as a
#                 persistent transient error.
#
# X.4.7  ---    Delivery time expired:(RFC 3463)
#                 The message was considered too old by the rejecting system, either because it
#                 remained on that host too long or because the time-to-live value specified by the
#                 sender of the message was exceeded. If possible, the code for the actual problem
#                 found when delivery was attempted should be returned rather than this code.
#
# X.4.8  421    Retry on IPv4
#        451      the mail system will not accept this message over IPv6 because it lacks some re-
#        456      quirments described in the full text of the rejection, however the sending mail
#                 system can retry immediately to submit the message over IPv4 only.
#                 https://datatracker.ietf.org/doc/html/draft-martin-smtp-ipv6-to-ipv4-fallback-00
#
# -------------------------------------------------------------------------------------------------
# X.5.0  220    Other or undefined protocol status:(RFC 3463)
#        250-253  Something was wrong with the protocol necessary to deliver the message to the next
#        451,452  hop and the problem cannot be well expressed with any of the other provided detail
#        454,458  codes.
#        459,554
#        501-503
#
# X.5.1  430    Invalid command:(RFC 3463)
#        500,501  A mail transaction protocol command was issued which was either out of sequence
#        503,530  or unsupported. This is useful only as a permanent error.
#        550,554  
#        555
#
# X.5.2  500    Syntax error:(RFC 3463)
#        500,501  A mail transaction protocol command was issued which could not be interpreted,
#        502,550  either because the syntax was wrong or the command is unrecognized. This is useful
#        555      only as a permanent error.
#
# X.5.3  451    Too many recipients:(RFC 3463)
#                 More recipients were specified for the message than could have been delivered by
#                 the protocol. This error should normally result in the segmentation of the message
#                 into two, the remainder of the recipients to be delivered on a subsequent delivery
#                 attempt. It is included in this list in the event that such segmentation is not
#                 possible.
#
# X.5.4  451    Invalid command arguments:(RFC 3463)
#        501-504  A valid mail transaction protocol command was issued with invalid arguments,
#        550      either because the arguments were out of range or represented unrecognized
#        555      features. This is useful only as a permanent error.
#
# X.5.5  ---    Wrong protocol version:(RFC 3463)
#                 A protocol version mis-match existed which could not be automatically resolved by
#                 the communicating parties.
#
# X.5.6  550    Authentication Exchange line is too long (RFC 4954)
#                 This enhanced status code SHOULD be returned when the server fails the AUTH
#                 command due to the client sending a [BASE64] response which is longer than the
#                 maximum buffer size available for the currently selected SASL mechanism. This is
#                 useful for both permanent and persistent transient errors.
# -------------------------------------------------------------------------------------------------
# X.6.0  ---    Other or undefined media error:(RFC 3463)
#                 Something about the content of a message caused it to be considered undeliverable
#                 and the problem cannot be well expressed with any of the other provided detail
#                 codes.
#
# X.6.1  ---    Media not supported:(RFC 3463)
#                 The media of the message is not supported by either the delivery protocol or the
#                 next system in the forwarding path. This is useful only as a permanent error.
#
# X.6.2  ---    Conversion required and prohibited:(RFC 3463)
#                 The content of the message must be converted before it can be delivered and such
#                 conversion is not permitted. Such prohibitions may be the expression of the sender
#                 in the message itself or the policy of the sending host.
#
# X.6.3  554    Conversion required but not supported:(RFC 3463)
#                 The message content must be converted in order to be forwarded but such conversion
#                 is not possible or is not practical by a host in the forwarding path. This
#                 condition may result when an ESMTP gateway supports 8bit transport but is not able
#                 to downgrade the message to 7 bit as required for the next hop.
#
# X.6.4  250    Conversion with loss performed:(RFC 3463)
#                 This is a warning sent to the sender when message delivery was successfully but
#                 when the delivery required a conversion in which some data was lost. This may also
#                 be a permanent error if the sender has indicated that conversion with loss is
#                 prohibited for the message.
#
# X.6.5  ---    Conversion Failed:(RFC 3463)
#                 A conversion was required but was unsuccessful. This may be useful as a permanent
#                 or persistent temporary notification.
#
# X.6.6  554    Message content not available (RFC 4468)
#                 The message content could not be fetched from a remote system. This may be useful
#                 as a permanent or persistent temporary notification.
#
# X.6.7  553    The ALT-ADDRESS is required but not specified:(RFC 6531)
#        550      This indicates the reception of a MAIL or RCPT command that non-ASCII addresses
#                 are not permitted
#
# X.6.8  252    UTF-8 string reply is required, but not permitted by the client:(RFC 6531)
#        553      This indicates that a reply containing a UTF-8 string is required to show the
#        550      mailbox name, but that form of response is not permitted by the SMTP client.
#
# X.6.9  550    UTF8SMTP downgrade failed:(RFC 6531)
#                 This indicates that transaction failed after the final "." of the DATA command.
#
# X.6.10        This is a duplicate of X.6.8 and is thus deprecated.
# -------------------------------------------------------------------------------------------------
# X.7.0  220    Other or undefined security status:(RFC 3463)
#        235      Something related to security caused the message to be returned, and the problem
#        450,454  cannot be well expressed with any of the other provided detail codes. This status
#        500,501  code may also be used when the condition cannot be further described because of
#        503,504  security policies in force.
#        530,535
#        550
#
# X.7.1  451    Delivery not authorized, message refused:(RFC 3463)
#        454,502  The sender is not authorized to send to the destination. This can be the result
#        503,533  of per-host or per-recipient filtering. This memo does not discuss the merits of
#        550,551  any such filtering, but provides a mechanism to report such. This is useful only
#                 as a permanent error.
#
# X.7.2  550    Mailing list expansion prohibited:(RFC 3463)
#                 The sender is not authorized to send a message to the intended mailing list. This
#                 is useful only as a permanent error.
#
# X.7.3  ---    Security conversion required but not possible:(RFC 3463)
#                 A conversion from one secure messaging protocol to another was required for
#                 delivery and such conversion was not possible. This is useful only as a permanent
#                 error.
#
# X.7.4  504    Security features not supported:(RFC 3463)
#                 A message contained security features such as secure authentication that could not
#                 be supported on the delivery protocol. This is useful only as a permanent error.
#
# X.7.5  ---    Cryptographic failure:(RFC 3463)
#                 A transport system otherwise authorized to validate or decrypt a message in
#                 transport was unable to do so because necessary information such as key was not
#                 available or such information was invalid.
#
# X.7.6  ---    Cryptographic algorithm not supported:(RFC 3463)
#                 A transport system otherwise authorized to validate or decrypt a message was
#                 unable to do so because the necessary algorithm was not supported.

# X.7.7  ---    Message integrity failure:(RFC 3463)
#                 A transport system otherwise authorized to validate a message was unable to do so
#                 because the message was corrupted or altered. This may be useful as a permanent,
#                 transient persistent, or successful delivery code.
#
# X.7.8  535    Trust relationship required:(RFC 4954)
#        554      This response to the AUTH command indicates that the authentication failed due to
#                 invalid or insufficient authentication credentials. In this case, the client
#                 SHOULD ask the user to supply new credentials (such as by presenting a password
#                 dialog box).
#
# X.7.9  534    Authentication mechanism is too weak:(RFC 4954)
#                 This response to the AUTH command indicates that the selected authentication
#                 mechanism is weaker than server policy permits for that user. The client SHOULD
#                 retry with a new authentication mechanism.
#
# X.7.10 523    Encryption Needed:(RFC 5248)
#                 This indicates that external strong privacy layer is needed in order to use the
#                 requested authentication mechanism. This is primarily intended for use with clear
#                 text authentication mechanisms. A client which receives this may activate a
#                 security layer such as TLS prior to authenticating, or attempt to use a stronger
#                 mechanism.
#
# X.7.11 524    Encryption required for requested authentication mechanism:(RFC 4954)
#        538      This response to the AUTH command indicates that the selected authentication
#                 mechanism may only be used when the underlying SMTP connection is encrypted. Note
#                 that this response code is documented here for historical purposes only. Modern
#                 implementations SHOULD NOT advertise mechanisms that are not permitted due to lack
#                 of encryption, unless an encryption layer of sufficient strength is currently
#                 being employed.
#
# X.7.12 422    A password transition is needed:(RFC 4954)
#        432      This response to the AUTH command indicates that the user needs to transition to
#                 the selected authentication mechanism. This is typically done by authenticating
#                 once using the [PLAIN] authentication mechanism. The selected mechanism SHOULD
#                 then work for authentications in subsequent sessions.
#
# X.7.13 525    User Account Disabled:(RFC 5248)
#                 Sometimes a system administrator will have to disable a user's account (e.g., due
#                 to lack of payment, abuse, evidence of a break-in attempt, etc). This error code
#                 occurs after a successful authentication to a disabled account. This informs the
#                 client that the failure is permanent until the user contacts their system
#                 administrator to get the account re-enabled. It differs from a generic
#                 authentication failure where the client's best option is to present the passphrase
#                 entry dialog in case the user simply mistyped their passphrase.
#
# X.7.14 535    Trust relationship required:(RFC 5248)
#        554      The submission server requires a configured trust relationship with a third-party
#                 server in order to access the message content. This value replaces the prior use
#                 of X.7.8 for this error condition. thereby updating [RFC4468].
#
# X.7.15 450    Priority Level is too low:(RFC6710)
#        550      The specified priority level is below the lowest priority acceptable for the
#        4xx      receiving SMTP server. This condition might be temporary, for example the server
#        5xx      is operating in a mode where only higher priority messages are accepted for
#                 transfer and delivery, while lower priority messages are rejected.
#
# X.7.16 552    Message is too big for the specified priority:(RFC 6710)
#        4xx      The message is too big for the specified priority. This condition might be
#        5xx      temporary, for example the server is operating in a mode where only higher
#                 priority messages below certain size are accepted for transfer and delivery.
#
# X.7.17 5xx    Mailbox owner has changed:(RFC 6710)
#                 This status code is returned when a message is received with a
#                 Require-Recipient-Valid-Since field or RRVS extension and the receiving system is
#                 able to determine that the intended recipient mailbox has not been under
#                 continuous ownership since the specified date-time.
#
# X.7.18 5xx    Domain owner has changed:(RFC 7293)
#                 This status code is returned when a message is received with a
#                 Require-Recipient-Valid-Since field or RRVS extension and the receiving system
#                 wishes to disclose that the owner of the domain name of the recipient has changed
#                 since the specified date-time.
#
# X.7.19 5xx    RRVS test cannot be completed:(RFC 7293)
#                 This status code is returned when a message is received with a
#                 Require-Recipient-Valid-Since field or RRVS extension and the receiving system
#                 cannot complete the requested evaluation because the required timestamp was not
#                 recorded. The message originator needs to decide whether to reissue the message
#                 without RRVS protection.
#
# X.7.20 550    No passing DKIM signature found:(RFC 7372)
#                 This status code is returned when a message did not contain any passing DKIM
#                 signatures. (This violates the advice of Section 6.1 of [RFC6376].)
#
# X.7.21 550    No acceptable DKIM signature found:(RFC 7372, 6476)
#                 This status code is returned when a message contains one or more passing DKIM
#                 signatures, but none are acceptable. (This violates the advice of Section 6.1 of
#                 [RFC6376].)
#
# X.7.22 550    No valid author-matched DKIM signature found:(RFC 7372)
#                 This status code is returned when a message contains one or more passing DKIM
#                 signatures, but none are acceptable because none have an identifier(s) that
#                 matches the author address(es) found in the From header field. This is a special
#                 case of X.7.21. (This violates the advice of Section 6.1 of [RFC6376].)
#
# X.7.23 550    SPF validation failed:(RFC 7273, 7208)
#                 This status code is returned when a message completed an SPF check that produced
#                 a "fail" result, contrary to local policy requirements. Used in place of 5.7.1 as
#                 described in Section 8.4 of [RFC7208].
#
# X.7.24 451    SPF validation error:(RFC 7372, 7208)
#        550      This status code is returned when evaluation of SPF relative to an arriving
#                 message resulted in an error. Used in place of 4.4.3 or 5.5.2 as described in
#                 Sections 8.6 and 8.7 of [RFC7208].
#
# X.7.25 550    Reverse DNS validation failed:(RFC 7372, 7601)
#                 This status code is returned when an SMTP client's IP address failed a reverse
#                 DNS validation check, contrary to local policy requirements.
#
# X.7.26 550    Multiple authentication checks failed:(RFC 7372)
#                 This status code is returned when a message failed more than one message
#                 authentication check, contrary to local policy requirements. The particular
#                 mechanisms that failed are not specified.
#
# X.7.27 550    Sender address has null MX:(RFC 7505)
#                 This status code is returned when the associated sender address has a null MX,
#                 and the SMTP receiver is configured to reject mail from such sender
#                 (e.g., because it could not return a DSN).
# -------------------------------------------------------------------------------------------------
# SAMPLES
#   554 5.5.0   No recipients have been specified
#   503 5.5.0   Valid RCPT TO required before BURL
#   554 5.6.3   Conversion required but not supported
#   554 5.3.4   Message too big for system
#   554 5.7.8   URL resolution requires trust relationship
#   552 5.2.2   Mailbox full
#   554 5.6.6   IMAP URL resolution failed
#   250 2.5.0   Waiting for additional BURL or BDAT commands
#   451 4.4.1   IMAP server unavailable
#   250 2.5.0   Ok.
#   250 2.6.4   MIME header conversion with loss performed
#   235 2.7.0   Authentication Succeeded
#   432 4.7.12  A password transition is needed
#   454 4.7.0   Temporary authentication failure
#   534 5.7.9   Authentication mechanism is too weak
#   535 5.7.8   Authentication credentials invalid
#   500 5.5.6   Authentication Exchange line is too long
#   530 5.7.0   Authentication required
#   538 5.7.11  Encryption required for requested authentication
#       5.7.8   Authentication credentials invalid
#       5.7.9   Authentication mechanism is too weak
#       5.7.11  Encryption required for requested authentication mechanism
# -------------------------------------------------------------------------------------------------
use constant StandardCode => {
    '2.1.5'  => 'delivered',    # Successfully delivered
    # ---------------------------------------------------------------------------------------------
    '4.1.6'  => 'hasmoved',     # Destination mailbox has moved, No forwarding address
    '4.1.7'  => 'rejected',     # Bad sender's mailbox address syntax
    '4.1.8'  => 'rejected',     # Bad sender's system address
    '4.1.9'  => 'systemerror',  # Message relayed to non-compliant mailer
    '4.2.1'  => 'suspend',      # Mailbox disabled, not accepting messages
    '4.2.2'  => 'mailboxfull',  # Mailbox full
    '4.2.3'  => 'exceedlimit',  # Message length exceeds administrative limit
    '4.2.4'  => 'filtered',     # Mailing list expansion problem
    #'4.3.0' => 'systemerror',  # Other or undefined mail system status
    '4.3.1'  => 'systemfull',   # Mail system full
    '4.3.2'  => 'notaccept',    # System not accepting network messages
    '4.3.3'  => 'systemerror',  # System not capable of selected features
    '4.3.5'  => 'systemerror',  # System incorrectly configured
    #'4.4.0' => 'networkerror', # Other or undefined network or routing status
    '4.4.1'  => 'expired',      # No answer from host
    '4.4.2'  => 'networkerror', # Bad connection
    '4.4.3'  => 'systemerror',  # Directory server failure
    '4.4.4'  => 'networkerror', # Unable to route
    '4.4.5'  => 'systemfull',   # Mail system congestion
    '4.4.6'  => 'networkerror', # Routing loop detected
    '4.4.7'  => 'expired',      # Delivery time expired
    '4.4.8'  => 'networkerror', # Retry on IPv4
#   '4.5.0'  => 'networkerror', # Other or undefined protocol status
    '4.5.3'  => 'systemerror',  # Too many recipients
    '4.5.5'  => 'systemerror',  # Wrong protocol version
    '4.6.0'  => 'contenterror', # Other or undefined media error
    '4.6.2'  => 'contenterror', # Conversion required and prohibited
    '4.6.5'  => 'contenterror', # Conversion Failed
    #'4.7.0' => 'securityerror',# Other or undefined security status
    '4.7.1'  => 'blocked',      # Delivery not authorized, message refused
    '4.7.2'  => 'blocked',      # Mailing list expansion prohibited
    '4.7.5'  => 'securityerror',# Cryptographic failure
    '4.7.6'  => 'securityerror',# Cryptographic algorithm not supported
    '4.7.7'  => 'securityerror',# Message integrity failure
    '4.7.12' => 'securityerror',# A password transition is needed
    '4.7.15' => 'securityerror',# Priority Level is too low
    '4.7.16' => 'mesgtoobig',   # Message is too big for the specified priority
    '4.7.24' => 'authfailure',  # SPF validation error
    '4.7.25' => 'requireptr',   # Reverse DNS validation failed
    '4.7.26' => 'authfailure',  # Must pass either SPF or DKIM validation
    # ---------------------------------------------------------------------------------------------
    '5.1.0'  => 'userunknown',  # Other address status
    '5.1.1'  => 'userunknown',  # Bad destination mailbox address
    '5.1.2'  => 'hostunknown',  # Bad destination system address
    '5.1.3'  => 'userunknown',  # Bad destination mailbox address syntax
    '5.1.4'  => 'filtered',     # Destination mailbox address ambiguous
    '5.1.6'  => 'hasmoved',     # Destination mailbox has moved, No forwarding address
    '5.1.7'  => 'rejected',     # Bad sender's mailbox address syntax
    '5.1.8'  => 'rejected',     # Bad sender's system address
    '5.1.9'  => 'systemerror',  # Message relayed to non-compliant mailer
    '5.1.10' => 'notaccept',    # Recipient address has null MX
    '5.2.0'  => 'filtered',     # Other or undefined mailbox status
    '5.2.1'  => 'filtered',     # Mailbox disabled, not accepting messages
    '5.2.2'  => 'mailboxfull',  # Mailbox full
    '5.2.3'  => 'exceedlimit',  # Message length exceeds administrative limit
    '5.2.4'  => 'filtered',     # Mailing list expansion problem
    '5.3.0'  => 'systemerror',  # Other or undefined mail system status
    '5.3.1'  => 'systemfull',   # Mail system full
    '5.3.2'  => 'notaccept',    # System not accepting network messages
    '5.3.3'  => 'systemerror',  # System not capable of selected features
    '5.3.4'  => 'mesgtoobig',   # Message too big for system
    '5.3.5'  => 'systemerror',  # System incorrectly configured
    '5.4.0'  => 'networkerror', # Other or undefined network or routing status
    '5.4.3'  => 'systemerror',  # Directory server failure
    '5.4.4'  => 'hostunknown',  # Unable to route
    '5.5.2'  => 'syntaxerror',  # If the server cannot BASE64 decode any client response (AUTH)
    '5.5.3'  => 'toomanyconn',  # Too many recipients
    '5.5.4'  => 'systemerror',  # Invalid command arguments
    '5.5.5'  => 'systemerror',  # Wrong protocol version
    '5.5.6'  => 'syntaxerror',  # Authentication Exchange line is too long
    '5.6.0'  => 'contenterror', # Other or undefined media error
    '5.6.1'  => 'contenterror', # Media not supported
    '5.6.2'  => 'contenterror', # Conversion required and prohibited
    '5.6.3'  => 'contenterror', # Conversion required but not supported
    '5.6.5'  => 'contenterror', # Conversion Failed
    '5.6.6'  => 'contenterror', # Message content not available
    '5.6.7'  => 'contenterror', # Non-ASCII addresses not permitted for that sender/recipient
    '5.6.8'  => 'contenterror', # UTF-8 string reply is required, but not permitted by the SMTP client
    '5.6.9'  => 'contenterror', # UTF-8 header message cannot be transferred to one or more recipients
    '5.7.0'  => 'securityerror',# Other or undefined security status
    '5.7.1'  => 'securityerror',# Delivery not authorized, message refused
    '5.7.2'  => 'securityerror',# Mailing list expansion prohibited
    '5.7.3'  => 'securityerror',# Security conversion required but not possible
    '5.7.4'  => 'securityerror',# Security features not supported
    '5.7.5'  => 'securityerror',# Cryptographic failure
    '5.7.6'  => 'securityerror',# Cryptographic algorithm not supported
    '5.7.7'  => 'securityerror',# Message integrity failure
    '5.7.8'  => 'securityerror',# Authentication credentials invalid
    '5.7.9'  => 'securityerror',# Authentication mechanism is too weak
    '5.7.10' => 'securityerror',# Encryption Needed
    '5.7.11' => 'securityerror',# Encryption required for requested authentication mechanism
    '5.7.13' => 'suspend',      # User Account Disabled
    '5.7.14' => 'securityerror',# Trust relationship required
    '5.7.15' => 'securityerror',# Priority Level is too low
    '5.7.16' => 'mesgtoobig',   # Message is too big for the specified priority
    '5.7.17' => 'hasmoved',     # Mailbox owner has changed
    '5.7.18' => 'hasmoved',     # Domain owner has changed
    '5.7.19' => 'securityerror',# RRVS test cannot be completed
    '5.7.20' => 'authfailure',  # No passing DKIM signature found
    '5.7.21' => 'authfailure',  # No acceptable DKIM signature found
    '5.7.22' => 'authfailure',  # No valid author-matched DKIM signature found
    '5.7.23' => 'authfailure',  # SPF validation failed
    '5.7.24' => 'authfailure',  # SPF validation error
    '5.7.25' => 'requireptr',   # Reverse DNS validation failed
    '5.7.26' => 'authfailure',  # Multiple authentication checks failed
    '5.7.27' => 'notaccept',    # MX resource record of a destination host is Null MX: RFC7505
    '5.7.28' => 'spamdetected', # The message appears to be part of a mail flood of similar abusive messages.
    '5.7.29' => 'authfailure',  # This status code may be returned when a message fails ARC validation.
    '5.7.30' => 'securityerror',# REQUIRETLS support required
};

use constant InternalCode => {
    'temporary' => {
        'authfailure'    => '4.0.972',
        'badreputation'  => '4.0.975',
        'blocked'        => '4.0.971',
        'contenterror'   => '4.0.960',
        #'exceedlimit'   => '4.0.923',
        'expired'        => '4.0.947',
        'filtered'       => '4.0.924',
        #'hasmoved'      => '4.0.916',
        #'hostunknown'   => '4.0.912',
        'mailboxfull'    => '4.0.922',
        #'mailererror'   => '4.0.939',
        #'mesgtoobig'    => '4.0.934',
        'networkerror'   => '4.0.944',
        #'norelaying'    => '4.0.909',
        'notaccept'      => '4.0.932',
        'notcompliantrfc'=> '4.0.974',
        'onhold'         => '4.0.901',
        'rejected'       => '4.0.918',
        'requireptr'     => '4.0.973',
        'securityerror'  => '4.0.970',
        'spamdetected'   => '4.0.980',
        'speeding'       => '4.0.946',
        #'suspend'       => '4.0.921',
        'systemerror'    => '4.0.930',
        'systemfull'     => '4.0.931',
        'toomanyconn'    => '4.0.945',
        #'userunknown'   => '4.0.911',
        'undefined'      => '4.0.900',
    },
    'permanent' => {
        'authfailure'    => '5.0.972',
        'badreputation'  => '5.0.975',
        'blocked'        => '5.0.971',
        'contenterror'   => '5.0.960',
        'exceedlimit'    => '5.0.923',
        'expired'        => '5.0.947',
        'filtered'       => '5.0.910',
        'hasmoved'       => '5.0.916',
        'hostunknown'    => '5.0.912',
        'mailboxfull'    => '5.0.922',
        'mailererror'    => '5.0.939',
        'mesgtoobig'     => '5.0.934',
        'networkerror'   => '5.0.944',
        'norelaying'     => '5.0.909',
        'notaccept'      => '5.0.932',
        'notcompliantrfc'=> '5.0.974',
        'onhold'         => '5.0.901',
        'policyviolation'=> '5.0.972',
        'rejected'       => '5.0.918',
        'requireptr'     => '5.0.973',
        'securityerror'  => '5.0.970',
        'spamdetected'   => '5.0.980',
        'speeding'       => '5.0.946',
        'suspend'        => '5.0.921',
        'systemerror'    => '5.0.930',
        'systemfull'     => '5.0.931',
        'syntaxerror'    => '5.0.902',
        'toomanyconn'    => '5.0.945',
        'userunknown'    => '5.0.911',
        'undefined'      => '5.0.900',
        'virusdetected'  => '5.0.971',
    },
};

sub code {
    # Convert from the reason string to the internal status code
    # @param    [String]  argv1 Reason name
    # @param    [Integer] argv2 0: Permanent error
    #                           1: Temporary error
    # @return   [String]        D.S.N. or empty if the 1st argument is missing
    # @see      name
    # @since v4.14.0
    my $class = shift;
    my $argv1 = shift || return undef;
    my $argv2 = shift // 0;
    my $table = undef;
    my $code0 = undef;

    $table = $argv2 ? InternalCode->{'temporary'} : InternalCode->{'permanent'};
    $code0 = $table->{ $argv1 } // InternalCode->{'permanent'}->{ $argv1 } // '';
    return $code0;
}

sub name {
    # Convert from the status code to the reason string
    # @param    [String] argv1  Status code(DSN)
    # @return   [String]        Reason name or empty if the first argument did
    #                           not match with values in Sisimai's reason list
    # @see      code
    # @since v4.14.0
    my $class = shift;
    my $argv1 = shift || return undef;

    return '' unless __PACKAGE__->test($argv1);
    return StandardCode->{ $argv1 } // '';
}

sub test {
    # Check whether a status code is a valid code or not
    # @param    [String] argv1  Status code(DSN)
    # @return   [Boolean]       0 = Invalid status code, 1 = Valid status code
    # @see      code
    # @since v5.0.0
    my $class = shift;
    my $argv1 = shift || return undef; 
    return 0 if length $argv1 < 5;
    return 0 if length $argv1 > 7;

    my $token = []; push @$token, int $_ for split(/[.]/, $argv1);
    return 0 unless scalar @$token == 3;
    return 0 if $token->[0] <  2;
    return 0 if $token->[0] == 3;
    return 0 if $token->[0] >  5;
    return 0 if $token->[1] <  0;
    return 0 if $token->[1] >  7;
    return 0 if $token->[2] <  0;
    return 1;
}

sub find {
    # Get a DSN code value from given string including DSN
    # @param    [String] argv1  String including DSN
    # @param    [String] argv2  An SMTP Reply Code or 2 or 4 or 5
    # @return   [String]        An SMTP Status Code
    # @since v4.14.0
    my $class = shift;
    my $argv1 = shift || return undef; return undef if length $argv1 < 7;
    my $argv2 = shift || '';

    my $givenclass = substr($argv2, 0, 1);
    my $eestatuses = $givenclass eq '2' || $givenclass eq '4' || $givenclass eq '5' ? [$givenclass.'.'] : ['5.', '4.', '2.'];
    my $esmtperror = ' '.$argv1.' ';
    my $lookingfor = {};

    for my $e ( Sisimai::String->ipv4($esmtperror)->@* ) {
        # Rewrite an IPv4 address in the given string(argv1) with '***.***.***.***'
        my $p0 = index($esmtperror, $e); next if $p0 == -1;
        substr($esmtperror, $p0, length $e, '***.***.***.***');
    }

    for my $e ( @$eestatuses ) {
        # Count the number of "5.", "4.", and "2." in the error message
        my $p0 = 0;
        my $p1 = 0;
        while($p0 > -1) {
            # Find all of the "5." and "4." string and store its postion
            $p0 = index($esmtperror, $e, $p1); last if $p0 == -1;
            $lookingfor->{ sprintf("%04d", $p0) } = $e;
            $p1 = $p0 + 5;
        }
    }
    return '' unless scalar keys %$lookingfor;

    my $statuscode = [];    # List of SMTP Status Code, Keep the order of appearances
    my $anotherone = '';    # Alternative code
    my $readbuffer = '';
    my $characters = [];    # Characters around the status code found by index()
    my $indexofees = -1;    # A position of SMTP status code found by the index()

    for my $e ( sort keys %$lookingfor ) {
        # Try to find an SMTP Status Code from the given string
        $indexofees = index($esmtperror, $lookingfor->{ $e }, int $e); next if $indexofees == -1;
        $characters = [
            ord(substr($esmtperror, $indexofees - 1, 1)) || 0,  # [0] The previous character of the status
            ord(substr($esmtperror, $indexofees + 2, 1)) || 0,  # [1] The value of the "Subject", "5.[7].261"
            ord(substr($esmtperror, $indexofees + 3, 1)) || 0,  # [2] "." chacater, a separator of the Subject and the Detail
        ];

        next if $characters->[0]  > 45 && $characters->[0]  <  58;  # Previous character is a number
        next if $characters->[0] == 86 || $characters->[0] == 118;  # Avoid a version number("V" or "v")
        next if $characters->[1]  < 48 || $characters->[1]   > 55;  # The value of the subject is not a number(0-7)
        next if $characters->[2] != 46;                             # It is not a "." character: a separator

        $readbuffer = $lookingfor->{ $e }.chr($characters->[1]).'.';
        push @$characters, ord(substr($esmtperror, $indexofees + 4, 1)) || 0, # [3] The 1st digit of the detail
                           ord(substr($esmtperror, $indexofees + 5, 1)) || 0, # [4] The 2nd digit of the detail
                           ord(substr($esmtperror, $indexofees + 6, 1)) || 0, # [5] The 3rd digit of the detail
                           ord(substr($esmtperror, $indexofees + 7, 1)) || 0; # [6] The next character

        next if $characters->[3] < 48 || $characters->[3] > 57; # The 1st digit of the detail is not a number
        $readbuffer .= chr $characters->[3];

        if( index($readbuffer, '.0.0') == 1 || $readbuffer eq '4.4.7' ) {
            # Find another status code except *.0.0, 4.4.7
            $anotherone = $readbuffer;
            next;
        }

        if( $characters->[4] < 48 || $characters->[4] > 57 ) {
            # The 2nd digit of the detail is not a number
            push @$statuscode, $readbuffer;
            next;
        }
        $readbuffer .= chr $characters->[4];    # The 2nd digit of the detail is a number

        if( $characters->[5] < 48 || $characters->[5] > 57 ) {
            # The 3rd digit of the detail is not a number
            push @$statuscode, $readbuffer;
            next;
        }
        $readbuffer .= chr $characters->[5];    # The 3rd digit of the detail is a number

        next if $characters->[6] > 47 && $characters->[6] < 58;
        push @$statuscode, $readbuffer;
    }
    push @$statuscode, $anotherone if length $anotherone;

    return '' if scalar @$statuscode == 0;
    return shift @$statuscode;
}

sub prefer {
    # Return the preferred value selected from the arguments
    # @param    [String] argv0  The value of Status:
    # @param    [String] argv1  The delivery status picked from the error message
    # @param    [String] argv2  The value of An SMTP Reply Code
    # @return   [String]        The preferred value
    # @since v5.0.0
    my $class = shift;
    my $argv0 = shift || '';
    my $argv1 = shift || '';
    my $argv2 = shift || '';

    my $statuscode = $argv0 || return $argv1; return $argv1 unless length $statuscode > 4;
    my $codeinmesg = $argv1 || return $argv0; return $argv0 unless length $codeinmesg > 4;
    my $esmtpreply = $argv2 || 0;
    my $the1stchar = {
        'field' => int substr($statuscode, 0, 1),
        'error' => int substr($codeinmesg, 0, 1),
        'reply' => int substr($esmtpreply, 0, 1),
    };

    if( $the1stchar->{'reply'} > 0 && $the1stchar->{'field'} != $the1stchar->{'error'} ) {
        # There is the 3rd argument (an SMTP Reply Code)
        # Returns the value of $argv0 or $argv1 which begins with the 1st character of $argv2
        return $statuscode if $the1stchar->{'reply'} == $the1stchar->{'field'};
        return $codeinmesg if $the1stchar->{'reply'} == $the1stchar->{'error'};
    }
    return $statuscode if $statuscode eq $codeinmesg;

    my $zeroindex1 = { 'field' => index($statuscode, '.0'),   'error' => index($codeinmesg, '.0')   };
    my $zeroindex2 = { 'field' => index($statuscode, '.0.0'), 'error' => index($codeinmesg, '.0.0') };

    if( $zeroindex2->{'field'} > 0 ) {
        # "Status:" field is "X.0.0"
        return $codeinmesg if $zeroindex2->{'error'} < 0;
        return $statuscode;
    }

    if( $zeroindex1->{'field'} > 0 ) {
        # "Status:" field is "X.Y.0" or "X.0.Z"
        return $codeinmesg if $zeroindex1->{'error'} < 0;
    }

    return $statuscode if $zeroindex2->{'error'} > 0;       # An SMTP status code is "X.0.0"
    return $codeinmesg if $statuscode eq '4.4.7';           # "4.4.7" is an ambiguous code
    return $codeinmesg if index($statuscode, '5.3.') == 0;  # "5.3.Z" is an error of a system

    if( $statuscode eq '5.1.1' ) {
        # "5.1.1" is a code of "userunknown"
        return $statuscode if $zeroindex1->{'error'} > 0;
        return $codeinmesg;

    } elsif( $statuscode eq '5.1.3' ) {
        # "5.1.3"
        return $codeinmesg if index($codeinmesg, '5.7.') == 0;
    }
    return $statuscode;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::SMTP::Status - SMTP Enhanced Status Codes related utilities

=head1 SYNOPSIS

    use Sisimai::SMTP::Status;
    print Sisimai::SMTP::Status->code('userunknown');           # '5.0.911'
    print Sisimai::SMTP::Status->name('5.1.2');                 # 'hostunknown'
    print Sisimai::SMTP::Status->find('550 5.1.1 Unknown user');# '5.1.1'

=head1 DESCRIPTION

Sisimai::SMTP::Status is utilities for getting DSN value from error reason text, getting the reason
from DSN value, and getting DSN from the text including DSN.

=head1 CLASS METHODS

=head2 C<B<code(I<reason>,I<temp>)>>

C<code()> returns pseudo DSN value from the specified reason string. The second argument is a flag
for getting pseudo DSN value as a temporary error.

    print Sisimai::SMTP::Status->code('mailboxfull');   # '5.0.922'
    print Sisimai::SMTP::Status->code('mailboxfull',1); # '4.0.922'

=head2 C<B<name(I<D.S.N.>)>>

C<name()> returns a reason string from the specified DSN value.

    print Sisimai::SMTP::Status->name('5.1.6');         # 'hasmoved'
    print Sisimai::SMTP::Status->name('4.2.3');         # 'exceedlimit'

=head2 C<B<test(I<D.S.N.>)>>

C<test()> checks whether a status code is a valid code or not.

    print Sisimai::SMTP::Status->test('5.1.6'); # 1
    print Sisimai::SMTP::Status->test('3.14');  # 0

=head2 C<B<find(I<String>, I<String>)>>

C<find()> returns a DSN value only from the text including DSN

    print Sisimai::SMTP::Status->find('5.0.0');                  # '5.0.0'
    print Sisimai::SMTP::Status->find('550 5.1.1 User unknown'); # '5.1.1'
    print Sisimai::SMTP::Status->find('447 delivery expired');   # ''

=head2 C<B<prefer(I<Code in Status: field>, I<Code in an error message>, [I<Reply code>])>>

C<prefer()> returns the preferred value selected from the arguments.

    print Sisimai::SMTP::Status->prefer("5.2.1", "5.0.0");      # "5.2.1"
    print Sisimai::SMTP::Status->prefer("4.4.7", "5.1.1", 421); # "4.4.7"

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018,2020-2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

