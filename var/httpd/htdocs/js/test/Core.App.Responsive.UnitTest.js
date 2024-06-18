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
Core.App = Core.App || {};

Core.App.Responsive = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        QUnit.module('Core.App.Responsive');

        QUnit.test('IsSmallerOrEqual', function(Assert){
            Assert.expect(4);

            Assert.ok(Core.App.Responsive.IsSmallerOrEqual('ScreenL', 'ScreenXL'));
            Assert.ok(Core.App.Responsive.IsSmallerOrEqual('ScreenXS', 'ScreenL'));
            Assert.ok(Core.App.Responsive.IsSmallerOrEqual('ScreenM', 'ScreenM'));
            Assert.ok(!Core.App.Responsive.IsSmallerOrEqual('ScreenL', 'ScreenM'));
        });
    };

    return Namespace;
}(Core.App.Responsive || {}));
