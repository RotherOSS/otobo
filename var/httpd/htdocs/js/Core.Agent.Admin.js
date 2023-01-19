// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
// --
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the admin overview module.
 */
Core.Agent.Admin = (function (TargetNS) {
    /**
     * @name Init
     * @memberof Core.Agent.Admin
     * @function
     * @description
     *      Initializes Overview screen.
     */
    TargetNS.Init = function () {

        var Favourites = Core.Config.Get('Favourites');

        window.setTimeout(function() {
            $('.SidebarColumn #Filter').focus();
        }, 100);

        $('.AddAsFavourite').off('click.AddAsFavourite').on('click.AddAsFavourite', function(Event) {

            var $TriggerObj = $(this),
                Module = $(this).data('module'),
                ModuleName = $TriggerObj.closest('a').find('span.Title').clone().children().remove().end().text();

            // Remove white space at start and at the end of string.
            ModuleName = ModuleName.replace(/^\s*(.*?)\s*$/, "$1");

            if ($TriggerObj.hasClass('Clicked')) {
                return false;
            }

            Event.stopPropagation();
            $(this).addClass('Clicked');
            Favourites.push(Module);

            Core.Agent.PreferencesUpdate('AdminNavigationBarFavourites', JSON.stringify(Favourites), function() {

                var FavouriteHTML = '',
                    RowIndex,
                    FavouriteRows = [ModuleName];

                $TriggerObj.addClass('Clicked');

                // also add the entry to the sidebar favourites list dynamically
                FavouriteHTML = Core.Template.Render('Agent/Admin/Favourite', {
                    'Link'  : $TriggerObj.closest('a').attr('href'),
                    'Name'  : ModuleName,
                    'Module': Module
                });

                // Fade the original icon out and display a success icon
                $TriggerObj.find('i').fadeOut(function() {
                    $(this).closest('li').find('.AddAsFavourite').append('<i class="fa fa-check" style="display: none;"></i>').find('i.fa-check').fadeIn().delay(1000).fadeOut(function() {
                        $(this)
                            .closest('.AddAsFavourite')
                            .hide()
                            .find('i.fa-check')
                            .remove();
                        $('.ItemListGrid').find('[data-module="' + Module + '"]').addClass('IsFavourite');
                    });
                    $(this).hide();
                });

                $('.DataTable.Favourites tbody tr').each(function() {
                    FavouriteRows.push($(this).find('td:first a').html());
                });

                FavouriteRows.sort(function (a, b) {
                  return a.localeCompare(b);
                });

                RowIndex = FavouriteRows.indexOf(ModuleName);
                if (RowIndex < 0) {
                    $('.DataTable.Favourites').append($(FavouriteHTML));
                }
                else if (RowIndex == 0) {
                    $('.DataTable.Favourites').prepend($(FavouriteHTML));
                }
                else {
                    $(FavouriteHTML).insertAfter($(".DataTable.Favourites tbody tr")[RowIndex - 1]);
                }

                $('.DataTable.Favourites').show();

            });
            return false;
        });

        $('.DataTable.Favourites').on('click', '.RemoveFromFavourites', function() {

            var Module = $(this).data('module'),
                Index = Favourites.indexOf(Module),
                $TriggerObj = $(this),
                $ListItemObj = $('.ItemListGrid').find('[data-module="' + Module + '"]');

            if ($ListItemObj.hasClass('IsFavourite') && Index > -1) {
                Favourites.splice(Index, 1);
                Core.Agent.PreferencesUpdate('AdminNavigationBarFavourites', JSON.stringify(Favourites), function() {
                    $TriggerObj.closest('tr').fadeOut(function() {
                        var $TableObj = $(this).closest('table');
                        $(this).remove();
                        if (!$TableObj.find('tr').length) {
                            $TableObj.hide();
                        }

                        // also remove the corresponding class from the entry in the grid view and list view
                        $ListItemObj.removeClass('IsFavourite').removeClass('Clicked').show().find('i.fa-star-o').show();
                    });
                });
            }

            return false;
        });

        Core.UI.Table.InitTableFilter($('#Filter'), $('.Filterable'), undefined, true);
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin || {}));
