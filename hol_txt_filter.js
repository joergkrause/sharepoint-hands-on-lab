<script>
$(function(){
  var url = window.location.href;
  $(document).on('click', '[data-item="txt-filter"] button', function() {
    var filterValue = $('#txt-filter-events').val();
	getListView('CompanyEvents', function(view) {
		var viewID = view.get_id();
		var hasQs = url.indexOf('?');
		if (hasQs > 0) {
		  url = url.substr(0, hasQs); 
		}
		if (filterValue !== '') {
			url += "?FilterField1=" + 'Title' + "&";
			url += "FilterValue1=" + filterValue + "&";
			url += "FilterOp1=" + 'Contains' + "&" ;
			// only send filter to particular view on page
			url += "View=" + viewID;
		}
		window.location.href = url;
		return false;
	});
  });
  return false;
});

function getListView(listName,success)
{
   var error = function(){
     // TODO: Error Handling
   };
   var ctx = SP.ClientContext.get_current();
   var list = ctx.get_web().get_lists().getByTitle(listName);
   var views = list.get_views();
   ctx.load(views);   
   ctx.executeQueryAsync(
      function() {
		  var enumerator = views.getEnumerator();
		  while (enumerator.moveNext()) {
		   var v = enumerator.get_current();
		   var t = v.get_title();
		   // first nameless view is the webpart's default one
		   if (t === '') {
			success(v); 
			break;
		   }
		  }
      },
      error);
}
</script>
