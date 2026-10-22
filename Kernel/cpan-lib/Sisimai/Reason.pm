package Sisimai::Reason;
use v5.26;
use strict;
use warnings;
use Sisimai::Eb;

my $ModulePath = __PACKAGE__->path;
my $GetRetried = __PACKAGE__->retry;
my $ClassOrder = [
    # 0. true() meethod in the following reasons are called from Reason->find()
    [$Sisimai::Eb::ReFULL, $Sisimai::Eb::ReSIZE, $Sisimai::Eb::ReQUIT, $Sisimai::Eb::ReMOVE, $Sisimai::Eb::RePASS,
     $Sisimai::Eb::ReAUTH, $Sisimai::Eb::ReUSER, $Sisimai::Eb::ReFILT, $Sisimai::Eb::ReQPTR, $Sisimai::Eb::ReNRFC,
     $Sisimai::Eb::ReFAMA, $Sisimai::Eb::ReBODY, $Sisimai::Eb::ReFROM, $Sisimai::Eb::ReHOST, $Sisimai::Eb::ReSPAM,
     $Sisimai::Eb::ReRATE, $Sisimai::Eb::ReBLOC, $Sisimai::Eb::ReTTLS, $Sisimai::Eb::Re00MX, $Sisimai::Eb::ReEXEC,
     $Sisimai::Eb::ReWONT],

    # 1. match() method in the following reasons are called from Sisimai::Reason->find()
    [$Sisimai::Eb::ReFULL, $Sisimai::Eb::ReSPAM, $Sisimai::Eb::ReEXEC, $Sisimai::Eb::RePASS, $Sisimai::Eb::RePROC,
     $Sisimai::Eb::ReINET, $Sisimai::Eb::ReQUIT, $Sisimai::Eb::ReDISK, $Sisimai::Eb::ReSTOP, $Sisimai::Eb::ReUNIX,
     $Sisimai::Eb::ReSAFE, $Sisimai::Eb::ReWONT, $Sisimai::Eb::ReCOMM, $Sisimai::Eb::ReTIME],

    [$Sisimai::Eb::ReFULL, $Sisimai::Eb::ReSIZE, $Sisimai::Eb::ReQUIT, $Sisimai::Eb::ReUSER, $Sisimai::Eb::ReFILT,
     $Sisimai::Eb::ReFROM, $Sisimai::Eb::ReHOST, $Sisimai::Eb::ReSPAM, $Sisimai::Eb::ReRATE, $Sisimai::Eb::ReBLOC,
     $Sisimai::Eb::ReAUTH, $Sisimai::Eb::ReTTLS, $Sisimai::Eb::ReSAFE, $Sisimai::Eb::RePROC, $Sisimai::Eb::ReINET,
     $Sisimai::Eb::ReTIME, $Sisimai::Eb::ReBODY, $Sisimai::Eb::ReMOVE, $Sisimai::Eb::ReDISK, $Sisimai::Eb::Re00MX,
     $Sisimai::Eb::ReUNIX, $Sisimai::Eb::RePASS, $Sisimai::Eb::ReSTOP, $Sisimai::Eb::ReCOMM, $Sisimai::Eb::Re___1],
];

sub retry {
    # Reason list better to retry detecting an error reason
    # @return   [Hash] Reason list
    return {
        $Sisimai::Eb::Re___0 => 1, $Sisimai::Eb::Re___1 => 1, $Sisimai::Eb::RePROC => 1, $Sisimai::Eb::ReSAFE => 1,
        $Sisimai::Eb::ReTIME => 1, $Sisimai::Eb::ReINET => 1, $Sisimai::Eb::ReHOST => 1, $Sisimai::Eb::ReUSER => 1,
    };
}

sub is_explicit {
    # is_explicit() returns 0 when the argument is empty or is "Undefined" or is "OnHold"
    # @param    string argv1  Reason name
    # @return   bool          false: The reaosn is not explicit
    my $class = shift;
    my $argv1 = shift || return 0;

    return 0 if $argv1 eq $Sisimai::Eb::Re___0 || $argv1 eq $Sisimai::Eb::Re___1 || $argv1 eq "";
    return 1;
}

