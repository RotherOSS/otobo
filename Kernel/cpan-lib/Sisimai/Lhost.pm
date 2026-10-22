package Sisimai::Lhost;
use v5.26;
use strict;
use warnings;
use Sisimai::RFC5322;

use constant INDICATORS => { 'deliverystatus' => (1 << 1), 'message-rfc822' => (1 << 2) };
use constant BannerDTAG => [
    # smail-3.2.0.108/src/
    #   notify.c:61|static char *log_banner = "\
    #   notify.c:62||------------------------- Message log follows: -------------------------|\n";
    #   notify.c:63|static char *addr_error_banner = "\
    #   notify.c:64||------------------------- Failed addresses follow: ---------------------|\n";
    #   notify.c:65|static char *text_banner = "\
    #   notify.c:66||------------------------- Message text follows: ------------------------|\n";
    "|------------------------- Message log follows: -------------------------|", # 0. Smail 3
    "|------------------------- Failed addresses follow: ---------------------|", # 1. Smail 3
    "|------------------------- Message text follows: ------------------------|", # 2. Smail 3
    "|------------------------- Message header follows: ----------------------|", # 3. Deutsche Telekom
#   "|----------- Message text follows: (body too large, truncated) ----------|", # 4. Deutsche Telekom
];
sub DELIVERYSTATUS {
    # Data structure for decoded bounce messages
    # @private
    # @return [Hash] Data structure for delivery status
    return {
        'spec'         => '',   # Protocl specification
        'date'         => '',   # The value of Last-Attempt-Date header
        'rhost'        => '',   # The value of Remote-MTA header
        'lhost'        => '',   # The value of Received-From-MTA header
        'alias'        => '',   # The value of alias entry(RHS)
        'agent'        => '',   # MTA name
        'action'       => '',   # The value of Action header
        'status'       => '',   # The value of Status header
        'reason'       => '',   # Temporary reason of bounce
        'command'      => '',   # SMTP command in the message body
        'replycode',   => '',   # SMTP Reply Code
        'diagnosis'    => '',   # The value of Diagnostic-Code header
        'recipient'    => '',   # The value of Final-Recipient header
        'feedbacktype' => '',   # Feedback Type
    };
}
sub description { return '' }
sub index {
    # Alphabetical sorted MTA module list
    # @return   [Array] MTA list with order
    return [qw|
        Activehunter AmazonSES ApacheJames Biglobe Courier Domino DeutscheTelekom DragonFly EZweb
        EinsUndEins Exchange2003 Exchange2007 Exim FML GMX GoogleGroups GoogleWorkspace Gmail
        IMailServer KDDI MailFoundry Mimecast MailMarshal MessagingServer Notes OpenSMTPD Postfix
        Sendmail TrendMicro V5sendmail Verizon X1 X2 X3 X6 Zoho mFILTER qmail
    |];
}

sub path {
    # Returns Sisimai::Lhost::* module path table
    # @return   [Hash] Module path table
    # @since    v4.25.6
    my $class = shift;
    my $index = __PACKAGE__->index;
    my $table = {
        'Sisimai::ARF'     => 'Sisimai/ARF.pm',
        'Sisimai::RFC3464' => 'Sisimai/RFC3464.pm',
        'Sisimai::RFC3834' => 'Sisimai/RFC3834.pm',
    };
    $table->{ __PACKAGE__.'::'.$_ } = 'Sisimai/Lhost/'.$_.'.pm' for @$index;
    return $table;
}

sub inquire {
    # Method of a parent class to decode a bounce message of each MTA
    # @param    [Hash] mhead    Message headers of a bounce email
    # @param    [String] mbody  Message body of a bounce email
    # @return   [Hash]          Bounce data list and message/rfc822 part
    # @return   [undef]         failed to decode or the arguments are missing
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Lhost - Base class for Sisimai::Lhost::*

=head1 SYNOPSIS

B<Do not use or require this class directly>, call a class of C<Sisimai::Lhost::*>, such as
C<Sisimai::Lhost::Sendmail>, instead.

=head1 DESCRIPTION

C<Sisimai::Lhost> is a base class for all the MTA modules of C<Sisimai::Lhost::*>.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2021,2025-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

