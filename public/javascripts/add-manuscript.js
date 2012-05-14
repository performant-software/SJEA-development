$(document).ready(function() {

	$("#SJA-manuscript").click(function() {
	    showManuscript( 'SJA-MS');
	});

    $("#SJC-manuscript").click(function() {
        showManuscript( 'SJC-MS');
    });

    $("#SJD-manuscript").click(function() {
        showManuscript( 'SJD-MS');
    });

    $("#SJE-manuscript").click(function() {
        showManuscript( 'SJE-MS');
    });

    $("#SJEx-manuscript").click(function() {
        showManuscript( 'SJEx-MS');
    });

    $("#SJL-manuscript").click(function() {
        showManuscript( 'SJL-MS');
    });

    $("#SJP-manuscript").click(function() {
        showManuscript( 'SJP-MS');
    });

    $("#SJU-manuscript").click(function() {
        showManuscript( 'SJU-MS');
    });

    $("#SJV-manuscript").click(function() {
        showManuscript( 'SJV-MS');
    });

});

function showManuscript( manuscript ) {

   var resource_name = manuscript + "-alltags.html"
   $("#manuscript").empty();
   $('#manuscript').load(resource_name, function(response, status, xhr) {
      if (status == "error") {
         var msg = "Sorry but there was an error: ";
         alert(msg + xhr.status + " " + xhr.statusText);
      }
   });
}