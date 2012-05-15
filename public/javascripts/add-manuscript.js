$(document).ready(function() {

    // hide all the sub menu's
    $( ".sublist").hide()

	$(".mainlist").toggle(function(){
        $( ".sublist").slideUp(500);
        $(this).parent().next().slideDown(500);
		//return false;
	},
	function(){
		$(this).parent().next().slideUp(500);
		//return false;
	});

	$("#SJA-manuscript").click(function() {
        highliteElement( $(this) )
	    showManuscriptContent( 'SJA');
	});

    $("#SJA-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJA');
    });


    $("#SJC-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJC');
    });

    $("#SJC-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJC');
    });


    $("#SJD-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJD');
    });

    $("#SJD-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJD');
    });


    $("#SJE-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJE');
    });

    $("#SJE-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJE');
    });


    $("#SJEx-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJEx');
    });

    $("#SJEx-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJEx');
    });


    $("#SJL-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJL');
    });

    $("#SJL-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJL');
    });


    $("#SJP-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJP');
    });

    $("#SJP-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJP');
    });


    $("#SJU-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJU');
    });

    $("#SJU-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJU');
    });


    $("#SJV-manuscript").click(function() {
        highliteElement( $(this) )
        showManuscriptContent( 'SJV');
    });

    $("#SJV-description").click(function() {
        highliteElement( $(this) )
        showManuscriptDescription( 'SJV');
    });
});

function highliteElement( element ) {
    $( ".sublist-item").removeClass( "active");
    element.addClass( "active");
}

function showManuscriptContent( manuscript ) {

   var resource_name = manuscript + "-MS-alltags.html"
   var main_title = $( "#" + manuscript + "-title").text()
   $("#manuscript").empty();
   $("#active-title").html( "<h2>" + main_title + "</h2>")

   $("#manuscript").load(resource_name, function(response, status, xhr) {
      if (status == "error") {
         var msg = "Sorry but there was an error: ";
         alert(msg + xhr.status + " " + xhr.statusText);
      }
   });
}