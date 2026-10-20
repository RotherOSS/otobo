package Sisimai::Address;
use v5.26;
use strict;
use warnings;
use Class::Accessor::Lite (
    'new' => 0,
    'ro'  => [
        'address',  # [String] Email address
        'user',     # [String] local part of the email address
        'host',     # [String] domain part of the email address
        'verp',     # [String] VERP
        'alias',    # [String] alias of the email address
    ],
    'rw'  => [
        'name',     # [String] Display name
        'comment',  # [String] (Comment)
    ]
);
use Sisimai::RFC1123;

sub undisclosed {
    # Return pseudo recipient or sender address
    # @param    [String] argv0  Address type: true = recipient, false = sender
    # @return   [String]        Pseudo recipient address or sender address or an empty value when
    #                           the $argv0 is neither 'r' nor 's'
    my $class = shift;
    my $argv0 = shift // 0;
    my $local = $argv0 ? 'recipient' : 'sender';
    return sprintf("undisclosed-%s-in-headers%slibsisimai.org.invalid", $local, '@');
}

sub is_emailaddress {
    # Check that the argument is an email address or not
    # @param    [String] email  Email address string
    # @return   [Integer]       0: Not email address
    #                           1: Email address
    my $class =  shift;
    my $email =  shift // return 0; return 0 if length($email) < 5;
       $email =~ s/\A[\s\t]+//; $email =~ s/[\s\t]+\z//;

    my $width = length($email);
    my $lasta = rindex($email, '@');

    return 0 if $width > 254;               # The maximum length of an email address is 254
    return 0 if $lasta < 1 || $lasta > 64;  # The maximum length of a local part is 64
    return 0 if $width - $lasta > 253;      # The maximum length of a domain part is 252

    my $quote = __PACKAGE__->is_quotedaddress($email); unless( $quote ) {
        # The email address is not a quoted address
        return 0 if index($email, '@') != $lasta; # There are 2 or more '@'.
        return 0 if index($email, ' ') > 0;       # There is 1 or more ' '.
    }
    my $ipv46 = Sisimai::RFC1123->is_domainliteral($email);

    my $j = -1; for my $e ( split('', $email) ) {
        # 31 < The ASCII code of each character < 127
        my $p = ord($e); $j++;

        if( $j < $lasta ) {
            # A local part of the email address: string before the last "@"
            return 0 if $p < 32 || $p > 126;    # Before ' ', After  '~'
            next     if $j == 0;                # The character is the first character

            if( $quote ) {
                # The email address has quoted local part like "neko@cat"@example.org
                my $jp = substr($email, $j - 1, 1);
                if( ord($jp) == 92 ) { # 92 = '\'
                    # When the previous character IS '\', only the followings are allowed: '\', '"'
                    return 0 if $p != 92 && $p != 34;

                } else {
                    # When the previous character IS NOT '\'
                    return 0 if $p == 34 && $j + 1 < $lasta;
                }
            } else {
                # The local part is not quoted
                # ".." is not allowed in a local part when the local part is not quoted by "" but
                # Non-RFC compliant email addresses still persist in the world.
                #
                # The following characters are not allowed in a local part without "..."@example.jp
                return 0 if $e eq ',' || $e eq '@' || $e eq ':' || $e eq ';' || $e eq '(';
                return 0 if $e eq ')' || $e eq '<' || $e eq '>' || $e eq '[' || $e eq ']';
            }
        } else {
            # A domain part of the email address: string after the last "@"
            next     if $p ==  64;  # '@'
            return 0 if $p <   45;  # Before '-'
            return 0 if $p ==  47;  # Equals '/'
            return 0 if $p ==  92;  # Equals '\'
            return 0 if $p >  122;  # After  'z'

            if( $ipv46 == 0 ) {
                # Such as "example.jp", "neko.example.org"
                return 0 if $p > 57 && $p < 64; # ':' to '?'
                return 0 if $p > 90 && $p < 97; # '[' to '`'

            } else {
                # Such as "[IPv4:192.0.2.25]"
                return 0 if $p > 59 && $p < 64; # ';' to '?'
                return 0 if $p > 93 && $p < 97; # '^' to '`'
            }
        }
    }
    return 1 if $ipv46;
    return Sisimai::RFC1123->is_internethost(substr($email, $lasta + 1,));
}

