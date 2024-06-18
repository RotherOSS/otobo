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

var ITSM = ITSM || {};
ITSM.Admin = ITSM.Admin || {};


/**
 * @namespace Admin
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains the special module behaviours for ITSM Service Zoom.
 */
 ITSM.Admin.ImportExport = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Admin.ImportExport
     * @function
     * @description
     *      This function initializes actions for ITSM Service Zoom.
     */
    TargetNS.Init = function() {

        var $NextButton, $FirstColumn;

        if (Core.Config.Get('TemplateEdit4')) {

            // find the next button and get the first column dropdown
            $NextButton = $("button.Primary[name='SubmitNextButton']").first();
            $FirstColumn = $('#Object\\:\\:0\\:\\:Key');

            // handle changes to the first column selector
            $FirstColumn.bind('change', function () {

                // check if there is at least one column with a value
                if ($FirstColumn.val()) {
                    // we remove the disabled attribute
                    $NextButton.removeAttr("disabled");
                }
                else {
                    // we add the disabled attribute
                    $NextButton.attr("disabled", "disabled");
                }

            }).trigger('change');

            // set the hidden field to delete this column and submit the form
            $('.DeleteColumn').unbind('click').bind('click', function() {
                $(this).closest('td').find('input[type="hidden"]').val(1);
                $(this).closest('form').submit();
                return true;
            });

            $('#MappingAddButton').bind('click', function () {
                $('input[name=MappingAdd]').val('1');
                $('input[name=SubmitNext]').val('0');
            });

            $('#SubmitNextButton').bind('click', function () {
                $('input[name=MappingAdd]').val('0');
                $('input[name=SubmitNext]').val('1');
            });
        }

        if (Core.Config.Get('TemplateOverview')) {

            $('button.Back').bind('click', function () {
                location.href = Core.Config.Get('Baselink') + Core.Config.Get('BackURL');
            });

            Core.Form.Validate.AddMethod("Validate_NumberBiggerThanZero", function(Value) {
                var Number = parseInt(Value, 10);
                if (isNaN(Number)) {
                    return false;
                }

                if (Number > 0) {
                    return true;
                }
                return false;

            });

            Core.Form.Validate.AddMethod("Validate_NumberInteger", function(Value) {
                return (Value.match(/^[0-9]+$/)) ? true : false;

            });

            Core.Form.Validate.AddRule("Validate_NumberBiggerThanZero", { Validate_NumberBiggerThanZero: true });
            Core.Form.Validate.AddRule("Validate_NumberInteger", { Validate_NumberInteger: true });
            Core.Form.Validate.AddRule("Validate_NumberIntegerBiggerThanZero", { Validate_NumberInteger: true, Validate_NumberBiggerThanZero: true });

        }

        // Delete Import/Export.
        TargetNS.InitImportExportDelete();
    };

    /**
     * @name ImportExportDelete
     * @memberof ITSM.Admin.ImportExport
     * @function
     * @description
     *      This function deletes import/export item on button click.
     */
    TargetNS.InitImportExportDelete = function () {
        $('.ImportExportDelete').on('click', function () {
            var $ImportExportDeleteElement = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeleteImportExportDialogContainer'),
                Core.Language.Translate('Delete this template'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting template..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink') + 'Action=AdminImportExport;Subaction=TemplateDelete',
                                { TemplateID: $ImportExportDeleteElement.data('id') },
                                function(Response) {
                                    var DialogText = Core.Language.Translate("There was an error deleting the template. Please check the logs for more information.");
                                    if (parseInt(Response, 10) > 0) {
                                        $('#TemplateID_' + parseInt(Response, 10)).fadeOut(function() {
                                            $(this).remove();
                                        });
                                        DialogText = Core.Language.Translate("Template was deleted successfully.");
                                    }
                                    $('.Dialog .InnerContent .Center').text(DialogText);
                                    window.setTimeout(function() {
                                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                    }, 1000);
                                }
                            );
                        }
                    },
                    {
                        Label: Core.Language.Translate("Cancel"),
                        Function: function () {
                            Core.UI.Dialog.CloseDialog($('#DeleteImportExportDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Admin.ImportExport || {}));
