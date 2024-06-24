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
 * @namespace Core.Agent.Admin.CustomerAccept
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the Notification Event module.
 */
Core.Agent.Admin.CustomerAccept = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.CustomerAccept
     * @function
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.Init = function () {

        // bind click function to add button
        $('.LanguageAdd').off('change.CustomerAccept').on('change.CustomerAccept', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        // bind click function to remove button
        $('.LanguageRemove').off('click.CustomerAccept').on('click.CustomerAccept', function () {

            if (window.confirm(Core.Language.Translate('Do you really want to delete this language?'))) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });
    };

   /**
     * @name AddLanguage
     * @memberof Core.Agent.Admin.CustomerAccept
     * @function
     * @param {string} LanguageID - short name of the language like es_MX.
     * @param {string} Language - full name of the language like Spanish (Mexico).
     * @returns {Bool} Returns false to prevent event bubbling.
     * @description
     *      This function add a new notification event language.
     */
    TargetNS.AddLanguage = function(LanguageID, Language){

        var $Clone = $('.Template').clone();

        if (Language === '-'){
            return false;
        }

        // remove unnecessary classes
        $Clone.removeClass('Hidden Template');

        // add title
        $Clone.find('.Title').html(Language);

        // update remove link
        $Clone.find('#Template_Language_Remove').attr('name', LanguageID + '_Language_Remove');
        $Clone.find('#Template_Language_Remove').attr('id', LanguageID + '_Language_Remove');

        // set hidden language field
        $Clone.find('.LanguageID').attr('name', 'LanguageID');
        $Clone.find('.LanguageID').val(LanguageID);

        // update body label
        $Clone.find('#Template_Label_Body').attr('for', LanguageID + '_Body');
        $Clone.find('#Template_Label_Body').attr('id', LanguageID + '_Label_Body');

        // update body field
        $Clone.find('#Template_Body').attr('name', LanguageID + '_Body');
        $Clone.find('#Template_Body').addClass('RichText');
        $Clone.find('#Template_Body').addClass('Validate_RequiredRichText');
        $Clone.find('#Template_Body').attr('id', LanguageID + '_Body');
        $Clone.find('#Template_BodyError').attr('id', LanguageID + '_BodyError');

        // append to container
        $('.PrivacyPolicyLanguageContainer').append($Clone);

        // initialize the rich text editor if set
        if (parseInt(Core.Config.Get('RichTextSet'), 10) === 1) {
            Core.UI.RichTextEditor.InitAllEditors();
        }

        // bind click function to remove button
        $('.LanguageRemove').off('click.CustomerAccept').on('click.CustomerAccept', function () {

            if (window.confirm(Core.Language.Translate('Do you really want to delete this language?'))) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });

        TargetNS.LanguageSelectionRebuild();

        return false;
    };


    /**
     * @name RemoveLanguage
     * @memberof Core.Agent.Admin.NotificationEvent
     * @function
     * @param {jQueryObject} Object - JQuery object used to remove the language block
     * @description
     *      This function removes a notification event language.
     */
    TargetNS.RemoveLanguage = function (Object) {
        Object.closest('.PrivacyPolicyLanguage').remove();
        TargetNS.LanguageSelectionRebuild();
    };


    /**
     * @name LanguageSelectionRebuild
     * @memberof Core.Agent.Admin.NotificationEvent
     * @function
     * @returns {Boolean} Returns true.
     * @description
     *      This function rebuilds language selection, only show available languages.
     */
    TargetNS.LanguageSelectionRebuild = function () {

        // get original selection with all possible fields and clone it
        var $Languages = $('#LanguageOrig option').clone();

        $('#Language').empty();

        // strip all already used attributes
        $Languages.each(function () {
            if (!$('.PrivacyPolicyLanguageContainer label#' + $(this).val() + '_Label_Subject').length) {
                $('#Language').append($(this));
            }
        });

        $('#Language').trigger('redraw.InputField');

        // bind click function to add button
        $('.LanguageAdd').off('change.CustomerAccept').on('change.CustomerAccept', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        return true;
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.CustomerAccept || {}));
