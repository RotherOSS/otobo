// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace ore.Agent.Admin.OAuth2Module
 * @memberof Core.Agent.Admin
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains the special module functions for the OAuth2 Token Store.
 */
Core.Agent.Admin.OAuth2Module = (function (TargetNS) {

    var ToggleGrantType = function() {

        if( $('#GrantType').length == 0) return;

        var GrantType = $('#GrantType')[0].value;
        if(GrantType == 'password') {

            $("[for|='Username']").show();
            $("[for|='Password']").show();
            $('#UsernameField').show();
            $('#PasswordField').show();

            $('#Username').addClass('Validate_Required');
            $('#Password').addClass('Validate_Required');
        }
        else {

            $("[for|='Username']").hide()
            $("[for|='Password']").hide();
            $('#UsernameField').hide();
            $('#PasswordField').hide();

            $('#Username').removeClass('Validate_Required');
            $('#Password').removeClass('Validate_Required');
        }
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.OAuth2Module
     * @function
     * @description
     *      This function binds events to certain actions
     */
    TargetNS.Init = function () {

        ToggleGrantType();

        $('#GrantType').on( 'change', function() {
            ToggleGrantType();
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.OAuth2Module || {}));
