// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
// Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

var Core         = Core             || {};
Core.Agent       = Core.Agent       || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.TypeImportExport
 * @description
 *      This namespace contains the special module functions for the Type ImportExport module.
 */
Core.Agent.Admin.TypeImportExport = (function (TargetNS) {

    TargetNS.Init = function () {

        $.each(['Type'], function (Index, Elements) {

            $('input[type="checkbox"][name="SelectAll'+Elements+'"]').bind('click', function () {

                Core.Form.SelectAllCheckboxes($(this), $('[name="'+Elements+'"]'));

            });
        });

    };

    return TargetNS;

}(Core.Agent.Admin.TypeImportExport || {}));

Core.Agent.Admin.TypeImportExport.Init();
