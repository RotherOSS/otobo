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
 *      This namespace contains the special functions for SystemConfiguration.VacationDays module.
 */
Core.SystemConfiguration.VacationDays = (function (TargetNS) {

    /**
     * @public
     * @name ValueGet
     * @memberof Core.SystemConfiguration.VacationDays
     * @function
     * @param {jQueryObject} $Object - jquery object that holds VacationDays value.
     * @description
     *      This function return selected VacationDays value.
     * @returns {String} VacationDays.
     */
    TargetNS.ValueGet = function ($Object) {
        var Value;

        // There are many input/select fields, but we should calcutale Date only once.
        if ($Object.attr("id").endsWith("Day")) {
            Value = VacationDaysValueGet($Object);
        }

        return Value;
    };

    /**
     * @private
     * @name VacationDaysValueGet
     * @memberof Core.SystemConfiguration.VacationDays
     * @function
     * @param {jQueryObject} $Object - jquery object.
     * @returns {Object} - Vacation days data.
     * @description
     *      This function calcutates vacation days.
     */
    function VacationDaysValueGet($Object) {
        var Prefix,
            Result,
            Month,
            Day,
            Description;

        Prefix = $Object.attr("id");
        Prefix = Prefix.substr(0, Prefix.length - 3);

        // Escape selector.
        Prefix = Core.App.EscapeSelector(Prefix);

        Month = parseInt($Object.parent().find("#" + Prefix + "Month").val(), 10);
        Day = parseInt($Object.val(), 10);
        Description = $Object.parent().find("#" + Prefix + "Description").val();

        Result = {};
        Result[Month] = {};
        Result[Month][Day] = Description;

        return Result;
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.SystemConfiguration.VacationDays || {}));
