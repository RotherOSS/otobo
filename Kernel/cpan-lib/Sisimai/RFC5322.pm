package Sisimai::RFC5322;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::String;
use Sisimai::Address;
use constant HEADERTABLE => {
    'messageid' => ['message-id'],
    'subject'   => ['subject'],
    'listid'    => ['list-id'],
    'date'      => [qw|date posted-date posted resent-date|],
    'addresser' => [qw|from return-path reply-to errors-to reverse-path x-postfix-sender envelope-from x-envelope-from|],
    'recipient' => [qw|to delivered-to forward-path envelope-to x-envelope-to resent-to apparently-to|],
};

my $HEADERINDEX = {};
BUILD_FLATTEN_RFC822HEADER_LIST: {
    # Convert $HEADER: hash reference to flatten hash reference for being called from Sisimai::Lhost::*
    for my $v ( values HEADERTABLE()->%* ) {
        $HEADERINDEX->{ $_ } = 1 for @$v;
    }
}

sub FIELDINDEX {
    return [qw|
        Resent-Date From Sender Reply-To To Message-ID Subject Return-Path Received Date X-Mailer
        Content-Type Content-Transfer-Encoding Content-Description Content-Disposition
    |];
    # The following fields are not referred in Sisimai
    #   Resent-From Resent-Sender Resent-Cc Cc Bcc Resent-Bcc In-Reply-To References
    #   Comments Keywords
}

sub HEADERFIELDS {
    # Grouped RFC822 headers
    # @param    [String] group  RFC822 Header group name
    # @return   [Array,Hash]    RFC822 Header list
    my $class = shift;
    my $group = shift || return $HEADERINDEX;
    return HEADERTABLE->{ $group } if exists HEADERTABLE->{ $group };
    return HEADERTABLE;
}

sub LONGFIELDS {
    # Fields that might be long
    # @return   [Hash] Long filed(email header) list
    return { 'to' => 1, 'from' => 1, 'subject' => 1, 'message-id' => 1 };
}

sub received {
    # Convert Received headers to a structured data
    # @param    [String] argv1  Received header
    # @return   [Array]         Each item in the Received header order by the following:
    #                           0: (from)   "hostname"
    #                           1: (by)     "hostname"
    #                           2: (via)    "protocol/tcp"
    #                           3: (with)   "protocol/smtp"
    #                           4: (id)     "queue-id"
    #                           5: (for)    "envelope-to address"
    my $class = shift;
    my $argv1 = shift || return [];

    # Received: (qmail 10000 invoked by uid 999); 24 Apr 2013 00:00:00 +0900
    return [] if ref $argv1;
    return [] if index($argv1, ' invoked by uid')       > 0;
    return [] if index($argv1, ' invoked from network') > 0;

    # - https://datatracker.ietf.org/doc/html/rfc5322
    #   received        =   "Received:" *received-token ";" date-time CRLF
    #   received-token  =   word / angle-addr / addr-spec / domain
    #
    # - Appendix A.4. Message with Trace Fields
    #   Received:
    #       from x.y.test
    #       by example.net
    #       via TCP
    #       with ESMTP
    #       id ABC12345
    #       for <mary@example.net>;  21 Nov 1997 10:05:43 -0600
    my $recvd = [split(' ', $argv1)];
    my $label = [qw|from by via with id for|];
    my $token = {};
    my $other = [];
    my $alter = [];
    my $right = 0;
    my $range = scalar @$recvd;
    my $index = -1;

    for my $e ( @$recvd ) {
        # Look up each label defined in $label from Received header
        last unless ++$index < $range; my $f = lc $e;
        next unless grep { $f eq $_ } @$label;

        $token->{ $f } =  $recvd->[$index + 1] || next;
        $token->{ $f } =  lc $token->{ $f };
        $token->{ $f } =~ y/();//d;

        next unless $f eq 'from';
        last unless $index + 2 < $range;
        next unless index($recvd->[$index + 2], '(') == 0;

        # Get and keep a hostname in the comment as follows:
        # from mx1.example.com (c213502.kyoto.example.ne.jp [192.0.2.135]) by mx.example.jp (V8/cf)
        # [
        #   "from",                         # index + 0
        #   "mx1.example.com",              # index + 1
        #   "(c213502.kyoto.example.ne.jp", # index + 2
        #   "[192.0.2.135])",               # index + 3
        #   "by",
        #   "mx.example.jp",
        #   "(V8/cf)",
        #   ...
        # ]
        # The 2nd element after the current element is NOT a continuation of the current element
        # such as "(c213502.kyoto.example.ne.jp)"
        push @$other, $recvd->[$index + 2]; $other->[0] =~ y/();//d;

        # The 2nd element after the current element is a continuation of the current element.
        # such as "(c213502.kyoto.example.ne.jp", "[192.0.2.135])"
        last unless $index + 3 < $range;
        push @$other, $recvd->[$index + 3];
        $other->[1] =~ y/();//d;
    }

    for my $e ( @$other ) {
        # Check alternatives in $other, and then delete uninformative values.
        next unless $e;
        next if length $e < 4;
        next if $e eq 'unknown';
        next if $e eq 'localhost';
        next if $e eq '[127.0.0.1]';
        next if $e eq '[IPv6:::1]';
        next if index($e, '.') == -1;
        next if index($e, '=') >   1;
        push @$alter, $e;
    }

    for my $e ('from', 'by') {
        # Remove square brackets from the IP address such as "[192.0.2.25]"
        next unless defined $token->{ $e };
        next unless length  $token->{ $e };
        next unless index($token->{ $e }, '[') == 0;
        $token->{ $e } = shift Sisimai::String->ipv4($token->{ $e })->@* || '';
    }

    $token->{'from'} ||= '';
    while(1) {
        # Prefer hostnames over IP addresses, except for localhost.localdomain and similar.
        last if $token->{'from'} eq 'localhost';
        last if $token->{'from'} eq 'localhost.localdomain';
        last if index($token->{'from'}, '.') < 0;   # A hostname without a domain name
        last if scalar Sisimai::String->ipv4($token->{'from'})->@*;

        # No need to rewrite $token->{'from'}
        $right = 1;
        last;
    }
    while(1) {
        # Try to rewrite uninformative hostnames and IP addresses in $token->{'from'}
        last if $right;                 # There is no need to rewrite
        last if scalar @$alter == 0;    # There is no alternative to rewriting
        last if index($alter->[0], $token->{'from'}) > -1;

        if( index($token->{'from'}, 'localhost') == 0 ) {
            # localhost or localhost.localdomain
            $token->{'from'} = $alter->[0];

        } elsif( index($token->{'from'}, '.') == -1 ) {
            # A hostname without a domain name such as "mail", "mx", or "mbox"
            $token->{'from'} = $alter->[0] if index($alter->[0], '.') > 0;

        } else {
            # An IPv4 address
            $token->{'from'} = $alter->[0];
        }
        last;
    }

    delete $token->{'by'}   unless defined $token->{'by'};
    delete $token->{'from'} unless defined $token->{'from'};
    $token->{'for'} = Sisimai::Address->s3s4($token->{'for'}) if exists $token->{'for'};
    for my $e ( keys %$token ) {
        # Delete an invalid value
        $token->{ $e } =  '' if index($token->{ $e }, ' ') > -1;
        $token->{ $e } =~ y/[]//d;  # Remove "[]" from the IP address
    }

    return [
        $token->{'from'} || '',
        $token->{'by'}   || '',
        $token->{'via'}  || '',
        $token->{'with'} || '',
        $token->{'id'}   || '',
        $token->{'for'}  || '',
    ];
}

