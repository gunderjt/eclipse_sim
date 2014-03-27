/*Three things I want to work on:
*1. I want object to clone and persist when they are dropped in the box
*2.  I want objects that are removed from accepted boxes to be deleted
*3. I want newly dragged objects to "overwrite" old objects.
* 	--idea: store the object
*/
$(document).ready(function() {
	//Counter
    counter = 0;
	$( ".part" ).draggable(
		{
		helper: "clone",
		cursor: "move", 
		cursorAt: { top: 56, left: 56 },
		distance: 20,
		
    });
    $(".part_container").droppable({
      drop: function( event, ui ) {
      	//In here I will add the part      	
      	add_part(ui.draggable.attr('id'), $(this));
      },
    }); 	
    $(".button").on('click', function() {alert("The value is: " + $(".ship_container").data("part"));});
 	//$( "#parts_pool" ).accordion();
 	$( ".races" ).menu(); 
 	$("#parts_pool").tabs();
 	$( ".spinner" ).spinner({
      spin: function( event, ui ) {
        if ( ui.value > 8 ) {
          $( this ).spinner( "value", 0 );
          return false;
        } else if ( ui.value < 0 ) {
          $( this ).spinner( "value", 8 );
          return false;
        }
      }
    });
    $("#calculate").on('click', function () {
    	var ship = calculate("att_d");
    	console.log(ship);
    });
});
function snapToMiddle(dragger, target){
    var topMove = target.position().top - dragger.data('position').top + (target.outerHeight(true) - dragger.outerHeight(true)) / 2;
    var leftMove= target.position().left - dragger.data('position').left + (target.outerWidth(true) - dragger.outerWidth(true)) / 2;
    dragger.animate({top:topMove,left:leftMove},{duration:600,easing:'easeOutBack'});
}