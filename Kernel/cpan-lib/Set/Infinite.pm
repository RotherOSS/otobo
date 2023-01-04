package Set::Infinite;

# Copyright (c) 2001, 2002, 2003, 2004 Flavio Soibelmann Glock. 
# All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

use 5.005_03;

# These methods are inherited from Set::Infinite::Basic "as-is":
#   type list fixtype numeric min max integer real new span copy
#   start_set end_set universal_set empty_set minus difference
#   symmetric_difference is_empty

use strict;
use base qw(Set::Infinite::Basic Exporter);
use Carp;
use Set::Infinite::Arithmetic;

use overload
    '<=>' => \&spaceship,
    '""'  => \&as_string;

use vars qw(@EXPORT_OK $VERSION 
    $TRACE $DEBUG_BT $PRETTY_PRINT $inf $minus_inf $neg_inf 
    %_first %_last %_backtrack
    $too_complex $backtrack_depth 
    $max_backtrack_depth $max_intersection_depth
    $trace_level %level_title );

@EXPORT_OK = qw(inf $inf trace_open trace_close);

$inf     = 100**100**100;
$neg_inf = $minus_inf  = -$inf;


# obsolete methods - included for backward compatibility
sub inf ()            { $inf }
sub minus_inf ()      { $minus_inf }
sub no_cleanup { $_[0] }
*type       = \&Set::Infinite::Basic::type;
sub compact { @_ }


BEGIN {
    $VERSION = "0.65";
    $TRACE = 0;         # enable basic trace method execution
    $DEBUG_BT = 0;      # enable backtrack tracer
    $PRETTY_PRINT = 0;  # 0 = print 'Too Complex'; 1 = describe functions
    $trace_level = 0;   # indentation level when debugging

    $too_complex =    "Too complex";
    $backtrack_depth = 0;
    $max_backtrack_depth = 10;    # _backtrack()
    $max_intersection_depth = 5;  # first()
}

sub trace { # title=>'aaa'
    return $_[0] unless $TRACE;
    my ($self, %parm) = @_;
    my @caller = caller(1);
    # print "self $self ". ref($self). "\n";
    print "" . ( ' | ' x $trace_level ) .
            "$parm{title} ". $self->copy .
            ( exists $parm{arg} ? " -- " . $parm{arg}->copy : "" ).
            " $caller[1]:$caller[2] ]\n" if $TRACE == 1;
    return $self;
}

sub trace_open { 
    return $_[0] unless $TRACE;
    my ($self, %parm) = @_;
    my @caller = caller(1);
    print "" . ( ' | ' x $trace_level ) .
            "\\ $parm{title} ". $self->copy .
            ( exists $parm{arg} ? " -- ". $parm{arg}->copy : "" ).
            " $caller[1]:$caller[2] ]\n";
    $trace_level++; 
    $level_title{$trace_level} = $parm{title};
    return $self;
}

sub trace_close { 
    return $_[0] unless $TRACE;
    my ($self, %parm) = @_;  
    my @caller = caller(0);
    print "" . ( ' | ' x ($trace_level-1) ) .
            "\/ $level_title{$trace_level} ".
            ( exists $parm{arg} ? 
               (
                  defined $parm{arg} ? 
                      "ret ". ( UNIVERSAL::isa($parm{arg}, __PACKAGE__ ) ? 
                           $parm{arg}->copy : 
                           "<$parm{arg}>" ) :
                      "undef"
               ) : 
               ""     # no arg 
            ).
            " $caller[1]:$caller[2] ]\n";
    $trace_level--;
    return $self;
}


# creates a 'function' object that can be solved by _backtrack()
sub _function {
    my ($self, $method) = (shift, shift);
    my $b = $self->empty_set();
    $b->{too_complex} = 1;
    $b->{parent} = $self;   
    $b->{method} = $method;
    $b->{param}  = [ @_ ];
    return $b;
}


# same as _function, but with 2 arguments
sub _function2 {
    my ($self, $method, $arg) = (shift, shift, shift);
    unless ( $self->{too_complex} || $arg->{too_complex} ) {
        return $self->$method($arg, @_);
    }
    my $b = $self->empty_set();
    $b->{too_complex} = 1;
    $b->{parent} = [ $self, $arg ];
    $b->{method} = $method;
    $b->{param}  = [ @_ ];
    return $b;
}


sub quantize {
    my $self = shift;
    $self->trace_open(title=>"quantize") if $TRACE; 
    my @min = $self->min_a;
    my @max = $self->max_a;
    if (($self->{too_complex}) or 
        (defined $min[0] && $min[0] == $neg_inf) or 
        (defined $max[0] && $max[0] == $inf)) {

        return $self->_function( 'quantize', @_ );
    }

    my @a;
    my %rule = @_;
    my $b = $self->empty_set();    
    my $parent = $self;

    $rule{unit} =   'one' unless $rule{unit};
    $rule{quant} =  1     unless $rule{quant};
    $rule{parent} = $parent; 
    $rule{strict} = $parent unless exists $rule{strict};
    $rule{type} =   $parent->{type};

    my ($min, $open_begin) = $parent->min_a;

    unless (defined $min) {
        $self->trace_close( arg => $b ) if $TRACE;
        return $b;    
    }

    $rule{fixtype} = 1 unless exists $rule{fixtype};
    $Set::Infinite::Arithmetic::Init_quantizer{$rule{unit}}->(\%rule);

    $rule{sub_unit} = $Set::Infinite::Arithmetic::Offset_to_value{$rule{unit}};
    carp "Quantize unit '".$rule{unit}."' not implemented" unless ref( $rule{sub_unit} ) eq 'CODE';

    my ($max, $open_end) = $parent->max_a;
    $rule{offset} = $Set::Infinite::Arithmetic::Value_to_offset{$rule{unit}}->(\%rule, $min);
    my $last_offset = $Set::Infinite::Arithmetic::Value_to_offset{$rule{unit}}->(\%rule, $max);
    $rule{size} = $last_offset - $rule{offset} + 1; 
    my ($index, $tmp, $this, $next);
    for $index (0 .. $rule{size} ) {
        # ($this, $next) = $rule{sub_unit} (\%rule, $index);
        ($this, $next) = $rule{sub_unit}->(\%rule, $index);
        unless ( $rule{fixtype} ) {
                $tmp = { a => $this , b => $next ,
                        open_begin => 0, open_end => 1 };
        }
        else {
                $tmp = Set::Infinite::Basic::_simple_new($this,$next, $rule{type} );
                $tmp->{open_end} = 1;
        }
        next if ( $rule{strict} and not $rule{strict}->intersects($tmp));
        push @a, $tmp;
    }

    $b->{list} = \@a;        # change data
    $self->trace_close( arg => $b ) if $TRACE;
    return $b;
}


sub _first_n {
    my $self = shift;
    my $n = shift;
    my $tail = $self->copy;
    my @result;
    my $first;
    for ( 1 .. $n )
    {
        ( $first, $tail ) = $tail->first if $tail;
        push @result, $first;
    }
    return $tail, @result;
}

