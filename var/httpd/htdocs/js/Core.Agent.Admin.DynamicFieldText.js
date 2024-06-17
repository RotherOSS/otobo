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
 * @namespace Core.Agent.Admin.DynamicFieldText
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the DynamicFieldText module.
 */
Core.Agent.Admin.DynamicFieldText = (function (TargetNS) {

    /**
     * @name RemoveRegEx
     * @memberof Core.Agent.Admin.DynamicFieldText
     * @function
     * @returns {Boolean} Returns true.
     * @param {String} IDSelector - ID of the pressed remove value button.
     * @description
     *      This function removes a RegEx.
     */
    TargetNS.RemoveRegEx = function(IDSelector) {

        var ObjectIndex = IDSelector.match(/.+_(\d+)/)[1];
        $('#RegExRow_' + ObjectIndex).remove();

        return true;
    };

    /**
     * @name AddRegEx
     * @memberof Core.Agent.Admin.DynamicFieldText
     * @function
     * @returns {Boolean} Returns false
     * @param {Object} RegExInsert - HTML container of the RegEx.
     * @description
     *      This function adds a new RegEx.
     */
    TargetNS.AddRegEx = function(RegExInsert) {
        var $Clone = $('.RegExTemplate').clone(),
            RegExCounter = $('#RegExCounter').val();

        // increment RegEx counter
        RegExCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden RegExTemplate');

        // add needed class and id
        $Clone.addClass('RegExRow');
        $Clone.addClass('W50pc');
        $Clone.attr('id', 'RegExRow_' + RegExCounter);

        // copy RegExs and change ids and names
        $Clone.find(':input, a.RemoveRegEx').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + '_' + RegExCounter);
            $(this).attr('name', ID + '_' + RegExCounter);

            $(this).addClass('Validate_Required');

            // set error controls
            $(this).parent().find('#' + ID + 'Error').attr('id', ID + '_' + RegExCounter + 'Error');
            $(this).parent().find('#' + ID + 'Error').attr('name', ID + '_' + RegExCounter + 'Error');

            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + '_' + RegExCounter + 'ServerError');
            $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + '_' + RegExCounter + 'ServerError');

            // add event handler to remove button
            if($(this).hasClass('RemoveRegEx')) {

                // bind click function to remove button
                $(this).on('click', function () {
                    TargetNS.RemoveRegEx($(this).attr('id'));
                    return false;
                });
            }
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + RegExCounter);
        });

        // append to container
        RegExInsert.append($Clone);

        // set new count of RegExs
        $('#RegExCounter').val(RegExCounter);

        return false;
    };

    /**
    * @name Init
    * @memberof Core.Agent.Admin.DynamicFieldText
    * @function
    * @description
    *       Initialize module functionality
    */
    TargetNS.Init = function () {

        $('.ShowWarning').on('change keyup', function () {
            $('p.Warning').removeClass('Hidden');
        });

        // click handler to add regex
        $('#AddRegEx').on('click', function () {
            TargetNS.AddRegEx(
                $(this).closest('fieldset').find('.RegExInsert')
            );
            return false;
        });

        // Bind click event to remove button for existing RegExs.
        $('a.RemoveRegEx').on('click', function () {
            TargetNS.RemoveRegEx($(this).attr('id'));
            return false;
        });

        Core.Agent.Admin.DynamicField.ValidationInit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldText || {}));
