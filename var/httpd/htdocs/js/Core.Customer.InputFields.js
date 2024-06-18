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
 * @namespace Core.Customer.InputFields
 * @memberof Core.Customer
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains all functions for the Customer login.
 */
Core.Customer.InputFields = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Customer.InputFields
     * @function
     * @description
     *      enables input css
     */
    TargetNS.Init = function () {

        // enable input css
        $('.Row').each( function() {
            var TextInput = $(this).find('input, textarea').first();
            if ( TextInput.lenght === 0 ) {
                return 1;
            }

            // fields already filled
            if ( $.trim(TextInput.value).length ) {
                $(this).addClass('oooFull');
                $(".Field", this).addClass('oooFull');
            }

            TextInput.blur( function() {
                // check whether field is filled
                if ( $.trim(this.value).length ) {
                    $(this).addClass('oooFull');
                    $(this).parent('.Field').addClass('oooFull');
                }
                else {
                    $(this).removeClass('oooFull');
                    $(this).parent('.Field').removeClass('oooFull');
                }
            });
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Customer.InputFields || {}));
