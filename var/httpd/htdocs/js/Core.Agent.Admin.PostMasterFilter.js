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
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.PostMasterFilter
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special function for PostMasterFilter module.
 */
 Core.Agent.Admin.PostMasterFilter = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.PostMasterFilter
    * @function
    * @description
    *      This function initializes table filter.
    */
    TargetNS.Init = function () {

        Core.UI.Table.InitTableFilter($('#FilterPostMasterFilters'), $('#PostMasterFilters'));

        // delete postmaster filter
        TargetNS.InitPostMasterFilterDelete();

        // check all negate labels and add a marker color if negate is enabled
        $('.FilterFields label.Negate input').each(function() {
            if ($(this).is(':checked')) {
                $(this).closest('label').addClass('Checked');
            }
            else {
                $(this).closest('label').removeClass('Checked');
            }
        });

        $('.FilterFields label.Negate input').on('click', function() {
            if ($(this).is(':checked')) {
                $(this).closest('label').addClass('Checked');
            }
            else {
                $(this).closest('label').removeClass('Checked');
            }
        });

    };

    /**
     * @name PostMasterFilterDelete
     * @memberof Core.Agent.Admin.PostMasterFilter
     * @function
     * @description
     *      This function deletes postmaster filter on buton click.
     */
    TargetNS.InitPostMasterFilterDelete = function () {
        $('.PostMasterFilterDelete').on('click', function () {
            var $PostMasterFilterDelete = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeletePostMasterFilterDialogContainer'),
                Core.Language.Translate('Delete this PostMasterFilter'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting the postmaster filter and its data. This may take a while..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink'),
                                $PostMasterFilterDelete.data('query-string'),
                                function() {
                                   Core.App.InternalRedirect({
                                       Action: 'AdminPostMasterFilter'
                                   });
                                }
                            );
                        }
                    },
                    {
                        Label: Core.Language.Translate("Cancel"),
                        Function: function () {
                            Core.UI.Dialog.CloseDialog($('#DeletePostMasterFilterDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.PostMasterFilter || {}));
