// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
 * @namespace Core.Agent.TicketMerge
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the TicketMerge functions.
 */
Core.Agent.TicketMerge = (function (TargetNS) {

    /**
     * @name SwitchMandatoryFields
     * @private
     * @memberof Core.Agent.TicketMerge
     * @function
     * @description
     *      This function switches the given fields between mandatory and optional.
     */
    function SwitchMandatoryFields() {
        var InformSenderChecked = $('#InformSender').prop('checked'),
            $ElementsLabelObj = $('#To,#Subject,#RichText').parent().prev('label');

        if (InformSenderChecked) {
            $ElementsLabelObj
                .addClass('Mandatory')
                .find('.Marker')
                .removeClass('Hidden');
        }
        else if (!InformSenderChecked) {
            $ElementsLabelObj
                .removeClass('Mandatory')
                .find('.Marker')
                .addClass('Hidden');
        }
    }

    /**
     * @name GetTicketSearchFilter
     * @private
     * @memberof Core.Agent.TicketMerge
     * @function
     * @description
     *      This function determines search filter for the ticket number field based on the checkbox state.
     */
    function GetTicketSearchFilter() {
        var $TicketSearchFilterObj = $('#TicketSearchFilter'),
            TicketSearchFilter = new Object(),
            FilterName = $TicketSearchFilterObj.is(':checked') ? $TicketSearchFilterObj.data('ticket-search-filter') : null,
            FilterValue = $TicketSearchFilterObj.is(':checked') ? $TicketSearchFilterObj.val() : null;

        if (FilterName && FilterValue) {
            TicketSearchFilter[FilterName] = FilterValue;
            Core.Config.Set('TicketSearchFilter', TicketSearchFilter);
            return;
        }

        Core.Config.Set('TicketSearchFilter', null);
    }

    /**
     * @name Init
     * @memberof Core.Agent.TicketMerge
     * @function
     * @description
     *      This function initializes the functionality for the TicketMerge screen.
     */
    TargetNS.Init = function () {
        var $TicketNumberObj = $('#MainTicketNumber'),
            $TicketSearchFilterObj = $('#TicketSearchFilter');

        $TicketSearchFilterObj.off('change.TicketMerge').on('change.TicketMerge', GetTicketSearchFilter)
            .trigger('change.TicketMerge');

        // Initialize autocomplete feature on ticket number field.
        Core.UI.Autocomplete.Init($TicketNumberObj, function (Request, Response) {
            var URL = Core.Config.Get('Baselink'),
                Data = {
                    Action: 'AgentTicketSearch',
                    Subaction: 'AJAXAutocomplete',
                    Filter: Core.JSON.Stringify(Core.Config.Get('TicketSearchFilter')),
                    Skip: $('[name="TicketID"]').val(),
                    Term: Request.term,
                    MaxResults: Core.UI.Autocomplete.GetConfig('MaxResultsDisplayed')
                };

            $TicketNumberObj.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                var ValueData = [];
                $TicketNumberObj.removeData('AutoCompleteXHR');
                $.each(Result, function () {
                    ValueData.push({
                        label: this.Value,
                        key:  this.Key,
                        value: this.Value
                    });
                });
                Response(ValueData);
            }));
        }, function (Event, UI) {
            $TicketNumberObj.val(UI.item.key).trigger('select.Autocomplete');

            Event.preventDefault();
            Event.stopPropagation();

            return false;
        }, 'TicketSearch');

        // Make sure on focus handler also returns ticket number value only.
        $TicketNumberObj.on('autocompletefocus', function (Event, UI) {
            $TicketNumberObj.val(UI.item.key);

            Event.preventDefault();
            Event.stopPropagation();

            return false;
        });

        // initial setting for to/subject/body
        SwitchMandatoryFields();

        // watch for changes of inform sender field
        $('#InformSender').on('click', function(){
            SwitchMandatoryFields();
        });

        // Subscribe to ToggleWidget event to handle special behaviour in ticket merge screen
        Core.App.Subscribe('Event.UI.ToggleWidget', function ($WidgetElement) {
            if ($WidgetElement.attr('id') !== 'WidgetInformSender') {
                return;
            }

            // if widget is being opened and checkbox is not yet checked, check it
            if ($WidgetElement.hasClass('Expanded') && !$('#InformSender').prop('checked')) {
                $('#InformSender').trigger('click');
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketMerge || {}));
