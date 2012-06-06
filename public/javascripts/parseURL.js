function parseURL( ) {

    // resulting key/value containing any/each of the URL parameters
    var params = {};

    // split the URL by the ? character
    var pstring = document.URL.split( "?" );
    if( pstring.length == 2 ) {
        // do we have multiple paramaters?
        if( pstring[ 1 ].indexOf( "&" ) != -1 ) {

           // split the parameter list up...
           var plist = pstring[ 1 ].split( "&" );
           var ix = 0;
           for ( ix = 0; ix < plist.length; ix++ ) {
               var nv = plist[ ix ].split( "=" )
               if ( nv.length == 2 ) {
                   params[ nv[ 0 ] ] = nv[ 1 ];
               }
           }
        } else {
            var nv = pstring[ 1 ].split( "=" )
            if ( nv.length == 2 ) {
               params[ nv[ 0 ] ] = nv[ 1 ];
            }
        }
    }

    return params;
}