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
 * @namespace Core.Agent.TicketProcess
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for TicketProcess.
 */
Core.Agent.TicketProcess = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketProcess
     * @function
     * @description
     *      This function initializes the special module functions.
     */
    TargetNS.Init = function () {

        var ProcessID = Core.Config.Get('ProcessID');

        if (typeof ProcessID !== 'undefined') {
            $('#ProcessEntityID').val(ProcessID);
        }

        if (typeof Core.Config.Get('ParentReload') !== 'undefined' && parseInt(Core.Config.Get('ParentReload'), 10) === 1){
            Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
                if (WindowObject.Core.UI.Popup.GetWindowMode() !== 'Iframe') {
                    WindowObject.Core.UI.Popup.FirePopupEvent('Reload');
                }
            });
        }

        $('#ProcessEntityID').on('change', function () {
            var Data = {
                Action: 'AgentTicketProcess',
                Subaction: 'DisplayActivityDialogAJAX',
                ProcessEntityID: $('#ProcessEntityID').val(),
                LinkTicketID: $('#LinkTicketID').val(),
                ArticleID: $('#ArticleID').val(),
                FormID: $(this).closest('form').find('input:hidden[name=FormID]').val(),
                IsAjaxRequest: 1,
                IsMainWindow: 1
            };

            if ($('#IsProcessEnroll').val() !== 'undefined' && $('#IsProcessEnroll').val() === '1') {
                $.extend(Data, {
                    IsMainWindow: 0,
                    IsProcessEnroll: 1,
                    TicketID: $('#TicketID').val()
                });
            }


            if ($('#ProcessEntityID').val()) {

                // remove the content of the activity dialog
                $('#ActivityDialogContent').empty();

                // fade out the empty container so it will fade in again on processes change
                // is not recommended to empty after fade out at this point since the transition offect
                // will not look so nice
                $('#ActivityDialogContent').fadeOut('fast');

                // show loader icon
                $('#AJAXLoader').removeClass('Hidden');

                // get new ActivityDialog content
                Core.AJAX.FunctionCall(
                    Core.Config.Get('CGIHandle'),
                    Data,
                    function (Response) {
                    var $ElementToUpdate = $('#ActivityDialogContent'),
                        JavaScriptString = '',
                        ErrorMessage;

                    if (!Response) {

                        // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefor we handle the error manually.
                        Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No content received.", 'CommunicationError'));
                        $('#AJAXLoader').addClass('Hidden');
                    }
                    else if ($ElementToUpdate && isJQueryObject($ElementToUpdate) && $ElementToUpdate.length) {
                        $ElementToUpdate.get(0).innerHTML = Response;
                        $ElementToUpdate.find('script').each(function() {
                            JavaScriptString += $(this).html();
                            $(this).remove();
                        });
                        $ElementToUpdate.fadeIn();
                        Core.UI.InputFields.Activate($ElementToUpdate);
                        try {
                            /*eslint-disable no-eval */
                            eval(JavaScriptString);
                            /*eslint-enable no-eval */
                        }
                        catch (Event) {
                            // do nothing here (code needed  to not have an empty block here)
                            $.noop(Event);
                        }

                        // Handle special server errors (Response = <div class="ServerError" data-message="Message"></div>)
                        // Check if first element has class 'ServerError'
                        if ($ElementToUpdate.children().first().hasClass('ServerError')) {
                            ErrorMessage = $ElementToUpdate.children().first().data('message');

                            // Add class ServerError to the process select element
                            $('#ProcessEntityID').addClass('ServerError');
                            // Set a custom error message to the proccess select element
                            $('#ProcessEntityIDServerError').children().first().text(ErrorMessage);
                        }

                        Core.Form.Validate.Init();

                        // Register event for tree selection dialog
                        Core.UI.TreeSelection.InitTreeSelection();

                        // initialize ajax dnd upload
                        Core.UI.InitAjaxDnDUpload();

                        // move help triggers into field rows for dynamic fields
                        $('.Row > .FieldCell > .FieldHelpContainer').each(function () {
                            if (!$(this).next('label').find('.Marker').length) {
                                $(this).prependTo($(this).next('label'));
                            }
                            else {
                                $(this).insertAfter($(this).next('label').find('.Marker'));
                            }
                        });


                        // Initially display dynamic fields with TreeMode = 1 correctly
                        Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();

                        // trigger again a responsive event
                        if (Core.App.Responsive.IsSmallerOrEqual(Core.App.Responsive.GetScreenSize(), 'ScreenL')) {
                            Core.App.Publish('Event.App.Responsive.SmallerOrEqualScreenL');
                        }

                        // trigget customer auto complete event if field is accesible
                        if ($ElementToUpdate.find('#CustomerAutoComplete').length) {
                            Core.Agent.CustomerSearchAutoComplete.Init();
                        }

                        $('#AJAXLoader').addClass('Hidden');
                        $('#AJAXDialog').val('1');

                        Core.TicketProcess.Init();

                        Core.UI.InputFields.InitMultiValueDynamicFields();

                        QuickDateButtons.Init();

                        // Publish event when first activity dialog has loaded, so other code can know to execute again.
                        Core.App.Publish('TicketProcess.Init.FirstActivityDialog.Load', [$ElementToUpdate]);

                        $('button[type=submit]').on('click', function(Event) {
                            $('.DynamicFieldText').attr('disabled', false);
                            return true;
                        });
                    }
                    else {

                        // We are out of the OTOBO App scope, that's why an exception would not be caught. Therefor we handle the error manually.
                        Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("No such element id: " + $ElementToUpdate.attr('id') + " in page!", 'CommunicationError'));
                        $('#AJAXLoader').addClass('Hidden');
                    }
                }, 'html');
            }
            else {
                $('#ActivityDialogContent').fadeOut(400, function() {
                    $('#ActivityDialogContent').empty();
                });
            }
            return false;
        });

        // If process is pre-selected trigger change event on ProcessEntityID field.
        if ($('#ProcessEntityID').val() !== "") {
            $('#ProcessEntityID').trigger('change');
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketProcess || {}));
