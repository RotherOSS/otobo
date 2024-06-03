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
 * @namespace Core.Agent.Admin.SelectBox
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module function for AdminSelectBox.
 */
 Core.Agent.Admin.SelectBox = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.SelectBox
    * @function
    * @description
    *      This function initializes the module functionality.
    */
    TargetNS.Init = function () {
        Core.Form.Validate.SetSubmitFunction($('#AdminSelectBoxForm'), function (Form) {
            Form.submit();

            if ($('#ResultFormat option:selected').text() !== 'CSV'
                && $('#ResultFormat option:selected').text() !== 'Excel'
             ) {
                window.setTimeout(function(){
                    Core.Form.DisableForm($(Form));
                }, 0);
            }
        });

        Core.UI.Table.InitTableFilter($('#FilterResults'), $('#Results'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SelectBox || {}));
