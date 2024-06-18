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
 * @namespace Core.Customer.TicketProcess
 * @memberof Core.Customer
 * @author
 * @description
 *      This namespace contains the special module functions for TicketProcess.
 */
Core.Customer.TicketProcess = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Customer.TicketProcess
     * @function
     * @description
     *      This function initializes the special module functions.
     */
    TargetNS.Init = function () {

        var ProcessAJAXFieldList = Core.Config.Get('ProcessAJAXFieldList');
        var DynamicFieldRegEx    = /^DynamicField_/;

        if (typeof ProcessAJAXFieldList !== 'undefined') {
            for (let n = 0; n < ProcessAJAXFieldList.length; n++) {
                let FieldSet = ProcessAJAXFieldList[n];

                for (let i = 0; i < FieldSet.length; i++) {
                    if ( DynamicFieldRegEx.test( FieldSet[i] ) ) { continue }

                    $( '#' + FieldSet[i] ).on('change', function () {
                        Core.AJAX.FormUpdate($(this).parents('form'), 'AJAXUpdate', $(this).attr('name'), FieldSet);
                    });
                }
            }
        }

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Customer.TicketProcess || {}));
