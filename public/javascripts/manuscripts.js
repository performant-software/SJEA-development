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
           $(this).children('.sublist-item').first().click();
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

    var params = parseURL();
    // if we are going to a specific page...
    if( params["manuscript"] != null ) {
        var element = $( "#" + params["manuscript"] + "-manuscript");
        element.parent().slideDown(450, function(){
           element.click();
        });
    } else if( params["description"] != null ) {
        var element = $( "#" + params["description"] + "-description");
        element.parent().slideDown(450, function(){
           element.click();
        });
    } else {
       // otherwise, set the default view...
       $("#overview").addClass( "active");
    }
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
            resource_name += "alltags.html"
            break;

        case "Critical":
            resource_name += "critical.html"
            break;

        case "Diplomatic":
            resource_name += "diplomatic.html"
            break;

        case "Scribal":
        default:
           resource_name += "scribal.html"
           break;
    }

    // set the manuscript name; we use this later when setting a new view
    $("#transcription-name").attr("href", manuscript_prefix );

    // show the transcript selector, color key and XML button
    $("#view-control").show();
    $("#view-control-title").show();
    $("#color-key-div").show();
    $("#xml-button").show();

    var xml_href = "/xml/" + manuscript_prefix + ".xml"
    $("#xml-button").attr("href", xml_href );
    $("#xml-button").attr("target", "_blank" );

    // clear any existing content...
    $("#content-display").empty();

    // nice wait display...
    showWaitOverlay();

    // load the resource and report an error if unsuccessful
    loadRemoteResource( resource_name, "#content-display" );
}

function showManuscriptDescription( manuscript_prefix ) {

    // clear the manuscript name as we are not displaying one
    $("#transcription-name").attr("href", "");

    // hide the transcript selector and color key and make sure the XML button is showing
    $("#view-control").hide();
    $("#view-control-title").hide();
    $("#color-key-div").hide();
    $("#xml-button").show();

    var resource_name = manuscript_prefix + "Description"

    var xml_href = "/xml/" + resource_name + ".xml"
    $("#xml-button").attr("href", xml_href );
    $("#xml-button").attr("target", "_blank" );

    // clear any existing content...
    $("#content-display").empty();

    resource_name += ".html"

    // nice wait display...
    showWaitOverlay();

    // load the resource and report an error if unsuccessful
    loadRemoteResource( resource_name, "#content-display" );
}