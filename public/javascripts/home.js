$(document).ready(function() {

    // disguise this as we dont need it
    $("#content-controls").css("background-color", "#F0E7CF");

    $("#the-poem").click(function() {
        redirectTo( "thepoem" );
    });

    $("#about").click(function() {
        redirectTo( "about" );
    });

    $("#partners").click(function() {
        redirectTo( "partners" );
    });

    $("#how-to-use").click(function() {
        redirectTo( "use" );
    });

    $("#terms-and-conditions").click(function() {
        redirectTo( "terms" );
    });

    // grab the URL paramaters...
    var params = parseURL();
    showContent( params["page"] );
});

function redirectTo( pageName ) {

    var newURL = "index.html?page=" + pageName;
    document.location.href = newURL;
}

function showContent( pageName ) {

    // un-highlight everything...
    $(".mainlist-item").removeClass( "active");

    switch( pageName ) {
        case "thepoem":
            $("#the-poem").addClass( "active");
            loadContent( "/thepoem.html" )
           break;

        case "about":
            $("#about").addClass( "active");
            loadContent( "/about.html")
            break;

        case "partners":
            $("#partners").addClass( "active");
            loadContent( "/partners.html")
            break;

        case "use":
            $("#how-to-use").addClass( "active");
            loadContent( "/use.html")
            break;

        case "terms":
            $("#terms-and-conditions").addClass( "active");
            loadContent( "/terms.html")
            break;
    }
}

function loadContent( resource_name ) {

    $("#content-display").empty();

    // load the resource and report an error if unsuccessful
    loadRemoteResource( resource_name, "#content-display", null );
}