// --
// Copyright (C) 2021 Perl-Services.de, https://perl-services.de
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};

Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};
Core.Agent.Admin.ProcessManagement = Core.Agent.Admin.ProcessManagement || {};

Core.Agent.Admin.ProcessManagement.TransitionActionParameters = (function (TargetNS) {
    function ClearParameters() {
        $('#ConfigParams input[name^="ConfigKey"]').each( function ( i, field ) {
            let $field = $(field);
            if ( $field.attr('id') === "ConfigKey[1]" ) {
                return;
            }
            $field.parent().remove();
        });
        
        $('#ConfigKey[1]').val('');
        $('#ConfigValue[1]').val('');
    }

    function SetParameters ( Module ) {
        let Data = {
            TransitionAction: Module,
            Action: 'AdminProcessManagementTransitionAction',
            Subaction: 'ActionParams',
        };

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function ( Response ) {
                var ParameterList = $('<ul></ul>');

                $.each( Response.Params, function ( ParamIndex, Param ) {

                    ParameterList.append(
                        $('<li></li>').text( Param.Key + ' - ' + Param.Value )
                    );

                    if ( Response.NoOptionals && Param.Optional ) {
                        return;
                    }

                    var ConfigParamHTML;

                    if ( ParamIndex != 0 ) {
                        ConfigParamHTML = $('#ConfigParamContainer').html().replace(/_INDEX_/g, parseInt(ParamIndex) + 1);
                    }
                    else {
                        ConfigParamHTML = $('#ConfigAdd').closest('.WidgetSimple').find('.Content fieldset').last();
                    }

                    let $ParamElem = $(ConfigParamHTML);
            
                    $ParamElem.find('input[name^="ConfigKey"]').val( Param.Key );
                    $ParamElem.find('input[name^="ConfigValue"]').attr( 'placeholder', Param.Value );

                    if ( ParamIndex != 0 ) {
                        let LastField = $('#ConfigAdd').closest('.WidgetSimple').find('.Content fieldset').last();
                        $ParamElem.insertAfter(LastField);
                    }
                });

                $('#ConfigParams').append(
                    $('<div></div>', { id: 'ParameterList' } )
                        .append( $('<br>' ) )
                        .append( $('<h2></h2>').text('All Parameters') )
                        .append( ParameterList )
                );
            }
        );
    }

    TargetNS.Init = function() {
        $('#Module').on('change', function () {
            let Module = $('#Module option:selected').val();

            // check if user has already filled some parameter fields


            // clear parameters
            ClearParameters();
            $('#ParameterList').remove();

            if ( !Module || Module === '' ) {
                return;
            }

            // request list of parameters
            SetParameters( Module );
        });
    };
    
    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.ProcessManagement.TransitionActionParameters || {})); 

