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
 * @namespace Core.Agent.TicketBulk
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains special module functions for the TicketBulk.
 */
Core.Agent.TicketBulk = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.TicketBulk
     * @function
     * @description
     *      This function initializes the functionality for the TicketBulk screen.
     */
    TargetNS.Init = function () {
        var TicketBulkURL = Core.Config.Get('TicketBulkURL'),
            $TicketNumberObj = $('#MergeTo');

        // Initialize autocomplete feature on ticket number field.
        Core.UI.Autocomplete.Init($TicketNumberObj, function (Request, Response) {
            var URL = Core.Config.Get('Baselink'),
                Data = {
                    Action: 'AgentTicketSearch',
                    Subaction: 'AJAXAutocomplete',
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

        // bind radio and text input fields
        $('#MergeTo').on('blur', function() {
            if ($(this).val()) {
                $('#OptionMergeTo').prop('checked', true);
            }
        });

        // execute function in the parent window
        Core.UI.Popup.ExecuteInParentWindow(function(WindowObject) {
            WindowObject.Core.UI.Popup.FirePopupEvent('URL', { URL: TicketBulkURL }, false);
        });

        // get the Recipients on expanding of the email widget
        $('#EmailSubject').closest('.WidgetSimple').find('.Header .Toggle a').on('click', function() {

            // if the spinner is still there, we want to load the recipients list
            if ($('#EmailRecipientsList i.fa-spinner:visible').length) {

                Core.AJAX.FunctionCall(
                    Core.Config.Get('CGIHandle'),
                    {
                        'Action'    : 'AgentTicketBulk',
                        'Subaction' : 'AJAXRecipientList',
                        'TicketIDs' : Core.JSON.Stringify(Core.Config.Get('ValidTicketIDs'))
                    },
                    function(Response) {
                        var Recipients = Core.JSON.Parse(Response),
                            TextShort = '',
                            TextFull = '',
                            Counter;

                        if (Recipients.length <= 3) {
                            $('#EmailRecipientsList').text(Recipients.join(', '));
                        }
                        else {
                            for (Counter = 0; Counter < 3; Counter++) {
                                TextShort += Recipients[Counter];
                                if (Counter < 2) {
                                    TextShort += ', ';
                                }
                            }

                            for (Counter = 3; Counter < Recipients.length; Counter++) {
                                if (Counter < Recipients.length) {
                                    TextFull += ', ';
                                }
                                TextFull += Recipients[Counter];
                            }

                            $('#EmailRecipientsList').text(TextShort);
                            $('#EmailRecipientsList')
                                .append('<a href="#" class="Expand"></a>')
                                .find('a')
                                .on('click', function() {

                                    $(this).hide();
                                    $(this).nextAll('span, a').fadeIn();
                                    return false;
                                })
                                .text(Core.Language.Translate(" ...and %s more", Recipients.length - 3))
                                .closest('span')
                                .append('<span />')
                                .find('span')
                                .text(TextFull)
                                .parent()
                                .append('<a href="#" class="Collapse"></a>')
                                .find('a.Collapse')
                                .on('click', function() {

                                    $(this)
                                        .hide()
                                        .prev('span')
                                        .hide()
                                        .prev('a')
                                        .fadeIn();

                                    return false;
                                })
                                .text(Core.Language.Translate(" ...show less"));
                        }
                    }
                );
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.TicketBulk || {}));
