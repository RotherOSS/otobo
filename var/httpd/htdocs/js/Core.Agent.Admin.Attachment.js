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
 * @namespace Core.Agent.Admin.Attachment
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module function for Attachment module.
 */
 Core.Agent.Admin.Attachment = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.Attachment
     * @function
     * @description
     *      This function initializes the table filter.
     */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($("#FilterAttachments"), $("#Attachments"));

        // delete attachment
        TargetNS.InitAttachmentDelete();

        // init checkbox to include invalid elements
        $('input#IncludeInvalid').off('change').on('change', function () {
            var URL = Core.Config.Get("Baselink") + 'Action=' + Core.Config.Get("Action") + ';IncludeInvalid=' + ( $(this).is(':checked') ? 1 : 0 );
            window.location.href = URL;
        });
    };

    /**
     * @name AttachmentDelete
     * @memberof Core.Agent.Admin.Attachment
     * @function
     * @description
     *      This function deletes attachment on buton click.
     */
    TargetNS.InitAttachmentDelete = function () {
        $('.AttachmentDelete').on('click', function () {
            var $AttachmentDeleteElement = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeleteAttachmentDialogContainer'),
                Core.Language.Translate('Delete this Attachment'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting attachment..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink') + 'Action=AdminAttachment;Subaction=Delete',
                                { ID: $AttachmentDeleteElement.data('id') },
                                function(Reponse) {
                                    var DialogText = Core.Language.Translate("There was an error deleting the attachment. Please check the logs for more information.");
                                    if (parseInt(Reponse, 10) > 0) {
                                        $('#AttachmentID_' + parseInt(Reponse, 10)).fadeOut(function() {
                                            $(this).remove();
                                        });
                                        DialogText = Core.Language.Translate("Attachment was deleted successfully.");
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
                            Core.UI.Dialog.CloseDialog($('#DeleteAttachmentDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.Admin.Attachment || {}));
