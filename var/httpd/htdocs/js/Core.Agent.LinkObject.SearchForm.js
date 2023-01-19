// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
Core.Agent.LinkObject = Core.Agent.LinkObject || {};

/**
 * @namespace Core.Agent.LinkObject.SearchForm
 * @memberof Core.Agent.LinkObject
 * @author
 * @description
 *      This namespace contains search form functions for LinkObject screen.
 */
Core.Agent.LinkObject.SearchForm = (function (TargetNS) {
    /**
     * @name Init
     * @memberof Core.Agent.LinkObject.SearchForm
     * @function
     * @description
     *      This function initializes the LinkObject search form.
     */
    TargetNS.Init = function () {

        var SearchValueFlag,
            TemporaryLink = Core.Config.Get('TemporaryLink'),
            Status;

        if (typeof TemporaryLink !== 'undefined' && parseInt(TemporaryLink, 10) === 1) {
            $('#LinkAddCloseLink, #LinkDeleteCloseLink').on('click', function () {
                Core.UI.Popup.ClosePopup();
                return false;
            });
        }

        $('#TargetIdentifier').on('change', function () {
            $('#LinkSearchForm').addClass('SkipFieldCheck');
            Core.UI.Dialog.ShowWaitingDialog(undefined, Core.Language.Translate("Please wait..."));
            $(this).closest('form').submit();
        });

        // Two submits in this form
        // if SubmitSelect or AddLinks button was clicked,
        // add "SkipFieldCheck" class to this button
        $('#AddLinks').on('click.Submit', function () {
           $('#LinkSearchForm').addClass('SkipFieldCheck');
        });

        $('#LinkSearchForm').submit(function () {

            // If SubmitSelect button was clicked,
            // "SkipFieldCheck" was added as class to the button
            // remove the class and do the search
            if ($('#LinkSearchForm').hasClass('SkipFieldCheck')) {
                $('#LinkSearchForm').removeClass('SkipFieldCheck');
                return true;
            }

            SearchValueFlag = false;
            $('#LinkSearchForm input, #LinkSearchForm select').each(function () {
                if ($(this).attr('name') && $(this).attr('name').match(/^SEARCH::/)) {
                    if ($(this).val() && $(this).val().length) {
                        SearchValueFlag = true;
                    }
                }
            });

            if (!SearchValueFlag) {
               alert(Core.Language.Translate("Please enter at least one search value or * to find anything."));
               return false;
            }
            else {
                Core.UI.Dialog.ShowWaitingDialog(undefined, Core.Language.Translate("Searching for linkable objects. This may take a while..."));
            }
        });

        // Make sure that (only!) from a popup window, links are always opened in a new tab of the main window.
        if (Core.UI.Popup.CurrentIsPopupWindow()) {
            $('a.LinkObjectLink').attr('target', '_blank');
        }

        // event for 'Select All' checkbox
        $('.SelectAll').on('click', function () {
            Status = $(this).prop('checked');
            $(this).closest('.WidgetSimple').find('table input[type=checkbox]').prop('checked', Status);
        });

        // event for checkboxes
        $('input[type="checkbox"][name="LinkTargetKeys"]').on('click', function () {
            Core.Form.SelectAllCheckboxes($(this), $(this).closest('.WidgetSimple').find('.SelectAll'));
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.LinkObject.SearchForm || {}));
