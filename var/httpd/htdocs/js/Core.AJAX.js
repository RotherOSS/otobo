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

/**
 * @namespace Core.AJAX
 * @memberof Core
 * @author OTRS AG
 * @description
 *      This namespace contains the functionality for AJAX calls.
 */
Core.AJAX = (function (TargetNS) {
    /**
     * @private
     * @name AJAXLoaderPrefix
     * @memberof Core.AJAX
     * @member {String}
     * @description
     *      AJAXLoaderPrefix
     */
    var AJAXLoaderPrefix = 'AJAXLoader',
    /**
     * @private
     * @name ActiveAJAXCalls
     * @memberof Core.AJAX
     * @member {Object}
     * @description
     *      ActiveAJAXCalls
     */
        ActiveAJAXCalls = {};

    if (!Core.Debug.CheckDependency('Core.AJAX', 'Core.Exception', 'Core.Exception')) {
        return;
    }

    if (!Core.Debug.CheckDependency('Core.AJAX', 'Core.App', 'Core.App')) {
        return;
    }

    /**
     * @private
     * @name HandleAJAXError
     * @memberof Core.AJAX
     * @function
     * @param {Object} XHRObject - Meta data returned by the ajax request
     * @param {String} Status - Status information of the ajax request
     * @param {String} Error - Error information of the ajax request
     * @description
     *      Handles failing ajax request (only used as error callback in $.ajax calls)
     */
    function HandleAJAXError(XHRObject, Status, Error) {
        var ErrorMessage = Core.Language.Translate('Error during AJAX communication. Status: %s, Error: %s', Status, Error);

        // Check for expired sessions.
        if (RedirectAfterSessionTimeOut(XHRObject)) {
            return;
        }

        // Ignore aborted AJAX calls.
        if (Status === 'abort') {
            return;
        }

        // Collect debug information if configured.
        if (Core.Config.Get('AjaxDebug') && typeof XHRObject === 'object') {
            ErrorMessage += "\n\nResponse status: " + XHRObject.status + " (" + XHRObject.statusText + ")\n";
            ErrorMessage += "Response headers: " + XHRObject.getAllResponseHeaders() + "\n";
            ErrorMessage += "Response content: " + XHRObject.responseText;
        }

        if (!XHRObject.status) {

            // If we didn't receive a status, the request didn't get any result, which is most likely a connection issue.
            Core.Exception.HandleFinalError(new Core.Exception.ApplicationError(ErrorMessage, 'ConnectionError'));
            return;
        }

        // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefore we handle the error manually.
        Core.Exception.HandleFinalError(new Core.Exception.ApplicationError(ErrorMessage, 'CommunicationError'));
    }

    /**
     * @private
     * @name ToggleAJAXLoader
     * @memberof Core.AJAX
     * @function
     * @param {String} FieldID - Id of the field which is updated via ajax
     * @param {Boolean} Show - Show or hide the AJAX loader image
     * @description
     *      Shows and hides an ajax loader for every element which is updates via ajax.
     */
    function ToggleAJAXLoader(FieldID, Show) {
        var $Element = $('#' + FieldID),
            $Loader = $('#' + AJAXLoaderPrefix + FieldID),
            LoaderHTML = '<span id="' + AJAXLoaderPrefix + FieldID + '" class="AJAXLoader"></span>',
            $MultivalueButtons = $Element.parent().siblings('.AddRemoveValueRow');

        // Ignore hidden fields, except for database and autocomplete
        if (
            $Element.is('[type=hidden]')
            && !$Element.hasClass('DynamicFieldDB')
            && !$Element.parent().find('.ui-autocomplete-input').length
        ) {
            return;
        }
        // Element not present, reset counter and ignore
        if (!$Element.length) {
                ActiveAJAXCalls[FieldID] = 0;
                return;
        }

        // Init counter value, if needed.
        // This counter stores the number of running AJAX requests for each field.
        // The loader image will be shown if it is > 0.
        if (typeof ActiveAJAXCalls[FieldID] === 'undefined') {
            ActiveAJAXCalls[FieldID] = 0;
        }

        // Calculate counter
        if (Show) {
            ActiveAJAXCalls[FieldID]++;
        }
        else {
            ActiveAJAXCalls[FieldID]--;
            if (ActiveAJAXCalls[FieldID] <= 0) {
                ActiveAJAXCalls[FieldID] = 0;
            }
        }

        // Show or hide the loader
        if (ActiveAJAXCalls[FieldID] > 0) {
            if (!$Loader.length) {
                $Element.after(LoaderHTML);
            }
            else {
                $Loader.show();
            }
            if ($MultivalueButtons.length) {
                $MultivalueButtons.hide();
            }
        }
        else {
            $Loader.hide();
            if ($MultivalueButtons.length) {
                $MultivalueButtons.show();
            }
        }
    }

    /**
     * @private
     * @name SerializeData
     * @memberof Core.AJAX
     * @function
     * @returns {String} Query string of the data.
     * @param {Object} Data - The data that should be converted
     * @description
     *      Converts a given hash into a query string.
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
        });
        return QueryString;
    }

    /**
     * @private
     * @name GetSessionInformation
     * @memberof Core.AJAX
     * @function
     * @returns {Object} Hash with session data, if needed.
     * @description
     *      Collects session data in a hash if available.
     */
    function GetSessionInformation() {
        var Data = {};
        if (!Core.Config.Get('SessionIDCookie')) {
            Data[Core.Config.Get('SessionName')] = Core.Config.Get('SessionID');
            Data[Core.Config.Get('CustomerPanelSessionName')] = Core.Config.Get('SessionID');
        }
        Data.ChallengeToken = Core.Config.Get('ChallengeToken');
        return Data;
    }

    /**
     * @private
     * @name GetAdditionalDefaultData
     * @memberof Core.AJAX
     * @function
     * @returns {Object} Hash with additional session and action data.
     * @description
     *      Collects additional data that are needed for the ajax requests.
     */
    function GetAdditionalDefaultData() {
        var Data = {};
        Data = GetSessionInformation();
        Data.Action = Core.Config.Get('Action');
        return Data;
    }

    /**
     * @private
     * @name UpdateTicketAttachments
     * @memberof Core.AJAX
     * @function
     * @param {Object} Attachments - Array of hashes, each hash have the needed attachment information.
     * @description
     *      Removes all selected attachments and adds the ones passed in the Attachments object.
     */
    function UpdateTicketAttachments(Attachments) {

        var Customer = /^Customer/.test( Core.Config.Get('Action') );
        var AttachmentTemplate = ( Customer ? 'AjaxDnDUpload/AttachmentItemCustomer' : 'AjaxDnDUpload/AttachmentItem' );

        // delete existing attachments
        $('.AttachmentList tbody').empty();

        // go through all attachments and append them to the attachment table
        $(Attachments).each(function() {

            var AttachmentItem = Core.Template.Render( AttachmentTemplate, {
                'Filename' : this.Filename,
                'Filetype' : this.ContentType,
                'Filesize' : this.Filesize,
                'FileID'   : this.FileID,
            });

            $(AttachmentItem).prependTo($('.AttachmentList tbody')).fadeIn();
        });

        // make sure to display the attachment table only if any attachments
        // are actually in it.
        if ($('.AttachmentList tbody tr').length) {
            $('.AttachmentList').show();
        }
        else {
            $('.AttachmentList').hide();
        }
    }

    /**
     * @private
     * @name UpdateTextarea
     * @memberof Core.AJAX
     * @function
     * @param {Object} $Element - the field selector.
     * @param {Object} Value - the field value. The keys are the IDs of the fields to be updated.
     * @description
     *      Inserts value in textarea components or RichText editors for the ajax requests.
     */
    function UpdateTextarea($Element, Value) {
        var $ParentBody,
            ParentBody,
            Range,
            StartRange = 0,
            NewPosition = 0,
            CKEditorObj;

        if ($Element.length) {
            $ParentBody = $Element;
            ParentBody = $ParentBody[0];

            // for regular popups, parent is a reference to the popup itself, which is why parent.CKEDITOR is a reference to the CKEDITOR
            // object of the popup window. But if we're on a mobile environment, the popup would instead open as an iframe, which would cause
            // parent.CKEDITOR to be the CKEDITOR object of the parent window which contains the iframe. This is why we want to use only
            // CKEDITOR in this case (see bug#12680).
            if (Core.App.Responsive.IsSmallerOrEqual(Core.App.Responsive.GetScreenSize(), 'ScreenL') && (!localStorage.getItem("DesktopMode") || parseInt(localStorage.getItem("DesktopMode"), 10) <= 0)) {
                CKEditorObj = window.editor;
            }

            // add the text to the RichText editor
            if (CKEditorInstances && CKEditorInstances['RichText']) {
                CKEditorObj = CKEditorInstances['RichText'];

                // TODO: probably reintroduce 75c5b5bfe3673279c03dba2f57350e6c79e7ae84
                CKEditorObj.editing.view.focus();
                window.setTimeout(function () {

                    // In some circumstances, this command throws an error (although inserting the HTML works)
                    // Because the intended functionality also works, we just wrap it in a try-catch-statement
                    try {
                        // set new text
                        CKEditorObj.setData(Value);
                    }
                    catch (Error) {
                        $.noop();
                    }
                }, 100);
                return;
            }

            // insert body and/or link to textarea (if possible to cursor position otherwise to the top)
            else {

                // Get previously saved cursor position of textarea
                if ($Element.parent().data('Cursor')) {
                    StartRange = parent.$Element.data('Cursor').StartRange;
                }

                // Add new text to textarea
                $ParentBody.val(Value);
                NewPosition = StartRange + Value.length;

                // Jump to new cursor position (after inserted text)
                if (ParentBody.selectionStart) {
                    ParentBody.selectionStart = NewPosition;
                    ParentBody.selectionEnd = NewPosition;
                }
                else if (document.selection) {
                    Range = document.selection.createRange().duplicate();
                    Range.moveStart('character', NewPosition);
                    Range.select();
                }

                return;
            }
        }
        else {
            alert(Core.Language.Translate('This window must be called from compose window.'));
            return;
        }
    }

    /**
     * @private
     * @name UpdateFormElements
     * @memberof Core.AJAX
     * @function
     * @param {Object} Data - The new field data. The keys are the IDs of the fields to be updated.
     * @description
     *      Updates the given fields with the given data.
     */
    function UpdateFormElements(Data) {
        if (typeof Data !== 'object') {
            return;
        }

        $.each(Data, function (DataKey, DataValue) {

            // hide and show fields
            if (DataKey === 'Restrictions_Visibility') {
                HideShowFields(DataValue);
                return;
            }

            if (DataKey === 'Restrictions_Visibility_Std') {
                HideShowFieldsStd(DataValue);
                return;
            }

            // special case to update ticket attachments
            if (DataKey === 'TicketAttachments') {
                UpdateTicketAttachments(DataValue);
                return;
            }

            var $Element = $('#' + DataKey);

            if ((!$Element.length || typeof DataValue == 'undefined') && !$Element.is('textarea')) {

                // catch multivalue case where DataKey is present in attribute name
                $Element = $('[name=' + DataKey + ']');

                // date time elements
                if ( !$Element.length ) {
                    $Element = $('[name=' + DataKey +  'Year]').parent();
                }

                if ((!$Element.length || typeof DataValue == 'undefined')) {
                    return;
                }
            }

            // Select elements
            if ($Element.is('select')) {
                $Element.empty();
                $.each(DataValue, function (Index, Value) {
                    var NewOption,
                        OptionText = Core.App.EscapeHTML(Value[1]);

                    NewOption = new Option(OptionText, Value[0], Value[2], Value[3]);

                    // Check if option must be disabled.
                    if (Value[4]) {
                        NewOption.disabled = true;
                    }

                    // Overwrite option text, because of wrong html quoting of text content.
                    // (This is needed for IE.)
                    NewOption.innerHTML = OptionText;
                    $Element.append(NewOption);

                });

                // Trigger custom redraw event for InputFields
                if ($Element.hasClass('Modernize')) {
                    $Element.trigger('redraw.InputField');
                }

                return;
            }

            // text area elements like the ticket body
            if ( $Element.is('textarea') && !$Element.hasClass('DynamicFieldTextArea') ) {
                UpdateTextarea($Element, DataValue);
                return;
            }

            // check box elements
            if ( $Element.is(':checkbox') && $Element.val() == 1 ) {
                $Element.prop('checked', (DataValue == 1 ? true : false));
                return;
            }

            // date time
            if ( $Element.hasClass('DynamicFieldDate') ) {
                Core.UI.InputFields.SetDate($Element, DataValue);
                return;
            }

            // reference fields
            // both hidden and visible input element need to be set
            var $ReferenceElement = $Element.parent().find('.DynamicFieldReference');
            if ( $ReferenceElement.length ) {
                $Element.val( typeof DataValue == 'object' ? DataValue[0][0] : '');
                $ReferenceElement.val( typeof DataValue == 'object' ? DataValue[0][1] : '' );
                return;
            }

            // Other form elements
            $Element.val(DataValue);

            // Trigger custom redraw event for InputFields
            if ($Element.hasClass('Modernize')) {
                $Element.trigger('redraw.InputField');
            }
        });
    }

    /**
     * @private
     * @name HideShowFields
     * @memberof Core.AJAX
     * @function
     * @param {Object} Data - The field data. The keys are the IDs of the fields to be updated.
     * @description
     *      Toggles visibility of fields
     */
    function HideShowFields(Visibility) {
        for ( var i = 0; i < Visibility.length; i++ ) {
            var FieldInfo = Visibility[i],
                Field = $( '#' + FieldInfo[0] );

            if ( Field.length == 0 ) {
                // DateTime
                if ( $( '#' + FieldInfo[0] + 'Used' ).length > 0 ) {
                    Field = $( '#' + FieldInfo[0] + 'Used' );
                }
                else if ( $( '#' + FieldInfo[0] + '_0' ).length > 0 ) {
                    Field = $( '#' + FieldInfo[0] + '_0' );
                }
                else if ( $( '#' + FieldInfo[0] + 'Used_0' ).length ) {
                    Field = $( '#' + FieldInfo[0] + 'Used_0' );
                }
                else {
                    continue;
                }
            }

            var $FieldRow        = Field.closest('.Row'),
                $FieldCell       = Field.closest('.FieldCell'),
                MultiValueFields = [],
                MultiColumnIndex;

            if ( $FieldRow.hasClass('MultiValue') ) {
                if ( $FieldRow.hasClass('MultiColumn') ) {
                    $('.MultiValue_0', $FieldRow).each( function ( Index ) {
                        if ( $(this).is( $FieldCell ) ) {
                            MultiColumnIndex = Index;
                        }
                    });

                    var ValueRowIndex = 1,
                        ValueRow      = $( '.MultiValue_' + ValueRowIndex, $FieldRow );

                    while ( ValueRow.length ) {
                        MultiValueFields.push( ValueRow[ MultiColumnIndex ] );
                        ValueRowIndex++;
                        ValueRow = $( '.MultiValue_' + ValueRowIndex, $FieldRow );
                    }
                }
                else {
                    MultiValueFields = $( '.FieldCell:not(.MultiValue_0)', $FieldRow ).toArray();
                }
            }

            // field has to be hidden
            if ( FieldInfo[1] == 0 ) {
                $FieldCell.addClass("oooACLHidden");
                if ( $FieldRow.hasClass('MultiValue') ) {
                    MultiValueFields.forEach( function( Cell ) {
                        $(Cell).addClass("oooACLHidden");
                    });
                    if ( $FieldRow.hasClass('MultiColumn') ) {
                        Core.UI.InputFields.HideMultiAddRemoveButtons( $FieldRow );
                    }
                }
                if ( !$FieldRow.hasClass('MultiColumn') || $FieldRow.children('.FieldCell:visible').length == 0 ) {
                    $FieldRow.addClass('oooACLHidden');
                    if ( $FieldRow.hasClass('MultiValue') ) {
                        // delete only sibling elements of first multivalues
                        $( '.FieldCell[class^=MultiValue]:not(.MultiValue_0)', $FieldRow ).remove();
                    }
                }

                // hidden fields cannot be mandatory
                if ( Field.hasClass("Validate_Required") ) {
                    Field.removeClass("Validate_Required");
                    Field.addClass("Validate_Required_IfVisible");

                    // handling of database dynamic fields
                    var FieldData = $( '#' + FieldInfo[0] + 'Data' );
                    if( FieldData.length > 0 && FieldData.hasClass("Validate_Required") ) {
                        FieldData.removeClass("Validate_Required");
                        FieldData.addClass("Validate_Required_IfVisible");
                    }
                }
                else if ( Field.hasClass("Validate_DnDUpload") ) {
                    Field.removeClass("Validate_DnDUpload");
                    Field.addClass("Validate_DnDUpload_IfVisible");

                    // handling of database dynamic fields
                    var FieldData = $( '#' + FieldInfo[0] + 'Data' );
                    if( FieldData.length > 0 && FieldData.hasClass("Validate_DnDUpload") ) {
                        FieldData.removeClass("Validate_DnDUpload");
                        FieldData.addClass("Validate_DnDUpload_IfVisible");
                    }
                }
                else if ( Field.hasClass("Validate_DependingRequiredAND") ) {
                    Field.removeClass("Validate_DependingRequiredAND");
                    Field.addClass("Validate_DependingRequired_IfVisibleAND");
                }
                else if ( Field.hasClass("Validate_DependingRequiredOR") ) {
                    Field.removeClass("Validate_DependingRequiredOR");
                    Field.addClass("Validate_DependingRequired_IfVisibleOR");
                }
            }
            // field has to be shown again
            else if ( $FieldCell.hasClass("oooACLHidden") ) {
                $FieldCell.removeClass('oooACLHidden');
                $FieldRow.removeClass("oooACLHidden");
                if ( $FieldRow.hasClass('MultiValue') ) {
                    MultiValueFields.forEach( function( Cell ) {
                        $(Cell).removeClass("oooACLHidden");
                    });
                }

                // restore validation on mandatory fields
                if ( Field.hasClass("Validate_Required_IfVisible") ) {
                    Field.removeClass("Validate_Required_IfVisible");
                    Field.addClass("Validate_Required");

                    // handling database dynamic fields
                    var FieldData = $( '#' + FieldInfo[0] + 'Data' );
                    if( FieldData.length > 0 && FieldData.hasClass("Validate_Required_IfVisible") ) {
                        FieldData.removeClass("Validate_Required_IfVisible");
                        FieldData.addClass("Validate_Required");
                    }
                }
                else if ( Field.hasClass("Validate_DnDUpload_IfVisible") ) {
                    Field.removeClass("Validate_DnDUpload_IfVisible");
                    Field.addClass("Validate_DnDUpload");

                    // handling database dynamic fields
                    var FieldData = $( '#' + FieldInfo[0] + 'Data' );
                    if( FieldData.length > 0 && FieldData.hasClass("Validate_DnDUpload_IfVisible") ) {
                        FieldData.removeClass("Validate_DnDUpload_IfVisible");
                        FieldData.addClass("Validate_DnDUpload");
                    }
                }
                else if ( Field.hasClass("Validate_DependingRequired_IfVisibleAND") ) {
                    Field.removeClass("Validate_DependingRequired_IfVisibleAND");
                    Field.addClass("Validate_DependingRequiredAND");
                }
                else if ( Field.hasClass("Validate_DependingRequired_IfVisibleOR") ) {
                    Field.removeClass("Validate_DependingRequired_IfVisibleOR");
                    Field.addClass("Validate_DependingRequiredOR");
                }

                // init modernization on select fields hidden initially
                Core.UI.InputFields.InitSelect( $('select.Modernize'), $FieldCell );

                // trigger custom redraw event for InputFields, as it is not executed for hidden fields, when they are emptied
                if ( Field.hasClass('Modernize')) {
                    Field.trigger('redraw.InputField');
                }

                if ( $FieldRow.hasClass('MultiValue') ) {
                    Core.UI.InputFields.InitSelect( $('select[name=' + FieldInfo[0] + ']') );
                    MultiValueFields.forEach( function( $Cell ) {
                        if ( Field.hasClass('Modernize')) {
                            $('[name=' + FieldInfo[0] + ']').trigger('redraw.InputField');
                        }
                    });
                }
            }
        }
    }

    /**
     * @private
     * @name HideShowFieldsStd
     * @memberof Core.AJAX
     * @function
     * @param {Object} Data - The field data. Currently only can include Article.
     * @description
     *      Toggles visibility of Standardfields
     */
    function HideShowFieldsStd(Visibility) {
        for ( var i = 0; i < Visibility.length; i++ ) {
            var FieldInfo = Visibility[i];

            if ( FieldInfo[1] == 0 ) {
                if (FieldInfo[0] === 'Article') {
                    $('#Subject').parent('div.Row').addClass("oooACLHidden");
                    if ( $('#Subject').hasClass("Validate_Required") ) {
                        $('#Subject').removeClass("Validate_Required");
                        $('#Subject').addClass("Validate_Required_IfVisible");
                    }
                    $('#RichText').parent('div.RichTextHolder').addClass("oooACLHidden");
                    if ( $('#RichText').hasClass("Validate_Required") ) {
                        $('#RichText').removeClass("Validate_Required");
                        $('#RichText').addClass("Validate_Required_IfVisible");
                    }
                    $('#oooAttachments').parent('div.Row').addClass("oooACLHidden");
                }
            }

            else {
                if (FieldInfo[0] === 'Article') {
                    $('#Subject').parent('div.Row').removeClass("oooACLHidden");
                    if ( $('#Subject').hasClass("Validate_Required_IfVisible") ) {
                        $('#Subject').removeClass("Validate_Required_IfVisible");
                        $('#Subject').addClass("Validate_Required");
                    }
                    $('#RichText').parent('div.RichTextHolder').removeClass("oooACLHidden");
                    if ( $('#RichText').hasClass("Validate_Required_IfVisible") ) {
                        $('#RichText').removeClass("Validate_Required_IfVisible");
                        $('#RichText').addClass("Validate_Required");
                    }
                    $('#oooAttachments').parent('div.Row').removeClass("oooACLHidden");
                }
            }
        }
    }

    /**
     * @private
     * @name RedirectAfterSessionTimeOut
     * @memberof Core.AJAX
     * @function
     * @returns {Boolean} Returns false, if Redirect is not necessary.
     * @param {Object} XHRObject - The original AJAX object.
     * @description
     *      Checks if session is timed out and redirects to the login to avoid
     *      ajax errors.
     */
    function RedirectAfterSessionTimeOut(XHRObject) {
        var Headers = XHRObject.getAllResponseHeaders(),
            OldUrl = location.href,
            NewUrl = Core.Config.Get('Baselink') + "RequestedURL=" + encodeURIComponent(OldUrl);

        if (Headers.match(/X-OTOBO-Login: /i)) {
            location.href = NewUrl;
            return true;
        }

        return false;
    }

    /**
     * @name SerializeForm
     * @memberof Core.AJAX
     * @function
     * @returns {String} The query string.
     * @param {jQueryObject} $Element - The jQuery object of the form  or any element within this form that should be serialized
     * @param {Object} [Ignore] - Elements (Keys) which should not be included in the serialized form string (optional)
     * @description
     *      Serializes the form data into a query string.
     */
    TargetNS.SerializeForm = function ($Element, Ignore) {
        var QueryString = "";
        if (typeof Ignore === 'undefined') {
            Ignore = {};
        }
        if (isJQueryObject($Element) && $Element.length) {
            $Element.closest('form').find('input:not(:file), textarea, select').each(function () {
                var Name = $(this).attr('name') || '';

                // only look at fields with name
                // only add element to the string, if there is no key in the data hash with the same name
                if (!Name.length || typeof Ignore[Name] !== 'undefined'){
                    return;
                }

                // TODO MultiValue Think about a solution to transfer unchecked value
                if ($(this).is(':checkbox, :radio')) {
                    if ($(this).is(':checked')) {
                        QueryString += encodeURIComponent(Name) + '=' + encodeURIComponent($(this).val() || 'on') + ";";
                    }
                }
                else if ($(this).is('select')) {
                    $.each($(this).find('option:selected'), function(){
                        QueryString += encodeURIComponent(Name) + '=' + encodeURIComponent($(this).val() || '') + ";";
                    });
                }
                else {
                    QueryString += encodeURIComponent(Name) + '=' + encodeURIComponent($(this).val() || '') + ";";
                }
            });
        }
        return QueryString;
    };

    /**
     * @name FormUpdate
     * @memberof Core.AJAX
     * @function
     * @returns {Object} The jqXHR object.
     * @param {jQueryObject} $EventElement - The jQuery object of the element(s) which are included in the form that should be submitted.
     * @param {String} Subaction - The subaction parameter for the perl module.
     * @param {String} ChangedElement - The name of the element which was changed by the user.
     * @param {Function} [SuccessCallback] - Callback function to be executed on AJAX success (optional).
     * @description
     *      Submits a special form via ajax and updates the form with the data returned from the server
     */
    TargetNS.FormUpdate = function ($EventElement, Subaction, ChangedElement, SuccessCallback) {
        var URL = Core.Config.Get('Baselink'),
            Data = GetAdditionalDefaultData(),
            QueryString;

        $EventElement.find('input[name="AJAXAction"]').each(function () {
            Data.Action = $(this).val();
        });

        var ChangedElementWithIndex = ChangedElement;
        if ( $('[name=' + ChangedElement + ']', '.DFSetOuterField').length ) {
            var DFRegex = RegExp('^DynamicField_[^_]+');
            ChangedElement = DFRegex.exec(ChangedElement)[0];
        }

        Data.Subaction = Subaction;
        Data.ElementChanged = ChangedElement;
        QueryString = TargetNS.SerializeForm($EventElement, Data) + SerializeData(Data);

        var $ChangedElement = $('[name="' + ChangedElementWithIndex + '"]');
        ToggleAJAXLoader($ChangedElement.attr('id'), true);

        return $.ajax({
            type: 'POST',
            url: URL,
            data: QueryString,
            dataType: 'json',
            success: function (Response, Status, XHRObject) {
                Core.App.Publish('Core.App.AjaxErrorResolved');

                if (RedirectAfterSessionTimeOut(XHRObject)) {
                    return false;
                }

                if (!Response) {
                    // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefore we handle the error manually.
                    Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("Invalid JSON from: " + URL, 'CommunicationError'));
                }
                else {
                    UpdateFormElements(Response);
                    if (typeof SuccessCallback === 'function') {
                        SuccessCallback();
                    }
                    Core.App.Publish('Event.AJAX.FormUpdate.Callback', [Response]);
                }
            },
            complete: function () {
                var $ChangedElement = $('[name="' + ChangedElementWithIndex + '"]');
                ToggleAJAXLoader($ChangedElement.attr('id'), false);
            },
            error: function(XHRObject, Status, Error) {
                HandleAJAXError(XHRObject, Status, Error)
            }
        });
    };

    /**
     * @name ContentUpdate
     * @memberof Core.AJAX
     * @function
     * @returns {Object} The jqXHR object.
     * @param {jQueryObject} $ElementToUpdate - The jQuery object of the element(s) which should be updated
     * @param {String} URL - The URL which is called via Ajax
     * @param {Function} Callback - The additional callback function which is called after the request returned from the server
     * @description
     *      Calls an URL via Ajax and updates a html element with the answer html of the server.
     */
    TargetNS.ContentUpdate = function ($ElementToUpdate, URL, Callback) {
        var QueryString, QueryIndex = URL.indexOf("?"), GlobalResponse;

        if (QueryIndex >= 0) {
            QueryString = URL.substr(QueryIndex + 1);
            URL = URL.substr(0, QueryIndex);
        }
        QueryString += SerializeData(GetSessionInformation());

        return $.ajax({
            type: 'POST',
            url: URL,
            data: QueryString,
            dataType: 'html',
            success: function (Response, Status, XHRObject) {

                Core.App.Publish('Core.App.AjaxErrorResolved');

                if (RedirectAfterSessionTimeOut(XHRObject)) {
                    return false;
                }

                if (!Response) {
                    // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefore we handle the error manually.
                    Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No content from: " + URL, 'CommunicationError'));
                }
                else if ($ElementToUpdate && isJQueryObject($ElementToUpdate) && $ElementToUpdate.length) {
                    GlobalResponse = Response;
                    $ElementToUpdate.html(Response);
                }
                else {
                    // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefore we handle the error manually.
                    Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No such element id: " + $ElementToUpdate.attr('id') + " in page!", 'CommunicationError'));
                }
            },
            complete: function () {
                if ($.isFunction(Callback)) {
                    Callback();
                }
                Core.App.Publish('Event.AJAX.ContentUpdate.Callback', [GlobalResponse]);
            },
            error: function(XHRObject, Status, Error) {
                HandleAJAXError(XHRObject, Status, Error)
            }
        });
    };

    /**
     * @name FunctionCall
     * @memberof Core.AJAX
     * @function
     * @returns {Object} The jqXHR object.
     * @param {String} URL - The URL which is called via Ajax.
     * @param {Object} Data - The data hash or data query string.
     * @param {Function} Callback - The callback function which is called after the request returned from the server.
     * @param {String} [DataType=json] Defines the datatype, default 'json', could also be 'html'
     * @description
     *      Calls an URL via Ajax and executes a given function after the request returned from the server.
     */
    TargetNS.FunctionCall = function (URL, Data, Callback, DataType) {
        if (typeof Data === 'string') {
            Data += SerializeData(GetSessionInformation());
        } else {
            Data = $.extend(Data, GetSessionInformation());
        }

        return $.ajax({
            type: 'POST',
            url: URL,
            data: Data,
            dataType: (typeof DataType === 'undefined') ? 'json' : DataType,
            success: function (Response, Status, XHRObject) {

                Core.App.Publish('Core.App.AjaxErrorResolved');

                if (RedirectAfterSessionTimeOut(XHRObject)) {
                    return false;
                }

                // call the callback
                if ($.isFunction(Callback)) {
                    Callback(Response);
                    // publish to event channel
                    Core.App.Publish('Event.AJAX.FunctionCall.Callback', [Response]);
                }
                else {
                    // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefore we handle the error manually.
                    Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("Invalid callback method: " + ((typeof Callback === 'undefined') ? 'undefined' : Callback.toString())));
                }
            },
            error: function(XHRObject, Status, Error) {
                HandleAJAXError(XHRObject, Status, Error)
            }
        });
    };

    return TargetNS;
}(Core.AJAX || {}));
