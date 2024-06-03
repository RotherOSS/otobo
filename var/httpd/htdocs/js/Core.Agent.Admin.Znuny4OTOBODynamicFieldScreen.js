// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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

var Core         = Core             || {};
Core.Agent       = Core.Agent       || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.Znuny4OTOBODynamicFieldScreen
 * @description
 *      This namespace contains the special module functions for the Dynamic Field Screen module.
 */
Core.Agent.Admin.Znuny4OTOBODynamicFieldScreen = (function (TargetNS) {

    TargetNS.Init = function () {

        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableElements, #DisabledElements, #AssignedElements, #AssignedRequiredElements", ".AllocationList", UpdateFields);

        // Initialize list filter
        Core.UI.Table.InitTableFilter($('#FilterElements'), $('#Elements'));
        Core.UI.Table.InitTableFilter($('#FilterAvailableElements'), $('#AvailableElements'));
        Core.UI.Table.InitTableFilter($('#FilterDisabledElements'), $('#DisabledElements'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedElements'), $('#AssignedElements'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedRequiredElements'), $('#AssignedRequiredElements'));

        $.each(['SelectAllAvailableElements', 'SelectAllDisabledElements',  'SelectAllAssignedElements', 'SelectAllAssignedRequiredElements'], function (Index, Elements) {

            $('input[type="checkbox"][name="'+Elements+'"]').bind('click', function () {
                Core.Form.SelectAllCheckboxes($(this), $('#' + Elements));
            });
        });

        // register all bindings
        $.each(['AvailableElements', 'DisabledElements', 'AssignedElements', 'AssignedRequiredElements'], function (Index, ParameterName) {

            var Element;
            $('#AllSelected'+ ParameterName).bind('click', function () {

                // move all li to another ul list.
                $("input:checkbox:checked").each(function(){
                    Element = $(this).val();

                    if(Element){
                        $('li#'+Element).appendTo('#'+ ParameterName);
                        $('li#'+Element).find('input[type="hidden"]').attr('name', ParameterName);
                        $('#'+Element).find('input[type="checkbox"]').attr('name', 'SelectAll'+ ParameterName);
                    }
                });

                // removed all checked
                $("input:checkbox").prop('checked', $(this).prop("checked")).removeAttr('checked');
            });
        });

        $('#Submit').bind('click', function() {
            $('#Form').submit();
            return false;
        });
    };

    function UpdateFields(Event, UI) {

        var Target = $(UI.item).parent().attr('id');

        // if the element was removed from the AssignedElement list, rename it to DF name
        if (Target === 'AvailableElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'AvailableElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllAvailableElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }

        // rename it to DisabledElements
        else if (Target === 'DisabledElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'DisabledElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllDisabledElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }

        // rename it to AssignedElements
        else if (Target === 'AssignedElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'AssignedElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllAssignedElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }

        // rename it to AssignedRequiredElements
        else if (Target === 'AssignedRequiredElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'AssignedRequiredElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllAssignedRequiredElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }
    }

    return TargetNS;
}(Core.Agent.Admin.Znuny4OTOBODynamicFieldScreen || {}));

Core.Agent.Admin.Znuny4OTOBODynamicFieldScreen.Init();
