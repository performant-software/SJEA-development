$(document).ready(function() {
   decorateTooltips( );
});

function decorateTooltips( ) {

    $(".standard-tooltip").tooltip({
        opacity: 0.8,
		fade: 250,
	 	position: 'top center',
        offset: [-20,-75],
		relative: true,
        delay: 0,
        events: {
			def: "mouseover, mouseout"
		}
	});

}