$(document).ready(function() {

    $("#special-button-1").click(function() {
        addCharacter( '\u210F')
    });

    $("#special-button-2").click(function() {
        addCharacter( '\u019A')
    });

    $("#special-button-3").click(function() {
        addCharacter( '\u00DE')
    });

    $("#special-button-4").click(function() {
        addCharacter( '\u04E0')
    });
});

function addCharacter( character ) {
    $("#search-text").val( $("#search-text").val() + character )
}
