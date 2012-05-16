$(document).ready(function() {

    // hide all the sub menu's
    $( ".sublist").hide()

    $("#previous-button").click(function() {
        showPreviousComparison();
    });

    $("#next-button").click(function() {
        showNextComparison();
    });

});

function showPreviousComparison( ) {

   var resource_name = $("#previous-page").attr( "href")
   if (resource_name == null) {
       resource_name = "HL-0001.html"
   }

   loadComparison( resource_name );
}

function showNextComparison( ) {

   var resource_name = $("#next-page").attr( "href");
   if (resource_name == null) {
       resource_name = "HL-0001.html"
   }

   loadComparison( resource_name );
}

function loadComparison( resource_name ) {

    $("#content-display").empty();
    $("#compare-page").text( resource_name.slice( 0, 7 ) )

    $("#content-display").load(resource_name, function(response, status, xhr) {
       if (status == "error") {
          var msg = "Sorry but there was an error: ";
          alert(msg + xhr.status + " " + xhr.statusText);
       }
    });
}
