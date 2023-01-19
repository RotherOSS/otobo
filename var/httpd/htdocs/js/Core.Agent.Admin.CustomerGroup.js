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
 * @namespace Core.Agent.Admin.CustomerGroup
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module function for CustomerGroup selection.
 */
 Core.Agent.Admin.CustomerGroup = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.CustomerGroup
    * @function
    * @description
    *      This function initializes filter and "SelectAll" actions.
    */
    TargetNS.Init = function () {
        var RelationItems = Core.Config.Get('RelationItems');

        // initialize "SelectAll" checkbox and bind click event on "SelectAll" for each relation item
        if (RelationItems) {
            $.each(RelationItems, function (index) {
                Core.Form.InitSelectAllCheckboxes($('table td input[type="checkbox"][name="' + Core.App.EscapeSelector(RelationItems[index]) + '"]'), $('#SelectAll' + Core.App.EscapeSelector(RelationItems[index])));

                $('input[type="checkbox"][name="' + Core.App.EscapeSelector(RelationItems[index]) + '"]').click(function () {
                    Core.Form.SelectAllCheckboxes($(this), $('#SelectAll' + Core.App.EscapeSelector(RelationItems[index])));
                });
            });
        }

        // initialize table filter
        Core.UI.Table.InitTableFilter($("#FilterGroups"), $("#Group"));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.CustomerGroup || {}));
