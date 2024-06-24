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

// nofilter(TidyAll::Plugin::OTOBO::JavaScript::UnloadEvent)

"use strict";

var Core = Core || {};

/**
 * @namespace Core.Init
 * @memberof Core
 * @author
 * @description
 *      This namespace contains initialization functionalities.
 */
Core.Init = (function (TargetNS) {
    /**
     * @private
     * @name Namespaces
     * @memberof Core.Init
     * @member {Object}
     * @description
     *      Contains all registered JS namespaces,
     *      organized in initialization blocks.
     */
    var Namespaces = {};

    /**
     * @name RegisterNamespace
     * @memberof Core.Init
     * @function
     * @param {Object} NewNamespace - The new namespace to register
     * @param {String} InitializationBlock - The name of the initialization block in which the namespace should be registered
     * @description
     *      Register a new JavaScript namespace for the OTOBO app.
     *      Parameters define, when the init function of the registered namespace
     *      should be executed.
     */
    TargetNS.RegisterNamespace = function (NewNamespace, InitializationBlock) {
        // all three parameters must be defined
        if (typeof NewNamespace === 'undefined' || typeof InitializationBlock === 'undefined') {
            return;
        }

        // if initialization block does not exist (yet), create it
        if (typeof Namespaces[InitializationBlock] === 'undefined') {
            Namespaces[InitializationBlock] = [];
        }

        // register namespace
        Namespaces[InitializationBlock].push({Namespace: NewNamespace});
    };

    /**
     * @name ExecuteInit
     * @memberof Core.Init
     * @function
     * @param {String} InitializationBlock - The block of registered namespaces that should be initialized
     * @description
     *      Initialize the OTOBO app. Call all init function of all
     *      previously registered JS namespaces.
     *      Parameter defines, which initialization block should be executed.
     */
    TargetNS.ExecuteInit = function (InitializationBlock) {
        // initialization block must be defined
        if (typeof InitializationBlock === 'undefined') {
            return;
        }

        // initialization block must exist
        if (typeof Namespaces[InitializationBlock] === 'undefined') {
            return;
        }

        // initialization block must contain namespaces
        if (Namespaces[InitializationBlock].length < 1) {
            return;
        }

        $.each(Namespaces[InitializationBlock], function () {
            if ($.isFunction(this.Namespace.Init)) {
                this.Namespace.Init();
            }
        });
    };

    return TargetNS;
}(Core.Init || {}));
