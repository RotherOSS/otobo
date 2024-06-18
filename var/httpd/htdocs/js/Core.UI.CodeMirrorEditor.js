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

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace Core.UI.CodeMirrorEditor
 * @memberof Core.UI
 * @author
 * @description
 *      This namespace contains all codemirror pluging related functions.
 */
Core.UI.CodeMirrorEditor = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.UI.CodeMirrorEditor
     * @function
     * @description
     *      This function initializes the codemirror plugin.
     */
    TargetNS.Init = function () {
        var Editor,
            EditorElement = $('.CodeMirrorEditor')[0];

        if ( !EditorElement ) {
            return;
        }

        var Mode = Core.Config.Get('EditorLanguageMode') || 'htmlmixed';

        try {
            //Create CodeMirror instance
            Editor = CodeMirror.fromTextArea(EditorElement, {
                mode: Mode,
                lineNumbers: true,
                lineWrapping: true,
                matchBrackets: true,
                autoCloseTags: true,
                autoCloseBrackets: true,
                showTrailingSpace: true,
                foldGutter: true,
                smartIndent: true,
                gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
                extraKeys: {
                    "'<'": TargetNS.completeAfter,
                    "'/'": TargetNS.completeIfAfterLt,
                    "' '": TargetNS.completeIfInTag,
                    "'='": TargetNS.completeIfInTag,
                    "Ctrl-Space": "autocomplete",
                    "Ctrl-K": 'toggleComment',
                    "Ctrl-Alt-J": 'jumpToLine',
                    "Ctrl-Alt-I": TargetNS.IndentCode,
                    "F11": function () { TargetNS.ToogleFullScreen('Maximize'); },
                    "Esc": function () { TargetNS.ToogleFullScreen('Exit'); }
                },
            });

            switch(Mode) {
                case 'text/x-yaml':
                    Editor.setOption("indentUnit", 2);
                    Editor.setOption("extensions", ['yaml']);
                    Object.assign(Editor.options.extraKeys, {
                        "Tab": function(cm) {
                            var spaces = Array(cm.getOption("indentUnit") + 1).join(" ");
                            cm.replaceSelection(spaces);
                        }
                    });
                    break;
                case 'htmlmixed':
                    Editor.setOption("indentUnit", 4);
                    break;
            }

            $("#CMToolbarContainer").removeClass("Hidden");
        } catch (error) {
            const ErrorDialogCloseFunction = function () {
                Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
            };

            Core.UI.Dialog.ShowAlert(
                Core.Language.Translate('Error'),
                Core.Language.Translate('Error trying to create CodeMirror instance, please check configuration!'), ErrorDialogCloseFunction
            );
        }

        //Initializate events
        if (Editor) {
            $(EditorElement).data('CodeMirrorInstance', Editor);

            //Assign XSLT standard tags to HTML mixed hint list
            if ( Mode == 'htmlmixed' ) {
                Object.assign(CodeMirror.htmlSchema, XSLT_Tags());
            }

            var EditorServerError;
            Editor.on('change', (Editor) => {
                const EditorLabel = $('label[for="' + $(EditorElement).attr('id') + '"]');
                EditorServerError = $('#' + $(EditorElement).attr('id') + 'ServerError');
                $(EditorElement).val(Editor.doc.getValue());

                if ($(EditorElement).val()) {
                    $(EditorElement).removeClass('Error');
                    $(EditorElement).removeClass('ServerError');
                    $(EditorLabel).removeClass('LabelError');
                    $(EditorServerError).hide();
                }

                Core.Form.ErrorTooltips.RemoveCMETooltip();
            });

            Core.App.Publish('Event.UI.CodeMirrorEditor.InstanceReady', [Editor]);

            if ( $(EditorElement).hasClass('ServerError') && EditorServerError !== undefined ) {
                $(EditorServerError).addClass('Error');
                $(EditorServerError).css('margin', '15px 0');
                $(EditorServerError).show();
            }
        }
    };

    /**
    * @private
    * @name getInstance
    * @memberof Core.UI.CodeMirrorEditor
    * @member {Object}
    * @description
    *      Return current Codemirror instance.
    */

    function getInstance() {
        return $('.CodeMirrorEditor').data('CodeMirrorInstance');
    }

    /**
    * @name ToogleFullScreen
    * @memberof Core.UI.CodeMirrorEditor
    * @function
    * @param {String} option - case for set or exit full screen
    * @description
    *      This function switch editor to full screen mode.
    */

    TargetNS.ToogleFullScreen = function (option) {
        var cm = getInstance();

        if (option == 'Maximize') {
            cm.setOption("fullScreen", !cm.getOption("fullScreen"));
        }

        if (cm.getOption("fullScreen") && option == 'Exit') {
            cm.setOption("fullScreen", false);
        }
    };

    /**
    * @name ToogleComment
    * @memberof Core.UI.CodeMirrorEditor
    * @function
    * @description
    *      This function toogle selection commented / uncommented.
    */

    TargetNS.ToogleComment = function () {
        var cm = getInstance();
        cm.execCommand('toggleComment');
    };

    /**
    * @name SelectAll
    * @memberof Core.UI.CodeMirrorEditor
    * @function
    * @description
    *      This function select all text in editor.
    */

    TargetNS.SelectAll = function () {
        var cm = getInstance();
        cm.execCommand('selectAll');
    };

    /**
    * @name SearchReplace
    * @memberof Core.UI.CodeMirrorEditor
    * @function
    * @description
    *      This function launch search and replace dialog
    */

    TargetNS.SearchReplace = function () {
        var cm = getInstance();
        cm.execCommand('replace');
    };

    /**
     * @name Search
     * @memberof Core.UI.CodeMirrorEditor
     * @function
     * @description
     *      This function launch find dialog
     */

    TargetNS.Search = function () {
        var cm = getInstance();
        cm.execCommand('find');
    };

    /**
     * @name IndentCode
     * @memberof Core.UI.CodeMirrorEditor
     * @function
     * @param {String} cm - editor instance
     * @param {String} pred - text
     * @description
     *      This function receives an editor instance and indent the code
     */
    TargetNS.IndentCode = function (cm, pred) {
        var cm = getInstance();
        cm.eachLine(line => {
            cm.indentLine(cm.getLineNumber(line), "smart");
        });
    };

    /**
     * @name completeAfter
     * @memberof Core.UI.CodeMirrorEditor
     * @function
     * @param {String} cm - editor instance
     * @param {String} pred - text
     * @description
     *      This function receives an editor instance and show hint (after)
     */
    TargetNS.completeAfter = function (cm, pred) {
        var cur = cm.getCursor();

        if (!pred || pred()) setTimeout(function () {
            if (!cm.state.completionActive)
                cm.showHint({ completeSingle: false });
        }, 100);

        return CodeMirror.Pass;
    };

    /**
     * @name completeIfAfterLt
     * @memberof Core.UI.CodeMirrorEditor
     * @function
     * @param {String} cm - editor instance
     * @param {String} pred - text
     * @description
     *       This function receives an editor instance and autocomplete code
     */
    TargetNS.completeIfAfterLt = function (cm) {
        return TargetNS.completeAfter(cm, function () {
            var cur = cm.getCursor();
            return cm.getRange(CodeMirror.Pos(cur.line, cur.ch - 1), cur) == "<";
        });
    };

    /**
     * @name completeIfInTag
     * @memberof Core.UI.CodeMirrorEditor
     * @function
     * @param {String} cm - editor instance
     * @param {String} pred - text
     * @description
     *      This function receives an editor instance and autocomplete code
     */
    TargetNS.completeIfInTag = function (cm) {
        return TargetNS.completeAfter(cm, function () {
            var tok = cm.getTokenAt(cm.getCursor());
            if (tok.type == "string" && (!/['"]/.test(tok.string.charAt(tok.string.length - 1)) || tok.string.length == 1)) return false;
            var inner = CodeMirror.innerMode(cm.getMode(), tok.state).state;
            return inner.tagName;
        });
    };

    /**
     * @private
     * @name XSLT_Tags
     * @memberof Core.UI.CodeMirrorEditor
     * @member {Object}
     * @description
     *      XSLT tags autocomplete list.
     */

    function XSLT_Tags() {
        var Tags = {
            "xsl:apply-imports": {},
            "xsl:apply-templates": {
                attrs: {
                    select: null,
                    mode: null,
                }
            },
            "xsl:attribute": {
                attrs: {
                    name: null,
                    namespace: null,
                }
            },
            "xsl:attribute-set": {
                attrs: {
                    name: null,
                    "use-attribute-sets": null,
                }
            },
            "xsl:call-template": {
                attrs: {
                    name: null,
                }
            },
            "xsl:choose": {},
            "xsl:comment": {},
            "xsl:copy": {
                attrs: {
                    "use-attribute-sets": null,
                }
            },
            "xsl:copy-of": {
                attrs: {
                    select: null,
                }
            },
            "xsl:decimal-format": {
                attrs: {
                    name: null,
                }
            },
            "xsl:element": {
                attrs: {
                    name: null,
                    namespace: null,
                    "use-attribute-sets": null,
                }
            },
            "xsl:fallback": {},
            "xsl:for-each": {
                attrs: {
                    select: null,
                }
            },
            "xsl:if": {
                attrs: {
                    test: null,
                }
            },
            "xsl:import": {
                attrs: {
                    href: null,
                }
            },
            "xsl:include": {
                attrs: {
                    href: null,
                }
            },
            "xsl:key": {
                attrs: {
                    name: null,
                    match: null,
                    use: null,
                }
            },
            "xsl:message": {
                attrs: {
                    terminate: null,
                }
            },
            "xsl:namespace-alias": {
                attrs: {
                    "stylesheet-prefix": null,
                    "result-prefix": null,
                }
            },
            "xsl:number": {
                attrs: {
                    count: null,
                    level: ["single", "multiple", "any"],
                    from: null,
                    value: null,
                    format: null,
                    "letter-value": null,
                    "grouping-separator": null,
                    "grouping-size": null
                }
            },
            "xsl:otherwise": {},
            "xsl:output": {
                attrs: {
                    method: null,
                    version: null,
                    encoding: null,
                    "omit-xml-declaration": null,
                    "doctype-public": null,
                    "doctype-system": null,
                    "cdata-section-elements": null
                }
            },
            "xsl:param": {
                attrs: {
                    name: null,
                    select: null,
                }
            },
            "xsl:preserve-space": {
                attrs: {
                    elements: null,
                }
            },
            "xsl:processing-instruction": {
                attrs: {
                    name: null,
                }
            },
            "xsl:sort": {
                attrs: {
                    select: null,
                    order: null,
                    "case-order": null,
                    lang: null,
                    "data-type": null,
                }
            },
            "xsl:strip-space": {
                attrs: {
                    elements: null,
                }
            },
            "xsl:stylesheet": {
                attrs: {
                    version: null,
                    "exclude-result-prefixes": null,
                    "extension-element-prefixes": null,
                    "default-collation": null,
                    "default-mode": null,
                    "default-validation": null,
                    "expand-text": null,
                    id: null,
                    "input-type-annotations": null,
                    "use-when": null,
                    "xpath-default-namespace": null
                }
            },
            "xsl:template": {
                attrs: {
                    match: null,
                    name: null,
                    mode: null,
                    priority: null
                }
            },
            "xsl:text": {
                attrs: {
                    "disable-output-escaping": null,
                }
            },
            "xsl:transform": {},
            "xsl:value-of": {
                attrs: {
                    select: null,
                    "disable-output-escaping": null,
                }
            },
            "xsl:variable": {
                attrs: {
                    name: null,
                    select: null,
                }
            },
            "xsl:when": {
                attrs: {
                    test: null,
                }
            },
            "xsl:with-param": {
                attrs: {
                    name: null,
                    select: null,
                }
            },
        };

        return Tags;
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_GLOBAL');

    return TargetNS;
}(Core.UI.CodeMirrorEditor || {}));
