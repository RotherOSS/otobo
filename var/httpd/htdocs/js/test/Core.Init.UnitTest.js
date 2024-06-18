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
Core.Init = Core.Init || {};

Core.Init = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Init');

        QUnit.test('Register and init namespaces', function (Assert) {
            Core.Init.Teststring = "";

            Assert.expect(3);

            Core.UnitTest1 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "1";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');
                return TargetNS;
            }(Core.UnitTest1 || {}));

            // testing sorting
            Core.UnitTest2 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "2";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');
                return TargetNS;
            }(Core.UnitTest2 || {}));

            Core.UnitTest3 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "3";
                };
                Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');
                return TargetNS;
            }(Core.UnitTest3 || {}));

            Core.UnitTest4 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "4";
                };
                Core.Init.RegisterNamespace(TargetNS, 'FINISH');
                return TargetNS;
            }(Core.UnitTest4 || {}));

            Core.UnitTest5 = (function (TargetNS) {
                TargetNS.Init = function () {
                    Core.Init.Teststring += "5";
                };
                Core.Init.RegisterNamespace(TargetNS, 'FINISH');
                return TargetNS;
            }(Core.UnitTest5 || {}));

            // empty call does nothing
            Core.Init.ExecuteInit();
            Assert.equal(Core.Init.Teststring, "");

            // calling first block
            Core.Init.ExecuteInit('APP_GLOBAL');
            Assert.equal(Core.Init.Teststring, "123");

            // calling second block
            Core.Init.ExecuteInit('FINISH');
            Assert.equal(Core.Init.Teststring, "12345");
        });
    };

    return Namespace;
}(Core.Init || {}));
