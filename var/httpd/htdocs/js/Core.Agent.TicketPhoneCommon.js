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
 * @namespace Core.Agent.TicketPhoneCommon
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains special module functions for TicketPhoneCommon.
 */
Core.Agent.TicketPhoneCommon = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketPhoneCommon
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        // Bind event to StandardTemplate field.
        $('#StandardTemplateID').on('change', function () {
            var $TemplateSelect = $(this);
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $TemplateSelect, function () {
                Core.AJAX.FormUpdate($TemplateSelect.closest('form'), 'AJAXUpdate', 'StandardTemplateID');
            });
            return false;
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketPhoneCommon || {}));
