extends Node2D


var orbs = []

func damage_orbs(damage):
	for orb in orbs:
		if orb is Orb:
			orb.health -= 1
			orb.get_node("./CollisionShape2D/Highlight/UsesLabel").set_text("%d" % orb.health)
			if (orb.health <= 0):
				orb.queue_free()

func calculate_damage():
	var fire = 0
	var water = 0
	var earth = 0
	var lightning = 0
	var damage_blocks: Array[DamageBlock] = []
	for orb in orbs:
		match orb.typecode:
			"FIRE":
				fire += 1
			"WATER":
				water += 1
			"EARTH":
				earth += 1
			"LIGHTNING":
				lightning += 1
		
	
	if (water > fire):
		water -= fire
		fire = 0
	else:
		fire -= water
		water = 0
	
	if (earth > lightning):
		earth -= lightning
		lightning = 0
	else:
		lightning -= earth
		earth = 0
	
	# synergy types
	var bonus = 0
	var flags = {}
	var synergy_types = ["OIL", "SALT"]
	for orb in orbs:
		if orb.typecode in synergy_types:
			flags[orb.typecode] = true
	
	# power types
	var phys = 0
	for orb in orbs:
		match orb.typecode:
			"IRON":
				phys += 30
			"WOOD":
				phys += 15
				if (flags.get("OIL", false)):
					bonus += 15 * fire
			"COPPER":
				phys += 20
				if (flags.get("SALT", false)):
					bonus += 20 * lightning
	
	# damage blocks
	if (phys > 0):
		damage_blocks.push_back(DamageBlock.new(phys, "PHYSICAL"))
	if (water > 0):
		damage_blocks.push_back(DamageBlock.new(water * 10, "WATER"))
	if (fire > 0):
		damage_blocks.push_back(DamageBlock.new(fire * 10, "FIRE"))
	if (earth > 0):
		damage_blocks.push_back(DamageBlock.new(earth * 10, "EARTH"))
	if (lightning > 0):
		damage_blocks.push_back(DamageBlock.new(lightning * 10, "LIGHTNING"))
	if (bonus > 0):
		damage_blocks.push_back(DamageBlock.new(bonus, "BONUS"))
	
	get_tree().call_group("WeaponListener", "update_weapon", damage_blocks)
	
	return damage_blocks

func orb_added(body: Node2D):
	orbs.push_back(body)
	calculate_damage()
	
func orb_removed(body: Node2D):
	orbs.remove_at(orbs.find(body))
	calculate_damage()
