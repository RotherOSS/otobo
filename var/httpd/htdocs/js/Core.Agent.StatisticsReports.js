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
 * @namespace Core.Agent.StatisticsReports
 * @memberof Core.Agent
 * @author Rother OSS GmbH
 * @description
 *      This namespace contains the special module functions for the Statistics module.
 */
Core.Agent.StatisticsReports = (function (TargetNS) {

    // Incremental number for the next stat that might be added.
    var StatAddOutputCounter = $('#StatsContainer .WidgetSimple.Stat').length + 1;

    /**
     * @private
     * @name SerializeStatsConfiguration
     * @memberof Core.Agent.StatisticsReports
     * @function
     * @returns {String} Configuration in JSON format
     * @description
     *      Returns serialized statistic configuration.
     */
    function SerializeStatsConfiguration () {
        var Config = [];

        function GetFieldValues ($Container) {
            var Values = {};

            $Container.find('select, input, textarea').each(function() {
                Values[$(this).attr('name')] = $(this).val();
            });

            return Values;
        }

        $('#StatsContainer .Stat').each(function() {
            var StatConfig = {};

            StatConfig.StatGetParams = GetFieldValues($(this).find('.StatGetParams'));
            StatConfig.StatReportSettings = GetFieldValues($(this).find('.StatReportSettings'));

            Config.push(StatConfig);
        });

        $('#StatsConfiguration').val(Core.JSON.Stringify(Config));
        return Config;
    }

    /**
     * @name Init
     * @memberof Core.Agent.StatisticsReports
     * @description
     *      Initializes the behavior of report statistics screen.
     */
    TargetNS.Init = function () {

        // Save and SaveAndFinish button click events.
        $('#SaveButton, #SaveAndFinishButton').on('click', function() {
            SerializeStatsConfiguration();
            $('input#SaveAndFinish').val($(this).data('save-and-finish'));
            $('form#MainForm').submit();
        });

        // Add statistics to container on change event.
        $('#StatsAdd').on('change', function() {
            var StatID = $(this).val();
            Core.AJAX.FunctionCall(
                Core.Config.Get('CGIHandle'),
                {
                    Action: 'AgentStatisticsReports',
                    Subaction: 'StatsAddWidgetAJAX',
                    StatID: StatID,
                    OutputCounter: StatAddOutputCounter++
                },
                function(Response) {
                    if (!Response.Success) {
                        return;
                    }
                    $('#StatsContainer').append(Response.Content);
                    Core.UI.InputFields.Activate($('#StatsContainer'));
                    Core.UI.InitWidgetActionToggle();
                },
                'json'
            );
            $(this).val('');
            if ($(this).hasClass('Modernize')) {
                $(this).trigger('redraw.InputField');
            }
        });

        // Remove container with statistics data.
        $('#StatsContainer').on('click', '.StatRemove', function() {
            $(this).parents('.WidgetSimple.Stat').remove();
            return false;
        });

        // Delete statistics on Overview screen.
        $('.StatDelete').on('click', function (Event) {
            var ConfirmText = '"' + $(this).data('stat-report-name') + '"\n\n' + Core.Language.Translate('Do you really want to delete this report?');
            if (!window.confirm(ConfirmText)) {
                Event.stopPropagation();
                Event.preventDefault();
                return false;
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Statistics || {}));
