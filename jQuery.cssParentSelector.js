/** wikiPage Selector */
(function($) {
    // document load event
    $(function () {
        if ($('.ms-wikicontent').length > 0) {
            $('div[data-item="hol_wiki_title"]').show();
        }
    });

})(jQuery);
