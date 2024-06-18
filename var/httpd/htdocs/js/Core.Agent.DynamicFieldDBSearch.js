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

/**
 * @namespace
 * @exports TargetNS as Core.Agent.DynamicFieldDBSearch
 * @description
 *      This namespace contains the special module functions for the dynamic field database search.
 */
Core.Agent.DynamicFieldDBSearch = (function(TargetNS) {

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @private
     * @param {Object} Data The data that should be converted
     * @return {string} query string of the data
     * @description Converts a given hash into a query string
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
        });
        return QueryString;
    }

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @private
     * @param {string} Field name of the DF
     * @param {string} TicketID
     * @description Open the detailed search screen
     */
    function OpenDetailedSearchDialog(Field, TicketID) {

        // declare variables
        var SearchIFrameURL,
            SearchIFrame,
            FrontendInterface;

        var ActivityDialogID = $('input[name="ActivityDialogEntityID"]', $('#' + Field).closest('form')).val();
        if ( typeof ActivityDialogID !== 'undefined' ) {
            ActivityDialogID = ActivityDialogID.substr('ActivityDialog-'.length);
        }
        else {
            ActivityDialogID = '';
        }

        // detect the frontend interface we currently use
        if (Core.Config.Get('CGIHandle').indexOf('customer') > -1) {
            FrontendInterface = 'CustomerDynamicFieldDBDetailedSearch';
            SearchIFrameURL = Core.Config.Get('CGIHandle') + '?Action=' + FrontendInterface + ';DynamicFieldName=' + Field + ';ActivityDialogID=' + ActivityDialogID;
            SearchIFrameURL += SerializeData(Core.App.GetSessionInformation());
            SearchIFrame = '<iframe width="700px" height="500px" class="TextOption Customer" src="' + SearchIFrameURL + '"></iframe>';
        }
        else {
            FrontendInterface = 'AgentDynamicFieldDBDetailedSearch';
            SearchIFrameURL = Core.Config.Get('CGIHandle') + '?Action=' + FrontendInterface + ';DynamicFieldName=' + Field + ';TicketID=' + TicketID;
            SearchIFrameURL += SerializeData(Core.App.GetSessionInformation());
            SearchIFrame = '<iframe class="TextOption Customer" src="' + SearchIFrameURL + '"></iframe>';
        }

        Core.UI.Dialog.ShowContentDialog(SearchIFrame, '', '10px', 'Center', true);
    }

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @private
     * @param {string} Field name of the DF
     * @param {string} IdentifierKey ID of the DF
     * @description Open the filter screen
     */
    function OpenDetailsDialog(Field, IdentifierKey) {

        // declare variables
        var SearchIFrameURL,
            SearchIFrame,
            FrontendInterface;

        var ActivityDialogID = $('input[name="ActivityDialogEntityID"]', $('#' + Field).closest('form')).val();
        if ( typeof ActivityDialogID !== 'undefined' ) {
            ActivityDialogID = ActivityDialogID.substr('ActivityDialog-'.length);
        }
        else {
            ActivityDialogID = '';
        }

        // detect the frontend interface we currently use
        if (Core.Config.Get('CGIHandle').indexOf('customer') > -1) {
            FrontendInterface = 'CustomerDynamicFieldDBDetails';
            SearchIFrameURL = Core.Config.Get('CGIHandle') + '?Action=' + FrontendInterface + ';DynamicFieldName=' + Field + ';ID=' + IdentifierKey + ';ActivityDialogID=' + ActivityDialogID;
            SearchIFrameURL += SerializeData(Core.App.GetSessionInformation());
            SearchIFrame = '<iframe width="700px" height="500px" class="TextOption Customer" src="' + SearchIFrameURL + '"></iframe>';
        }
        else {
            FrontendInterface = 'AgentDynamicFieldDBDetails';
            SearchIFrameURL = Core.Config.Get('CGIHandle') + '?Action=' + FrontendInterface + ';DynamicFieldName=' + Field + ';ID=' + IdentifierKey;
            SearchIFrameURL += SerializeData(Core.App.GetSessionInformation());
            SearchIFrame = '<iframe class="TextOption Customer" src="' + SearchIFrameURL + '"></iframe>';
        }

        Core.UI.Dialog.ShowContentDialog(SearchIFrame, '', '10px', 'Center', true);
    }

    /**
     * @name Init
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @function
     * @description This function initializes the special module functions
     */
    TargetNS.Init = function() {

        function InitDynamicFields($Context) {
            var ActiveAutoComplete = Core.Config.Get('ActiveAutoComplete');

            $('.DynamicFieldDB[type="text"]', $Context).each(function () {
                TargetNS.InitElement($(this).attr('id'), ActiveAutoComplete);
            });
        }

        InitDynamicFields();

        // Since new process screen loads activity via an AJAX call, we need to subscribe to an event
        //   in order to re-initalize dynamic fields. Please see bug#13146 for more information.
        Core.App.Subscribe('TicketProcess.Init.FirstActivityDialog.Load', function ($ActivityDialog) {
            InitDynamicFields($ActivityDialog);
        });

        // Load events when widget has expanded like e.g. in AdminGenericAgent screen (see bug#14590).
        $('.WidgetSimple.Collapsed .WidgetAction.Toggle').on('click', function () {
            InitDynamicFields(this);
        });

        // change the position of the label for DB fields
        if ( Core.Config.Get('SessionName') === Core.Config.Get('CustomerPanelSessionName') ) {
            $('fieldset > .Row').each( function() {
                var $DBField = $('.Field > input.DynamicFieldDB', $(this)).first();

                if ( $DBField.length ) {
                    // set the label in front of the results box
                    $('label', $(this)).insertBefore( $('.Field > .Field', $(this)) );
                }
            });
        }

    };

    /**
     * @name InitElement
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @function
     * @param {String} DynamicFieldName to be used
     * @param {Boolean} ActiveAutoComplete Set to false, if autocomplete should only be started by click on a button next to the input field
     * @description This function initialize dynamic field database search
     */
    TargetNS.InitElement = function(DynamicFieldName, ActiveAutoComplete) {
        var $Element,
            Value,
            FrontendInterface,
            TicketID,
            URL,
            Data,
            Label,
            Key,
            IdentifierKey,
            IdentifierValue,
            ObjectID,
            FieldValue,
            FieldIdentifiers,
            UpdateList,
            DynamicFields,
            IgnoreList,
            QueryString;

        if (ActiveAutoComplete == undefined || DynamicFieldName == undefined) {
            return;
        }

        // If we are in AdminGenericAgent screen and DynamicFieldName starts with 'Search_DynamicField_',
        // it shouldn't be initialized because it is located in 'Select Tickets' section (see bug#14590).
        if (/^Search_DynamicField_/.exec(DynamicFieldName) && /Action=AdminGenericAgent/.exec(document.URL)) {
            return;
        }

        $Element = $('#' + Core.App.EscapeSelector(DynamicFieldName))

        if ($Element.length == 0) {
            return;
        }

        if(isJQueryObject($Element)) {

            // check if there exists an ActivityDialogEntityID input element exists and derive ActivityDialogID
            var ActivityDialogID = $('input[name="ActivityDialogEntityID"]', $Element.closest('form')).val();
            if (typeof ActivityDialogID !== 'undefined') {
                ActivityDialogID = ActivityDialogID.substr('ActivityDialog-'.length);
            }
            else {
                ActivityDialogID = '';
            }

            // Get the ticket id.
            /TicketID=(\d+)/.exec(document.URL);
            TicketID = RegExp.$1;
            if (TicketID === null) {
                TicketID = '';
            }

            // clear the text field on blur to prevent missing error messages and misunderstandings
            $Element.blur(function() {
                $Element.val('');
            });

            // Register event for the detailed search dialog
            $('#DynamicFieldDBDetailedSearch_' + DynamicFieldName).on('click', function () {
                OpenDetailedSearchDialog($(this).attr('field'), TicketID);
                return false;
            });

            // Hide tooltip in autocomplete field, if user already typed something to prevent the autocomplete list
            // to be hidden under the tooltip. (Only needed for serverside errors)
            $Element.off('keyup.Validate').on('keyup.Validate', function() {
                Value = $Element.val();
                if($Element.hasClass('ServerError') && Value.length) {
                    $('#OTOBO_UI_Tooltips_ErrorTooltip').hide();
                }
            });

            // detect the frontend interface we currently use
            if (Core.Config.Get('CGIHandle').indexOf('customer') > -1) {
                FrontendInterface = 'CustomerDynamicFieldDBSearch';
            }
            else {
                FrontendInterface = 'AgentDynamicFieldDBSearch';
            }

            $Element.autocomplete({
                minLength: ActiveAutoComplete ? Core.Config.Get('Autocomplete.MinQueryLength') : 500,
                delay: Core.Config.Get('Autocomplete.QueryDelay'),
                source: function(Request, Response) {

                    // get ticket parameters
                    UpdateList = ['TypeID', 'Signature', 'NewUserID', 'NewResponsibleID', 'NextStateID', 'PriorityID', 'ServiceID', 'SLAID', 'SignKeyID', 'CryptKeyID', 'To', 'Cc', 'Bcc'];

                    // get dynamic fields names
                    if ($('#DynamicFieldNamesStrg').val()) {
                        DynamicFields = $('#DynamicFieldNamesStrg').val().split(",");
                    }

                    // put names into update list string
                    UpdateList = UpdateList.concat(DynamicFields);

                    // ignore Action and Subaction, request is not for the form's module
                    // also ignore the current dynamic field
                    IgnoreList = {
                        Action: 1,
                        Subaction: 1,
                        DynamicFieldDBSearch: 1
                    };

                    // get the ticket id
                    /TicketID=(\d+)/.exec(document.URL);
                    TicketID = RegExp.$1;

                    // serialize form
                    QueryString = Core.AJAX.SerializeForm($('#'+DynamicFieldName).closest('form'), IgnoreList) + SerializeData(UpdateList);

                    QueryString += ";Action="+FrontendInterface;
                    QueryString += ";Term="+encodeURIComponent(Request.term);
                    QueryString += ";MaxResults="+Core.Config.Get('Autocomplete.MaxResultsDisplayed');
                    QueryString += ";DynamicFieldName="+encodeURIComponent(DynamicFieldName);
                    QueryString += ";ActivityDialogID="+encodeURIComponent(ActivityDialogID);
                    QueryString += ";TicketID="+encodeURIComponent(TicketID);

                    URL = Core.Config.Get('Baselink');

                    // if an old ajax request is already running, stop the old request and start the new one
                    if($Element.data('AutoCompleteXHR')) {
                        $Element.data('AutoCompleteXHR').abort();
                        $Element.removeData('AutoCompleteXHR');
                        // run the response function to hide the request animation
                        Response({});
                    }

                    $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, QueryString, function(Result) {

                        Data = [];
                        $Element.removeData('AutoCompleteXHR');
                        $.each(Result, function() {

                            // prepare the results
                            Label = '';

                            $.each(this, function() {

                                // save the identifier as the key
                                if (this.Identifier) {
                                    Key = this.Identifier;

                                    // check if the identifier should be displayed as well
                                    if (this.Data) {
                                        Label += this.Data + ' - ';
                                    }
                                }
                                // save the normal columns
                                else {
                                    if (this.Data) {
                                        Label += this.Data + ' - ';
                                    }
                                }
                            });

                            // cut the last dash away
                            Label = Label.substring(0, Label.length - 2);

                            Data.push({
                                label: Label,
                                value: Label,
                                key: Key
                            });
                        });

                        Response(Data);
                    }));
                },
                select: function(Event, UI) {

                    IdentifierKey = UI.item.key;
                    IdentifierValue = UI.item.value;
                    ObjectID = $(this).attr('id');

                    Core.Agent.DynamicFieldDBSearch.AddResultElement(ObjectID, IdentifierValue, IdentifierKey);

                    Event.preventDefault();
                    return false;
                }
            });

            // check if we already have values and restore the selection
            FieldValue = $('#' + DynamicFieldName + 'Data').val();
            if (FieldValue) {

                FieldIdentifiers = FieldValue.split(',');

                // clear the value field
                $('#' + DynamicFieldName + 'Data').val('');

                $.each(FieldIdentifiers, function() {

                    // get the ticket id
                    /TicketID=(\d+)/.exec(document.URL);
                    TicketID = RegExp.$1;

                    URL = Core.Config.Get('Baselink');
                    Data = {
                        Action: FrontendInterface,
                        DynamicFieldName: DynamicFieldName,
                        ActivityDialogID: ActivityDialogID,
                        Search: DynamicFieldName + 'Restore' + this,
                        Identifier: this,
                        TicketID: TicketID
                    };

                    Core.AJAX.FunctionCall(URL, Data, function (Response) {

                        Data = [];

                        if (!Response) {
                            // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefor we handle the error manually.
                            Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No content from: " + URL, 'CommunicationError'));
                        }
                        else {

                            $.each(Response, function() {

                                // prepare the results
                                Label = '';

                                $.each(this, function() {

                                    // save the identifier as the key
                                    if (this.Identifier) {
                                        Key = this.Identifier;

                                        // check if the identifier should be displayed as well
                                        if (this.Data) {
                                            Label += this.Data + ' - ';
                                        }
                                    }
                                    // save the normal columns
                                    else {
                                        if (this.Data) {
                                            Label += this.Data + ' - ';
                                        }
                                    }
                                });

                                // cut the last dash away
                                Label = Label.substring(0, Label.length - 2);

                                // restore the selection
                                TargetNS.AddResultElement(DynamicFieldName, Label, Key);
                            });
                        }

                    }, 'json');
                });
            }
        }
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @param {String} Field The DynamicField field id.
     * @param {String} ElementValue The result element value.
     * @param {String} IdentifierKey The result element identifier key.
     * @param {Boolean} Focus The parameter for focus element.
     * @description This function add a result element entry
     * @returns {boolean}
     */
    TargetNS.AddResultElement = function (Field, ElementValue, IdentifierKey, Focus) {

        var IsDuplicated = false;

        if (ElementValue === '') {
            return false;
        }

        // check for duplicated entries
        $('#' + Field + 'Container [class*=ResultElementText]').each(function() {

            var ElementChunks = $(this).attr('id').split('_');

            if (ElementChunks[1] == IdentifierKey) {
                IsDuplicated = true;
            }
        });
        if (IsDuplicated) {
            TargetNS.ShowDuplicatedDialog(Field);
            return false;
        }

        // check if multiple entries are allowed
        TargetNS.CheckMultiselect(Field, ElementValue, IdentifierKey, Focus);

        return false;
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @param {String} Field The DynamicField field id.
     * @param {String} ElementValue The result element value.
     * @param {String} IdentifierKey The result element identifier key.
     * @param {String} SelectAllowed True if (multi)select is allowed.
     * @param {Boolean} Focus The parameter for focus element.
     * @description This function add a result element entry
     * @returns {boolean}
     */
    TargetNS.AddResultElementAction = function (Field, ElementValue, IdentifierKey, SelectAllowed, Focus) {

        // clone database result entry
        var $Clone = $('.ResultElementTemplate' + Field).clone(),
            Suffix,
            DataInputValue,
            ID;

        if (ElementValue === '') {
            return false;
        }

        // set sufix
        Suffix = '_' + IdentifierKey;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ResultElementTemplate' + Field);

        // copy values and change ids and names
        $Clone.find(':input').each(function(){
            ID = $(this).attr('id');
            $(this).data('identifier', IdentifierKey);

            $(this).attr('id', ID + Suffix);
            $(this).val(ElementValue);
        });

        // bind a click event on the details link
        $Clone.find('a').each(function(){


            // add event handler to remove button
            if($(this).hasClass('RemoveButton')) {

                // bind click function to remove button
                $(this).on('click', function () {

                    // remove row
                    TargetNS.RemoveResultElement($(this), Field);
                    return false;
                });
                // set button value
                $(this).val(ElementValue);
            }
            else {
                // Register event for the filter dialog
                $(this).on('click', function () {
                    OpenDetailsDialog($(this).attr('field'), IdentifierKey);
                    return false;
                });
            }

        });

        // show container
        $('#' + Field + 'Container').parent().removeClass('Hidden');
        // append to container
        $('#' + Field + 'Container').append($Clone);

        // update the value parameter of the hidden input field
        DataInputValue = $('#' + Field + 'Data').val();

        if (DataInputValue) {
            DataInputValue = DataInputValue + ',' + IdentifierKey;
            $('#' + Field + 'Data').val(DataInputValue);
        }
        else {
            $('#' + Field + 'Data').val(IdentifierKey);
        }

        // lock the text field and hide the detailed search dialog
        // if only single select is allowed
        if (!SelectAllowed) {
            $('#' + Field).attr('readonly', "readonly");
            $('#DynamicFieldDBDetailedSearch_' + Field).hide();
        }

        // remove the mandatory class from the original dynamic field input
        if ($('#' + Field).hasClass('Validate_Required')) {
            $('#' + Field).removeClass('Validate_Required');
        }

        // return value to search field
        if (Focus) {
            $('#' + Field).val('').focus();
        }
        else {
            $('#' + Field).val('');
        }

        return false;
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @param {string} Field ID object of the element should receive the focus on close event.
     * @param {String} ElementValue The result element value.
     * @param {String} IdentifierKey The ID of the DF
     * @param {Boolean} Focus The parameter for focus element.
     * @description This function shows an alert dialog for duplicated entries.
     */
    TargetNS.CheckMultiselect = function(Field, ElementValue, IdentifierKey, Focus){

        // declare variables
        var FrontendInterface,
            URL,
            Data;

        // detect the frontend interface we currently use
        if (Core.Config.Get('CGIHandle').indexOf('customer') > -1) {
            FrontendInterface = 'CustomerDynamicFieldDBSearch';
        }
        else {
            FrontendInterface = 'AgentDynamicFieldDBSearch';
        }

        var ActivityDialogID = $('input[name="ActivityDialogEntityID"]', $('#' + Field).closest('form')).val();
        if ( typeof ActivityDialogID !== 'undefined' ) {
            ActivityDialogID = ActivityDialogID.substr('ActivityDialog-'.length);
        }
        else {
            ActivityDialogID = '';
        }

        var FieldNameLong = Field;
        var IndexOfActivityDialogID = Field.indexOf('_' + ActivityDialogID);
        if ( ActivityDialogID != '' && IndexOfActivityDialogID > 0 ) {
            Field = Field.substr(0, IndexOfActivityDialogID);
        }

        URL = Core.Config.Get('Baselink');
        Data = {
            Action: FrontendInterface,
            Subaction: 'AJAXGetDynamicFieldConfig',
            DynamicFieldName: Field
        };

        Core.AJAX.FunctionCall(URL, Data, function (Response) {

            if (!Response) {
                // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefor we handle the error manually.
                Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No content from: " + URL, 'CommunicationError'));
            }
            else {
                TargetNS.AddResultElementAction(FieldNameLong, ElementValue, IdentifierKey, Response[0].Multiselect, Focus);
                return true;
            }

        }, 'json');
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @param {jQueryObject} Object used as base to delete it's parent.
     * @param {String} Field The DynamicField field id.
     * @description This function removes a result element entry
     */
    TargetNS.RemoveResultElement = function (Object, Field) {

        // declare variables
        var $Field = Object.closest('.Field'),
            RemoveValue,
            DataInputValue = $('#' + Field + 'Data').val(),
            DataInputValueChunks,
            DataInputValueNew = '';

        // get the identifier key which will be removed
        RemoveValue = Object.closest('div').find('input').data('identifier');

        DataInputValueChunks = DataInputValue.split(',');

        if (DataInputValueChunks.length === 1) {
            $('#' + Field + 'Data').val('');
        }
        else {
            $.each(DataInputValueChunks, function(Index, Value) {

                if (Value != RemoveValue) {
                    DataInputValueNew = DataInputValueNew + Value + ',';
                }
            });

            // cut the last comma away
            DataInputValueNew = DataInputValueNew.substring(0, DataInputValueNew.length - 1);

            // set the new value
            $('#' + Field + 'Data').val(DataInputValueNew);
        }

        // remove the parent element
        Object.parent().remove();

        // hide the container field, if there is no visible element left
        if ($Field.find('.ResultElementText:visible').length === 0) {
            $Field.addClass('Hidden');

            // open the autocompletion field again
            $('#' + Field).prop('readonly', false);

            // show the detailed search dialog again
            $('#DynamicFieldDBDetailedSearch_' + Field).show();

            // check if the dynamic field is mandatory and add the related class
            // again to the original field input
            if ($('#' + Field + 'Data').hasClass('Validate_Required')) {
                $('#' + Field).addClass('Validate_Required');
            }
        }
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @param {string} Field ID object of the element should receive the focus on close event.
     * @description This function shows an alert dialog for duplicated entries.
     */
    TargetNS.ShowDuplicatedDialog = function(Field){
        Core.UI.Dialog.ShowAlert(
            Core.Language.Translate('Duplicated entry'),
            Core.Language.Translate('This dynamic field database value is already selected.') + ' ' + Core.Language.Translate('It is going to be deleted from the field, please try again.'),
            function () {
                Core.UI.Dialog.CloseDialog($('.Alert'));
                $('#' + Field).val('');
                $('#' + Field).focus();
                return false;
            }
        );
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @description This function initializes the necessary stuff for the detailed search screen
     */
    TargetNS.InitDetailedSearch = function () {

        // declare variables
        var FieldName,
            FieldKey,
            FieldLabel;

        // hide the labels of already hidden fields
        $('label[class=Hidden]').hide();

        // Bind the event to add search attributes.
        $('#AddValue').off('click.AddValue').on('click.AddValue', function() {

            // Get field key and name by reg exp.
            /(\d+)_(.+)/.exec($('#SelectFieldList option:selected').val());
            FieldKey = RegExp.$1;
            FieldName = RegExp.$2;

            TargetNS.SearchAttributeAdd(FieldName, FieldKey);
        });

        // bind the event to add search attributes
        $('a[id^=RemoveValue_]').off('click.RemoveValue').on('click.RemoveValue', function() {

            // field reg exp
            /RemoveValue_(.+?)_(\d+)/.exec($(this).attr('id'));

            // get the field key and label
            FieldName = RegExp.$1;
            FieldKey = RegExp.$2;

            // Get label text and remove the last character ':'.
            FieldLabel = $('#Label_' + FieldName).text().trim().slice(0,-1);

            // Remove the search attribute and re-add it to the list.
            TargetNS.SearchAttributeRemove(FieldName, FieldKey, FieldLabel);
        });


        // restore the needed search attributes after the back button was used
        $('#SelectFieldList option').each(function(Key, Value) {

            if ($('#' + $(this).text()).val()) {

                // show the hidden search attribute
                $('#Label_' + $(this).text()).show();
                $('#Field_' + $(this).text()).show();

                // remove the search attribute from the list
                $("#SelectFieldList option[value='" + Value.value + "']").remove();
            }
        });
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @param {string} FieldName
     * @param {string} FieldKey
     * @description This function adds an attribute for the search.
     * @returns {boolean}
     */
    TargetNS.SearchAttributeAdd = function (FieldName, FieldKey) {

        if (!FieldName || !FieldKey) {
            return false;
        }

        $('#Label_' + FieldName).show();
        $('#Field_' + FieldName).show();

        // Remove added option from the list.
        if (FieldKey !== '') {
            $("#SelectFieldList option[value='" + FieldKey + "_" + FieldName + "']").remove();
        }

        return false;
    };

    /**
     * @function
     * @memberof Core.Agent.DynamicFieldDBSearch
     * @param {string} FieldName
     * @param {string} FieldKey
     * @param {string} FieldLabel
     * @description This function removes an attribute from the search.
     * @returns {boolean}
     */
    TargetNS.SearchAttributeRemove = function (FieldName, FieldKey, FieldLabel) {

        var Sorted;

        if (!FieldName || !FieldKey) {
            return false;
        }

        // clear the field
        $('#' + FieldName).val('');

        // hide the field and the related label
        $('#Label_' + FieldName).hide();
        $('#Field_' + FieldName).hide();

        // Append the removed attribute to the list.
        $("#SelectFieldList").append('<option value="' + FieldKey + '_' + FieldName + '">' + FieldLabel + '</option>');

        // Sort the attribute list alphabetically.
        Sorted = $.makeArray($("#SelectFieldList option")).sort(function(a, b) {
            return (($(a).text() > $(b).text()) ? 1 : -1);
        });
        $("#SelectFieldList").empty().append(Sorted).val('');

        return false;
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.DynamicFieldDBSearch || {}));
