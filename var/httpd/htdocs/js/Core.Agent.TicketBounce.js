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
 * @namespace Core.Agent.TicketBounce
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for AgentTicketBounce functionality.
 */
 Core.Agent.TicketBounce = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketBounce
     * @function
     * @description
     *      This function binds click event on checkbox.
     */
    TargetNS.Init = function () {

        // function to switch between mandatory and optional
        function SwitchMandatoryFields() {
            var InformSenderChecked = $('#InformSender').prop('checked'),
                $ElementsLabelObj = $('#To,#Subject,#RichText').parent().prev('label');

            if (InformSenderChecked) {
                $ElementsLabelObj
                    .addClass('Mandatory')
                    .find('.Marker')
                    .removeClass('Hidden');
            }
            else if (!InformSenderChecked) {
                $ElementsLabelObj
                    .removeClass('Mandatory')
                    .find('.Marker')
                    .addClass('Hidden');
            }

            return;
        }

        // initial setting for to/subject/body
        SwitchMandatoryFields();

        // watch for changes of inform sender field
        $('#InformSender').on('click', function(){
            SwitchMandatoryFields();
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.TicketBounce || {}));
