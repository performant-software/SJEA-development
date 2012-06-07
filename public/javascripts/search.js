$(document).ready(function() {

    // thorn
    $("#special-button-1").click(function() {
        addCharacter( '\u00DE');
        $("#search-text").focus();
    });

    // yogh
    $("#special-button-2").click(function() {
        addCharacter( '\u021D');
        $("#search-text").focus();
    });

    $("#search-text").focus();
});


function addCharacter( character ) {
    $("#search-text").val( $("#search-text").val() + character )
}