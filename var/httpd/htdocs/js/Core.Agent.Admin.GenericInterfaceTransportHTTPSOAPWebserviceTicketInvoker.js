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
 * @namespace Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker
 * @memberof Core.Agent.Admin
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains the special module functions for the GenericInterface Transport HTTP SOAP module.
 */
Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker = (function (TargetNS) {

    /**
     * @name RemoveValue
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker
     * @function
     * @returns {Boolean} Returns false.
     * @param {String} IDSelector - ID of the pressed remove value button.
     * @description
     *      This function removes a value from header list
     */
    TargetNS.RemoveValue = function (IDSelector){

        // remove entry
        $('#' + IDSelector).parent().remove();

        return false;
    };

    /**
     * @name RemoveContainer
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker
     * @function
     * @returns {Boolean} Returns false.
     * @param {String} IDSelector - ID of the pressed remove value button.
     * @description
     *      This function removes a header container
     */
    TargetNS.RemoveContainer = function (IDSelector){

        // cleanup operation selection
        var Operation = $('#' + IDSelector).parent().find('.Operation').html();
        $('#OutboundHeadersOperationSelection option[value="' + Operation +'"]').attr('selected', false).attr('disabled', false);
        $('#OutboundHeadersOperationSelection').trigger('redraw.InputField');


        // remove entry
        $('#OperationOutboundHeaders' + Operation).replaceWith('<div class="HeaderContainer" id="OperationOutboundHeaders' + Operation + '"></div>');

        return false;
    };

    /**
     * @name AddAdditionalValue
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker
     * @function
     * @returns {Boolean} Returns false
     * @param {Object} ValueInsert - HTML container of the value mapping row.
     * @description
     *      This function adds a new value to the possible values list
     */
    TargetNS.AddAdditionalValue = function (ValueInsert) {

        // clone key dialog
        var $Clone = $('.ValueTemplate').clone(),
            ValueCounter = $('#ValueCounter').val();

        // increment key counter
        ValueCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ValueTemplate');

        // add needed class
        $Clone.addClass('ValueRow');

        // copy values and change ids and names
        $Clone.find(':input, a.RemoveButton').each(function(){
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
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + ValueCounter);
        });
        // prepend to container
        ValueInsert.prepend($Clone);

        // set new value for KeyName
        $('#ValueCounter').val(ValueCounter);

        return false;
    };


    /**
     * @name AddValue
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker
     * @function
     * @returns {Boolean} Returns false
     * @param {Object} ValueInsert - HTML container of the value mapping row.
     * @description
     *      This function adds a new value to the header list
     */
    TargetNS.AddValue = function (ValueInsert) {

        // clone key dialog
        var $Clone = ValueInsert.parent().find('.ValueTemplate').clone(),
            ValueCounter = ValueInsert.parent().find('.ValueCounter').val();

        // increment key counter
        ValueCounter++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ValueTemplate');

        // copy values and change ids and names
        $Clone.find(':input, a.RemoveButton').each(function(){
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
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + ValueCounter);
        });

        // append to container
        ValueInsert.find('.ValueRows').append($Clone);

        // set new value for KeyName
        ValueInsert.parent().find('.ValueCounter').val(ValueCounter);

        return false;
    };

    /**
     * @name AddContainer
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker
     * @function
     * @returns {Boolean} Returns false
     * @param {String} Operation - contains selected operation name
     * @description
     *      This function adds a new container for specific headers
     */
    TargetNS.AddContainer = function (Operation) {

        var $Clone, ActiveID, $InputListContainerObj;

        if (!Operation || $('#OperationOutboundHeaders' + Operation).hasClass('HeaderContainerActive')) {
            return;
        }

        // clone box
        $Clone = $('.ContainerValueTemplate').clone();

        // remove unnecessary classes
        $Clone.removeClass('Hidden ContainerValueTemplate').addClass('HeaderContainerActive');

        // change ids and names, set values
        $Clone.attr('id', 'OperationOutboundHeaders' + Operation);

        ActiveID = $Clone.find('.OperationOutboundHeadersActiveTemplate');
        ActiveID.attr('id', 'OperationOutboundHeadersActive' + Operation);
        ActiveID.attr('name', 'OperationOutboundHeadersActive');
        ActiveID.val(Operation);
        ActiveID.removeClass('OperationOutboundHeadersActiveTemplate');

        $Clone.find('.ValueCounter').val('0');
        $Clone.find('.Operation').html(Operation);

        $Clone.find('div > :input, div > a.RemoveButton, div > a.AddValue').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', 'OutboundHeaders' + Operation + ID);
            $(this).attr('name', 'OutboundHeaders' + Operation + ID);
        });

        // bind click function to add button
        $Clone.find('#OutboundHeaders' + Operation + 'AddValue').on('click', function () {
            TargetNS.AddValue(
                $(this).closest('.ValueInsert')
            );
            return false;
        });

        // bind click function to remove all button
        $Clone.find('#OutboundHeaders' + Operation + 'ValueRemoveAll').on('click', function () {
            TargetNS.RemoveContainer($(this).attr('id'));
            return false;
        });

        // append to container
        $('#OperationOutboundHeaders' + Operation).replaceWith($Clone);

        // cleanup operation selection
        $InputListContainerObj = $('body > .InputField_ListContainer').first().find('#OutboundHeadersOperationSelection_Select');
        $InputListContainerObj.jstree('deselect_node', $InputListContainerObj.jstree('get_selected'));

        $('#OutboundHeadersOperationSelection option[value="' + Operation +'"]').attr('selected', false).attr('disabled', true);
        $('#OutboundHeadersOperationSelection').trigger('redraw.InputField');

        return false;
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker
     * @function
     * @description
     *      This function binds events to certain actions
     */
    TargetNS.Init = function () {

        // bind change function to Request Name Scheme field
        $('#RequestNameScheme').on('change', function(){
            if ($(this).val() === 'Append' || $(this).val() === 'Replace') {
                $('.RequestNameFreeTextField').removeClass('Hidden');
                $('#RequestNameFreeText').addClass('Validate_Required');
            }
            else {
                $('.RequestNameFreeTextField').addClass('Hidden');
                $('#RequestNameFreeText').removeClass('Validate_Required');
            }
        });

        // bind change function to Response Name Scheme field
        $('#ResponseNameScheme').on('change', function(){
            if ($(this).val() === 'Append' || $(this).val() === 'Replace') {
                $('.ResponseNameFreeTextField').removeClass('Hidden');
                $('#ResponseNameFreeText').addClass('Validate_Required');
            }
            else {
                $('.ResponseNameFreeTextField').addClass('Hidden')
                $('#ResponseNameFreeText').removeClass('Validate_Required');
            }
        });

        // bind change function to SOAP Action field
        $('#SOAPAction').on('change', function(){
            if ($(this).val() === 'Yes') {
                $('.SOAPActionSchemeField').removeClass('Hidden');
                $('#SOAPActionScheme').addClass('Validate_Required');

                if ($('#SOAPActionScheme').val() === 'SeparatorOperation' || $('#SOAPActionScheme').val() === 'NameSpaceSeparatorOperation') {
                    $('.SOAPActionSeparatorField').removeClass('Hidden');
                    $('#SOAPActionSeparatorText').addClass('Validate_Required');
                }
                else if ($('#SOAPActionScheme').val() === 'FreeText') {
                    $('.SOAPActionFreeTextField').removeClass('Hidden');
                    $('#SOAPActionFreeText').addClass('Validate_Required');
                }
                Core.UI.InputFields.Init();
            }
            else {
                $('.SOAPActionSchemeField').addClass('Hidden');
                $('#SOAPActionScheme').removeClass('Validate_Required');
                $('.SOAPActionSeparatorField').addClass('Hidden');
                $('#SOAPActionSeparatorText').removeClass('Validate_Required');
                $('.SOAPActionFreeTextField').addClass('Hidden');
                $('#SOAPActionFreeText').removeClass('Validate_Required');
            }
        });

        // bind change function to SOAP Action scheme field
        $('#SOAPActionScheme').on('change', function(){
            if ($(this).val() === 'SeparatorOperation' || $(this).val() === 'NameSpaceSeparatorOperation') {
                $('.SOAPActionSeparatorField').removeClass('Hidden');
                $('#SOAPActionSeparatorText').addClass('Validate_Required');
                $('.SOAPActionFreeTextField').addClass('Hidden');
                $('#SOAPActionFreeText').removeClass('Validate_Required');
                Core.UI.InputFields.Init();
            }
            else if ($(this).val() === 'FreeText') {
                $('.SOAPActionFreeTextField').removeClass('Hidden');
                $('#SOAPActionFreeText').addClass('Validate_Required');
                $('.SOAPActionSeparatorField').addClass('Hidden');
                $('#SOAPActionSeparatorText').removeClass('Validate_Required');
                Core.UI.InputFields.Init();
            }
            else {
                $('.SOAPActionFreeTextField').addClass('Hidden');
                $('#SOAPActionFreeText').removeClass('Validate_Required');
                $('.SOAPActionSeparatorField').addClass('Hidden');
                $('#SOAPActionSeparatorText').removeClass('Validate_Required');
            }
        });

        // bind change function to Authentication field
        $('#AuthType').on('change', function(){
            if ($(this).val() === 'BasicAuth') {
                $('.BasicAuthField').removeClass('Hidden');
                $('.BasicAuthField').find('#BasicAuthUser').each(function(){
                    $(this).addClass('Validate_Required');
                });
            }
            else {
                $('.BasicAuthField').addClass('Hidden');
                $('.BasicAuthField').find('#BasicAuthUser').each(function(){
                    $(this).removeClass('Validate_Required');
                });
            }
        });

        // bind change function to Use Proxy field
        $('#UseProxy').on('change', function(){
            if ($(this).val() === 'Yes') {
                $('.ProxyField').removeClass('Hidden');
                $('#ProxyExclude').addClass('Validate_Required');
                Core.UI.InputFields.Activate($('.ProxyField'));
            }
            else {
                $('.ProxyField').addClass('Hidden');
            }
        });

        // bind change function to Use SSL field
        $('#UseSSL').on('change', function(){
            if ($(this).val() === 'Yes') {
                $('.SSLField').removeClass('Hidden');
            }

            else {
                $('.SSLField').addClass('Hidden');
            }
        });

        // special handling for value counter
        $('.ValueRow :input[name^="Key"]').each(function(i){

            // set value counter
            $('#ValueCounter').val(i + 1);
        })

        //bind click function to add button
        $('#AddValue').on('click', function () {
            TargetNS.AddAdditionalValue(
                $(this).closest('fieldset').find('.ValueInsert')
            );
            return false;
        });

        //bind click function to remove button
        $('.ValueRemove').on('click', function () {
            TargetNS.RemoveValue($(this).attr('id'));
            return false;
        });

        // bind change function to operation selection field
        $('#OutboundHeadersOperationSelection').on('change', function(){
            TargetNS.AddContainer(
                $(this).val()
            );
            return false;
        });

        //bind click function to add buttons
        $('.AddValue').on('click', function () {
            TargetNS.AddValue(
                $(this).closest('.ValueInsert')
            );
            return false;
        });

        //bind click function to remove button
        $('.ValueRemove').on('click', function () {
            TargetNS.RemoveValue($(this).attr('id'));
            return false;
        });

        // bind click function to remove all button
        $('.ValueRemoveAll').on('click', function () {
            TargetNS.RemoveContainer($(this).attr('id'));
            return false;
        });

        Core.Agent.SortedTree.Init($('.SortableList'), $('#TransportConfigForm'), $('#Sort'), Core.Config.Get('SortData'));
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.GenericInterfaceTransportHTTPSOAPWebserviceTicketInvoker || {}));