sub part {
    # Split given entire message body into error message lines and the original message part only
    # include email headers
    # @param    [String] email  Entire message body
    # @param    [Array]  cutby  List of strings which is a boundary of the original message part
    # @param    [Bool]   keeps  Flag for keeping strings after "\n\n"
    # @return   [Array]         [Error message lines, The original message]
    # @since    v5.0.0
    my $class = shift;
    my $email = shift || return undef;
    my $cutby = shift || return undef;
    my $keeps = shift // 0;

    my $boundaryor = '';    # A boundary string divides the error message part and the original message part
    my $positionor = -1;    # A Position of the boundary string
    my $formerpart = '';    # The error message part
    my $latterpart = '';    # The original message part

    for my $e ( @$cutby ) {
        # Find a boundary string(2nd argument) from the 1st argument
        $positionor = index($$email, $e); next if $positionor == -1;
        $boundaryor = $e;
        last;
    }

    if( $positionor > 0 ) {
        # There is the boundary string in the message body
        $formerpart = substr($$email, 0, $positionor);
        $latterpart = substr($$email, ($positionor + length($boundaryor) + 1), ) || '';

    } else {
        # Substitute the entire message to the former part when the boundary string is not included
        # the $$email
        $formerpart = $$email;
        $latterpart = '';
    } 

    if( length $latterpart > 0 ) {
        # Remove blank lines, the message body of the original message, and append "\n" at the end
        # of the original message headers
        # 1. Remove leading blank lines
        # 2. Remove text after the first blank line: \n\n
        # 3. Append "\n" at the end of test block when the last character is not "\n"
        $latterpart =~ s/\A[\r\n\s]+//m;
        if( $keeps == 0 ) {
            # Remove text after the first blank line: \n\n when $keeps is 0
            substr($latterpart, index($latterpart, "\n\n") + 1, length($latterpart), '') if index($latterpart, "\n\n");
        }
        $latterpart .= "\n" unless substr($latterpart, -1, 1) eq "\n";
    }
    return [$formerpart, $latterpart];
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::RFC5322 - Email address related utilities

=head1 SYNOPSIS

    use Sisimai::RFC5322;

=head1 DESCRIPTION

Sisimai::RFC5322 provide methods for checking email address.

=head1 CLASS METHODS

=head2 C<B<received(I<String>)>>

C<received()> returns array reference including elements in the Received header.

    my $v = 'from mx.example.org (c1.example.org [192.0.2.1]) by neko.libsisimai.org
             with ESMTP id neko20180202nyaan for <michitsuna@nyaan.jp>; ...';
    my $r = Sisimai::RFC5322->received($v);

    warn Dumper $r;
    $VAR1 = [
          'mx.example.org',
          'neko.libsisimai.org',
          '',
          'ESMTP',
          'neko20180202nyaan',
          'michitsuna@nyaan.jp'
        ];

=head2 C<B<part(I<String>, I<Array>)>>

C<part()> returns array reference which include error message lines of given message body and the
original message part split by the 2nd argument.

    my $v = 'Error message here
    Content-Type: message/rfc822
    Return-Path: <neko@libsisimai.org>';
    my $r = Sisimai::RFC5322->part(\$v, ['Content-Type: message/rfc822']);

    warn Dumper $r;
    $VAR1 = [
        'Error message here',
        'Return-Path: <neko@libsisimai.org>';
    ];

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2024 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
