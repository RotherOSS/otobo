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
 * @namespace Core.UI.NavigationBar
 * @memberof Core.UI
 * @author Rother OSS GmbH
 * @description
 *      Navigation Bar
 */
Core.UI.NavigationBar = (function (TargetNS) {

    /**
     * @private
     * @name NavBarShrink
     * @memberof Core.UI.Navigation
     * @function
     * @description
     *      This function returns the NavBar to its default.
     */
    function NavBarShrink() {
        $('#oooNavigation').off('mouseleave', NavBarShrink);
        // desktop mode
        if ($(window).width() >= 768) {
            $('#oooNavBarExpand').show();
            $('#oooLogo').hide();
            $('#oooSignet').show();
            $('#oooNavigation').removeClass("oooExpanded");
            $('#oooNavBarModuleIcons > a > .oooNavBarDescription > h3').each(function() {
                $(this).hide();
            });
            $('#oooUser h3').each(function() {
                $(this).hide();
            });
            $('#oooPrefDesc > p').each(function() {
                $(this).hide();
            });
        }
        // mobile mode
        else {
            $('#oooMobileMenuClose').hide().fadeOut(100);
            $('#oooNavigation').removeClass("oooExpanded");
            $('#oooNavBarModuleIcons').hide().fadeOut(100);
            $('#oooUser').hide().fadeOut(100);
        }
    }

    /**
     * @name Init
     * @memberof Core.UI.Notification
     * @function
     * @description
     *      This function initializes autocomplete in customer search fields.
     */
    TargetNS.Init = function() {
        // hide all descriptions initially
        /*        $('#oooNavBarModuleIcons > a > .oooNavBarDescription > h3').each(function() {
            $(this).hide();
        });
        $('#oooUser h3').each(function() {
            $(this).hide();
        });*/

        // expands the NavBar on click via css
        $('#oooNavBarExpand').on('click', function() {
            // if we switched modes from mobile to desktop
            $('#oooNavBarModuleIcons').show();
            $('#oooUser').show();

            setTimeout(function() {
                // only trigger if still expanded
                $('.oooExpanded > #oooNavBarExpand').hide();
                $('.oooExpanded #oooSignet').hide();
                $('.oooExpanded #oooLogo').show();
            }, 200);

            $('#oooNavigation').addClass("oooExpanded");

            // shrinks the NavBar again on mouseleave
            setTimeout(function() {
                $('#oooNavBarModuleIcons > a > .oooNavBarDescription > h3').each(function() {
                    $(this).show();
                });
                $('#oooUser h3').each(function() {
                    $(this).show();
                });
                $('#oooPrefDesc > p').each(function() {
                    $(this).show();
                });
                $('#oooNavigation').on('mouseleave', NavBarShrink);
            }, 100);
        });

        // mobile expand
        $('#oooMobileMenu').on('click', function() {
            $('#oooNavigation').addClass("oooExpanded");
            // if we switched from desktop to mobile
            $('.oooExpanded #oooLogo').show();

            setTimeout(function() {
                $('#oooNavBarModuleIcons > a > .oooNavBarDescription > h3').each(function() {
                    $(this).show();
                });
                $('#oooUser h3').each(function() {
                    $(this).show();
                });
                $('#oooPrefDesc > p').each(function() {
                    $(this).show();
                });
                $('#oooUser').show().fadeIn(100);
                $('#oooNavBarModuleIcons').show().fadeIn(100);
            }, 40);
            setTimeout(function() {
                $('#oooMobileMenuClose').show().fadeIn(100);
                // shrinks the NavBar again on mouseleave
                $('#oooNavigation').on('mouseleave', NavBarShrink);
            }, 140);
        });

        // mobile close
        $('#oooMobileMenuClose').on('click', function() {
            NavBarShrink();
        });

        // special highlighting for preferences and logout
        $('#oooAvatar :first-child').hover(
            function() {
                $('#oooUser .oooLogout h3').addClass('Highlight');
            },
            function() {
                $('#oooUser .oooLogout h3').removeClass('Highlight');
            },
        );
        $('#oooPreferences').hover(
            function() {
                $('#oooPrefDesc > p').addClass('Highlight');
            },
            function() {
                $('#oooPrefDesc > p').removeClass('Highlight');
            }
        );
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.UI.NavigationBar || {}));
