// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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
Core.Customer = Core.Customer || {};

/**
 * @namespace Core.Customer.TicketList
 * @memberof Core.Customer
 * @author Rother OSS GmbH
 * @description
 *      Navigation Bar
 */
Core.Customer.TicketList = (function (TargetNS) {

    /**
     * @private
     * @name NavBarShrink
     * @memberof Core.Customer.TicketList
     * @function
     * @description
     *      This function returns the NavBar to its default.
     */
    /*function NavBarShrink() {
        $('#Navigation').off('mouseleave', NavBarShrink);
        $('#Navigation').removeClass("oooExpanded");
        $('#NavBarModuleIcons > a > .NavBarDescription > p').each(function() {
            $(this).hide();
        });

        // wait, till the NavBar is small
        setTimeout( function() {
            $('#NavBarExpand').show();
        }, 250);
    };*/

    /**
     * @name Init
     * @memberof Core.Customer.TicketList
     * @function
     * @description
     *      This function initializes TicketList javascript functions.
     */
    TargetNS.Init = function() {
        // move all elements to the rows
        $('.oooTicketItemCat').each(function() {
            var Row1       = $(this).children(".oooRow1").first();
            var Row2       = $(this).children(".oooRow2").first();
            var Width1     = 0;
            var Width2     = 0;
            var MaxWidth   = $(this).width();
            var Categories = $(this).children("p");

//            for (var Cat of Categories) {
            for (var i = 0; i < Categories.length; i++ ) {
                var Category = $( Categories[i] );
                var Outer    = Category.outerWidth(true);
                if ( Width1 <= Width2 ) {
                    if ( Width1 + Outer < MaxWidth ) {
                        Category.appendTo(Row1);
                        Width1 += Outer;
                    }
                    else {
                        Category.hide();
                    }
                }
                else {
                    if ( Width2 + Outer < MaxWidth ) {
                        Category.appendTo(Row2);
                        Width2 += Outer;
                    }
                    else {
                        Category.hide();
                    }
                }
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Customer.TicketList || {}));
