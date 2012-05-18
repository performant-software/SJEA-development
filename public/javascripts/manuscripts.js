$(document).ready(function() {

    // hide all the sub menu's
    $( ".sublist").hide()

    // sub menu toggle behavior handlers
	$(".mainlist-item").toggle(function(){
        $( ".sublist").slideUp(100);
        $(this).parent().next().slideDown(400);
	},
	function(){
		$(this).parent().next().slideUp(100);
	});

    // selection box changes
    $("select").change(function () {

        // are we currently showing a manuscript?
        var current_manuscript = $("#transcription-name").attr("href");
        if (current_manuscript.length != 0 ) {
            showManuscriptContent( current_manuscript )
        }
    });

    //
    // menu item handlers
    //

    $("#overview").click(function() {
        $( ".sublist").slideUp(300);
        highliteElement( $(this) );
        showOverviewContent( );
    });

    $("#SJA-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJA');
    });

    $("#SJA-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJA');
    });


    $("#SJC-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJC');
    });

    $("#SJC-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJC');
    });


    $("#SJD-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJD');
    });

    $("#SJD-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJD');
    });


    $("#SJE-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJE');
    });

    $("#SJE-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJE');
    });


    $("#SJEx-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJEx');
    });

    $("#SJEx-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJEx');
    });


    $("#SJL-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJL');
    });

    $("#SJL-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJL');
    });


    $("#SJP-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJP');
    });

    $("#SJP-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJP');
    });


    $("#SJU-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJU');
    });

    $("#SJU-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJU');
    });


    $("#SJV-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJV');
    });

    $("#SJV-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'SJV');
    });
});

function highliteElement( element ) {
    $( ".sublist-item").removeClass( "active");
    $("#overview").removeClass( "active");
    element.addClass( "active");
}

function showManuscriptContent( manuscript_prefix ) {

    var transcript_type = $("select option:selected").text();
    var resource_name = manuscript_prefix + "-MS-"
    switch( transcript_type ) {
        case "All Tags":
            resource_name += "alltags"
            break;

        case "Critical":
            resource_name += "critical"
            break;

        case "Diplomatic":
            resource_name += "diplomatic"
            break;

        case "Scribal":
        default:
           resource_name += "scribal"
           break;
    }

    // set the manuscript name
    $("#transcription-name").attr("href", manuscript_prefix );

    $("#content-display").empty();

    $("#content-display").load(resource_name, function(response, status, xhr) {
       if (status == "error") {
          var msg = "Sorry but there was an error: ";
          alert(msg + xhr.status + " " + xhr.statusText);
       }
    });
}

function showManuscriptDescription( manuscript_prefix ) {

    // clear the manuscript name as we are not displaying one
    $("#transcription-name").attr("href", "");

    var resource_name = manuscript_prefix + "-description"
    $("#content-display").empty();

    $("#content-display").load(resource_name, function(response, status, xhr) {
       if (status == "error") {
          var msg = "Sorry but there was an error: ";
          alert(msg + xhr.status + " " + xhr.statusText);
       }
    });
}

function showOverviewContent( ) {
    $("#content-display").empty();
}