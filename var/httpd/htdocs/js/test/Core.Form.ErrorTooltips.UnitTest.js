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
Core.Form = Core.Form || {};

Core.Form.ErrorTooltips = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Form.ErrorTooltips');
        QUnit.test('Core.Form.ErrorTooltip()', function(Assert){
            var $TestForm = $('<form id="TestForm" class="Validate"></form>'),
                ErrorTooltipMessage = 'UT Error Tooltip message',
                ErrorTooltipID = '#OTOBO_UI_Tooltips_ErrorTooltip',
                TestFieldElement;

            Assert.expect(9);

            /*
             * Create a form container for the test
             */
            $TestForm.append('<div class="Field">');
            $TestForm.append('<input class="Validate_Required" type="text" name="TestField" id="TestField" value=""/>');
            $TestForm.append('</div>');

            $('body').append($TestForm);
            TestFieldElement = $('#TestForm').find("input");

            /*
             * Run the test
             */
            // Test ShowToolTip() function
            Core.Form.ErrorTooltips.ShowTooltip(TestFieldElement, ErrorTooltipMessage);
            Assert.ok($(ErrorTooltipID).find('div:eq(1)').length, 'Found ErrorTooltip on ShowTooltip()');
            Assert.equal($(ErrorTooltipID).find('div:eq(1)').text(), ErrorTooltipMessage, 'ErrorTooltip message is correct');

            // Test HideTooltip() function
            Core.Form.ErrorTooltips.HideTooltip();
            Assert.notOk($(ErrorTooltipID).find('div:eq(1)').length, 'Not found ErrorTooltip on HideTooltip()');

            // Test InitTooltip() function
            Core.Form.ErrorTooltips.InitTooltip(TestFieldElement, ErrorTooltipMessage);
            Assert.notOk($(ErrorTooltipID).find('div:eq(1)').length, 'Not found ErrorTooltip on InitTooltip() without focus on the field');

            // Put focus on test field
            $('#TestField').triggerHandler('focus');
            Assert.ok($(ErrorTooltipID).find('div:eq(1)').length, 'Found ErrorTooltip on InitTooltip() with focus on the field');
            Assert.equal($(ErrorTooltipID).find('div:eq(1)').text(), ErrorTooltipMessage, 'ErrorTooltip message is correct');

            // Remove focus from test field
            $('#TestField').triggerHandler('blur');
            Assert.notOk($(ErrorTooltipID).find('div:eq(1)').length, 'Not found ErrorTooltip on InitTooltip() when focus is removed again');

            // Test RemoveTooltip() function
            Core.Form.ErrorTooltips.RemoveTooltip(TestFieldElement);
            Assert.notOk($(ErrorTooltipID).find('div:eq(1)').length, 'Not found ErrorTooltip on RemoveTooltip() without focus on the field');

            // Put focus on test field
            $('#TestField').triggerHandler('focus');
            Assert.notOk($(ErrorTooltipID).find('div:eq(1)').length, 'Not found ErrorTooltip on RemoveTooltip() with focus on the field');

            /*
             * Cleanup div container and contents
             */
            $('#TestForm').remove();
        });
    };

    return Namespace;
}(Core.Form.ErrorTooltips || {}));