sub index {
    # All the error reason list Sisimai support
    # @return   [Array] Reason list
    return [
        $Sisimai::Eb::ReAUTH, $Sisimai::Eb::ReFAMA, $Sisimai::Eb::ReBLOC, $Sisimai::Eb::ReBODY, $Sisimai::Eb::ReSENT,
        $Sisimai::Eb::ReSIZE, $Sisimai::Eb::ReTIME, $Sisimai::Eb::ReTTLS, $Sisimai::Eb::ReFEED, $Sisimai::Eb::ReFILT,
        $Sisimai::Eb::ReMOVE, $Sisimai::Eb::ReHOST, $Sisimai::Eb::ReFULL, $Sisimai::Eb::ReUNIX, $Sisimai::Eb::ReINET,
        $Sisimai::Eb::RePASS, $Sisimai::Eb::Re00MX, $Sisimai::Eb::ReNRFC, $Sisimai::Eb::Re___1, $Sisimai::Eb::ReWONT,
        $Sisimai::Eb::ReFROM, $Sisimai::Eb::ReQPTR, $Sisimai::Eb::ReRATE, $Sisimai::Eb::ReSAFE, $Sisimai::Eb::ReSPAM,
        $Sisimai::Eb::ReSTOP, $Sisimai::Eb::ReQUIT, $Sisimai::Eb::ReCOMM, $Sisimai::Eb::RePROC, $Sisimai::Eb::ReDISK,
        $Sisimai::Eb::ReUSER, $Sisimai::Eb::ReAWAY, $Sisimai::Eb::ReEXEC,
    ];
}

sub path {
    # Returns Sisimai::Reason::* module path table
    # @return   [Hash] Module path table
    # @since    v4.25.6
    my $class = shift;
    my $index = __PACKAGE__->index;
    my $table = {}; $table->{ __PACKAGE__.'::'.$_ } = 'Sisimai/Reason/'.$_.'.pm' for @$index;
    return $table;
}

sub find {
    # Detect the bounce reason
    # @param    [Hash]   argvs  Decoded email object
    # @return   [String]        Bounce reason or an empty string if the argument is missing or not HASH
    # @see anotherone
    my $class = shift;
    my $argvs = shift // return "";

    # Return a reason text already decided except a reason matched with the regular expression of
    # Sisimai::Reason->retry() method.
    return $argvs->{'reason'}   if( (not exists $GetRetried->{ $argvs->{'reason'} }) && $argvs->{'reason'} );
    return $Sisimai::Eb::ReSENT if substr($argvs->{'deliverystatus'}, 0, 2) eq '2.';

    my $reasontext = '';
    my $issuedcode = $argvs->{'diagnosticcode'} || '';
    my $codeformat = $argvs->{'diagnostictype'} || '';
    if( $codeformat eq 'SMTP' || $codeformat eq '' ) {
        # Diagnostic-Code: SMTP; ... or empty value
        for my $e ( $ClassOrder->[0]->@* ) {
            # Check the values of Diagnostic-Code: and Status: fields using true() method of each
            # child class in Sisimai::Reason
            my $p = 'Sisimai::Reason::'.$e;
            require $ModulePath->{ $p };

            next unless $p->true($argvs);
            $reasontext = $p->text;
            last;
        }
    }

    if( not $reasontext || $reasontext eq $Sisimai::Eb::Re___0 ) {
        # Bounce reason is not detected yet.
        $reasontext   = __PACKAGE__->anotherone($argvs);
        $reasontext   = '' if $reasontext eq $Sisimai::Eb::Re___0;
        $reasontext ||= $Sisiimai::Eb::ReTIME if $argvs->{'action'} eq $Sisimai::Eb::AeSTAY;
        return $reasontext if $reasontext;

        # Try to match with message patterns in Sisimai::Reason::Vacation
        require Sisimai::Reason::Vacation;
        $reasontext   = $Sisimai::Eb::ReAWAY if Sisimai::Reason::Vacation->match(lc $issuedcode);
        $reasontext ||= $Sisimai::Eb::Re___1 if $issuedcode;
        $reasontext ||= $Sisimai::Eb::Re___0;
    }
    return $reasontext;
}