sub _last_n {
    my $self = shift;
    my $n = shift;
    my $tail = $self->copy;
    my @result;
    my $last;
    for ( 1 .. $n )
    {
        ( $last, $tail ) = $tail->last if $tail;
        unshift @result, $last;
    }
    return $tail, @result;
}


sub select {
    my $self = shift;
    $self->trace_open(title=>"select") if $TRACE;

    my %param = @_;
    die "select() - parameter 'freq' is deprecated" if exists $param{freq};

    my $res;
    my $count;
    my @by;
    @by = @{ $param{by} } if exists $param{by}; 
    $count = delete $param{count} || $inf;
    # warn "select: count=$count by=[@by]";

    if ($count <= 0) {
        $self->trace_close( arg => $res ) if $TRACE;
        return $self->empty_set();
    }

    my @set;
    my $tail;
    my $first;
    my $last;
    if ( @by ) 
    {
        my @res;
        if ( ! $self->is_too_complex ) 
        {
            $res = $self->new;
            @res = @{ $self->{list} }[ @by ] ;
        }
        else
        {
            my ( @pos_by, @neg_by );
            for ( @by ) {
                ( $_ < 0 ) ? push @neg_by, $_ :
                             push @pos_by, $_;
            }
            my @first;
            if ( @pos_by ) {
                @pos_by = sort { $a <=> $b } @pos_by;
                ( $tail, @set ) = $self->_first_n( 1 + $pos_by[-1] );
                @first = @set[ @pos_by ];
            }
            my @last;
            if ( @neg_by ) {
                @neg_by = sort { $a <=> $b } @neg_by;
                ( $tail, @set ) = $self->_last_n( - $neg_by[0] );
                @last = @set[ @neg_by ];
            }
            @res = map { $_->{list}[0] } ( @first , @last );
        }

        $res = $self->new;
        @res = sort { $a->{a} <=> $b->{a} } grep { defined } @res;
        my $last;
        my @a;
        for ( @res ) {
            push @a, $_ if ! $last || $last->{a} != $_->{a};
            $last = $_;
        }
        $res->{list} = \@a;
    }
    else
    {
        $res = $self;
    }

    return $res if $count == $inf;
    my $count_set = $self->empty_set();
    if ( ! $self->is_too_complex )
    {
        my @a;
        @a = grep { defined } @{ $res->{list} }[ 0 .. $count - 1 ] ;
        $count_set->{list} = \@a;
    }
    else
    {
        my $last;
        while ( $res ) {
            ( $first, $res ) = $res->first;
            last unless $first;
            last if $last && $last->{a} == $first->{list}[0]{a};
            $last = $first->{list}[0];
            push @{$count_set->{list}}, $first->{list}[0];
            $count--;
            last if $count <= 0;
        }
    }
    return $count_set;
}

