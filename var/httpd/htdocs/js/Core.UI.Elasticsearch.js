/* OTOBO is a web-based ticketing system for service organisations.

Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
*/

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


    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Language.Translate('Loading...') + '"></span></div>', Core.Language.Translate('Loading...'), '100px', '400px', false);
        $('.Dialog').css('width','550px');
    }
  
    function OnClick( $Input, Action ){
        var $Dialog = $('div.Dialog:visible');
        var FulltextESValue = $Input.val();
        if ( typeof FulltextESValue == 'undefined' ){
            FulltextESValue = '';
        }
        var LengthFulltext = FulltextESValue.length;

        // if dialog is not visible and the inputfield is filled open it and start to search
        if( typeof $Dialog[0] == 'undefined' ){
            if( LengthFulltext > 1 ){
                TargetNS.OpenElasticsearchQuickResultDialog( Action );
                $('#oooESOuter').removeClass('oooEmpty');
                var URL = Core.Config.Get('Baselink'),
                    Data = {
                        Action: Action,
                        Subaction: 'SearchUpdate',
                        FulltextES: FulltextESValue, 
                    };
                GetResult(URL, Data); 
                return false;
            }
        }
        else if ( LengthFulltext < 2 ) {
            $('#oooESOuter').addClass('oooEmpty');
            Core.UI.Dialog.CloseDialog( $('div.Dialog:visible') );
            return false;
        }

    }
 
    TargetNS.InitSearchField = function ( $Input, Action ) {

        if (Core.Config.Get('SessionName') === Core.Config.Get('CustomerPanelSessionName')){
            // on click event if customer interface
            OnClick( $Input, Action);
        }else{
            // on click event if agent interface
            $Input.on('click', function() {
                OnClick( $Input, Action);
            });
        }

        // on input event
        $Input.on('input', function() {
            var $Dialog = $('div.Dialog:visible');
            var FulltextESValue = $Input.val();
            if ( typeof FulltextESValue == 'undefined' ){
                FulltextESValue = '';
            }
            var LengthFulltext = FulltextESValue.length;

            if ( typeof $Dialog[0] != 'undefined' ) {
                // if text parameter is longer than 1, then perform query
                if( LengthFulltext > 1 ){ 
                    $('#oooESOuter').removeClass('oooEmpty');
                    var URL = Core.Config.Get('Baselink'),
                        Data = {
                            Action: Action,
                            Subaction: 'SearchUpdate',
                            FulltextES: FulltextESValue, 
                        };
                    GetResult(URL, Data); 
                    return false;
                // otherwise delete results 
                }else if ( LengthFulltext < 2 ){
                    $('#oooESOuter').addClass('oooEmpty');
                    Core.UI.Dialog.CloseDialog( $('div.Dialog:visible') );
                    return false;
                }
            }

            // open the dialog if it is not yet open
            else if ( LengthFulltext > 1 ) {
                TargetNS.OpenElasticsearchQuickResultDialog( Action );
                $('#oooESOuter').removeClass('oooEmpty');
                var URL = Core.Config.Get('Baselink'),
                    Data = {
                        Action: Action,
                        Subaction: 'SearchUpdate',
                        FulltextES: FulltextESValue, 
                    };
                GetResult(URL, Data); 
                return false;
            }
        });
    }; 

    TargetNS.OpenElasticsearchQuickResultDialog = function ( Action ) {

        var Data = {
            Action: Action
        };
        var CustomerInterface = Core.Config.Get('SessionName') === Core.Config.Get('CustomerPanelSessionName');

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function ( Response ) {

                var DialogOptions;
                if ( CustomerInterface ) {
                    var HTML      = "<div id='oooESOuter' style='min-width: 400px'>" + Response + "</div>";
                    var PosRight  = $(window).width() > 520 ? '120px' : '0px';
                    DialogOptions = {
                        HTML: HTML,
                        Title: Core.Language.Translate('Results'),
                        PositionTop: '120px',
                        PositionRight: PosRight,  
                        Modal: true,
                        CloseOnClickOutside: false,
                        CloseOnEscape: true,
                        AllowAutoGrow: false,
                    }; 
                    Core.UI.Dialog.ShowDialog( DialogOptions );

                } else {
                    var HTML      = "<div id='oooESOuter' style='min-width: 500px'>" + Response + "</div>";
                    DialogOptions = {
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

                    $('#Overlay').css('top','94px');
                }

            }, 'html'
        );

    };

    function GetResult( URL, Data ){
        Core.AJAX.FunctionCall(
            URL,
            Data,
            function ( Response ) {

                $('#oooESOuter:not(.oooEmpty)').html(Response);

            }, 'html'
        );

    }


    /**
     * @name Init
     * @memberof Core.UI.Elasticsearch
     * @function
     * @description
     *      This function binds click event for opening search dialog.
     */
    TargetNS.Init = function () {
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.UI.Elasticsearch || {}));
