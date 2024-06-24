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
 * @namespace Core.Agent.Admin.DynamicFieldReference
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the DynamicFieldReference module.
 */
Core.Agent.Admin.DynamicFieldReference = (function (TargetNS) {

    /**
     * @name RemoveReferenceFilter
     * @memberof Core.Agent.Admin.DynamicFieldText
     * @function
     * @returns {Boolean} Returns true.
     * @param {String} IDSelector - ID of the pressed remove value button.
     * @description
     *      This function removes a ReferenceFilter.
     */
    TargetNS.RemoveReferenceFilter = function(IDSelector) {

        var ObjectIndex = IDSelector.match(/.+_(\d+)/)[1];
        $('#ReferenceFilterRow_' + ObjectIndex).remove();

        return true;
    };

    /**
     * @name AddReferenceFilter
     * @memberof Core.Agent.Admin.DynamicFieldText
     * @function
     * @returns {Boolean} Returns false
     * @param {Object} ReferenceFilterInsert - HTML container of the ReferenceFilter.
     * @description
     *      This function adds a new ReferenceFilter.
     */
    TargetNS.AddReferenceFilter = function(ReferenceFilterInsert) {
        var $Clone = $('.ReferenceFilterTemplate').clone(),
            ReferenceFilterCounter = $('#ReferenceFilterCounter').val();

        // increment ReferenceFilter counter
        ReferenceFilterCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ReferenceFilterTemplate');

        // add needed class and id
        $Clone.addClass('ReferenceFilterRow');
        $Clone.addClass('W50pc');
        $Clone.attr('id', 'ReferenceFilterRow_' + ReferenceFilterCounter);

        // copy ReferenceFilters and change ids and names
        $Clone.find(':input, a.RemoveReferenceFilter').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + '_' + ReferenceFilterCounter);
            $(this).attr('name', ID + '_' + ReferenceFilterCounter);

            // set error controls
            $(this).parent().find('#' + ID + 'Error').attr('id', ID + '_' + ReferenceFilterCounter + 'Error');
            $(this).parent().find('#' + ID + 'Error').attr('name', ID + '_' + ReferenceFilterCounter + 'Error');

            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + '_' + ReferenceFilterCounter + 'ServerError');
            $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + '_' + ReferenceFilterCounter + 'ServerError');

            // add event handler to remove button
            if($(this).hasClass('RemoveReferenceFilter')) {

                // bind click function to remove button
                $(this).on('click', function () {
                    TargetNS.RemoveReferenceFilter($(this).attr('id'));
                    return false;
                });
            }
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + ReferenceFilterCounter);
        });

        // append to container
        ReferenceFilterInsert.append($Clone);

        // set new count of ReferenceFilters
        $('#ReferenceFilterCounter').val(ReferenceFilterCounter);

        // activate row select fields
        Core.UI.InputFields.Activate($Clone);

        return false;
    };

    /**
     * @name DynamicFieldReferenceRegisterEventHandler
     * @memberof Core.Agent.Admin.DynamicFieldReference
     * @function
     * @description
     *      Bind event on reference dynamic field select referenced object type field.
     *      Autocommit when the referenced object type is selected.
     */
    TargetNS.DynamicFieldReferenceRegisterEventHandler = function () {

        // reload the form with the inputs relevant to the referenced object type
        $('#ReferencedObjectType').change( function() {
            $(this).closest('form').submit();

            return false;
        });
    };

    /**
    * @name Init
    * @memberof Core.Agent.Admin.DynamicFieldReference
    * @function
    * @description
    *       Initialize module functionality, register event handlers
    */
    TargetNS.Init = function () {

        // Initialize JS functions
        TargetNS.DynamicFieldReferenceRegisterEventHandler();

        $('.ShowWarning').on('change keyup', function () {
            $('p.Warning').removeClass('Hidden');
        });

        // click handler to add regex
        $('#AddReferenceFilter').on('click', function () {
            TargetNS.AddReferenceFilter(
                $(this).closest('fieldset').find('.ReferenceFilterInsert')
            );
            return false;
        });

        // Bind click event to remove button for existing ReferenceFilters.
        $('a.RemoveReferenceFilter').on('click', function () {
            TargetNS.RemoveReferenceFilter($(this).attr('id'));
            return false;
        });

        Core.Agent.Admin.DynamicField.ValidationInit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldReference || {}));
