function parseURL( ) {

    // resulting key/value containing any/each of the URL parameters
    var params = {};

    // split the URL by ? character
    var plist = document.URL.split( "?" );
    var ix = 1;
    for ( ix = 1; ix < plist.length; ix++ ) {
        var nv = plist[ ix ].split( "=" )
        if ( nv.length == 2 ) {
           params[ nv[ 0 ] ] = nv[ 1 ];
        }
    }
    return params;
}