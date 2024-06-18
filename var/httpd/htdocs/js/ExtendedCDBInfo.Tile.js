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

var ExtendedCDBInfo = ExtendedCDBInfo || {};
ExtendedCDBInfo.Tile = ExtendedCDBInfo.Tile || {};

/**
 * @namespace ExtendedCDBInfo.Tile
 * @memberof ExtendedCDBInfo
 * @author
 * @description
 *      This namespace contains the special functions for the CustomerDashboardInfoTile.
 */
 ExtendedCDBInfo.Tile = (function (TargetNS) {

    /**
     * @private
     * @name CalculateHeight
     * @memberof ExtendedCDBInfo.Tile
     * @function
     * @param {DOMObject} Iframe - DOM representation of an iframe
     * @description
     *      Sets the size of the iframe to the size of its inner html.
     */
    function CalculateHeight(Iframe){
        Iframe = isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;

        setTimeout(function () {
            var $IframeContent = $(Iframe.contentDocument || Iframe.contentWindow.document),
                NewHeight = $IframeContent.height();

            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = 100;
            }

            NewHeight = parseInt(NewHeight, 10) + 10;
            $(Iframe).height(NewHeight + 'px');
        }, 1000);
    }

    /**
     * @private
     * @name CalculateHeight
     * @memberof ExtendedCDBInfo.Tile
     * @function
     * @param {DOMObject} Iframe - DOM representation of an iframe
     * @param {Function} [Callback]
     * @description
     *      Resizes Iframe to its max inner height and (optionally) calls callback.
     */
    function ResizeIframe(Iframe, Callback){
        Iframe = isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;
        CalculateHeight(Iframe);
        if ($.isFunction(Callback)) {
            Callback();
        }
    }

    /**
     * @private
     * @name CheckIframe
     * @memberof ExtendedCDBInfo.Tile
     * @function
     * @param {DOMObject} Iframe - DOM representation of an iframe
     * @param {Function} [Callback]
     * @description
     *      This function contains some workarounds for all browsers to get re-size the iframe.
     * @see http://sonspring.com/journal/jquery-iframe-sizing
     */
    function CheckIframe(Iframe, Callback){
        var Source;

        Iframe = isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;

        if ($.browser.safari || $.browser.opera){
            $(Iframe).on('load', function() {
                setTimeout(ResizeIframe, 0, Iframe, Callback);
            });
            Source = Iframe.src;
            Iframe.src = '';
            Iframe.src = Source;
        }
        else {
            $(Iframe).on('load', function() {
                ResizeIframe(this, Callback);
            });
        }
    }

    /*
    * @name Init
    * @memberof ExtendedCDBInfo.Tile
    * @function
    * @description
    *      This function initializes module functionality.
    */
    TargetNS.Init = function () {
        $('.oooTile_InfoTile iframe').each( function() {
            CheckIframe($(this));
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ExtendedCDBInfo.Tile || {}));
