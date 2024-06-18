// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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
 * @namespace
 * @exports TargetNS as Core.Agent.DynamicFieldDBDetailedSearch
 * @description
 *      This namespace contains the special module functions for the dynamic field database detailed search.
 */
Core.Agent.DynamicFieldDBDetailedSearch = (function(TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.DynamicFieldDBDetailedSearch
     * @function
     * @description
     *      Initialize module functionalities.
     */
    TargetNS.Init = function() {

        // Initialize dynamic field databse detailed search.
        Core.Agent.DynamicFieldDBSearch.InitDetailedSearch();

        // Bind event on master action click.
        $('.MasterAction').on('click', function () {
            var Elements = $(this).children(),
                Identifier = $(this).attr('data'),
                NewValue = '',
                FieldName;

            $.each(Elements, function () {
                NewValue += $(this).text() + ' - ';
            });

            // Get field name.
            FieldName = $('#ResultTable').attr('field');

            // Cut the last dash away.
            NewValue = NewValue.substring(0, NewValue.length - 2);

            // Add the new search value.
            parent.Core.Agent.DynamicFieldDBSearch.AddResultElement(FieldName, NewValue, Identifier, true);

            // Close the detailed search dialog.
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.DynamicFieldDBDetailedSearch || {}));
