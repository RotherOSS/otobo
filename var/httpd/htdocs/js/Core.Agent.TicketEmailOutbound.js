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
 * @namespace Core.Agent.TicketEmailOutbound
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains special module functions for TicketEmailOutbound.
 */
Core.Agent.TicketEmailOutbound = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketEmailOutbound
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        var ArticleComposeOptions = Core.Config.Get('ArticleComposeOptions'),
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames');

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

        // set a template
        $('#StandardTemplateID').on('change', function () {
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $(this), function () {
                Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdateTemplate', 'StandardTemplateID', ['RichTextField']);
            });
            return false;
        });

        // update dynamic fields in form
        $('#ComposeStateID').on('change', function () {
            Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', 'ComposeStateID', DynamicFieldNames);
        });

        // change article compose options
        if (typeof ArticleComposeOptions !== 'undefined') {
            $.each(ArticleComposeOptions, function (Key, Value) {
                $('#'+Value.Name).on('change', function () {
                    Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', Value.Name, Value.Fields);
                });
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketEmailOutbound || {}));
