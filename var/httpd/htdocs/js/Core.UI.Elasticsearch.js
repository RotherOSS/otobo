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
 * @namespace Core.UI.Elasticsearch
 * @memberof Core.UI
 * @author Rother OSS
 * @description
 *      This namespace contains the special module functions for CustomerInformationCenter.
 */
Core.UI.Elasticsearch = (function (TargetNS) {

    /**
     * @private
     * @name MinSearch
     * @memberof Core.UI.ElasticSearch
     * @description
     *      Minimum length of search string which induces a search.
    */
    var MinSearch = 2;

    /**
     * @name InitSearchField
     * @memberof Core.UI.Elasticsearch
     * @param {jQueryObject} $InputField
     * @param {String} Action
     * @description
     *      This function initializes an Elasticsearch search field.
     */
    TargetNS.InitSearchField = function ( $InputField, Action ) {

        // handle searches on input
        $InputField.on('input', function() {

            // if the dialog already exists, use it
            var $Dialog = $('div.Dialog:visible');

            // get the current input length
            var FulltextESValue = $InputField.val();
            if ( typeof FulltextESValue == 'undefined' ){
                FulltextESValue = '';
            }
            var LengthFulltext = FulltextESValue.length;

            // close an existing dialog, if the search string is less than MinSearch characters long
            if ( typeof $Dialog[0] != 'undefined' && LengthFulltext < MinSearch ) {
                Core.UI.Dialog.CloseDialog( $Dialog );
            }

            // else update the dialog
            else if ( LengthFulltext >= MinSearch ) {
                UpdateDialog( $InputField, Action, FulltextESValue );
            }

        });

        // delete input on blur, if the dialog is not open
        $InputField.on('blur', function() {
            var $Dialog = $('div.Dialog:visible');
            if ( typeof $Dialog[0] == 'undefined' ) {
                $InputField.val('');
            }
        });

        // delete input on closing the dialog, if InputField is not focused
        Core.App.Subscribe('Event.UI.Dialog.CloseDialog.Close', function () {
            if ( !$InputField.is(':focus') ) {
                $InputField.val('');
            }
        });

    };

    /**
     * @private
     * @name UpdateDialog
     * @memberof Core.UI.Elasticsearch
     * @function
     * @param {jQueryObject} $InputField
     * @param {String} Action
     * @param {String} FulltextESValue
     * @description
     *      Updates the Elasticsearch quick result dialog.
     */
    function UpdateDialog( $InputField, Action, FulltextESValue ){

        var URL = Core.Config.Get('Baselink'),
            Data = {
                Action: Action,
                Subaction: 'SearchUpdate',
                FulltextES: FulltextESValue,
            };

        // initiate the AJAX call
        Core.AJAX.FunctionCall(
            URL,
            Data,
            function ( Response ) {

                var CurrentESValue = $InputField.val();

                // check whether the results still matches the current input
                if ( FulltextESValue == CurrentESValue ) {

                    var $Dialog = $('div.Dialog:visible');

                    // open a new dialog, if it doesn't exist
                    if ( typeof $Dialog[0] == 'undefined' ) {
                        OpenDialog( Response );
                        $InputField.focus();
                    }

                    // update the dialog
                    $('#oooESOuter').html(Response);
                }

            },
            'html'
        );

    }

    /**
     * @private
     * @name OpenDialog
     * @memberof Core.UI.Elasticsearch
     * @function
     * @param {String} Response
     * @description
     *      Opens the Elasticsearch quick result dialog.
     */
    function OpenDialog( Response ) {

        var CustomerInterface = Core.Config.Get('SessionName') === Core.Config.Get('CustomerPanelSessionName');

        // define and open the dialog for the customer interface
        if ( CustomerInterface ) {
            var MinWidth      = $(window).width() > 767 ? '400px' : '320px';
            var Fullsize      = $(window).width() > 767 ? '' : 'width: 100vw;';
            var HTML          = "<div id='oooESOuter' style='" + Fullsize + "min-width: " + MinWidth + "'>" + Response + "</div>";
            var PosRight      = $(window).width() > 767 ? '120px' : '0px';
            var PosTop        = $(window).width() > 767 ? '120px' : '192px';
            var DialogOptions = {
                HTML: HTML,
                Title: Core.Language.Translate('Results'),
                PositionTop: PosTop,
                PositionRight: PosRight,
                Modal: true,
                CloseOnClickOutside: false,
                CloseOnEscape: true,
                AllowAutoGrow: false,
            };

            Core.UI.Dialog.ShowDialog( DialogOptions );

            if ( $(window).width() < 768 ) {
                // move the overlay to keep access to the input field
                $('#Overlay').css('top','201.5px');
            }

        }

        // define and open the dialog for the agent interface
        else {
            var HTML          = "<div id='oooESOuter' style='min-width: 500px'>" + Response + "</div>";
            var DialogOptions = {
                HTML: HTML,
                Title: Core.Language.Translate('Results'),
                PositionTop: '100px',
                PositionLeft: 'Center',
                Modal: true,
                CloseOnClickOutside: false,
                CloseOnEscape: true,
                AllowAutoGrow: false,
            };

            Core.UI.Dialog.ShowDialog( DialogOptions );

            // move the overlay to keep access to the input field
            $('#Overlay').css('top','94px');
        }

    };

    return TargetNS;
}(Core.UI.Elasticsearch || {}));
