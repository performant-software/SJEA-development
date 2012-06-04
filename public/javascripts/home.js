$(document).ready(function() {

    $("#the-poem").click(function() {
        poemContent();
    });

    $("#about").click(function() {
        aboutContent();
    });

    $("#partners").click(function() {
        partnersContent();
    });

    $("#how-to-use").click(function() {
        useContent();
    });

    $("#terms-and-conditions").click(function() {
        termsContent();
    });
});

function poemContent( ) {

    $(".mainlist-item").removeClass( "active");
    $("#the-poem").addClass( "active");
    loadContent( "/thepoem.html")
}

function aboutContent( ) {

    $(".mainlist-item").removeClass( "active");
    $("#about").addClass( "active");
    loadContent( "/about.html")
}

function partnersContent( ) {

    $(".mainlist-item").removeClass( "active");
    $("#partners").addClass( "active");
    loadContent( "/partners.html")
}

function useContent( ) {

    $(".mainlist-item").removeClass( "active");
    $("#how-to-use").addClass( "active");
    loadContent( "/use.html")
}

function termsContent( ) {

    $(".mainlist-item").removeClass( "active");
    $("#terms-and-conditions").addClass( "active");
    loadContent( "/terms.html")
}

function loadContent( resource_name ) {

    $("#content-display").empty();

    // load the resource and report an error if unsuccessful
    loadRemoteResource( resource_name, "#content-display" );
}