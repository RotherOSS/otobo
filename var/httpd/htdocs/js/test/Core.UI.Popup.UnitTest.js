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
Core.UI = Core.UI || {};

Core.UI.Popup = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.UI.Popup');

        QUnit.test('PopupProfiles', function(Assert){

            var ExpectedProfiles = {
                'Default': {
                    WindowURLParams: "dependent=yes,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no",
                    Left: 100,
                    Top: 100,
                    Width: 1040,
                    Height: 700
                }
            };

            Assert.expect(2);

            Assert.deepEqual(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Default profile list');

            ExpectedProfiles.CustomLarge = "dependent=yes,height=700,left=100,top=100,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000";

            Core.UI.Popup.ProfileAdd('CustomLarge', ExpectedProfiles.CustomLarge);

            Assert.deepEqual(Core.UI.Popup.ProfileList(), ExpectedProfiles, 'Modified profile list');
        });
    };

    return Namespace;
}(Core.UI.Popup || {}));
