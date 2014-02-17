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
		/*helper: "clone",*/
		cursor: "move", 
		cursorAt: { top: 56, left: 56 },
		distance: 20,
		create: function(){$(this).data('position',$(this).position());},
		/*revert : function(event, ui) {
            // on older version of jQuery use "draggable"
            // $(this).data("draggable")
            // on 2.x versions of jQuery use "ui-draggable"
            // $(this).data("ui-draggable")
            $(this).data("uiDraggable").originalPosition = {
                top : 0,
                left : 0
            };
            // return boolean
            return !event;
            // that evaluate like this:
            // return event !== false ? false : true;

       	},*/
		start: function() {
			//if in the part pool, duplicate the element and place it in the place
			//if on the ship, remove the ship part from the javascript object
			},
		drag: function() {
			//nothing?
			},
		stop: function (ev, ui) {
			//if not in a ship, return to the part pool (and then delete it after the animation)
			//if it ends in the ship, add the ship part to the javascript object
            var pos = $(ui.helper).offset();
            objName = "#clonediv" + counter;
            $(objName).css({
                "left": pos.left,
                "top": pos.top
            });
            $(objName).removeClass("drag");
            //When an existiung object is dragged
            $(objName).draggable({
                containment: 'parent',
                stop: function (ev, ui) {
                    var pos = $(ui.helper).offset();
                    console.log($(this).attr("id"));
                    console.log(pos.left);
                    console.log(pos.top);
                }
            });        			
		},
		/*
		snap: ".ship_container",
		snapMode: "inner"
		*/	
    });
    $(".ship_container").droppable({
      drop: function( event, ui ) {
      	//In here I will add the part
        $( this )
          .addClass( "ui-state-highlight" ).html( "Dropped!" );
        $( this ).data("part", ui.draggable.html());
        /*
        if (ui.helper.attr('id').search(/drag[0-9]/) != -1) {
                counter++;
                var element = $(ui.draggable).clone();
                element.addClass("tempclass");
                $(this).append(element);
                $(".tempclass").attr("id", "clonediv" + counter);
                $("#clonediv" + counter).removeClass("tempclass");
                //Get the dynamically item id
                draggedNumber = ui.helper.attr('id').search(/drag([0-9])/);
                itemDragged = "dragged" + RegExp.$1;
                console.log(itemDragged);
                $("#clonediv" + counter).addClass(itemDragged);
            }
            */
           ui.draggable.offset().top;
           snapToMiddle(ui.draggable,$(this));
      },
      out: function( event, ui ) {
      	//In here I will remove the part
      	$( this )
          .removeClass( "ui-state-highlight" ).html( "Drop Here!" );
          $( this ).data("part", ui.draggable.html());
      }
    }); 	
    $(".button").on('click', function() {alert("The value is: " + $(".ship_container").data("part"));});
   	function snapToMiddle(dragger, target){
	    var topMove = target.position().top - dragger.data('position').top + (target.outerHeight(true) - dragger.outerHeight(true)) / 2;
	    var leftMove= target.position().left - dragger.data('position').left + (target.outerWidth(true) - dragger.outerWidth(true)) / 2;
	    dragger.animate({top:topMove,left:leftMove},{duration:600,easing:'easeOutBack'});
	} 
    	
});