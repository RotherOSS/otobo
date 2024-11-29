# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

package Kernel::GenericInterface::Mapping::XSLT;

use strict;
use warnings;

# core modules
use Storable qw(dclone);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Mapping::XSLT - GenericInterface C<XSLT> data mapping backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Mapping->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Check needed params.
    for my $Needed (qw(DebuggerObject MappingConfig)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    # Check mapping config.
    if ( !IsHashRefWithData( $Param{MappingConfig} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no MappingConfig as hash ref with content!',
        );
    }

    # Check config - if we have a map config, it has to be a non-empty hash ref.
    if (
        defined $Param{MappingConfig}->{Config}
        && !IsHashRefWithData( $Param{MappingConfig}->{Config} )
        )
    {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got MappingConfig with Data, but Data is no hash ref with content!',
        );
    }

    return $Self;
}

=head2 Map()

Provides mapping based on C<XSLT> style sheets.
Additional data is provided by the function results from various stages in requester and provider.
This data can be included in the C<XSLT> mapping as 'DataInclude' structure via configuration.

    my $ReturnData = $MappingObject->Map(
        Data => {
            'original_key' => 'original_value',
            'another_key'  => 'next_value',
        },
        DataInclude => {
            RequesterRequestInput => { ... },
            RequesterRequestPrepareOutput => { ... },
            RequesterRequestMapOutput => { ... },
            RequesterResponseInput => { ... },
            RequesterResponseMapOutput => { ... },
            RequesterErrorHandlingOutput => { ... },
            ProviderRequestInput => { ... },
            ProviderRequestMapOutput => { ... },
            ProviderResponseInput => { ... },
            ProviderResponseMapOutput => { ... },
            ProviderErrorHandlingOutput => { ... },
        },
    }
    );

    my $ReturnData = {
        'changed_key'          => 'changed_value',
        'original_key'         => 'another_changed_value',
        'another_original_key' => 'default_value',
        'default_key'          => 'changed_value',
    };

=cut

