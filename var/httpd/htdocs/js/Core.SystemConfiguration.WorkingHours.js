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
Core.SystemConfiguration = Core.SystemConfiguration || {};

/**
 * @namespace Core.SystemConfiguration
 * @memberof Core
 * @author
 * @description
 *      This namespace contains the special functions for SystemConfiguration.WorkingHours module.
 */
Core.SystemConfiguration.WorkingHours = (function (TargetNS) {

    /**
     * @public
     * @name ValueGet
     * @memberof Core.SystemConfiguration.WorkingHours
     * @function
     * @param {jQueryObject} $Object - jquery object that holds WorkingHours value.
     * @description
     *      This function return selected WorkingHours value.
     * @returns {String} WorkingHours
     */
    TargetNS.ValueGet = function ($Object) {
        var Value,
            Day;

        Day = $Object.attr("data-day");
        Value = {};
        if ($Object.is(":checked")) {
            Value[Day] = [$Object.val()];
        }

        return Value;
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.SystemConfiguration.WorkingHours || {}));
