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
 * @namespace Core.JSON
 * @memberof Core
 * @author
 * @description
 *      Contains the code for the JSON functions.
 */
Core.JSON = (function (TargetNS) {

    // Some old browsers (e.g. IE7) don't have native JSON support. Such browsers will
    // let you see a javascript error message instead of the 'old browser' warning box.
    // Therefore we do the dependency check silent in this case.
    if (!Core.Debug.CheckDependency('Core.JSON', 'JSON.parse', 'JSON parser', true)) {
        return false;
    }

    /**
     * @name Parse
     * @memberof Core.JSON
     * @function
     * @returns {Object} The parsed JSON object.
     * @param {String} JSONString - The string which should be parsed.
     * @description
     *      This function parses a JSON String.
     */
    TargetNS.Parse = function (JSONString) {
        var JSONObject;

        if (typeof JSONString !== 'string' && typeof JSONString !== 'undefined') {
            return JSONString;
        }

        try {
            JSONObject = JSON.parse(JSONString);
        }
        catch (e) {
            JSONObject = {};
        }

        return JSONObject;
    };

    /**
     * @name Stringify
     * @memberof Core.JSON
     * @function
     * @returns {String} The stringified JSON object.
     * @param {Object} JSONObject - The object which should be stringified.
     * @description
     *      This function stringifies a given JavaScript object.
     */
    TargetNS.Stringify = function (JSONObject) {
        var JSONString;

        try {
            JSONString = JSON.stringify(JSONObject);
        }
        catch (e) {
            JSONString = "";
        }

        return JSONString;
    };

    return TargetNS;
}(Core.JSON || {}));