BEGIN {

  # %_first and %_last hashes are used to backtrack the value
  # of first() and last() of an infinite set

  %_first = (
    'complement' =>
        sub {
            my $self = $_[0];
            my @parent_min = $self->{parent}->first;
            unless ( defined $parent_min[0] ) {
                return (undef, 0);
            }
            my $parent_complement;
            my $first;
            my @next;
            my $parent;
            if ( $parent_min[0]->min == $neg_inf ) {
                my @parent_second = $parent_min[1]->first;
                #    (-inf..min)        (second..?)
                #            (min..second)   = complement
                $first = $self->new( $parent_min[0]->complement );
                $first->{list}[0]{b} = $parent_second[0]->{list}[0]{a};
                $first->{list}[0]{open_end} = ! $parent_second[0]->{list}[0]{open_begin};
                @{ $first->{list} } = () if 
                    ( $first->{list}[0]{a} == $first->{list}[0]{b}) && 
                        ( $first->{list}[0]{open_begin} ||
                          $first->{list}[0]{open_end} );
                @next = $parent_second[0]->max_a;
                $parent = $parent_second[1];
            }
            else {
                #            (min..?)
                #    (-inf..min)        = complement
                $parent_complement = $parent_min[0]->complement;
                $first = $self->new( $parent_complement->{list}[0] );
                @next = $parent_min[0]->max_a;
                $parent = $parent_min[1];
            }
            my @no_tail = $self->new($neg_inf,$next[0]);
            $no_tail[0]->{list}[0]{open_end} = $next[1];
            my $tail = $parent->union($no_tail[0])->complement;  
            return ($first, $tail);
        },  # end: first-complement
    'intersection' =>
        sub {
            my $self = $_[0];
            my @parent = @{ $self->{parent} };
            # warn "$method parents @parent";
            my $retry_count = 0;
            my (@first, @min, $which, $first1, $intersection);
            SEARCH: while ($retry_count++ < $max_intersection_depth) {
                return undef unless defined $parent[0];
                return undef unless defined $parent[1];
                @{$first[0]} = $parent[0]->first;
                @{$first[1]} = $parent[1]->first;
                unless ( defined $first[0][0] ) {
                    # warn "don't know first of $method";
                    $self->trace_close( arg => 'undef' ) if $TRACE;
                    return undef;
                }
                unless ( defined $first[1][0] ) {
                    # warn "don't know first of $method";
                    $self->trace_close( arg => 'undef' ) if $TRACE;
                    return undef;
                }
                @{$min[0]} = $first[0][0]->min_a;
                @{$min[1]} = $first[1][0]->min_a;
                unless ( defined $min[0][0] && defined $min[1][0] ) {
                    return undef;
                } 
                # $which is the index to the bigger "first".
                $which = ($min[0][0] < $min[1][0]) ? 1 : 0;  
                for my $which1 ( $which, 1 - $which ) {
                  my $tmp_parent = $parent[$which1];
                  ($first1, $parent[$which1]) = @{ $first[$which1] };
                  if ( $first1->is_empty ) {
                    # warn "first1 empty! count $retry_count";
                    # trace_close;
                    # return $first1, undef;
                    $intersection = $first1;
                    $which = $which1;
                    last SEARCH;
                  }
                  $intersection = $first1->intersection( $parent[1-$which1] );
                  # warn "intersection with $first1 is $intersection";
                  unless ( $intersection->is_null ) { 
                    # $self->trace( title=>"got an intersection" );
                    if ( $intersection->is_too_complex ) {
                        $parent[$which1] = $tmp_parent;
                    }
                    else {
                        $which = $which1;
                        last SEARCH;
                    }
                  };
                }
            }
            if ( $#{ $intersection->{list} } > 0 ) {
                my $tail;
                ($intersection, $tail) = $intersection->first;
                $parent[$which] = $parent[$which]->union( $tail );
            }
            my $tmp;
            if ( defined $parent[$which] and defined $parent[1-$which] ) {
                $tmp = $parent[$which]->intersection ( $parent[1-$which] );
            }
            return ($intersection, $tmp);
        }, # end: first-intersection
    'union' =>
        sub {
            my $self = $_[0];
            my (@first, @min);
            my @parent = @{ $self->{parent} };
            @{$first[0]} = $parent[0]->first;
            @{$first[1]} = $parent[1]->first;
            unless ( defined $first[0][0] ) {
                # looks like one set was empty
                return @{$first[1]};
            }
            @{$min[0]} = $first[0][0]->min_a;
            @{$min[1]} = $first[1][0]->min_a;

            # check min1/min2 for undef
            unless ( defined $min[0][0] ) {
                $self->trace_close( arg => "@{$first[1]}" ) if $TRACE;
                return @{$first[1]}
            }
            unless ( defined $min[1][0] ) {
                $self->trace_close( arg => "@{$first[0]}" ) if $TRACE;
                return @{$first[0]}
            }

            my $which = ($min[0][0] < $min[1][0]) ? 0 : 1;
            my $first = $first[$which][0];

            # find out the tail
            my $parent1 = $first[$which][1];
            # warn $self->{parent}[$which]." - $first = $parent1";
            my $parent2 = ($min[0][0] == $min[1][0]) ? 
                $self->{parent}[1-$which]->complement($first) : 
                $self->{parent}[1-$which];
            my $tail;
            if (( ! defined $parent1 ) || $parent1->is_null) {
                # warn "union parent1 tail is null"; 
                $tail = $parent2;
            }
            else {
                my $method = $self->{method};
                $tail = $parent1->$method( $parent2 );
            }

            if ( $first->intersects( $tail ) ) {
                my $first2;
                ( $first2, $tail ) = $tail->first;
                $first = $first->union( $first2 );
            }

            $self->trace_close( arg => "$first $tail" ) if $TRACE;
            return ($first, $tail);
        }, # end: first-union
    'iterate' =>
        sub {
            my $self = $_[0];
            my $parent = $self->{parent};
            my ($first, $tail) = $parent->first;
            $first = $first->iterate( @{$self->{param}} ) if ref($first);
            $tail  = $tail->_function( 'iterate', @{$self->{param}} ) if ref($tail);
            my $more;
            ($first, $more) = $first->first if ref($first);
            $tail = $tail->_function2( 'union', $more ) if defined $more;
            return ($first, $tail);
        },
    'until' =>
        sub {
            my $self = $_[0];
            my ($a1, $b1) = @{ $self->{parent} };
            $a1->trace( title=>"computing first()" );
            my @first1 = $a1->first;
            my @first2 = $b1->first;
            my ($first, $tail);
            if ( $first2[0] <= $first1[0] ) {
                # added ->first because it returns 2 spans if $a1 == $a2
                $first = $a1->empty_set()->until( $first2[0] )->first;
                $tail = $a1->_function2( "until", $first2[1] );
            }
            else {
                $first = $a1->new( $first1[0] )->until( $first2[0] );
                if ( defined $first1[1] ) {
                    $tail = $first1[1]->_function2( "until", $first2[1] );
                }
                else {
                    $tail = undef;
                }
            }
            return ($first, $tail);
        },
    'offset' =>
        sub {
            my $self = $_[0];
            my ($first, $tail) = $self->{parent}->first;
            $first = $first->offset( @{$self->{param}} );
            $tail  = $tail->_function( 'offset', @{$self->{param}} );
            my $more;
            ($first, $more) = $first->first;
            $tail = $tail->_function2( 'union', $more ) if defined $more;
            return ($first, $tail);
        },
    'quantize' =>
        sub {
            my $self = $_[0];
            my @min = $self->{parent}->min_a;
            if ( $min[0] == $neg_inf || $min[0] == $inf ) {
                return ( $self->new( $min[0] ) , $self->copy );
            }
            my $first = $self->new( $min[0] )->quantize( @{$self->{param}} );
            return ( $first,
                     $self->{parent}->
                        _function2( 'intersection', $first->complement )->
                        _function( 'quantize', @{$self->{param}} ) );
        },
    'tolerance' =>
        sub {
            my $self = $_[0];
            my ($first, $tail) = $self->{parent}->first;
            $first = $first->tolerance( @{$self->{param}} );
            $tail  = $tail->tolerance( @{$self->{param}} );
            return ($first, $tail);
        },
  );  # %_first

  %_last = (
    'complement' =>
        sub {
            my $self = $_[0];
            my @parent_max = $self->{parent}->last;
            unless ( defined $parent_max[0] ) {
                return (undef, 0);
            }
            my $parent_complement;
            my $last;
            my @next;
            my $parent;
            if ( $parent_max[0]->max == $inf ) {
                #    (inf..min)        (second..?) = parent
                #            (min..second)         = complement
                my @parent_second = $parent_max[1]->last;
                $last = $self->new( $parent_max[0]->complement );
                $last->{list}[0]{a} = $parent_second[0]->{list}[0]{b};
                $last->{list}[0]{open_begin} = ! $parent_second[0]->{list}[0]{open_end};
                @{ $last->{list} } = () if
                    ( $last->{list}[0]{a} == $last->{list}[0]{b}) &&
                        ( $last->{list}[0]{open_end} ||
                          $last->{list}[0]{open_begin} );
                @next = $parent_second[0]->min_a;
                $parent = $parent_second[1];
            }
            else {
                #            (min..?)
                #    (-inf..min)        = complement
                $parent_complement = $parent_max[0]->complement;
                $last = $self->new( $parent_complement->{list}[-1] );
                @next = $parent_max[0]->min_a;
                $parent = $parent_max[1];
            }
            my @no_tail = $self->new($next[0], $inf);
            $no_tail[0]->{list}[-1]{open_begin} = $next[1];
            my $tail = $parent->union($no_tail[-1])->complement;
            return ($last, $tail);
        },
    'intersection' =>
        sub {
            my $self = $_[0];
            my @parent = @{ $self->{parent} };
            # TODO: check max1/max2 for undef

            my $retry_count = 0;
            my (@last, @max, $which, $last1, $intersection);

            SEARCH: while ($retry_count++ < $max_intersection_depth) {
                return undef unless defined $parent[0];
                return undef unless defined $parent[1];

                @{$last[0]} = $parent[0]->last;
                @{$last[1]} = $parent[1]->last;
                unless ( defined $last[0][0] ) {
                    $self->trace_close( arg => 'undef' ) if $TRACE;
                    return undef;
                }
                unless ( defined $last[1][0] ) {
                    $self->trace_close( arg => 'undef' ) if $TRACE;
                    return undef;
                }
                @{$max[0]} = $last[0][0]->max_a;
                @{$max[1]} = $last[1][0]->max_a;
                unless ( defined $max[0][0] && defined $max[1][0] ) {
                    $self->trace( title=>"can't find max()" ) if $TRACE;
                    $self->trace_close( arg => 'undef' ) if $TRACE;
                    return undef;
                }

                # $which is the index to the smaller "last".
                $which = ($max[0][0] > $max[1][0]) ? 1 : 0;

                for my $which1 ( $which, 1 - $which ) {
                  my $tmp_parent = $parent[$which1];
                  ($last1, $parent[$which1]) = @{ $last[$which1] };
                  if ( $last1->is_null ) {
                    $which = $which1;
                    $intersection = $last1;
                    last SEARCH;
                  }
                  $intersection = $last1->intersection( $parent[1-$which1] );

                  unless ( $intersection->is_null ) {
                    # $self->trace( title=>"got an intersection" );
                    if ( $intersection->is_too_complex ) {
                        $self->trace( title=>"got a too_complex intersection" ) if $TRACE; 
                        # warn "too complex intersection";
                        $parent[$which1] = $tmp_parent;
                    }
                    else {
                        $self->trace( title=>"got an intersection" ) if $TRACE;
                        $which = $which1;
                        last SEARCH;
                    }
                  };
                }
            }
            $self->trace( title=>"exit loop" ) if $TRACE;
            if ( $#{ $intersection->{list} } > 0 ) {
                my $tail;
                ($intersection, $tail) = $intersection->last;
                $parent[$which] = $parent[$which]->union( $tail );
            }
            my $tmp;
            if ( defined $parent[$which] and defined $parent[1-$which] ) {
                $tmp = $parent[$which]->intersection ( $parent[1-$which] );
            }
            return ($intersection, $tmp);
        },
    'union' =>
        sub {
            my $self = $_[0];
            my (@last, @max);
            my @parent = @{ $self->{parent} };
            @{$last[0]} = $parent[0]->last;
            @{$last[1]} = $parent[1]->last;
            @{$max[0]} = $last[0][0]->max_a;
            @{$max[1]} = $last[1][0]->max_a;
            unless ( defined $max[0][0] ) {
                return @{$last[1]}
            }
            unless ( defined $max[1][0] ) {
                return @{$last[0]}
            }

            my $which = ($max[0][0] > $max[1][0]) ? 0 : 1;
            my $last = $last[$which][0];
            # find out the tail
            my $parent1 = $last[$which][1];
            # warn $self->{parent}[$which]." - $last = $parent1";
            my $parent2 = ($max[0][0] == $max[1][0]) ?
                $self->{parent}[1-$which]->complement($last) :
                $self->{parent}[1-$which];
            my $tail;
            if (( ! defined $parent1 ) || $parent1->is_null) {
                $tail = $parent2;
            }
            else {
                my $method = $self->{method};
                $tail = $parent1->$method( $parent2 );
            }

            if ( $last->intersects( $tail ) ) {
                my $last2;
                ( $last2, $tail ) = $tail->last;
                $last = $last->union( $last2 );
            }

            return ($last, $tail);
        },
    'until' =>
        sub {
            my $self = $_[0];
            my ($a1, $b1) = @{ $self->{parent} };
            $a1->trace( title=>"computing last()" );
            my @last1 = $a1->last;
            my @last2 = $b1->last;
            my ($last, $tail);
            if ( $last2[0] <= $last1[0] ) {
                # added ->last because it returns 2 spans if $a1 == $a2
                $last = $last2[0]->until( $a1 )->last;
                $tail = $a1->_function2( "until", $last2[1] );
            }
            else {
                $last = $a1->new( $last1[0] )->until( $last2[0] );
                if ( defined $last1[1] ) {
                    $tail = $last1[1]->_function2( "until", $last2[1] );
                }
                else {
                    $tail = undef;
                }
            }
            return ($last, $tail);
        },
    'iterate' =>
        sub {
            my $self = $_[0];
            my $parent = $self->{parent};
            my ($last, $tail) = $parent->last;
            $last = $last->iterate( @{$self->{param}} ) if ref($last);
            $tail = $tail->_function( 'iterate', @{$self->{param}} ) if ref($tail);
            my $more;
            ($last, $more) = $last->last if ref($last);
            $tail = $tail->_function2( 'union', $more ) if defined $more;
            return ($last, $tail);
        },
    'offset' =>
        sub {
            my $self = $_[0];
            my ($last, $tail) = $self->{parent}->last;
            $last = $last->offset( @{$self->{param}} );
            $tail  = $tail->_function( 'offset', @{$self->{param}} );
            my $more;
            ($last, $more) = $last->last;
            $tail = $tail->_function2( 'union', $more ) if defined $more;
            return ($last, $tail);
        },
    'quantize' =>
        sub {
            my $self = $_[0];
            my @max = $self->{parent}->max_a;
            if (( $max[0] == $neg_inf ) || ( $max[0] == $inf )) {
                return ( $self->new( $max[0] ) , $self->copy );
            }
            my $last = $self->new( $max[0] )->quantize( @{$self->{param}} );
            if ($max[1]) {  # open_end
                    if ( $last->min <= $max[0] ) {
                        $last = $self->new( $last->min - 1e-9 )->quantize( @{$self->{param}} );
                    }
            }
            return ( $last, $self->{parent}->
                        _function2( 'intersection', $last->complement )->
                        _function( 'quantize', @{$self->{param}} ) );
        },
    'tolerance' =>
        sub {
            my $self = $_[0];
            my ($last, $tail) = $self->{parent}->last;
            $last = $last->tolerance( @{$self->{param}} );
            $tail  = $tail->tolerance( @{$self->{param}} );
            return ($last, $tail);
        },
  );  # %_last
} # BEGIN

