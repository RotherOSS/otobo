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
 * @namespace Core.Agent.Admin.Group
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for AdminGroup.
 */
Core.Agent.Admin.Group = (function (TargetNS) {

    /**
     * @name Init
     * @memberof CCore.Agent.Admin.Group
     * @function
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {

        Core.Form.Validate.SetSubmitFunction($('form#GroupUpdate'), function(Form) {

            if ($('#GroupOldName').val() !== 'admin' || $('#GroupName').val() === 'admin') {
                Form.submit();
                return false;
            }

            Core.UI.Dialog.ShowContentDialog('<p style="width:400px;">' + Core.Language.Translate("WARNING: When you change the name of the group 'admin', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.") + '</p>', '', '150px', 'Center', true, [
                {
                    Label: Core.Language.Translate('Cancel'),
                    Function: function () {
                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                        Core.Form.EnableForm($('form#GroupUpdate'));
                        $('#GroupName').focus();
                    }
                },
                {
                    Label: Core.Language.Translate('Confirm'),
                    Function: function () {
                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                        Form.submit();
                    },
                    Class: 'Primary'
                }
            ]);
        });

        Core.UI.Table.InitTableFilter($('#FilterGroups'), $('#Groups'));

        // init checkbox to include invalid elements
        $('input#IncludeInvalid').off('change').on('change', function () {
            var URL = Core.Config.Get("Baselink") + 'Action=' + Core.Config.Get("Action") + ';IncludeInvalid=' + ( $(this).is(':checked') ? 1 : 0 );
            window.location.href = URL;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Group || {}));
