extends Node2D

func get_total_damage():
	var orbs: Array[Node2D] = $StaticBody2D/Area2D.get_overlapping_bodies()\
		.filter(func(node): return node is Orb)
	
	var damageTotal = 0
	for orb in orbs:
		damageTotal += 5
	
	return damageTotal
	
func clear_orbs():
	var orbs: Array[Node2D] = $StaticBody2D/Area2D.get_overlapping_bodies()\
		.filter(func(node): return node is Orb)
		
	for orb in orbs:
		orb.queue_free()

func on_cauldron_entered(_body: Node2D):
	pass