sub first {
    my $self = $_[0];
    unless ( exists $self->{first} ) {
        $self->trace_open(title=>"first") if $TRACE;
        if ( $self->{too_complex} ) {
            my $method = $self->{method};
            # warn "method $method ". ( exists $_first{$method} ? "exists" : "does not exist" );
            if ( exists $_first{$method} ) {
                @{$self->{first}} = $_first{$method}->($self);
            }
            else {
                my $redo = $self->{parent}->$method ( @{ $self->{param} } );
                @{$self->{first}} = $redo->first;
            }
        }
        else {
            return $self->SUPER::first;
        }
    }
    return wantarray ? @{$self->{first}} : $self->{first}[0];
}


sub last {
    my $self = $_[0];
    unless ( exists $self->{last} ) {
        $self->trace(title=>"last") if $TRACE;
        if ( $self->{too_complex} ) {
            my $method = $self->{method};
            if ( exists $_last{$method} ) {
                @{$self->{last}} = $_last{$method}->($self);
            }
            else {
                my $redo = $self->{parent}->$method ( @{ $self->{param} } );
                @{$self->{last}} = $redo->last;
            }
        }
        else {
            return $self->SUPER::last;
        }
    }
    return wantarray ? @{$self->{last}} : $self->{last}[0];
}


