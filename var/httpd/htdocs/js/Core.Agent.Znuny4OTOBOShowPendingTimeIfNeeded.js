// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
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

var Core   = Core       || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Znuny4OTOBOShowPendingTimeIfNeeded
 * @description
 *      This namespace contains the special module functions for Znuny4OTOBOShowPendingTimeIfNeeded.
 */
Core.Agent.Znuny4OTOBOShowPendingTimeIfNeeded = (function (TargetNS) {
    var PendingStates = [];
    TargetNS.Init = function (Param) {

        var ParamCheckSuccess = true;
        $.each([ 'PendingStates' ], function (Index, ParameterName) {
            if (!Param[ ParameterName ]) {
                ParamCheckSuccess = false;
            }
        });
        if (!ParamCheckSuccess) {
            return false;
        }
        PendingStates = Param.PendingStates;
        $('#NextStateID, #NewStateID, #StateID, #ComposeStateID').on('change', TargetNS.TogglePendingState);


        TargetNS.TogglePendingState();

        return true;
    }

    TargetNS.TogglePendingState = function () {

        var StateID = $('#NextStateID, #NewStateID, #StateID, #ComposeStateID').val();

        // check if state exists in the pending state list.
        // do not use $.inArray see issue #1
        var StateFound = false;
        $.each(PendingStates, function(index, PendingStateID) {
            if (PendingStateID != StateID) return true;
            StateFound = true;
            return false;
        });

        if (StateFound) {
            $('#Month').parent().prev().show();
            $('#Month').parent().show();
        }
        else {
            $('#Month').parent().prev().hide();
            $('#Month').parent().hide();
        }
        return true;
    }

    return TargetNS;
}(Core.Agent.Znuny4OTOBOShowPendingTimeIfNeeded || {}));
