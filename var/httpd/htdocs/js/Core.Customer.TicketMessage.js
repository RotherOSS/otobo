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
 * @namespace Core.Customer.TicketMessage
 * @memberof Core.Customer
 * @author
 * @description
 *      This namespace contains module functions for CustomerTicketMessage.
 */
Core.Customer.TicketMessage = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Customer.TicketMessage
     * @function
     * @description
     *      This function initializes module functionality.
     */
    TargetNS.Init = function(){

        var $Form,
            FieldID,
            DynamicFieldNames = Core.Config.Get('DynamicFieldNames'),
            Fields = ['TypeID', 'Dest', 'PriorityID', 'ServiceID', 'SLAID'],
            ModifiedFields;

        // Bind events to specific fields
        $.each(Fields, function(Index, Value) {
            ModifiedFields = Core.Data.CopyObject(Fields).concat(DynamicFieldNames);
            ModifiedFields.splice(Index, 1);

            FieldUpdate(Value, ModifiedFields);
        });

        // delete attachment
        $('button[id*=AttachmentDeleteButton]').on('click', function() {
            $Form = $(this).closest('form');
            FieldID = $(this).attr('id').split('AttachmentDeleteButton')[1];
            $('#AttachmentDelete' + FieldID).val(1);
            Core.Form.Validate.DisableValidation($Form);
            $Form.trigger('submit');
        });

    };

   /**
     * @private
     * @name FieldUpdate
     * @memberof Core.Customer.TicketMessage.Init
     * @function
     * @param {String} Value - FieldID
     * @param {Array} ModifiedFields - Fields
     * @description
     *      Create on change event handler
     */
    function FieldUpdate (Value, ModifiedFields) {
        $('#' + Value).on('change', function () {
            Core.AJAX.FormUpdate($('#NewCustomerTicket'), 'AJAXUpdate', Value, ModifiedFields);
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Customer.TicketMessage || {}));
