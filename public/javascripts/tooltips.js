$(document).ready(function() {

    $(".standard-tooltip").tooltip({
        opacity: 0.8,
		effect: 'fade',
	 	position: 'top center',
		offset: [-8, 25],
		relative: true,
        delay: 30,
        events: {
			def: "mouseover, mouseout"
		}
	});
});