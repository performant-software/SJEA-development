$(document).ready(function() {

    // thorn
    $("#special-button-1").click(function() {
        addCharacter( '\u00DE');
        $("#search-text").focus();
        setCaretPosition( "search-text", $("#search-text").val( ).length );
    });

    // yogh
    $("#special-button-2").click(function() {
        addCharacter( '\u021D');
        $("#search-text").focus();
        setCaretPosition( "search-text", $("#search-text").val( ).length );
    });

    $("#search-text").focus();
});


function addCharacter( character ) {
    $("#search-text").val( $("#search-text").val() + character )
}

// grabbed this from a google search...
function setCaretPosition(elemId, caretPos) {
    var elem = document.getElementById(elemId);

    if(elem != null) {
        if(elem.createTextRange) {
            var range = elem.createTextRange();
            range.move('character', caretPos);
            range.select();
        }
        else {
            if(elem.selectionStart) {
                elem.focus();
                elem.setSelectionRange(caretPos, caretPos);
            }
            else
                elem.focus();
        }
    }
}