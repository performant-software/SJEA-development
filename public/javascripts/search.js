$(document).ready(function() {

    // barred H
    $("#special-button-1").click(function() {
        addCharacter( '\u0127');
        $("#search-text").focus();
    });

    // barred L
    $("#special-button-2").click(function() {
        addCharacter( '\u0142');
        $("#search-text").focus();
    });

    // thorn
    $("#special-button-3").click(function() {
        addCharacter( '\u00DE');
        $("#search-text").focus();
    });

    // yogh
    $("#special-button-4").click(function() {
        addCharacter( '\u021D');
        $("#search-text").focus();
    });

    $("#search-text").focus();
});


function addCharacter( character ) {
    $("#search-text").val( $("#search-text").val() + character )
}