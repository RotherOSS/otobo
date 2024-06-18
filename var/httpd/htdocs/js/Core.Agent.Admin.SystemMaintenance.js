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
 * @namespace Core.Agent.Admin.SystemMaintenance
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special function for AdminSystemMaintenance module.
 */
 Core.Agent.Admin.SystemMaintenance = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.SystemMaintenance
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {

        // Initialize table filter
        Core.UI.Table.InitTableFilter($('#FilterSystemMaintenances'), $('#SystemMaintenances'));

        // Initialize bind click on delete action
        $('.SystemMaintenanceDelete').on('click', function (Event) {

            if (window.confirm(Core.Language.Translate("Do you really want to delete this scheduled system maintenance?"))) {
                return true;
            }

            // don't interfere with MasterAction
            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SystemMaintenance || {}));
