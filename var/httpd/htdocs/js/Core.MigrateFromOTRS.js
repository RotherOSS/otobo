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

/**
 * @namespace Core.MigrateFromOTRS
 * @memberof Core
 * @author
 * @description
 *      This namespace contains the special module functions for MigrateFromOTRS.
 */
Core.MigrateFromOTRS = (function (TargetNS) {

    /**
     * @private
     * @name NextStep
     * @description
     *      Defines the order of steps.
     */
    var NextStep = {
        OTRSFileSettings: 'OTRSDBSettings',
        OTRSDBSettings: 'PreChecks',
        PreChecks: 'Copy',
        Copy: 'Finish',
    };

    /**
     * @private
     * @name RunMultiTask
     * @memberof Core.MigrateFromOTRS
     * @function
     * @description
     *      This function check the values for the copydata configuration.
     */
    function RunMultiTask() {
        $('#MultiTask .oooMigrationResults > div').remove();
        $('#ButtonStartTasks').attr('disabled');
        $('#ButtonStartTasks').addClass('Disabled');

        var Data = Core.AJAX.SerializeForm($('#MultiTask'));
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, MultiTaskCallback);

        // show progress for the actual migration (Copy step)
        if ( $('input[name=Subaction]').val() === 'Copy' ) {
            var PData = {
                Action: 'MigrateFromOTRS',
                Subaction: 'GetProgress',
                Task: 'GetProgress',
            };
            setTimeout( function() {
                Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), PData, ProgressCallback);
            }, 500 );
        }
    };

    /**
     * @private
     * @name MultiTaskCallback
     * @memberof Core.MigrateFromOTRS
     * @function
     * @param {Object} json - The server response JSON object.
     * @description
     *      This function displays the results for the database credentials.
     */
    function MultiTaskCallback(json) {

        var Success = json.Successful === 1 ? 'Success' : 'Error';

        var MessageBlock = Core.Template.Render('MigrateFromOTRS/Message', {
            Message: json.Message,
            Comment: json.Comment,
            Success: Success,
        });
        $('#MultiTask .oooMigrationResults').show().append(MessageBlock);

// Package resolve is disabled
//        // resolve package error for PreChecks step
//        if ( json.Successful === 0 && $('input[name=Task]').val() == 'OTOBOOTRSPackageCheck' ) {
//            for ( const Package of json.Content ) {
//                var ResolveBlock = Core.Template.Render('MigrateFromOTRS/PackageResolve', {
//                    Package: Package,
//                });
//                $('#MultiTask .oooMigrationResults > .Field:nth-last-child(2)').append(ResolveBlock);
//            }
//            json.Successful = 1;
//        }

        // run through all tasks
        if ( json.Successful === 1 && json.NextTask ) {

            $('input[name=Task]').val(json.NextTask);
            var Data = Core.AJAX.SerializeForm($('#MultiTask'));

            Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, MultiTaskCallback);

        }

        // prepare next step
        else if ( json.Successful === 1 ) {
            $('#ButtonStartTasks').hide();
            $('#MigrationProgress').html('');
            $('input[name=Subaction]').val( NextStep[ $('input[name=Subaction]').val() ] );
            $('input[name=Task]').val('');
            $('#ButtonSubmitStep').removeAttr('disabled').removeClass('Disabled');
        }

        // aborted
        else {
            $('#MigrationProgress').html('');
            $('#ButtonStartTasks').removeAttr('disabled').removeClass('Disabled');
        }


    }

    /**
     * @private
     * @name ProgressCallback
     * @memberof Core.MigrateFromOTRS
     * @function
     * @param {Object} Response - The server response JSON object.
     * @description
     *      This function displays the results for the database credentials.
     */
    function ProgressCallback( Response ) {
        // stop loop if not told to continue
        if ( !Response.Continue ) {
            $('#MigrationProgress').html('');
            return;
        }

        var ProgressBlock = Core.Template.Render('MigrateFromOTRS/MigrationState', {
            Task: Response.Task,
            SubTask: Response.SubTask,
            TimeSpent: Response.TimeSpent,
        });
        $('#MigrationProgress').html( ProgressBlock );

        var PData = {
            Action: 'MigrateFromOTRS',
            Subaction: 'GetProgress',
            Task: 'GetProgress',
        };
        setTimeout( function() {
            Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), PData, ProgressCallback);
        }, 1000 );
    }

    /**
     * @private
     * @name DefTaskCallback
     * @memberof Core.MigrateFromOTRS
     * @function
     * @param {Object} json - The server response JSON object.
     * @description
     *      This function shows success and error messages, and enables form submission.
     */
    function DefTaskCallback(json) {
        // success
        if (parseInt(json.Successful, 10) === 1) {
            ToggleAJAXLoader( 'ButtonDefTask', false );
            $('#ButtonDefTask').closest('.Field').hide();
            $('button[type="submit"]').removeAttr('disabled').removeClass('Disabled');
            $('fieldset.ErrorMsg').hide();
            $('fieldset.Success').show();

            // prepare next step
            $('#Task').val('');
            $('input[name=Subaction]').val( NextStep[ $('input[name=Subaction]').val() ] );
        }
        // error
        else {
            ToggleAJAXLoader( 'ButtonDefTask', false );
            $('#ResultMessage').html(json.Message);
            $('#ResultComment').html(json.Comment);
            $('fieldset.ErrorMsg').show();
            $('fieldset.Success').hide();
        }
    }

     /**
     * @private
     * @name InitButtons
     * @memberof Core.MigrateFromOTRS
     * @function
     * @description
     *      This function creates click events.
     */
     function InitButtons() {

        // standard buttons
        // single task
        $('#ButtonDefTask').on('click', function() {
            ToggleAJAXLoader( 'ButtonDefTask', true );
            var Data = Core.AJAX.SerializeForm( $(this).closest('form') );
            Core.AJAX.FunctionCall( Core.Config.Get('Baselink'), Data, DefTaskCallback );
        });

        // multi task
        $('#ButtonStartTasks').on('click', function() {
            RunMultiTask();
        });

        // back button
        $('#ButtonBack').on('click', function() {
            parent.history.back();
        });

        // step specific
        // Intro
        $('#ButtonDeleteCache').on('click', function() {
            var Data = {
                Subaction: "Intro",
                Task: "ClearCache",
            };
            Core.AJAX.FunctionCall( Core.Config.Get('Baselink'), Data, function ( Response ) {
                if ( Response.Successful == 1 ) {
                    window.location.reload(true);
                }
                else {
                    $('#DeleteCacheError').show();
                }
            });
        });

        // DB skip
        $('#SkipDBMigration').on('change', function() {
            $('#DBChecked').toggle();
            $('#DBSkipped').toggle();

            if ( $(this).is(':checked') ) {
                ToggleAJAXLoader( 'ButtonDefTask', true );
                var Data = 'Action=MigrateFromOTRS;Subaction=OTRSDBSettings;Task=CheckSettings;SkipDBMigration=1';
                Core.AJAX.FunctionCall( Core.Config.Get('Baselink'), Data, DefTaskCallback );
            }
            else {
                $('#ButtonDefTask').closest('.Field').show();
                $('button[type="submit"]').attr('disabled','').addClass('Disabled');
                $('fieldset.ErrorMsg').hide();
                $('fieldset.Success').hide();

                // reset
                $('#Task').val('CheckSettings');
                $('input[name=Subaction]').val('OTRSDBSettings');
            }
        });

     }

     /**
     * @private
     * @name InitConditionalFields
     * @memberof Core.MigrateFromOTRS
     * @function
     * @description
     *      Sets field visibility.
     */
    function InitConditionalFields() {

        // OTRSFileSettings
        var Location = $('#OTRSLocation');
        if ( Location.val() === 'remote' ) {
            $('.oooRemote').show();
        }
        else {
            $('.oooRemote').hide();
        }

        Location.on('change', function() {
            if ( $(this).val() === 'remote' ) {
                $('.oooRemote').show();
            }
            else {
                $('.oooRemote').hide();
            }
        });

        // OTRSDBSettings
        var DBType = $('#DBType');
        if ( DBType.val() === 'mysql' || DBType.val() === 'postgresql' ) {
            $('.oooSQL').show();
            $('.oooOracle').hide();
        }
        else if ( DBType.val() === 'oracle' ) {
            $('.oooSQL').hide();
            $('.oooOracle').show();
        }
        else {
            $('.oooSQL').hide();
            $('.oooOracle').hide();
        }

        DBType.on('change', function() {
            if ( DBType.val() === 'mysql' || DBType.val() === 'postgresql' ) {
                $('.oooSQL').show();
                $('.oooOracle').hide();
            }
            else if ( DBType.val() === 'oracle' ) {
                $('.oooSQL').hide();
                $('.oooOracle').show();
            }
            else {
                $('.oooSQL').hide();
                $('.oooOracle').hide();
            }
        });

    }

    /**
     * @private
     * @name ToggleAJAXLoader
     * @memberof Core.MigrateFromOTRS
     * @function
     * @param {String} FieldID - Id of the field which is updated via ajax
     * @param {Boolean} Show - Show or hide the AJAX loader image
     * @description
     *      Shows and hides an ajax loader for every element which is updates via ajax.
     */
    function ToggleAJAXLoader(FieldID, Show) {
        var $Element = $('#' + FieldID),
            AJAXLoaderPrefix = 'Loader',
            $Loader = $('#' + AJAXLoaderPrefix + FieldID),
            LoaderHTML = '<span id="' + AJAXLoaderPrefix + FieldID + '" class="AJAXLoader"></span>';

        // Show or hide the loader
        if ( Show ) {
            if (!$Loader.length) {
                $Element.after(LoaderHTML);
            }
            else {
                $Loader.show();
            }
        }
        else {
            $Loader.hide();
        }
    }

    /**
     * @name Init
     * @memberof Core.MigrateFromOTRS
     * @function
     * @description
     *      This function initializes JS functionality.
     */
    TargetNS.Init = function () {

        // show 'Next' button
        $('#MigrateFromOTRSContinueWithJS').show();
        // during Intro check for https
        if ( location.protocol == 'https:' ) {
            $('#MigrateFromOTRSContinueWithJSIntro').show();
        }
        else {
            $('#CheckIgnoreHTTP').on('click', function() {
                if ( $(this).is(':checked') ) {
                    $('#MigrateFromOTRSContinueWithJSIntro').show();
                }
                else {
                    $('#MigrateFromOTRSContinueWithJSIntro').hide();
                }
            });
        }

        // button click events for Database Settings screen
        InitButtons();

        // fields which are shown under certain circumstances
        InitConditionalFields();

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.MigrateFromOTRS || {}));
