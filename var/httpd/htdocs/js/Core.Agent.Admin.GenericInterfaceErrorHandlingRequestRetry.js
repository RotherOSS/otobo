// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
 * @namespace Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special functions for the GenericInterface request retry module.
 */
Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry
     * @function
     * @description
     *      Initializes the module functions.
     */
    TargetNS.Init = function () {

        // hide and show the related retry fields
        $('#ScheduleRetry').off('change.ScheduleRetry').on('change.ScheduleRetry', function(){

            if ($('#ScheduleRetry').val() === '1') {

                $('#ScheduleRetryFields').fadeIn();
                Core.UI.InputFields.Activate($('#ScheduleRetryFields'));
            }
            else {
                $('#ScheduleRetryFields').fadeOut();
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceErrorHandlingRequestRetry || {}));
