extends StaticBody2D

var blade_bonuses = {
	"STEEL": {
		"elements": {
			"IRON": 98.5,
			"CARBON": 1.5,
		},
		"effects": {
			"damage": 183,
			"electrical_conductivity": 10, # IACS conductivity; copper has 100
			"thermal_conductivity": 50
		},
		"radius": 1.0,
	},
	"BRONZE": {
		"elements": {
			"COPPER": 88.0,
			"TIN": 12.0,
		},
		"effects": {
			"damage": 75,
			"electrical_conductivity": 11,
			"thermal_conductivity": 74, 
		},
	},
	"COPPER": {
		"elements": {
			"COPPER": 100.0,
		},
		"effects": {
			"damage": 35, # Brinell hardness?
			"electrical_conductivity": 100,
			"thermal_conductivity": 385
		},
	},
	"IRON": {
		"elements": {
			"IRON": 100.0,
		},
		"effects": {
			"damage": 146,
			"electrical_conductivity": 17,
			"thermal_conductivity": 76,
		},
	},
	"LIGHTNING": {
		"elements": {
			"LIGHTNING": 100.0,
		},
		"effects": {
			"damage_lightning": 100,
		}
	}
}

func _process(_dt):
	if (Input.is_action_just_pressed("game_cauldron_cast")):
		calculate_damage()

# Outputs a dictionary of elements to orb percentages, expressed as a real [0, 100] (i.e. human format)
func calculate_composition(orbs):
	var composition = {}
	var orb_count = 0
	for x in orbs:
		if (x is Orb):
			composition[x.typecode] = composition.get(x.typecode, 0) + 1
			orb_count += 1
	
	for element in composition:
		composition[element] = (float(composition[element]) / orb_count) * 100.0
	
	return composition
		
func calculate_bonuses(composition, bonuses):
	var bonus_effects: Dictionary = {}
	var bonus_distances: Dictionary = {}
	
	for bonus_key in bonuses:
		var bonus = bonuses[bonus_key]
		var bonus_elements: Dictionary = bonus["elements"]
		var key_list = bonus_elements.keys()
		for key in composition:
			if not (key_list.has(key)):
				key_list.push_back(key)
		
		# Now key_list is unique
		# Compute distance to this bonus
		var distance_squared = 0
		for element in key_list:
			print("%s, %s: %f, %f" % [bonus_key, element, bonus_elements.get(element, 0.0), composition.get(element, 0.0)])
			distance_squared += (bonus_elements.get(element, 0.0) - composition.get(element, 0.0)) ** 2
		
		var distance = sqrt(distance_squared)
		var sensitivity = bonus.get("radius", 10.0)
		if (distance < sensitivity):
			# nice! apply bonuses
			bonus_distances[bonus_key] = distance
			for bonus_effect in bonus["effects"]:
				bonus_effects[bonus_effect] = bonus_effects.get(bonus_effect, 0.0) + bonus["effects"][bonus_effect]
	
	return {
		"effects": bonus_effects,
		"distances": bonus_distances,
	}
	
func print_dictionary(dict, rtd):
	for key in dict:
		if (dict[key] is Dictionary):
			rtd.add_text("%s:\n" % key)
			rtd.push_indent(1)
			print_dictionary(dict[key], rtd)
			rtd.pop()
		else:
			if (dict[key] is float):
				rtd.add_text("%s: %f\n" % [key, dict[key]])
			
			if (dict[key] is String):
				rtd.add_text("%s: %s\n" % [key, dict[key]])
				
			if (dict[key] is int):
				rtd.add_text("%s: %d\n" % [key, dict[key]])

func calculate_damage():
	# blade
	# find composition
	var blade_orbs = $Blade.get_overlapping_bodies()
	var blade_composition = calculate_composition(blade_orbs)
	
	print(blade_composition)
	
	var blade_results = calculate_bonuses(blade_composition, blade_bonuses)
	var blade_bonus_effects: Dictionary = blade_results["effects"]
	var blade_bonus_distances: Dictionary = blade_results["distances"]
	
	var guard_orbs = $Guard.get_overlapping_bodies()
	var guard_composition = calculate_composition(guard_orbs)
	
	var guard_results = calculate_bonuses(guard_composition, blade_bonuses)
	var guard_bonus_effects: Dictionary = guard_results["effects"]
	
	var damages: Array[DamageBlock] = []
	# Custom damage calculations
	if (blade_bonus_effects.has("damage")):
		var phys_damage := DamageBlock.new(blade_bonus_effects["damage"], "PHYSICAL")
		damages.push_back(phys_damage)
	
	if (guard_bonus_effects.has("damage_lightning")):
		var lightning_damage := DamageBlock.new(guard_bonus_effects["damage_lightning"], "LIGHTNING")
		if (blade_bonus_effects.has("electrical_conductivity")):
			lightning_damage.amount *= blade_bonus_effects["electrical_conductivity"]
		damages.push_back(lightning_damage)
	
	var damage_dictionary = {}
	for damage_block in damages:
		damage_dictionary[damage_block.type] = damage_block.amount
	
	$StatsDisplay.clear()
	
	print_dictionary({
		"Blade": {
			"Composition": blade_composition,
			"Effects": blade_bonus_effects,
		},
		"Guard": {
			"Composition": guard_composition,
			"Effects": guard_bonus_effects,
		},
		"Total": damage_dictionary
	}, $StatsDisplay)
	
	print(blade_bonus_distances)
	print(blade_bonus_effects)
