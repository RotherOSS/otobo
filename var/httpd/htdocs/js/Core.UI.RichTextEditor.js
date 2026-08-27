// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2021-2024 Znuny GmbH, https://znuny.org/
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
        //  use wildcard to include "RichText<ActivityDialogID>"
        const $RichTextLabel = $EditorArea.closest('.Field').siblings('label[for="' + EditorID + '"]');

        var ToolbarConfig;
        if ( CustomerInterface ) {
            ToolbarConfig = CheckFormID($EditorArea).length ? Core.Config.Get('RichText.Toolbar') : Core.Config.Get('RichText.ToolbarWithoutImage');
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

        // if this is a RichText DF, disable Image Upload
        if($EditorArea.hasClass('DynamicFieldRichText')) {
            ToolbarConfig = Core.Config.Get('RichText.ToolbarWithoutImage');
            Integrations = [ 'url' ];
            removedPlugins = [ 'SimpleUploadAdapter' ];
        }

        var ClassicEditor = CKEditor5Wrapper.ClassicEditor;
        let EnabledPlugins = [];
        for (let pluginName of PluginList) {
            let Plugin = CKEditor5Wrapper[pluginName];
            if (Plugin) {
                EnabledPlugins.push(CKEditor5Wrapper[pluginName]);
            } else {
                Core.Exception.ShowError('Couldn\'t find plugin: ' + pluginName, 'JavaScriptError');
            }
        }

        ClassicEditor.create($($EditorArea).get(0), {
            licenseKey: 'GPL',
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
            htmlSupport: {
                allow: [
                    {
                        name: 'style',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'p',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'span',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'cite',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'img',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'table',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'caption',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'colgroup',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'col',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'thead',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'tbody',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'tfoot',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'th',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'tr',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                    {
                        name: 'td',
                        attributes: true,
                        classes: true,
                        styles: true
                    },
                ],
                disallow: [
                    {
                        styles: {
                            position: /(absolute|sticky|fixed)$/
                        }
                    }
                ]
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
                styles: {
                    options: [
                        'alignLeft', 'alignCenter', 'alignRight', 'alignBlockRight',
                        {
                            name: 'alignBlockLeft',
                            isDefault: true
                        }
                    ]
                },
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
                    type: 'ImageBlock',
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
                        alignment: 'center',
                        width: '100%'
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
            },
            fontColor: {
                colors: [
                    {
                        color: '#000000',
                        label: 'Black'
                    },
                    {
                        color: '#4d4d4d',
                        label: 'Dim grey'
                    },
                    {
                        color: '#999999',
                        label: 'Grey'
                    },
                    {
                        color: '#e6e6e6',
                        label: 'Light grey'
                    },
                    {
                        color: '#ffffff',
                        label: 'White',
                        hasBorder: true
                    },
                    {
                        color: '#e64c4c',
                        label: 'Red'
                    },
                    {
                        color: '#e6994c',
                        label: 'Orange'
                    },
                    {
                        color: '#e6e64c',
                        label: 'Yellow'
                    },
                    {
                        color: '#99e64c',
                        label: 'Light green'
                    },
                    {
                        color: '#4ce64c',
                        label: 'Green'
                    },
                    {
                        color: '#4ce699',
                        label: 'Aquamarine'
                    },
                    {
                        color: '#4ce6e6',
                        label: 'Turquoise'
                    },
                    {
                        color: '#4c99e6',
                        label: 'Light blue'
                    },
                    {
                        color: '#4c4ce6',
                        label: 'Blue'
                    },
                    {
                        color: '#994ce6',
                        label: 'Purple'
                    }
                ],
                colorPicker: {
                    format: 'hex'
                }
            },
            fontBackgroundColor: {
                colors: [
                    {
                        color: '#000000',
                        label: 'Black'
                    },
                    {
                        color: '#4d4d4d',
                        label: 'Dim grey'
                    },
                    {
                        color: '#999999',
                        label: 'Grey'
                    },
                    {
                        color: '#e6e6e6',
                        label: 'Light grey'
                    },
                    {
                        color: '#ffffff',
                        label: 'White',
                        hasBorder: true
                    },
                    {
                        color: '#e64c4c',
                        label: 'Red'
                    },
                    {
                        color: '#e6994c',
                        label: 'Orange'
                    },
                    {
                        color: '#e6e64c',
                        label: 'Yellow'
                    },
                    {
                        color: '#99e64c',
                        label: 'Light green'
                    },
                    {
                        color: '#4ce64c',
                        label: 'Green'
                    },
                    {
                        color: '#4ce699',
                        label: 'Aquamarine'
                    },
                    {
                        color: '#4ce6e6',
                        label: 'Turquoise'
                    },
                    {
                        color: '#4c99e6',
                        label: 'Light blue'
                    },
                    {
                        color: '#4c4ce6',
                        label: 'Blue'
                    },
                    {
                        color: '#994ce6',
                        label: 'Purple'
                    }
                ],
                colorPicker: {
                    format: 'hex'
                }
            },
            translations: [
                CKEditor5CoreTranslations,
            ]
        })
            .then(editor => {
                /* Generate ID for current Editor */
                editor.ElementId = EditorID;
                CKEditorInstances[$EditorArea.attr('id')] = editor;

                window.editor = editor;

                // set input field label as placeholder
                if (CustomerInterface) {
                    if (!$RichTextLabel.closest('.Row').hasClass('Row_DynamicField')) {
                        editor.editing.view.document.getRoot('main').placeholder = $RichTextLabel.text();
                        $RichTextLabel.hide();
                    }
                }

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
                $domEditableElement.resizable("option", "minHeight", 200);
                $domEditableElement.resizable("option", "handles", "s");
                let $resizeHandle = $(".ui-resizable-s", $domEditableElement);
                $resizeHandle.append("<i class='ooofo ooofo-more_h'></i>");
                $resizeHandle.addClass("RichTextField_resizeHandle");

                // Adjust Editor Size to match (resizable) container size
                var UpdateEditorSize = function(newSize=null) {

                    let fieldPadding = parseFloat($domEditableElement.css("padding-top"))
                                     + parseFloat($domEditableElement.css("padding-bottom"));

                    let newEditorSize;
                    if (newSize) {
                        newEditorSize = newSize.height - fieldPadding;
                    } else {
                        newEditorSize = $domEditableElement.innerHeight() - fieldPadding;
                    }
                    let toolbarHeight = $domEditableElement.find('.ck-editor__top').outerHeight();
                    let newEditingAreaSize = newEditorSize - toolbarHeight;

                    if (sourceEditingActive) {
                        let $editingArea = $domEditableElement.find('.ck-source-editing-area');
                        $editingArea.height(newEditingAreaSize);
                        editor.editing.view.forceRender();
                    } else {
                        editor.editing.view.change(writer => {
                            writer.setStyle(
                                'height',
                                newEditingAreaSize + 'px',
                                editor.editing.view.document.getRoot()
                            );
                        });
                    }
                };

                // set initial Editor height as defined by the System Configurations
                $domEditableElement.css("--InitialHeight", Core.Config.Get("RichText.Height") + "px");

                UpdateEditorSize();

                // resize editing area when editor is resized with the resizable handle
                $domEditableElement.on('resize', function() {
                    UpdateEditorSize();
                });

                const resizeObserver = new ResizeObserver(() => {
                    UpdateEditorSize();
                });

                // resize editor when resizable container changes size for any reason (e.g. window resize, sidebar toggle)
                // currently this leads to the editor growing endlessly if activated for the customer interface or
                // RichTextEditors in TableLike forms (e.g. Admin Interface)
                let InModularForm = $domEditableElement.closest("fieldset").hasClass("ModularForm");
                if (!CustomerInterface && InModularForm) {
                    resizeObserver.observe($domEditableElement.get(0));
                }

                //make sure editor size is adjusted as well whenever the toolbar changes size
                resizeObserver.observe(editor.ui.view.toolbar.element);

                // resize editor on mode change
                if ( editor.plugins.has( 'SourceEditing' ) ) {
                    const sourceEditing = editor.plugins.get( 'SourceEditing' );

                    editor.listenTo( sourceEditing, 'change:isSourceEditingMode', () => {
                        sourceEditingActive = sourceEditing.isSourceEditingMode;
                        UpdateEditorSize();
                    } );
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

                Core.App.Publish('Event.UI.RichTextEditor.InstanceCreated', [editor]);

                // workaround for ckeditor not using data filter correctly on pre-filled content
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

                editor.ui.focusTracker.on('change:isFocused', (_evt, _name, isFocused) => {
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
                    var ExistingIgnores = ( $(this).data('validator').settings.ignore || '' ).split(', ');
                    [".ck", ".ck-editor__editable", ".ck-content"].forEach(function(Element) {
                        if ( ExistingIgnores.indexOf(Element) == -1 ) {
                            ExistingIgnores.push(Element);
                        }
                    });
                    $(this).data('validator').settings.ignore = ExistingIgnores.join(", ");
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
     * @returns {jQueryObject} jQuery object of the corresponding RTE element.
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
