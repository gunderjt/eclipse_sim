function change_image (element, part) {
	
}

$(document).ready( function () {
	$(".part_container").dblclick(function() {
  		$(this).removeClass($(this).data("part"));
	});
});

