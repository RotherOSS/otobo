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
 * @namespace Core.Agent.TicketEmail
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains special module functions for TicketEmail.
 */
Core.Agent.TicketEmail = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketEmail
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {
        var CustomerKey,
            ArticleComposeOptions = Core.Config.Get('ArticleComposeOptions'),
            DataEmail = Core.Config.Get('DataEmail'),
            DataCustomer = Core.Config.Get('DataCustomer'),
            Fields = ['TypeID', 'Dest', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID'];

        // Bind events to specific fields
        $.each(Fields, function(Index, Value) {
            FieldUpdate(Value);
        });

        // get all owners
        $('#OwnerSelectionGetAll').on('click', function () {
            $('#OwnerAll').val('1');
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'OwnerAll', function() {
                $('#NewUserID').focus();
            });
            return false;
        });

        // get all responsibles
        $('#ResponsibleSelectionGetAll').on('click', function () {
            $('#ResponsibleAll').val('1');
            Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'ResponsibleAll', function() {
                $('#NewResponsibleID').focus();
            });
            return false;
        });

        // change standard template
        $('#StandardTemplateID').on('change', function () {
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $(this), function () {
                Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', 'StandardTemplateID');
            });
            return false;
        });

        // change customer user radio button
        $('.CustomerTicketRadio').on('change', function () {
            if ($(this).prop('checked')){
                CustomerKey = $('#CustomerKey_' + $(this).val()).val();
                // get customer tickets
                Core.Agent.CustomerSearch.ReloadCustomerInfo(CustomerKey);
            }
            return false;
        });

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

        // add a new ticket customer user
        if (typeof DataEmail !== 'undefined' && typeof DataCustomer !== 'undefined') {
            Core.Agent.CustomerSearch.AddTicketCustomer('ToCustomer', DataEmail, DataCustomer, true);
        }

        // change article compose options
        if (typeof ArticleComposeOptions !== 'undefined') {
            $.each(ArticleComposeOptions, function (Key, Value) {
                $('#'+Value.Name).on('change', function () {
                    Core.AJAX.FormUpdate($('#NewEmailTicket'), 'AJAXUpdate', Value.Name);
                });
            });
        }
    };

    /**
     * @private
     * @name FieldUpdate
     * @memberof Core.Agent.TicketEmail
     * @function
     * @param {String} Value - FieldID
     * @description
     *      Create on change event handler
     */
    function FieldUpdate (Value) {
        var SignatureURL, FieldValue, CustomerUser;
        $('#' + Value).on('change', function () {

            if (Value === 'Dest') {
                FieldValue = $(this).val() || '';
                CustomerUser = $('#SelectedCustomerUser').val() || '';
                SignatureURL = Core.Config.Get('Baselink') + 'Action=' + Core.Config.Get('Action') + ';Subaction=Signature;Dest=' + FieldValue + ';SelectedCustomerUser=' + CustomerUser;
                if (!Core.Config.Get('SessionIDCookie')) {
                    SignatureURL += ';' + Core.Config.Get('SessionName') + '=' + Core.Config.Get('SessionID');
                }
                $('#Signature').attr('src', SignatureURL);
            }
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketEmail || {}));
