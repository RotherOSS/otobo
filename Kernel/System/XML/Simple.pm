# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::System::XML::Simple;

use strict;
use warnings;

use XML::LibXML::Simple;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::XML::Simple - Turn XML into a Perl structure

=head1 DESCRIPTION

Turn XML into a Perl structure.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 XMLIn()

Turns given XML data into Perl structure.
The resulting Perl structure can be in adjusted with options.
Available options can be found here:
http://search.cpan.org/~markov/XML-LibXML-Simple-0.97/lib/XML/LibXML/Simple.pod#Parameter_%options

    # XML from file:
    my $PerlStructure = $XMLSimpleObject->XMLIn(
        XMLInput => '/xml/items.xml',
        Options  => {
            ForceArray   => 1,
            ForceContent => 1,
            ContentKey   => 'Content',
        },
    );

    # XML from string:
    my $PerlStructure = $XMLSimpleObject->XMLIn(
        XMLInput => '<MyXML><Item Type="String">My content</Item><Item Type="Number">23</Item></MyXML>',
        Options  => {
            ForceArray   => 1,
            ForceContent => 1,
            ContentKey   => 'Content',
        },
    );

    Results in:

    my $PerlStructure = {
        Item => [
            {
                Type    => 'String',
                Content => 'My content',
            },
            {
                Type    => 'Number',
                Content => '23',
            },
        ],
    };

=cut

sub XMLIn {
    my ( $Self, %Param ) = @_;

    if ( !$Param{XMLInput} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need parameter XMLInput!",
        );
        return;
    }

    if ( exists $Param{Options} && ref $Param{Options} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Parameter Options needs to be a hash ref!",
        );
        return;
    }

    my $PerlStructure;
    eval {

        my $XMLSimpleObject = XML::LibXML::Simple->new();

        $PerlStructure = $XMLSimpleObject->XMLin(
            $Param{XMLInput},
            $Param{Options} ? %{ $Param{Options} } : (),
        );
    };

    my $Error = $@;
    if ($Error) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error parsing XML: $Error",
        );
        return;
    }

    return $PerlStructure;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
