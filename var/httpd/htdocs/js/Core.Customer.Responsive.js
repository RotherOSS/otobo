// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
Core.Customer = Core.Customer || {};

/**
 * @namespace Core.Customer.Responsive
 * @memberof Core.Customer
 * @author
 * @description
 *      This namespace contains the responsive functionality.
 */
Core.Customer.Responsive = (function (TargetNS) {

    Core.App.Subscribe('Event.App.Responsive.SmallerOrEqualScreenL', function () {

        var SidebarElem;
        if ($('#ZoomSidebar').length) {
            SidebarElem = '#ZoomSidebar';
        }
        else if ($('.SidebarColumn').length) {
            SidebarElem = '.SidebarColumn';
        }

        // Add switch for Desktopmode
        if (!$('#ViewModeSwitch').length) {
            $('#Footer').append('<div id="ViewModeSwitch"><a href="#">' + Core.Language.Translate('Switch to desktop mode') + '</a></div>');
            $('#ViewModeSwitch a').on('click.Responsive', function() {
                localStorage.setItem("DesktopMode", 1);
                location.reload(true);
                return false;
            });
        }

        // wrap sidebar modules with an additional container
        if (!$('.ResponsiveSidebarContainer').length) {
            $(SidebarElem + ', #Navigation').wrap('<div class="ResponsiveSidebarContainer" />');
        }

        // make sure the relevant sidebar is being collapsed on clicking
        // on the background
        $('.ResponsiveSidebarContainer').off().on('click', function(Event) {

            // only react on a direct click on the background
            if (Event.target !== this) {
                return;
            }

            // check if the navigation container is currently invisible, in this
            // case the other container is expanded and we need to use the relevant trigger
            if (parseInt($('#Navigation').css('left'), 10) < 0 || parseInt($('#Navigation').css('left'), 10) === 10) {
                $('#ResponsiveSidebarHandle').trigger('click');
            }
            else {
                $('#ResponsiveNavigationHandle').trigger('click');
            }
        });

        // add handle for for navigation
        if ($('#Navigation').length && !$('#MainBox').hasClass('Login') && !$('#ResponsiveNavigationHandle').length) {
            $('#Header').append('<a id="ResponsiveNavigationHandle" href="#"><i class="fa fa-bars"></i></a>');
        }

        // add navigation sidebar expansion handling
        $('#ResponsiveNavigationHandle').off().on('click', function() {
            if (parseInt($('#Navigation').css('left'), 10) < 0 || parseInt($('#Navigation').css('left'), 10) === 10) {
                $('#ResponsiveSidebarHandle').animate({
                    'right': '-45px'
                });
                $('#Navigation').closest('.ResponsiveSidebarContainer').fadeIn();
                $('html').addClass('NoScroll');
                $('#Navigation').animate({
                    'left': '0px'
                });
            }
            else {
                $('#ResponsiveSidebarHandle').animate({
                    'right': '21px'
                });
                $('#Navigation').closest('.ResponsiveSidebarContainer').fadeOut();
                $('html').removeClass('NoScroll');
                $('#Navigation').animate({
                    'left': '-300px'
                });
            }
            return false;
        });

        // add sidebar handling
        if ($(SidebarElem).length && !$('#ResponsiveSidebarHandle').length) {
            $('#Header').append('<a id="ResponsiveSidebarHandle" href="#"><i class="fa fa-caret-square-o-left"></i></a>');
        }

        // add sidebar column expansion handling
        $('#ResponsiveSidebarHandle').off().on('click', function() {
            if (parseInt($(SidebarElem).css('right'), 10) < 0) {
                $('#ResponsiveNavigationHandle').animate({
                    'left': '-45px'
                });
                $(SidebarElem).closest('.ResponsiveSidebarContainer').fadeIn();
                $('html').addClass('NoScroll');
                $(SidebarElem).animate({
                    'right': '0px'
                });
            }
            else {
                $('#ResponsiveNavigationHandle').animate({
                    'left': '21px'
                });
                $(SidebarElem).closest('.ResponsiveSidebarContainer').fadeOut();
                $('html').removeClass('NoScroll');
                $(SidebarElem).animate({
                    'right': '-300px'
                });
            }
            return false;
        });

    });

    Core.App.Subscribe('Event.App.Responsive.ScreenXL', function () {

        var SidebarElem;
        if ($('#ZoomSidebar').length) {
            SidebarElem = '#ZoomSidebar';
        }
        else if ($('.SidebarColumn').length) {
            SidebarElem = '.SidebarColumn';
        }

        // remove view mode switch
        $('#ViewModeSwitch').remove();

        $('#ResponsiveSidebarHandle').remove();

        // unwrap sidebar
        $('.ResponsiveSidebarContainer').children(SidebarElem + ', #Navigation').unwrap();
    });

    return TargetNS;

}(Core.Customer.Responsive || {}));
