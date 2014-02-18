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
		
		/*
		snap: ".ship_container",
		snapMode: "inner"
		*/	
    });
    $(".ship_container").droppable({
      drop: function( event, ui ) {
      	//In here I will add the part
        $( this )
          .addClass( "ui-state-highlight" ).html( ui.draggable.html() );
        $( this ).data("part", ui.draggable.html());
   		/*snapToMiddle(ui.draggable,$(this));*/
      },
    }); 	
    $(".button").on('click', function() {alert("The value is: " + $(".ship_container").data("part"));});
   	function snapToMiddle(dragger, target){
	    var topMove = target.position().top - dragger.data('position').top + (target.outerHeight(true) - dragger.outerHeight(true)) / 2;
	    var leftMove= target.position().left - dragger.data('position').left + (target.outerWidth(true) - dragger.outerWidth(true)) / 2;
	    dragger.animate({top:topMove,left:leftMove},{duration:600,easing:'easeOutBack'});
	} 
    	
});