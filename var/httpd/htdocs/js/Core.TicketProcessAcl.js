Core.App.Ready(function() {
    if ($('input#IsProcessEnroll').val() === "1") {
        return;
    }
    if ($('.LayoutPopup').length) {
        Core.AJAX.FormUpdate($('form'), 'AJAXUpdate', 'TypeID' , Core.Config.Get('TypeFieldsToUpdate'));
    }
});
