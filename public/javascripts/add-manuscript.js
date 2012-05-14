$(document).ready(function() {

	$("#SJA-manuscript").click(function() {
	    showManuscript( );
	});

});

function showManuscript() {
   $("#manuscript").empty();
   $('#manuscript').load('SJA-MS-alltags.html', function(response, status, xhr) {
      if (status == "error") {
         var msg = "Sorry but there was an error: ";
         alert(msg + xhr.status + " " + xhr.statusText);
      }
   });
}