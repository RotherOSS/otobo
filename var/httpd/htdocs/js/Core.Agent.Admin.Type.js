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
 * @namespace Core.Agent.Admin.Type
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special function for AdminType module.
 */
 Core.Agent.Admin.Type = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.Type
     * @function
     * @description
     *      This function initializes the table filter.
     */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($("#FilterTypes"), $("#Types"));

        // init checkbox to include invalid elements
        $('input#IncludeInvalid').off('change').on('change', function () {
            var URL = Core.Config.Get("Baselink") + 'Action=' + Core.Config.Get("Action") + ';IncludeInvalid=' + ( $(this).is(':checked') ? 1 : 0 );
            window.location.href = URL;
        });

        Core.Config.Set('EntityType', 'Type');
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.Type || {}));