sub Map {
    my ( $Self, %Param ) = @_;

    # Check data - only accept undef or hash ref or array ref.
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' && ref $Param{Data} ne 'ARRAY' ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash or array ref in Mapping XSLT backend!'
        );
    }

    # Check included data - only accept undef or hash ref.
    if ( defined $Param{DataInclude} && !IsHashRefWithData( $Param{DataInclude} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got DataInclude but it is not a hash ref in Mapping XSLT backend!'
        );
    }

    # Return if data is empty.
    if ( !defined $Param{Data} || !%{ $Param{Data} } ) {
        return {
            Success => 1,
            Data    => {},
        };
    }

    # Prepare short config variable.
    my $Config = $Self->{MappingConfig}->{Config};

    # No config means we just return input data.
    if ( !$Config || !$Config->{Template} ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # Load required libraries (XML::LibXML and XML::LibXSLT).
    LIBREQUIRED:
    for my $LibRequired (qw(XML::LibXML XML::LibXSLT)) {
        my $LibFound = $Kernel::OM->Get('Kernel::System::Main')->Require($LibRequired);

        next LIBREQUIRED if $LibFound;

        return $Self->{DebuggerObject}->Error(
            Summary => "Could not find required library $LibRequired",
        );
    }

    # Prepare style sheet.
    my $LibXSLT = XML::LibXSLT->new();

    # Remove template line breaks and white spaces to plain text lines on the fly, see bug# 14106.
    my $Template =
        $Config->{Template}
        =~ s{ > [ \t\n]+ (?= [^< \t\n] ) }{>}xmsgr
        =~ s{ (?<! [> \t\n] ) [ \t\n]+ < }{<}xmsgr;

    my ( $StyleDoc, $StyleSheet );
    eval {
        $StyleDoc = XML::LibXML->load_xml(
            string   => $Template,
            no_cdata => 1,
        );
    };
    if ( !$StyleDoc ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not load configured XSLT template',
            Data    => $Template,
        );
    }
    eval {
        $StyleSheet = $LibXSLT->parse_stylesheet($StyleDoc);
    };
    if ( !$StyleSheet ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not parse configured XSLT template',
            Data    => $@,
        );
    }

    # Append the configured include data to the normal data structure.
    if (
        IsHashRefWithData( $Param{DataInclude} )
        && IsArrayRefWithData( $Config->{DataInclude} )
        )
    {
        my $MergedData = dclone( $Param{Data} );
        DATAINCLUDEMODULE:
        for my $DataIncludeModule ( @{ $Config->{DataInclude} } ) {
            next DATAINCLUDEMODULE if !$Param{DataInclude}->{$DataIncludeModule};

            # Clone the data include hash to prevent circular data structure references
            $MergedData->{DataInclude}->{$DataIncludeModule} = dclone( $Param{DataInclude}->{$DataIncludeModule} );
        }

        $Self->{DebuggerObject}->Debug(
            Summary => 'Data merged with DataInclude before mapping',
            Data    => $MergedData,
        );

        $Param{Data} = $MergedData;
    }

    # XSTL regex recursion.
    if ( IsArrayRefWithData( $Config->{PreRegExFilter} ) ) {
        $Self->_RegExRecursion(
            Data   => $Param{Data},
            Config => $Config->{PreRegExFilter},
        );
        $Self->{DebuggerObject}->Debug(
            Summary => 'Data before mapping after Pre RegExFilter',
            Data    => $Param{Data},
        );
    }

    # Convert data to XML string.
    #
    # Note: XML::Simple was chosen over alternatives like XML::LibXML and XML::Dumper
    #   due to its simplicity and because we just require a straightforward conversion.
    #   Internally XML::LibXML::SAX is used for parsing XML, there is no dependency
    #   on XML::Parser and expat.
    #   Other modules provide more possibilities but don't allow directly exporting a complete
    #   and clean structure.
    # Reference:
    #   http://www.perlmonks.org/?node_id=490846
    #   http://stackoverflow.com/questions/12182129/convert-string-to-hash-using-libxml-in-perl
    $Kernel::OM->Get('Kernel::System::Main')->Require('XML::Simple');

    # Set the preferred parser for XML::Simple.
    #   Override the default XML::Sax::Expat which is based on XML::Parser, which is based on expat.
    #   Override potential settings in $ENV{XML_SIMPLE_PREFERRED_PARSER}.
    local $XML::Simple::PREFERRED_PARSER = 'XML::LibXML::SAX::Parser';

    my $XMLSimple = XML::Simple->new;
    my $XMLPre    = eval {
        $XMLSimple->XMLout(
            $Param{Data},
            AttrIndent    => 1,
            ContentKey    => '-content',
            NoAttr        => 1,
            KeyAttr       => [],
            RootName      => 'RootElement',
            SuppressEmpty => '',
        );
    };
    if ( !$XMLPre ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not convert data from Perl to XML before mapping',
            Data    => $@,
        );
    }

    # Transform xml data.
    my $XMLSource = eval {
        XML::LibXML->load_xml(
            string   => $XMLPre,
            no_cdata => 1,
        );
    };
    if ( !$XMLSource ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not load data after conversion from Perl to XML',
            Data    => $XMLPre,
        );
    }
    my $Result = eval {
        $StyleSheet->transform($XMLSource);
    };
    if ( !$Result ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not map data',
            Data    => $@,
        );
    }
    my $XMLPost = $StyleSheet->output_as_bytes($Result);
    if ( !$XMLPost ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not write mapped data",
        );
    }

    # Convert data back to Perl structure.
    my $ReturnData = eval {
        $XMLSimple->XMLin(
            $XMLPost,
            ForceArray    => 0,
            ContentKey    => '-content',
            NoAttr        => 1,
            KeyAttr       => [],
            SuppressEmpty => '',
        );
    };
    if ( !$ReturnData ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not convert data from XML to Perl after mapping',
            Data    => {
                Message => $@,
                XMLIn   => $XMLPost,
            },
        );
    }

    # XST regex recursion.
    if ( IsArrayRefWithData( $Config->{PostRegExFilter} ) ) {
        $Self->{DebuggerObject}->Debug(
            Summary => 'Data after mapping before Post RegExFilter',
            Data    => $ReturnData,
        );
        $Self->_RegExRecursion(
            Data   => $ReturnData,
            Config => $Config->{PostRegExFilter},
        );
    }

    return {
        Success => 1,
        Data    => $ReturnData,
    };
}

sub _RegExRecursion {
    my ( $Self, %Param ) = @_;

    # Data must be hash ref.
    return 1 if !IsHashRefWithData( $Param{Data} );

    KEY:
    for my $Key ( sort keys %{ $Param{Data} } ) {

        # Recurse for array data in value.
        if ( IsArrayRefWithData( $Param{Data}->{$Key} ) ) {

            ARRAYENTRY:
            for my $ArrayEntry ( @{ $Param{Data}->{$Key} } ) {
                $Self->_RegExRecursion(
                    Data   => $ArrayEntry,
                    Config => $Param{Config},
                );
            }
        }

        # Recurse directly otherwise (assume hash reference).
        else {
            $Self->_RegExRecursion(
                Data   => $Param{Data}->{$Key},
                Config => $Param{Config},
            );
        }

        # Apply configured RegEx to key.
        REGEX:
        for my $RegEx ( @{ $Param{Config} } ) {
            next REGEX if $Key !~ m{$RegEx->{Search}};

            # Double-eval the replacement string to allow embedded capturing group replacements,
            #   e.g. Search = '(foo|bar)bar', Replace = '$1foo'
            #   turns 'foobar' into 'foofoo' and 'barbar' into 'barfoo'.
            my $NewKey = $Key =~ s{$RegEx->{Search}}{ '"' . $RegEx->{Replace} . '"' }eer;

            # Skip if new key is equivalent to old key.
            next KEY if $NewKey eq $Key;

            # Replace matched key with new one.
            $Param{Data}->{$NewKey} = delete $Param{Data}->{$Key};
        }

    }

    return 1;
}

1;
