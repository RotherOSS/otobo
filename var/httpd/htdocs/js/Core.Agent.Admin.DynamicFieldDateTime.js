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
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.DynamicFieldDateTime
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the DynamicFieldDateTime module.
 */
Core.Agent.Admin.DynamicFieldDateTime = (function (TargetNS) {

    /**
     * @name ToggleYearsPeriod
     * @memberof Core.Agent.Admin.DynamicFieldDateTime
     * @function
     * @returns {Boolean} false
     * @param {Number} YearsPeriod - 0 or 1 to show or hide the Years in Future and in Past fields.
     * @description
     *      This function shows or hide two fields (Years In future and Years in Past) depending
     *      on the YearsPeriod parameter
     */
    TargetNS.ToggleYearsPeriod = function (YearsPeriod) {
        if (YearsPeriod === '1') {
            $('#YearsPeriodOption').removeClass('Hidden');
        }
        else {
            $('#YearsPeriodOption').addClass('Hidden');
        }
        return false;
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.DynamicFieldDateTime
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {
        $('.ShowWarning').on('change keyup', function () {
            $('p.Warning').removeClass('Hidden');
        });

        $('#YearsPeriod').on('change', function () {
            TargetNS.ToggleYearsPeriod($(this).val());
        });

        Core.Agent.Admin.DynamicField.ValidationInit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldDateTime || {}));
