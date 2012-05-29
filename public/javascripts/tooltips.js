$(document).ready(function() {

    $(".standard-tooltip").tooltip({
		effect: 'fade',
	 	position: 'top center',
		offset: [-8, 25],
		relative: true,
		events: {
			def: "mouseover, mouseout"
		}
	});
});