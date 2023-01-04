// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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
 * @namespace Core.Agent.AppointmentParticipationWidget
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for the Appointment Participation Widget.
 */
Core.Agent.AppointmentParticipationWidget = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.AppointmentParticipationWidget
     * @function
     * @description
     *      Initializes widget Appointment Participation
     */
    TargetNS.Init = function() {
        var AppointmentParticipation = Core.Config.Get('AppointmentParticipation');

        // Initializes Appointment Participation event functionality
        if (typeof AppointmentParticipation !== 'undefined') {
            AppointmentParticipationEvent(AppointmentParticipation);

            TargetNS.InitAppointmentActions();

           // Subscribe to ContentUpdate event to initiate events on Appointment Participation widget update
            Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function(WidgetHTML) {
                if (typeof WidgetHTML !== 'undefined' && WidgetHTML.search('DashboardActions') !== parseInt('-1', 10)) {
                    AppointmentParticipationEvent(AppointmentParticipation);
                }
            });

        }
        else if (Core.Config.Get('Action') === 'AgentParticipation') {
            TargetNS.InitAppointmentActions();
        }
    }

    TargetNS.InitAppointmentActions = function() {

        $('.CalendarParticipationAction').off('change').on('change', function(Event) {

            var ParticipationID = $(this).attr('id').substring('CalendarParticipationAction_'.length);
            var ParticipationStatus = $(this).val();

            if ( ParticipationStatus ) {
                // Declining without further action
                if ( ParticipationStatus === 'InstantDeclineInvitation' ) {
                    SetParticipationStatus(ParticipationID, ParticipationStatus);
                }
                else {
                    // When accepting, ask for calendar selection
                    var SelectionClone = $('#CalendarSelection_' + ParticipationID).clone();
                    SelectionClone.removeClass('Hidden').attr('name', 'DialogCalendarSelection').attr('id', 'DialogCalendarSelection').addClass('W25pc');
                    var DialogHTML = SelectionClone.prop('outerHTML');
                    // Show calendar selection dialog
                    // Doing check for conflicting appointment once on load and on every change
                    Core.UI.Dialog.ShowDialog({
                        Modal: true,
                        Title: Core.Language.Translate("Calendar Selection"),
                        HTML: '<script type="application/javascript">'                                            +
                            'CheckConflictingAppointments();'                                                     +
                            '$("#DialogCalendarSelection").on("change", function() {'                             +
                            '   CheckConflictingAppointments();'                                                  +
                            '});'                                                                                 +
                            'function CheckConflictingAppointments() {'                                           +
                            '   Core.AJAX.FunctionCall('                                                          +
                            '       Core.Config.Get("CGIHandle"),'                                                +
                            '       {'                                                                            +
                            '           ChallengeToken: $("#ChallengeToken").val(),'                              +
                            '           Action: "AgentParticipation",'                                            +
                            '           Subaction: "CheckConflictingAppointments",'                               +
                            '           ParticipationID: ' + ParticipationID + ','                                +
                            '          CalendarID: $("#DialogCalendarSelection").val(),'                          +
                            '       },'                                                                           +
                            '       function(Response) {'                                                         +
                            '           if ( Response.ConflictMessage ) {'                                        +
                            '               $("#AppointmentConflictWarning > p").text(Response.ConflictMessage);' +
                            '               $("#AppointmentConflictWarning").css("display", "block");'            +
                            '           }'                                                                        +
                            '           else {'                                                                   +
                            '               $("#AppointmentConflictWarning").css("display", "none");'             +
                            '           }'                                                                        +
                            '       }'                                                                            +
                            '   );'                                                                               +
                            '}'                                                                                   +
                            '</script>'                                                                           +
                            '<fieldset class="TableLike" style="width: 300px;">'                                  +
                            '    <label>' + Core.Language.Translate("Calendar") + ':</label>'                     +
                            '    <div class="Field">' + DialogHTML + '</div>'                                     +
                            '    <div id="AppointmentConflictWarning" style="display: none;"><p></p></div>'       +
                            '</fieldset>',
                        PositionTop: '100px',
                        PositionLeft: 'Center',
                        CloseOnEscape: true,
                        CloseOnClickOutside: true,
                        AllowAutoGrow: true,
                        Buttons: [
                            {
                                Label: Core.Language.Translate("Confirm"),
                                Function: function() {
                                    var SelectedCalendarID = $('#DialogCalendarSelection').val();
                                    SetParticipationStatus(ParticipationID, ParticipationStatus, SelectedCalendarID);
                                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                }
                            }
                        ]
                    });
                }
            }
        });
    }

    /**
     * @private
     * @name AppointmentParticipationEvent
     * @memberof Core.Agent.AppointmentParticipationWidget
     * @function
     * @param {Object} AppointmentParticipation - Hash with container name, HTML name and refresh time
     * @description
     *      Initializes dashboard widget Appointment Participation events.
     */
    function AppointmentParticipationEvent (AppointmentParticipation) {

        var RequestURL = Core.Config.Get('Baselink') + 'Action=AgentDashboard;Subaction=Element;Name=' + AppointmentParticipation.Name;
        if ( Core.Config.Get('Action') === 'AgentAppointmentCalendarOverview' ) {
            var CalendarSelection = [];
            $.each($('.CalendarSwitch input:checked'), function(Index, Element) {
                CalendarSelection.push($(Element).data('id'));
            });
            RequestURL += ';CalendarID=' + JSON.stringify(CalendarSelection);
        }
        else if ( Core.Config.Get('Action') === 'AgentTicketZoom' ) {
            var TicketID, key;
            for (key of (new URLSearchParams(document.documentURI.replace(';', '&'))).entries())
            {
                if (key[0] == 'TicketID')
                {
                    TicketID = key[1];
                }
            }
            RequestURL += ';TicketID=' + TicketID;
        }

        // Load filter for today.
        $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name) + 'Today').unbind('click').bind('click', function(){
            Core.AJAX.ContentUpdate(
                $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)).length ? $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)) : $(this).closest('.Content'),
                RequestURL + ';Filter=Today',
                function () {
                    TargetNS.InitAppointmentActions();
                }
            );
            return false;
        });

        // Load filter for tomorrow.
        $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name) + 'Tomorrow').unbind('click').bind('click', function(){
            Core.AJAX.ContentUpdate(
                $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)).length ? $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)) : $(this).closest('.Content'),
                RequestURL + ';Filter=Tomorrow',
                function () {
                    TargetNS.InitAppointmentActions();
                }
            );
            return false;
        });

        // Load filter for soon.
        $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name) + 'Soon').unbind('click').bind('click', function(){
            Core.AJAX.ContentUpdate(
                $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)).length ? $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)) : $(this).closest('.Content'),
                RequestURL + ';Filter=Soon',
                function () {
                    TargetNS.InitAppointmentActions();
                }
            );
            return false;
        });

        // Initiate refresh event.
        Core.Config.Set('RefreshSeconds_' + AppointmentParticipation.NameHTML, parseInt(AppointmentParticipation.RefreshTime, 10) || 0);
        if (Core.Config.Get('RefreshSeconds_' + AppointmentParticipation.NameHTML)) {
            Core.Config.Set('Timer_' + AppointmentParticipation.NameHTML, window.setTimeout(
                function() {
                    $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name) + '-box').addClass('Loading');
                    Core.AJAX.ContentUpdate($('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)), Core.Config.Get('Baselink') + 'Action=AgentDashboard;Subaction=Element;Name=' + AppointmentParticipation.Name, function () {
                        $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name) + '-box').removeClass('Loading');
                    });
                    clearTimeout(Core.Config.Get('Timer_' + AppointmentParticipation.NameHTML));
                },
                Core.Config.Get('RefreshSeconds_' + AppointmentParticipation.NameHTML) * 1000)
            );
        }
        Core.UI.InputFields.InitSelect($('.CalendarParticipationAction'));
    }

    /**
     * @private
     * @name SetParticipationStatus
     * @memberof Core.Agent.AppointmentParticipationWidget
     * @function
     * @param {String} ParticipationStatus - 'Accept', 'Accept temporarily' or 'Reject'
     * @param {Number} SelectedCalendarID - ID of calendar to set the appointment state for
     * @description
     *      Initializes dashboard widget Appointment Participation events.
     */
    function SetParticipationStatus (ParticipationID, ParticipationStatus, SelectedCalendarID) {

        var RequestData = {
            ChallengeToken: $('#ChallengeToken').val(),
            Subaction: ParticipationStatus,
            ParticipationID: ParticipationID,
            Action: 'AgentParticipation'
        };
        if ( ParticipationStatus !== 'InstantDeclineInvitation' ) {
            RequestData.CalendarID = SelectedCalendarID;
        }

        // AJAX request for setting participation state
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            RequestData,
            function () {
                var AppointmentParticipation = Core.Config.Get('AppointmentParticipation');
                if (typeof AppointmentParticipation !== 'undefined') {
                    var RequestURL = Core.Config.Get('Baselink') + 'Action=AgentDashboard;Subaction=Element;Name=' + AppointmentParticipation.Name;
                    if ( Core.Config.Get('Action') === 'AgentAppointmentCalendarOverview' ) {
                        var CalendarSelection = [];
                        $.each($('.CalendarSwitch input:checked'), function(Index, Element) {
                            CalendarSelection.push($(Element).data('id'));
                        });
                        RequestURL += ';CalendarID=' + JSON.stringify(CalendarSelection);
                    }
                    else if ( Core.Config.Get('Action') === 'AgentTicketZoom' ) {
                        var TicketID, key;
                        for (key of (new URLSearchParams(document.documentURI.replace(';', '&'))).entries())
                        {
                            if (key[0] == 'TicketID')
                            {
                                TicketID = key[1];
                            }
                        }
                        RequestURL += ';TicketID=' + TicketID;
                    }
                    Core.AJAX.ContentUpdate(
                        $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)).length ? $('#Dashboard' + Core.App.EscapeSelector(AppointmentParticipation.Name)) : $('.CalendarParticipationAction').closest('.Content'),
                        RequestURL + ';Filter=' + $('.ParticipationFilter > li.Selected > a').attr('id').substr(('Dashboard' +Core.App.EscapeSelector(AppointmentParticipation.Name)).length),
                        function () {
                            TargetNS.InitAppointmentActions();
                        }
                    );
                }
                else {
                    location.reload();
                }
            }
        );
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.AppointmentParticipationWidget || {}))