sub is_quotedaddress {
    # Checks that the local part of the argument is quoted address or not.
    # @param    [String] argv0  Email address
    # @return   [Integer]       0: is not a quoted address
    #                           1: is a quoted address
    my $class = shift;
    my $argv0 = shift;
    return 1 if index($argv0, '"') == 0 && index($argv0, '"@') > 1;
    return 0;
}

sub is_mailerdaemon {
    # Check that the argument is mailer-daemon or not
    # @param    [String] argv0  Email address
    # @return   [Integer]       0: Not mailer-daemon
    #                           1: Mailer-daemon
    my $class = shift;
    my $argv0 = shift // return 0;
    my $email = lc $argv0;

    state $postmaster = [
        'mailer-daemon@', '<mailer-daemon>', '(mailer-daemon)', ' mailer-daemon ',
        'postmaster@', '<postmaster>', '(postmaster)'
    ];
    return 1 if grep { index($email, $_) > -1 } @$postmaster;
    return 1 if $email eq 'mailer-daemon' || $email eq 'postmaster';
    return 0;
}

sub new {
    # Constructor of Sisimai::Address
    # @param    [Hash] argvs        Email address, name, and other elements
    # @return   [Sisimai::Address]  Object or undef when the email address was not valid
    # @since    v4.22.1
    my $class = shift;
    my $argvs = shift // return undef; return undef if ref $argvs ne 'HASH';
    my $thing = {
        'address' => '',    # Entire email address
        'user'    => '',    # Local part
        'host'    => '',    # Domain part
        'verp'    => '',    # VERP
        'alias'   => '',    # Alias
        'comment' => '',    # Comment
        'name'    => '',    # Display name
    };

    return undef unless exists $argvs->{'address'};
    return undef unless $argvs->{'address'};

    my $heads = ['<'];
    my $tails = ['>', ',', '.', ';'];
    my $point = rindex($argvs->{'address'}, '@');

    if( $point > 0 ) {
        # Get the local part and the domain part from the email address
        my $lpart = substr($argvs->{'address'}, 0, $point);
        my $dpart = substr($argvs->{'address'}, $point+1,);
        my $email = __PACKAGE__->expand_verp($argvs->{'address'}) || '';
        my $alias = 0;

        unless( $email ) {
            # Is not VERP address, try to expand the address as an alias
            $email = __PACKAGE__->expand_alias($argvs->{'address'}) || '';
            $alias = 1 if $email;
        }

        if( index($email, '@') > 0 ) {
            # The address is a VERP or an alias
            if( $alias ) {
                # The address is an alias: neko+nyaan@example.jp
                $thing->{'alias'} = $argvs->{'address'};

            } else {
                # The address is a VERP: b+neko=example.jp@example.org
                $thing->{'verp'}  = $argvs->{'address'};
            }
        }

        do { while( substr($lpart,  0, 1) eq $_ ) { substr($lpart,  0, 1, '') }} for @$heads;
        do { while( substr($dpart, -1, 1) eq $_ ) { substr($dpart, -1, 1, '') }} for @$tails;
        $thing->{'user'}    = $lpart;
        $thing->{'host'}    = $dpart;
        $thing->{'address'} = $lpart.'@'.$dpart;

    } else {
        # The argument does not include "@"
        return undef unless __PACKAGE__->is_mailerdaemon($argvs->{'address'});
        return undef if rindex($argvs->{'address'}, ' ') > -1;

        # The argument does not include " "
        $thing->{'user'}    = $argvs->{'address'};
        $thing->{'address'} = $argvs->{'address'};
    }

    $thing->{'name'}    = $argvs->{'name'}    || '';
    $thing->{'comment'} = $argvs->{'comment'} || '';
    return bless($thing, __PACKAGE__);
}

