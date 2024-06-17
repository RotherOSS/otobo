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
 * @namespace Core.Agent.TicketHistory
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the TicketHistory functions.
 */
Core.Agent.TicketHistory = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketHistory
     * @function
     * @description
     *      This function initializes the functionality for the TicketHistory screen.
     */
    TargetNS.Init = function () {
        var $FilterHistory = $('#FilterHistory');

        // bind click event on ZoomView link
        $('a.LinkZoomView').on('click', function () {
            var that = this;
            Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                WindowObject.Core.UI.Popup.FirePopupEvent('URL', { URL: $(that).attr('href')});
            });
            Core.UI.Popup.ClosePopup();
        });

        $('#ExpandCollapseAll').off('click').on('click', function() {
            if ($(this).hasClass('Collapsed')) {
                $('.WidgetSimple:not(.HistoryActions)').removeClass('Collapsed').addClass('Expanded');
                $(this).removeClass('Collapsed');
            }
            else {
                $('.WidgetSimple:not(.HistoryActions)').removeClass('Expanded').addClass('Collapsed');
                $(this).addClass('Collapsed');
            }
            return false;
        });

        Core.UI.Table.InitTableFilter($FilterHistory, $('.DataTable'), undefined, true);

        // Focus filter
        $FilterHistory.trigger('keydown.FilterInput').focus();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketHistory || {}));
