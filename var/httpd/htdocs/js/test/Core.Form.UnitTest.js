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

Core.Form = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Form');
        QUnit.test('Core.Form.DisableForm() and Core.Form.EnableForm()', function(Assert){

            /*
             * Create a form containter for the tests
             */
            var $TestForm = $('<form id="TestForm"></form>'), Checkboxes, CheckboxesSelected;
            $TestForm.append('<input type="text" value="ObjectOne" id="ObjectOne" name="ObjectOne" />');
            $TestForm.append('<input type="text" readonly data-initially-readonly="readonly" value="ObjectOne" id="ObjectOne" name="ObjectOne" />');
            $TestForm.append('<input type="password" value="ObjectTwo" id="ObjectTwo" name="ObjectTwo" />');
            $TestForm.append('<input type="checkbox" value="ObjectThree" id="ObjectThree" name="ObjectThree" />');
            $TestForm.append('<input type="radio" value="ObjectFour" id="ObjectFour" name="ObjectFour" />');
            $TestForm.append('<input type="file" value="" id="ObjectFive" name="ObjectFive" />');
            $TestForm.append('<input type="hidden" value="ObjectSix" id="ObjectSix" name="ObjectSix" />');
            $TestForm.append('<textarea id="ObjectSeven" name="ObjectSeven">ObjectSeven</textarea>');
            $TestForm.append('<select id="ObjectEight" name="ObjectEight"><option value="1">EightOne</option><option value="2">EightTwo</option></select>');
            $TestForm.append('<button value="ObjectNine" type="submit" id="ObjectNine">ObjectNine</button>');
            $TestForm.append('<button value="ObjectTen" type="button" id="ObjectTen">ObjectTen</button>');
            $TestForm.append('<button value="ObjectTen" type="button" disabled data-initially-disabled="disabled" id="ObjectTen">ObjectTen</button>');
            $TestForm.append('<input type="checkbox" name="ItemsSelected" id="SelectAllItemsSelected"  value="" />');
            $TestForm.append('<input type="checkbox" name="ItemsSelected" id="CheckboxOne" value="CheckboxOne" />');
            $TestForm.append('<input type="checkbox" name="ItemsSelected" id="CheckboxTwo" value="CheckboxTwo" />');
            $TestForm.append('<input type="checkbox" name="ItemsSelected" id="CheckboxThree" value="CheckboxThree" />');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            /*
             * Disable a form containter
             */
            Core.Form.DisableForm($('#TestForm'));

            Assert.expect(42);

            Assert.equal($('#TestForm').hasClass("AlreadyDisabled"), true, 'Form is already disabled');

            $.each($('#TestForm').find("input, textarea, select, button"), function() {


                var readonlyValue = $(this).attr('readonly');
                var tagnameValue = $(this).prop('tagName');
                var typeValue = $(this).attr('type');
                var disabledValue = $(this).attr('disabled');

                if (tagnameValue === "BUTTON") {
                    Assert.equal(disabledValue, 'disabled', 'disabledValue for BUTTON');
                }
                else {
                    if (typeValue === "hidden") {
                        Assert.equal(readonlyValue, undefined, 'readonlyValue for ' + tagnameValue);
                    }
                    else {
                        Assert.equal(readonlyValue, 'readonly', 'readonlyValue for ' + tagnameValue);
                    }
                }
            });


            /*
             * Enable a form containter
             */
            Core.Form.EnableForm($('#TestForm'));

            Assert.equal($('#TestForm').hasClass("AlreadyDisabled"), false, 'Form is not already disabled');

            $.each($('#TestForm').find("input, textarea, select, button"), function() {

                var readonlyValue = $(this).attr('readonly');
                var tagnameValue = $(this).prop('tagName');
                var typeValue = $(this).attr('type');
                var disabledValue = $(this).attr('disabled');
                var expectedDisabledValue = $(this).data('initially-disabled') ? 'disabled' : undefined;
                var expectedReadonlyValue = $(this).data('initially-readonly') ? 'readonly' : undefined;


                if (tagnameValue === "BUTTON") {
                    Assert.equal(disabledValue, expectedDisabledValue, 'enabledValue for BUTTON');
                }
                else {
                    if (typeValue === "hidden") {
                        Assert.equal(readonlyValue, expectedReadonlyValue, 'readonlyValue for ' + tagnameValue);
                    }
                    else {
                        Assert.equal(readonlyValue, expectedReadonlyValue, 'readonlyValue for ' + tagnameValue);
                    }
                }
            });

            /*
             * Select all checkboxes
             */

            // initialize "SelectAll" checkbox and bind click event on "SelectAll" for each relation item
            Core.Form.InitSelectAllCheckboxes($('input[type="checkbox"][name=ItemsSelected]'), $('#SelectAllItemsSelected'));

            $('input[type="checkbox"][name=ItemsSelected]').click(function () {
                Core.Form.SelectAllCheckboxes($(this), $('#SelectAllItemsSelected'));
            });

            // select all checkbox in group
            $('#SelectAllItemsSelected').click();

            Checkboxes = [ 'SelectAllItemsSelected', 'CheckboxOne', 'CheckboxTwo', 'CheckboxThree'];

            // check if there are all check boxes selected
            $.each(Checkboxes, function() {
                var expectedSelectedValue = $('#' + this).is(":checked") ? 'checked' : undefined;
                Assert.equal(expectedSelectedValue, 'checked', 'Selected for ' + this);
            });

            // deselect one checkbox in the group
            $('#CheckboxTwo').click();

            CheckboxesSelected =
            { 'SelectAllItemsSelected': false,
              'CheckboxOne': true,
              'CheckboxTwo': false,
              'CheckboxThree': true
            };

            $.each(CheckboxesSelected,function(index, value){
                var expectedSelectedValue = $('#' + index).is(":checked");
                var testMessageSelected =  expectedSelectedValue ? 'Selected' : 'Deselected';

                Assert.equal(expectedSelectedValue, value, testMessageSelected + ' for ' + index);
            });

            /*
             * Cleanup div container and contents
             */
            $('#TestForm').remove();
        });
    };

    return Namespace;
}(Core.Form || {}));
