// --
// OTOBO is a web-based ticketing system for service organisations.
// --
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

var QuickDateButtons = QuickDateButtons || {};

/**
 * @namespace QuickDateButtons
 * @author Rother OSS
 * @description
 *      This namespace contains the special module functions for the package QuickDateButtons.
 */
QuickDateButtons = (function (TargetNS) {

    /**
     * @name Init
     * @memberof QuickDateButtons
     * @function
     * @description
     *      Initializes the module.
     */
    TargetNS.Init = function ($Element) {
        $('.oooQuickDate.SetDate').on('click', function () {
            var Days     = parseInt($(this).attr('data-days'));
            var CurrDate = new Date();

            CurrDate.setDate( CurrDate.getDate() + Days );

            $( 'select[name$="Year"]',  $(this).parent() ).first().val( CurrDate.getFullYear() );
            $( 'select[name$="Month"]', $(this).parent() ).first().val( CurrDate.getMonth() + 1);
            $( 'select[name$="Day"]',   $(this).parent() ).first().val( CurrDate.getDate() );
        });

        $('.oooQuickDate.AddDays').on('click', function () {
            var Days     = parseInt($(this).attr('data-days'));
            var CurrDate = new Date(
                $( 'select[name$="Year"]',  $(this).parent() ).first().val(),
                $( 'select[name$="Month"]', $(this).parent() ).first().val() - 1,
                $( 'select[name$="Day"]',   $(this).parent() ).first().val(),
            );

            CurrDate.setDate( CurrDate.getDate() + Days );

            $( 'select[name$="Year"]',  $(this).parent() ).first().val( CurrDate.getFullYear() );
            $( 'select[name$="Month"]', $(this).parent() ).first().val( CurrDate.getMonth() + 1);
            $( 'select[name$="Day"]',   $(this).parent() ).first().val( CurrDate.getDate() );
        });

        $('.oooQuickDate.SubtractDays').on('click', function () {
            var Days     = parseInt($(this).attr('data-days'));
            var CurrDate = new Date(
                $( 'select[name$="Year"]',  $(this).parent() ).first().val(),
                $( 'select[name$="Month"]', $(this).parent() ).first().val() - 1,
                $( 'select[name$="Day"]',   $(this).parent() ).first().val(),
            );

            CurrDate.setDate( CurrDate.getDate() - Days );

            $( 'select[name$="Year"]',  $(this).parent() ).first().val( CurrDate.getFullYear() );
            $( 'select[name$="Month"]', $(this).parent() ).first().val( CurrDate.getMonth() + 1);
            $( 'select[name$="Day"]',   $(this).parent() ).first().val( CurrDate.getDate() );
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');

    return TargetNS;
}(QuickDateButtons || {}));
