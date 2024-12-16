// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2021-2024 Znuny GmbH, https://znuny.org/
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
var CKEditorInstances = {};

/**
 * @namespace Core.UI.RichTextEditor
 * @memberof Core.UI
 * @author
 * @description
 *      Richtext Editor.
 */
Core.UI.RichTextEditor = (function (TargetNS) {

    /**
     * @private
     * @name $FormID
     * @memberof Core.UI.RichTextEditor
     * @member {jQueryObject}
     * @description
     *      Hidden input field with name FormID.
     */
    var $FormID,

        /**
         * @private
         * @name TimeOutRTEOnChange
         * @memberof Core.UI.RichTextEditor
         * @member {Object}
         * @description
         *      Object to handle timeout.
         */
        TimeOutRTEOnChange;

    /**
     * @private
     * @name CheckFormID
     * @memberof Core.UI.RichTextEditor
     * @function
     * @returns {jQueryObject} FormID element.
     * @param {jQueryObject} $EditorArea - The jQuery object of the element that has become a rich text editor.
     * @description
     *      Check in the window which hidden element has a name same to 'FormID' and return it like a JQuery object.
     */
    function CheckFormID($EditorArea) {
        if (typeof $FormID === 'undefined') {
            $FormID = $EditorArea.closest('form').find('input:hidden[name=FormID]');
        }
        return $FormID;
    }

    /**
     * @name InitEditor
     * @memberof Core.UI.RichTextEditor
     * @function
     * @returns {Boolean} Returns false on error.
     * @param {jQueryObject} $EditorArea - The jQuery object of the element that will be a rich text editor.
     * @description
     *      This function initializes the application and executes the needed functions.
     */
    TargetNS.InitEditor = function ($EditorArea) {
        var EditorID = '',
            UserLanguage,
            PluginList = Core.Config.Get('RichText.Plugins'),
            CustomerInterface = (Core.Config.Get('SessionName') === Core.Config.Get('CustomerPanelSessionName'));

        // The format for the language is different between OTOBO and CKEditor (see bug#8024)
        // To correct this, we replace "_" with "-" in the language (e.g. zh_CN becomes zh-cn)
        UserLanguage = Core.Config.Get('UserLanguage').replace(/_/, '-').toLowerCase();

        if (!window.CKEditor5Wrapper) {
            return false;
        }

        // Check if instance is already loaded
        if (isJQueryObject($EditorArea) && $EditorArea.hasClass('HasCKEInstance')) {
            return false;
        }

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            Core.Exception.Throw('RichTextEditor: Need exactly one EditorArea!', 'TypeError');
        }

        // Common editor label
        const RichTextLabel = $('label[for="RichText"]');

        var ToolbarConfig;
        if ( CustomerInterface ) {
            ToolbarConfig = /*$EditorArea.width() < 454 ? Core.Config.Get('RichText.ToolbarMini') :
                            $EditorArea.width() < 622 ? Core.Config.Get('RichText.ToolbarMidi') :*/
                            CheckFormID($EditorArea).length ? Core.Config.Get('RichText.Toolbar') : Core.Config.Get('RichText.ToolbarWithoutImage');
        }
        else {
            ToolbarConfig = CheckFormID($EditorArea).length ? Core.Config.Get('RichText.Toolbar') : Core.Config.Get('RichText.ToolbarWithoutImage');
        }

        var Integrations;
        var removedPlugins = [];
        var BlockPasteImg = false;

        //Enable picture upload when FormID is present
        //If not, load only the url to image function
        if ( CheckFormID($EditorArea).length ) {
            Integrations = [ 'upload', 'url' ];
        } else {
            Integrations = [ 'url' ];
            BlockPasteImg = true;
            removedPlugins = [ 'SimpleUploadAdapter' ];
        }

        var ClassicEditor = CKEditor5Wrapper.ClassicEditor;
        let EnabledPlugins = [];
        for (let pluginName of PluginList) {
            let Plugin = CKEditor5Plugins[pluginName];
            if (Plugin) {
                EnabledPlugins.push(CKEditor5Plugins[pluginName]);
            } else {
                Core.Exception.ShowError('Couldnt find plugin: ' + pluginName, 'JavaScriptError');
            }
        }

        ClassicEditor.create($($EditorArea).get(0), {
            ui: {
                poweredBy: {
                    position: 'inside',
                    side: 'right',
                    label: null,
                    forceVisible: true,
                    verticalOffset: 2,
                    horizontalOffset: 2
                }
            },
            heading: {
                options: [
                    { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                    { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
                    { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
                    { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
                    { model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4' },
                    { model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5' },
                    { model: 'heading6', view: 'h6', title: 'Heading 6', class: 'ck-heading_heading6' },
                ]
            },
            fontSize: {
                options: [
                    'default', 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
                ],
                supportAllValues: true
            },
            fontFamily: {
                supportAllValues: true
            },
            toolbar: {
                shouldNotGroupWhenFull: true,
                items: ToolbarConfig
            },
            plugins: EnabledPlugins,
            removePlugins: removedPlugins,
            language: {
                ui: UserLanguage,
                content: UserLanguage
            },
            image: {
                resizeUnit: 'px',
                resizeOptions: [
                    {
                        name: 'resizeImage:original',
                        label: 'Original Image Size',
                        value: null,
                        icon: 'original'
                    },
                    {
                        name: 'resizeImage:custom',
                        label: 'Scale Image',
                        value: 'custom',
                        icon: 'custom'
                    }
                ],
                toolbar: [
                    {
                        name: 'imageStyle:imagePositioningDropdown',
                        title: 'Image Positioning',
                        items: [
                            'imageStyle:alignLeft',
                            'imageStyle:alignCenter',
                            'imageStyle:alignRight',
                            'imageStyle:alignBlockLeft',
                            'imageStyle:alignBlockRight'
                        ],
                        defaultItem: 'imageStyle:alignBlockLeft'
                    },
                    'resizeImage'
                ],
                insert: {
                    type: 'auto',
                    integrations: Integrations
                }
            },
            table: {
                tableCellProperties: {
                    defaultProperties: {
                        horizontalAlignment: 'left',
                        verticalAlignment: 'top',
                    }
                },
                tableProperties: {
                    defaultProperties: {
                        alignment: 'left',
                    }
                },
                contentToolbar: [
                    'tableColumn', 'tableRow', 'mergeTableCells', 'tableProperties', 'tableCellProperties'
                ]
            },
            simpleUpload: {
                // build URL for image upload
                uploadUrl: Core.Config.Get('Baselink')
                    + 'Action='
                    + Core.Config.Get('RichText.PictureUploadAction', 'PictureUpload')
                    + '&FormID='
                    + CheckFormID($EditorArea).val()
                    + '&' + Core.Config.Get('SessionName')
                    + '=' + Core.Config.Get('SessionID'),

                // Enable the XMLHttpRequest.withCredentials property.
                withCredentials: false,

                // Headers sent along with the XMLHttpRequest to the upload server.
                headers: {}
            }
        })
            .then(editor => {
                /* Generate ID for current Editor */
                editor.ElementId = EditorID;
                CKEditorInstances[$EditorArea.attr('id')] = editor;

                window.editor = editor;

                /* configure permissable html tags */
                if (window.editor.plugins.has("DataFilter")) {
                    let dataFilter = window.editor.plugins.get("DataFilter");
                    dataFilter.allowElement( "style" );
                }

                /* Set Container size */
                var $domEditableElement = $($EditorArea).closest(".RichTextField");

                //Try use RichTextHolder for Customer Interface
                if (CustomerInterface) {
                    $domEditableElement = $($EditorArea).closest(".RichTextHolder");
                }

                //Set to Readonly mode if required
                if ($EditorArea.hasClass('Readonly')) {
                    editor.enableReadOnlyMode('DF_Readonly');
                }

                var sourceEditingActive = false;

                $domEditableElement.resizable();
                $domEditableElement.resizable("option", "handles", "s");
                $(".ui-resizable-s", $domEditableElement).append("<i class='ooofo ooofo-more_h'></i>");

                $domEditableElement.on('resize', function() {
                    adjustEditorSize();
                });

                // Adjust Editor Size to match (resizable) container size
                var adjustEditorSize = function() {
                    let toolbarHeight = $domEditableElement.find('.ck-editor__top').outerHeight();
                    let fieldPadding = parseFloat($domEditableElement.css("padding-top"))
                        + parseFloat($domEditableElement.css("padding-bottom"));
                    let newEditorSize = $domEditableElement.innerHeight() - fieldPadding;
                    let $editingArea = $domEditableElement.find('.ck-content');
                    if (sourceEditingActive) {
                        $editingArea = $domEditableElement.find('.ck-source-editing-area');
                    }
                    let verticalPadding = parseFloat($editingArea.css("padding-top")) + parseFloat($editingArea.css("padding-bottom"));
                    let borderWidth = parseFloat($editingArea.css("border-top")) + parseFloat($editingArea.css("border-bottom"));
                    let newSize = newEditorSize - (toolbarHeight + verticalPadding)
                    if (sourceEditingActive) {
                        $editingArea.height(newSize);
                        editor.editing.view.forceRender();
                    } else {
                        newSize -= borderWidth;
                        editor.editing.view.change(writer => {
                            writer.setStyle('height', newSize + 'px', editor.editing.view.document.getRoot());
                        });
                    }
                };

                //resize editor on mode change
                if ( editor.plugins.has( 'SourceEditing' ) ) {
                    const sourceEditing = editor.plugins.get( 'SourceEditing' );

                    editor.listenTo( sourceEditing, 'change:isSourceEditingMode', () => {
                        sourceEditingActive = sourceEditing.isSourceEditingMode;
                        adjustEditorSize();
                    } );
                }

                // bind editor resize to container($domEditableElement) size change (ie. when changing window size)
                const resizeObserver = new ResizeObserver(() => {
                    adjustEditorSize();
                });
                resizeObserver.observe($domEditableElement.first().get(0));

                //make sure editor size is adjusted whenever the toolbar changes size
                //otherwise editor size can behave weirdly right after loading page
                resizeObserver.observe(editor.ui.view.toolbar.element);

                if (CustomerInterface) {
                    editor.editing.view.document.getRoot('main').placeholder = RichTextLabel[0].innerText;
                    RichTextLabel.hide();

                    /* Set editing area width for Customer */
                    editor.editing.view.change(writer => {
                        writer.setStyle('max-width', '100%', editor.editing.view.document.getRoot());
                    });
                }

                //Block pasting images for ToolbarWithoutImage
                editor.editing.view.document.on( 'clipboardInput', ( evt, data ) => {
                    const dataTransfer = data.dataTransfer;

                    if ( dataTransfer._files.length > 0 ) {
                        const imageName = dataTransfer._files[0].name;

                        if ( /\.(jpe?g|png|gif|bmp)$/i.test(imageName) && BlockPasteImg ) {
                            evt.stop();
                            return;
                        }
                    }
                });

                if (!CustomerInterface) {
                    // set initial Editor size as defined by System Configuration
                    // add 10 px of padding to the editor width
                    let EditorWidth = Number( Core.Config.Get("RichText.Width", 620) ) + 10;

                    $domEditableElement.css("height", Core.Config.Get("RichText.Height", 320));
                    $domEditableElement.css("width", EditorWidth);
                }

                Core.App.Publish('Event.UI.RichTextEditor.InstanceCreated', [editor]);

                // workaround for ckeditor not using data filter correctly on prefilled content
                if (editor.ElementId == 'RichText') {
                    editor.setData(editor.sourceElement.innerText);
                }

                //Update validation error tooltip while content is added to the editor
                editor.model.document.on('change:data', () => {
                    window.clearTimeout(TimeOutRTEOnChange);
                    TimeOutRTEOnChange = window.setTimeout(function () {
                        let EditorAreaContent = editor.getData();
                        if (EditorAreaContent != "") {
                            $("#" + editor.ElementId).val(EditorAreaContent);
                        }
                        Core.Form.Validate.ValidateElement($EditorArea);
                        Core.App.Publish('Event.UI.RichTextEditor.ChangeValidationComplete', [editor]);
                    }, 500);
                });

                editor.ui.focusTracker.on('change:isFocused', (evt, name, isFocused) => {
                    if (!isFocused) {
                        $("#" + $EditorArea.attr('id')).val(editor.getData());

                        Core.Form.Validate.ValidateElement($EditorArea);
                        Core.Form.ErrorTooltips.RemoveRTETooltip($EditorArea);
                    }
                });

            })
            .catch(error => {
                console.error(error);
            });

        // mark the editor textarea as linked with an RTE instance to avoid multiple instances
        $EditorArea.addClass('HasCKEInstance');

        //Remove validation for undefined elements on CKEditor (JQuery validate plugin exception)
        $(document).ready(function () {
            $('form').each(function () {
                if ($(this).data('validator')) {
                    $(this).data('validator').settings.ignore = ".ck, .ck-editor__editable, .ck-content";
                    return false;
                }
            });
        });
    };

    /**
     * @name InitAllEditors
     * @memberof Core.UI.RichTextEditor
     * @function
     * @description
     *      This function initializes as a rich text editor every textarea element that containing the RichText class.
     */
    TargetNS.InitAllEditors = function () {

        if (!window.CKEditor5Wrapper) {
            return;
        }

        $('textarea.RichText').each(function () {
            TargetNS.InitEditor($(this));
        });
    };

    /**
     * @name Init
     * @memberof Core.UI.RichTextEditor
     * @function
     * @description
     *      This function initializes JS functionality.
     */
    TargetNS.Init = function () {

        if (!window.CKEditor5Wrapper || Core.Config.Get('Action') == 'AdminGenericInterfaceMappingXSLT') {
            return;
        }

        var CustomerInterface = (Core.Config.Get('SessionName') === Core.Config.Get('CustomerPanelSessionName'));

        $("head").append('<link rel="stylesheet" type="text/css" href="' + Core.Config.Get('WebPath') + Core.Config.Get('RichText.EditorStylesPath') + '">');
        $("head").append('<link rel="stylesheet" type="text/css" href="' + Core.Config.Get('WebPath') + Core.Config.Get('RichText.ContentStylesPath') + '">');
        if (CustomerInterface) {
            $("head").append('<link rel="stylesheet" type="text/css" href="' + Core.Config.Get('WebPath') + '/skins/Customer/default/css/CKEditorCustomStyles.css">');
            $("head").append('<link rel="stylesheet" type="text/css" href="' + Core.Config.Get('WebPath') + '/skins/Customer/default/css/RichTextArticleContent.css">');
        } else {
            $("head").append('<link rel="stylesheet" type="text/css" href="' + Core.Config.Get('WebPath') + '/skins/Agent/default/css/CKEditorCustomStyles.css">');
            $("head").append('<link rel="stylesheet" type="text/css" href="' + Core.Config.Get('WebPath') + '/skins/Agent/default/css/RichTextArticleContent.css">');
        }

        let CustomStyles = Core.Config.Get('RichText.CustomCSS') || '';
        if (CustomStyles != '') {
            $("head").append('<style type="text/css"> .ck-content {' + CustomStyles + '} </style>');
        }

        TargetNS.InitAllEditors();
    };

    /**
     * @name GetRTE
     * @memberof Core.UI.RichTextEditor
     * @function
     * @returns {jQueryObject} jQuery object of the corresponsing RTE element.
     * @param {jQueryObject} $EditorArea - The jQuery object of the element that is a rich text editor.
     * @description
     *      Get RTE jQuery element.
     */
    TargetNS.GetRTE = function ($EditorArea) {
        var $RTE;

        if (isJQueryObject($EditorArea)) {
            $RTE = $($EditorArea.attr('id'));
            return ($RTE.length ? $RTE : undefined);
        }
    };

    /**
     * @name UpdateLinkedField
     * @memberof Core.UI.RichTextEditor
     * @function
     * @param {jQueryObject} $EditorArea - The jQuery object of the element that is a rich text editor.
     * @description
     *      This function updates the linked field for a rich text editor.
     */
    TargetNS.UpdateLinkedField = function ($EditorArea) {
        var EditorID = '',
            Data,
            StrippedContent;

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            Core.Exception.Throw('RichTextEditor: Need exactly one EditorArea!', 'TypeError');
        }

        Data = window.editor.getData();
        StrippedContent = Data.replace(/\s+|&nbsp;|<\/?\w+[^>]*\/?>/g, '');

        if (StrippedContent.length === 0 && !Data.match(/<img/)) {
            $EditorArea.val('');
        }
        else {
            $EditorArea.val(Data);
        }
    };

    /**
     * @name IsEnabled
     * @memberof Core.UI.RichTextEditor
     * @function
     * @returns {Boolean} True if RTE is enabled, false otherwise
     * @param {jQueryObject} $EditorArea - The jQuery object of the element that is a rich text editor.
     * @description
     *      This function check if a rich text editor is enable in this moment.
     */
    TargetNS.IsEnabled = function ($EditorArea) {
        if (typeof window.editor === 'undefined') {
            return false;
        }

        if (isJQueryObject($EditorArea) && $EditorArea.length && $EditorArea.hasClass('RichText')) {
            return (window.editor ? true : false);
        }
        return false;
    };

    /**
     * @name Focus
     * @memberof Core.UI.RichTextEditor
     * @function
     * @param {jQueryObject} $EditorArea - The jQuery object of the element that is a rich text editor.
     * @description
     *      This function focusses the given RTE.
     */
    TargetNS.Focus = function ($EditorArea) {
        var EditorID = '';

        if (isJQueryObject($EditorArea) && $EditorArea.length === 1) {
            EditorID = $EditorArea.attr('id');
        }

        if (EditorID === '') {
            Core.Exception.Throw('RichTextEditor: Need exactly one EditorArea!', 'TypeError');
        }

        if (typeof ClassicEditor != 'undefined') {
            CKEditorInstances[$EditorArea.attr('id')].focus();
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.UI.RichTextEditor || {}));
