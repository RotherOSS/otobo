package Sisimai::Fact::YAML;
use feature ':5.10';
use strict;
use warnings;

sub dump {
    # Data dumper(YAML)
    # @param    [Sisimai::Fact] argvs   Object
    # @return   [String, undef]         Dumped data or undef if the argument is missing
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Fact';
    my $damneddata = undef;
    my $yamlstring = undef;
    my $modulename = undef;

    eval {
        require YAML;
        $modulename = 'YAML';
    };
    if( $@ ) {
        # Try to load YAML::Syck
        eval {
            require YAML::Syck;
            $modulename = 'YAML::Syck';
        };
        die ' ***error: Neither "YAML" nor "YAML::Syck" module is installed' if $@;
    }

    $damneddata = $argvs->damn;
    if( $modulename eq 'YAML' ) {
        # Use YAML module
        local $YAML::SortKeys       = 1;
        local $YAML::Stringify      = 0;
        local $YAML::UseHeader      = 1;
        local $YAML::UseBlock       = 0;
        local $YAML::CompressSeries = 0;
        $yamlstring = YAML::Dump($damneddata);

    } elsif( $modulename eq 'YAML::Syck' ) {
        # Use YAML::Syck module instead of YAML module.
        local $YAML::Syck::ImplicitTyping  = 1;
        local $YAML::Syck::Headless        = 0;
        local $YAML::Syck::ImplicitUnicode = 1;
        local $YAML::Syck::SingleQuote     = 0;
        local $YAML::Syck::SortKeys        = 1;
        $yamlstring = YAML::Syck::Dump($damneddata);
    }

    return $yamlstring;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Fact::YAML - Dumps parsed data object as a YAML format

=head1 SYNOPSIS

    use Sisimai::Fact;
    my $fact = Sisimai::Fact->rise('data' => 'Entire email text');
    for my $e ( @$fact ) {
        print $e->dump('yaml');
    }

=head1 DESCRIPTION

Sisimai::Fact::YAML dumps parsed data object as a YAML format. This class and method should be called
from the parent object "Sisimai::Fact".

=head1 CLASS METHODS

=head2 C<B<dump(I<Sisimai::Fact>)>>

C<dump> method returns Sisimai::Fact object as a YAML formatted string.

    my $mail = Sisimai::Mail->new('/var/mail/root');
    while( my $r = $mail->read ) {
        my $fact = Sisimai::Fact->rise('data' => $r);
        for my $e ( @$fact ) {
            print $e->dump('yaml');
        }
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2020,2021 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

