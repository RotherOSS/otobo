// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2018-2020 OTRS AG, https://otrs.com/
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

CKEDITOR.plugins.add('contextmenu_linkopen', {
    init: function(editor) {

        // add context menu item to allow opening links
        editor.addCommand('openLinkCommand', {
            exec: function(editor) {
                var selection = editor.getSelection(),
                    element = selection.getStartElement();

                if (element.$ && element.$.href) {
                    // don't use the popup api here as we want
                    // to simulate a new window
                    window.open(element.$.href, '_blank');
                }
            }
        });

        editor.addMenuItem('openLinkItem', {
            icon: 'Redo',
            label: Core.Config.Get('RichText.Lang.OpenLink') || 'Open link',
            command: 'openLinkCommand',
            group: 'link'
        });

        editor.contextMenu.addListener(function(element) {
            if (element.getAscendant('a', true)) {
                return { openLinkItem: CKEDITOR.TRISTATE_OFF };
            }
        });
    }
});
