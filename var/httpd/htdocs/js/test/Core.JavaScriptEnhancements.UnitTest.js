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

Core.JavaScriptEnhancements = {};
Core.JavaScriptEnhancements.RunUnitTests = function(){

    QUnit.module('Core.JavaScriptEnhancements');

    QUnit.test('isJQueryObject()', function(Assert){
        Assert.expect(6);

        Assert.equal(isJQueryObject($([])), true, 'empty jQuery object');
        Assert.equal(isJQueryObject($('body')), true, 'simple jQuery object');
        Assert.equal(isJQueryObject({}), false, 'plain object');
        Assert.equal(isJQueryObject(undefined), false, 'undefined');
        Assert.equal(isJQueryObject($([]), $([])), true, 'multiple');
        Assert.equal(isJQueryObject($([]), $([]), {}), false, 'multiple, one plain object');
    });
};
