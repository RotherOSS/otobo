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
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.oooWidget
 * @memberof Core.UI
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains all functions for oooWidget.
 */
Core.UI.oooWidget = (function (TargetNS) {
    /**
     * @private
     * @name CalculateHeight
     * @memberof Core.Customer.TicketZoom
     * @function
     * @param {DOMObject} Iframe - DOM representation of an iframe
     * @description
     *      Sets the size of the iframe to the size of its inner html.
     */

    /**
     * @name Init
     * @memberof Core.UI.oooWidget.Init
     * @function
     * @description
     *      Initializes otobo widgets.
     */
    TargetNS.Init = function(){
        // close on click
        $(".oooClose").on('click', function() {
            $(this).parent().parent('.oooWidget').hide();
        });

        // close on escape
        $(document).keyup(function(e) {
            if (e.key === "Escape" || e.key === "Esc") {
                $('.oooWidget').hide();
            }
        });

        /*
        // close on "blur"
        $(document).on('click', function() {
            $('.oooWidget:visible').hide();
        });
        $('.oooWidget').on('click', function(e) {
            e.stopPropagation();
            return false;
        });
        */
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.UI.oooWidget || {}));
