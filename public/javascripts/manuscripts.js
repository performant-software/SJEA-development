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

        // get the current view
        var view = getManuscriptViewState( );
        redirectToManuscript( $("#transcription-name").attr("href"), view );
    });

    //
    // menu item handlers
    //

    $("#SJA-manuscript").click(function() {
        redirectToManuscript( "SJA", "diplomatic")
    });

    $("#SJA-description").click(function() {
        redirectToDescription( "SJA" );
    });


    $("#SJC-manuscript").click(function() {
        redirectToManuscript( "SJC", "diplomatic")
    });

    $("#SJC-description").click(function() {
        redirectToDescription( "SJC" );
    });


    $("#SJD-manuscript").click(function() {
        redirectToManuscript( "SJD", "diplomatic")
    });

    $("#SJD-description").click(function() {
        redirectToDescription( "SJD" );
    });


    $("#SJE-manuscript").click(function() {
        redirectToManuscript( "SJE", "diplomatic")
    });

    $("#SJE-description").click(function() {
        redirectToDescription( "SJE" );
    });


    $("#SJEx-manuscript").click(function() {
        redirectToManuscript( "SJEx", "diplomatic")
    });

    $("#SJEx-description").click(function() {
        redirectToDescription( "SJEx" );
    });


    $("#SJL-manuscript").click(function() {
        redirectToManuscript( "SJL", "diplomatic")
    });

    $("#SJL-description").click(function() {
        redirectToDescription( "SJL" );
    });


    $("#SJP-manuscript").click(function() {
        redirectToManuscript( "SJP", "diplomatic")
    });

    $("#SJP-description").click(function() {
        redirectToDescription( "SJP" );
    });


    $("#SJU-manuscript").click(function() {
        redirectToManuscript( "SJU", "diplomatic")
    });

    $("#SJU-description").click(function() {
        redirectToDescription( "SJU" );
    });


    $("#SJV-manuscript").click(function() {
        redirectToManuscript( "SJV", "diplomatic")
    });

    $("#SJV-description").click(function() {
        redirectToDescription( "SJV" );
    });

    // load the URL paramaters...
    var params = parseURL();
    // if we are going to a specific page...
    if( ( params["manuscript"] != null ) && ( params["view"] != null ) ) {
        // set the GUI widgets to the correct state
        setGUIForManuscript( params["manuscript"], params["view"] );
        showManuscript( params["manuscript"], params["view"], params["folio"] );

    } else if( params["description"] != null ) {
        // set the GUI widgets to the correct state
        setGUIForDescription( params["description"] );
        showDescription( params["description"] );

    } else {
       // otherwise, set the default view...
       $("#overview").addClass( "active");
    }
});

function showManuscript( name, view, scrollto_id ) {

    // set the manuscript name; we may need this later when setting a new view
    $("#transcription-name").attr("href", name );

    // remove any color box decoration/handlers... we will add more shortly.
    $.colorbox.remove();

    // nice wait display...
    showWaitOverlay();

    // load the resource and report an error if unsuccessful
    var resource = name.replace( "SJ", "MS") + "-" + view + ".html";
    loadRemoteResource( resource, "#content-display", makeDocReadyCallback( false, scrollto_id ) );
}

function showDescription( name ) {

    // remove any color box decoration/handlers... we will add more shortly.
    $.colorbox.remove();

    // nice wait display...
    showWaitOverlay();

    // load the resource and report an error if unsuccessful
    var resource = name + "-description.html";
    loadRemoteResource( resource, "#content-display", makeDocReadyCallback( true, null ) );
}

function redirectToManuscript( name, view ) {

    var newURL = "manuscript.html?manuscript=" + name + "&view=" + view;
    document.location.href = newURL;
}

function redirectToDescription( name ) {

    var newURL = "manuscript.html?description=" + name;
    document.location.href = newURL;
}

function setGUIForManuscript( name, view ) {

    // show the transcript selector, color key and XML button
    $("#view-control").show();
    $("#view-control-title").show();
    $("#color-key-div").show();
    $("#xml-button").show();

    // clear any existing content...
    $("#content-display").empty( );

    // configure the XML button so it does the right thing...
    setXMLButtonAttributes( name );

    // set up the nav bar correctly...
    var navElement = $( "#" + name + "-manuscript");
    navElement.parent( ).slideDown( 0 );
    highliteNavElement( navElement );

    // set the view dropdown
    setManuscriptViewState( view )
}

function setGUIForDescription( name ) {

    // hide the transcript selector and color key and show the XML button
    $("#view-control").hide();
    $("#view-control-title").hide();
    $("#color-key-div").hide();
    $("#xml-button").show();

    // clear any existing content...
    $("#content-display").empty();

    // configure the XML button so it does the right thing...
    setXMLButtonAttributes( name.replace( "SJ", "") + "Description" );

    // set up the nav bar correctly...
    var navElement = $( "#" + name + "-description");
    navElement.parent().slideDown( 0 );
    highliteNavElement( navElement );
}

function setXMLButtonAttributes( name ) {

    var xml_href = "/xml/" + name + ".xml";
    $("#xml-button").attr("href", xml_href );
    $("#xml-button").attr("target", "_blank" );
}

function highliteNavElement( element ) {

    // clear any existing highlights...
    $( ".sublist-item").removeClass( "active");
    $("#overview").removeClass( "active");

    // and highlight this element.
    element.addClass( "active");
}

// get the state of the view dropdown so we know which view to display
function getManuscriptViewState( ) {

    var view = $("#view-control option:selected").text( );
    switch( view ) {
        case "All Tags":
            return( "alltags" );

        case "Critical":
            return( "critical" );

        case "Diplomatic":
            return( "diplomatic" );

        case "Scribal":
        default:
           return( "scribal" );
    }
}

// set the state of the view drop-down to reflect what we are currently showing
function setManuscriptViewState( name ) {
    $("#view-control" ).val( name );
}

function makeDocReadyCallback( enable_popup, scrollto_id ) {

    var callback = function( ) {

        if( enable_popup == true ) {
           // enable the image pop-up behavior
           $( ".popup-span" ).dialog({ width: "auto", autoOpen: false, show: "blind", hide: "blind" });
        }

        // attach the click handler to open the image pop-up
        $(".graphic" ).click(function() {
            var popupdiv = "#" + $(this).attr( "src" ) + "-popup";
            $( popupdiv ).dialog( "open" )
        });

        // Enable the lightbox behavior
        $(".imglightbox").colorbox( { iframe:true, width: "70%", height: "95%" } );

        // decorate the tooltips...
        decorateTooltips( );

        // scroll to the right position if appropriate...
        if( scrollto_id != null ) {
           $('html,body').animate( { scrollTop: $("#" + scrollto_id ).offset().top - 15 },'slow' );
        }
    }

    return( callback )

}