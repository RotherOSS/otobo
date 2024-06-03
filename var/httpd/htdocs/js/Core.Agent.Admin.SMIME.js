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
 * @namespace Core.Agent.Admin.SMIME
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module function for SMIME module.
 */
 Core.Agent.Admin.SMIME = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.SMIME
     * @function
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {

        // Initialize SMIME table filter
        Core.UI.Table.InitTableFilter($('#FilterSMIME'), $('#SMIME'));

        // Open pop up window
        $('a.CertificateRead').off('click').on('click', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'CertificateRead');
            return false;
        });

        // Initialize SMIME certificate fitler
        Core.UI.Table.InitTableFilter($('#FilterSMIMECerts'), $('#AvailableCerts'));

        // Bind click function to remove button
        $('#SMIME a.TrashCan').on('click', function () {
            if (window.confirm(Core.Language.Translate('Do you really want to delete this certificate?'))) {
                return true;
            }
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.SMIME || {}));
