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
 * @namespace Core.Agent.Admin.DynamicField
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for the DynamicField module.
 */
Core.Agent.Admin.DynamicField = (function (TargetNS) {

    /**
     * @private
     * @name SerializeData
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @returns {String} query string of the data
     * @param {Object} Data - The data that should be converted.
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
     * @name Redirect
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @param {String} FieldType  - Type of DynamicField.
     * @param {String} ObjectType - Type of the object to which the dynamic field is attached
     * @param {String} OptionData - Additional data from data attributes in the option tag
     * @description
     *      Redirect to URL based on DynamicField config.
     */
    TargetNS.Redirect = function(FieldType, ObjectType, OptionData) {
        var DynamicFieldsConfig, Action, URL, FieldOrder, ObjectTypeFilter, NamespaceFilter;

        // get configuration
        DynamicFieldsConfig = Core.Config.Get('DynamicFields');

        // get action
        Action = DynamicFieldsConfig[ FieldType ];

        // get field order
        FieldOrder = parseInt($('#MaxFieldOrder').val(), 10) + 1;

        // get object type filter
        ObjectTypeFilter = $("#DynamicFieldObjectType").val();

        // get namespace filter
        NamespaceFilter = $("#DynamicFieldNamespace").val();

        // redirect to correct url
        URL = Core.Config.Get('Baselink') + 'Action=' + Action + ';Subaction=Add' + ';ObjectType=' + ObjectType + ';FieldType=' + FieldType + ';FieldOrder=' + FieldOrder;
        if ( ObjectTypeFilter ) {
            URL += ';ObjectTypeFilter=' + encodeURIComponent(ObjectTypeFilter);
        }
        if ( NamespaceFilter ) {
            URL += ';NamespaceFilter=' + encodeURIComponent(NamespaceFilter);
        }

        // some options have additional associated data
        if( 'referenced_object_type' in OptionData ) {
            URL += ';ReferencedObjectType=' + OptionData.referenced_object_type;
        }
        URL += SerializeData(Core.App.GetSessionInformation());
        window.location = URL;
    };

    /**
     * @name ValidationInit
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Adds specific validation rules to the frontend module.
     */
    TargetNS.ValidationInit = function() {
        Core.Form.Validate.AddRule("Validate_Alphanumeric", {
            /*eslint-disable camelcase */
            Validate_Alphanumeric: true
            /*eslint-enable camelcase */
        });
        Core.Form.Validate.AddMethod("Validate_Alphanumeric", function (Value) {
            return (/^[a-zA-Z0-9]+$/.test(Value));
        }, "");

        Core.Form.Validate.AddRule("Validate_PositiveNegativeNumbers", {
            /*eslint-disable camelcase */
            Validate_PositiveNegativeNumbers: true
            /*eslint-enable camelcase */
        });
        Core.Form.Validate.AddMethod("Validate_PositiveNegativeNumbers", function (Value) {
            return (/^-?[0-9]+$/.test(Value));
        }, "");
    };

    /**
     * @name DynamicFieldAddAction
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Bind event on dynamic field add action field.
     */
    TargetNS.DynamicFieldAddAction = function () {
        var ObjectType = Core.Config.Get('ObjectTypes'),
            Key;

        // Bind event on dynamic field add action
        function FieldAddAction(Type) {
            $('#' + Type + 'DynamicField').on('change', function() {
                if ($(this).val() !== null && $(this).val() !== '') {
                    var FieldType = $(this).val().split('::').shift();
                    Core.Agent.Admin.DynamicField.Redirect(
                        FieldType,
                        Type,
                        $(this).find("option:selected").data() // the data of the selected option
                    );

                    // reset select value to none
                    $(this).val('');
                }

                return false;
            });
        }
        for (Key in ObjectType) {
            FieldAddAction(ObjectType[Key]);
        }
    };

    /**
     * @name ShowContextSettingsDialog
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Bind event on Setting button.
     */
    TargetNS.ShowContextSettingsDialog = function() {
        $('#ShowContextSettingsDialog').on('click', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#ContextSettingsDialogContainer'), Core.Language.Translate("Settings"), '20%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Save"),
                        Type: 'Submit',
                        Class: 'Primary'}
                ]);
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });
    }

    /**
     * @name DynamicFieldDelete
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Bind event on dynamic field delete button.
     */
    TargetNS.DynamicFieldDelete = function() {
        $('.DynamicFieldDelete').on('click', function (Event) {

            if (window.confirm(Core.Language.Translate("Do you really want to delete this dynamic field? ALL associated data will be LOST!"))) {

                Core.UI.Dialog.ShowDialog({
                    Title: Core.Language.Translate("Delete field"),
                    HTML: Core.Language.Translate("Deleting the field and its data. This may take a while..."),
                    Modal: true,
                    CloseOnClickOutside: false,
                    CloseOnEscape: false,
                    PositionTop: '20%',
                    PositionLeft: 'Center',
                    Buttons: []
                });

                Core.AJAX.FunctionCall(
                    Core.Config.Get('Baselink'),
                    $(this).data('query-string') + 'Confirmed=1;',
                    function() {
                        window.location.reload();
                    }
                );
            }

            // don't interfere with MasterAction
            Event.stopPropagation();
            Event.preventDefault();
            return false;
        });
    };

    /**
     * @name DynamicFieldClone
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *      Bind event on dynamic field clone button.
     */
    TargetNS.DynamicFieldClone = function() {
        $('.DynamicFieldClone').on('click', function (Event) {

            // get field order
            var FieldOrder = parseInt($('#MaxFieldOrder').val(), 10) + 1;

            // don't interfere with MasterAction
            Event.stopPropagation();
            Event.preventDefault();

            window.location = $(this).attr('href') + ';FieldOrder=' + FieldOrder;

            return false;
        });
    };

    /**
     * @name Init
     * @memberof Core.Agent.Admin.DynamicField
     * @function
     * @description
     *       Initialize module functionality
     */
    TargetNS.Init = function () {

        // Initialize JS functions
        TargetNS.ValidationInit();
        TargetNS.DynamicFieldAddAction();
        TargetNS.ShowContextSettingsDialog();
        TargetNS.DynamicFieldDelete();
        TargetNS.DynamicFieldClone();

        // Initialize dynamic field filter
        Core.UI.Table.InitTableFilter($('#FilterDynamicFields'), $('#DynamicFieldsTable'));

        $( "#DynamicFieldObjectType, #DynamicFieldNamespace, #IncludeInvalid" ).change(function() {
            let ObjectTypeFilter = $("#DynamicFieldObjectType").val();
            let NamespaceFilter = $("#DynamicFieldNamespace").val();
            let IncludeInvalid = $("#IncludeInvalid").is(':checked') ? 1 : 0;
            let URL = Core.Config.Get('Baselink') + 'Action=AdminDynamicField';
            if ( ObjectTypeFilter ) {
                URL += ';ObjectTypeFilter=' + encodeURIComponent(ObjectTypeFilter);
            }
            if ( NamespaceFilter ) {
                URL += ';NamespaceFilter=' + encodeURIComponent(NamespaceFilter);
            }
            if ( IncludeInvalid !== undefined ) {
                URL += ';IncludeInvalid=' + encodeURIComponent(IncludeInvalid);
            }
            window.location = URL;
        });

        Core.Config.Set('EntityType', 'DynamicField');

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicField || {}));
