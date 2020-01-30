// --
// Copyright (C) 2001-2019 OTRS AG, https://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var OTOBO = OTOBO || {};
OTOBO.Agent = OTOBO.Agent || {};
OTOBO.Agent.App = OTOBO.Agent.App || {};

/**
 * @namespace
 * @exports TargetNS as OTOBO.Agent.App.Dashboard
 * @description
 *      This namespace contains the special module functions for the Dashboard.
 */
OTOBO.Agent.App.Dashboard = (function (TargetNS) {
    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        OTOBO.UI.DnD.Sortable(
            $(".SidebarColumn"),
            {
                Handle: '.Header h2',
                Items: '.CanDrag',
                Placeholder: 'DropPlaceholder',
                Tolerance: 'pointer',
                Distance: 15,
                Opacity: 0.6
            }
        );

        OTOBO.UI.DnD.Sortable(
            $(".ContentColumn"),
            {
                Handle: '.Header h2',
                Items: '.CanDrag',
                Placeholder: 'DropPlaceholder',
                Tolerance: 'pointer',
                Distance: 15,
                Opacity: 0.6
            }
        );
    };

    /**
     * @function
     * @return nothing
     *      This function binds a click event on an html element to update the preferences of the given dahsboard widget
     * @param {jQueryObject} $ClickedElement The jQuery object of the element(s) that get the event listener
     * @param {string} ElementID The ID of the element whose content should be updated with the server answer
     * @param {jQueryObject} $Form The jQuery object of the form with the data for the server request
     */
    TargetNS.RegisterUpdatePreferences = function ($ClickedElement, ElementID, $Form) {
        if (isJQueryObject($ClickedElement) && $ClickedElement.length) {
            $ClickedElement.click(function () {
                var URL = OTOBO.Config.Get('Baselink') + OTOBO.AJAX.SerializeForm($Form);
                OTOBO.AJAX.ContentUpdate($('#' + ElementID), URL, function () {
                    OTOBO.UI.ToggleTwoContainer($('#' + ElementID + '-setting'), $('#' + ElementID));
                    OTOBO.UI.Table.InitCSSPseudoClasses();
                });
                return false;
            });
        }
    };

    return TargetNS;
}(OTOBO.Agent.App.Dashboard || {}));
