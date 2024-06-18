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
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.CustomerUser
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module function for the CustomerUser module.
 */
 Core.Agent.Admin.CustomerUser = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.CustomerUser
     * @function
     * @description
     *      This function initializes actions for customer update.
     */
    TargetNS.Init = function() {

        var Customer = Core.Config.Get('Customer');
        var Nav      = Core.Config.Get('Nav');

        // init checkbox to include invalid elements
        $('input#IncludeInvalid').off('change').on('change', function () {
            var URL = Core.Config.Get("Baselink") + 'Action=' + Core.Config.Get("Action");

            // preserve necessary url params
            var Search = $('#Search').val();
            if (Search) {
                URL += ';Subaction=Search;Search=' + Search;
            }
            if ( Nav ) {
                URL += ';Nav=' + Nav;
            }
            URL += ';IncludeInvalid=' + ( $(this).is(':checked') ? 1 : 0 );

            window.location.href = URL;
        });

        $('.CustomerAutoCompleteSimple').each(function() {
            Core.Agent.CustomerSearch.InitSimple($(this));
        });

        // update customer only when parameter Nav is 'None'
        // which only happens when the AdminCustomerUser is called
        // from within the customer search iframe in AgentTicketPhone/Email etc.
        if (!Nav || Nav != 'None') {
            return;
        }

        // call UpdateCustomer function with customer from config if exists
        if (Customer) {
            Core.Agent.TicketAction.UpdateCustomer(Core.Language.Translate(Customer));
        }

        // call UpdateCustomer function with field text parameter
        $('#CustomerTable a').click(function () {
            Core.Agent.TicketAction.UpdateCustomer($(this).text());
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.CustomerUser || {}));
