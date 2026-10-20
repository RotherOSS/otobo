package Sisimai::Rhost::Google;
use feature ':5.10';
use strict;
use warnings;

sub get {
    # Detect bounce reason from Google Workspace
    # @param    [Sisimai::Fact] argvs   Parsed email object
    # @return   [String]                The bounce reason for Google Workspace
    # @see      https://support.google.com/a/answer/3726730?hl=en
    my $class = shift;
    my $argvs = shift // return undef;

    return $argvs->{'reason'} if $argvs->{'reason'};
    return '' unless $argvs->{'diagnosticcode'};
    return '' unless Sisimai::SMTP::Reply->test($argvs->{'replycode'});
    return '' unless Sisimai::SMTP::Status->test($argvs->{'deliverystatus'});

    state $messagesof = {
        'authfailure' => [
            # - 451 4.7.24 The SPF record of the sending domain has one or more suspicious entries.
            #   To protect our users from spam, mail sent from your IP address has been temporarily
            #   rate limited. For more information, go to Email sender guidelines.
            #   https://support.google.com/mail/answer/81126#authentication
            #   
            # - 550 5.7.24 The SPF record of the sending domain has one or more suspicious entries.
            #   For more information, go to Email sender guidelines.
            # - https://support.google.com/mail/answer/81126#authentication
            ['451', '4.7.24', 'the spf record of the sending domain has one or more suspicious entries'],
            ['550', '5.7.24', 'the spf record of the sending domain has one or more suspicious entries'],

            # - 421 4.7.26 This mail has been rate limited because it is unauthenticated.
            #   Gmail requires all senders to authenticate with either SPF or DKIM.
            #   Authentication results: DKIM = did not pass SPF domain-name with ip: ip-address =
            #   did not pass. To resolve this issue, go to Email sender guidelines. 
            # - https://support.google.com/mail/answer/81126#authentication
            ['421', '4.7.26', 'gmail requires all senders to authenticate with either spf or dkim'],
            ['550', '5.7.26', 'gmail requires all senders to authenticate with either spf or dkim'],

            # - 550 5.7.26 This message fails to pass SPF checks for an SPF record with a hard fail
            #   policy (-all). To best protect our users from spam and phishing, the message has
            #   been blocked. Please visit https://support.google.com/mail/answer/81126 for more
            #   information.
            #
            # - 550 5.7.26 The MAIL FROM domain [domain-name] has an SPF record with a hard fail
            #   policy (-all) but it fails to pass SPF checks with the ip: [ip-address]. To best
            #   protect our users from spam and phishing, the message has been blocked. For more
            #   information, go to Email sender guidelines.
            # - https://support.google.com/mail/answer/81126#authentication
            ['550', '5.7.26', 'this message fails to pass spf checks for an spf record with a hard fail'],
            ['550', '5.7.26', 'has an spf record with a hard fail policy'],

            # - 451 4.7.26 Unauthenticated email from domain-name is not accepted due to domain's
            #   DMARC policy, but temporary DNS failures prevent authentication. Please contact the
            #   administrator of domain-name domain if this was a legitimate mail. To learn about
            #   the DMARC initiative, go to https://support.google.com/mail/?p=DmarcRejection
            ['451', '4.7.26', "is not accepted due to domain's dmarc policy"],
            ['550', '5.7.26', "is not accepted due to domain's dmarc policy"],

            # - 550 5.7.26 Unauthenticated email from domain-name is not accepted due to domain's
            #   DMARC policy. Please contact the administrator of domain-name domain. If this was
            #   a legitimate mail please visit [Control unauthenticated mail from your domain] to
            #   learn about the DMARC initiative. If the messages are valid and aren't spam, con-
            #   tact the administrator of the receiving mail server to determine why your outgoing
            #   messages don't pass authentication checks.
            ['550', '5.7.26', "is not accepted due to domain's dmarc policy"],

            # - 550 5.7.26 This message does not have authentication information or fails to pass
            #   authentication checks (SPF or DKIM). To best protect our users from spam, the mes-
            #   sage has been blocked. Please visit https://support.google.com/mail/answer/81126
            #   for more information.
            ['550', '5.7.1',  'fails to pass authentication checks'],
            ['550', '5.7.26', 'fails to pass authentication checks'],

            # - 421 4.7.27 This mail has been rate limited because SPF does not pass.
            #   Gmail requires all large senders to authenticate with SPF. Authentication results:
            #   SPF domain-name with ip: ip-address = did not pass. To resolve this issue, go to
            #   Define your SPF record—Basic setup. https://support.google.com/a/answer/10685031
            ['421', '4.7.27', 'gmail requires all large senders to authenticate with spf'],
            ['550', '5.7.27', 'gmail requires all large senders to authenticate with spf'],

            # - 421 4.7.28 This mail has been rate limited because DKIM does not pass.
            #   Gmail requires all large senders to authenticate with DKIM. Authentication results:
            #   DKIM = did not pass. For instructions on setting up DKIM authentication, go to Turn
            #   on DKIM for your domain. https://support.google.com/a/answer/180504
            ['421', '4.7.28', 'gmail requires all large senders to authenticate with dkim'],
            ['550', '5.7.28', 'gmail requires all large senders to authenticate with dkim'],
        ],
        'badreputation' => [
            # - 421 4.7.0 This message is suspicious due to the very low reputation of the sending
            #   IP address/domain. To protect our users from spam, mail sent from your IP address
            #   has been temporarily rate limited. For more information, go to Why has Gmail blocked
            #   my messages?. https://support.google.com/mail/answer/188131
            ['421', '4.7.0', 'this message is suspicious due to the very low reputation of the sending ip address'],
            ['421', '4.7.0', 'this message is suspicious due to the very low reputation of the sending domain'],

            # - 550 5.7.1 Our system has detected that this message is likely suspicious due to the
            #   very low reputation of the sending IP address/domain. To best protect our users
            #   from spam, the message has been blocked. 
            #   Please visit https://support.google.com/mail/answer/188131 for more information.
            ['550', '5.7.1', 'this message is likely suspicious due to the very low reputation of the sending ip address'],
            ['550', '5.7.1', 'this message is likely suspicious due to the very low reputation of the sending domain'],
        ],
        'blocked' => [
            # - 421 4.7.0 IP not in whitelist for RCPT domain, closing connection.
            #   For more information, go to Allowlists, denylists, and approved senders.
            #   https://support.google.com/a/answer/60752
            ['421', '4.7.0', 'ip not in whitelist for rcpt domain, closing connection.'],

            # - 421 4.7.0 Try again later, closing connection. This usually indicates a Denial of
            #   Service (DoS) for the SMTP relay at the HELO stage.
            #   https://support.google.com/a/answer/3221692
            ['421', '4.7.0', 'try again later, closing connection.'],

            # - 501 5.5.4 HELO/EHLO argument is invalid. https://support.google.com/mail/?p=helo
            ['501', '5.5.4', 'empty helo/ehlo argument not allowed'],
            ['501', '5.5.4', 'helo/ehlo argument is invalid'],

            # - 421 4.7.28 Gmail has detected an unusual rate of unsolicited mail.
            #   (originating from)
            #       - your IP address 192.0.2.25
            #       - your IP Netblock 192.0.2.0/24 (?)
            #       - your DKIM domain example.org
            #       - your SPF domain example.org
            #   (containing one of your URL domains)
            #
            #   To protect our users from spam, mail has been temporarily rate limited. To review
            #   our bulk email senders guidelines, go to Email sender guidelines.
            #   https://support.google.com/mail/?p=UnsolicitedRateLimitError
            ['421', '4.7.0',  'an unusual rate of unsolicited mail'],
            ['421', '4.7.28', 'an unusual rate of unsolicited mail'],

            # - 550 5.7.1 Our system has detected an unusual rate of unsolicited mail originating
            #   from your IP address. To protect our users from spam, mail sent from your IP ad-
            #   dress has been blocked. Review https://support.google.com/mail/answer/81126
            #
            # - 550 5.7.28 There is an unusual rate of unsolicited mail originating from your IP
            #   address. To protect our users from spam, mail sent from your IP address has been
            #   blocked. To review our bulk email senders guidelines, go to Email sender guidelines.
            ['550', '5.7.1',  'an unusual rate of unsolicited mail originating from your ip address'],
            ['550', '5.7.28', 'an unusual rate of unsolicited mail originating from your ip address'],
        ],
        'exceedlimit' => [
            # - 552 5.2.3 Your message exceeded Google's message size limits. For more information,
            #   visit https://support.google.com/mail/answer/6584
            ['552', '5.2.3', "your message exceeded google's message size limits"],

            # - 552 5.3.4 The number of attachments (num-attachments) exceeds Google's limit of
            #   limit attachments. To view our attachment size guidelines, go to Gmail receiving
            #   limits in Google Workspace. https://support.google.com/a/answer/1366776
            #
            # - 552 5.3.4 The size of the <header name> header value (size bytes) exceeds Google's
            #   limit of limit bytes per individual header size. To view our header size guidelines,
            #   go to Gmail message header limits https://support.google.com/a?p=header-limits
            ['552', '5.3.4', "exceeds google's limit of limit attachments."],
            ['552', '5.3.4', "your message exceeded google's message header size limits"],
            ['552', '5.3.4', 'bytes per individual header size'],
            ['552', '5.3.4', "exceeds google’s header name limit of"],
            ['552', '5.3.4', "your message has a subject: header that exceeds google's message header size limit"]
        ],
        'expired' => [
            # - 421 4.7.0 Connection expired, try reconnecting. For more information, go to About
            # SMTP error messages. https://support.google.com/a/answer/3221692
            ['421', '4.7.0', 'connection expired'],

            # - 451 4.4.2 Timeout - closing connection. For more information, go to About SMTP
            #   error messages. https://support.google.com/a/answer/3221692
            ['451', '4.4.2', 'timeout - closing connection'],
        ],
        'mailboxfull' => [
            # - 452 4.2.2 The recipient's inbox is out of storage space.
            #   Please direct the recipient to https://support.google.com/mail/?p=OverQuotaTemp
            # - Please direct the recipient to https://support.google.com/mail/?p=OverQuotaPerm
            ['452', '4.2.2', 'inbox is out of storage space'],
            ['552', '5.2.2', 'inbox is out of storage space and inactive'],

            # - 452 4.2.2 The email account that you tried to reach is over quota. Please direct
            #   the recipient to Clear Google Drive space & increase storage.
            ['452', '4.2.2', 'the email account that you tried to reach is over quota'],
            ['552', '5.2.2', 'the email account that you tried to reach is over quota'],
            ['550', '5.7.1', 'email quota exceeded'],
        ],
        'mesgtoobig' => [
            # - 552 5.3.4 Your message exceeded Google's message size limits. To view our message
            #   size guidelines, go to Send attachments with your Gmail message.
            # - https://support.google.com/mail/?p=MaxSizeError
            ['552', '5.3.4', "your message exceeded google's message size limits"],

            # - 552 5.3.4 The size of your message (size bytes) exceeded Google's message size
            #   limits of limit bytes. To view our message size guidelines, go to Gmail receiving
            #   limits in Google Workspace.
            # - https://support.google.com/mail/?p=MaxSizeError
            ['552', '5.3.4', "exceeds google's message size limit of"],
        ],
        'networkerror' => [
            # - 554 5.4.6 Message exceeded 50 hops, this may indicate a mail loop.
            #   For more information, go to Gmail Help. https://support.google.com/mail/?p=MailLoop
            ['554', '5.4.6', 'message exceeded 50 hops, this may indicate a mail loop'],
            ['554', '5.6.0', 'message exceeded 50 hops, this may indicate a mail loop'],
        ],
        'norelaying' => [
            # - 550 5.7.0 Mail relay denied <ip-address>. Invalid credentials for relay for one of
            #   the domains in: <domain-name> (as obtained from HELO and MAIL FROM). Email is being
            #   sent from a domain or IP address which isn't registered in your Workspace account.
            #   Please login to your Workspace account and verify that your sending device IP
            #   address has been registered within the Workspace SMTP Relay Settings. For more
            #   information, go to SMTP relay service error messages. 
            # - https://support.google.com/a/answer/6140680#maildenied
            ['550', '5.7.0', 'mail relay denied'],

            # - 550 5.7.1 Invalid credentials for relay <ip-address>. The IP address you've
            #   registered in your Workspace SMTP Relay service doesn't match the domain of the
            #   account this email is being sent from. If you are trying to relay mail from a
            #   domain that isn't registered under your Workspace account or has empty
            #   envelope-from:, you must configure your mail server either to use SMTP AUTH to
            #   identify the sending domain or to present one of your domain names in the HELO or
            #   EHLO command. For more information, go to SMTP relay service error messages. 
            # - https://support.google.com/a/answer/6140680#invalidcred
            ['550', '5.7.1', 'invalid credentials for relay'],

            # - 550 7.7.1 The IP you're using to send mail is not authorized to send email directly
            #   to our servers. Use the SMTP relay at your service provider instead. For more
            #   information, go to 'The IP you're using to send email is not authorized...'. 
            # - https://support.google.com/mail/?p=NotAuthorizedError
            ['550', '5.7.1', "the ip you're using to send mail is not authorized to send email directly to our servers"],
        ],
        'notcompliantrfc' => [
            # - 550 5.7.1 Messages missing a valid address in the From: header, or having no From:
            #   header, are not accepted. For more information, go to Email sender guidelines and
            #   review RFC 5322 specifications.
            # - https://support.google.com/mail/?p=RfcMessageNonCompliant
            ['550', '5.7.1', 'messages missing a valid address in the from: header'],
            ['550', '5.7.1', 'messages with multiple addresses in from: header are not accepted'],

            # - 550 5.7.1 This message is not RFC 5322 compliant because it has duplicate headers.
            #   To reduce the amount of spam sent to Gmail, this message has been blocked. For more
            #   information, go to Email sender guidelines and review RFC 5322 specifications.
            # - https://support.google.com/mail/?p=RfcMessageNonCompliant
            ['550', '5.7.1', 'this message is not rfc 5322 compliant'],

            # - 550 5.7.1 Messages missing a valid Message-ID: header are not accepted. For more
            #   information, go to Email sender guidelines and review RFC 5322 specifications.
            # - https://support.google.com/mail/?p=RfcMessageNonCompliant
            ['550', '5.7.1', 'messages missing a valid message-id: header are not accepted'],

            # - 550 5.7.1 The message contains a unicode character in a disallowed header.
            #   To review our message and header content guidelines, go to File types blocked in
            #   Gmail. https://support.google.com/mail/?p=BlockedMessage
            ['550', '5.7.1', 'the message contains a unicode character in a disallowed header'],

            # - 550 5.7.1 Encoded-word syntax is not permitted in message header header-name. To
            #   reduce the amount of spam sent to Gmail, this message has been blocked. For more
            #   information, go to Email sender guidelines and review RFC 5322 specifications.
            # - https://support.google.com/mail/?p=RfcMessageNonCompliant
            ['550', '5.7.1', 'encoded-word syntax is not permitted in message header'],

            # - 553 5.1.7 The sender address address is not a valid RFC 5321 address. For more
            #   information, go to About SMTP error messages and review RFC 5321 specifications.
            # - https://support.google.com/a/answer/3221692
            ['553', '5.1.7', 'is not a valid rfc 5321 address'],

            # - 554 5.6.0 Mail message is malformed. Not accepted. For more information, go to
            #   Email sender guidelines and review RFC 5322 specifications.
            # - https://support.google.com/mail/?p=RfcMessageNonCompliant
            ['554', '5.6.0', 'mail message is malformed. not accepted'],
        ],
        'policyviolation' => [
            # - 552 5.7.0 Our system detected an illegal attachment on your message. Please visit
            #   http://mail.google.com/support/bin/answer.py?answer=6590 to review our attachment
            #   guidelines.
            ['552', '5.7.0', 'detected an illegal attachment on your message'],

            # - 552 5.7.0 This message was blocked because its content presents a potential securi-
            #   ty issue. Please visit https://support.google.com/mail/?p=BlockedMessage to review
            #   our message content and attachment content guidelines.
            ['552', '5.7.0', 'this message was blocked because its content presents a potential security issue'],

            # - 550 5.7.1 The user or domain that you are sending to (or from) has a policy that
            #   prohibited the mail that you sent. Please contact your domain administrator for
            #   further details.
            #   For more information, visit https://support.google.com/a/answer/172179
            ['550', '5.7.1', 'the user or domain that you are sending to (or from) has a policy that prohibited'],

            # - 421 4.7.28 Gmail has detected this message exceeded its quota for sending messages
            #   with the same Message-ID:. To best protect our users, the message has been tempo-
            #   rarily rejected. For more information, go to Why has Gmail blocked my messages?.
            #   https://support.google.com/mail/answer/188131
            ['421', '4.7.28', 'has detected this message exceeded its quota for sending messages with the same message-id:'],
        ],
        'rejected' => [
            # - 550 5.7.0, Mail Sending denied. This error occurs if the sender account is disabled
            #   or not registered within your Google Workspace domain.
            # - https://support.google.com/a/answer/6140680#maildenied
            ['550', '5.7.0', 'mail sending denied'],
            ['550', '5.7.1', 'unauthenticated email is not accepted from this domain'],
        ],
        'requireptr' => [
            # - 550 5.7.1 This message does not meet IPv6 sending guidelines regarding PTR records
            #   and authentication. For more information, go to Email sender guidelines.
            #   https://support.google.com/mail/?p=IPv6AuthError
            ['550', '5.7.1', 'this message does not meet ipv6 sending guidelines regarding ptr records and authentication'],

            # - 421 4.7.0 The IP address sending this message does not have a PTR record, or the
            #   corresponding forward DNS entry does not point to the sending IP. To protect our
            #   users from spam, mail sent from your IP address has been temporarily rate limited.
            #   For more information, go to Email sender guidelines.
            #
            # - 550 5.7.25 The IP address sending this message does not have a PTR record setup, or
            #   the corresponding forward DNS entry does not point to the sending IP. As a policy,
            #   Gmail does not accept messages from IPs with missing PTR records.
            #   For more information, go to Email sender guidelines.
            # - https://support.google.com/mail/answer/81126#ip-practices
            #
            # - 550 5.7.25 The sending IP does not match the IP address of the hostname specified
            #   in the pointer (PTR) record. For more information, go to Email sender guidelines.
            # - https://support.google.com/mail/answer/81126#ip-practices
            ['421', '4.7.0',  'the ip address sending this message does not have a ptr record'],
            ['550', '5.7.25', 'the ip address sending this message does not have a ptr record'],
            ['550', '5.7.25', 'the sending ip does not match the ip address of the hostname'],
        ],
        'securityerror' => [
            # - 421 4.7.0 TLS required for RCPT domain, closing connection. For more information,
            #   go to Email encryption in transit. https://support.google.com/mail/answer/6330403
            #
            # - 454 4.7.0 Too many login attempts, please try again later. For more information, go
            #   to Add Gmail to another email client. https://support.google.com/mail/answer/7126229
            ['421', '4.7.0', 'tls required for rcpt domain, closing connection'],
            ['454', '4.7.0', 'too many login attempts'],

            # - 503 5.7.0 No identity changes permitted. For more information, go to About SMTP
            #   error messages.
            ['501', '5.5.2', 'cannot decode response'],   # 2FA related error, maybe.
            ['503', '5.7.0', 'no identity changes permitted'],

            # - 530 5.5.1 Authentication Required. For more information, visit
            #   https://support.google.com/accounts/troubleshooter/2402620
            # - https://support.google.com/mail/?p=WantAuthError
            ['530', '5.5.1', 'authentication required.'],
            ['530', '5.7.0', 'authentication required.'],

            # - 535 5.7.1 Application-specific password required.
            #   For more information, visit https://support.google.com/accounts/answer/185833
            ['535', '5.7.1', 'application-specific password required'],
            ['535', '5.7.9', 'application-specific password required'],

            # - 535 5.7.1 Please log in with your web browser and then try again. For more infor-
            #   mation, visit https://support.google.com/mail/bin/accounts/answer/78754
            ['535', '5.7.1',  'please log in with your web browser and then try again'],
            ['534', '5.7.9',  'please log in with your web browser and then try again'],
            ['534', '5.7.14', 'please log in through your web browser and then try again'],

            # - 535 5.7.1 Username and Password not accepted. For more information, visit 
            #   https://support.google.com/accounts/troubleshooter/2402620
            ['535', '5.7.1', 'username and password not accepted'],
            ['535', '5.7.8', 'username and password not accepted'],

            # - 421 4.7.29 This mail has been rate limited because TLS wasn't used. Gmail requires
            #   all large senders to use TLS/SSL during SMTP. For instructions on using TLS, go to
            #   TLS & SSL connections. https://support.google.com/a/answer/100181
            ['421', '4.7.29', 'gmail requires all large senders to use tls/ssl during smtp'],
        ],
        'spamdetected' => [
            # - 421 4.7.0 This message is suspicious due to the nature of the content or the links
            #   within. To best protect our users from spam, the message has been blocked. For more
            #   information, go to Why has Gmail blocked my messages?.
            #   https://support.google.com/mail/answer/188131
            ['421', '4.7.0', 'this message is suspicious due to the nature of the content or the links within'],

            # - 550 5.7.1 Our system has detected that this message is likely unsolicited mail. To
            #   reduce the amount of spam sent to Gmail, this message has been blocked.
            #   For more information, visit https://support.google.com/mail/answer/188131
            # - https://support.google.com/mail/?p=UnsolicitedMessageError
            ['550', '5.7.1', 'this message is likely unsolicited mail'],
        ],
        'speeding' => [
            # - 450 4.2.1 The user you are trying to contact is receiving mail too quickly. Please
            #   resend your message at a later time. If the user is able to receive mail at that
            #   time, your message will be delivered. 
            #   For more information, visit https://support.google.com/mail/answer/22839
            #
            # - 450 4.2.1 Peak SMTP relay limit exceeded for customer. This is a temporary error.
            #   For more information on SMTP relay limits, please contact your administrator or
            #   visit https://support.google.com/a/answer/6140680
            ['450', '4.2.1', 'is receiving mail too quickly'],
            ['450', '4.2.1', 'peak smtp relay limit exceeded for customer'],

            # - 450 4.2.1 The user you are trying to contact is receiving mail at a rate that pre-
            #   vents additional messages from being delivered. Please resend your message at a
            #   later time. If the user is able to receive mail at that time, your message will be
            #   delivered. For more information, visit https://support.google.com/mail/answer/6592
            # - https://support.google.com/mail/?p=ReceivingRatePerm
            ['450', '4.2.1', 'is receiving mail at a rate that prevents additional messages from being delivered'],
            ['550', '5.2.1', 'is receiving mail at a rate that prevents additional messages from being delivered'],

            # - 550 5.4.5 Daily SMTP relay limit exceeded for user. For more information on SMTP
            #   relay sending limits please contact your administrator or visit SMTP relay service
            #   error messages.
            #   https://support.google.com/a/answer/6140680
            # - https://support.google.com/a/answer/166852
            ['550', '5.4.5', 'daily sending quota exceeded'],
            ['550', '5.4.5', 'daily user sending limit exceeded'],
            ['550', '5.4.5', 'daily smtp relay limit exceeded for'],
            ['550', '5.7.1', 'daily smtp relay limit exceeded for'],
            ['550', '5.7.1', 'daily smtp relay sending limit exceeded for'],
            ['550', '5.7.1', 'this mail has been rate limited'],
        ],
        'suspend' => [
            # - 550 5.2.1 The email account that you tried to reach is inactive.
            #   For more information, go to https://support.google.com/mail/?p=DisabledUser
            ['550', '5.2.1', 'the email account that you tried to reach is disabled'],
            ['550', '5.2.1', 'the email account that you tried to reach is inactive'],
        ],
        'syntaxerror' => [
            # - 523 5.7.10 SMTP protocol violation, no commands allowed to pipeline after STARTTLS.
            #   For more information, go to About SMTP error messages and review RFC 3207
            #   specifications.
            ['451', '4.5.0',  'smtp protocol violation'],
            ['454', '4.5.0',  'smtp protocol violation, no commands allowed to pipeline after starttls'],
            ['525', '5.7.10', 'smtp protocol violation, no commands allowed to pipeline after starttls'],
            ['535', '5.5.4',  'optional argument not permitted for that auth mode'],
            ['454', '5.5.1',  'starttls may not be repeated'],

            # - 501 5.5.2 Syntax error, cannot decode response. For more information, go to About
            #   SMTP error messages.
            # - https://support.google.com/a/answer/3221692
            # - 501 5.7.11 Syntax error (no parameters allowed). For more information, go to About
            #   SMTP error messages and review RFC 3207 specifications.
            ['501', '5.7.11', 'syntax error'],
            ['501', '5.5.2',  'syntax error'],
            ['555', '5.5.2',  'syntax error'],

            # - 503 5.5.1 Bad sequence of commands. For more information, go to About SMTP error
            #   messages and review RFC 5321 specifications.
            # - https://support.google.com/mail/?p=helo
            #
            # - 503 5.5.1 No DATA after BDAT. A mail transaction protocol command was issued out of
            #   sequence. For more information, go to About SMTP error messages and review RFC 3030
            #   specifications.
            # - https://support.google.com/a/answer/3221692
            ['502', '5.5.1', 'too many unrecognized commands, goodbye'],
            ['502', '5.5.1', 'unimplemented command'],
            ['502', '5.5.1', 'unrecognized command'],
            ['503', '5.5.1', 'bad sequence of commands'],
            ['503', '5.5.1', 'ehlo/helo first'],
            ['503', '5.5.1', 'mail first'],
            ['503', '5.5.1', 'rcpt first'],
            ['503', '5.5.1', 'no data after bdat'],
            ['504', '5.7.4', 'unrecognized authentication type'],
            ['504', '5.7.4', 'xoauth is no longer supported'],

            # - 530 5.7.0 Must issue a STARTTLS command first. For more information, go to About
            #   SMTP error messages and review RFC 3207 specifications.
            ['530', '5.7.0', 'must issue a starttls command first'],
            ['554', '5.7.0', 'too many unauthenticated commands'],
        ],
        'systemerror' => [
            # About SMTP error messages, https://support.google.com/a/answer/3221692
            ['421', '4.3.0', 'temporary system problem'],
            ['421', '4.7.0', 'temporary system problem'],
            ['421', '4.4.5', 'server busy'],

            # - 451 4.3.0 Multiple destination domains per transaction is unsupported. Please try
            #   again. For more information, go to About SMTP error messages and review RFC 5321
            #   specifications. https://support.google.com/a/answer/3221692
            ['451', '4.3.0', 'multiple destination domains per transaction is unsupported'],
            ['451', '4.3.0', 'mail server has temporarily rejected this message'],
            ['451', '4.3.0', 'mail server temporarily rejected message'],

            # - 452 4.5.3 Domain policy size per transaction exceeded, please try this recipient in
            #   a separate transaction. This message means the email policy size (size of policies,
            #   number of policies, or both) for the recipient domain has been exceeded.
            #   https://support.google.com/a/answer/7282433
            ['452', '4.5.3', 'domain policy size per transaction exceeded'],

            # - 454 4.7.0 Cannot authenticate due to a temporary system problem. Try again later.
            #   For more information, go to About SMTP error messages.
            #   https://support.google.com/a/answer/3221692
            ['454', '4.7.0', 'cannot authenticate due to temporary system problem'],
        ],
        'toomanyconn' => [
            # - 452 4.5.3 Your message has too many recipients. For more information regarding
            #   Google's sending limits, visit https://support.google.com/mail/answer/6592
            #   https://support.google.com/mail/?p=TooManyRecipientsError
            ['452', '4.5.3', 'your message has too many recipients'],
            ['550', '5.5.3', 'too many recipients for this sender'],
        ],
        'userunknown' => [
            # - 550 5.1.1 The email account that you tried to reach does not exist. Please try dou-
            #   ble-checking the recipient's email address for typos or unnecessary spaces.
            #   For more information, visit https://support.google.com/mail/answer/6596
            # - https://support.google.com/mail/?p=NoSuchUser
            ['550', '5.1.1', 'the email account that you tried to reach does not exist'],

            # - 553 5.1.2 We weren't able to find the recipient domain. Please check for any spell-
            #   ing errors, and make sure you didn't enter any spaces, periods, or other punctua-
            #   tion after the recipient's email address.
            # - https://support.google.com/mail/?p=BadRcptDomain
            ['553', '5.1.2', "we weren't able to find the recipient domain"],

            # - 553 5.1.3 The recipient address <address> is not a valid RFC 5321 address. For more
            #   information, go to About SMTP error messages and review RFC 5321 specifications.
            # - https://support.google.com/a/answer/3221692
            ['553', '5.1.3', 'is not a valid rfc 5321 address'],
        ],
    };

    my $statuscode = substr($argvs->{'deliverystatus'}, 2); # 421   => 21
    my $esmtpreply = substr($argvs->{'replycode'}, 1, 2);   # 5.7.1 => 7.1
    my $issuedcode = lc $argvs->{'diagnosticcode'};
    my $reasontext = '';

    REASON: for my $e ( keys %$messagesof ) {
        # Each key is a reason name
        for my $f ( $messagesof->{ $e }->@* ) {
            # Try to match an SMTP reply code, a D.S.N., and an error message
            next unless index($issuedcode, $f->[2]) > -1;
            next unless index($f->[0], $esmtpreply) >  0;
            next unless index($f->[1], $statuscode) >  1;
            $reasontext = $e;
            last REASON;
        }
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::Google - Detect the bounce reason returned from Google Workspace.

=head1 SYNOPSIS

    use Sisimai::Rhost;

=head1 DESCRIPTION

Sisimai::Rhost detects the bounce reason from the content of Sisimai::Fact object as an argument
of get() method when the value of C<rhost> of the object is "aspmx.l.google.com". This class is
called only Sisimai::Fact class.

=head1 CLASS METHODS

=head2 C<B<get(I<Sisimai::Fact Object>)>>

C<get()> detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018-2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
