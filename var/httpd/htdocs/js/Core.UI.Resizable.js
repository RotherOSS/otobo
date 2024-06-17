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
 * @namespace Core.UI.Resizable
 * @memberof Core.UI
 * @author
 * @description
 *      Contains the code for resizable elements.
 */
Core.UI.Resizable = (function (TargetNS) {

    /**
     * @private
     * @name ScrollerMinHeight
     * @memberof Core.UI.Resizable
     * @member {Number}
     * @description
     *      The minimum height fpr the resizable object.
     */
    var ScrollerMinHeight = 120,
    /**
     * @private
     * @name HandleHeight
     * @memberof Core.UI.Resizable
     * @member {Number}
     * @description
     *      The height of the handle to resize the resizable element.
     */
        HandleHeight = 9;

    /**
     * @callback Core.UI.Resizable~Callback
     * @param {EventObject} Event - The javascript event object.
     * @param {Object} UI - The jQuery UI object.
     * @param {String} Height - Height of the resizable object.
     * @param {String} Width - Width of the resizable object.
     */

    /**
     * @name Init
     * @memberof Core.UI.Resizable
     * @function
     * @param {jQueryObject} $Element - jQuery object of the element, which should be resizable.
     * @param {Number} ScrollerHeight - The default height of the resizable object.
     * @param {Function} Callback - The callback if resizable has changed.
     * @description
     *      This function initializes the resizability of the given element.
     */
    TargetNS.Init = function ($Element, ScrollerHeight, Callback) {
        var CurrentTableHeight,
            InitScroller = true;

        // also catch NaN or undefined values for ScrollerHeight, but pass 0
        //      to Math.max in these cases, otherwise it may cause an exception
        ScrollerHeight = Math.max(ScrollerHeight || 0, ScrollerMinHeight);

        if (isJQueryObject($Element) && $Element.length) {
            CurrentTableHeight = $Element.find('table').outerHeight();
            // If the scroller is not needed (because only few elements shown in table)
            // than also do not initialize the scroller event and hide the scroller handle

            // Table is smaller than minheight
            if ((CurrentTableHeight) <= ScrollerMinHeight) {
                $Element.find('.Scroller').height(CurrentTableHeight);
                InitScroller = false;
            }
            // Table is bigger than minheight but smaller than the saved scrollerheight
            // Scroller still should be enabled
            else if ((CurrentTableHeight) < ScrollerHeight) {
                $Element.find('.Scroller').height(CurrentTableHeight);
            }
            // Table is bigger than minheight and saved height of scroller
            // Scroller still should be enabled
            else {
                $Element.find('.Scroller').height(ScrollerHeight);
            }

            if (InitScroller) {
                $Element.resizable({
                    handles: {
                        s: $Element.find('.Handle a')
                    },
                    minHeight: ScrollerMinHeight + HandleHeight,
                    maxHeight: $Element.find('table').outerHeight() + HandleHeight,
                    resize: function (Event, UI) {
                        var Height, Width;
                        Height = UI.size.height - HandleHeight;
                        Width = UI.size.width - 2; // substract 2 pixels for the scroller borders
                        $Element.find('div.Scroller').height(Height + 'px').width(Width + 'px');

                        if ($.isFunction(Callback)) {
                            Callback(Event, UI, Height, Width);
                        }
                    }
                });
            }
            else {
                // No event initialization
                // Additionally, the scroller handle is hidden
                $('div.Handle').hide();
                $Element.find('.Scroller').css('margin-bottom', '1px');
            }
        }
    };

    return TargetNS;
}(Core.UI.Resizable || {}));
