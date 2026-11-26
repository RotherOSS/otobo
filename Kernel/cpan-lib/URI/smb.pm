package URI::smb;

use strict;
use warnings;

use parent 'URI::_login';

use URI::Escape qw(uri_escape uri_unescape);

our $VERSION = '5.40';

sub default_port {445}

sub user {
    my $self = shift;
    my $new  = shift;
    my ($user, $authdomain) = _parse_user($self->_raw_user);
    if ($new) {
        $self->_raw_user($authdomain
            ? _smb_escape($authdomain) . ';' . _smb_escape($new)
            : _smb_escape($new));
        $user = $new;
    }
    return $user;
}

sub authdomain {
    my $self = shift;
    my $new  = shift;
    my ($user, $authdomain) = _parse_user($self->_raw_user);

    # it must not be possible to set authdomain without user
    if ($user && $new) {
        $self->_raw_user(_smb_escape($new) . ';' . _smb_escape($user));
        $authdomain = $new;
    }
    return $authdomain;
}

sub sharename {
    return (shift->path_segments)[1];
}

# The 'authdomain;user' slice of userinfo, still percent-encoded, so that ';'
# is split before it is decoded (a %3B in a username is data, not a delimiter).
sub _raw_user {
    my $self = shift;
    my $info = $self->userinfo;
    if (@_) {
        my $pass = defined($info) ? $info : '';
        $pass =~ s/^[^:]*//;
        $self->userinfo(shift(@_) . $pass);
    }
    return undef unless defined $info;
    $info =~ s/:.*//;
    return $info;
}

# userinfo() escapes everything except '%', ';' and ':', which here start an
# escape or delimit authdomain;user:password, so escape those ourselves.
sub _smb_escape {
    my $str = shift;
    return uri_escape($str, '%;:');
}

sub _parse_user {
    my $input = shift or return;
    my ($authdomain, $user) = split ';', $input, 2;
    return $user
        ? (uri_unescape($user), uri_unescape($authdomain))
        : uri_unescape($authdomain);
}

1;
__END__

=head1 NAME

URI::smb - Samba/CIFS URI scheme

=head1 SYNOPSIS

    my $uri = URI->new('smb://authdomain;user:password@server/share/path');

=head1 DESCRIPTION

This module implements the (unofficial) C<smb:> URI scheme described in L<http://www.ubiqx.org/cifs/Appendix-D.html>.

=head1 SUBROUTINES/METHODS

=head2 default_port

The default port for accessing Samba/Windows File Servers is 445

=head2 user

Get or set the user part of the URI (without the authdomain)

=head2 authdomain

Get or set the authentication authdomain part of the URI. This value is only available if the user is already set.

=head2 sharename

Helper method to get the share name from path

=head1 DEPENDENCIES

None

=head1 BUGS AND LIMITATIONS

See L<URI|URI#BUGS>

=head1 SEE ALSO

L<http://www.ubiqx.org/cifs/Appendix-D.html>

=head1 AUTHOR

I. M. Bur <github@lty.cz>

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.