# offset: offsets subsets
sub offset {
    my $self = shift;
    if ($self->{too_complex}) {
        return $self->_function( 'offset', @_ );
    }
    $self->trace_open(title=>"offset") if $TRACE;

    my @a;
    my %param = @_;
    my $b1 = $self->empty_set();    
    my ($interval, $ia, $i);
    $param{mode} = 'offset' unless $param{mode};

    unless (ref($param{value}) eq 'ARRAY') {
        $param{value} = [0 + $param{value}, 0 + $param{value}];
    }
    $param{unit} =    'one'  unless $param{unit};
    my $parts    =    ($#{$param{value}}) / 2;
    my $sub_unit =    $Set::Infinite::Arithmetic::subs_offset2{$param{unit}};
    my $sub_mode =    $Set::Infinite::Arithmetic::_MODE{$param{mode}};

    carp "unknown unit $param{unit} for offset()" unless defined $sub_unit;
    carp "unknown mode $param{mode} for offset()" unless defined $sub_mode;

    my ($j);
    my ($cmp, $this, $next, $ib, $part, $open_begin, $open_end, $tmp);

    my @value;
    foreach $j (0 .. $parts) {
        push @value, [ $param{value}[$j+$j], $param{value}[$j+$j + 1] ];
    }

    foreach $interval ( @{ $self->{list} } ) {
        $ia =         $interval->{a};
        $ib =         $interval->{b};
        $open_begin = $interval->{open_begin};
        $open_end =   $interval->{open_end};
        foreach $j (0 .. $parts) {
            # print " [ofs($ia,$ib)] ";
            ($this, $next) = $sub_mode->( $sub_unit, $ia, $ib, @{$value[$j]} );
            next if ($this > $next);    # skip if a > b
            if ($this == $next) {
                # TODO: fix this
                $open_end = $open_begin;
            }
            push @a, { a => $this , b => $next ,
                       open_begin => $open_begin , open_end => $open_end };
        }  # parts
    }  # self
    @a = sort { $a->{a} <=> $b->{a} } @a;
    $b1->{list} = \@a;        # change data
    $self->trace_close( arg => $b1 ) if $TRACE;
    $b1 = $b1->fixtype if $self->{fixtype};
    return $b1;
}


sub is_null {
    $_[0]->{too_complex} ? 0 : $_[0]->SUPER::is_null;
}


sub is_too_complex {
    $_[0]->{too_complex} ? 1 : 0;
}


# shows how a 'compacted' set looks like after quantize
sub _quantize_span {
    my $self = shift;
    my %param = @_;
    $self->trace_open(title=>"_quantize_span") if $TRACE;
    my $res;
    if ($self->{too_complex}) {
        $res = $self->{parent};
        if ($self->{method} ne 'quantize') {
            $self->trace( title => "parent is a ". $self->{method} );
            if ( $self->{method} eq 'union' ) {
                my $arg0 = $self->{parent}[0]->_quantize_span(%param);
                my $arg1 = $self->{parent}[1]->_quantize_span(%param);
                $res = $arg0->union( $arg1 );
            }
            elsif ( $self->{method} eq 'intersection' ) {
                my $arg0 = $self->{parent}[0]->_quantize_span(%param);
                my $arg1 = $self->{parent}[1]->_quantize_span(%param);
                $res = $arg0->intersection( $arg1 );
            }

            # TODO: other methods
            else {
                $res = $self; # ->_function( "_quantize_span", %param );
            }
            $self->trace_close( arg => $res ) if $TRACE;
            return $res;
        }

        # $res = $self->{parent};
        if ($res->{too_complex}) {
            $res->trace( title => "parent is complex" );
            $res = $res->_quantize_span( %param );
            $res = $res->quantize( @{$self->{param}} )->_quantize_span( %param );
        }
        else {
            $res = $res->iterate (
                sub {
                    $_[0]->quantize( @{$self->{param}} )->span;
                }
            );
        }
    }
    else {
        $res = $self->iterate (   sub { $_[0] }   );
    }
    $self->trace_close( arg => $res ) if $TRACE;
    return $res;
}



BEGIN {

    %_backtrack = (

        until => sub {
            my ($self, $arg) = @_;
            my $before = $self->{parent}[0]->intersection( $neg_inf, $arg->min )->max;
            $before = $arg->min unless $before;
            my $after = $self->{parent}[1]->intersection( $arg->max, $inf )->min;
            $after = $arg->max unless $after;
            return $arg->new( $before, $after );
        },

        iterate => sub {
            my ($self, $arg) = @_;

            if ( defined $self->{backtrack_callback} )
            {
                return $arg = $self->new( $self->{backtrack_callback}->( $arg ) );
            }

            my $before = $self->{parent}->intersection( $neg_inf, $arg->min )->max;
            $before = $arg->min unless $before;
            my $after = $self->{parent}->intersection( $arg->max, $inf )->min;
            $after = $arg->max unless $after;

            return $arg->new( $before, $after );
        },

        quantize => sub {
            my ($self, $arg) = @_;
            if ($arg->{too_complex}) {
                return $arg;
            }
            else {
                return $arg->quantize( @{$self->{param}} )->_quantize_span;
            }
        },

        offset => sub {
            my ($self, $arg) = @_;
            # offset - apply offset with negative values
            my %tmp = @{$self->{param}};
            my @values = sort @{$tmp{value}};

            my $backtrack_arg2 = $arg->offset( 
                   unit => $tmp{unit}, 
                   mode => $tmp{mode}, 
                   value => [ - $values[-1], - $values[0] ] );
            return $arg->union( $backtrack_arg2 );   # fixes some problems with 'begin' mode
        },

    );
}


sub _backtrack {
    my ($self, $method, $arg) = @_;
    return $self->$method ($arg) unless $self->{too_complex};

    $self->trace_open( title => 'backtrack '.$self->{method} ) if $TRACE;

    $backtrack_depth++;
    if ( $backtrack_depth > $max_backtrack_depth ) {
        carp ( __PACKAGE__ . ": Backtrack too deep " .
               "(more than $max_backtrack_depth levels)" );
    }

    if (exists $_backtrack{ $self->{method} } ) {
        $arg = $_backtrack{ $self->{method} }->( $self, $arg );
    }

    my $result;
    if ( ref($self->{parent}) eq 'ARRAY' ) {
        # has 2 parents (intersection, union, until)

        my ( $result1, $result2 ) = @{$self->{parent}};
        $result1 = $result1->_backtrack( $method, $arg )
            if $result1->{too_complex};
        $result2 = $result2->_backtrack( $method, $arg )
            if $result2->{too_complex};

        $method = $self->{method};
        if ( $result1->{too_complex} || $result2->{too_complex} ) {
            $result = $result1->_function2( $method, $result2 );
        }
        else {
            $result = $result1->$method ($result2);
        }
    }
    else {
        # has 1 parent and parameters (offset, select, quantize, iterate)

        $result = $self->{parent}->_backtrack( $method, $arg ); 
        $method = $self->{method};
        $result = $result->$method ( @{$self->{param}} );
    }

    $backtrack_depth--;
    $self->trace_close( arg => $result ) if $TRACE;
    return $result;
}


sub intersects {
    my $a1 = shift;
    my $b1 = (ref ($_[0]) eq ref($a1) ) ? shift : $a1->new(@_);

    $a1->trace(title=>"intersects");
    if ($a1->{too_complex}) {
        $a1 = $a1->_backtrack('intersection', $b1 ); 
    }  # don't put 'else' here
    if ($b1->{too_complex}) {
        $b1 = $b1->_backtrack('intersection', $a1);
    }
    if (($a1->{too_complex}) or ($b1->{too_complex})) {
        return undef;   # we don't know the answer!
    }
    return $a1->SUPER::intersects( $b1 );
}


sub iterate {
    my $self = shift;
    my $callback = shift;
    die "First argument to iterate() must be a subroutine reference"
        unless ref( $callback ) eq 'CODE';
    my $backtrack_callback;
    if ( @_ && $_[0] eq 'backtrack_callback' )
    {
        ( undef, $backtrack_callback ) = ( shift, shift );
    }
    my $set;
    if ($self->{too_complex}) {
        $self->trace(title=>"iterate:backtrack") if $TRACE;
        $set = $self->_function( 'iterate', $callback, @_ );
    }
    else
    {
        $self->trace(title=>"iterate") if $TRACE;
        $set = $self->SUPER::iterate( $callback, @_ );
    }
    $set->{backtrack_callback} = $backtrack_callback;
    # warn "set backtrack_callback" if defined $backtrack_callback;
    return $set;
}


sub intersection {
    my $a1 = shift;
    my $b1 = (ref ($_[0]) eq ref($a1) ) ? shift : $a1->new(@_);

    $a1->trace_open(title=>"intersection", arg => $b1) if $TRACE;
    if (($a1->{too_complex}) or ($b1->{too_complex})) {
        my $arg0 = $a1->_quantize_span;
        my $arg1 = $b1->_quantize_span;
        unless (($arg0->{too_complex}) or ($arg1->{too_complex})) {
            my $res = $arg0->intersection( $arg1 );
            $a1->trace_close( arg => $res ) if $TRACE;
            return $res;
        }
    }
    if ($a1->{too_complex}) {
        $a1 = $a1->_backtrack('intersection', $b1) unless $b1->{too_complex};
    }  # don't put 'else' here
    if ($b1->{too_complex}) {
        $b1 = $b1->_backtrack('intersection', $a1) unless $a1->{too_complex};
    }
    if ( $a1->{too_complex} || $b1->{too_complex} ) {
        $a1->trace_close( ) if $TRACE;
        return $a1->_function2( 'intersection', $b1 );
    }
    return $a1->SUPER::intersection( $b1 );
}


sub intersected_spans {
    my $a1 = shift;
    my $b1 = ref ($_[0]) eq ref($a1) ? $_[0] : $a1->new(@_);

    if ($a1->{too_complex}) {
        $a1 = $a1->_backtrack('intersection', $b1 ) unless $b1->{too_complex};  
    }  # don't put 'else' here
    if ($b1->{too_complex}) {
        $b1 = $b1->_backtrack('intersection', $a1) unless $a1->{too_complex};
    }

    if ( ! $b1->{too_complex} && ! $a1->{too_complex} )
    {
        return $a1->SUPER::intersected_spans ( $b1 );
    }

    return $b1->iterate(
        sub {
            my $tmp = $a1->intersection( $_[0] );
            return $tmp unless defined $tmp->max;

            my $before = $a1->intersection( $neg_inf, $tmp->min )->last;
            my $after =  $a1->intersection( $tmp->max, $inf )->first;

            $before = $tmp->union( $before )->first;
            $after  = $tmp->union( $after )->last;

            $tmp = $tmp->union( $before )
                if defined $before && $tmp->intersects( $before );
            $tmp = $tmp->union( $after )
                if defined $after && $tmp->intersects( $after );
            return $tmp;
        }
    );

}


sub complement {
    my $a1 = shift;
    # do we have a parameter?
    if (@_) {
        my $b1 = (ref ($_[0]) eq ref($a1) ) ? shift : $a1->new(@_);

        $a1->trace_open(title=>"complement", arg => $b1) if $TRACE;
        $b1 = $b1->complement;
        my $tmp =$a1->intersection($b1);
        $a1->trace_close( arg => $tmp ) if $TRACE;
        return $tmp;
    }
    $a1->trace_open(title=>"complement") if $TRACE;
    if ($a1->{too_complex}) {
        $a1->trace_close( ) if $TRACE;
        return $a1->_function( 'complement', @_ );
    }
    return $a1->SUPER::complement;
}


sub until {
    my $a1 = shift;
    my $b1 = (ref ($_[0]) eq ref($a1) ) ? shift : $a1->new(@_);

    if (($a1->{too_complex}) or ($b1->{too_complex})) {
        return $a1->_function2( 'until', $b1 );
    }
    return $a1->SUPER::until( $b1 );
}


sub union {
    my $a1 = shift;
    my $b1 = (ref ($_[0]) eq ref($a1) ) ? shift : $a1->new(@_);  
    
    $a1->trace_open(title=>"union", arg => $b1) if $TRACE;
    if (($a1->{too_complex}) or ($b1->{too_complex})) {
        $a1->trace_close( ) if $TRACE;
        return $a1 if $b1->is_null;
        return $b1 if $a1->is_null;
        return $a1->_function2( 'union', $b1);
    }
    return $a1->SUPER::union( $b1 );
}


# there are some ways to process 'contains':
# A CONTAINS B IF A == ( A UNION B )
#    - faster
# A CONTAINS B IF B == ( A INTERSECTION B )
#    - can backtrack = works for unbounded sets
sub contains {
    my $a1 = shift;
    $a1->trace_open(title=>"contains") if $TRACE;
    if ( $a1->{too_complex} ) { 
        # we use intersection because it is better for backtracking
        my $b0 = (ref $_[0] eq ref $a1) ? shift : $a1->new(@_);
        my $b1 = $a1->intersection($b0);
        if ( $b1->{too_complex} ) {
            $b1->trace_close( arg => 'undef' ) if $TRACE;
            return undef;
        }
        $a1->trace_close( arg => ($b1 == $b0 ? 1 : 0) ) if $TRACE;
        return ($b1 == $b0) ? 1 : 0;
    }
    my $b1 = $a1->union(@_);
    if ( $b1->{too_complex} ) {
        $b1->trace_close( arg => 'undef' ) if $TRACE;
        return undef;
    }
    $a1->trace_close( arg => ($b1 == $a1 ? 1 : 0) ) if $TRACE;
    return ($b1 == $a1) ? 1 : 0;
}


sub min_a { 
    my $self = $_[0];
    return @{$self->{min}} if exists $self->{min};
    if ($self->{too_complex}) {
        my @first = $self->first;
        return @{$self->{min}} = $first[0]->min_a if defined $first[0];
        return @{$self->{min}} = (undef, 0);
    }
    return $self->SUPER::min_a;
};


sub max_a { 
    my $self = $_[0];
    return @{$self->{max}} if exists $self->{max};
    if ($self->{too_complex}) {
        my @last = $self->last;
        return @{$self->{max}} = $last[0]->max_a if defined $last[0];
        return @{$self->{max}} = (undef, 0);
    }
    return $self->SUPER::max_a;
};


sub count {
    my $self = $_[0];
    # NOTE: subclasses may return "undef" if necessary
    return $inf if $self->{too_complex};
    return $self->SUPER::count;
}


sub size { 
    my $self = $_[0];
    if ($self->{too_complex}) {
        my @min = $self->min_a;
        my @max = $self->max_a;
        return undef unless defined $max[0] && defined $min[0];
        return $max[0] - $min[0];
    }
    return $self->SUPER::size;
};


sub spaceship {
    my ($tmp1, $tmp2, $inverted) = @_;
    carp "Can't compare unbounded sets" 
        if $tmp1->{too_complex} or $tmp2->{too_complex};
    return $tmp1->SUPER::spaceship( $tmp2, $inverted );
}


sub _cleanup { @_ }    # this subroutine is obsolete


sub tolerance {
    my $self = shift;
    my $tmp = pop;
    if (ref($self)) {  
        # local
        return $self->{tolerance} unless defined $tmp;
        if ($self->{too_complex}) {
            my $b1 = $self->_function( 'tolerance', $tmp );
            $b1->{tolerance} = $tmp;   # for max/min processing
            return $b1;
        }
        return $self->SUPER::tolerance( $tmp );
    }
    # class method
    __PACKAGE__->SUPER::tolerance( $tmp ) if defined($tmp);
    return __PACKAGE__->SUPER::tolerance;   
}


sub _pretty_print {
    my $self = shift;
    return "$self" unless $self->{too_complex};
    return $self->{method} . "( " .
               ( ref($self->{parent}) eq 'ARRAY' ? 
                   $self->{parent}[0] . ' ; ' . $self->{parent}[1] : 
                   $self->{parent} ) .
           " )";
}


sub as_string {
    my $self = shift;
    return ( $PRETTY_PRINT ? $self->_pretty_print : $too_complex ) 
        if $self->{too_complex};
    return $self->SUPER::as_string;
}


sub DESTROY {}

1;

__END__


=head1 NAME

Set::Infinite - Sets of intervals


=head1 SYNOPSIS

  use Set::Infinite;

  $set = Set::Infinite->new(1,2);    # [1..2]
  print $set->union(5,6);            # [1..2],[5..6]


=head1 DESCRIPTION

Set::Infinite is a Set Theory module for infinite sets.

A set is a collection of objects. 
The objects that belong to a set are called its members, or "elements". 

As objects we allow (almost) anything:  reals, integers, and objects (such as dates).

We allow sets to be infinite.

There is no account for the order of elements. For example, {1,2} = {2,1}.

There is no account for repetition of elements. For example, {1,2,2} = {1,1,1,2} = {1,2}.

=head1 CONSTRUCTOR

=head2 new

Creates a new set object:

    $set = Set::Infinite->new;             # empty set
    $set = Set::Infinite->new( 10 );       # single element
    $set = Set::Infinite->new( 10, 20 );   # single range
    $set = Set::Infinite->new( 
              [ 10, 20 ], [ 50, 70 ] );    # two ranges

=over 4

=item empty set

    $set = Set::Infinite->new;

=item set with a single element

    $set = Set::Infinite->new( 10 );

    $set = Set::Infinite->new( [ 10 ] );

=item set with a single span

    $set = Set::Infinite->new( 10, 20 );

    $set = Set::Infinite->new( [ 10, 20 ] );
    # 10 <= x <= 20

=item set with a single, open span

    $set = Set::Infinite->new(
        {
            a => 10, open_begin => 0,
            b => 20, open_end => 1,
        }
    );
    # 10 <= x < 20

=item set with multiple spans

    $set = Set::Infinite->new( 10, 20,  100, 200 );

    $set = Set::Infinite->new( [ 10, 20 ], [ 100, 200 ] );

    $set = Set::Infinite->new(
        {
            a => 10, open_begin => 0,
            b => 20, open_end => 0,
        },
        {
            a => 100, open_begin => 0,
            b => 200, open_end => 0,
        }
    );

=back

The C<new()> method expects I<ordered> parameters.

If you have unordered ranges, you can build the set using C<union>:

    @ranges = ( [ 10, 20 ], [ -10, 1 ] );
    $set = Set::Infinite->new;
    $set = $set->union( @$_ ) for @ranges;

The data structures passed to C<new> must be I<immutable>.
So this is not good practice:

    $set = Set::Infinite->new( $object_a, $object_b );
    $object_a->set_value( 10 );

This is the recommended way to do it:

    $set = Set::Infinite->new( $object_a->clone, $object_b->clone );
    $object_a->set_value( 10 );


=head2 clone / copy

Creates a new object, and copy the object data.

=head2 empty_set

Creates an empty set.

If called from an existing set, the empty set inherits
the "type" and "density" characteristics.

=head2 universal_set

Creates a set containing "all" possible elements.

If called from an existing set, the universal set inherits
the "type" and "density" characteristics.

=head1 SET FUNCTIONS

=head2 union

    $set = $set->union($b);

Returns the set of all elements from both sets.

This function behaves like an "OR" operation.

    $set1 = new Set::Infinite( [ 1, 4 ], [ 8, 12 ] );
    $set2 = new Set::Infinite( [ 7, 20 ] );
    print $set1->union( $set2 );
    # output: [1..4],[7..20]

=head2 intersection

    $set = $set->intersection($b);

Returns the set of elements common to both sets.

This function behaves like an "AND" operation.

    $set1 = new Set::Infinite( [ 1, 4 ], [ 8, 12 ] );
    $set2 = new Set::Infinite( [ 7, 20 ] );
    print $set1->intersection( $set2 );
    # output: [8..12]

=head2 complement

=head2 minus

=head2 difference

    $set = $set->complement;

Returns the set of all elements that don't belong to the set.

    $set1 = new Set::Infinite( [ 1, 4 ], [ 8, 12 ] );
    print $set1->complement;
    # output: (-inf..1),(4..8),(12..inf)

The complement function might take a parameter:

    $set = $set->minus($b);

Returns the set-difference, that is, the elements that don't
belong to the given set.

    $set1 = new Set::Infinite( [ 1, 4 ], [ 8, 12 ] );
    $set2 = new Set::Infinite( [ 7, 20 ] );
    print $set1->minus( $set2 );
    # output: [1..4]

=head2 symmetric_difference

Returns a set containing elements that are in either set,
but not in both. This is the "set" version of "XOR".

=head1 DENSITY METHODS    

=head2 real

    $set1 = $set->real;

Returns a set with density "0".

=head2 integer

    $set1 = $set->integer;

Returns a set with density "1".

=head1 LOGIC FUNCTIONS

=head2 intersects

    $logic = $set->intersects($b);

=head2 contains

    $logic = $set->contains($b);

=head2 is_empty

=head2 is_null

    $logic = $set->is_null;

=head2 is_nonempty 

This set that has at least 1 element.

=head2 is_span 

This set that has a single span or interval.

=head2 is_singleton

This set that has a single element.

=head2 is_subset( $set )

Every element of this set is a member of the given set.

=head2 is_proper_subset( $set )

Every element of this set is a member of the given set.
Some members of the given set are not elements of this set.

=head2 is_disjoint( $set )

The given set has no elements in common with this set.

=head2 is_too_complex

Sometimes a set might be too complex to enumerate or print.

This happens with sets that represent infinite recurrences, such as
when you ask for a quantization on a
set bounded by -inf or inf.

See also: C<count> method.

=head1 SCALAR FUNCTIONS

=head2 min

    $i = $set->min;

=head2 max

    $i = $set->max;

=head2 size

    $i = $set->size;  

=head2 count

    $i = $set->count;

=head1 OVERLOADED OPERATORS

=head2 stringification

    print $set;

    $str = "$set";

See also: C<as_string>.

=head2 comparison

    sort

    > < == >= <= <=> 

See also: C<spaceship> method.

=head1 CLASS METHODS

    Set::Infinite->separators(@i)

        chooses the interval separators for stringification. 

        default are [ ] ( ) '..' ','.

    inf

        returns an 'Infinity' number.

    minus_inf

        returns '-Infinity' number.

=head2 type

    type( "My::Class::Name" )

Chooses a default object data type.

Default is none (a normal Perl SCALAR).


=head1 SPECIAL SET FUNCTIONS

=head2 span

    $set1 = $set->span;

Returns the set span.

=head2 until

Extends a set until another:

    0,5,7 -> until 2,6,10

gives

    [0..2), [5..6), [7..10)

=head2 start_set

=head2 end_set

These methods do the inverse of the "until" method.

Given:

    [0..2), [5..6), [7..10)

start_set is:

    0,5,7

end_set is:

    2,6,10

=head2 intersected_spans

    $set = $set1->intersected_spans( $set2 );

The method returns a new set,
containing all spans that are intersected by the given set.

Unlike the C<intersection> method, the spans are not modified.
See diagram below:

               set1   [....]   [....]   [....]   [....]
               set2      [................]

       intersection      [.]   [....]   [.]

  intersected_spans   [....]   [....]   [....]


=head2 quantize

    quantize( parameters )

        Makes equal-sized subsets.

        Returns an ordered set of equal-sized subsets.

        Example: 

            $set = Set::Infinite->new([1,3]);
            print join (" ", $set->quantize( quant => 1 ) );

        Gives: 

            [1..2) [2..3) [3..4)

=head2 select

    select( parameters )

Selects set spans based on their ordered positions

C<select> has a behaviour similar to an array C<slice>.

            by       - default=All
            count    - default=Infinity

 0  1  2  3  4  5  6  7  8      # original set
 0  1  2                        # count => 3 
    1              6            # by => [ -2, 1 ]

=head2 offset

    offset ( parameters )

Offsets the subsets. Parameters: 

    value   - default=[0,0]
    mode    - default='offset'. Possible values are: 'offset', 'begin', 'end'.
    unit    - type of value. Can be 'days', 'weeks', 'hours', 'minutes', 'seconds'.

=head2 iterate

    iterate ( sub { } , @args )

Iterates on the set spans, over a callback subroutine. 
Returns the union of all partial results.

The callback argument C<$_[0]> is a span. If there are additional arguments they are passed to the callback.

The callback can return a span, a hashref (see C<Set::Infinite::Basic>), a scalar, an object, or C<undef>.

[EXPERIMENTAL]
C<iterate> accepts an optional C<backtrack_callback> argument. 
The purpose of the C<backtrack_callback> is to I<reverse> the
iterate() function, overcoming the limitations of the internal
backtracking algorithm.
The syntax is:

    iterate ( sub { } , backtrack_callback => sub { }, @args )

The C<backtrack_callback> can return a span, a hashref, a scalar, 
an object, or C<undef>. 

For example, the following snippet adds a constant to each
element of an unbounded set:

    $set1 = $set->iterate( 
                 sub { $_[0]->min + 54, $_[0]->max + 54 }, 
              backtrack_callback =>  
                 sub { $_[0]->min - 54, $_[0]->max - 54 }, 
              );

=head2 first / last

    first / last

In scalar context returns the first or last interval of a set.

In list context returns the first or last interval of a set, 
and the remaining set (the 'tail').

See also: C<min>, C<max>, C<min_a>, C<max_a> methods.

=head2 type

    type( "My::Class::Name" )

Chooses a default object data type. 

default is none (a normal perl SCALAR).


=head1 INTERNAL FUNCTIONS

=head2 _backtrack

    $set->_backtrack( 'intersection', $b );

Internal function to evaluate recurrences.

=head2 numeric

    $set->numeric;

Internal function to ignore the set "type".
It is used in some internal optimizations, when it is
possible to use scalar values instead of objects.

=head2 fixtype

    $set->fixtype;

Internal function to fix the result of operations
that use the numeric() function.

=head2 tolerance

    $set = $set->tolerance(0)    # defaults to real sets (default)
    $set = $set->tolerance(1)    # defaults to integer sets

Internal function for changing the set "density".

=head2 min_a

    ($min, $min_is_open) = $set->min_a;

=head2 max_a

    ($max, $max_is_open) = $set->max_a;


=head2 as_string

Implements the "stringification" operator.

Stringification of unbounded recurrences is not implemented.

Unbounded recurrences are stringified as "function descriptions",
if the class variable $PRETTY_PRINT is set.

=head2 spaceship

Implements the "comparison" operator.

Comparison of unbounded recurrences is not implemented.


=head1 CAVEATS

=over 4

=item * constructor "span" notation

    $set = Set::Infinite->new(10,1);

Will be interpreted as [1..10]

=item * constructor "multiple-span" notation

    $set = Set::Infinite->new(1,2,3,4);

Will be interpreted as [1..2],[3..4] instead of [1,2,3,4].
You probably want ->new([1],[2],[3],[4]) instead,
or maybe ->new(1,4) 

=item * "range operator"

    $set = Set::Infinite->new(1..3);

Will be interpreted as [1..2],3 instead of [1,2,3].
You probably want ->new(1,3) instead.

=back

=head1 INTERNALS

The base I<set> object, without recurrences, is a C<Set::Infinite::Basic>.

A I<recurrence-set> is represented by a I<method name>, 
one or two I<parent objects>, and extra arguments.
The C<list> key is set to an empty array, and the
C<too_complex> key is set to C<1>.

This is a structure that holds the union of two "complex sets":

  {
    too_complex => 1,             # "this is a recurrence"
    list   => [ ],                # not used
    method => 'union',            # function name
    parent => [ $set1, $set2 ],   # "leaves" in the syntax-tree
    param  => [ ]                 # optional arguments for the function
  }

This is a structure that holds the complement of a "complex set":

  {
    too_complex => 1,             # "this is a recurrence"
    list   => [ ],                # not used
    method => 'complement',       # function name
    parent => $set,               # "leaf" in the syntax-tree
    param  => [ ]                 # optional arguments for the function
  }


=head1 SEE ALSO

See modules DateTime::Set, DateTime::Event::Recurrence, 
DateTime::Event::ICal, DateTime::Event::Cron
for up-to-date information on date-sets.

The perl-date-time project <http://datetime.perl.org> 


=head1 AUTHOR

Flavio S. Glock <fglock@gmail.com>

=head1 COPYRIGHT

Copyright (c) 2003 Flavio Soibelmann Glock.  All rights reserved.  
This program is free software; you can redistribute it and/or modify 
it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=cut

