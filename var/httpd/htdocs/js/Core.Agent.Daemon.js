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
 * @namespace Core.Agent.Daemon
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for the Daemon module.
 */
Core.Agent.Daemon = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Daemon
     * @function
     * @description
     *      This function initializes the module.
     */
    TargetNS.Init = function () {
        // set action to daemon notify band link
        $('.DaemonInfo').on('click', function() {
            Core.Agent.Daemon.OpenDaemonStartDialog();
            return false;
        });
    };

    /**
     * @private
     * @name ShowWaitingDialog
     * @memberof Core.Agent.Daemon
     * @function
     * @description
     *      Shows waiting dialog until daemon start screen is ready.
     */
    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Language.Translate('Loading...') + '"></span></div>', Core.Language.Translate('Loading...'), '240px', 'Center', true);
    }

    /**
     * @name OpenDaemonStartDialog
     * @memberof Core.Agent.Daemon
     * @function
     * @description
     *      This function open the daemon start dialog.
     */

    TargetNS.OpenDaemonStartDialog = function(){

        var Data = {
            Action: 'AgentDaemonInfo'
        };

        ShowWaitingDialog();

        // call dialog HTML via AJAX
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {

                // if the waiting dialog was canceled, do not show the daemon
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                // show main dialog
                Core.UI.Dialog.ShowContentDialog(HTML, Core.Language.Translate('Information about the OTOBO Daemon'), '240px', 'Center', true);

                // set cancel button action
                $('#DaemonFormCancel').on('click', function() {

                    // close main dialog
                    Core.UI.Dialog.CloseDialog($('#DaemonRunDialog'));
                });

            }, 'html'
        );
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Daemon || {}));
