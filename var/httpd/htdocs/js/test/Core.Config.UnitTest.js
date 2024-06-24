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
Core.Config = Core.Config || {};

Core.Config = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Config');
        QUnit.test('Core.Config.Get()', function(Assert){
            var ConfigTest = 'Test value';

            Assert.expect(6);

            Core.Config.Set('Test', ConfigTest);
            Assert.deepEqual(Core.Config.Get('Test'), ConfigTest);

            Core.Config.Set('RichText.Test', ConfigTest);
            Assert.deepEqual(Core.Config.Get('RichText.Test'), ConfigTest);

            Core.Config.Set('RichText.Test2', ConfigTest);
            Assert.deepEqual(Core.Config.Get('RichText.Test2'), ConfigTest);

            Assert.deepEqual(Core.Config.Get('non.existing.dummy.ns'), undefined);

            Assert.deepEqual(Core.Config.Get('EasyName', 42), 42, "Test for default value");

            Assert.deepEqual(Core.Config.Get('non.existing.dummy.ns', 'DefaultValueTest'), 'DefaultValueTest', "Test for default value 2");
        });

        QUnit.test('Core.Config.AddConfig()', function(Assert){

            var ConfigTest = {
                Width: 600,
                Height: 400,
                Name: 'Test'
            };

            Assert.expect(3);

            Core.Config.AddConfig(ConfigTest, 'RichText');
            Assert.deepEqual(Core.Config.Get('RichText'), ConfigTest);

            Core.Config.AddConfig(ConfigTest, 'RichText.Details');
            Assert.deepEqual(Core.Config.Get('RichText.Details'), ConfigTest);

            ConfigTest = '{"Width":"600","Height":"400","Name":"Test"}';

            Core.Config.AddConfig(ConfigTest, 'RichText.JSONStuff');
            Assert.deepEqual(Core.Config.Get('RichText.JSONStuff'), ConfigTest);
        });
    };

    return Namespace;
}(Core.Config || {}));
