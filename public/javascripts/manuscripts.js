$(document).ready(function() {

    // hide all the sub menu's
    $( ".sublist").hide();

    // hide the transcript selector, color key and XML button
    $("#view-control").hide();
    $("#view-control-title").hide();
    $("#color-key-div").hide();
    $("#xml-button").hide();

    // sub menu toggle behavior handlers
	$(".mainlist-item").toggle(function(){
        $( ".sublist").slideUp(75);
        $(this).parent().next().slideDown(450, function(){
           var item = $(this).children('.sublist-item').first();
           highliteElement( item );
           showManuscriptContent ( item.attr("id").split("-")[0] );
        });
	},
	function(){
		$(this).parent().next().slideUp(75);
	});

    // selection box changes
    $("#view-control").change(function () {

        // are we currently showing a manuscript?
        var current_manuscript = $("#transcription-name").attr("href");
        if (current_manuscript.length != 0 ) {
            showManuscriptContent( current_manuscript )
        }
    });

    //
    // menu item handlers
    //

    $("#SJA-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJA');
    });

    $("#SJA-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'A');
    });


    $("#SJC-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJC');
    });

    $("#SJC-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'C');
    });


    $("#SJD-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJD');
    });

    $("#SJD-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'D');
    });


    $("#SJE-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJE');
    });

    $("#SJE-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'E');
    });


    $("#SJEx-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJEx');
    });

    $("#SJEx-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'Ex');
    });


    $("#SJL-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJL');
    });

    $("#SJL-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'L');
    });


    $("#SJP-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJP');
    });

    $("#SJP-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'P');
    });


    $("#SJU-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJU');
    });

    $("#SJU-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'U');
    });


    $("#SJV-manuscript").click(function() {
        highliteElement( $(this) );
        showManuscriptContent( 'SJV');
    });

    $("#SJV-description").click(function() {
        highliteElement( $(this) );
        showManuscriptDescription( 'V');
    });

    // set initial view...
    $("#overview").addClass( "active");
});

function highliteElement( element ) {
    $( ".sublist-item").removeClass( "active");
    $("#overview").removeClass( "active");
    element.addClass( "active");
}

function showManuscriptContent( manuscript_prefix ) {

    var transcript_type = $("#view-control option:selected").text();
    var resource_name = manuscript_prefix.replace( "SJ", "MS" ) + "-"
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

    // show the transcript selector, color key and XML button
    $("#view-control").show();
    $("#view-control-title").show();
    $("#color-key-div").show();
    $("#xml-button").show();

    var xml_href = "/xml/" + manuscript_prefix + ".xml"
    $("#xml-button").attr("href", xml_href );
    $("#xml-button").attr("target", "_blank" );

    // nice wait display...
    showWaitOverlay();

    $("#content-display").load(resource_name, function(response, status, xhr) {
       clearWaitOverlay();
       if (status == "error") {
          var msg = "Sorry but there was an error: ";
          alert(msg + xhr.status + " " + xhr.statusText);
       }
    });
}

function showManuscriptDescription( manuscript_prefix ) {

    // clear the manuscript name as we are not displaying one
    $("#transcription-name").attr("href", "");

    // hide the transcript selector, color key and XML button
    $("#view-control").hide();
    $("#view-control-title").hide();
    $("#color-key-div").hide();
    $("#xml-button").hide();

    var resource_name = manuscript_prefix + "Description"
    $("#content-display").empty();

    // nice wait display...
    showWaitOverlay();

    $("#content-display").load(resource_name, function(response, status, xhr) {
       clearWaitOverlay();
       if (status == "error") {
          var msg = "Sorry but there was an error: ";
          alert(msg + xhr.status + " " + xhr.statusText);
       }
    });
}