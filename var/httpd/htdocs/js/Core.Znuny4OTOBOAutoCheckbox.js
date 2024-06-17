// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
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

var Core   = Core || {};

/**
 * @namespace
 * @exports TargetNS as Core.Znuny4OTOBOAutoCheckbox
 * @description
 *      This namespace contains the special functions for Znuny4OTOBOAutoCheckbox.
 */
Core.Znuny4OTOBOAutoCheckbox = (function (TargetNS) {

    TargetNS.Init = function () {

        // find all select elements for date fields
        // also input fields because datefields can also be input fields (sysconfig TimeInputFormat)
        $('select,input').off('change.Z40AutoCheckbox').on('change.Z40AutoCheckbox', function() {
            TargetNS.AutoCheck(this);
        });

        // take care about ajax requests so we also need to have this functionality in process management
        Core.App.Subscribe('Event.AJAX.FunctionCall.Callback', function() {
            $('select,input').off('change.Z40AutoCheckbox').on('change.Z40AutoCheckbox', function() {
                TargetNS.AutoCheck(this);
            });
        });

        return true;
    };

    TargetNS.AutoCheck = function(Element) {

        // get id
        var ElementID = $(Element).attr('id');
        if (!ElementID) return;

        // only handle dynamic fields
        if (!ElementID.match(/^DynamicField/)) return;

        // check which element was changed of the date field
        var ElementType = ElementID.match(/(Day|Month|Year|Hour|Minute)$/);
        if (!ElementType) return;

        // mark checkbox for used date field
        var ElementCheckboxID = ElementID.replace(ElementType[1], 'Used');
        $('#' + ElementCheckboxID).prop('checked', true);
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Znuny4OTOBOAutoCheckbox || {}));
