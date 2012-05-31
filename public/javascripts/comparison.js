$(document).ready(function() {

    $("#previous-button").click(function() {
        showPreviousComparison(null);
    });

    $("#next-button").click(function() {
        showNextComparison(null);
    });

    var params = parseURL();
    showNextComparison( params["comparison"] );
});

function showPreviousComparison( resource_name ) {

   // if we did not provide a previous page
   if( resource_name == null ) {
      // try to get it from the current page
      resource_name = $("#previous-page").attr( "href");

      if (resource_name == null) {
         // just use a default
         resource_name = "HL.0001.html"
      }
   }

   resource_name = "comparisons/" + resource_name.replace(/ /g, "%20"); // some of the names have spaces in!
   loadComparison( resource_name );
}

function showNextComparison( resource_name ) {

   // if we did not provide a next page
   if( resource_name == null ) {
      // try to get it from the current page
      resource_name = $("#next-page").attr( "href");
      if (resource_name == null) {
         // just use a default
         resource_name = "HL.0001.html"
      }
   }

   resource_name = "comparisons/" + resource_name.replace(/ /g, "%20"); // some of the names have spaces in!
   loadComparison( resource_name );
}

function loadComparison( resource_name ) {

    $("#content-display").empty();

    var title = resource_name.replace(/%20/g, " ").replace(/comparisons\//g, "" ).replace(/.html/g, "" );
    $("#compare-page").text( title )

    // load the resource and report an error if unsuccessful
    loadRemoteResource( resource_name, "#content-display" );
}
