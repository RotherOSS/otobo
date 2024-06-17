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
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.SystemConfigurationUser
 * @memberof Core
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains the special functions for OTOBOUserSpecificSettings module.
 */
 Core.Agent.Admin.SystemConfigurationUser = (function (TargetNS) {

    /**
    * @name Init
    * @memberof Core.Agent.Admin.SystemConfigurationUser
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {

        $("a.DeleteUserSetting").on("click", function() {
            TargetNS.UserSettingValueDelete($(this));
            return false;
        });
    };

    /**
     * @public
         * @name UserSettingValueDelete
     * @memberof Core.Agent.Admin.SystemConfigurationUser
     * @function
     * @param {jQueryObject} $Object - jquery object
     * @returns {Boolean} - false in case delete all values is not needed
     * @description
     *      Delete user setting.
     */
    TargetNS.UserSettingValueDelete = function ($Object) {
        var $Widget = $Object.closest(".SettingContainer"),
            $SettingName = $("#SettingName"),
            Data = 'Action=AdminSystemConfigurationUser;Subaction=UserSettingValueDelete;';

        Data += 'SettingName=' + encodeURIComponent($SettingName.attr('value')) + ';';
        Data += 'ModifiedID=' + encodeURIComponent($Object.attr('value')) + ';';

        // Confirm deleting all values at once.
        if ($Object.attr('value') == 'All') {
            if (!confirm(Core.Language.Translate('Are you sure you want to remove all user values?'))) {
                return false;
            }
        }

        // Show loader.
        Core.UI.WidgetOverlayShow($Widget, 'Loading');

        Core.AJAX.FunctionCall(
            Core.Config.Get('Baselink'),
            Data,
            function(Response) {

                if (Response.Error === undefined) {

                    if (Response.Success == 1) {
                        // Removel all or just one setting container.
                        if ($Object.attr('value') == 'All') {
                            $(".SettingContainer").remove();
                        }
                        else {
                            $Widget.remove();
                        }

                        // Show no user values message and remove delete all button.
                        if($('li.SettingContainer').length < 1) {
                            $("#NoValues").removeClass('Hidden');
                            $(".AllUserValues").remove();
                        }
                    }
                }
                else {
                    alert(Response.Error);
                }

                // Remove loading
                Core.UI.WidgetOverlayHide($Widget, true);
            }
        );
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.SystemConfigurationUser || {}));
