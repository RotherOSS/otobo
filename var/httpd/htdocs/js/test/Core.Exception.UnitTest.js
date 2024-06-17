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

Core.Exception = (function (Namespace) {
    Namespace.RunUnitTests = function(){
        QUnit.module('Core.Exception');

        // ApplicationError
        QUnit.test('Core.Exception.ApplicationError()', function(Assert){
            var ErrorMessage = 'Test error message',
                ErrorTypes = ['Error', 'InternalError', 'TypeError', 'CommunicationError', 'ConnectionError'],
                ExceptionObject;

            Assert.expect(15);

            Core.Exception.HandleFinalError = function (Exception, ErrorType) {
                Assert.equal(Exception.GetType(), ErrorType, "Handle error type - " + ErrorType + ', error message - ' + ErrorMessage);
            };

            $.each(ErrorTypes, function() {
                try {
                    ExceptionObject = new Core.Exception.ApplicationError(ErrorMessage, this);
                    Core.Exception.HandleFinalError(ExceptionObject, this);

                    // test IsErrorOfType
                    Assert.equal(Core.Exception.IsErrorOfType(ExceptionObject,this), true, 'Exception type is - ' +  this);

                    // test Thrown function
                    Core.Exception.Throw(ErrorMessage, this);
                }
                catch (Error) {

                    // check if the exception is caught
                    Assert.ok(true, 'Error caught, error type \'' + ExceptionObject.GetType() + '\' is not correct!');
                }
            });

        });
    };

    return Namespace;
}(Core.Exception || {}));
