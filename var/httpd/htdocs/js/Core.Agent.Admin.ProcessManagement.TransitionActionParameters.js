// --
// OTOBO is a web-based ticketing system for service organisations.
// --
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
Core.Agent.Admin = Core.Agent.Admin || {};
Core.Agent.Admin.ProcessManagement = Core.Agent.Admin.ProcessManagement || {};

/**
 * @namespace Core.Agent.Admin.ProcessManagement.TransitionActionParameter
 * @memberof Core.Agent.Admin.ProcessManagement
 * @author
 * @description
 *     This namespace contains the special module functions for the ProcessManagement module.
 */
Core.Agent.Admin.ProcessManagement.TransitionActionParameters = (function (TargetNS) {

    /**
     * @private
     * @name ClearParameters
     * @memberof Core.Agent.Admin.ProcessManagement.TransitionActionParameters
     * @function
     * @description
     *      Removes the paremeters in the dalog
     */
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

    /**
     * @private
     * @name SetParameters
     * @memberof Core.Agent.Admin.ProcessManagement.TransitionActionParameters
     * @function
     * @description
     *      Retrieves the parameter list from the backend and
     *      shows the parameters in the dialog
     */
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

    /**
     * @name Init
     * @memberof Core.Agent.Admin.ProcessManagement.TransitionActionParameters
     * @function
     * @description
     *      This function initializes the module functionality.
     */
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
