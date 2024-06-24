// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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
 * @namespace Core.Agent.Admin.DynamicFieldWebService
 * @memberof Core.Agent.Admin
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains the special module functions for the DynamicFieldWebService module.
 */
Core.Agent.Admin.DynamicFieldWebService = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.DynamicFieldWebService
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {
        $('.ShowWarning').on('change keyup', function () {
            $('p.Warning').removeClass('Hidden');
        });

        $('#WebserviceID').on('change', function () {
            Core.AJAX.FormUpdate($('#EntityUpdate'), 'AJAXUpdate', 'WebserviceID');
        });

        // Appropriately hide or show Link and Link Preview fields based on Multiselect value.
        if ($('#Multiselect').val() === '1') {
            $('.DFWebServiceLink').fadeOut("fast");
        }
        else {
            $('.DFWebServiceLink').fadeIn("fast");
        }

        $('#Multiselect').on('change', function () {
            if ($(this).val() === '1') {
                $('.DFWebServiceLink').fadeOut();
            }
            else {
                $('.DFWebServiceLink').fadeIn();
            }
        });

        Core.Agent.Admin.DynamicField.ValidationInit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldWebService || {}));
