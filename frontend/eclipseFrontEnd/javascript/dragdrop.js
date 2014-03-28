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
		opacity: 0.3,
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
    	var battle = new Object();
    	var side = ["att", "def"];
    	var ship_id = ["i", "c", "d", "s"];
    	for(var i = 0; i < side.length; i++){
    		battle[side[i]] = create_fleet(side[i]);
    		var race = $("#"+side[i]).data('race');    		
    		switch(race){
				case "Terran":
					break;
				case "Planta":
					battle[side[i]].i.initiative += -2;
					battle[side[i]].s.initiative += -2;
					battle[side[i]].c.initiative += -1;
					for (var j =0; j < ship_id.length; j++){						
						battle[side[i]][ship_id[j]].computer += 1;
						battle[side[i]][ship_id[j]].power += 1;
					}
					break;
				case "Exiles":
					battle[side[i]].s.initialize += -4;
					battle[side[i]].s.hull += 1;
					battle[side[i]].s.power += 1;
					break;
				case "Rho Indi":
					for (var j =0; j < ship_id.length; j++){						
						battle[side[i]][ship_id[j]].shield += -1;
						battle[side[i]][ship_id[j]].initiative += 1;						
					}
					break;
				case "Orion":
					for (var j =0; j < ship_id.length; j++){						
						battle[side[i]][ship_id[j]].initiative += 1;
						if (ship_id[j] == "i"){
							battle[side[i]][ship_id[j]].power += 1;	
						}
						else if (ship_id[j] == "c"){
							battle[side[i]][ship_id[j]].power += 2;	
						}
						else if (ship_id[j] == "d"){
							battle[side[i]][ship_id[j]].power += 3;	
						}
					}
					break;
				case "Eridani":
					battle[side[i]].d.power += 1;
					break;
				case "Standard":
					break;
		    }
		}
    	console.log(battle);
    });
});
function snapToMiddle(dragger, target){
    var topMove = target.position().top - dragger.data('position').top + (target.outerHeight(true) - dragger.outerHeight(true)) / 2;
    var leftMove= target.position().left - dragger.data('position').left + (target.outerWidth(true) - dragger.outerWidth(true)) / 2;
    dragger.animate({top:topMove,left:leftMove},{duration:600,easing:'easeOutBack'});
}