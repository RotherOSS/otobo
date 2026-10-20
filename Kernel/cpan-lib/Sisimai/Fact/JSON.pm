package Sisimai::Fact::JSON;
use feature ':5.10';
use strict;
use warnings;
use JSON;

sub dump {
    # Data dumper(JSON)
    # @param    [Sisimai::Fact] argvs   Object
    # @return   [String, undef]         Dumped data or undef if the argument is missing
    my $class = shift;
    my $argvs = shift // return undef;
    return undef unless ref $argvs eq 'Sisimai::Fact';

    my $jsonstring = '';
    eval { $jsonstring = JSON->new->space_after(1)->encode($argvs->damn) };
    warn sprintf(" ***warning: Something is wrong in JSON encoding: %s", $@) if $@;
    return $jsonstring;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Fact::JSON - Dumps parsed data object as a JSON format

=head1 SYNOPSIS

    use Sisimai::Fact;
    my $fact = Sisimai::Fact->rise('data' => 'entire email text');
    for my $e ( @$fact ) {
        print $e->dump('json');
    }

=head1 DESCRIPTION

Sisimai::Fact::JSON dumps parsed data object as a JSON format. This class and method should be called
from the parent object "Sisimai::Fact".

=head1 CLASS METHODS

=head2 C<B<dump(I<Sisimai::Fact>)>>

C<dump> method returns Sisimai::Fact object as a JSON formatted string.

    my $mail = Sisimai::Mail->new('/var/mail/root');
    while( my $r = $mail->read ) {
        my $fact = Sisimai::Fact->rise('data' => 'entire email text');
        for my $e ( @$fact ) {
            print $e->dump('json');
        }
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018,2020,2021 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

