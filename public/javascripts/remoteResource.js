function loadRemoteResource( resource_name, result_div ) {

    $(result_div).load( resource_name, function(response, status, xhr ) {

       // just in case we have one...
       clearWaitOverlay();

       if (status == "error") {

          var msg = "(loading: " + resource_name + ", got: " + xhr.status + " " + xhr.statusText + ")";
          $.blockUI({
              overlayCSS: { backgroundColor: '#FD3C3C' },
              message: '<h1>Sorry, there was an error. Please try again.</h1><h4>' + msg + '</h4>',
              timeout: 1750
          });
       }
    });
}
