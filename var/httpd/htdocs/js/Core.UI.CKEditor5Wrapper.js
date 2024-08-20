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

import * as CKEditor5Wrapper from 'ckeditor5';

window.CKEditor5Wrapper = CKEditor5Wrapper;

let Plugins = [
    CKEditor5Wrapper.Alignment,
    CKEditor5Wrapper.Autoformat,
    CKEditor5Wrapper.BlockQuote,
    CKEditor5Wrapper.Bold,
    CKEditor5Wrapper.CodeBlock,
    CKEditor5Wrapper.DataFilter,
    CKEditor5Wrapper.DataSchema,
    CKEditor5Wrapper.FindAndReplace,
    CKEditor5Wrapper.FontColor,
    CKEditor5Wrapper.FontFamily,
    CKEditor5Wrapper.FontSize,
    CKEditor5Wrapper.FontBackgroundColor,
    CKEditor5Wrapper.GeneralHtmlSupport,
    CKEditor5Wrapper.Heading,
    CKEditor5Wrapper.HorizontalLine,
    CKEditor5Wrapper.Image,
    CKEditor5Wrapper.ImageResize,
    CKEditor5Wrapper.ImageStyle,
    CKEditor5Wrapper.ImageUpload,
    CKEditor5Wrapper.ImageToolbar,
    CKEditor5Wrapper.ImageInsert,
    CKEditor5Wrapper.Indent,
    CKEditor5Wrapper.Italic,
    CKEditor5Wrapper.Link,
    CKEditor5Wrapper.List,
    CKEditor5Wrapper.Paragraph,
    CKEditor5Wrapper.RemoveFormat,
    CKEditor5Wrapper.SelectAll,
    CKEditor5Wrapper.SimpleUploadAdapter,
    CKEditor5Wrapper.SourceEditing,
    CKEditor5Wrapper.SpecialCharacters,
    CKEditor5Wrapper.SpecialCharactersEssentials,
    CKEditor5Wrapper.Strikethrough,
    CKEditor5Wrapper.Table,
    CKEditor5Wrapper.TableCellProperties,
    CKEditor5Wrapper.TableColumnResize,
    CKEditor5Wrapper.TableProperties,
    CKEditor5Wrapper.TableToolbar,
    CKEditor5Wrapper.Underline,
    CKEditor5Wrapper.Undo,
    CKEditor5Wrapper.PasteFromOffice
];
let PluginDict = {};

for (let Plugin of Plugins) {
    PluginDict[Plugin.pluginName] = Plugin;
}

window.CKEditor5Plugins = PluginDict;