sub find {
    # Email address parser with a name and a comment
    # @param    [String] argv1  String including email address
    # @param    [Boolean] addrs 0 = Returns list including all the elements
    #                           1 = Returns list including email addresses only
    # @return   [Array]         Email address list or undef when there is no email address in the argument
    # @since    v4.22.0
    my $class = shift;
    my $argv1 = shift // return undef; y/\r//d, y/\n//d for $argv1; # Remove CR, NL
    my $addrs = shift // undef;

    require Sisimai::String;
    state $indicators = {
        'email-address' => (1 << 0),    # <neko@example.org>
        'quoted-string' => (1 << 1),    # "Neko, Nyaan"
        'comment-block' => (1 << 2),    # (neko)
    };
    state $delimiters = {'<' => 1, '>' => 1, '(' => 1, ')' => 1, '"' => 1, ',' => 1};
    state $validemail = qr{(?>
        (?:([^\s]+|["].+?["]))          # local part
        [@]
        (?:([^@\s]+|[0-9A-Za-z:\.]+))   # domain part
        )
    }x;

    my $emailtable = {'address' => '', 'name' => '', 'comment' => ''};
    my $addrtables = [];
    my @readbuffer;
    my $readcursor = 0;
    my $v = $emailtable;   # temporary buffer
    my $p = '';            # current position

    for my $e ( split('', $argv1) ) {
        # Check each characters
        if( $delimiters->{ $e } ) {
            # The character is a delimiter character
            if( $e eq ',' ) {
                # Separator of email addresses or not
                if(  index($v->{'address'}, '<') == 0 &&
                    rindex($v->{'address'}, '@') > -1 &&
                    substr($v->{'address'}, -1, 1) eq '>' ) {
                    # An email address has already been picked
                    if( $readcursor & $indicators->{'comment-block'} ) {
                        # The cursor is in the comment block (Neko, Nyaan)
                        $v->{'comment'} .= $e;

                    } elsif( $readcursor & $indicators->{'quoted-string'} ) {
                        # "Neko, Nyaan"
                        $v->{'name'} .= $e;

                    } else {
                        # The cursor is not in neither the quoted-string nor the comment block
                        $readcursor = 0;    # reset cursor position
                        push @readbuffer, $v;
                        $v = {'address' => '', 'name' => '', 'comment' => ''};
                        $p = '';
                    }
                } else {
                    # "Neko, Nyaan" <neko@nyaan.example.org> OR <"neko,nyaan"@example.org>
                    $p ? ($v->{ $p } .= $e) : ($v->{'name'} .= $e);
                }
                next;
            } # End of if(',')

            if( $e eq '<' ) {
                # <: The beginning of an email address or not
                if( $v->{'address'} ) {
                    $p ? ($v->{ $p } .= $e) : ($v->{'name'} .= $e);

                } else {
                    # <neko@nyaan.example.org>
                    $readcursor |= $indicators->{'email-address'};
                    $v->{'address'} .= $e;
                    $p = 'address';
                }
                next;
            } # End of if('<')

            if( $e eq '>' ) {
                # >: The end of an email address or not
                if( $readcursor & $indicators->{'email-address'} ) {
                    # <neko@example.org>
                    $readcursor &= ~$indicators->{'email-address'};
                    $v->{'address'} .= $e;
                    $p = '';

                } else {
                    # a comment block or a display name
                    $p ? ($v->{'comment'} .= $e) : ($v->{'name'} .= $e);
                }
                next;
            } # End of if('>')

            if( $e eq '(' ) {
                # The beginning of a comment block or not
                if( $readcursor & $indicators->{'email-address'} ) {
                    # <"neko(nyaan)"@example.org> or <neko(nyaan)@example.org>
                    if( rindex($v->{'address'}, '"') > -1 ) {
                        # Quoted local part: <"neko(nyaan)"@example.org>
                        $v->{'address'} .= $e;

                    } else {
                        # Comment: <neko(nyaan)@example.org>
                        $readcursor |= $indicators->{'comment-block'};
                        $v->{'comment'} .= ' ' if substr($v->{'comment'}, -1, 1) eq ')';
                        $v->{'comment'} .= $e;
                        $p = 'comment';
                    }
                } elsif( $readcursor & $indicators->{'comment-block'} ) {
                    # Comment at the outside of an email address (...(...)
                    $v->{'comment'} .= ' ' if substr($v->{'comment'}, -1, 1) eq ')';
                    $v->{'comment'} .= $e;

                } elsif( $readcursor & $indicators->{'quoted-string'} ) {
                    # "Neko, Nyaan(cat)", Deal as a display name
                    $v->{'name'} .= $e;

                } else {
                    # The beginning of a comment block
                    $readcursor |= $indicators->{'comment-block'};
                    $v->{'comment'} .= ' ' if substr($v->{'comment'}, -1, 1) eq ')';
                    $v->{'comment'} .= $e;
                    $p = 'comment';
                }
                next;
            } # End of if('(')

            if( $e eq ')' ) {
                # The end of a comment block or not
                if( $readcursor & $indicators->{'email-address'} ) {
                    # <"neko(nyaan)"@example.org> OR <neko(nyaan)@example.org>
                    if( rindex($v->{'address'}, '"') > -1 ) {
                        # Quoted string in the local part: <"neko(nyaan)"@example.org>
                        $v->{'address'} .= $e;

                    } else {
                        # Comment: <neko(nyaan)@example.org>
                        $readcursor &= ~$indicators->{'comment-block'};
                        $v->{'comment'} .= $e;
                        $p = 'address';
                    }
                } elsif( $readcursor & $indicators->{'comment-block'} ) {
                    # Comment at the outside of an email address (...(...)
                    $readcursor &= ~$indicators->{'comment-block'};
                    $v->{'comment'} .= $e;
                    $p = '';

                } else {
                    # Deal as a display name
                    $readcursor &= ~$indicators->{'comment-block'};
                    $v->{'name'} .= $e;
                    $p = '';
                }
                next;
            } # End of if(')')

            if( $e eq '"' ) {
                # The beginning or the end of a quoted-string
                if( $p ) {
                    # email-address or comment-block
                    $v->{ $p } .= $e;

                } else {
                    # Display name like "Neko, Nyaan"
                    $v->{'name'} .= $e;
                    next unless $readcursor & $indicators->{'quoted-string'};
                    next if substr($v->{'name'}, -2, 2) eq qq|\x5c"|;   # "Neko, Nyaan \"...
                    $readcursor &= ~$indicators->{'quoted-string'};
                    $p = '';
                }
                next;
            } # End of if('"')
        } else {
            # The character is not a delimiter
            $p ? ($v->{ $p } .= $e) : ($v->{'name'} .= $e);
            next;
        }
    }

    if( $v->{'address'} ) {
        # Push the latest values
        push @readbuffer, $v;

    } else {
        # No email address like <neko@example.org> in the argument
        if( $v->{'name'} =~ $validemail ) {
            # String like an email address will be set to the value of "address"
            $v->{'address'} = $1.'@'.$2;

        } elsif( __PACKAGE__->is_mailerdaemon($v->{'name'}) ) {
            # Allow if the argument is MAILER-DAEMON
            $v->{'address'} = $v->{'name'};
        }

        if( $v->{'address'} ) {
            # Remove the comment from the address
            if( Sisimai::String->aligned(\$v->{'address'}, ['(', ')']) ) {
                # (nyaan)nekochan@example.org, nekochan(nyaan)cat@example.org or
                # nekochan(nyaan)@example.org
                my $p1 = index($v->{'address'}, '(');
                my $p2 = index($v->{'address'}, ')');
                $v->{'address'} = substr($v->{'address'}, 0, $p1).substr($v->{'address'}, $p2 + 1,);
                $v->{'comment'} = substr($v->{'address'}, $p1, $p2 - $p1 - 1);
            }
            push @readbuffer, $v;
        }
    }

    for my $e ( @readbuffer ) {
        # The element must not include any character except from 0x20 to 0x7e.
        next if $e->{'address'} =~ /[^\x20-\x7e]/;
        if( index($e->{'address'}, '@') == -1 ) {
            # Allow if the argument is MAILER-DAEMON
            next unless __PACKAGE__->is_mailerdaemon($e->{'address'});
        }

        # Remove angle brackets, other brackets, and quotations: []<>{}'` except a domain part is
        # an IP address like neko@[192.0.2.222]
        s/\A[\[<{('`]//g, s/[.,'`>});]\z//g for $e->{'address'};
        $e->{'address'} =~ s/[^A-Za-z]\z//g unless index($e->{'address'}, '@[') > 1;

        if( index($e->{'address'}, '"@') < 0 ) {
            # Remove double-quotations
            substr($e->{'address'},  0, 1, '') if substr($e->{'address'},  0, 1) eq '"';
            substr($e->{'address'}, -1, 1, '') if substr($e->{'address'}, -1, 1) eq '"';
        }

        if( $addrs ) {
            # Almost compatible with parse() method, returns email address only
            delete $e->{'name'};
            delete $e->{'comment'};

        } else {
            # Remove double-quotations, trailing spaces.
            for my $f ('name', 'comment') { s/\A[ ]//g, s/[ ]\z//g for $e->{ $f } }
            $e->{'comment'} = ''   unless $e->{'comment'} =~ /\A[(].+[)]\z/;
            $e->{'name'} =~ y/ //s    unless $e->{'name'} =~ /\A["].+["]\z/;
            $e->{'name'} =~ s/\A["]// unless $e->{'name'} =~ /\A["].+["][@]/;
            substr($e->{'name'}, -1, 1, '') if substr($e->{'name'}, -1, 1) eq '"';
        }
        push @$addrtables, $e;
    }

    return undef unless scalar @$addrtables;
    return $addrtables;
}

sub s3s4 {
    # Runs like ruleset 3,4 of sendmail.cf
    # @param    [String] input  Text including an email address
    # @return   [String]        Email address without comment, brackets
    my $class = shift;
    my $input = shift // return "";
    my $addrs = __PACKAGE__->find($input, 1) || [];
    return $input unless scalar @$addrs;
    return $addrs->[0]->{'address'};
}

sub expand_verp {
    # Expand VERP: Get the original recipient address from VERP
    # @param    [String] email  VERP Address
    # @return   [String]        Email address
    my $class = shift;
    my $email = shift // return "";
    my $local = (split('@', $email, 2))[0];

    # bounce+neko=example.org@example.org => neko@example.org
    return "" unless $local =~ /\A[-_\w]+?[+](\w[-._\w]+\w)[=](\w[-.\w]+\w)\z/;
    my $verp0 = $1.'@'.$2;
    return $verp0 if __PACKAGE__->is_emailaddress($verp0);
}

sub expand_alias {
    # Expand alias: remove from '+' to '@'
    # @param    [String] email  Email alias string
    # @return   [String]        Expanded email address
    my $class = shift;
    my $email = shift // return ""; return "" unless __PACKAGE__->is_emailaddress($email);

    # neko+straycat@example.org => neko@example.org
    my @local = split('@', $email);
    return "" unless $local[0] =~ /\A([-_\w]+?)[+].+\z/;
    return $1.'@'.$local[1];
}

sub TO_JSON {
    # Instance method for JSON::encode()
    # @return   [String] The value of "address" accessor
    my $self = shift; return $self->address;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Address - Email address object

=head1 SYNOPSIS

    use Sisimai::Address;

    my $v = Sisimai::Address->new({ 'address' => 'neko@example.org' });
    print $v->user;     # neko
    print $v->host;     # example.org
    print $v->address;  # neko@example.org

    print Sisimai::Address->is_emailaddress('neko@example.jp');    # 1
    print Sisimai::Address->is_domainpart('example.jp');           # 1
    print Sisimai::Address->is_mailerdaemon('neko@example.jp');    # 0

=head1 DESCRIPTION

C<Sisimai::Address> provide methods for dealing email address.

=head1 CLASS METHODS

=head2 C<B<is_emailaddress(I<email address>)>>

C<is_emailaddress()> method checks the argument is valid email address or not.

    print Sisimai::Address->is_emailaddress('neko@example.jp');  # 1
    print Sisimai::Address->is_emailaddress('neko%example.jp');  # 0

    my $addr_with_name = [
        'Stray cat <neko@example.jp',
        '=?UTF-8?B?55m954yr?= <shironeko@example.co.jp>',
    ];
    for my $e ( @$addr_with_name ) {
        print Sisimai::Address->is_emailaddress($e); # 1
    }

=head2 C<B<is_quotedaddress(I<email address>)>>

C<is_quotedaddress()> method returns 1 if an argument is like "neko@nyaan"@example.jp

    print Sisimai::Address->is_quotedaddress('"neko@nyaan"@example.jp'); # 1
    print Sisimai::Address->is_quotedaddress('neko-nyaan@example.org');  # 0

=head2 C<B<is_mailerdaemon(I<email address>)>>

C<is_mailerdaemon()> method checks the argument is B<mailer-daemon> or not.

    print Sisimai::Address->is_mailerdaemon('neko@example.jp');          # 0
    print Sisimai::Address->is_mailerdaemon('mailer-daemon@example.jp'); # 1

=head2 C<B<find(I<String>)>>

C<find()> method is a new parser for getting only the email address from the given string including
an email addresses.

    my $r = 'Stray cat <cat@example.org>, nyaa@example.org (White Cat)',
    my $v = Sisimai::Address->find($r);

    warn Dumper $v;
    $VAR1 = [
              {
                'name' => 'Stray cat',
                'address' => 'cat@example.org',
                'comment' => ''
              },
              {
                'name' => '',
                'address' => 'nyaa@example.jp',
                'comment' => '(White Cat)'
              }
    ];

=head2 C<B<s3s4(I<email address>)>>

C<s3s4()> method works Ruleset 3, and 4 of F<sendmail.cf>.

    my $r = [
        'Stray cat <cat@example.org>',
        'nyaa@example.org (White Cat)',
    ];

    for my $e ( @$r ) {
        print Sisimai::Address->s3s4($e);   # cat@example.org
                                            # nyaa@example.org
    }

=head2 C<B<expand_verp(I<email address>)>>

C<expand_verp()> method gets the original email address from C<VERP>

    my $r = 'nyaa+neko=example.org@example.org';
    print Sisimai::Address->expand_verp($r); # neko@example.org

=head2 C<B<expand_alias(I<email address>)>>

C<expand_alias()> method gets the original email address from the alias address

    my $r = 'nyaa+neko@example.org';
    print Sisimai::Address->expand_alias($r); # nyaa@example.org

=head1 INSTANCE METHODS

=head2 C<B<user()>>

C<user()> method returns a local part of the email address.

    my $v = Sisimai::Address->new({ 'address' => 'neko@example.org' });
    print $v->user;     # neko

=head2 C<B<host()>>

C<host()> method returns a domain part of the email address.

    my $v = Sisimai::Address->new({ 'address' => 'neko@example.org' });
    print $v->host;     # example.org

=head2 C<B<address()>>

C<address()> method returns an email address

    my $v = Sisimai::Address->new({ 'address' => 'neko@example.org' });
    print $v->address;     # neko@example.org

=head2 C<B<verp()>>

C<verp()> method returns a VERP email address

    my $v = Sisimai::Address->new({ 'address' => 'neko+nyaan=example.org@example.org' });
    print $v->verp;     # neko+nyaan=example.org@example.org
    print $v->address;  # nyaan@example.org

=head2 C<B<alias()>>

C<alias()> method returns an email address (alias)

    my $v = Sisimai::Address->new({ 'address' => 'neko+nyaan@example.org' });
    print $v->alias;    # neko+nyaan@example.org
    print $v->address;  # neko@example.org

=head2 C<B<name()>>

C<name()> method returns a display name

    my $e = '"Neko, Nyaan" <neko@example.org>';
    my $r = Sisimai::Address->find($e);
    my $v = Sisimai::Address->new($r->[0]);
    print $v->address;  # neko@example.org
    print $v->name;     # Neko, Nyaan

=head2 C<B<comment()>>

C<comment()> method returns a comment

    my $e = '"Neko, Nyaan" <neko(nyaan)@example.org>';
    my $v = Sisimai::Address->new(shift Sisimai::Address->find($e)->@*);
    print $v->address;  # neko@example.org
    print $v->comment;  # nyaan

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2025 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
