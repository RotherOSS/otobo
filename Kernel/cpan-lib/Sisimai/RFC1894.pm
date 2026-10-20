package Sisimai::RFC1894;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;
use Sisimai::String;

use constant FIELDINDEX => [qw|
    Action Arrival-Date Diagnostic-Code Final-Recipient Last-Attempt-Date Original-Recipient
    Received-From-MTA Remote-MTA Reporting-MTA Status X-Actual-Recipient X-Original-Message-ID
|];
use constant FIELDTABLE => {
    # Return pairs that a field name and key name defined in Sisimai::Lhost class
    'action'            => 'action',
    'arrival-date'      => 'date',
    'diagnostic-code'   => 'diagnosis',
    'final-recipient'   => 'recipient',
    'last-attempt-date' => 'date',
    'original-recipient'=> 'alias',
    'received-from-mta' => 'lhost',
    'remote-mta'        => 'rhost',
    'reporting-mta'     => 'lhost',
    'status'            => 'status',
    'x-actual-recipient'=> 'alias',
};

sub match {
    # Check the argument matches with a field defined in RFC3464
    # @param    [String] argv0 A line including field and value defined in RFC3464
    # @return   [Integer]      0: did not matched, 1,2: matched
    # @since v4.25.0
    my $class = shift;
    my $argv0 = shift                      || return 0;
    my $label = __PACKAGE__->label($argv0) || return 0;
    my $match = 0;

    state $fieldnames = [
        # https://tools.ietf.org/html/rfc3464#section-2.2
        #   Some fields of a DSN apply to all of the delivery attempts described by that DSN. At
        #   most, these fields may appear once in any DSN. These fields are used to correlate the
        #   DSN with the original message transaction and to provide additional information which
        #   may be useful to gateways.
        #
        #   The following fields (not defined in RFC 3464) are used in Sisimai
        #     - X-Original-Message-ID: <....> (GSuite)
        #
        #   The following fields are not used in Sisimai:
        #     - Original-Envelope-Id
        #     - DSN-Gateway
        {
            'arrival-date'          => ':',
            'received-from-mta'     => ';',
            'reporting-mta'         => ';',
            'x-original-message-id' => '@',
        },

        # https://tools.ietf.org/html/rfc3464#section-2.3
        #   A DSN contains information about attempts to deliver a message to one or more recipi-
        #   ents. The delivery information for any particular recipient is contained in a group of
        #   contiguous per-recipient fields. Each group of per-recipient fields is preceded by a
        #   blank line.
        #
        #   The following fields (not defined in RFC 3464) are used in Sisimai
        #     - X-Actual-Recipient: RFC822; ....
        #
        #   The following fields are not used in Sisimai:
        #     - Will-Retry-Until
        #     - Final-Log-ID
        {
            'action'                => 'e',
            'diagnostic-code'       => ';',
            'final-recipient'       => ';',
            'last-attempt-date'     => ':',
            'original-recipient'    => ';',
            'remote-mta'            => ';',
            'status'                => '.',
            'x-actual-recipient'    => ';',
        },
    ];

    FIELDS0: for my $e ( keys $fieldnames->[0]->%* ) {
        # Per-Message fields
        next unless $label eq $e;
        next unless index($argv0, $fieldnames->[0]->{ $label }) > 1;
        $match = 1; last;
    }
    return $match if $match > 0;

    FIELDS1: for my $e ( keys $fieldnames->[1]->%* ) {
        # Per-Recipient fields
        next unless $label eq $e;
        next unless index($argv0, $fieldnames->[1]->{ $label }) > 1;
        $match = 2; last;
    }
    return $match;
}

sub label {
    # Returns a field name as a label from the given string
    # @param    [String] argv0 A line including field and value defined in RFC3464
    # @return   [String]       Field name as a label
    # @since v4.25.15
    my $class = shift;
    my $argv0 = shift || return "";
    return lc((split(':', $argv0, 2))[0]) || "";
}

