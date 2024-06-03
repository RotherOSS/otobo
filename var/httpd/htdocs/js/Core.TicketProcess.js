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

/**
 * @namespace Core.TicketProcess
 * @memberof Core
 * @author
 * @description
 *      This namespace contains the special module functions for TicketProcesses in Agent and Customer interface.
 */
Core.TicketProcess = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.TicketProcess
     * @function
     * @description
     *      This function binds event on different fields to trigger AJAX form update on the other fields.
     */
    TargetNS.Init = function () {

        // Bind event on Type field
        if (typeof Core.Config.Get('TypeFieldsToUpdate') !== 'undefined') {
            $('#TypeID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'TypeID' , Core.Config.Get('TypeFieldsToUpdate'));
            });
        }

        // Bind event on State field
        if (typeof Core.Config.Get('StateFieldsToUpdate') !== 'undefined') {
            $('#StateID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'StateID' , Core.Config.Get('StateFieldsToUpdate'));
            });
        }

        // Bind event on SLA field
        if (typeof Core.Config.Get('SLAFieldsToUpdate') !== 'undefined') {
            $('#SLAID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'SLAID' , Core.Config.Get('SLAFieldsToUpdate'));
            });
        }

        // Bind event on Service field
        if (typeof Core.Config.Get('ServiceFieldsToUpdate') !== 'undefined') {
            $('#ServiceID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'ServiceID' , Core.Config.Get('ServiceFieldsToUpdate'));
            });
        }

        // Bind event on Lock field
        if (typeof Core.Config.Get('LockFieldsToUpdate') !== 'undefined') {
            $('#LockID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'LockID', Core.Config.Get('LockFieldsToUpdate'));
            });
        }

        if (typeof Core.Config.Get('OwnerFieldsToUpdate') !== 'undefined') {

            // Bind event on Owner field
            $('#OwnerID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'OwnerID', Core.Config.Get('OwnerFieldsToUpdate'));
            });

            // Bind event on Owner get all button
            $('#OwnerSelectionGetAll').on('click', function () {
                $('#OwnerAll').val('1');
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'OwnerID', ['OwnerID']);
                return false;
            });
        }

        // Bind event on Responsible field
        if (typeof Core.Config.Get('ResponsibleFieldsToUpdate') !== 'undefined') {
            $('#ResponsibleID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'ResponsibleID' , Core.Config.Get('ResponsibleFieldsToUpdate'));
            });

            // Bind event on Responsible Get all button
            $('#ResponsibleSelectionGetAll').on('click', function () {
                $('#ResponsibleAll').val('1');
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'ResponsibleID' , ['ResponsibleID']);
                return false;
            });
        }

        // Bind event on Priority field
        if (typeof Core.Config.Get('PriorityFieldsToUpdate') !== 'undefined') {
            $('#PriorityID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'PriorityID' , Core.Config.Get('PriorityFieldsToUpdate'));
            });
        }

        // Bind event to AttachmentDelete button
        $('button[id*=AttachmentDelete]').on('click', function () {
            var $Form;

            $Form = $(this).closest('form');
            Core.Form.Validate.DisableValidation($Form);
        });

        // Bind event on Queue field
        if (typeof Core.Config.Get('QueueFieldsToUpdate') !== 'undefined') {
            $('#QueueID').on('change', function () {
                Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', 'QueueID' , Core.Config.Get('QueueFieldsToUpdate'));
            });
        }

        if (typeof Core.Config.Get('CustomerSearch') !== 'undefined') {
            Core.Agent.CustomerSearch.Init($("#CustomerAutoComplete, .CustomerAutoComplete"));
        }

        // initialize rich text editor
        Core.UI.RichTextEditor.Init();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.TicketProcess || {}));
