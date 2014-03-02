//To Do: pop outs indicating which is default, accordian menu of aliens, quantity
//calculate ships
/*
 * 
 * <ul class="races">
				<li><a href="#">Terran</a></li>
				<li><a href="#">Planta</a></li>
				<li><a href="#">Exiles</a></li>
				<li><a href="#">Rho Indi</a></li>
				<li><a href="#">Orion</a></li>
				<li><a href="#">Alien Ships</a>
					 <ul>
						<li><a href="#">Standard</a></li>
						<li><a href="#">Cruisers</a>
							<ul>
								<li><a href="#" class='alien_container alienCruiser1'></a></li>
								<li><a href="#" class='alien_container alienCruiser2'></a></li>
								<li><a href="#" class='alien_container alienCruiser3'></a></li>
								<li><a href="#" class='alien_container alienCruiser4'></a></li>
								<li><a href="#" class='alien_container alienCruiser5'></a></li>
								<li><a href="#" class='alien_container alienCruiser6'></a></li>
								<li><a href="#" class='alien_container alienCruiser7'></a></li>
								<li><a href="#" class='alien_container alienCruiser8'></a></li>
							</ul>
						</li>
						<li><a href="#">Dreadnoughts</a></li>
						<li><a href="#">Galactic Center</a></li>
					</ul>
				</li>
			</ul>
 */

function initialize_board(race, side){
	//check to see if need to restore to defaults
	if($("#"+side).data('status') == 'modified'){
		$("#"+side + " .part_container").removeClass("hidden");
		/*TO DO: remove image modificatons*/
		$("#"+side + " .s1").css("top", "65px");
		$("#"+side + " .s5").css("top", "65px");
		$("#"+side).data('status', "");
	}
	//set interceptor
	remove_part($("#"+side + " .i1"));
	add_part("ion_cannon",$("#"+side + " .i2"));
	add_part("nuclear_source",$("#"+side + " .i3"));
	add_part("nuclear_drive",$("#"+side + " .i4"));
	//set cruiser
	add_part("hull",$("#"+side + " .c1"));
	remove_part($("#"+side + " .c2"));
	add_part("ion_cannon",$("#"+side + " .c3"));
	add_part("nuclear_source",$("#"+side + " .c4"));
	add_part("electron_computer",$("#"+side + " .c5"));
	add_part("nuclear_drive",$("#"+side + " .c6"));
	//set dreadnought
	add_part("ion_cannon",$("#"+side + " .d1"));
	add_part("hull",$("#"+side + " .d2"));
	remove_part($("#"+side + " .d3"));
	add_part("hull",$("#"+side + " .d4"));
	add_part("nuclear_source",$("#"+side + " .d5"));
	add_part("ion_cannon",$("#"+side + " .d6"));
	add_part("electron_computer",$("#"+side + " .d7"));
	add_part("nuclear_drive",$("#"+side + " .d8"));
	//set starbase
	add_part("hull",$("#"+side + " .s1"));
	add_part("ion_cannon",$("#"+side + " .s2"));
	add_part("hull",$("#"+side + " .s3"));
	remove_part($("#"+side + " .s4"));
	add_part("electron_computer",$("#"+side + " .s5"));
	
	switch (race){
		case 'Terran':
			break;
		case 'Planta':
			$("#"+side + " .i1").addClass("hidden");
			$("#"+side + " .c2").addClass("hidden");
			$("#"+side + " .s4").addClass("hidden");
			
			/*still need to add image modifications*/
			$("#"+side).data('status', "modified");			
			break;
		case "Exiles":
			$("#"+side + " .s1").css("top", "130px");
			$("#"+side + " .s5").css("top", "130px");
			//$("#"+side + " .s5").css("top", "130px");
			$("#"+side + " .s3").addClass("hidden");
			$("#"+side + " .s4").addClass("hidden");
			add_part("ion_turret",$("#"+side + " .s2"));
			add_part("hull",$("#"+side + " .s5"));
			/*still need to add image modifications*/
			$("#"+side).data('status', "modified");
			break;
		case "Rho Indi":
			$("#"+side + " .dre .part_container").each( function(){
				remove_part($(this));
				//grey out quantity
				$(this).addClass("hidden");
			});
			/*still need to add image modifications*/
			$("#"+side).data('status', "modified");
			break;
		default: //Orion
			add_part("gauss_shield",$("#"+side + " .i1"));
			add_part("gauss_shield",$("#"+side + " .c2"));
			add_part("gauss_shield",$("#"+side + " .d3"));
			add_part("gauss_shield",$("#"+side + " .s4"));
			/*still need to add image modifications*/
			break;
	}
}

function calculate_ship(ship_div){
	
}



function initialize_ship(ship){
	ship.computer = 0;
	ship.initiative = 0;
	ship.shield = 0;
	ship.hull = 0;
	ship.hit_recovery = 0;
	ship.drive = 0;
	ship.power = 0;
	ship.yellow_missle = 0;
	ship.orange_missle = 0;
	ship.red_missle = 0;
	ship.yellow_cannon = 0;
	ship.orange_cannon = 0;
	ship.red_cannon = 0;
	ship.power_consumption = 0;
	ship.note = "None";
	return ship;
}

function remove_part(element){
	element.removeClass(element.data("part"));
  	element.data("part", "");
}
function add_part(name, element){
	remove_part(element);
    element.addClass(name).data("part", name);
}

$(document).ready( function () {
	initialize_board("Terran", "att");
	initialize_board("Terran", "def");
	$(".part_container").dblclick(function() {
  		remove_part($(this));
	});
	$( ".races li" ).on('click', function() {
		var side = $(this).closest(".ships").attr("id");
  		initialize_board($(this).children('a').html(), side);
	});
});

