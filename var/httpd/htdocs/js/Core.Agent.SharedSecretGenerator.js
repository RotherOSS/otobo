// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.SharedSecretGenerator
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for the AgentPreferences module.
 */
Core.Agent.SharedSecretGenerator = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.SharedSecretGenerator
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        // the alphabet for the Base32 string
        const base32Letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "2", "3", "4", "5", "6", "7"];

        // add button for generating a shared secret
        $("#UserGoogleAuthenticatorSecretKey").parent().append("<button id=\"GenerateUserGoogleAuthenticatorSecretKey\" type=\"button\" class=\"CallForAction\"><span>" + Core.Language.Translate("Generate") + "</span></button>");
        $("#UserGoogleAuthenticatorSecretKey + button").on(
            'click',
            function() {
                // get 16 random bytes
                const randomBytes = new Uint8Array(16);
                crypto.getRandomValues(randomBytes);

                // using modulus 32 on a random bytes gives evenly distributed buckets as 256 is divisible by 32
                const randomIndexes = randomBytes.map(
                    function (randomByte) {
                        return randomByte % 32;
                    }
                );

                // Assemble the 16 character, effectively 5*16=80 bits, base32 secret key.
                // E.g. 'GR66UCK4MTGWWQDA'
                // There is no problem with padding as 5*16 is divisibe by 8.
                let sharedSecret = '';
                randomIndexes.forEach(
                    function (randomIndex) {
                        sharedSecret += base32Letters[ randomIndex ];

                        return;
                    }
                );
                $("#UserGoogleAuthenticatorSecretKey").val(sharedSecret);
            }
        );
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.SharedSecretGenerator || {}));
