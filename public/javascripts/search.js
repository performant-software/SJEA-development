$(document).ready(function() {

    // thorn
    $("#special-button-1").click(function() {
        addCharacter( '\u00DE');
        setCaretPosition( "search-text", $("#search-text").val( ).length );
    });

    // yogh
    $("#special-button-2").click(function() {
        addCharacter( '\u021D');
        setCaretPosition( "search-text", $("#search-text").val( ).length );
    });

    // add a return key handler
    $("#search-text").keydown( function(event){
       if( event.keyCode == 13 ) {
          $("#search-submit").click( );
          // prevent this from being handled elsewhere...
          event.preventDefault( );
       }
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