(function () {

    function createModstat(state) {
        var html = '<div data-field="hol-approval">';
        switch (state) {
            case "Approved":
                html += '<div data-item="Approved">Approved</div>';
                break;
            case "Pending":
                html += '<div data-item="Pending">Pending</div>';
                break;
            case "Rejected":
                html += '<div data-item="Rejected">Rejected</div>';
                break;
        }
        html += '</div>';
        return html;
    }

    SPClientTemplates.TemplateManager.RegisterTemplateOverrides({
        Templates: {
            Fields: {
                '_ModerationStatus': {
                    View: function (ctx) {
                        return createModstat(ctx.CurrentItem._ModerationStatus);
                    },
                    DisplayForm: function (ctx) {
                        return createModstat(ctx.CurrentItem._ModerationStatus);
                    }
                }
            }
        }
    });

})();
