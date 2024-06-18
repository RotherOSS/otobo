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
 * @namespace Core.Agent.Header
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the functions for handling Header in framework.
 */
Core.Agent.Header = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Header
     * @function
     * @description
     *      Initializes the module functionality.
     */
    TargetNS.Init = function () {

        // Bind event on ToolBarSearchProfile field
        $('#ToolBarSearchProfile').on('change', function (Event) {
            $(Event.target).closest('form').submit();
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });

        // Initialize auto complete searches
        Core.Agent.CustomerInformationCenterSearch.InitAutocomplete($('#ToolBarCICSearchCustomerID'), "SearchCustomerID");
        Core.Agent.CustomerUserInformationCenterSearch.InitAutocomplete($('#ToolBarCICSearchCustomerUser'), "SearchCustomerUser");

        // Initialize full text search via ES
        Core.UI.Elasticsearch.InitSearchField($('#FulltextES'), "AgentElasticsearchQuickResult");

        // Initialize full text search
        Core.Agent.Search.InitToolbarFulltextSearch();

        // Bind event on Simulate RTL button
        $('.DebugRTL').on('click', function () {
            Core.Debug.SimulateRTLPage();
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Header || {}));
