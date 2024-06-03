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

Core.Language = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        var TranslationData = {
            'yes':                          'ja',
            'no':                           'nein',
            'This is %s':                   'Das ist %s',
            'Complex %s with %s arguments': 'Komplexer %s mit %s Argumenten'
        },
        LanguageMetaData = {
            'DateFormat':           '%D.%M.%Y %T',
            'DateFormatLong':       '%T - %D.%M.%Y',
            'DateFormatShort':      '%D.%M.%Y',
            'DateInputFormat':      '%D.%M.%Y',
            'DateInputFormatLong':  '%D.%M.%Y - %T'
        };

        QUnit.module('Core.Language');

        QUnit.test('Translations', function(Assert){
            Core.Language.Load(LanguageMetaData, TranslationData);
            Assert.equal(Core.Language.Translate('yes'), 'ja');
            Assert.equal(Core.Language.Translate('no'), 'nein');
            Assert.equal(Core.Language.Translate('This is %s', 'OTOBO'), 'Das ist OTOBO');
            Assert.equal(Core.Language.Translate('This is %s', 'yes'), 'Das ist yes');
            Assert.equal(Core.Language.Translate('Complex %s with %s arguments', 'Text', 'vielen'), 'Komplexer Text mit vielen Argumenten');
        });
    };

    return Namespace;
}(Core.Language || {}));
