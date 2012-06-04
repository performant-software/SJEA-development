$(document).ready(function() {

   $("#params-div").hide();

    $(".new-page").click(function() {
       var page = $(this).attr( "page" );
       newSearch( page );
    });

});

function newSearch( page ) {
    var searchfor = $( "#q-searchfor").attr( "data");
    var docname = $( "#q-docname").attr( "data");
    var facetname = $( "#q-facetname").attr( "data");
    //alert( "searchfor=" + searchfor + ", docname = " + docname + ", facet = " + facetname + ", page = " + page );

    var newURL = "/solrsearch/dosearch?searchfor=" + searchfor + "&facet=" + facetname + "&transcription=" + docname + "&page=" + page;
    //alert( newURL )
    document.location.href = newURL;
}