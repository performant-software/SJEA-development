$(document).ready(function() {
   decorateTooltips( );
});

function decorateTooltips( ) {

    $(".standard-tooltip").tooltip({
        opacity: 0.8,
		effect: 'fade',
	 	position: 'top center',
		relative: true,
        delay: 100,
        events: {
			def: "mouseover, mouseout"
		}
	});

}