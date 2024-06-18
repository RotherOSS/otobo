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

Core.Template = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Template');
        QUnit.test('Core.Template.Render()', function(Assert){

            var Templates = {
                'Basetemplate' : 'Basetemplate with {{one}}, {{two}}, {{three}}.',
                'Translation'  : 'Another template with {{"User" | Translate}}',
                'TranslationComplex' : 'Another template with {{"User with %s and %s" | Translate("1", "2")}}',
                'TranslationComplexWithData' : 'Another template with {{"User with %s and %s" | Translate(var_1, var_2)}}'
            };

            Core.Template.Init();

            // manually load the template
            Core.Template.Load(Templates);

            // load manually to check if the filter works correctly
            Core.Language.Load({}, {
                'User' : 'Benutzer',
                'User with %s and %s' : 'Benutzer mit %s und %s'
            });

            Assert.equal(Core.Template.Render('Basetemplate', { 'one' : '1', 'two' : '2', 'three' : '3' }), 'Basetemplate with 1, 2, 3.');
            Assert.equal(Core.Template.Render('Translation', {}), 'Another template with Benutzer');
            Assert.equal(Core.Template.Render('TranslationComplex', {}), 'Another template with Benutzer mit 1 und 2');
            Assert.equal(Core.Template.Render('TranslationComplexWithData', { 'var_1' : 'var_1_result', 'var_2' : 'var_2_result' }), 'Another template with Benutzer mit var_1_result und var_2_result');
        });
    };

    return Namespace;
}(Core.Template || {}));
