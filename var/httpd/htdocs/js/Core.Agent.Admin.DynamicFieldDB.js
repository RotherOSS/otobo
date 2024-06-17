// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.DynamicFieldDB
 * @description
 *      This namespace contains the special module functions for the DynamicFieldDB module.
 */
Core.Agent.Admin.DynamicFieldDB = (function (TargetNS) {

    /**
     * @function
     * @param {string} IDSelector, id of the pressed remove value button.
     * @param {boolean} Remove
     * @description This function updates the identifier dropdown menu
     * @returns {boolean}
     */
    TargetNS.UpdateIdentifier = function (IDSelector, Remove){

        var IdentifierKey,
            IdentifierValue,
            ElementUpdated,
            sorted;

        // get the number of the selector id and
        // use it as the select key
        /.*?_(\d+)/.exec(IDSelector);
        IdentifierKey = RegExp.$1;

        // remove the related item if the complete line was removed
        if (Remove) {
            $("#Identifier option[value='" + IdentifierKey + "']").remove();
            TargetNS.UpdateIdentifier();
            return false;
        }

        // use the input value as the select value
        IdentifierValue = $('#' + IDSelector).val();

        if(IdentifierValue) {

            ElementUpdated = 0;

            // search for the select option and update the text
            $('#Identifier option').each(function(Key, Value) {
                if (Value.value === IdentifierKey) {
                    $(this).text(IdentifierValue);
                    ElementUpdated = 1;
                }
            });

            // obviously the entry is not present yet
            // add it to the dropdown menu
            if (!ElementUpdated) {
                $("<option/>").val(IdentifierKey).text(IdentifierValue).appendTo('#Identifier');
            }
        }
        else {
            $("#Identifier option[value='" + IdentifierKey + "']").remove();
        }

        // sort the identifier dropdown menu by text
        sorted = $.makeArray($("#Identifier option")).sort(function(a, b) {
            return (($(a).text() > $(b).text()) ? 1 : -1);
        });
        $("#Identifier").empty().append(sorted).trigger('redraw.InputField').trigger('change');

        return false;
    };

    /**
     * @function
     * @param {string} IDSelector, id of the pressed remove value button.
     * @returns {boolean}
     * @description This function removes a value from possible values list and creates a stub input so
     *              the server can identify if a value is empty or deleted (useful for server validation)
     *              It also deletes the Value from the DefaultValues list
     */
    TargetNS.RemoveValue = function (IDSelector){

        // copy HTML code for an input replacement for the deleted value
        var $Clone = $('.DeletedValue').clone(),

        // get the index of the value to delete (its always the second element (1) in this RegEx
        $ObjectIndex = IDSelector.match(/.+_(\d+)/)[1],

        // get the key name to remove it from the defaults select
        $Key = $('#Key_' + $ObjectIndex).val();

        // set the input replacement attributes to match the deleted original value
        // new value and other controls are not needed anymore
        $Clone.attr('id', 'Key' + '_' + $ObjectIndex);
        $Clone.attr('name', 'Key' + '_' + $ObjectIndex);
        $Clone.removeClass('DeletedValue');

        // add the input replacement to the mapping type so it can be parsed and distinguish from
        // empty values by the server
        //$('#'+ IDSelector).closest('fieldset').append($Clone);

        // remove the value from default list
        if ($Key !== ''){
            $('#DefaultValue').find("option[value='" + $Key + "']").remove();
        }

        // remove possible value
        $('#' + IDSelector).parent().remove();

        // remove the value in the identifier dropdown menu
        TargetNS.UpdateIdentifier(IDSelector, true);

        return false;
    };

    /**
     * @function
     * @param {Object} ValueInsert, HTML container of the value mapping row
     * @returns {boolean}
     * @description This function add a new value to the possible values list
     */
    TargetNS.AddValue = function (ValueInsert) {

        // clone key dialog
        var $Clone = $('.ValueTemplate').clone(),
            ValueCounter = $('#ValueCounter').val();

        // increment key counter
        ValueCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ValueTemplate');

        // add needed class
        $Clone.addClass('ValueRow Card');

        // copy values and change ids and names
        $Clone.find(':input, a').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + '_' + ValueCounter);
            $(this).attr('name', ID + '_' + ValueCounter);

            $(this).addClass('Validate_Required');

            // set error controls
            $(this).parent().find('#' + ID + 'Error').attr('id', ID + '_' + ValueCounter + 'Error');
            $(this).parent().find('#' + ID + 'Error').attr('name', ID + '_' + ValueCounter + 'Error');

            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + '_' + ValueCounter + 'ServerError');
            $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + '_' + ValueCounter + 'ServerError');

            // add event handler to remove button
            if($(this).hasClass('RemoveButton')) {

                // bind click function to remove button
                $(this).on('click', function () {
                    TargetNS.RemoveValue($(this).attr('id'));
                    return false;
                });
            }

            // add blur event handler to the name field
            // to update the identifier dropdown menu
            if ($(this).attr('id').match(/FieldName_/i)) {
                $(this).on('blur', function() {
                    TargetNS.UpdateIdentifier($(this).attr('id'));
                });
            }

            // remove class Validate_Required
            if ($(this).attr('id').match(/Searchfield_/i)) {
                $(this).removeClass('Validate_Required');
            }
            if ($(this).attr('id').match(/Listfield_/i)) {
                $(this).removeClass('Validate_Required');
            }
            if ($(this).attr('id').match(/FieldFilter_/i)) {
                $(this).removeClass('Validate_Required');
            }
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + ValueCounter);
        });

        // append to container
        ValueInsert.append($Clone);

        // set new value for KeyName
        $('#ValueCounter').val(ValueCounter);

        $('.DefaultValueKeyItem,.DefaultValueItem').on('keyup', function () {
            Core.Agent.Admin.DynamicFieldDB.RecreateDefaultValueList();
        });

        Core.UI.InputFields.Activate($Clone);

        return false;
    };

    /**
     * @function
     * @returns {boolean}
     * @description     This function re-creates and sort the Default Values list taking the Possible Values
     *                  as source, all deleted values will not be part of the re-created value list
     */
    TargetNS.RecreateDefaultValueList = function() {

        // get the selected default value
        var SelectedValue = $("#DefaultValue option:selected").val(),

        // define other variables
        ValueIndex, Key, Value, KeyID, SelectOptions;

        // delete all elements
        $('#DefaultValue').empty();

        // add the default "possible none" element
        $('#DefaultValue').append($('<option>', { value: '' }).text('-'));

        // find all active possible values keys (this will omit all previously deleted keys)
        $('.ValueRow > .DefaultValueKeyItem').each(function(){

            // for each key:
            // Get the ID
            KeyID = $(this).attr('id');

            // extract the index
            ValueIndex = KeyID.match(/.+_(\d+)/)[1];

            // get the Key and Value
            Key = $(this).val();
            Value = $('#Value_' + ValueIndex).val();

            // check if both are none empty and add them to the default values list
            if (Key !== '' && Value !== '') {
                $('#DefaultValue').append($('<option>', { value: Key }).text(Value));

            }
        });

        // extract the new value list into an array
        SelectOptions = $("#DefaultValue option");

        // sort the array by the text (this means the Value)
        SelectOptions.sort(function(a, b) {
            if (a.text > b.text) {
                return 1;
            }
            else if (a.text < b.text) {
                return -1;
            }
            else {
                return 0;
            }
        });

        // clear the list again and re-populate it with the sorted list
        $("#DefaultValue").empty().append(SelectOptions);

        // set the selected value as it was before, this will not apply if the key name was
        // changed
        $('#DefaultValue').val(SelectedValue);

        return false;
    };

    /**
     * @name Init
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {

        // Bind click function to add button.
        $('#AddValue').on('click', function () {
            TargetNS.AddValue(
                $(this).closest('fieldset').find('.ValueInsert')
            );
            return false;
        });

        // Bind click function to remove button.
        $('.ValueRemove').on('click', function () {
            TargetNS.RemoveValue($(this).attr('id'));
            return false;
        });

        // Check if SID is needed.
        if ($('#Type').val() === 'oracle') {
            $('#SIDLabel').fadeIn();
            $('#SIDField').fadeIn();
        }
        else {
            $('#SIDLabel').fadeOut();
            $('#SIDField').fadeOut();
        }

        $('#Type').on('change', function() {

            if ($('#Type').val() === 'oracle') {
                $('#SIDLabel').fadeIn();
                $('#SIDField').fadeIn();
            }
            else {
                $('#SIDLabel').fadeOut();
                $('#SIDField').fadeOut();
            }
        });

        // Check if the driver field is needed.
        if ($('#Type').val() === 'ODBC') {
            $('#DriverLabel').fadeIn();
            $('#DriverField').fadeIn();
        }
        else {
            $('#DriverLabel').fadeOut();
            $('#DriverField').fadeOut();
        }

        $('#Type').on('change', function() {

            if ($('#Type').val() === 'ODBC') {
                $('#DriverLabel').fadeIn();
                $('#DriverField').fadeIn();
            }
            else {
                $('#DriverLabel').fadeOut();
                $('#DriverField').fadeOut();
            }
        });

        $('input[id*=FieldName_]').each(function() {
            $(this).blur(function() {
                TargetNS.UpdateIdentifier($(this).attr('id'));
            });
        });

        Core.UI.InputFields.Activate();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldDB || {}));
