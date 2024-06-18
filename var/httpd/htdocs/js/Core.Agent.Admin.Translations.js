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
 * @namespace Core.Agent.Admin.Translations
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the Translations module.
 */
Core.Agent.Admin.Translations = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.Translations
     * @function
     * @description
     *      This function initialize the module.
     */
    TargetNS.Init = function () {

        /* Trigger work language change in overview subaction */
        $('#UserLanguage').bind('change', function (Event) {
            $('#UserLanguage_Search').prop('readonly', true);
            $("#LangSelection").submit();
            return false;
        });

        /* Initialize search boxes and clean notice message */
        if ( Core.Config.Get('Subaction') != 'Add' && Core.Config.Get('Subaction') != 'Change' ) {
            Core.UI.Table.InitTableFilter($('#FilterTranslations'), $('#TranslationsTable'));
            Core.UI.Table.InitTableFilter($('#FilterDraftTranslations'), $('#DraftTranslationsTable'));
            setTimeout(function () { $('.MessageBox.Notice').hide(); }, 10000);
        }

        /* Initialize change Subaction */
        if (Core.Config.Get('Subaction') === 'Change') {
            Core.UI.Table.InitTableFilter($('#FilterEditTranslations'), $('#DraftTranslations'));

            $("input[type=text]").keypress(function() {
                if ( $(this).attr('id') != 'FilterEditTranslations' ) {
                    $(this).css("background","#feffb3");
                }
            });
        }

        /* Show next fields depending on Object selection */
        $("#Object").bind('change', function (Event) {

            /* Clear and Hide all containers */
            $("#FieldContainer").html('');
            $("#FieldContainerSingle").html('');
            $("#DataContainer").html('');
            $("#FieldContainer").addClass('Hidden');
            $("#FieldContainerSingle").addClass('Hidden');
            $("#TranslationTableContainer").addClass('Hidden');

            if ($(this).val() == '') {
                return;
            }

            let Data = {
                Action: 'AdminTranslations',
                Object: encodeURIComponent($("#Object").val()),
                LanguageID: encodeURIComponent($("input[name=LanguageID]").val()),
                OTOBOAgentInterface: encodeURIComponent($("input[name=OTOBOAgentInterface]").val())
            };

            /* Show containers and data */
            if ($(this).val() == 'DynamicFieldLabel' || $(this).val() == 'DynamicFieldContent' || $(this).val() == 'GeneralLabel') {
                Data.Subaction = 'RenderField';

                /* Get field data from backend */
                Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                    $("#FieldContainer").html(Response);
                    $("#FieldContainer").removeClass('Hidden');
                    Core.UI.InputFields.Activate("#FieldContainer");

                    if ($("#Object").val() == 'DynamicFieldLabel' || $("#Object").val() == 'DynamicFieldContent') {
                        Core.Agent.Admin.Translations.Init();
                        $("#Translation").focus();
                    }

                    $("#Content").focus();
                    return false;
                }, 'html');

            } else {
                Data.Subaction = 'GetDraftTable';

                /* Get data table from backend */
                Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
                    $("#FieldContainer").addClass('Hidden');
                    $("#DataContainer").html(Response);
                    return false;
                }, 'html');

                /* Show Table container */
                $("#TranslationTableContainer").removeClass('Hidden');
            }

            return false;
        });

        $("#DynamicFieldID").bind('change', function (Event) {
            ChangeDynamicField("DynamicFieldID");
        });

        $("#DynamicFieldListWithContent").bind('change', function (Event) {
            ChangeDynamicField("DynamicFieldListWithContent");
        });

        /* Submit validation */
        $("#Submit").click( function (e) {
            if ( $("#Subaction").val() == 'AddAction' ) {
                if ( $("#ItemCount").length ) {
                    let Filled = 0;
                    for (var row=1; row <= $("#ItemCount").val(); row++ ) {
                        if ( $("#TranslateInput_"+row).val().trim() != "" ) {
                            Filled++;
                        }
                    }

                    if ( !Filled ) {
                        Core.UI.Dialog.ShowAlert(
                            Core.Language.Translate('Missing Translations'),
                            Core.Language.Translate('At least one translation must be filled!'),
                            function () {
                                Core.UI.Dialog.CloseDialog($('.Alert'));
                                return false;
                            }
                        );

                        e.preventDefault();
                        e.stopPropagation();
                        return false;
                    }
                }
            } else if ( $("#Subaction").val() == 'ChangeAction' ) {
                if ( parseInt($("#CountNew").val()) > 0 ) {
                    let Filled = 0;
                    for (var row = 1; row < parseInt($("#CountNew").val()); row++ ) {
                        if ( $("#TranslateInput_Change_"+row).val().trim() != "" ) {
                            Filled++;
                        }
                    }

                    if ( Filled+1 != parseInt($("#CountNew").val()) ) {
                        Core.UI.Dialog.ShowAlert(
                            Core.Language.Translate('Missing Translations'),
                            Core.Language.Translate('All translations must be filled!'),
                            function () {
                                Core.UI.Dialog.CloseDialog($('.Alert'));
                                return false;
                            }
                        );

                        e.preventDefault();
                        e.stopPropagation();
                        return false;
                    }
                }

                if ( $("#ExistingIDs").get(0) ) {
                    if ( $("#ExistingIDs").val() != '' ) {
                        let Existing = $("#ExistingIDs").val().split(",");
                        let Filled = 0;

                        $.each( Existing, function( id, value ) {
                            if ( $("#TranslateInput_"+value).val().trim() != "" ) {
                                Filled++;
                            }
                        });

                        if ( Filled != Existing.length ) {
                            Core.UI.Dialog.ShowAlert(
                                Core.Language.Translate('Missing Translations'),
                                Core.Language.Translate('All translations must be filled!'),
                                function () {
                                    Core.UI.Dialog.CloseDialog($('.Alert'));
                                    return false;
                                }
                            );

                            e.preventDefault();
                            e.stopPropagation();
                            return false;
                        }
                    }
                }
            }
        });
    };

    /**
     * @private
     * @name ChangeDynamicField
     * @memberof Core.Agent.Admin.Translations
     * @function
     * @param {String} FieldID - The data that should be serialized
     * @description
     *     Event for dynamic field changes.
     */

    function ChangeDynamicField(FieldID) {
        let IsAll = $('#' + FieldID).val();

        if ($("#" + FieldID).val() == '') {
            $("#FieldContainerSingle").html('');
            $("#FieldContainerSingle").addClass('Hidden');
            $("#DataContainer").html('');
            $("#TranslationTableContainer").addClass('Hidden');
            return;
        }

        let Data = {
            Action: 'AdminTranslations',
            Subaction: 'GetDraftTable',
            Object: encodeURIComponent($("#Object").val()),
            DynamicFieldID: encodeURIComponent($('#' + FieldID).val()),
            LanguageID: encodeURIComponent($("input[name=LanguageID]").val()),
            OTOBOAgentInterface: encodeURIComponent($("input[name=OTOBOAgentInterface]").val())
        };

        /* Get field data or data table from backend */
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            if ((FieldID == 'DynamicFieldID' || FieldID == 'DynamicFieldListWithContent ') && IsAll != 'ListAll') {
                $("#DataContainer").html('');
                $("#TranslationTableContainer").addClass('Hidden');
                $("#FieldContainerSingle").html(Response);
                $("#Content").prop('readonly', true);
                $("#FieldContainerSingle").removeClass('Hidden');
            } else {
                $("#FieldContainerSingle").html('');
                $("#Content").prop('readonly', false);
                $("#FieldContainerSingle").addClass('Hidden');
                $("#DataContainer").html(Response);
                $("#TranslationTableContainer").removeClass('Hidden');
            }
        }, 'html');
        return;
    };

    /**
     * @name Deploy
     * @memberof Core.Agent.Admin.Translations
     * @function
     * @param {jQueryObject} $Object
     * @description
     *      Deploy translations.
     */

    TargetNS.Deploy = function () {

        let Data = {
            Action: 'AdminTranslations',
            Subaction: 'Deploy',
            UserLanguage: encodeURIComponent($("input[name=UserLanguage]").val()),
            OTOBOAgentInterface: encodeURIComponent($("input[name=OTOBOAgentInterface]").val())
        };

        /* Get field data or data table from backend */
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
            if ( Response.Success == 2 || Response.Success == 3 ) {
                Core.UI.Dialog.ShowAlert(
                    $("#DeployHeader").val(),
                    Response.Message,
                    function () {
                        Core.UI.Dialog.CloseDialog($('.Alert'));
                        return false;
                    }
                );
            } else {
                Core.UI.Dialog.ShowDialog({
                    Modal: true,
                    Title: $("#DeployHeader").val(),
                    HTML: Response.Message,
                    PositionTop: '20%',
                    PositionLeft: 'Center',
                    CloseOnEscape: false,
                    CloseOnClickOutside: false,
                    Buttons: [
                        {
                            Label: Core.Language.Translate('Close'),
                            Function: function () {
                                Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                window.location = Core.Config.Get('CGIHandle') + "?Action=AdminTranslations;UserLanguage="+encodeURIComponent($("input[name=UserLanguage]").val())+";OTOBOAgentInterface="+encodeURIComponent($("input[name=OTOBOAgentInterface]").val());
                            },
                            Class: 'CallForAction'
                        }
                    ]
                });

            }
        });
    };

    /**
     * @name Delete
     * @memberof Core.Agent.Admin.Translations
     * @function
     * @param {jQueryObject} $Object
     * @param {String} ID
     * @param {String} Content
     * @param {String} Translation
     * @description
     *      Mark existing translation for delete.
     */

    TargetNS.Delete = function (ID, Content, Translation) {

        if (ID) {
            $("#Mark").val('');
        }

        $("#Subaction").val('Delete');
        $("#DeleteID").val(ID);
        $("#Content").val(Content);
        $("#Translation").val(Translation);
        $("#FormOverviewData").submit();
    };

    /**
     * @name UndoDelete
     * @memberof Core.Agent.Admin.Translations
     * @function
     * @param {jQueryObject} $Object
     * @param {String} Content
     * @description
     *     Undo delete translation item.
     */

    TargetNS.UndoDelete = function (Content) {
        $("#Subaction").val('UndoDelete');
        $("#Content").val(Content);
        $("#FormOverviewData").submit();
    };

    /**
     * @name EditSingleTranslation
     * @memberof Core.Agent.Admin.Translations
     * @function
     * @param {jQueryObject} $Object
     * @param {String} ID
     * @param {String} Content
     * @param {String} Translation
     * @description
     *     Launch single translation editing.
     */

    TargetNS.EditSingleTranslation = function (ID, Content, Translation) {
        $("#ID").val(ID);
        $("#EditContent").val(Content);
        $("#EditTranslation").val(Translation);
        $("#FormChangeData").submit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Translations || {}));
