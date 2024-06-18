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

Core.Data = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Data');
        QUnit.test('Core.Data.Set()', function(Assert){

            /*
             * Create a div containter for the tests
             */
            var Sign, ObjectOne, ObjectTwo, ResultOneEmpty, NonexistingResult,
                ResultOne, ResultTwo,
                ObjectThree, ObjectFour, ResultCompare,
                $TestDiv = $('<div id="Container"></div>');
            $TestDiv.append('<span id="ElementOne"></span>');
            $TestDiv.append('<span id="ElementTwo"></span>');
            $('body').append($TestDiv);

            /*
             * Run the tests
             */

            Assert.expect(9);

            Sign = 'Save This Information';
            ObjectOne = $('#ElementOne');
            ObjectTwo = $('#ElementTwo');

            ResultOneEmpty = Core.Data.Get(ObjectOne, 'One');
            Assert.deepEqual(ResultOneEmpty, {}, 'information not yet stored');

            NonexistingResult = Core.Data.Get($('#nonexisting_selector'), 'One');
            Assert.deepEqual(NonexistingResult, {}, 'nonexisting element');

            Core.Data.Set(ObjectOne, 'One', Sign);
            Core.Data.Set(ObjectTwo, 'Two', Sign);

            ResultOne = Core.Data.Get(ObjectOne, 'One');
            ResultTwo = Core.Data.Get(ObjectTwo, 'Two');

            Assert.equal(ResultOne, Sign, 'okay');
            Assert.equal(ResultTwo, Sign, 'okay');
            Assert.equal(ResultOne, ResultTwo, 'okay');

            /* test CopyObject and CompareObject functions */
            ObjectThree = {
                "ItemOne": "abcd"
            };

            ObjectFour = Core.Data.CopyObject(ObjectThree);
            Assert.deepEqual(ObjectThree, ObjectFour, 'okay');

            ResultCompare = Core.Data.CompareObject(ObjectThree, ObjectFour);
            Assert.equal(ResultCompare, true, 'okay');

            ObjectThree.ItemTwo = "1234";
            Assert.notDeepEqual(ObjectThree, ObjectFour, 'okay');

            ResultCompare = Core.Data.CompareObject(ObjectThree, ObjectFour);
            Assert.equal(ResultCompare, false, 'okay');

             /*
             * Cleanup div container and contents
             */
            $('#Container').remove();
        });
    };

    return Namespace;
}(Core.Data || {}));
