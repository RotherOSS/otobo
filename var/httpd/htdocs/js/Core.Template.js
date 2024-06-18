// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

/*global nunjucks */

"use strict";

var Core = Core || {};

/**
 * @namespace Core.Template
 * @memberof Core
 * @author
 * @description
 *      This namespace contains initialization functionalities.
 */
Core.Template = (function (TargetNS) {

    /**
     * @private
     * @name Templates
     * @memberof Core.Template
     * @member {Object}
     * @description
     *      Contains all templates
     */
    var Templates = {},
        NunjucksEnvironment;

    /**
     * @name Load
     * @memberof Core.Template
     * @function
     * @param {Object} TemplateData - contains the objectified template data as provided by the loader
     * @description
     *      Load all template files for later use.
     */
    TargetNS.Load = function(TemplateData) {

        if (typeof TemplateData !== 'object') {
            return;
        }

        Templates = TemplateData;
    };

    /**
     * @name Render
     * @memberof Core.Template
     * @function
     * @param {String} TemplateName - The name of the templated which should be used for rendering as of Core.Template.LoadTemplates()
     * @param {Object} Data - the data which should be used for rendering (optional)
     * @returns {String} - the rendering result
     * @description
     *      Render a template with the given data.
     * @example
     *
     *   Core.Template.Render('MetaFloater', {
     *       'Variable' : 'String',
     *       'Another'  : 'Another String'
     *   });
     *
     * For more examples and possibilities, see the Nunjucks documentation.
     *
     */
    TargetNS.Render = function(TemplateName, Data) {

        var Template;

        if (typeof TemplateName === 'undefined' || typeof Templates[TemplateName] === 'undefined') {
            return;
        }

        Template = Templates[TemplateName];

        return NunjucksEnvironment.renderString(Template, Data);
    };

    /**
     * @name RenderString
     * @memberof Core.Template
     * @function
     * @param {String} TemplateString - The string which should be used for rendering as of Core.Template.LoadTemplates()
     * @param {Object} Data - the data which should be used for rendering
     * @returns {String} - the rendering result
     * @description
     *      Render a string with the given data.
     */
    TargetNS.RenderString = function(TemplateString, Data) {

        if (typeof TemplateString === 'undefined' || typeof Data === 'undefined') {
            return;
        }

        return NunjucksEnvironment.renderString(TemplateString, Data);
    };


    /**
     * @name Init
     * @memberof Core.Template
     * @function
     * @description
     *      Init the engine environment.
     */
    TargetNS.Init = function() {

        NunjucksEnvironment = new nunjucks.Environment();

        // translation
        NunjucksEnvironment.addFilter('Translate', function() {
            return Core.Language.Translate.apply(window, arguments);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL_EARLY');

    return TargetNS;
}(Core.Template || {}));
