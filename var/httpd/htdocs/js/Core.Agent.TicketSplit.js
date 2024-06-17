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
 * @namespace Core.Agent.TicketSplit
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for TicketSplit.
 */
Core.Agent.TicketSplit = (function (TargetNS) {

    /**
     * @function
     * @param {String} Action which is used in framework right now.
     * @param {String} Used profile name.
     * @return nothing
     *      This function open the extended split dialog after clicking on "spit" button in AgentTicketZoom.
     */

    TargetNS.OpenSplitSelection = function (DataHref) {

        // extract the parameters from the DataHref string
        var DataHrefArray = DataHref.split(';'),
            TicketIDArray = DataHrefArray[1].split('='),
            ArticleIDArray = DataHrefArray[2].split('='),
            LinkTicketIDArray = DataHrefArray[3].split('='),
            Data = {
                Action: 'AgentSplitSelection',
                TicketID: TicketIDArray[1],
                ArticleID: ArticleIDArray[1],
                LinkTicketID: LinkTicketIDArray[1]
            };

        // Show waiting dialog.
        Core.UI.Dialog.ShowWaitingDialog(Core.Config.Get('LoadingMsg'), Core.Config.Get('LoadingMsg'));

        // Modernize fields
        Core.UI.InputFields.Activate($('#SplitSelection'));

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                var URL;

                // if the waiting dialog was cancelled, do not show the search
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                // open the modal dialog
                Core.UI.Dialog.ShowContentDialog(HTML, Core.Language.Translate("Split"), '20%', 'Center', true);

                // show or hide the process selection
                $('#SplitSelection').unbind('change.SplitSelection').bind('change.SplitSelection', function() {

                    if ($('#SplitSelection').val() == 'ProcessTicket') {
                        $('#ProcessSelectionLabel').fadeIn();
                        $('#ProcessSelection').fadeIn();

                        // Modernize fields
                        Core.UI.InputFields.Activate();
                    }
                    else {
                        $('#ProcessSelectionLabel').fadeOut();
                        $('#ProcessSelection').fadeOut();
                    }
                });


                // check if it is needed to submit the process id as an additional parameter
                $('#SplitSubmit').off('click').on('click', function() {

                    // only add the parameter, if we split into a process ticket
                    if ($('#SplitSelection').val() == 'ProcessTicket') {

                        // append a hidden field to the form with the selected process id
                        $('<input/>')
                            .attr('type', 'hidden')
                            .attr('name', 'ProcessEntityID')
                            .attr('value', $('#ProcessEntityID').val())
                            .appendTo($('#AgentSplitSelection'));
                    }

                    if(Core.UI.Popup !== undefined && Core.UI.Popup.CurrentIsPopupWindow()) {
                        URL = Core.Config.Get('Baselink') + $('#AgentSplitSelection').serialize();
                        Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                            WindowObject.Core.UI.Popup.FirePopupEvent('URL', {
                                URL: URL
                            });
                        });
                        Core.UI.Popup.ClosePopup();
                    }
                    else {
                        $('#AgentSplitSelection').submit();
                    }
                });

            }, 'html'
        );
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketSplit || {}));