sub field {
    # Check the argument is including field defined in RFC3464 and return values
    # @param    [String] argv0 A line including field and value defined in RFC3464
    # @return   [Array]        ['field-name', 'value-type', 'Value', 'field-group']
    # @since v4.25.0
    my $class = shift;
    my $argv0 = shift || return undef;

    state $subtypeset = {"addr" => "RFC822", "cdoe" => "SMTP", "host" => "DNS"};
    state $actionlist = [$Sisimai::Eb::AeFAIL, $Sisimai::Eb::AeSTAY, $Sisimai::Eb::AeSENT,
                         $Sisimai::Eb::AePASS, $Sisimai::Eb::AeEXPN];
    state $correction = {
        'deliverable' => $Sisimai::Eb::AeSENT,
        'expired'     => $Sisimai::Eb::AeFAIL,
        'failure'     => $Sisimai::Eb::AeFAIL,
    };
    state $fieldgroup = {
        'original-recipient'    => 'addr',
        'final-recipient'       => 'addr',
        'x-actual-recipient'    => 'addr',
        'diagnostic-code'       => 'code',
        'arrival-date'          => 'date',
        'last-attempt-date'     => 'date',
        'received-from-mta'     => 'host',
        'remote-mta'            => 'host',
        'reporting-mta'         => 'host',
        'action'                => 'list',
        'status'                => 'stat',
        'x-original-message-id' => 'text',
    };
    state $captureson = {
        "addr" => ["Final-Recipient", "Original-Recipient", "X-Actual-Recipient"],
        "code" => ["Diagnostic-Code"],
        "date" => ["Arrival-Date", "Last-Attempt-Date"],
        "host" => ["Received-From-MTA", "Remote-MTA", "Reporting-MTA"],
        "list" => ["Action"],
        "stat" => ["Status"],
       #"text" => ["X-Original-Message-ID", "Final-Log-ID", "Original-Envelope-ID"],
    };

    my $parts = [split(":", $argv0, 2)]; # ["Final-Recipient", " rfc822; <neko@example.jp>"]
    my $label = __PACKAGE__->label($argv0) || return undef;
    my $group = $fieldgroup->{ $label }    || return undef;
    return undef unless exists $captureson->{ $group };

    # Try to match with each pattern of Per-Message field, Per-Recipient field
    # - 0: Field-Name
    # - 1: Sub Type: RFC822, DNS, X-Unix, and so on)
    # - 2: Value
    # - 3: Field Group(addr, code, date, host, stat, text)
    # - 4: Comment
    my $table = [$label, "", "", $group, ""]; $parts->[1] = Sisimai::String->sweep($parts->[1]);

    if( $group eq 'addr' || $group eq 'code' || $group eq 'host' ) {
        # - Final-Recipient: RFC822; kijitora@nyaan.jp
        # - Diagnostic-Code: SMTP; 550 5.1.1 <kijitora@example.jp>... User Unknown
        # - Remote-MTA: DNS; mx.example.jp
        if( index($parts->[1], ";" ) > 0 ) {
            # There is a valid sub type (including ";")
            my $v = [split(";", $parts->[1], 2)];
            $table->[1] = uc Sisimai::String->sweep($v->[0]) if scalar @$v > 0;
            $table->[2] = Sisimai::String->sweep($v->[1])    if scalar @$v > 1;

        } else {
            # There is no sub type like "Diagnostic-Code: 550 5.1.1 <kijitora@example.jp>..."
            $table->[2] = $parts->[1];
            $table->[1] = $subtypeset->{ $group } || "";
        }
        $table->[2] = lc $table->[2] if $group eq "host";
        $table->[2] = '' if $table->[2] =~ /\A\s+\z/;

    } elsif( $group eq "list" ) {
        # Action: failed
        # Check that the value is an available value defined in "actionlist" or not.
        # When the value is invalid, convert to an available value defined in "correction"
        my $v = lc $parts->[1];
        $table->[2]   = $v if grep { $v eq $_ } @$actionlist;
        $table->[2] ||= $correction->{ $v };

    } else {
        # Other groups such as Status:, Arrival-Date:, or X-Original-Message-ID:.
        # There is no ";" character in the field.
        # - Status: 5.2.2
        # - Arrival-Date: Mon, 21 May 2018 16:09:59 +0900
        $table->[2] = $group eq "date" ? $parts->[1] : lc $parts->[1];
    }

    if( Sisimai::String->aligned(\$table->[2], [" (", ")"]) ) {
        # Extract text enclosed in parentheses as comments
        # Reporting-MTA: dns; mr21p30im-asmtp004.me.example.com (tcp-daemon)
        my $p1 = index($table->[2], " (");
        my $p2 = index($table->[2], ")");
        $table->[4] = substr($table->[2], $p1 + 2, $p2 - $p1 - 2);
        $table->[2] = substr($table->[2], 0, $p1);
    }
    return $table;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::RFC1894 - DSN field defined in RFC3464 (obsoletes RFC1894)

=head1 SYNOPSIS

    use Sisimai::RFC1894;

    print Sisimai::RFC1894->match('From: Nyaan <kijitora@libsisimai.org>'); # 0
    print Sisimai::RFC1894->match('Reporting-MTA: DNS; mx.libsisimai.org'); # 1
    print Sisimai::RFC1894->match('Final-Recipient: RFC822; cat@nyaan.jp'); # 2

    my $v = Sisimai::RFC1894->field('Reporting-MTA: DNS; mx.nyaan.jp');
    my $r = Sisimai::RFC1894->field('Status: 5.1.1 (user unknown)');
    print Data::Dumper::Dumper $v;  # ['reporting-mta', 'dns', 'mx.nyaan.org', 'host', ''];
    print Data::Dumper::Dumper $r;  # ['status', '', '5.1.1', 'stat', 'user unknown'];

=head1 DESCRIPTION

C<Sisimai::RFC1894> provide methods for checking or getting DSN fields

=head1 CLASS METHODS

=head2 C<B<match(I<String>)>>

C<match()> method checks the argument includes the field defined in RFC3464 or not

    print Sisimai::RFC1894->match('From: Nyaan <kijitora@libsisimai.org>'); # 0
    print Sisimai::RFC1894->match('Reporting-MTA: DNS; mx.libsisimai.org'); # 1
    print Sisimai::RFC1894->match('Final-Recipient: RFC822; cat@nyaan.jp'); # 2

=head2 C<B<label(I<String>)>>

C<label()> method returns a lower cased field name such as C<"diagnostic-code"> from the given email
header or the delivery status field.

    print Sisimai::RFC1894->label('Remote-MTA: DNS; mx.nyaan.jp');  # remote-mta
    print Sisimai::RFC1894->field('Status: 5.1.1');                 # status
    print Sisimai::RFC1894->field('Subject: Nyaan');                # subject
    print Sisimai::RFC1894->field('');                              # undef

=head2 C<B<field(I<String>)>>

C<field()> method returns the splited values as an array reference from the given string including
DSN fields defined in RFC3464.

    my $v = Sisimai::RFC1894->field('Remote-MTA: DNS; mx.nyaan.jp');
    my $r = Sisimai::RFC1894->field('Status: 5.1.1');
    print Data::Dumper::Dumper $v;  # ['remote-mta', 'dns', 'mx.nyaan.org', 'host'];
    print Data::Dumper::Dumper $r;  # ['status', '', '5.1.1', 'stat'];

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2018-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

