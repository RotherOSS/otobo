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
Core.Agent.Statistics = Core.Agent.Statistics || {};

/**
 * @namespace Core.Agent.Statistics.ParamsWidget
 * @memberof Core.Agent.Statistics
 * @author
 * @description
 *      This namespace contains the special module functions for the Statistics module.
 */
Core.Agent.Statistics.ParamsWidget = (function (TargetNS) {

    /**
     * @name InitViewScreen
     * @memberof Core.Agent.Statistics
     * @function
     * @description
     *      Initialize the params view screen.
     */

TargetNS.Init = function() {
        var StatsParamData = Core.Config.Get('StatsParamData');

        if (typeof StatsParamData !== 'undefined') {
            $('#' + StatsParamData.XAxisTimeScaleElementID).on('change', function() {
                var TimeScaleYAxis = StatsParamData.TimeScaleYAxis,
                $TimeScaleElement = $('#' + StatsParamData.TimeScaleElementID),
                XAxisTimeScaleValue = $(this).val();

                // reset the current time scale dropdown for the y axis
                $TimeScaleElement.empty();

                if (XAxisTimeScaleValue in TimeScaleYAxis) {
                    $.each(TimeScaleYAxis[XAxisTimeScaleValue], function (Index, Item) {
                        var TimeScaleOption = new Option(Item.Value, Item.Key);

                        // Overwrite option text, because of wrong html quoting of text content.
                        // (This is needed for IE.)
                        TimeScaleOption.innerHTML = Item.Value;
                        $TimeScaleElement.append(TimeScaleOption).val(Item.Key).trigger('redraw.InputField').trigger('change');

                    });
                }
            });
        }

        if (typeof Core.Config.Get('StatsWidgetAJAX') !== 'undefined') {
            Core.UI.InputFields.Activate();
        }

        $('.DataShowMore').on('click', function() {
            if ($(this).find('.More').is(':visible')) {
                $(this)
                    .find('.More')
                    .hide()
                    .next('.Less')
                    .show()
                    .parent()
                    .prev('.DataFull')
                    .show()
                    .prev('.DataTruncated')
                    .hide()
            }
            else {
                $(this)
                    .find('.More')
                    .show()
                    .next('.Less')
                    .hide()
                    .parent()
                    .prev('.DataFull')
                    .hide()
                    .prev('.DataTruncated')
                    .show()
            }
            return false;
        });


        $('.CustomerAutoCompleteSimple').each(function() {
            Core.Agent.CustomerSearch.InitSimple($(this));
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Statistics.ParamsWidget || {}));
