$(document).ready(function() {

    // barred H
    $("#special-button-1").click(function() {
        addCharacter( '\u0127');
    });

    // barred L
    $("#special-button-2").click(function() {
        addCharacter( '\u0142');
    });

    // thorn
    $("#special-button-3").click(function() {
        addCharacter( '\u00DE');
    });

    // yogh
    $("#special-button-4").click(function() {
        addCharacter( '\u021D');
    });

    $("#search-text").focus();
});

function addCharacter( character ) {
    $("#search-text").val( $("#search-text").val() + character )
}
