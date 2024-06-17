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
 * @namespace Core.Agent.Admin.DynamicFieldTitle
 * @memberof Core.Agent.Admin
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains the special module functions for the DynamicFieldText module.
 */
Core.Agent.Admin.DynamicFieldTitle = (function (TargetNS) {

    TargetNS.ActivateTemplate = function() {

        $('#FontTemplate').attr('readonly', false);
        $('#FontTemplate').attr('disabled', false);
        $('#FontSize').attr('readonly', true);
        $('#FontColor').attr('readonly', true);
        $('#CBFontStyleBold').attr('disabled', true);
        $('#CBFontStyleItalic').attr('disabled', true);
        $('#CBFontStyleUnderLine').attr('disabled', true);

        return true;
    };
    TargetNS.DeactivateTemplate = function() {

        $('#FontTemplate').attr('readonly', true);
        $('#FontTemplate').attr('disabled', true);
        $('#FontSize').attr('readonly', false);
        $('#FontColor').attr('readonly', false);
        $('#CBFontStyleBold').attr('disabled', false);
        $('#CBFontStyleItalic').attr('disabled', false);
        $('#CBFontStyleUnderLine').attr('disabled', false);
        return true;
    };
    TargetNS.SetValue = function(Param){
        var MyParam =  Param;

        $('#FontSize').val(MyParam['Size']);
        $('#FontColor').val(MyParam['Color']);
        if( MyParam['Italic'] == '1') {
            $('#CBFontStyleItalic').prop('checked', true);
            $('#CBFontStyleItalicValue').val('on');
        }else{
            $('#CBFontStyleItalic').prop('checked', false);
            $('#CBFontStyleItalicValue').val('');
        }

        if( MyParam['Bold'] == '1' ) {
            $('#CBFontStyleBold').prop('checked', true);
            $('#CBFontStyleBoldValue').val('on');
        }else{
            $('#CBFontStyleBold').prop('checked', false);
            $('#CBFontStyleBoldValue').val('');
        }

        if( MyParam['UnderLine'] == '1' ) {
            $('#CBFontStyleUnderLine').prop('checked', true);
            $('#CBFontStyleUnderLineValue').val('on');
        }else{
            $('#CBFontStyleUnderLine').prop('checked', false);
            $('#CBFontStyleUnderLineValue').val('');
        }

        return true;
    };

    /**
    * @name Init
    * @memberof Core.Agent.Admin.DynamicFieldTitle
    * @function
    * @description
    *       Initialize module functionality
    */
    TargetNS.Init = function () {
        $('.ShowWarning').on('change keyup', function () {
            $('p.Warning').removeClass('Hidden');
        });


        if ( $('#ActivateTemplate').prop("checked") == true) {
            TargetNS.ActivateTemplate();
            var SelectedTemplate = $('.FontTemplateSelected option:selected').text();
            var Param = Core.Config.Get(SelectedTemplate);
            TargetNS.SetValue(Param);
        }else{
            TargetNS.DeactivateTemplate();
        }

        // Font template selection handle;
        $('#FontTemplate').on('change', function () {
            var SelectedTemplate = $('.FontTemplateSelected option:selected').text();
            var Param = Core.Config.Get(SelectedTemplate);
            TargetNS.SetValue(Param);
        });

        //italic, bold, underline style checkboxes handle
        $('#CBFontStyleItalic').on('change', function () {
            if(this.checked){
                $('#CBFontStyleItalicValue').val('on');
            }else{
                $('#CBFontStyleItalicValue').val('');
            }
        });

        $('#CBFontStyleBold').on('change', function () {
            if(this.checked){
                $('#CBFontStyleBoldValue').val('on');
            }else{
                $('#CBFontStyleBoldValue').val('');
            }
        });

        $('#CBFontStyleUnderLine').on('change', function () {
            if(this.checked){
                $('#CBFontStyleUnderLineValue').val('on');
            }else{
                $('#CBFontStyleUnderLineValue').val('');
            }
        });

        // checkbox handle
        $('#ActivateTemplate').on('change', function () {
            if(this.checked){
                TargetNS.ActivateTemplate();
                var SelectedTemplate = $('.FontTemplateSelected option:selected').text();
                var Param = Core.Config.Get(SelectedTemplate);
                TargetNS.SetValue(Param);
            }
            else{
                TargetNS.DeactivateTemplate();
            }
        return false;
        });

        Core.Agent.Admin.DynamicField.ValidationInit();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldText || {}));
