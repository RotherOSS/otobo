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
 * @namespace Core.Agent.TicketEmailResend
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for TicketEmailResend.
 */
Core.Agent.TicketEmailResend = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketEmailResend
     * @function
     * @description
     *      This function initializes .
     */
    TargetNS.Init = function () {
        var ArticleComposeOptions = Core.Config.Get('ArticleComposeOptions'),
            EmailAddressesTo = Core.Config.Get('EmailAddressesTo'),
            EmailAddressesCc = Core.Config.Get('EmailAddressesCc'),
            EmailAddressesBcc = Core.Config.Get('EmailAddressesBcc');

        // add event listeners to remove or move customers
        $('.CustomerTicketRemove').on('click', function () {
            Core.Agent.CustomerSearch.RemoveCustomerTicket($(this));
            return false;
        });
        $('.MoveCustomerButton').on('click', function () {
            var MoveCustomerKey = $('.CustomerKey', $(this).parent()).val(),
                MoveCustomerVal = $('.CustomerTicketText', $(this).parent()).val(),
                TargetField     =
                    $(this).hasClass('ToMove')  ? 'ToCustomer'  :
                    $(this).hasClass('CcMove')  ? 'CcCustomer'  :
                    $(this).hasClass('BccMove') ? 'BccCustomer' : '';

            // remove the current entry
            $('.RemoveButton', $(this).parent()).click();

            // add the customer to the target field
            Core.Agent.CustomerSearch.AddTicketCustomer(TargetField, MoveCustomerVal, MoveCustomerKey);
        });

        // Add 'To' customer users.
        if (typeof EmailAddressesTo !== 'undefined') {
            EmailAddressesTo.forEach(function(ToCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('ToCustomer', ToCustomer.CustomerTicketText, ToCustomer.CustomerKey);
            });
        }

        // Add 'Cc' customer users.
        if (typeof EmailAddressesCc !== 'undefined') {
            EmailAddressesCc.forEach(function(CcCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('CcCustomer', CcCustomer.CustomerTicketText, CcCustomer.CustomerKey);
            });
        }

        // Add 'BCc' customer users.
        if (typeof EmailAddressesBcc !== 'undefined') {
            EmailAddressesBcc.forEach(function(BccCustomer) {
                Core.Agent.CustomerSearch.AddTicketCustomer('BccCustomer', BccCustomer.CustomerTicketText, BccCustomer.CustomerKey);
            });
        }

        // Change article compose options.
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
}(Core.Agent.TicketEmailResend || {}));
