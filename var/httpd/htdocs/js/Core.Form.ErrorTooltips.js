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
Core.Form = Core.Form || {};

/**
 * @namespace Core.Form.ErrorTooltips
 * @memberof Core.Form
 * @author
 * @description
 *      This namespace contains the Tooltip initialization functions.
 */
Core.Form.ErrorTooltips = (function (TargetNS) {

    /**
     * @private
     * @name TooltipContainerID
     * @memberof Core.Form.ErrorTooltips
     * @member {String}
     * @description
     *      ID of the container DOM element.
     */
    var TooltipContainerID = 'OTOBO_UI_Tooltips_ErrorTooltip',
    /**
     * @private
     * @name TooltipOffsetTop
     * @memberof Core.Form.ErrorTooltips
     * @member {Number}
     * @description
     *      Top offset in pixel of the tooltip from the DOM element.
     */
        TooltipOffsetTop = 20,
    /**
     * @private
     * @name TooltipOffsetLeft
     * @memberof Core.Form.ErrorTooltips
     * @member {Number}
     * @description
     *      Left offset in pixel of the tooltip from the DOM element.
     */
        TooltipOffsetLeft = 20,
    /**
     * @private
     * @name TongueClass
     * @memberof Core.Form.ErrorTooltips
     * @member {String}
     * @description
     *      Class name of the tooltip for the tongue. Defines if the tongue is left or right.
     */
        TongueClass = 'TongueLeft',
    /**
     * @private
     * @name TonguePosition
     * @memberof Core.Form.ErrorTooltips
     * @member {String}
     * @description
     *      Class name of the tooltip for the tongue position. Defines if the tongue is top or bottom.
     */
        TonguePosition = 'TongueBottom',

    /**
     * @private
     * @name TongueHeight
     * @memberof Core.Form.ErrorTooltips
     * @member {Number}
     * @description
     *      Height of the tongue (css-based) which will be considered when the tooltip position is being calculated
     */
        TongueHeight = 10,
    /**
     * @private
     * @name $TooltipContent
     * @memberof Core.Form.ErrorTooltips
     * @member {jQueryObject}
     * @description
     *      The tooltip base HTML.
     */
        $TooltipContent = $('<div class="Content" role="tooltip"></div>'),
    /**
     * @private
     * @name $Tooltip
     * @memberof Core.Form.ErrorTooltips
     * @member {jQueryObject}
     * @description
     *      The HTMl of the complete Tooltip.
     */
        $Tooltip,
    /**
     * @private
     * @name Offset
     * @memberof Core.Form.ErrorTooltips
     * @member {Object}
     * @description
     *      The offset of the element for which a tooltip is shown.
     */
        Offset;
    /**
     * @name ShowTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - jquery object.
     * @param {String} TooltipContent - The string content that will be show in tooltip.
     * @param {String} TooltipPosition - Vertical position of the tooltip: 'TongueTop' or 'TongueBottom'.
     * @description
     *      This function shows the tooltip for an element with a certain content.
     */
    TargetNS.ShowTooltip = function($Element, TooltipContent, TooltipPosition) {

        var $TooltipContainer = $('#' + TooltipContainerID),
            TopOffset;

        if (TooltipPosition == null) {
            TooltipPosition = TonguePosition;
        }

        if (!$TooltipContainer.length) {
            $('body').append('<div id="' + TooltipContainerID + '" class="TooltipContainer"></div>');
            $TooltipContainer = $('#' + TooltipContainerID);
        }

        /*
         * Now determine if the tongue needs to be right or left, depending on the
         * position of the target element on the screen.
         */
        if (($(document).width() - $Element.offset().left) < 250) {
            TongueClass = 'TongueRight';
        }

        /*
         * Now create and fill the tooltip with the error message.
         */
        $Tooltip = $('<div class="Tooltip ' + TongueClass + ' ' + TooltipPosition + '"></div>');
        $TooltipContent.html(TooltipContent);
        $Tooltip.append($TooltipContent);

        Offset = $Element.offset();

        $TooltipContainer
            .empty()
            .append($Tooltip)
            .show();

        if ( Core.Config.Get('SessionName') === Core.Config.Get('CustomerPanelSessionName') ) {
            TooltipOffsetLeft = 48;
            TooltipOffsetTop = 40;
        }

        if (TooltipPosition === 'TongueBottom') {
            TopOffset = Offset.top + TooltipOffsetTop;
        }
        else if (TooltipPosition === 'TongueTop') {
            TopOffset = Offset.top + $Element.height() - $TooltipContainer.height() - TooltipOffsetTop + TongueHeight;
        }

        $TooltipContainer
            .css('left', Offset.left + TooltipOffsetLeft)
            .css('top', TopOffset);
    };

    /**
     * @name HideTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @description
     *      This function hides the tooltip for an element.
     */
    TargetNS.HideTooltip = function() {
        $('#' + TooltipContainerID).hide().empty();
    };

    /**
     * @name InitTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The elements (within a jQuery object) for whom the tooltips are initialized.
     * @param {String} TooltipContent - Content of the tooltip, may contain HTML.
     * @description
     *      This function initializes the tooltips on an input field.
     */
    TargetNS.InitTooltip = function ($Element, TooltipContent) {
        $Element
        .off('focus.Tooltip')
        .on('focus.Tooltip', function () {
            TargetNS.ShowTooltip($Element, TooltipContent);
        });

        $Element.off('blur.Tooltip').on('blur.Tooltip', TargetNS.HideTooltip);
    };

    /**
     * @name RemoveTooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The elements (within a jQuery object) for whom the tooltips are removed.
     * @description
     *      This function removes the tooltip from an input field.
     */
    TargetNS.RemoveTooltip = function ($Element) {
        TargetNS.HideTooltip();
        $Element.off('focus.Tooltip');
        $Element.off('blur.Tooltip');
    };

    /**
     * @private
     * @name ShowRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {Object} Event - The event object.
     * @description
     *      This function shows the tooltip for a rich text editor.
     */
    function ShowRTETooltip(Event) {
        TargetNS.ShowTooltip($('#cke_' + Event.listenerData.ElementID + ' .cke_contents'), Event.listenerData.Message);
    }

    /**
     * @private
     * @name RemoveRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @description
     *      This function remove the tooltip from a rich text editor.
     */
    function RemoveRTETooltip() {
        TargetNS.HideTooltip();
    }

    /**
     * @name InitRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The RTE element for whom the tooltips are initialized.
     * @param {String} Message - The string content that will be show in tooltip.
     * @description
     *      This function initializes the necessary stuff for a tooltip in a rich text editor.
     */
    TargetNS.InitRTETooltip = function ($Element, Message) {

        var ElementID = $Element.attr('id');
        CKEDITOR.instances[ElementID].on('focus', ShowRTETooltip, null, {ElementID: ElementID, Message: Message});
        CKEDITOR.instances[ElementID].on('blur', RemoveRTETooltip, null, ElementID);
    };

    /**
     * @name RemoveRTETooltip
     * @memberof Core.Form.ErrorTooltips
     * @function
     * @param {jQueryObject} $Element - The RTE element for whom the tooltips are removed.
     * @description
     *      This function removes the tooltip in a rich text editor.
     */
    TargetNS.RemoveRTETooltip = function ($Element) {
        var ElementID = $Element.attr('id');
        CKEDITOR.instances[ElementID].removeListener('focus', ShowRTETooltip);
        CKEDITOR.instances[ElementID].removeListener('blur', RemoveRTETooltip);
        TargetNS.HideTooltip();
    };

    return TargetNS;
}(Core.Form.ErrorTooltips || {}));
