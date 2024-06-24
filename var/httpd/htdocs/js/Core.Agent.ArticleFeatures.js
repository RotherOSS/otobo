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
 * @namespace Core.Agent.ArticleFeatures
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for TicketSplit.
 */
Core.Agent.ArticleFeatures = (function (TargetNS) {

    /**
     * @function
     * @param {String} Action which is used in framework right now.
     * @param {String} Used profile name.
     * @return nothing
     *      This function open the delete confirmation dialog after clicking on "delete" button in AgentTicketZoom.
     */

    TargetNS.OpenDeleteConfirmDialog = function (DataHref) {

        // extract the parameters from the DataHref string
        var DataHrefArray = DataHref.split(';'),
            TicketIDArray = DataHrefArray[1].split('='),
            ArticleIDArray = DataHrefArray[2].split('=');

        Core.UI.Dialog.ShowDialog({
            Modal: true,
            Title: Core.Language.Translate('Article Delete'),
            HTML: Core.Language.Translate('Are you sure you want to delete this article?'),
            PositionTop: '15%',
            PositionLeft: 'Center',
            CloseOnEscape: false,
            CloseOnClickOutside: false,
            Buttons: [
                {
                    Label: Core.Language.Translate('Yes'),
                    Function: function () {
                        var Data = {
                            Action: 'AgentTicketArticleEdit',
                            Subaction: 'ArticleDelete',
                            TicketID: TicketIDArray[1],
                            ArticleID: ArticleIDArray[1]
                        };

                        var Success = 0;

                        Core.AJAX.FunctionCall( Core.Config.Get('CGIHandle'), Data, function (Response) {

                            if ( Response.Success == "1" ) {
                                Core.UI.Popup.ClosePopup();

                                Core.UI.Dialog.ShowDialog({
                                    Modal: true,
                                    Title: Core.Language.Translate('Information'),
                                    HTML: '<div style="height: 40px; display: flex; align-items: center; justify-content: center;">' + Core.Language.Translate('Article deleted successfully!') + '</div>',
                                    PositionTop: '15%',
                                    PositionLeft: 'Center',
                                    CloseOnEscape: false,
                                    CloseOnClickOutside: false,
                                });

                                setTimeout(() => {
                                    Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                                        WindowObject.Core.UI.Popup.FirePopupEvent('URL', {
                                            URL: DataHref + ';ArticleStatus=1'
                                        });
                                    });
                                }, 3000);
                            } else {
                                Core.UI.Popup.ClosePopup();

                                Core.UI.Dialog.ShowAlert(
                                    Core.Language.Translate('Error'),
                                    Core.Language.Translate('Article already marked as deleted.')
                                );
                                return false;
                            }
                        });
                    },
                    Class: 'Primary CallForAction'
                },
                {
                    Label: Core.Language.Translate('Cancel'),
                    Function: function () {
                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                    },
                Class: 'CallForAction'
                },
            ]
        });

    };

    /**
     * @function
     * @param {String} Action which is used in framework right now.
     * @param {String} Used profile name.
     * @return nothing
     *      This function open the delete confirmation dialog after clicking on "delete" button in AgentTicketZoom.
     */

    TargetNS.OpenUndoDeleteConfirmDialog = function (DataHref) {

        // extract the parameters from the DataHref string
        var DataHrefArray = DataHref.split(';'),
            TicketIDArray = DataHrefArray[1].split('='),
            ArticleIDArray = DataHrefArray[2].split('=');

        Core.UI.Dialog.ShowDialog({
            Modal: true,
            Title: Core.Language.Translate('Article Restore'),
            HTML: Core.Language.Translate('Are you sure you want to restore this article?'),
            PositionTop: '15%',
            PositionLeft: 'Center',
            CloseOnEscape: false,
            CloseOnClickOutside: false,
            Buttons: [
                {
                    Label: Core.Language.Translate('Yes'),
                    Function: function () {
                        var Data = {
                            Action: 'AgentTicketArticleEdit',
                            Subaction: 'ArticleRestore',
                            TicketID: TicketIDArray[1],
                            ArticleID: ArticleIDArray[1]
                        };

                        var Success = 0;

                        Core.AJAX.FunctionCall( Core.Config.Get('CGIHandle'), Data, function (Response) {

                            if ( Response.Success == "1" ) {
                                Core.UI.Popup.ClosePopup();

                                Core.UI.Dialog.ShowDialog({
                                    Modal: true,
                                    Title: Core.Language.Translate('Information'),
                                    HTML: '<div style="height: 40px; display: flex; align-items: center; justify-content: center;">' + Core.Language.Translate('Article restored successfully!') + '</div>',
                                    PositionTop: '15%',
                                    PositionLeft: 'Center',
                                    CloseOnEscape: false,
                                    CloseOnClickOutside: false,
                                });

                                setTimeout(() => {
                                    Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                                        WindowObject.Core.UI.Popup.FirePopupEvent('URL', {
                                            URL: DataHref + ';ArticleStatus=1'
                                        });
                                    });
                                }, 3000);
                            } else {
                                Core.UI.Popup.ClosePopup();

                                Core.UI.Dialog.ShowAlert(
                                    Core.Language.Translate('Error'),
                                    Core.Language.Translate('Article not available for restoring.')
                                );
                                return false;
                            }
                        });
                    },
                    Class: 'Primary CallForAction'
                },
                {
                    Label: Core.Language.Translate('Cancel'),
                    Function: function () {
                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                    },
                Class: 'CallForAction'
                },
            ]
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.ArticleFeatures || {}));