sub anotherone {
    # Detect the other bounce reason, fall back method for find()
    # @param    [Hash] argvs    Decoded email structure
    # @return   [String]        Bounce reason or an empty string if the argument is missing or not HASH
    # @see      find()
    my $class = shift;
    my $argvs = shift // return ""; return $argvs->{'reason'} if $argvs->{'reason'};

    require Sisimai::SMTP::Status;
    my $issuedcode = lc $argvs->{'diagnosticcode'} // '';
    my $codeformat = $argvs->{'diagnostictype'}    // '';
    my $actiontext = $argvs->{'action'}            // '';
    my $statuscode = $argvs->{'deliverystatus'}    // '';
    my $reasontext = Sisimai::SMTP::Status->name($statuscode) || '';
    my $trytomatch = $reasontext eq '' ? 1 : 0;
       $trytomatch = 1 if exists $GetRetried->{ $reasontext } || $codeformat ne 'SMTP';

    while($trytomatch) {
        # Could not decide the reason by the value of Status:
        for my $e ( $ClassOrder->[1]->@* ) {
            # Trying to match with other patterns in Sisimai::Reason::* classes
            my $p = 'Sisimai::Reason::'.$e;
            require $ModulePath->{ $p };

            next unless $p->match($issuedcode);
            $reasontext = $e;
            last;
        }
        last if $reasontext;

        # Check the value of Status:
        my $code2digit = substr($statuscode, 0, 3) || '';
        if( $code2digit eq '5.6' || $code2digit eq '4.6' ) {
            #  X.6.0   Other or undefined media error
            $reasontext = $Sisimai::Eb::ReBODY;

        } elsif( $code2digit eq '5.7' || $code2digit eq '4.7' ) {
            #  X.7.0   Other or undefined security status
            $reasontext = $Sisimai::Eb::ReSAFE;

        } elsif( CORE::index($codeformat, 'X-UNIX') == 0 ) {
            # Diagnostic-Code: X-UNIX; ..., X-Postfix, or other X-*
            $reasontext = $Sisimai::Eb::ReUNIX;

        } else {
            # 50X Syntax Error?
            require Sisimai::Reason::SyntaxError;
            $reasontext = $Sisimai::Eb::ReCOMM if Sisimai::Reason::SyntaxError->true($argvs);
        }
        last if $reasontext;

        # Check the value of Action: field, first
        if( CORE::index($actiontext, $Sisimai::Eb::AeSTAY) == 0 || CORE::index($actiontext, 'expired') == 0 ) {
            # Action: delayed, expired
            $reasontext = $Sisimai::Eb::ReTIME;

        } else {
            # Check the value of SMTP command
            my $thecommand = $argvs->{'command'} // '';
            if( $thecommand eq $Sisimai::Eb::CeEHLO || $thecommand eq $Sisimai::Eb::CeHELO ) {
                # Rejected at connection or after EHLO|HELO
                $reasontext = $Sisimai::Eb::ReBLOC;
            }
        }
        last;
    }
    return $reasontext;
}

sub match {
    # Detect the bounce reason from given text
    # @param    [String] argv1  Error message
    # @return   [String]        Bounce reason
    my $class = shift;
    my $argv1 = shift // return "";

    my $reasontext = '';
    my $issuedcode = lc $argv1;

    # Diagnostic-Code: SMTP; ... or empty value
    for my $e ( $ClassOrder->[2]->@* ) {
        # Check the values of Diagnostic-Code: and Status: fields using true() method of each child
        # class in Sisimai::Reason
        my $p = 'Sisimai::Reason::'.$e;
        require $ModulePath->{ $p };

        next unless $p->match($issuedcode);
        $reasontext = $p->text;
        last;
    }
    return $reasontext if $reasontext;

    if( CORE::index(uc $issuedcode, 'X-UNIX; ') > -1 ) {
        # X-Unix; ...
        $reasontext = $Sisimai::Eb::ReUNIX;

    } else {
        # Detect the bounce reason from "Status:" code
        require Sisimai::SMTP::Status;
        my $cv = Sisimai::SMTP::Status->find($argv1)   || '';
        $reasontext = Sisimai::SMTP::Status->name($cv) || $Sisimai::Eb::Re___0;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason - Detect the bounce reason

=head1 SYNOPSIS

    use Sisimai::Reason;

=head1 DESCRIPTION

C<Sisimai::Reason> detects the bounce reason from the content of C<Sisimai::Fact> object as an argument
of C<find()> method. This class is called only C<Sisimai::Fact> class.

=head1 CLASS METHODS

=head2 C<B<find(I<Sisimai::Fact Object>)>>

C<find()> method detects the bounce reason.

=head2 C<B<anotherone(I<Sisimai::Fact object>)>>

C<anotherone()> method is a method for detecting the bounce reason, it works as a fall back method
of C<find()> and called only from C<find()> method.

C<match()> detects the bounce reason from given text as a error message.

=head2 C<B<match(I<String>)>>

C<match()> method is a method for detecting the bounce reason from the string given as an argument
of the method. However, this method is low analytical precision.

=head1 LIST OF BOUNCE REASONS

C<Sisimai::Reason->find()> method detects the reason of bounce with decoding the bounced messages.
The following reasons will be set in the value of C<reason> property of C<Sisimai::Fact> instance.
The list of all the bounce reasons is available at L<https://libsisimai.org/en/reason/>.

=head1 SEE ALSO

L<Sisimai::ARF>
L<http://tools.ietf.org/html/rfc5965>
L<https://libsisimai.org/en/reason/>

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2026 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

