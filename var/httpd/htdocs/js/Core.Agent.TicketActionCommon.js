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
 * @namespace Core.Agent.TicketActionCommon
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains special module functions for AgentTicketActionCommon.
 */
Core.Agent.TicketActionCommon = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketActionCommon
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        var DynamicFieldNames = Core.Config.Get('DynamicFieldNames'),
            Fields = ['TypeID', 'ServiceID', 'SLAID', 'NewOwnerID', 'NewResponsibleID', 'NewStateID', 'NewPriorityID'],
            ModifiedFields;

        // Bind events to specific fields
        $.each(Fields, function(Index, Value) {
            ModifiedFields = Core.Data.CopyObject(Fields).concat(DynamicFieldNames);
            ModifiedFields.splice(Index, 1);

            FieldUpdate(Value, ModifiedFields);
        });

        // Bind event to Queue field.
        $('#NewQueueID').on('change', function () {
            Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', 'NewQueueID', ['TypeID', 'ServiceID', 'NewOwnerID', 'NewResponsibleID', 'NewStateID', 'NewPriorityID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to StandardTemplate field.
        $('#StandardTemplateID').on('change', function () {
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $(this), function () {
                Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', 'StandardTemplateID', ['RichTextField']);
            });
            return false;
        });

        // Bind click event to CreateArticle checkbox and toggle widget.
        $('#CreateArticle, #WidgetArticle .WidgetAction.Toggle').on('click', function () {
            $('#WidgetArticle .Validate_DependingRequiredAND.Validate_Depending_CreateArticle').each(function (Index, Element) {
                var $Element = $(Element);
                var ClosestClass = 'Field';
                if ($Element.attr('id') === 'RichText') {
                    ClosestClass = 'RichTextField';
                }
                if ($('#CreateArticle').prop('checked') && $('#WidgetArticle').hasClass('Expanded')) {
                    $Element.closest('.' + ClosestClass)
                        .prev('label')
                        .addClass('Mandatory')
                        .prepend('<span class="Marker">*</span>');
                }
                else {
                    $Element.closest('.' + ClosestClass)
                        .prev('label')
                        .removeClass('Mandatory')
                        .find('span')
                        .remove();
                    Core.Form.Validate.UnHighlightError(Element);
                }
            });
        });
    };

    /**
     * @private
     * @name FieldUpdate
     * @memberof Core.Agent.TicketActionCommon
     * @function
     * @param {String} Value - FieldID
     * @param {Array} ModifiedFields - Fields
     * @description
     *      Create on change event handler
     */
    function FieldUpdate (Value, ModifiedFields) {
        $('#' + Value).on('change', function () {
            Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', Value, ModifiedFields);
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketActionCommon || {}));
