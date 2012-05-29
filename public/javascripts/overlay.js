$(document).ready(function() {
	$(".overlay-trigger").overlay({});
	
	if (!( $.browser.msie )) {
		$("body").append("<div id='grayout' style='display: none;'></div>");
	}

	$(".overlay-trigger").click(function() {
	    $("#grayout").fadeIn("slow");
	});
	
	$(".close").click(function() {
	    $("#grayout").fadeOut("slow");
	});

	$(".close-overlay").click(function() {
            var theOverlay = $(this).parent();
            var theCloseBtn = $(theOverlay).find('.close');
            theCloseBtn.click();
	});
});