$(document).ready(function() {

    $(".standard-tooltip").tooltip({
		effect: 'fade',
	 	position: 'top center',
		offset: [-8, 25],
		relative: true,
        delay: 0,
        events: {
			def: "mouseover, mouseout"
		}
	});
});