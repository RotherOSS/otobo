// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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
 * @namespace
 * @exports TargetNS as Core.Agent.DynamicFieldContactWDSearch
 * @description
 *      This namespace contains the special module functions for the contact data search.
 */
Core.Agent.DynamicFieldContactWDSearch = (function(TargetNS) {

    if (
        !Core.Debug.CheckDependency('Core.Agent.DynamicFieldContactWDSearch', 'Core.Config', 'Core.Config', true)
        )
    {
        return false;
    }

    /**
     * @name Init
     * @memberof Core.Agent.DynamicFieldContactWDSearch
     * @function
     * @description This function initializes the special module functions
     */
    TargetNS.Init = function() {

        function InitDynamicFields($Context) {
            var AutoComplete = Core.Config.Get('Autocomplete'),
                AutoCompleteActive = false;

            if (
                typeof AutoComplete !== 'undefined'
                && typeof AutoComplete.DynamicFieldContactWD !== 'undefined'
                && typeof AutoComplete.DynamicFieldContactWD.AutoCompleteActive !== 'undefined'
                )
            {
                AutoCompleteActive = AutoComplete.DynamicFieldContactWD.AutoCompleteActive !== '0'
                    ? true
                    : false;
            }

            $('.DynamicFieldContactWD', $Context).each(function () {
                TargetNS.InitElement($(this), AutoCompleteActive);
            });
        }

        InitDynamicFields();

        // Since new process screen loads activity via an AJAX call, we need to subscribe to an event
        //   in order to re-initalize dynamic fields. Please see bug#13146 for more information.
        Core.App.Subscribe('TicketProcess.Init.FirstActivityDialog.Load', function ($ActivityDialog) {
            InitDynamicFields($ActivityDialog);
        });
    };

    /**
     * @name InitElement
     * @memberof Core.Agent.DynamicFieldContactWDSearch
     * @function
     * @param {jQueryObject} $Element The jQuery object of the input field with autocomplete
     * @param {Boolean} AutoCompleteActive Set to false, if autocomplete should only be started by click on a button next to the input field
     * @description This function initializes the special module functions for every ContactWD dynamic field
     */
    TargetNS.InitElement = function($Element, AutoCompleteActive) {
        var AutoCompleteConfig = Core.Config.Get('Autocomplete').DynamicFieldContactWD
            ? Core.Config.Get('Autocomplete').DynamicFieldContactWD
            : {
                MinQueryLength: 2,
                QueryDelay: 100,
                MaxResultsDisplayed: 20,
                ButtonText: Core.Language.Translate('Search'),
            };

        if(isJQueryObject($Element)) {

            $Element.next('input[type=button]').bind('click', function() {
                $(this).prev('input').val('').prevAll('input').val('');
                $(this).prev('input').blur();
            });

            // Hide tooltip in autocomplete field, if user already typed something to prevent the autocomplete list
            // to be hidden under the tooltip. (Only needed for serverside errors)
            $Element.unbind('keyup.Validate').bind('keyup.Validate', function() {
                var Value = $Element.val();
                if($Element.hasClass('ServerError') && Value.length) {
                    $('#OTOBO_UI_Tooltips_ErrorTooltip').hide();
                }
            });

            $Element.autocomplete({
                minLength: AutoCompleteActive ? AutoCompleteConfig.MinQueryLength : 500,
                delay: AutoCompleteConfig.QueryDelay,
                source: function(Request, Response) {

                    var URL = Core.Config.Get('Baselink'),
                        Data = {
                            Action: 'AgentContactWDSearch',
                            Term: Request.term,
                            Field: $Element.attr('id'),
                            MaxResults: AutoCompleteConfig.MaxResultsDisplayed
                        };

                    // If an old ajax request is already running, stop the old request and start the new one.
                    if($Element.data('AutoCompleteXHR')) {
                        $Element.data('AutoCompleteXHR').abort();
                        $Element.removeData('AutoCompleteXHR');
                        // Run the response function to hide the request animation.
                        Response({});
                    }

                    $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function(Result) {
                        var ValueData = [];
                        $Element.removeData('AutoCompleteXHR');
                        $.each(Result, function() {
                            ValueData.push({
                                label: this.Value,
                                value: this.Value,
                                key: this.Key
                            });
                        });
                        Response(ValueData);
                    }));
                },
                select: function(Event, UI) {

                    var ContactKey = UI.item.key,
                        ContactValue = UI.item.value;

                    TargetNS.AddTicketContact($(this).attr('id'), ContactValue, ContactKey);
                    Event.preventDefault();
                    return false;
                }
            });

            $Element.blur(function() {
                var Visible = false;

                if (!$(this).val()) {
                    $(this).prevAll('input[type=hidden]').val('');
                    $('.' + $(this).prevAll('input[type=hidden]').attr('id')).fadeOut('fast', function() {

                        if (!$(this).find('.ContactWD').hasClass('Hidden')) {
                            Visible = true;
                        }
                        $(this).remove();

                        if (!$('#ContactInfo').find('.Contact').length) {
                            $('#ContactInfo').find('p.None').removeClass('Hidden');
                        }
                        else if (Visible) {
                            $('#ContactInfo')
                                .find('.Contact')
                                .find('.ContactWD')
                                .addClass('Hidden');
                            $('#ContactInfo')
                                .find('.Contact:first')
                                .find('.ContactWD')
                                .show()
                                .removeClass('Hidden');
                        }
                    });
                }
            });

            if (!AutoCompleteActive) {
                $Element.after('<button id="' + $Element.attr('id') + 'Search" type="button">' + Core.Language.Translate(AutoCompleteConfig.ButtonText) + '</button>');
                $('#' + $Element.attr('id') + 'Search').click(function() {
                    $Element.autocomplete('option', 'minLength', 0);
                    $Element.autocomplete('search');
                    $Element.autocomplete('option', 'minLength', 500);
                });
            }
        }

        // On unload remove old selected data. If the page is reloaded (with F5) this data stays in the field and invokes an ajax request otherwise.
        $(window).bind('beforeunload', function() {
            $('.ContactAutoComplete').val('');
            return;
        });
    };

    /**
     * @function
     * @param {String} Field
     * @param {String} ContactValue The readable customer identifier.
     * @param {String} ContactKey on system.
     * @description This function add a new ticket contact
     * @returns {boolean}
     */
    TargetNS.AddTicketContact = function(Field, ContactValue, ContactKey) {

        var ValueField = Field.replace('Autocomplete_', '');

        if(!ValueField.length) {
            return false;
        }

        $('#' + ValueField).val(ContactKey);
        $('#' + Field).val(ContactValue);

        return true;
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.DynamicFieldContactWDSearch || {}));
