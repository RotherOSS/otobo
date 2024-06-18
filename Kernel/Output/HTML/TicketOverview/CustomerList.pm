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

package Kernel::Output::HTML::TicketOverview::CustomerList;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);
use Digest::MD5 qw(md5_hex);

our @ObjectDependencies = (
    'Kernel::System::CommunicationChannel',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::Config',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::User',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Main',
    'Kernel::System::Queue'
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = \%Param;
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{TicketIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketList!',
        );
        return;
    }

    # get needed object
    my $ConfigObject               = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject               = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject               = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject              = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

    # generate empty message
    if ( scalar @{ $Param{TicketIDs} } == 0 ) {

        # customeruser has no tickets at all
        if ( $Param{NoAllTotal} ) {
            if ( $Param{CustomText} ) {
                $LayoutObject->Block(
                    Name => 'EmptyCustom',
                    Data => $Param{CustomText},
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'EmptyDefault',
                );
            }
        }

        # customeruser has no tickets under the current filter
        else {
            $LayoutObject->Block(
                Name => 'EmptyFilter',
            );
        }
    }

    my $TicketStart = $Param{StartHit} ? $Param{StartHit} - 1 : 0;
    my $TicketEnd   = $Param{PageShown}
        ? ( sort { $a <=> $b } ( $Param{PageShown} - 1 + $TicketStart, $#{ $Param{TicketIDs} } ) )[0]
        : $#{ $Param{TicketIDs} };

    # generate ticket list
    for my $TicketID ( @{ $Param{TicketIDs} }[ $TicketStart .. $TicketEnd ] ) {

        # Get last customer article.
        my @ArticleList = $ArticleObject->ArticleList(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            OnlyLast             => 1,
        );

        my %Article;
        if ( $ArticleList[0] && IsHashRefWithData( $ArticleList[0] ) ) {
            my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{ $ArticleList[0] } );
            %Article = $ArticleBackendObject->ArticleGet(
                TicketID  => $TicketID,
                ArticleID => $ArticleList[0]->{ArticleID},
            );
        }

        # get ticket info
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        my $Subject;
        my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
        my $SmallViewColumnHeader = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{ColumnHeader};

        # Check if the last customer subject or ticket title should be shown.
        # If ticket title should be shown, check if there are articles, because ticket title
        # could be related with a subject of an article which does not visible for customer (see bug#13614).
        # If there is no subject, set to 'Untitled'.
        if ( $SmallViewColumnHeader eq 'LastCustomerSubject' ) {
            $Subject = $Article{Subject} || '';
        }
        elsif ( $SmallViewColumnHeader eq 'TicketTitle' && $ArticleList[0] ) {
            $Subject = $Ticket{Title};
        }
        else {
            $Subject = Translatable('Untitled!');
        }

        # Condense down the subject.
        $Subject = $TicketObject->TicketSubjectClean(
            TicketNumber => $Ticket{TicketNumber},
            Subject      => $Subject,
        );

        # Age design.
        $Ticket{CustomerAge} = $LayoutObject->CustomerAge(
            Age   => $Ticket{Age},
            Space => ' '
        ) || 0;

        # return ticket information if there is no article
        if ( !IsHashRefWithData( \%Article ) ) {
            $Article{State}        = $Ticket{State};
            $Article{TicketNumber} = $Ticket{TicketNumber};
            $Article{Body}         = $LayoutObject->{LanguageObject}->Translate('This item has no articles yet.');
        }

        # name and avatar
        my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Article{CustomerUserID} || $Ticket{CustomerUserID},
        );
        my $CustomerName = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
            UserLogin => $Article{CustomerUserID} || $Ticket{CustomerUserID},
        );
        my ( $Avatar, $UserInitials );
        if ( $ConfigObject->Get('Frontend::AvatarEngine') eq 'Gravatar' && $CustomerUser{UserEmail} ) {
            my $DefaultIcon = $ConfigObject->Get('Frontend::Gravatar::DefaultImage') || 'mm';
            $Avatar = '//www.gravatar.com/avatar/' . md5_hex( lc $CustomerUser{UserEmail} ) . '?s=100&d=' . $DefaultIcon;
        }
        else {
            $UserInitials = substr( $CustomerUser{UserFirstname}, 0, 1 ) . substr( $CustomerUser{UserLastname}, 0, 1 );
        }

        # gather categories to be shown
        my %Categories;
        my $CategoryConfig = $ConfigObject->Get("Ticket::Frontend::CustomerTicketCategories");

        # standard ticket categories
        CAT:
        for my $CatName (qw/Type Queue Service State Owner/) {
            next CAT if !$Ticket{$CatName};
            if ( $CategoryConfig->{$CatName} ) {
                my $Conf = $CategoryConfig->{$CatName};
                my $Text = $Conf->{Text} // $Ticket{$CatName};

                $Conf->{ColorSelection} //= {};
                my $Color = $Conf->{ColorSelection}{ $Ticket{$CatName} } // $Conf->{ColorDefault};

                push @{ $Categories{ $Conf->{Order} } }, {
                    Text   => $Text,
                    Color  => $Color,
                    Value  => $Ticket{$CatName},
                    Config => $Conf,
                };
            }
        }

        # get the dynamic fields for this screen
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # get dynamic field config for frontend module
        my $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::CustomerTicketOverview")->{DynamicField};
        my $DynamicField       = $DynamicFieldObject->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Ticket'],
            FieldFilter => $DynamicFieldFilter || {},
        );

        my %DynamicFieldCategories = $CategoryConfig->{DynamicField}
            ?
            map { $CategoryConfig->{DynamicField}{$_}{DynamicField} => $_ } keys %{ $CategoryConfig->{DynamicField} }
            : ();

        # Dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsCustomerInterfaceCapable',
            );
            next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

            # get field value
            my $Value = $BackendObject->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Ticket{TicketID},
            );

            my $ValueStrg = $BackendObject->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                ValueMaxChars      => 20,
                LayoutObject       => $LayoutObject,
            );
            next DYNAMICFIELD if ( !defined $ValueStrg->{Value} || $ValueStrg->{Value} eq '' );

            # build %Categories as $Categories{<Order>} = [ {Text => '', Color => ''}, ... ]
            if ( $DynamicFieldCategories{ $DynamicFieldConfig->{Name} } ) {
                my $Conf = $CategoryConfig->{DynamicField}{ $DynamicFieldCategories{ $DynamicFieldConfig->{Name} } };
                my $Text = $Conf->{Text} // $ValueStrg->{Value};

                $Conf->{ColorSelection} //= {};
                my $Color = $Conf->{ColorSelection}{ $ValueStrg->{Value} } // $Conf->{ColorDefault};

                push @{ $Categories{ $Conf->{Order} } }, {
                    Text   => $Text,
                    Color  => $Color,
                    Value  => $ValueStrg->{Value},
                    Config => $Conf,
                };
            }
        }

        $LayoutObject->Block(
            Name => 'Ticket',
            Data => {
                %Ticket,
                %Article,
                Subject      => $Subject,
                CustomerName => $CustomerName,
                Avatar       => $Avatar,
                UserInitials => $UserInitials,
            },
        );

        for my $Order ( sort { $a <=> $b } keys %Categories ) {
            for my $Category ( @{ $Categories{$Order} } ) {
                $LayoutObject->Block(
                    Name => 'Categories',
                    Data => $Category,
                );
            }
        }
    }

    # create & return output
    return $LayoutObject->Output(
        TemplateFile => 'CustomerTicketList',
    );
}

1;
