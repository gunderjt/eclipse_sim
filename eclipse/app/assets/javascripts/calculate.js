function calculate(id_tag){
	//Conformal Drive;  Muon Source;  Axion Computer
	//create a ship object
	ship = initialize_ship();
	ship.quantity = $("#"+id_tag+"_s").spinner("value");
	//get all the parts into an array
	parts = $("#"+id_tag).children(".part_container").each(function(){
		//for each part build the ship object
		var part_name = $(this).data("part");
		switch(part_name) {
			//cannons
			case "ion_cannon":
				ship.yellow_cannon += 1;
				ship.power_consumption += 1;
				break;
			case "plasma_cannon":
				ship.orange_cannon +=1;
				ship.power_consumption +=2;
				break;
			case "antimatter_cannon":
				ship.red_cannon += 1;
				ship.power_consumption +=4;
				break;
			case "ion_disruptor":
				ship.yellow_cannon += 1;
				ship.initiative += 3;
				break;
			case "ion_turret":
				ship.yellow_cannon += 2;
				ship.power_consumption +=1;
				break;
			//missles
			case "plasma_missle":								
				ship.orange_missle += 2;
				break;
			case "flux_missle":
				ship.yellow_missle += 2;
				ship.initiative += 3;
				break;
			//sources
			case "nuclear_source":
				ship.power += 3;
				break;
			case "fusion_source":
				ship.power += 6;
				break;			
			case "tachyon_source":
				ship.power += 9;
				break;
			case "hyperion_source":
				ship.power += 11;
				break;
			case "zero_point":
				ship.power += 12;
				break;
			case "muon":
				ship.power += 2;
				ship.initiative += 1;
				break;
			//computers
			case "electron_computer":
				ship.computer += 1;
				break;
			case "positron_computer":
				ship.computer +=2;
				ship.power_consumption += 1;
				ship.initiative += 1;
				break;
			case "gluon_computer":
				ship.computer += 3;
				ship.power_consumption += 2;
				ship.initiative += 2;
				break;
			case "sentient_computer":
				ship.computer += 1;
				ship.hull += 1;
				break;
			case "axion_computer":
				ship.computer += 3;
				break;
			//shields
			case "gauss_shield":
				ship.shield += -1;
				break;
			case "phase_shield":
				ship.shield += -2;
				ship.power_consumption += 1;
				break;
			case "morph_shield":
				ship.shield += -1;
				ship.hit_recovery += 1;
				ship.initiative += 2;
				break;
			case "flux_shield":
				ship.shield += -3;
				ship.power_consumption += 2;
				break;
			//hull
			case "hull":
				ship.hull += 1;
				break;
			case "improved_hull":
				ship.hull += 2;
				break;		
			case "conifold_field":
				ship.hull += 3;
				ship.power_consumption += 2;
				break;
			case "shard_hull":
				ship.hull += 3;
				break;
			case "interceptor_bay":
				ship.hull += 1;
				ship.power_consumption += 2;
				break;
			//drive
			case "nuclear_drive":
				ship.drive += 1;
				ship.power_consumption += 1;
				ship.initiative += 1;
				break;
			case "fusion_drive":
				ship.drive += 2;
				ship.power_consumption += 2;
				ship.initiative += 2;
				break;
			case "tachyon_drive":
				ship.drive += 3;
				ship.power_consumption += 3;
				ship.initiative += 3;
				break;
			case "jump_drive":
				ship.drive += 1;
				ship.power_consumption += 2;				
				break;
			case "conformal_drive":
				ship.drive += 4;
				ship.power_consumption += 2;
				ship.initiative += 2;
				break;
			default:
				break;
		}
	});
	return ship;
}

function initialize_ship(race){
	ship= new Object();
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
	ship.note = null;
	return ship;
}

function create_fleet(side){
	var fleet = new Object();
	var ship_id = ["i", "c", "d", "s"];	
	for(var j= 0; j < ship_id.length; j++){
		fleet[ship_id[j]] = calculate(side+"_"+ship_id[j]);					
		if (ship_id[j] == "i"){
			fleet[ship_id[j]].initiative += 2;	
		}
		else if (ship_id[j] == "c"){
			fleet[ship_id[j]].initiative += 1;	
		}
		else if (ship_id[j] == "s"){
			fleet[ship_id[j]].initiative += 4;	
		}
	}
	return fleet;
}
