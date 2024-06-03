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
 * @namespace Core.Agent.Admin.Registration
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module function for AdminRegistration.
 */
 Core.Agent.Admin.Registration = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.Registration
    * @function
    * @description
    *      This function initializes modal dialogs and also textarea selecting.
    */
    TargetNS.Init = function () {

        $('#RegistrationMoreInfo').on('click', function() {
            Core.UI.Dialog.ShowDialog({
                Modal: true,
                Title: Core.Language.Translate('System Registration'),
                HTML: $('#QADialog').html(),
                PositionTop: '70px',
                PositionLeft: 'Center',
                CloseOnEscape: true,
                CloseOnClickOutside: true
            });
            return false;
        });

        $('#RegistrationDataProtection').on('click', function() {
            Core.UI.Dialog.ShowDialog({
                Modal: true,
                Title: Core.Language.Translate('Data Protection'),
                HTML: $('#DPDialog').html(),
                PositionTop: '10px',
                PositionLeft: 'Center',
                CloseOnEscape: true,
                CloseOnClickOutside: true
            });
            return false;
        });

        $('textarea.SupportData').on('focus', function() {
            $(this).select();
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Registration || {}));
