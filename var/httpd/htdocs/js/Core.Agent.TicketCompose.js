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

/**
 * @namespace Core.Agent.TicketCompose
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for TicketCompose.
 */
Core.Agent.TicketCompose = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketCompose
     * @function
     * @description
     *      This function initializes .
     */
    TargetNS.Init = function () {

        var ArticleComposeOptions = Core.Config.Get('ArticleComposeOptions'),
            EmailAddressesTo = Core.Config.Get('EmailAddressesTo'),
            EmailAddressesCc = Core.Config.Get('EmailAddressesCc');

        // remove customer user
        $('.CustomerTicketRemove').on('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });

        // change next ticket state
        $('#StateID').on('change', function () {
            Core.AJAX.FormUpdate($('#ComposeTicket'), 'AJAXUpdate', 'StateID', Core.Config.Get('DynamicFieldNames'));
        });

        // add 'To' customer users
        if (typeof EmailAddressesTo !== 'undefined') {
            EmailAddressesTo.forEach(function(ToCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('ToCustomer', ToCustomer.CustomerTicketText, ToCustomer.CustomerKey);
            });
        }

        // add 'Cc' customer users
        if (typeof EmailAddressesCc !== 'undefined') {
            EmailAddressesCc.forEach(function(CcCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('CcCustomer', CcCustomer.CustomerTicketText, CcCustomer.CustomerKey);
            });
        }

        // change article compose options
        if (typeof ArticleComposeOptions !== 'undefined') {
            $.each(ArticleComposeOptions, function (Key, Value) {
                $('#'+Value.Name).on('change', function () {
                    Core.AJAX.FormUpdate($('#ComposeTicket'), 'AJAXUpdate', Value.Name, Value.Fields);
                });
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketCompose || {}));
