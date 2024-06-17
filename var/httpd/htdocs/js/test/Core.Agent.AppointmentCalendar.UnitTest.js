// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

Core.Agent.AppointmentCalendar = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.Agent.AppointmentCalendar');

        QUnit.test('CollapseValues in AppointmentCalendar Edit', function(Assert){

            var ExpectedTeamValues = 'T1<br>T2<br><a href="#" class="DialogTooltipLink">' + Core.Language.Translate('+%s more', 5) + '</a>',
            ExpectedResourceValues = 'A1<br>A2<br><a href="#" class="DialogTooltipLink">'
            + Core.Language.Translate('+%s more', 3) + '</a>';

            $('<fieldset class="TableLike">' +
            '<legend><span>Resource</span></legend>' +
            '<label for="TeamID">Team:</label>'+
            '<div class="Field">'+

               ' <p id="TeamID" class="ReadOnlyValue">T1<br>T2<br>T3<br>T4<br>T5<br>T6<br></p>'+
            '</div>'+
            '<div class="Clear"></div>'+
            '<label for="ResourceID">Agent:</label>'+
           ' <div class="Field">'+
                '<p id="ResourceID" class="ReadOnlyValue">A1<br>A2<br>A3<br>A4<br></p>'+
            '</div>'+
       ' </fieldset>').appendTo('body');



            Assert.expect(2);

            Core.Agent.AppointmentCalendar.TeamInit($('#TeamID'), $('#ResourceID'), $('label[for="TeamID"] + div.Field p.ReadOnlyValue'), $('label[for="ResourceID"] + div.Field p.ReadOnlyValue'));

            Assert.deepEqual($('#TeamID').html(), ExpectedTeamValues, 'CollapseTeamValues');
            Assert.deepEqual($('#ResourceID').html(), ExpectedResourceValues, 'CollapseResourceValues');


        });
    };

    return Namespace;
}(Core.Agent.AppointmentCalendar || {}));
