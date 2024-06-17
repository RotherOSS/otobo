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
 * @namespace Core.Agent.Stats
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for the statistic module.
 */
Core.Agent.Stats = (function (TargetNS) {

    /**
     * @name FormatGraphSizeRelation
     * @memberof Core.Agent.Stats
     * @function
     * @description
     *      Activates the graph size menu if a GD element is selected.
     */
    TargetNS.FormatGraphSizeRelation = function () {
        var $Format = $('#Format'),
            Flag = false,
            Reg = /^GD::/;

        // find out if a GD element is used
        $.each($Format.children('option:selected'), function () {
            if (Reg.test($(this).val()) === true) {
                Flag = true;
            }
        });

        // activate or deactivate the Graphsize menu
        if (Flag) {
            $('#GraphSize').removeAttr('disabled');
        }
        else {
            $('#GraphSize').attr('disabled', 'disabled');
        }
    };

    /**
     * @name SelectCheckbox
     * @memberof Core.Agent.Stats
     * @function
     * @param {String} Name - The name of the radio button to be selected.
     * @description
     *      Activate given checkbox.
     */
    TargetNS.SelectCheckbox = function (Name) {
        $('input[type="checkbox"][name=' + Name + ']').prop('checked', true);
    };

    /**
     * @name SelectRadiobutton
     * @memberof Core.Agent.Stats
     * @function
     * @param {String} Value - The value attribute of the radio button to be selected.
     * @param {String} Name - The name of the radio button to be selected.
     * @description
     *      Selects a radio button by name and value.
     */
    TargetNS.SelectRadiobutton = function (Value, Name) {
        $('input[type="radio"][name=' + Name + '][value=' + Value + ']').prop('checked', true);
    };

    return TargetNS;
}(Core.Agent.Stats || {}));
