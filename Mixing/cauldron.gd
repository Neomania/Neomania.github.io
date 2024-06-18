extends Node2D


func _process(delta):
	if (Input.is_action_just_pressed("game_cauldron_cast")):
		var orbs: Array[Node2D] = $StaticBody2D/Area2D.get_overlapping_bodies()\
			.filter(func(node): return node is Orb)
		
		for orb in orbs:
			orb.queue_free()
	

func on_cauldron_entered(body: Node2D):
	pass
