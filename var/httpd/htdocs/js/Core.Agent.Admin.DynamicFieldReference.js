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
 * @namespace Core.Agent.Admin.DynamicFieldReference
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the DynamicFieldReference module.
 */
Core.Agent.Admin.DynamicFieldReference = (function (TargetNS) {

    /**
     * @name DynamicFieldReferenceRegisterEventHandler
     * @memberof Core.Agent.Admin.DynamicFieldReference
     * @function
     * @description
     *      Bind event on reference dynamic field select referenced object type field.
     *      Autocommit when the referenced object type is selected.
     */
    TargetNS.DynamicFieldReferenceRegisterEventHandler = function () {

        // reload the form with the inputs relevant to the referenced object type
        $('#ReferencedObjectType').change( function() {
            $(this).closest('form').submit();

            return false;
        });
    };

    /**
    * @name Init
    * @memberof Core.Agent.Admin.DynamicFieldReference
    * @function
    * @description
    *       Initialize module functionality, register event handlers
    */
    TargetNS.Init = function () {

        // Initialize JS functions
        TargetNS.DynamicFieldReferenceRegisterEventHandler();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldReference || {}));
