$(document).ready(function() {

    $("#previous-button").click(function() {
        showPreviousComparison();
    });

    $("#next-button").click(function() {
        showNextComparison();
    });

    showNextComparison();
});

function showPreviousComparison( ) {

   var resource_name = $("#previous-page").attr( "href");
   if (resource_name != null) {
       resource_name = "comparisons/" + resource_name.replace(/ /g, "%20"); // some of the names have spaces in!
   } else {
       resource_name = "comparisons/" + "HL.0001.html"
   }

   loadComparison( resource_name );
}

function showNextComparison( ) {

   var resource_name = $("#next-page").attr( "href");
   if (resource_name != null) {
       resource_name = "comparisons/" + resource_name.replace(/ /g, "%20"); // some of the names have spaces in!
   } else {
       resource_name = "comparisons/" + "HL.0001.html"
   }

   loadComparison( resource_name );
}

function loadComparison( resource_name ) {

    $("#content-display").empty();

    var title = resource_name.replace(/%20/g, " ").replace(/comparisons\//g, "" ).replace(/.html/g, "" );
    $("#compare-page").text( title )

    // load the resource and report an error if unsuccessful
    loadRemoteResource( resource_name, "#content-display" );
}
