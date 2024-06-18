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
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.AllocationList
 * @memberof Core.UI
 * @author
 * @description
 *      Support for Allocation Lists (sortable lists).
 */
Core.UI.AllocationList = (function (TargetNS) {
    if (!Core.Debug.CheckDependency('Core.UI.AllocationList', '$([]).sortable', 'jQuery UI sortable')) {
        return false;
    }

    /**
     * @name GetResult
     * @memberof Core.UI.AllocationList
     * @function
     * @return {Array} An array of values defined by DataAttribute.
     * @param {String} ResultListSelector - The selector for the list which will be evaluated for the result.
     * @param {String} DataAttribute - The data attribute to determine the selection.
     * @description
     *      Gets the result of an allocation list.
     */
    TargetNS.GetResult = function (ResultListSelector, DataAttribute) {
        var $List = $(ResultListSelector),
            Result = [];

        if (!$List.length || !$List.find('li').length) {
            return [];
        }

        $List.find('li').each(function () {
            var Value = $(this).data(DataAttribute);
            if (typeof Value !== 'undefined') {
                Result.push(Value);
            }
        });

        return Result;
    };

    /**
     * @name Init
     * @memberof Core.UI.AllocationList
     * @function
     * @param {String} ListSelector - The selector for the lists to initialize
     * @param {String} ConnectorSelector - The selector for the connection (dnd), probably a class
     * @param {Function} ReceiveCallback - The Callback which is called if a list receives an element
     * @param {Function} RemoveCallback - The Callback which is called if an element is removed from a list
     * @param {Function} SortStopCallback - The Callback which is called if the sorting has stopped.
     * @description
     *      Initializes an allocation list.
     */
    TargetNS.Init = function (ListSelector, ConnectorSelector, ReceiveCallback, RemoveCallback, SortStopCallback) {
        var $Lists = $(ListSelector);

        if (!$Lists.length) {
            return;
        }

        $Lists
            .find('li').removeClass('Even').end()
            .sortable({
                connectWith: ConnectorSelector,
                receive: function (Event, UI) {
                    if ($.isFunction(ReceiveCallback)) {
                        ReceiveCallback(Event, UI);
                    }
                },
                remove: function (Event, UI) {
                    if ($.isFunction(RemoveCallback)) {
                        RemoveCallback(Event, UI);
                    }
                },
                stop: function (Event, UI) {
                    if ($.isFunction(SortStopCallback)) {
                        SortStopCallback(Event, UI);
                    }
                }
            }).disableSelection();
    };

    return TargetNS;
}(Core.UI.AllocationList || {}));
